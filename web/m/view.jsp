<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/ok-taglib.tld" prefix="okbbs" %>
<%@ page import="java.util.*,kr.pe.okjsp.util.CommonUtil,kr.pe.okjsp.*"
	pageEncoding="euc-kr" %>
<jsp:useBean id="member" class="kr.pe.okjsp.member.Member" scope="session"/>
<jsp:useBean id="one"  class="kr.pe.okjsp.Article" scope="request"/>
<jsp:useBean id="list" class="kr.pe.okjsp.ListHandler" />

	<div id="entry" class="panel" title="" style="0%" seleted="true">
		<fieldset>
			<div class="row" style="text-align:left; padding:0 10px 0 10px;">
				<p>
	<%
	    if (!"".equals(one.getId())) {
	%>
				<img src="http://www.okjsp.pe.kr/profile/<%= one.getId() %>.jpg" alt="<%= one.getId() %>" style="float:left; width:35px; margin-right:10px;" onerror="this.src='/images/spacer.gif'">
	<%
	 	}
	%>
				<strong><%= CommonUtil.showHtml(one.getSubject()) %></strong><br/>
				<span class="b"><c:out value="${one.when}" /> by <c:out value="${one.writer}"/></span>				
				</p>
			</div>
			<div class="row" style="text-align:left; padding:0 5px 0 5px;">
				<p>
				<%=one.getContentView()%>
				</p>				
			</div>
		</fieldset>
	<%
	ArrayList<MemoBean> memoList = new MemoHandler().getList(one.getSeq());
	Iterator memo = null;
		if (memoList != null) {
			memo = memoList.iterator();
			while (memo.hasNext()) {
				MemoBean mb = (MemoBean)memo.next();
	%>
		<fieldset>
			<div class="row" style="text-align:left; padding:0 5px 0 5px;">
				<p>
					<img src="http://www.okjsp.pe.kr/profile/<%= mb.getId() %>.jpg" alt="<%= mb.getId() %>" style="float:left; width:35px; margin-right:10px;" onerror="this.src='/images/spacer.gif'">
					<span class="b"><%= mb.getWriter() %> | <%= mb.getWhen("yyyy-MM-dd HH:mm:ss")%>
				</p>				
			</div>
			<div class="row" style="text-align:left; padding:0 5px 0 5px;">
				<p>
					<okbbs:link>
					<okbbs:html br="true"><%= mb.getBcomment() %></okbbs:html>
					</okbbs:link>
				</p>				
			</div>
		</fieldset>
	<%
			} // end while
		}
	%>							

	<%	if (member.getSid() != 0) { %>
		<fieldset>
			<div class="row" style="text-align:left; padding:0 5px 0 5px;">	
				<!-- css 적용 법을 몰라서, 하드코딩 하였습니다.. Sorry.. by jongkwang -->
				<form 
					name="f0" 
					method="POST" 
					onSubmit="return chk_memo(this)" 
					action="/memowritemobile"
					style=" box-sizing: border-box;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;padding: 10px;">
			        <fieldset style="position: relative;margin: 0 0 20px 0;padding: 0;background: #FFFFFF;-webkit-border-radius: 10px;-moz-border-radius: 10px;border: 1px solid #999999;text-align: right;font-size: 16px;">
			            <div style="position: relative;min-height: 42px;border-bottom: 1px solid #999999;-webkit-border-radius: 0;text-align: center">
	                		<textarea name="bcomment" id="bcomment" style="font-size:16px;width:90%;height:200px;border: none;"></textarea>
	            		</div>
			            <div style="position: relative;min-height: 42px;-webkit-border-radius: 0;text-align: center;vertical-align: middle;padding:0 5px 0 5px;">
	                		<label>ID : </label>
	                		<input type="text" 		class="memoid" name="memoid" value="<%= member.getId() %>" style="padding: 0;width:100px;text-align:left;border:none;">
	                		<label>PW : </label>
	                		<input type="password" 	class="memopass" name="memopass" maxlength="50" value="" style="padding: 0;width:100px;text-align:left;border:none;">
	            		</div>
	        		</fieldset>
			        <a class="whiteButton" type="submit" href="#" target="_self">댓글 전송</a><br/>
			        
				    <input type="hidden" name="pact" value="MEMO">
				    <input type="hidden" name="seq" value="<%= one.getSeq() %>">
				    <input type="hidden" name="pg" value="<%= list.getPg() %>">
				    <input type="hidden" name="keyfield" value="<%=  CommonUtil.nchk(request.getParameter("keyfield"),"content")  %>">
				    <input type="hidden" name="keyword" value="<%=  CommonUtil.nchk(request.getParameter("keyword"))  %>">
				    <input type="hidden" name="bbs" value="<%= one.getBbs() %>">
				    <input type="hidden" name="viewstamp" value="<%= System.currentTimeMillis() %>">
				    <input type="hidden" name="doublecheck" class="memodc" value="okjsp">
				    <input type="hidden" name="sid" value="<%= member.getSid() %>">
				    <input type="hidden" name="okid" value="<%= member.getId() %>">
				    <input type="hidden" name="writer" value="<%= member.getId() %>">
			    </form>
			</div>		
		</fieldset>					    
	<% 	} else { %>
	    <a class="whiteButton" href="#loginForm" onclick="window.scrollTo(0,0);">댓글 달기</a>
	<% 	} %>
	</div>

	<!-- ################ 삭제 폼_시작 ##################### -->
	<form id="deleteForm" class="dialog" action="/deletemobile" method="post" target="_self">
		<input type="hidden" name="seq" value="<%= one.getSeq() %>">
		<input type="hidden" name="bbs" value="<%= one.getBbs() %>">
	    <fieldset>
	        <h1>삭제암호입력</h1>
	        <!-- 버튼에  href="#"를 넣어주지 않으면 동작하지 않는다 -->
	        <a class="button leftButton" type="cancel" href="#">Cancel</a>
	        <a class="button blueButton" type="submit" href="#">Delete</a>
	        <label>암호:</label>
	        <input id="password" type="password" name="password" maxlength="15"/>
	    </fieldset>
	</form>
	<!-- ################ 삭제 폼_끝 ##################### -->



	<%-- 
	<ul id="detailView" >
		<li>
			<!-- ###########제목################################# -->
			<h2><%= CommonUtil.showHtml(one.getSubject()) %></h2>
			<!-- ###########이미지및사용자id_시작################################# -->
			<%
			    if (!"".equals(one.getId())) {
			%><img src="http://www.okjsp.pe.kr/profile/<%= one.getId() %>.jpg"
			        	alt="<%= one.getId() %>"
			        	style="width:77px"
			        	onerror="this.src='/images/spacer.gif'"><%
			    }
			%>
			<c:out value="${one.writer}"/> / <c:out value="${one.when}" />
			<!-- ###########이미지및사용자id_끝################################# -->
			<!-- ###########삭제버튼_작성자와로그인아이디가동일할때만 생성################################# -->
			<%
			if(one.getId().equals(member.getId())){
			%>	
				<a class="button" href="#deleteForm">delete</a>
			<%	
			}
			%>
		</li>
		<br/>
		<li>
			<!-- ###########내용################################# -->
			<%=  one.getContentView()  %>
		</li>
		<br/>
		<!-- ################  댓글 ##################### -->
		<%
		  ArrayList<MemoBean> memoList = new MemoHandler().getList(one.getSeq());
		  Iterator memo = null;
		  if (memoList != null) {
		    memo = memoList.iterator();
		    while (memo.hasNext()) {
		      MemoBean mb = (MemoBean)memo.next();
		%>
		<li class="group" style="text-overflow:ellipsis;overflow:hidden;width=250px"><!-- 글자가 길어 2줄로 표시되는 것 방지. 마지막 글자를 '...'처리한다. -->
			<nobr>
				<%= mb.getWriter() %> | <%= mb.getWhen("yyyy-MM-dd HH:mm:ss")%>
			</nobr>
		</li>
		<li>
		<okbbs:link>
		<okbbs:html br="true"><%= mb.getBcomment() %></okbbs:html>
		</okbbs:link>
		
		</li>
		<%
		    } // end while
		  }
		%>
		<li align="center">
<% if (member.getSid() != 0) { %>
			<!-- css 적용 법을 몰라서, 하드코딩 하였습니다.. Sorry.. by jongkwang -->
			<form 
				name="f0" 
				method="POST" 
				onSubmit="return chk_memo(this)" 
				action="/memowritemobile"
				style=" box-sizing: border-box;-moz-box-sizing: border-box;-webkit-box-sizing: border-box;padding: 10px;background: #c8c8c8 url(/m/iui/pinstripes.png);">
		        <fieldset style="position: relative;margin: 0 0 20px 0;padding: 0;background: #FFFFFF;-webkit-border-radius: 10px;-moz-border-radius: 10px;border: 1px solid #999999;text-align: right;font-size: 16px;">
		            <div style="position: relative;min-height: 42px;border-bottom: 1px solid #999999;-webkit-border-radius: 0;text-align: center">
                		<textarea name="bcomment" id="bcomment" style="border: none;font-size:20px;font-family:Arial;width:95%"></textarea>
            		</div>
		            <div style="position: relative;min-height: 42px;border-bottom: 1px solid #999999;-webkit-border-radius: 0;text-align: center;vertical-align: middle;">
                		<label>ID : </label>
                		<input type="text" 		class="memoid" name="memoid" value="<%= member.getId() %>" style="width:100px">
                		<label>PW : </label>
                		<input type="password" 	class="memopass" name="memopass" maxlength="50" value="" style="width:100px">
            		</div>
        		</fieldset>
		        <a class="whiteButton" type="submit" href="#" target="_self">댓글전송</a><br/>
		        
			    <input type="hidden" name="pact" value="MEMO">
			    <input type="hidden" name="seq" value="<%= one.getSeq() %>">
			    <input type="hidden" name="pg" value="<%= list.getPg() %>">
			    <input type="hidden" name="keyfield" value="<%=  CommonUtil.nchk(request.getParameter("keyfield"),"content")  %>">
			    <input type="hidden" name="keyword" value="<%=  CommonUtil.nchk(request.getParameter("keyword"))  %>">
			    <input type="hidden" name="bbs" value="<%= one.getBbs() %>">
			    <input type="hidden" name="viewstamp" value="<%= System.currentTimeMillis() %>">
			    <input type="hidden" name="doublecheck" class="memodc" value="okjsp">
			    <input type="hidden" name="sid" value="<%= member.getSid() %>">
			    <input type="hidden" name="okid" value="<%= member.getId() %>">
			    <input type="hidden" name="writer" value="<%= member.getId() %>">
		    </form>
<% } else { %>
			<font color="blue">※ 댓글을 남기시려면 Login 하세요</font>
<% } %>
		</li>
	</ul>
	
	<!-- ################ 삭제 폼_시작 ##################### -->
	<form id="deleteForm" class="dialog" action="/deletemobile" method="post" target="_self">
		<input type="hidden" name="seq" value="<%= one.getSeq() %>">
		<input type="hidden" name="bbs" value="<%= one.getBbs() %>">
	    <fieldset>
	        <h1>삭제암호입력</h1>
	        <!-- 버튼에  href="#"를 넣어주지 않으면 동작하지 않는다 -->
	        <a class="button leftButton" type="cancel" href="#">Cancel</a>
	        <a class="button blueButton" type="submit" href="#">Delete</a>
	        <label>암호:</label>
	        <input id="password" type="password" name="password" maxlength="15"/>
	    </fieldset>
	</form>
	<!-- ################ 삭제 폼_끝 ##################### -->
--%>