// User-level IPC library routines

#include <inc/lib.h>
// Receive a value via IPC and return it.
// If 'pg' is nonnull, then any page sent by the sender will be mapped at
//	that address.
// If 'fromenv' is nonnull, then store the IPC sender's envid in *fromenv.
// If 'perm' is nonnull, then store the IPC sender's page permission in *perm
//	(this is nonzero iff a page was successfully transferred to 'pg').
// If the system call fails, then store 0 in *fromenv and *perm (if
//	they're nonnull) and return the error.
//
// Hint:
//   Use 'env' to discover the value and who sent it.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
	// LAB 4: Your code here.
	//panic("ipc_recv not implemented");
	int r;
	if(pg == NULL){//send a data
	    r = sys_ipc_recv((void *)UTOP);
	}
	else {//send a page
	    r = sys_ipc_recv(pg);
	}
	if(r < 0) {
		panic("send ipc_recv failed\n");
		return r;
	}
	//use env to discover the value and who sent it
	struct Env *env_n = (struct Env *)envs + ENVX(sys_getenvid());
	if(from_env_store != NULL) {
		//if(r < 0) *from_env_store = 0;
		//else 
		*from_env_store = env_n->env_ipc_from;
	}
	if(perm_store != NULL){
		//if(r < 0) *perm_store = 0;
		//else 
		*perm_store = env_n->env_ipc_perm;
	}
	return env_n->env_ipc_value;
	//return 0;
}

// Send 'val' (and 'pg' with 'perm', assuming 'pg' is nonnull) to 'toenv'.
// This function keeps trying until it succeeds.
// It should panic() on any error other than -E_IPC_NOT_RECV.
//
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;// = -1;//the first value
	//while(r < 0){}
	/*while ((r = sys_ipc_try_send (to_env, val, pg != NULL ? pg : (void *) UTOP, perm)) < 0) {
		if(r != -E_IPC_NOT_RECV)
		   panic ("ipc_send: send message error %e", r);
		   sys_yield ();
    }*/
	do{
		if(pg == NULL){
			r = sys_ipc_try_send(to_env, val, (void *)UTOP, perm);
	    }
	    else {
			r = sys_ipc_try_send(to_env, val, pg, perm);
		}
	    if(r < 0 && r != -E_IPC_NOT_RECV) 
	        panic(" %d Msg Rec Error!\n", r);
	    sys_yield();
	}while(r < 0);
}

