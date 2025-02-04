package com.accp.fileupload.servlet;  
  
import java.io.File;  
import java.io.IOException;  
import java.util.List;  
  
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServlet;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  
  
import org.apache.commons.fileupload.FileItem;  
import org.apache.commons.fileupload.FileUploadException;  
import org.apache.commons.fileupload.FileUploadBase.FileSizeLimitExceededException;  
import org.apache.commons.fileupload.disk.DiskFileItemFactory;  
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class FileuploadServlet extends HttpServlet{ 
    private static final long serialVersionUID = 2827297299439162553L;  
  
    public void doGet(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {   
        doPost(request, response); 
		}
	 public void doPost(HttpServletRequest request, HttpServletResponse response)  
            throws ServletException, IOException {  
        request.setCharacterEncoding("UTF-8");  
        response.setContentType("text/html; charset=UTF-8");  
          
        //保存路径   
        String savePath = getServletContext().getRealPath("/upload");  
        File saveDir = new File(savePath);  
        // 如果目录不存在，就创建目录   
        if(!saveDir.exists()){  
            saveDir.mkdir();  
        }  
          
        // 创建文件上传核心类   
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        ServletFileUpload sfu = new ServletFileUpload(factory);  
        //设置编码   
        sfu.setHeaderEncoding("UTF-8");  
        // 设置上传的单个文件的最大字节数为2M   
        sfu.setFileSizeMax(1024*1024*2);  
        //设置整个表单的最大字节数为10M   
        sfu.setSizeMax(1024*1024*10);  
          
        try{  
            // 处理表单请求   
            List<FileItem> itemList = sfu.parseRequest(request);  
            for (FileItem fileItem : itemList) {  
                // 对应表单中的控件的name   
                String fieldName = fileItem.getFieldName();  
                System.out.println("控件名称：" + fieldName);  
                // 如果是普通表单控件   
                if(fileItem.isFormField()){  
                    String value = fileItem.getString();  
                    //重新编码,解决乱码   
                    value = new String(value.getBytes("ISO-8859-1"),"UTF-8");  
                    System.out.println("普通内容：" + fieldName + "=" + value);  
                // 上传文件   
                }else{  
                    // 获得文件大小   
                    Long size = fileItem.getSize();  
                    // 获得文件名   
                    String fileName = fileItem.getName();  
                    System.out.println("文件名："+fileName+"\t大小：" + size + "byte");  
                      
                    //设置不允许上传的文件格式   
                    if(fileName.endsWith(".exe")){  
                        request.setAttribute("msg", "不允许上传的类型！");  
                    }else{  
                        //将文件保存到指定的路径   
                        File file = new File(savePath,fileName);  
                        fileItem.write(file);  
                        request.setAttribute("msg", "上传成功！");  
                    }  
                }  
            }  
        }catch(FileSizeLimitExceededException e){  
            request.setAttribute("msg", "文件太大");  
        }catch(FileUploadException e){  
            e.printStackTrace();  
        }catch(Exception e){  
            e.printStackTrace();  
        }  
        //上传完毕后  转发到首页   
       // request.getRequestDispatcher("/index.jsp").forward(request, response); 
	    alert("上传完毕~~~~");
    }  
  
}  
