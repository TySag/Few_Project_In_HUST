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
          
        //����·��   
        String savePath = getServletContext().getRealPath("/upload");  
        File saveDir = new File(savePath);  
        // ���Ŀ¼�����ڣ��ʹ���Ŀ¼   
        if(!saveDir.exists()){  
            saveDir.mkdir();  
        }  
          
        // �����ļ��ϴ�������   
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        ServletFileUpload sfu = new ServletFileUpload(factory);  
        //���ñ���   
        sfu.setHeaderEncoding("UTF-8");  
        // �����ϴ��ĵ����ļ�������ֽ���Ϊ2M   
        sfu.setFileSizeMax(1024*1024*2);  
        //����������������ֽ���Ϊ10M   
        sfu.setSizeMax(1024*1024*10);  
          
        try{  
            // ���������   
            List<FileItem> itemList = sfu.parseRequest(request);  
            for (FileItem fileItem : itemList) {  
                // ��Ӧ���еĿؼ���name   
                String fieldName = fileItem.getFieldName();  
                System.out.println("�ؼ����ƣ�" + fieldName);  
                // �������ͨ���ؼ�   
                if(fileItem.isFormField()){  
                    String value = fileItem.getString();  
                    //���±���,�������   
                    value = new String(value.getBytes("ISO-8859-1"),"UTF-8");  
                    System.out.println("��ͨ���ݣ�" + fieldName + "=" + value);  
                // �ϴ��ļ�   
                }else{  
                    // ����ļ���С   
                    Long size = fileItem.getSize();  
                    // ����ļ���   
                    String fileName = fileItem.getName();  
                    System.out.println("�ļ�����"+fileName+"\t��С��" + size + "byte");  
                      
                    //���ò������ϴ����ļ���ʽ   
                    if(fileName.endsWith(".exe")){  
                        request.setAttribute("msg", "�������ϴ������ͣ�");  
                    }else{  
                        //���ļ����浽ָ����·��   
                        File file = new File(savePath,fileName);  
                        fileItem.write(file);  
                        request.setAttribute("msg", "�ϴ��ɹ���");  
                    }  
                }  
            }  
        }catch(FileSizeLimitExceededException e){  
            request.setAttribute("msg", "�ļ�̫��");  
        }catch(FileUploadException e){  
            e.printStackTrace();  
        }catch(Exception e){  
            e.printStackTrace();  
        }  
        //�ϴ���Ϻ�  ת������ҳ   
       // request.getRequestDispatcher("/index.jsp").forward(request, response); 
	    alert("�ϴ����~~~~");
    }  
  
}  
