<%@ page contentType="application/vnd.ms-excel;charset=euc-kr"%><%@ page import="com.hts.framework.util.*,com.hts.framework.db.*, com.hts.cms.ebiz.util.*, java.sql.*, javax.sql.*"%><%!
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
%><%
    String fromDate = StringUtil.getCleanString(request.getParameter("fromDate"), DateTime.getDateString("yyyyMM")+"01");
	String toDate = StringUtil.getCleanString(request.getParameter("toDate"), DateTime.getDateString("yyyyMMdd"));

    String supportyear = fromDate.substring(0,4) +"년 " + fromDate.substring(4,6) +"월 " + fromDate.substring(6) +"일 ";
    supportyear += " ~ " + toDate.substring(0,4) +"년 " + toDate.substring(4,6) +"월 " + toDate.substring(6) +"일 ";

    String excelFileName = "contentstat_report_" + DateTime.getDateString("yyyyMMdd") + ".xls";

    StringBuffer sb = new StringBuffer();
	sb.append("<html> \r\n");
	sb.append("<head> \r\n");
	sb.append("    <title>부서/동별 콘텐츠 작업 통계정보</title> \r\n");
	sb.append("    <meta http-equiv='content-type' content='text/html; charset=euc-kr'> \r\n");
	sb.append("    <style> body,table { line-height:30px; mso-style-parent:style0; font-size:9.0pt;font-family:Tahoma,sans-serif; mso-font-charset:0; white-space:normal;background:#e0e0e0; bgcolor:#e0e0e0; } </style> \r\n");
    sb.append("</head> \r\n");
	sb.append("<body> \r\n");
    sb.append("<table border='1' cellspacing='1' cellpadding='1' bgcolor='#f3f3f3'> \r\n");
    sb.append("<tr style='height:25pt'><td colspan='2' style='font-family:굴림;font-size:9pt;' align='center'>");
    sb.append("  <b>부서/동별 콘텐츠 작업 통계정보</b></td>\r\n");
    sb.append("</tr> \r\n");
    sb.append("<tr style='height:25pt'><td colspan='2' style='font-family:굴림;font-size:9pt;' align='center'>");
    sb.append("  <b>기간 : [" + supportyear + "]</b></td>\r\n");
    sb.append("</tr> \r\n");
    sb.append("<tr style='height:20pt'> \r\n");
    sb.append("    <td align='center' bgcolor='#c2e0b8' valign='middle' style='font-family:굴림;font-size:9pt;font-weight:bold;'>부서/동 명</td> \r\n");
    sb.append("    <td align='center' bgcolor='#c2e0b8' valign='middle' style='font-family:굴림;font-size:9pt;font-weight:bold;'>콘텐츠 작업 건수</td> \r\n");
    sb.append("</tr> \r\n");
    
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

	try {
        dbMgr = DBManagerFactory.getInstance(DB_POOL_NAME);
		conn = dbMgr.getConnection();
	    stmt = conn.createStatement();
        //System.out.println(queryForDepart);
        rs = stmt.executeQuery(queryForDepart);
        while (rs.next()) {
            sb.append("<tr style='height:17pt'> \r\n");
            sb.append("    <td style='width:120pt' align='center' bgcolor='#f3f3f3' valign='middle' style='font-family:굴림;font-size:9pt;font-weight:normal;'>" + rs.getString("departName") + "</td> \r\n");
            sb.append("    <td style='width:120pt' width='50%' align='center' bgcolor='#f3f3f3' valign='middle' style='font-family:굴림;font-size:9pt;font-weight:normal;'>" + rs.getString("CNT") + "</td> \r\n");
            sb.append("</tr> \r\n");
        }
	} catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { dbMgr.closeObject(rs); } catch(Exception e) {}
        try { dbMgr.closeObject(stmt); } catch(Exception e) {}
        try { dbMgr.closeObject(conn); } catch(Exception e) {}
    }

    sb.append("</body> \r\n");
	sb.append("</html> \r\n");

    response.setHeader("Content-Disposition", "attachment;filename=" + excelFileName);
	out.print(sb.toString());
	out.flush();
%>