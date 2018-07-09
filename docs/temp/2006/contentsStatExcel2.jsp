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
        "�������","�ѹ���","�ֹ���ġ��","��ȭü����","�ο������",
        "���ǰ�","��ȹ�����","�繫��","����1��","����2��",
        "��ȸ������","����������","����������","û��ȯ���","���ð�",
        "���ð�����","�����","������","����������","����������",
        "����������","����","ġ����","����������","�������ǰ�","�Ǿ��",
    };

    final static String[] dongIDs = {
        "3130039","3130040","3130041","3130042","3130043",
        "3130044","3130045","3130046","3130047","3130048",
        "3130049","3130050","3130051","3130052","3130053",
        "3130054","3130055","3130056","3130057","3130058",
        "3130059","3130060","3130061","3130062",
    };
    
    final static String[] dongNames = {
        "������1��","������2��","������3��","������1��","������2��",
        "�Ű�����","��ȭ��1��","��ȭ��2��","�밭��","���ﵿ",
        "������","���굿","�ż���","â����","�����",
        "������","������","������","������1��","������2��",
        "������","������1��","������2��","��ϵ�",
    };
%><%
    String fromDate = StringUtil.getCleanString(request.getParameter("fromDate"), DateTime.getDateString("yyyyMM")+"01");
	String toDate = StringUtil.getCleanString(request.getParameter("toDate"), DateTime.getDateString("yyyyMMdd"));

    String supportyear = fromDate.substring(0,4) +"�� " + fromDate.substring(4,6) +"�� " + fromDate.substring(6) +"�� ";
    supportyear += " ~ " + toDate.substring(0,4) +"�� " + toDate.substring(4,6) +"�� " + toDate.substring(6) +"�� ";

    String excelFileName = "contentstat_report_" + DateTime.getDateString("yyyyMMdd") + ".xls";

    StringBuffer sb = new StringBuffer();
	sb.append("<html> \r\n");
	sb.append("<head> \r\n");
	sb.append("    <title>�μ�/���� ������ �۾� �������</title> \r\n");
	sb.append("    <meta http-equiv='content-type' content='text/html; charset=euc-kr'> \r\n");
	sb.append("    <style> body,table { line-height:30px; mso-style-parent:style0; font-size:9.0pt;font-family:Tahoma,sans-serif; mso-font-charset:0; white-space:normal;background:#e0e0e0; bgcolor:#e0e0e0; } </style> \r\n");
    sb.append("</head> \r\n");
	sb.append("<body> \r\n");
    sb.append("<table border='1' cellspacing='1' cellpadding='1' bgcolor='#f3f3f3'> \r\n");
    sb.append("<tr style='height:25pt'><td colspan='2' style='font-family:����;font-size:9pt;' align='center'>");
    sb.append("  <b>�μ�/���� ������ �۾� �������</b></td>\r\n");
    sb.append("</tr> \r\n");
    sb.append("<tr style='height:25pt'><td colspan='2' style='font-family:����;font-size:9pt;' align='center'>");
    sb.append("  <b>�Ⱓ : [" + supportyear + "]</b></td>\r\n");
    sb.append("</tr> \r\n");
    sb.append("<tr style='height:20pt'> \r\n");
    sb.append("    <td align='center' bgcolor='#c2e0b8' valign='middle' style='font-family:����;font-size:9pt;font-weight:bold;'>�μ�/�� ��</td> \r\n");
    sb.append("    <td align='center' bgcolor='#c2e0b8' valign='middle' style='font-family:����;font-size:9pt;font-weight:bold;'>������ �۾� �Ǽ�</td> \r\n");
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
            sb.append("    <td style='width:120pt' align='center' bgcolor='#f3f3f3' valign='middle' style='font-family:����;font-size:9pt;font-weight:normal;'>" + rs.getString("departName") + "</td> \r\n");
            sb.append("    <td style='width:120pt' width='50%' align='center' bgcolor='#f3f3f3' valign='middle' style='font-family:����;font-size:9pt;font-weight:normal;'>" + rs.getString("CNT") + "</td> \r\n");
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