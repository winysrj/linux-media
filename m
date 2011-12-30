Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9VTc026602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 82/94] [media] tlg2300: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:19 -0200
Message-Id: <1325257711-12274-83-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
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

