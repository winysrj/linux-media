Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511BTJ016674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 43/47] [media] mt2063: add some useful info for the dvb callback calls
Date: Wed,  4 Jan 2012 23:00:54 -0200
Message-Id: <1325725258-27934-44-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The per-delivery system tables are confusing.
Add an extra table that explains them, and some
dprintk calls, that allows to check if mt2063 driver
is working as expected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   68 +++++++++++++++++++++++----------
 1 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index de45c9d..6f14ee3 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -1008,29 +1008,38 @@ static unsigned int mt2063_lockStatus(struct mt2063_state *state)
  */
 
 enum mt2063_delivery_sys {
-	MT2063_CABLE_QAM = 0,		/* Digital cable              */
-	MT2063_CABLE_ANALOG,		/* Analog cable               */
-	MT2063_OFFAIR_COFDM,		/* Digital offair             */
-	MT2063_OFFAIR_COFDM_SAWLESS,	/* Digital offair without SAW */
-	MT2063_OFFAIR_ANALOG,		/* Analog offair              */
-	MT2063_OFFAIR_8VSB,		/* Analog offair              */
+	MT2063_CABLE_QAM = 0,
+	MT2063_CABLE_ANALOG,
+	MT2063_OFFAIR_COFDM,
+	MT2063_OFFAIR_COFDM_SAWLESS,
+	MT2063_OFFAIR_ANALOG,
+	MT2063_OFFAIR_8VSB,
 	MT2063_NUM_RCVR_MODES
 };
 
-static const u8 RFAGCEN[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 LNARIN[] = { 0, 0, 3, 3, 3, 3 };
-static const u8 FIFFQEN[] = { 1, 1, 1, 1, 1, 1 };
-static const u8 FIFFQ[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 DNC1GC[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 DNC2GC[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ACLNAMAX[] = { 31, 31, 31, 31, 31, 31 };
-static const u8 LNATGT[] = { 44, 43, 43, 43, 43, 43 };
-static const u8 RFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ACRFMAX[] = { 31, 31, 31, 31, 31, 31 };
-static const u8 PD1TGT[] = { 36, 36, 38, 38, 36, 38 };
-static const u8 FIFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ACFIFMAX[] = { 29, 29, 29, 29, 29, 29 };
-static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
+static const char *mt2063_mode_name[] = {
+	[MT2063_CABLE_QAM]		= "digital cable",
+	[MT2063_CABLE_ANALOG]		= "analog cable",
+	[MT2063_OFFAIR_COFDM]		= "digital offair",
+	[MT2063_OFFAIR_COFDM_SAWLESS]	= "digital offair without SAW",
+	[MT2063_OFFAIR_ANALOG]		= "analog offair",
+	[MT2063_OFFAIR_8VSB]		= "analog offair 8vsb",
+};
+
+static const u8 RFAGCEN[]	= {  0,  0,  0,  0,  0,  0 };
+static const u8 LNARIN[]	= {  0,  0,  3,  3,  3,  3 };
+static const u8 FIFFQEN[]	= {  1,  1,  1,  1,  1,  1 };
+static const u8 FIFFQ[]		= {  0,  0,  0,  0,  0,  0 };
+static const u8 DNC1GC[]	= {  0,  0,  0,  0,  0,  0 };
+static const u8 DNC2GC[]	= {  0,  0,  0,  0,  0,  0 };
+static const u8 ACLNAMAX[]	= { 31, 31, 31, 31, 31, 31 };
+static const u8 LNATGT[]	= { 44, 43, 43, 43, 43, 43 };
+static const u8 RFOVDIS[]	= {  0,  0,  0,  0,  0,  0 };
+static const u8 ACRFMAX[]	= { 31, 31, 31, 31, 31, 31 };
+static const u8 PD1TGT[]	= { 36, 36, 38, 38, 36, 38 };
+static const u8 FIFOVDIS[]	= {  0,  0,  0,  0,  0,  0 };
+static const u8 ACFIFMAX[]	= { 29, 29, 29, 29, 29, 29 };
+static const u8 PD2TGT[]	= { 40, 33, 38, 42, 30, 38 };
 
 /*
  * mt2063_set_dnc_output_enable()
@@ -1315,8 +1324,11 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
 	}
 
-	if (status >= 0)
+	if (status >= 0) {
 		state->rcvr_mode = Mode;
+		dprintk(1, "mt2063 mode changed to %s\n",
+			mt2063_mode_name[state->rcvr_mode]);
+	}
 
 	return status;
 }
@@ -2023,6 +2035,8 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 	if (status)
 		*tuner_status = TUNER_STATUS_LOCKED;
 
+	dprintk(1, "Tuner status: %d", *tuner_status);
+
 	return 0;
 }
 
@@ -2092,6 +2106,9 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 	if (status < 0)
 		return status;
 
+	dprintk(1, "Tuning to frequency: %d, bandwidth %d, foffset %d\n",
+		params->frequency, ch_bw, pict2chanb_vsb);
+
 	status = MT2063_Tune(state, (params->frequency + (pict2chanb_vsb + (ch_bw / 2))));
 	if (status < 0)
 		return status;
@@ -2161,6 +2178,9 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 	if (status < 0)
 		return status;
 
+	dprintk(1, "Tuning to frequency: %d, bandwidth %d, foffset %d\n",
+		c->frequency, ch_bw, pict2chanb_vsb);
+
 	status = MT2063_Tune(state, (c->frequency + (pict2chanb_vsb + (ch_bw / 2))));
 
 	if (status < 0)
@@ -2180,6 +2200,9 @@ static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
 		return -ENODEV;
 
 	*freq = state->frequency;
+
+	dprintk(1, "frequency: %d\n", *freq);
+
 	return 0;
 }
 
@@ -2193,6 +2216,9 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 		return -ENODEV;
 
 	*bw = state->AS_Data.f_out_bw - 750000;
+
+	dprintk(1, "bandwidth: %d\n", *bw);
+
 	return 0;
 }
 
-- 
1.7.7.5

