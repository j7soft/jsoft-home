<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="com.hts.framework.db.*, com.hts.cms.ebiz.util.*, java.sql.*, javax.sql.*, com.hts.framework.util.*" %>
<%@ page import="java.util.Locale, com.hts.cms.ebiz.util.Resource" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<% Locale locale = Resource.setResponseLocale(response, request); %>
<%
    String fromDate = StringUtil.getCleanString(request.getParameter("fromDate"), DateTime.getDateString("yyyyMM")+"01");
	String toDate = StringUtil.getCleanString(request.getParameter("toDate"), DateTime.getDateString("yyyyMMdd"));
%>
<html:html locale="true">
<head>
    <title>부서/동별 콘텐츠 작업 통계정보</title>
	<link rel="stylesheet" type="text/css" href="../css/human-t.css">
    <script language="javascript" src="../js/common.js"></script>
    <script language="javascript">
        function doSearch() {
            var formObj = document.forms["frmStat"];
            formObj.submit();
        }

        function downExcelFile(){
            var formObj = document.forms["frmStat"];
            download.location='./contentsStatExcel.jsp?fromDate=' + formObj.fromDate.value + '&toDate=' + formObj.toDate.value;
        }
    </script>
</head>
<body topmargin="0" leftmargin="0" marginheight="0" marginwidth="0">
<form name="frmStat" method="get" action="./contentsStatList.jsp">
<table cellspacing="0" cellpadding="0" border="0" width="350" height="100%">
<tr>
  <td colspan="2" class="popup_blue" height="8"></td>
</tr>
<tr>
  <td class="popup_blue" height="18" width="300">부서/동별 콘텐츠 작업 통계정보&nbsp;<a href="javascript:downExcelFile()" title="상세내역 다운로드"><img src="../images/icon_excel.gif" border="0" align="absmiddle"></a></td>
  <td class="popup_blue" align="right"><img src="../images/popup_logo.gif" width="75" height="15" alt="" border="0"><img src="../images/1pixel.gif" width="10" height="1" alt="" border="0"></td>
</tr>
<tr>
  <td colspan="2" class="popup_line" height="1"></td>
</tr>
<tr>
  <td colspan="2" class="popup_gray" height="5"></td>
</tr>
<tr>
  <td colspan="2" height="5"></td>
</tr>
<tr>
<tr>
  <td colspan="2"><table width="100%" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td width="75%" style="padding-left:5px;">
        기간 :
        <input type="text" name="fromDate" maxlength="8" size="8" value="<%=fromDate%>" readonly="readonly">&nbsp;<img src="../images/ico_calendar.gif" onClick="javascript:showCal('fromDate', '');" style="cursor:hand;" width="25" height="19" alt="" border="0" align="absmiddle"> ~
        <input type="text" name="toDate" maxlength="8" size="8" value="<%=toDate%>" readonly="readonly">&nbsp;<img src="../images/ico_calendar.gif" onClick="javascript:showCal('toDate', '');" style="cursor:hand;" width="25" height="19" alt="" border="0" align="absmiddle">
      </td>
      <td width="25%" bgcolor="#ffffff">
        <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><img src="../images/btn3_left.gif" width="10" height="22" alt="" border="0"></td>
          <td background="../images/btn3_middle.gif"><a href="javascript:doSearch();">검색</a></td>
          <td><img src="../images/btn3_right.gif" width="10" height="22" alt="" border="0"></td>
        </tr>
        </table>
      </td>
	</tr>
	</table>

  </td>
</tr>
<tr>
  <td colspan="2" valign="top" height="550">
    <div style='left:0px; height:100%; padding:5px; overflow:auto;'>
      <table cellspacing="1" cellpadding="2" border="0" width="320" class="box_in2" align="center">
      <tr>
        <td class="info2">부서/동 명</td>
        <td class="info2">콘텐츠 작업 건수</td>
      </tr>
<%!
    final static String DB_POOL_NAME = ServerConfig.getDBName();

    final static String[] deptIDs = {
        "3130065","3130067","3130095","3130068","3130069",
        "3130107","3130072","3130073","3130074","3130075",
        "3130078","3130098","3130099","3130100","3130083",
        "3130101","3130085","3130094","3130102","3130091",
        "3130092","3130089","3130104","3130105","3130106","3130036",
    };

    final static String[] deptNames = {
        "감사담당관","총무과","주민자치과","문화체육과","민원봉사과",
        "여권과","기획예산과","재무과","세무1과","세무2과",
        "사회복지과","가정복지과","지역경제과","청소환경과","주택과",
        "도시관리과","건축과","지적과","공원녹지과","교통행정과",
        "교통지도과","토목과","치수과","보건위생과","지역보건과","의약과",
    };

    final static String[] dongIDs = {
        "3130039","3130040","3130041","3130042","3130043",
        "3130044","3130045","3130046","3130047","3130048",
        "3130049","3130050","3130051","3130052","3130053",
        "3130054","3130055","3130056","3130057","3130058",
        "3130059","3130060","3130061","3130062",
    };

    final static String[] dongNames = {
        "아현제1동","아현제2동","아현제3동","공덕제1동","공덕제2동",
        "신공덕동","도화제1동","도화제2동","용강동","대흥동",
        "염리동","노고산동","신수동","창전동","상수동",
        "서교동","동교동","합정동","망원제1동","망원제2동",
        "연남동","성산제1동","성산제2동","상암동",
    };
%>
<%
    DBManager dbMgr = null;
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    String queryForDepart = "";
    String queryForDong = "";

    String strDateCondition =
        "(workdate BETWEEN TO_DATE('" + fromDate + "', 'yyyyMMdd') AND TO_DATE('" + toDate + "', 'yyyyMMdd')+0.99999) AND \r\n";

    for (int i = 0; i < deptIDs.length; i++) {
        if (i > 0) {
            queryForDepart += "UNION ALL\r\n";
        }
        queryForDepart +=
            "SELECT '"+deptIDs[i]+"' AS departId, '"+deptNames[i]+"' AS departName, NVL(COUNT(*), 0) AS CNT \r\n" +
            "FROM ContentsLog \r\n" +
            "WHERE \r\n" +
            strDateCondition +
            "  workerId IN ( \r\n" +
            "    SELECT userid FROM Member \r\n" +
            "    WHERE departId = '"+deptIDs[i]+"' OR departId IN (SELECT departid FROM DepartMent WHERE parentDepartId='"+deptIDs[i]+"') \r\n" +
            "  ) \r\n";
    }

    for (int i = 0; i < dongIDs.length; i++) {
        queryForDepart +=
            "UNION ALL \r\n" +
            "SELECT '"+dongIDs[i]+"' AS departId, '"+dongNames[i]+"' AS departName, NVL(COUNT(*), 0) AS CNT \r\n" +
            "FROM ContentsLog \r\n" +
            "WHERE \r\n" +
            strDateCondition +
            "  workerId IN ( \r\n" +
            "    SELECT userid FROM Member \r\n" +
            "    WHERE departId = '"+dongIDs[i]+"' OR departId IN (SELECT departid FROM DepartMent WHERE parentDepartId='"+dongIDs[i]+"') \r\n" +
            "  ) \r\n";
    }

    /*
    for (int i = 0; i < dongIDs.length; i++) {
        if (i > 0) {
            queryForDong += "UNION \r\n";
        }
        queryForDong +=
            "SELECT '"+dongIDs[i]+"' AS departId, '"+dongNames[i]+"' AS dongName, NVL(COUNT(*), 0) AS CNT \r\n" +
            "FROM ContentsLog \r\n" +
            "WHERE \r\n" +
            strDateCondition +
            "  workerId IN ( \r\n" +
            "    SELECT userid FROM Member \r\n" +
            "    WHERE departId = '"+dongIDs[i]+"' OR departId IN (SELECT departid FROM DepartMent WHERE parentDepartId='"+dongIDs[i]+"') \r\n" +
            "  ) \r\n";
    }
    */

	try {
        dbMgr = DBManagerFactory.getInstance(DB_POOL_NAME);
		conn = dbMgr.getConnection();
	    stmt = conn.createStatement();
        //System.out.println(queryForDepart);
        rs = stmt.executeQuery(queryForDepart);
        while (rs.next()) {
%>
      <tr>
        <td bgcolor="#ffffff"><%= rs.getString("departName") %></td>
        <td bgcolor="#ffffff"><%= rs.getInt("CNT") %></td>
      </tr>
<%
        }

        /*

        dbMgr.closeObject(rs);
        //System.out.println(queryForDong);
        rs = stmt.executeQuery(queryForDong);
        while (rs.next()) {
% >
      <tr>
        <td bgcolor="#ffffff">< %= rs.getString("dongName") % ></td>
        <td bgcolor="#ffffff">< %= rs.getInt("CNT") % ></td>
      </tr>
< %
        }
        */
	} catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { dbMgr.closeObject(rs); } catch(Exception e) {}
        try { dbMgr.closeObject(stmt); } catch(Exception e) {}
        try { dbMgr.closeObject(conn); } catch(Exception e) {}
    }
%>
</table>
    </div>
  </td>
</tr><iframe id="download" src="" style="height:0%;width:0%" frameborder="0"></iframe>
<tr>
  <td colspan="2" class=popup_close align="right" height=30><a href="javascript:window.close();"><img src="../images/btn_close2.gif" width="53" height="24" alt="" border="0" vspace=3 hspace=15></a></td>
</tr>
</table>
</form>
</body>
</html:html>