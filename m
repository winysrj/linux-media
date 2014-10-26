Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43648 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaJZLrf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 07:47:35 -0400
Received: by mail-pd0-f179.google.com with SMTP id g10so3961331pdj.38
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 04:47:35 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 6/7] v4l-utils/libdvbv5: don't discard config-supplied parameters
Date: Sun, 26 Oct 2014 20:46:22 +0900
Message-Id: <1414323983-15996-7-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

When an user enabled the option to update parameters with PSI,
the parameters that were supplied from config file and  not mandatory
to the delivery system were discarded.
---
 lib/libdvbv5/dvb-fe.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 05f7d03..52af4e4 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -575,6 +575,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
 	int i, n = 0;
 	const unsigned int *sys_props;
 	struct dtv_properties prop;
+	struct dtv_property fe_prop[DTV_MAX_COMMAND];
 	struct dvb_frontend_parameters v3_parms;
 	uint32_t bw;
 
@@ -583,19 +584,14 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *p)
 		return EINVAL;
 
 	while (sys_props[n]) {
-		parms->dvb_prop[n].cmd = sys_props[n];
+		fe_prop[n].cmd = sys_props[n];
 		n++;
 	}
-	parms->dvb_prop[n].cmd = DTV_DELIVERY_SYSTEM;
-	parms->dvb_prop[n].u.data = parms->p.current_sys;
+	fe_prop[n].cmd = DTV_DELIVERY_SYSTEM;
+	fe_prop[n].u.data = parms->p.current_sys;
 	n++;
 
-	/* Keep it ready for set */
-	parms->dvb_prop[n].cmd = DTV_TUNE;
-	parms->n_props = n;
-
-	struct dtv_property fe_prop[DTV_MAX_COMMAND];
-	n = dvb_copy_fe_props(parms->dvb_prop, n, fe_prop);
+	n = dvb_copy_fe_props(fe_prop, n, fe_prop);
 
 	prop.props = fe_prop;
 	prop.num = n;
-- 
2.1.2

