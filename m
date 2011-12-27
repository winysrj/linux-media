Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1L0BJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:45 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19jAj017924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 82/91] [media] tlg2300: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:10 -0200
Message-Id: <1324948159-23709-83-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-82-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
 <1324948159-23709-77-git-send-email-mchehab@redhat.com>
 <1324948159-23709-78-git-send-email-mchehab@redhat.com>
 <1324948159-23709-79-git-send-email-mchehab@redhat.com>
 <1324948159-23709-80-git-send-email-mchehab@redhat.com>
 <1324948159-23709-81-git-send-email-mchehab@redhat.com>
 <1324948159-23709-82-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tlg2300/pd-common.h |    2 +-
 drivers/media/video/tlg2300/pd-dvb.c    |   23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/video/tlg2300/pd-common.h
index 56564e6..5dd73b7 100644
--- a/drivers/media/video/tlg2300/pd-common.h
+++ b/drivers/media/video/tlg2300/pd-common.h
@@ -140,7 +140,7 @@ struct pd_dvb_adapter {
 	u8			reserved[3];
 
 	/* data for power resume*/
-	struct dvb_frontend_parameters fe_param;
+	struct dtv_frontend_properties fe_param;
 
 	/* for channel scanning */
 	int		prev_freq;
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/video/tlg2300/pd-dvb.c
index f864c17..7998811 100644
--- a/drivers/media/video/tlg2300/pd-dvb.c
+++ b/drivers/media/video/tlg2300/pd-dvb.c
@@ -12,9 +12,9 @@
 static void dvb_urb_cleanup(struct pd_dvb_adapter *pd_dvb);
 
 static int dvb_bandwidth[][2] = {
-	{ TLG_BW_8, BANDWIDTH_8_MHZ },
-	{ TLG_BW_7, BANDWIDTH_7_MHZ },
-	{ TLG_BW_6, BANDWIDTH_6_MHZ }
+	{ TLG_BW_8, 8000000 },
+	{ TLG_BW_7, 7000000 },
+	{ TLG_BW_6, 6000000 }
 };
 static int dvb_bandwidth_length = ARRAY_SIZE(dvb_bandwidth);
 
@@ -146,9 +146,9 @@ static int fw_delay_overflow(struct pd_dvb_adapter *adapter)
 	return msec > 800 ? true : false;
 }
 
-static int poseidon_set_fe(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *fep)
+static int poseidon_set_fe(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	s32 ret = 0, cmd_status = 0;
 	s32 i, bandwidth = -1;
 	struct poseidon *pd = fe->demodulator_priv;
@@ -159,7 +159,7 @@ static int poseidon_set_fe(struct dvb_frontend *fe,
 
 	mutex_lock(&pd->lock);
 	for (i = 0; i < dvb_bandwidth_length; i++)
-		if (fep->u.ofdm.bandwidth == dvb_bandwidth[i][1])
+		if (fep->bandwidth_hz == dvb_bandwidth[i][1])
 			bandwidth = dvb_bandwidth[i][0];
 
 	if (check_scan_ok(fep->frequency, bandwidth, pd_dvb)) {
@@ -210,7 +210,7 @@ static int pm_dvb_resume(struct poseidon *pd)
 
 	poseidon_check_mode_dvbt(pd);
 	msleep(300);
-	poseidon_set_fe(&pd_dvb->dvb_fe, &pd_dvb->fe_param);
+	poseidon_set_fe(&pd_dvb->dvb_fe);
 
 	dvb_start_streaming(pd_dvb);
 	return 0;
@@ -227,12 +227,12 @@ static s32 poseidon_fe_init(struct dvb_frontend *fe)
 	pd->pm_resume  = pm_dvb_resume;
 #endif
 	memset(&pd_dvb->fe_param, 0,
-			sizeof(struct dvb_frontend_parameters));
+			sizeof(struct dtv_frontend_properties));
 	return 0;
 }
 
 static int poseidon_get_fe(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *fep)
+			struct dtv_frontend_properties *fep)
 {
 	struct poseidon *pd = fe->demodulator_priv;
 	struct pd_dvb_adapter *pd_dvb = &pd->dvb_data;
@@ -332,6 +332,7 @@ static int poseidon_read_unc_blocks(struct dvb_frontend *fe, u32 *unc)
 }
 
 static struct dvb_frontend_ops poseidon_frontend_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name		= "Poseidon DVB-T",
 		.type		= FE_OFDM,
@@ -353,8 +354,8 @@ static struct dvb_frontend_ops poseidon_frontend_ops = {
 	.init = poseidon_fe_init,
 	.sleep = poseidon_fe_sleep,
 
-	.set_frontend_legacy = poseidon_set_fe,
-	.get_frontend_legacy = poseidon_get_fe,
+	.set_frontend = poseidon_set_fe,
+	.get_frontend = poseidon_get_fe,
 	.get_tune_settings = poseidon_fe_get_tune_settings,
 
 	.read_status	= poseidon_read_status,
-- 
1.7.8.352.g876a6

