Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36776 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762233Ab2EQSAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 14:00:24 -0400
Received: by wibhj8 with SMTP id hj8so5312568wib.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 11:00:22 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/2] dvb_cmd_name function
Date: Thu, 17 May 2012 19:59:41 +0200
Message-Id: <1337277582-14128-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h  |    1 +
 lib/libdvbv5/dvb-fe.c |   21 +++++++++++++++------
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 872a558..b4c5279 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -108,6 +108,7 @@ int dvb_set_sys(struct dvb_v5_fe_parms *parms,
 		   fe_delivery_system_t sys);
 int dvb_set_compat_delivery_system(struct dvb_v5_fe_parms *parms,
 				   uint32_t desired_system);
+const char *dvb_cmd_name(int cmd);
 void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms);
 int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms);
 int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms);
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 1fa4ef5..4f7a217 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -380,6 +380,15 @@ int dvb_set_compat_delivery_system(struct dvb_v5_fe_parms *parms,
 	return 0;
 }
 
+const char *dvb_cmd_name(int cmd)
+{
+  if (cmd < DTV_USER_COMMAND_START)
+    return dvb_v5_name[cmd];
+  else if (cmd <= DTV_MAX_USER_COMMAND)
+    return dvb_user_name[cmd - DTV_USER_COMMAND_START];
+  return NULL;
+}
+
 void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms)
 {
 	int i;
@@ -398,11 +407,11 @@ void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms)
 
 		if (!attr_name || !*attr_name)
 			fprintf(fp, "%s = %u\n",
-				dvb_v5_name[parms->dvb_prop[i].cmd],
+				dvb_cmd_name(parms->dvb_prop[i].cmd),
 				parms->dvb_prop[i].u.data);
 		else
 			fprintf(fp, "%s = %s\n",
-				dvb_v5_name[parms->dvb_prop[i].cmd],
+				dvb_cmd_name(parms->dvb_prop[i].cmd),
 				*attr_name);
 	}
 };
@@ -417,8 +426,8 @@ int dvb_fe_retrieve_parm(struct dvb_v5_fe_parms *parms,
 		*value = parms->dvb_prop[i].u.data;
 		return 0;
 	}
-	fprintf(stderr, "%s (%d) command not found during retrieve\n",
-		dvb_v5_name[cmd], cmd);
+	fprintf(stderr, "command %s (%d) not found during retrieve\n",
+		dvb_cmd_name(cmd), cmd);
 
 	return EINVAL;
 }
@@ -433,8 +442,8 @@ int dvb_fe_store_parm(struct dvb_v5_fe_parms *parms,
 		parms->dvb_prop[i].u.data = value;
 		return 0;
 	}
-	fprintf(stderr, "%s (%d) command not found during store\n",
-		dvb_v5_name[cmd], cmd);
+	fprintf(stderr, "command %s (%d) not found during store\n",
+		dvb_cmd_name(cmd), cmd);
 
 	return EINVAL;
 }
-- 
1.7.2.5

