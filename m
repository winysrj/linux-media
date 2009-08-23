Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:64756 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446AbZHWDul (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 23:50:41 -0400
Received: by rv-out-0506.google.com with SMTP id k40so585423rvb.5
        for <linux-media@vger.kernel.org>; Sat, 22 Aug 2009 20:50:42 -0700 (PDT)
From: hiranotaka@zng.jp
Date: Sun, 23 Aug 2009 12:49:49 +0900
Message-Id: <87my5r6vfm.fsf@wei.zng.jp>
To: mchehab@infradead.org, linux-media@vger.kernel.org
CC: tomy@users.sourceforge.jp
Subject: [PATCH 1/2] Add the DTV_ISDB_TS_ID property for ISDB_S
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Add the DTV_ISDB_TS_ID property for ISDB-S

In ISDB-S, time-devision duplex is used to multiplexing several waves
in the same frequency. Each wave is identified by its own transport
stream ID, or TS ID. We need to provide some way to specify this ID
from user applications to handle ISDB-S frontends.

This code has been tested with the Earthsoft PT1 driver.

Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>

diff -r 948b12c08e2b -r bc34617eca49 linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Sat Aug 22 23:17:30 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Sun Aug 23 11:50:35 2009 +0900
@@ -948,6 +948,11 @@
 		.cmd	= DTV_TRANSMISSION_MODE,
 		.set	= 1,
 	},
+	[DTV_ISDB_TS_ID] = {
+		.name	= "DTV_ISDB_TS_ID",
+		.cmd	= DTV_ISDB_TS_ID,
+		.set	= 1,
+	},
 	/* Get */
 	[DTV_DISEQC_SLAVE_REPLY] = {
 		.name	= "DTV_DISEQC_SLAVE_REPLY",
@@ -1356,6 +1361,9 @@
 	case DTV_HIERARCHY:
 		tvp->u.data = fe->dtv_property_cache.hierarchy;
 		break;
+	case DTV_ISDB_TS_ID:
+		tvp->u.data = fe->dtv_property_cache.isdb_ts_id;
+		break;
 	default:
 		r = -1;
 	}
@@ -1462,6 +1470,9 @@
 	case DTV_HIERARCHY:
 		fe->dtv_property_cache.hierarchy = tvp->u.data;
 		break;
+	case DTV_ISDB_TS_ID:
+		fe->dtv_property_cache.isdb_ts_id = tvp->u.data;
+		break;
 	default:
 		r = -1;
 	}
diff -r 948b12c08e2b -r bc34617eca49 linux/drivers/media/dvb/dvb-core/dvb_frontend.h
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Sat Aug 22 23:17:30 2009 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.h	Sun Aug 23 11:50:35 2009 +0900
@@ -355,6 +355,7 @@
 	fe_modulation_t		isdb_layerc_modulation;
 	u32			isdb_layerc_segment_width;
 #endif
+	u32			isdb_ts_id;
 };
 
 struct dvb_frontend {
diff -r 948b12c08e2b -r bc34617eca49 linux/include/linux/dvb/frontend.h
--- a/linux/include/linux/dvb/frontend.h	Sat Aug 22 23:17:30 2009 -0300
+++ b/linux/include/linux/dvb/frontend.h	Sun Aug 23 11:50:35 2009 +0900
@@ -307,7 +307,9 @@
 #define DTV_TRANSMISSION_MODE			39
 #define DTV_HIERARCHY				40
 
-#define DTV_MAX_COMMAND				DTV_HIERARCHY
+#define DTV_ISDB_TS_ID				41
+
+#define DTV_MAX_COMMAND				DTV_ISDB_TS_ID
 
 typedef enum fe_pilot {
 	PILOT_ON,
