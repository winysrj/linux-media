Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59800 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2ESKTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 06:19:49 -0400
Received: by wibhm6 with SMTP id hm6so1477044wib.1
        for <linux-media@vger.kernel.org>; Sat, 19 May 2012 03:19:48 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/5] ignore user commands on fe
Date: Sat, 19 May 2012 12:18:49 +0200
Message-Id: <1337422732-2001-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337422732-2001-1-git-send-email-neolynx@gmail.com>
References: <1337422732-2001-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/libdvbv5/dvb-fe.c     |   32 ++++++++++++++++++++++++++++----
 lib/libdvbv5/dvb-v5-std.c |    2 ++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 9ec9893..8f27e1a 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -391,12 +391,21 @@ const char *dvb_cmd_name(int cmd)
   return NULL;
 }
 
+const char * const *dvb_attr_names(int cmd)
+{
+  if (cmd < DTV_USER_COMMAND_START)
+    return dvb_v5_attr_names[cmd];
+  else if (cmd <= DTV_MAX_USER_COMMAND)
+    return dvb_user_attr_names[cmd - DTV_USER_COMMAND_START];
+  return NULL;
+}
+
 void dvb_fe_prt_parms(FILE *fp, const struct dvb_v5_fe_parms *parms)
 {
 	int i;
 
 	for (i = 0; i < parms->n_props; i++) {
-		const char * const *attr_name = dvb_v5_attr_names[parms->dvb_prop[i].cmd];
+		const char * const *attr_name = dvb_attr_names(parms->dvb_prop[i].cmd);
 		if (attr_name) {
 			int j;
 
@@ -450,6 +459,15 @@ int dvb_fe_store_parm(struct dvb_v5_fe_parms *parms,
 	return EINVAL;
 }
 
+int dvb_copy_fe_props(struct dtv_property *from, int n, struct dtv_property *to)
+{
+  int i, j;
+  for (i = 0, j = 0; i < n; i++)
+    if (from[i].cmd < DTV_USER_COMMAND_START)
+      to[j++] = from[i];
+  return j;
+}
+
 int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 {
 	int n = 0;
@@ -473,7 +491,10 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 	parms->dvb_prop[n].cmd = DTV_TUNE;
 	parms->n_props = n;
 
-	prop.props = parms->dvb_prop;
+	struct dtv_property fe_prop[DTV_MAX_COMMAND];
+        n = dvb_copy_fe_props(parms->dvb_prop, n, fe_prop);
+
+	prop.props = fe_prop;
 	prop.num = n;
 	if (!parms->legacy_fe) {
 		if (ioctl(parms->fd, FE_GET_PROPERTY, &prop) == -1) {
@@ -540,8 +561,11 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 	uint32_t freq;
 	uint32_t bw;
 
-	prop.props = parms->dvb_prop;
-	prop.num = parms->n_props + 1;
+	struct dtv_property fe_prop[DTV_MAX_COMMAND];
+        int n = dvb_copy_fe_props(parms->dvb_prop, parms->n_props, fe_prop);
+
+	prop.props = fe_prop;
+	prop.num = n + 1;
 	parms->dvb_prop[parms->n_props].cmd = DTV_TUNE;
 
 	if (is_satellite(parms->current_sys)) {
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index 210f661..e20eb91 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -106,6 +106,7 @@ const unsigned int sys_dvbs_props[] = {
 	DTV_INNER_FEC,
 	DTV_VOLTAGE,
 	DTV_TONE,
+        DTV_POLARIZATION,
 	0
 };
 
@@ -119,6 +120,7 @@ const unsigned int sys_dvbs2_props[] = {
 	DTV_MODULATION,
 	DTV_PILOT,
 	DTV_ROLLOFF,
+        DTV_POLARIZATION,
 	0
 };
 
-- 
1.7.2.5

