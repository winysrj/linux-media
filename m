Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57965 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab2EXWDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 18:03:05 -0400
Received: by wgbdr13 with SMTP id dr13so224722wgb.1
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 15:03:04 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 1/2] Tuning fixed
Date: Fri, 25 May 2012 00:02:09 +0200
Message-Id: <1337896930-19554-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-fe.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index ba7bdf0..9d0866e 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -503,11 +503,11 @@ int dvb_fe_store_parm(struct dvb_v5_fe_parms *parms,
 
 int dvb_copy_fe_props(struct dtv_property *from, int n, struct dtv_property *to)
 {
-  int i, j;
-  for (i = 0, j = 0; i < n; i++)
-    if (from[i].cmd < DTV_USER_COMMAND_START)
-      to[j++] = from[i];
-  return j;
+	int i, j;
+	for (i = 0, j = 0; i < n; i++)
+		if (from[i].cmd < DTV_USER_COMMAND_START)
+			to[j++] = from[i];
+	return j;
 }
 
 int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
@@ -529,6 +529,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 	parms->dvb_prop[n].cmd = DTV_DELIVERY_SYSTEM;
 	parms->dvb_prop[n].u.data = parms->current_sys;
 	n++;
+
 	/* Keep it ready for set */
 	parms->dvb_prop[n].cmd = DTV_TUNE;
 	parms->n_props = n;
@@ -604,17 +605,19 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 	uint32_t bw;
 
 	struct dtv_property fe_prop[DTV_MAX_COMMAND];
-	int n = dvb_copy_fe_props(parms->dvb_prop, parms->n_props, fe_prop);
-
-	prop.props = fe_prop;
-	prop.num = n + 1;
-	parms->dvb_prop[parms->n_props].cmd = DTV_TUNE;
 
 	if (is_satellite(parms->current_sys)) {
 		dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
 		dvb_sat_set_parms(parms);
 	}
 
+	int n = dvb_copy_fe_props(parms->dvb_prop, parms->n_props, fe_prop);
+
+	prop.props = fe_prop;
+	prop.num = n;
+	prop.props[prop.num].cmd = DTV_TUNE;
+	prop.num++;
+
 	if (!parms->legacy_fe) {
 		if (ioctl(parms->fd, FE_SET_PROPERTY, &prop) == -1) {
 			dvb_perror("FE_SET_PROPERTY");
-- 
1.7.2.5

