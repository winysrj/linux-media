Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward7.mail.yandex.net ([77.88.61.37]:48127 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2HPRwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 13:52:20 -0400
From: CrazyCat <crazycat69@yandex.ru>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb_frontend: Multistream support
MIME-Version: 1.0
Message-Id: <53381345139167@web11e.yandex.ru>
Date: Thu, 16 Aug 2012 20:46:07 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DTV_ISDBS_TS_ID replaced with DTV_STREAM_ID.
Aliases DTV_ISDBS_TS_ID, DTV_DVBS2_MIS_ID for DTV_STREAM_ID.
DTV_DVBT2_PLP_ID marked as legacy.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index f50d405..3444dda 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -62,6 +62,7 @@ typedef enum fe_caps {
���������FE_CAN_8VSB = 0x200000,
���������FE_CAN_16VSB = 0x400000,
���������FE_HAS_EXTENDED_CAPS = 0x800000, ��/* We need more bitspace for newer APIs, indicate this. */
+ FE_CAN_MULTISTREAM = 0x4000000, �/* frontend supports DVB-S2 multistream filtering */
���������FE_CAN_TURBO_FEC = 0x8000000, �/* frontend supports "turbo fec modulation" */
���������FE_CAN_2G_MODULATION = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
���������FE_NEEDS_BENDING = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
@@ -314,9 +315,11 @@ struct dvb_frontend_event {

�#define DTV_ISDBT_LAYER_ENABLED 41

-#define DTV_ISDBS_TS_ID 42
+#define DTV_STREAM_ID 42
+#define DTV_ISDBS_TS_ID DTV_STREAM_ID
+#define DTV_DVBS2_MIS_ID DTV_STREAM_ID

-#define DTV_DVBT2_PLP_ID 43
+#define DTV_DVBT2_PLP_ID_LEGACY 43

�#define DTV_ENUM_DELSYS 44

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 7c64c09..bec0cda 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -368,11 +368,8 @@ struct dtv_frontend_properties {
�������������u8 interleaving;
���������} layer[3];

- /* ISDB-T specifics */
- u32 isdbs_ts_id;
-
- /* DVB-T2 specifics */
- u32 ��������������������dvbt2_plp_id;
+ /* Multistream specifics */
+ u32 stream_id;

���������/* ATSC-MH specifics */
���������u8 atscmh_fic_ver;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index aebcdf2..bccd245 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -946,8 +946,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
�����������������c->layer[i].segment_count = 0;
���������}

- c->isdbs_ts_id = 0;
- c->dvbt2_plp_id = 0;
+ c->stream_id = -1;

���������switch (c->delivery_system) {
���������case SYS_DVBS:
@@ -1017,8 +1016,8 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
���������_DTV_CMD(DTV_ISDBT_LAYERC_SEGMENT_COUNT, 1, 0),
���������_DTV_CMD(DTV_ISDBT_LAYERC_TIME_INTERLEAVING, 1, 0),

- _DTV_CMD(DTV_ISDBS_TS_ID, 1, 0),
- _DTV_CMD(DTV_DVBT2_PLP_ID, 1, 0),
+ _DTV_CMD(DTV_STREAM_ID, 1, 0),
+ _DTV_CMD(DTV_DVBT2_PLP_ID_LEGACY, 1, 0),

���������/* Get */
���������_DTV_CMD(DTV_DISEQC_SLAVE_REPLY, 0, 1),
@@ -1382,11 +1381,10 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
���������case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
�����������������tvp->u.data = c->layer[2].interleaving;
�����������������break;
- case DTV_ISDBS_TS_ID:
- tvp->u.data = c->isdbs_ts_id;
- break;
- case DTV_DVBT2_PLP_ID:
- tvp->u.data = c->dvbt2_plp_id;
+
+ case DTV_STREAM_ID:
+ case DTV_DVBT2_PLP_ID_LEGACY:
+ tvp->u.data = c->stream_id;
�����������������break;

���������/* ATSC-MH */
@@ -1771,11 +1769,10 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
���������case DTV_ISDBT_LAYERC_TIME_INTERLEAVING:
�����������������c->layer[2].interleaving = tvp->u.data;
�����������������break;
- case DTV_ISDBS_TS_ID:
- c->isdbs_ts_id = tvp->u.data;
- break;
- case DTV_DVBT2_PLP_ID:
- c->dvbt2_plp_id = tvp->u.data;
+
+ case DTV_STREAM_ID:
+ case DTV_DVBT2_PLP_ID_LEGACY:
+ c->stream_id = tvp->u.data;
�����������������break;

���������/* ATSC-MH */
