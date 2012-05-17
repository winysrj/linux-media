Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38940 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762286Ab2EQSAZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 14:00:25 -0400
Received: by weyu7 with SMTP id u7so1324709wey.19
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 11:00:23 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/2] ignore user commands on fe
Date: Thu, 17 May 2012 19:59:42 +0200
Message-Id: <1337277582-14128-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337277582-14128-1-git-send-email-neolynx@gmail.com>
References: <1337277582-14128-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/libdvbv5/dvb-fe.c     |   32 ++++++++++++++++++++++++++++----
 lib/libdvbv5/dvb-v5-std.c |    2 ++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 4f7a217..a91dd65 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -389,12 +389,21 @@ const char *dvb_cmd_name(int cmd)
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
 
@@ -448,6 +457,15 @@ int dvb_fe_store_parm(struct dvb_v5_fe_parms *parms,
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
@@ -471,7 +489,10 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
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
@@ -538,8 +559,11 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
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
index ec588b1..fe66041 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -105,6 +105,7 @@ const unsigned int sys_dvbs_props[] = {
 	DTV_INNER_FEC,
 	DTV_VOLTAGE,
 	DTV_TONE,
+        DTV_POLARIZATION,
 	0
 };
 
@@ -118,6 +119,7 @@ const unsigned int sys_dvbs2_props[] = {
 	DTV_MODULATION,
 	DTV_PILOT,
 	DTV_ROLLOFF,
+        DTV_POLARIZATION,
 	0
 };
 
-- 
1.7.2.5

