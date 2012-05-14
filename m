Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:44405 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab2ENWLT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:19 -0400
Received: by qabj40 with SMTP id j40so5345287qab.1
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:18 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 01/11] linux-dvb v5 API support for ATSC-MH
Date: Mon, 14 May 2012 18:10:43 -0400
Message-Id: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the following properties for controlling an ATSC-MH frontend:

DTV_ATSCMH_FIC_VER
DTV_ATSCMH_PARADE_ID
DTV_ATSCMH_NOG
DTV_ATSCMH_TNOG
DTV_ATSCMH_SGN
DTV_ATSCMH_PRC
DTV_ATSCMH_RS_FRAME_MODE
DTV_ATSCMH_RS_FRAME_ENSEMBLE
DTV_ATSCMH_RS_CODE_MODE_PRI
DTV_ATSCMH_RS_CODE_MODE_SEC
DTV_ATSCMH_SCCC_BLOCK_MODE
DTV_ATSCMH_SCCC_CODE_MODE_A
DTV_ATSCMH_SCCC_CODE_MODE_B
DTV_ATSCMH_SCCC_CODE_MODE_C
DTV_ATSCMH_SCCC_CODE_MODE_D
DTV_ATSCMH_FIC_ERR
DTV_ATSCMH_CRC_ERR
DTV_ATSCMH_RS_ERR

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   92 ++++++++++++++++++++++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.h |   22 +++++++
 include/linux/dvb/frontend.h              |   54 ++++++++++++++++-
 3 files changed, 166 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 4555baa..067f10a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -180,13 +180,13 @@ static enum dvbv3_emulation_type dvbv3_type(u32 delivery_system)
 	case SYS_DMBTH:
 		return DVBV3_OFDM;
 	case SYS_ATSC:
+	case SYS_ATSCMH:
 	case SYS_DVBC_ANNEX_B:
 		return DVBV3_ATSC;
 	case SYS_UNDEFINED:
 	case SYS_ISDBC:
 	case SYS_DVBH:
 	case SYS_DAB:
-	case SYS_ATSCMH:
 	default:
 		/*
 		 * Doesn't know how to emulate those types and/or
@@ -1027,6 +1027,28 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_HIERARCHY, 0, 0),
 
 	_DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
+
+	_DTV_CMD(DTV_ATSCMH_PARADE_ID, 1, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 1, 0),
+
+	_DTV_CMD(DTV_ATSCMH_FIC_VER, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_PARADE_ID, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_NOG, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_TNOG, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SGN, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_PRC, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_FRAME_MODE, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_FRAME_ENSEMBLE, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_CODE_MODE_PRI, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_CODE_MODE_SEC, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_BLOCK_MODE, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_A, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_FIC_ERR, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_CRC_ERR, 0, 0),
+	_DTV_CMD(DTV_ATSCMH_RS_ERR, 0, 0),
 };
 
 static void dtv_property_dump(struct dtv_property *tvp)
@@ -1118,6 +1140,8 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 	case DVBV3_ATSC:
 		dprintk("%s() Preparing ATSC req\n", __func__);
 		c->modulation = p->u.vsb.modulation;
+		if (c->delivery_system == SYS_ATSCMH)
+			break;
 		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
 			c->delivery_system = SYS_ATSC;
 		else
@@ -1364,6 +1388,63 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	case DTV_DVBT2_PLP_ID:
 		tvp->u.data = c->dvbt2_plp_id;
 		break;
+
+	/* ATSC-MH */
+	case DTV_ATSCMH_FIC_VER:
+		tvp->u.data = fe->dtv_property_cache.atscmh_fic_ver;
+		break;
+	case DTV_ATSCMH_PARADE_ID:
+		tvp->u.data = fe->dtv_property_cache.atscmh_parade_id;
+		break;
+	case DTV_ATSCMH_NOG:
+		tvp->u.data = fe->dtv_property_cache.atscmh_nog;
+		break;
+	case DTV_ATSCMH_TNOG:
+		tvp->u.data = fe->dtv_property_cache.atscmh_tnog;
+		break;
+	case DTV_ATSCMH_SGN:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sgn;
+		break;
+	case DTV_ATSCMH_PRC:
+		tvp->u.data = fe->dtv_property_cache.atscmh_prc;
+		break;
+	case DTV_ATSCMH_RS_FRAME_MODE:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_frame_mode;
+		break;
+	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_frame_ensemble;
+		break;
+	case DTV_ATSCMH_RS_CODE_MODE_PRI:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_code_mode_pri;
+		break;
+	case DTV_ATSCMH_RS_CODE_MODE_SEC:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_code_mode_sec;
+		break;
+	case DTV_ATSCMH_SCCC_BLOCK_MODE:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_block_mode;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_A:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_a;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_B:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_b;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_C:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_c;
+		break;
+	case DTV_ATSCMH_SCCC_CODE_MODE_D:
+		tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_d;
+		break;
+	case DTV_ATSCMH_FIC_ERR:
+		tvp->u.data = fe->dtv_property_cache.atscmh_fic_err;
+		break;
+	case DTV_ATSCMH_CRC_ERR:
+		tvp->u.data = fe->dtv_property_cache.atscmh_crc_err;
+		break;
+	case DTV_ATSCMH_RS_ERR:
+		tvp->u.data = fe->dtv_property_cache.atscmh_rs_err;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -1682,6 +1763,15 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	case DTV_DVBT2_PLP_ID:
 		c->dvbt2_plp_id = tvp->u.data;
 		break;
+
+	/* ATSC-MH */
+	case DTV_ATSCMH_PARADE_ID:
+		fe->dtv_property_cache.atscmh_parade_id = tvp->u.data;
+		break;
+	case DTV_ATSCMH_RS_FRAME_ENSEMBLE:
+		fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
+		break;
+
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index d63a821..80f5c27 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -372,6 +372,28 @@ struct dtv_frontend_properties {
 
 	/* DVB-T2 specifics */
 	u32                     dvbt2_plp_id;
+
+	/* ATSC-MH specifics */
+	u8			atscmh_fic_ver;
+	u8			atscmh_parade_id;
+	u8			atscmh_nog;
+	u8			atscmh_tnog;
+	u8			atscmh_sgn;
+	u8			atscmh_prc;
+
+	u8			atscmh_rs_frame_mode;
+	u8			atscmh_rs_frame_ensemble;
+	u8			atscmh_rs_code_mode_pri;
+	u8			atscmh_rs_code_mode_sec;
+	u8			atscmh_sccc_block_mode;
+	u8			atscmh_sccc_code_mode_a;
+	u8			atscmh_sccc_code_mode_b;
+	u8			atscmh_sccc_code_mode_c;
+	u8			atscmh_sccc_code_mode_d;
+
+	u16			atscmh_fic_err;
+	u16			atscmh_crc_err;
+	u16			atscmh_rs_err;
 };
 
 struct dvb_frontend {
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index cb4428a..5aedd5a 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -320,7 +320,27 @@ struct dvb_frontend_event {
 
 #define DTV_ENUM_DELSYS		44
 
-#define DTV_MAX_COMMAND				DTV_ENUM_DELSYS
+/* ATSC-MH */
+#define DTV_ATSCMH_FIC_VER		45
+#define DTV_ATSCMH_PARADE_ID		46
+#define DTV_ATSCMH_NOG			47
+#define DTV_ATSCMH_TNOG			48
+#define DTV_ATSCMH_SGN			49
+#define DTV_ATSCMH_PRC			50
+#define DTV_ATSCMH_RS_FRAME_MODE	51
+#define DTV_ATSCMH_RS_FRAME_ENSEMBLE	52
+#define DTV_ATSCMH_RS_CODE_MODE_PRI	53
+#define DTV_ATSCMH_RS_CODE_MODE_SEC	54
+#define DTV_ATSCMH_SCCC_BLOCK_MODE	55
+#define DTV_ATSCMH_SCCC_CODE_MODE_A	56
+#define DTV_ATSCMH_SCCC_CODE_MODE_B	57
+#define DTV_ATSCMH_SCCC_CODE_MODE_C	58
+#define DTV_ATSCMH_SCCC_CODE_MODE_D	59
+#define DTV_ATSCMH_FIC_ERR		60
+#define DTV_ATSCMH_CRC_ERR		61
+#define DTV_ATSCMH_RS_ERR		62
+
+#define DTV_MAX_COMMAND				DTV_ATSCMH_RS_ERR
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -360,6 +380,38 @@ typedef enum fe_delivery_system {
 
 #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
 
+/* ATSC-MH */
+
+enum atscmh_sccc_block_mode {
+	ATSCMH_SCCC_BLK_SEP      = 0,
+	ATSCMH_SCCC_BLK_COMB     = 1,
+	ATSCMH_SCCC_BLK_RES      = 2,
+};
+
+enum atscmh_sccc_code_mode {
+	ATSCMH_SCCC_CODE_HLF     = 0,
+	ATSCMH_SCCC_CODE_QTR     = 1,
+	ATSCMH_SCCC_CODE_RES     = 2,
+};
+
+enum atscmh_rs_frame_ensemble {
+	ATSCMH_RSFRAME_ENS_PRI   = 0,
+	ATSCMH_RSFRAME_ENS_SEC   = 1,
+};
+
+enum atscmh_rs_frame_mode {
+	ATSCMH_RSFRAME_PRI_ONLY  = 0,
+	ATSCMH_RSFRAME_PRI_SEC   = 1,
+	ATSCMH_RSFRAME_RES       = 2,
+};
+
+enum atscmh_rs_code_mode {
+	ATSCMH_RSCODE_211_187    = 0,
+	ATSCMH_RSCODE_223_187    = 1,
+	ATSCMH_RSCODE_235_187    = 2,
+	ATSCMH_RSCODE_RES        = 3,
+};
+
 
 struct dtv_cmds_h {
 	char	*name;		/* A display name for debugging purposes */
-- 
1.7.9.5

