Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:46472 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756729AbdLPMYz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 07:24:55 -0500
Received: by mail-wr0-f193.google.com with SMTP id g17so999246wrd.13
        for <linux-media@vger.kernel.org>; Sat, 16 Dec 2017 04:24:55 -0800 (PST)
From: Athanasios Oikonomou <athoik@gmail.com>
To: linux-media@vger.kernel.org
Cc: Athanasios Oikonomou <athoik@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: [PATCH 1/2] media: dvb_frontend: add physical layer scrambling support
Date: Sat, 16 Dec 2017 14:23:38 +0200
Message-Id: <ad2ec63bc7fcfc220a1c1069947e4bbcac7091f3.1513426881.git.athoik@gmail.com>
In-Reply-To: <cover.1513426880.git.athoik@gmail.com>
References: <cover.1513426880.git.athoik@gmail.com>
In-Reply-To: <cover.1513426880.git.athoik@gmail.com>
References: <cover.1513426880.git.athoik@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds a new property DTV_SCRAMBLING_SEQUENCE_INDEX.

This 18 bit field, when present, carries the index of the DVB-S2 physical
layer scrambling sequence as defined in clause 5.5.4 of EN 302 307.
There is no explicit signalling method to convey scrambling sequence index
to the receiver. If S2 satellite delivery system descriptor is available
it can be used to read the scrambling sequence index (EN 300 468 table 41).

By default, gold scrambling sequence index 0 is used. The valid scrambling
sequence index range is from 0 to 262142.

Increase the DVB API version in order userspace to be aware of the changes.

Signed-off-by: Athanasios Oikonomou <athoik@gmail.com>
---
 .../media/uapi/dvb/fe_property_parameters.rst          | 18 ++++++++++++++++++
 .../uapi/dvb/frontend-property-satellite-systems.rst   |  2 ++
 drivers/media/dvb-core/dvb_frontend.c                  | 12 ++++++++++++
 drivers/media/dvb-core/dvb_frontend.h                  |  5 +++++
 include/uapi/linux/dvb/frontend.h                      |  5 ++++-
 include/uapi/linux/dvb/version.h                       |  2 +-
 6 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index 6eef507..3524dca 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -987,3 +987,21 @@ Possible values: 0, 1, LNA_AUTO
 1, LNA on
 
 use the special macro LNA_AUTO to set LNA auto
+
+
+.. _DTV-SCRAMBLING-SEQUENCE-INDEX:
+
+DTV_SCRAMBLING_SEQUENCE_INDEX
+=============================
+
+Used on DVB-S2.
+
+This 18 bit field, when present, carries the index of the DVB-S2 physical
+layer scrambling sequence as defined in clause 5.5.4 of EN 302 307.
+There is no explicit signalling method to convey scrambling sequence index
+to the receiver. If S2 satellite delivery system descriptor is available
+it can be used to read the scrambling sequence index (EN 300 468 table 41).
+
+By default, gold scrambling sequence index 0 is used.
+
+The valid scrambling sequence index range is from 0 to 262142.
diff --git a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
index 1f40399..2929e69 100644
--- a/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
+++ b/Documentation/media/uapi/dvb/frontend-property-satellite-systems.rst
@@ -60,6 +60,8 @@ following parameters:
 
 -  :ref:`DTV_STREAM_ID <DTV-STREAM-ID>`
 
+-  :ref:`DTV_SCRAMBLING_SEQUENCE_INDEX <DTV-SCRAMBLING-SEQUENCE-INDEX>`
+
 In addition, the :ref:`DTV QoS statistics <frontend-stat-properties>`
 are also valid.
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2afaa82..e192876 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -982,6 +982,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	}
 
 	c->stream_id = NO_STREAM_ID_FILTER;
+	c->scrambling_sequence_index = 0;/* default sequence */
 
 	switch (c->delivery_system) {
 	case SYS_DVBS:
@@ -1072,6 +1073,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 
 	_DTV_CMD(DTV_STREAM_ID, 1, 0),
 	_DTV_CMD(DTV_DVBT2_PLP_ID_LEGACY, 1, 0),
+	_DTV_CMD(DTV_SCRAMBLING_SEQUENCE_INDEX, 1, 0),
 	_DTV_CMD(DTV_LNA, 1, 0),
 
 	/* Get */
@@ -1417,6 +1419,11 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		tvp->u.data = c->stream_id;
 		break;
 
+	/* Physical layer scrambling support */
+	case DTV_SCRAMBLING_SEQUENCE_INDEX:
+		tvp->u.data = c->scrambling_sequence_index;
+		break;
+
 	/* ATSC-MH */
 	case DTV_ATSCMH_FIC_VER:
 		tvp->u.data = fe->dtv_property_cache.atscmh_fic_ver;
@@ -1900,6 +1907,11 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		c->stream_id = data;
 		break;
 
+	/* Physical layer scrambling support */
+	case DTV_SCRAMBLING_SEQUENCE_INDEX:
+		c->scrambling_sequence_index = data;
+		break;
+
 	/* ATSC-MH */
 	case DTV_ATSCMH_PARADE_ID:
 		fe->dtv_property_cache.atscmh_parade_id = data;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index ace0c2f..2bc25f1 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -513,6 +513,8 @@ struct dvb_fe_events {
  * @layer.interleaving:	 per layer interleaving.
  * @stream_id:		If different than zero, enable substream filtering, if
  *			hardware supports (DVB-S2 and DVB-T2).
+ * @scrambling_sequence_index:	Carries the index of the DVB-S2 physical layer
+ *				scrambling sequence.
  * @atscmh_fic_ver:	Version number of the FIC (Fast Information Channel)
  *			signaling data (only ATSC-M/H)
  * @atscmh_parade_id:	Parade identification number (only ATSC-M/H)
@@ -591,6 +593,9 @@ struct dtv_frontend_properties {
 	/* Multistream specifics */
 	u32			stream_id;
 
+	/* Physical Layer Scrambling specifics */
+	u32			scrambling_sequence_index;
+
 	/* ATSC-MH specifics */
 	u8			atscmh_fic_ver;
 	u8			atscmh_parade_id;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index b297b65..9218cd6 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -547,7 +547,10 @@ enum fe_interleaving {
 #define DTV_STAT_ERROR_BLOCK_COUNT	68
 #define DTV_STAT_TOTAL_BLOCK_COUNT	69
 
-#define DTV_MAX_COMMAND		DTV_STAT_TOTAL_BLOCK_COUNT
+/* Physical layer scrambling */
+#define DTV_SCRAMBLING_SEQUENCE_INDEX	70
+
+#define DTV_MAX_COMMAND		DTV_SCRAMBLING_SEQUENCE_INDEX
 
 /**
  * enum fe_pilot - Type of pilot tone
diff --git a/include/uapi/linux/dvb/version.h b/include/uapi/linux/dvb/version.h
index 02e32ea..2c5cffe 100644
--- a/include/uapi/linux/dvb/version.h
+++ b/include/uapi/linux/dvb/version.h
@@ -25,6 +25,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 10
+#define DVB_API_VERSION_MINOR 11
 
 #endif /*_DVBVERSION_H_*/
-- 
2.1.4
