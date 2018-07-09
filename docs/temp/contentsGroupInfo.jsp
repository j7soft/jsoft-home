<%@ page contentType="text/html; charset=euc-kr" errorPage="/common/errorPage.jsp"%>
<%@ page import="java.util.*, com.hts.framework.util.*" %>
<%@ page import="com.hts.cms.action.contents.*, com.hts.cms.ebiz.contents.*" %>
<%@ page import="java.util.Locale, com.hts.cms.ebiz.util.Resource" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<% Locale locale = Resource.setResponseLocale(response, request); %>
<%
	String strMsgMeta = Resource.getValue(locale, "message.metacustomfield.is");
	ContentsGroupForm contentsGroupForm = (ContentsGroupForm)request.getAttribute("contentsGroupForm");
	int contsGroupId = contentsGroupForm.getContsGroupId();
	int authorityLevel = contentsGroupForm.getAuthorityLevel();
%>
<html:html locale="true">
<head>
	<title><%=Resource.getValue(locale, "cms.title")%></title>
	<link rel="stylesheet" type="text/css" href="../css/human-t.css">
	<script src="../js/common.js"></script>
	<script language='Javascript'>
		function doRegister(){
			var formObj = document.contentsGroupForm;
			formObj.command.value = "register";
			formObj.submit();
		}

		function openContsStatisticsWindow(){
			openWindows('../contents/contentsgroup.do?command=conts_statistics', 'report', 800, 600);
		}

        function openDeptDongContsStat() {
            openWindows('../2006/contentsStatList.jsp', 'report', 350, 650);
        }
<%
	if(contsGroupId > 0){
%>
		function doModify(){
			var formObj = document.contentsGroupForm;
			formObj.command.value = "modify";
			formObj.submit();
		}
		function doRemove(existChild){
			if(existChild){
				alert("<%=Resource.getValue(locale, "message.contents.classify.delete.error")%>");
				return;
			} else {
				var confirmMessage = "<%=Resource.getValue(locale, "message.confirm.contents.classify.deletion")%>";
				if(confirm(confirmMessage)){
					var formObj = document.contentsGroupForm;
					formObj.command.value = "remove";
					formObj.submit();
				}
			}
		}

		function openCopyContsGroupWindow() {
			var winl = (screen.width - 550) / 2;
			var wint = (screen.height - 400) / 2;
			var formObj = document.contentsGroupForm;
			//var sFeatures="dialogHeight: " + iHeight + "px; dialogWidth: " + iWidth + "px; dialogTop: " + iTop + "px; dialogLeft: " + iLeft + "px; edge: " + sEdge + "; center: " + bCenter + "; help: " + bHelp + "; resizable: " + bResize + "; status: " + bStatus + ";";
			openWindows('../contents/contentsgroup.do?command=copy&contsGroupId=' + formObj.contsGroupId.value + '&treeType=C', 'copyContsGroup', 550, 400);
			//window.showModalDialog("/contents/contentsgroup.do?command=copy&contsGroupId=" + formObj.contsGroupId.value,"copyContsGroup","dialogHeight: 400px; dialogWidth: 550px; dialogTop: " + wint + "; dialogLeft: " + winl + "; edge: Raised; center: Yes; help: No; resizable: No; status: No;");
		}

		function doCopy(contsGroupIds, copyCustomFieldFlag, copySubContsGroupFlag){
			var formObj = document.contentsGroupForm;
			formObj.idsStr.value = contsGroupIds;
			formObj.copyCustomFieldFlag.value = copyCustomFieldFlag;
			formObj.copySubContsGroupFlag.value = copySubContsGroupFlag;
			formObj.command.value = "do_copy";
			formObj.submit();
		}

		function openMoveContsGroupWindow(){
			var formObj = document.contentsGroupForm;
			openWindows('../contents/contentsgroup.do?command=move&contsGroupId=' + formObj.contsGroupId.value + '&treeType=M', 'moveContsGroup', 550, 400);
		}
		function doMove(selectedNewParentContsGroupId){
			var formObj = document.contentsGroupForm;
			formObj.newParentContsGroupId.value = selectedNewParentContsGroupId;
		//	alert("newParentContsGroupId=" + formObj.newParentContsGroupId.value);
			formObj.command.value = "do_move";
			formObj.submit();
		}
<%
	}
%>
		function doOrder(){
			var formObj = document.contentsGroupForm;
			formObj.command.value = "order";
			formObj.submit();
		}
		</script>
</head>
<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<html:form action="/contents/contentsgroup">
<html:hidden property="command" value="view"/>
<html:hidden property="contsGroupId"/>
<%
	if(contsGroupId == 0){
%>
<img src="../images/1pixel.gif" width="1" height="20" alt="" border="0"><br>
<table border="0" cellpadding="0" cellspacing="0" width="660">
<tr>
  <td class=ti_m2><img src="../images/title_dot02.gif" width="6" height="11" alt="" border="0" hspace="5" align="top"><strong><%=Resource.getValue(locale, "contents.manage.presentPosition")%></strong></td>
<%
	if(contentsGroupForm.getTotalContsGroupNum()>0){
%>
  <td align="right" width="325">
    <table width="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td align="right">
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn3_left.gif" width="10" height="22" alt="" border="0"></td>
          <td width="150" background="../images/btn3_middle.gif"><a href="javascript:openContsStatisticsWindow();" class="btn"><%=Resource.getValue(locale, "contents.classify.statistics.info")%></a></td>
          <td><img src="../images/btn3_right.gif" width="10" height="22" alt="" border="0"></td>
        </tr>
        </table>
      </td>
      <td width="5"></td>
      <td align="right">
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn3_left.gif" width="10" height="22" alt="" border="0"></td>
          <td width="170" background="../images/btn3_middle.gif"><a href="javascript:openDeptDongContsStat();" class="btn">부서/동별 콘텐츠 입력실적</a></td>
          <td><img src="../images/btn3_right.gif" width="10" height="22" alt="" border="0"></td>
        </tr>
        </table>
      </td>
    </tr>
    </table>
  </td>
  <td width="5"></td>
<%
	}
%>
</tr>
</table>
<img src="../images/1pixel.gif" width="1" height="5" alt="" border="0"><br>
<table cellspacing="0" cellpadding="0" border="0" width="660" class="box_out">
	<tr>
		<td><img src="../images/1pixel.gif" width="1" height="5" alt="" border="0"></td>
	</tr>
	<tr>
		<td align="center">
			<table cellspacing="1" cellpadding="2" border="0" width="650" class="box_in2">
			<tr>
			    <td class=info2 width="130"><%=Resource.getValue(locale, "register.contents.classify")%></td>
			    <td bgcolor="ffffff"><bean:write name="contentsGroupForm" property="totalContsGroupNum" /></td>
			</tr>
			<tr>
			    <td class=info2><%=Resource.getValue(locale, "register.contents")%></td>
			    <td bgcolor="ffffff"><bean:write name="contentsGroupForm" property="totalContentsNum"/></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><img src="../images/1pixel.gif" width="1" height="5" alt="" border="0"></td>
	</tr>
</table>
<img src="../images/1pixel.gif" width="1" height="13" alt="" border="0"><br>
<%
		if(authorityLevel > 1){
%>
<table border="0" cellspacing="0" cellpadding="0" width=660>
<tr>
  <td align="left">
    <table border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:doRegister();" class="btn"><%=Resource.getValue(locale, "theHighest.cont.class.register")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
<%
			if(contentsGroupForm.getSubContentsGroupNum() > 1) {
%>
      <td><img src="../images/1pixel.gif" width="8" height="1" alt="" border="0"></td>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:doOrder();" class="btn"><%=Resource.getValue(locale, "sub.contents.classify.order.control")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
<%		
			}	
%>
    </tr>
    </table>
  </td>
</tr>
</table>
<%
		}
	} else {	// if not root element,
%>
<html:hidden property="idsStr"/>
<html:hidden property="newParentContsGroupId"/>
<html:hidden property="copyCustomFieldFlag"/>
<html:hidden property="copySubContsGroupFlag"/>
<table border="0" cellpadding="0" cellspacing="0" width="680" bgcolor="F2F2F2">
	<tr>
		<td width=22 valign="middle"><img src="../images/navigation_arrow.gif" width="8" height="10" alt="" border="0" hspace="7"></td>
		<td><bean:write name="contentsGroupForm" property="locPath"/></td>
	</tr>
</table>
<img src="../images/1pixel.gif" width="1" height="20" alt="" border="0"><br>
<table border="0" cellpadding="0" cellspacing="0" width="660">
	<tr>
		<td class=ti_m2><img src="../images/title_dot02.gif" width="6" height="11" alt="" border="0" hspace="5" align="top"><strong><%=Resource.getValue(locale, "contents.classify.info")%></strong></td>
	</tr>
</table>
<img src="../images/1pixel.gif" width="1" height="10" alt="" border="0"><br>
<table cellspacing="0" cellpadding="0" border="0" width="660" class="box_out">
	<tr>
		<td><img src="../images/1pixel.gif" width="1" height="5" alt="" border="0"></td>
	</tr>
	<tr>
		<td align="center"><table cellspacing="1" cellpadding="2" border="0" width="650" class="box_in2">
			<tr>
			    <td class=info2 width="130"><%=Resource.getValue(locale, "id")%></td>
			    <td bgcolor="ffffff"><bean:write name="contentsGroupForm" property="contsGroupId"/></td>
			</tr>
			<tr>
			    <td class=info2><%=Resource.getValue(locale, "name")%></td>
			    <td bgcolor="ffffff"><bean:write name="contentsGroupForm" property="contsGroupName"/></td>
			</tr>
			<tr>
			    <td class=info2><%=Resource.getValue(locale, "explanation")%></td>
			    <td bgcolor="ffffff"><bean:write name="contentsGroupForm" property="contsGroupExp"/></td>
			</tr>
		</table></td>
	</tr>
	<tr>
		<td><img src="../images/1pixel.gif" width="1" height="5" alt="" border="0"></td>
	</tr>
</table>
<img src="../images/1pixel.gif" width="1" height="13" alt="" border="0"><br>
<%
		if(authorityLevel > 1){
%>
<table border="0" cellspacing="0" cellpadding="0" width=660>
<tr>
  <td align="left">
    <table border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:doRegister();" class="btn"><%=Resource.getValue(locale, "sub.contents.classify.info.registration")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
      <td><img src="../images/1pixel.gif" width="8" height="1" alt="" border="0"></td>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:doModify();" class="btn"><%=Resource.getValue(locale, "modification")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
      <td><img src="../images/1pixel.gif" width="8" height="1" alt="" border="0"></td>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:doRemove(<%= contentsGroupForm.getSubContentsGroupNum() == 0 ? "false" : "true" %>);" class="btn"><%=Resource.getValue(locale, "deletion")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
      <td><img src="../images/1pixel.gif" width="8" height="1" alt="" border="0"></td>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:openCopyContsGroupWindow();" class="btn"><%=Resource.getValue(locale, "copy")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
      <td><img src="../images/1pixel.gif" width="8" height="1" alt="" border="0"></td>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:openMoveContsGroupWindow();" class="btn"><%=Resource.getValue(locale, "movement")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
<%			if (contentsGroupForm.getSubContentsGroupNum() > 1) {	%>
      <td><img src="../images/1pixel.gif" width="8" height="1" alt="" border="0"></td>
      <td>
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn_left.gif" width="20" height="23" alt="" border="0"></td>
          <td background="../images/btn_bg.gif"><a href="javascript:doOrder();" class="btn"><%=Resource.getValue(locale, "sub.contents.classify.order.control")%></a></td>
          <td><img src="../images/btn_right.gif" width="13" height="23" alt="" border="0"></td>
        </tr>
        </table>
      </td>
<%			}	%>
    </tr>
    </table>
  </td>
</tr>
</table>
<%
		}
%>
<br><br>
<table border="0" cellpadding="0" cellspacing="0" width="660">
	<tr>
		<td class=ti_m2><img src="../images/title_dot02.gif" width="6" height="11" alt="" border="0" hspace="5" align="top"><strong><%=Resource.getValue(locale, "setting.customfield.list")%></strong></td>
	</tr>
</table>
<img src="../images/1pixel.gif" width="1" height="10" alt="" border="0"><br>
<table cellspacing="0" cellpadding="0" border="0" width=660>
	<tr>
	    <td colspan="6" bgcolor="BDBCBC"><img src="../images/1pixel.gif" width="1" height="1" border="0"></td>
	</tr>
	<tr>
	    <td height=25 class=t_ti2 width="40"><%=Resource.getValue(locale, "no")%></td>
	    <td class=t_ti2 width="120"><%=Resource.getValue(locale, "label.name")%></td>
		<td class=t_ti2 width="120"><%=Resource.getValue(locale, "field.name")%></td>
	    <td class=t_ti2 width="80"><%=Resource.getValue(locale, "data.type")%></td>
		<td class=t_ti2 width="80"><%=Resource.getValue(locale, "select.item")%></td>
		<td class=t_ti2 width="220"><%=Resource.getValue(locale, "explanation")%></td>
	</tr>
	<tr>
	    <td colspan="6" bgcolor="BDBCBC"><img src="../images/1pixel.gif" width="1" height="1" border="0"></td>
	</tr>
	<tr>
	    <td colspan="6"><img src="../images/1pixel.gif" width="1" height="5" border="0"></td>
	</tr>
<%
		List cgCustomFieldVOList = contentsGroupForm.getVoList();
		int dataNum = cgCustomFieldVOList.size();
		int seqNum = 0;	// 출력 일련번호
		if(dataNum > 0){
			ContsGroupCustomFieldVO contsGroupCustomFieldVO = null;
			String classStr1 = "t_center";
			String classStr2 = "t_padding";
			boolean bMetaField = false;
	
			for(int i=0; i<dataNum; i++) {
				contsGroupCustomFieldVO = (ContsGroupCustomFieldVO)cgCustomFieldVOList.get(i);
				bMetaField = com.hts.cms.ebiz.util.ServerConfig.isMetaField(contsGroupCustomFieldVO.getCustomFieldId());
				if (bMetaField) {
					classStr1 = "t_bg_meta_center";
					classStr2 = "t_bg_meta";
				} else {
					classStr1 = ((i%2 == 0) ? "t_center" : "t_bg_center");
					classStr2 = ((i%2 == 0) ? "t_padding" : "t_bg");
					seqNum++;
				}
				if (i!=0) {
%>
	<tr>
	    <td colspan="6"><img src="../images/line_660.gif" width="658" height="1" alt="" border="0" vspace="3"></td>
	</tr>
<%
				}
%>
	<tr>
		<td class="<%=classStr1%>"><%= bMetaField ? "<font style='font-size:7pt;color:steelblue;font-family:tahoma;' title='" + StringUtil.getCleanString(contsGroupCustomFieldVO.getLabel()) + strMsgMeta + "'>Meta</font>" : ("" + seqNum) %></td>
		<td class="<%=classStr2%>"><%= StringUtil.getCleanString(contsGroupCustomFieldVO.getLabel()) %></td>
		<td class="<%=classStr2%>"><%= StringUtil.getCleanString(contsGroupCustomFieldVO.getCustomFieldName()) %></td>
		<td class="<%=classStr1%>"><%= StringUtil.getCleanString(Resource.getValue(locale, "customfield.type." + contsGroupCustomFieldVO.getDataType())) %></td>
		<td class="<%=classStr1%>"><%= StringUtil.getCleanString(contsGroupCustomFieldVO.getSelectItemSetFlag()) %></td>
		<td class="<%=classStr2%>"><%= StringUtil.getCleanString(contsGroupCustomFieldVO.getExplain()) %></td>
    </tr>
<%
			}	// end of for
		} else {	// if data none,
%>
	<tr>
		<td colspan="6" align="center"><%=Resource.getValue(locale, "nothing.data")%></td>
	</tr>

<%
		}
%>
	<tr>
	    <td colspan="6"><img src="../images/1pixel.gif" width="1" height="5" border="0"></td>
	</tr>
	<tr>
	    <td colspan="6" bgcolor="BDBCBC"><img src="../images/1pixel.gif" width="1" height="1" border="0"></td>
	</tr>
</table>
<%
	}	// end of } else {	// if not root element
%>
</html:form>
</body>
</html:html>
