Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaCCUmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 15:42:38 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 1/2] tda18212: add support for ATSC and clearQAM on tda18272
Date: Mon,  3 Mar 2014 17:41:53 -0300
Message-Id: <1393879314-2080-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tda18272 is programmed just like tda18212, but it also
supports ClearQAM and ATSC.

Add support for them. Tested with a Kworld UB435-Q on both
8VSB and 256QAM modes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tda18212.c | 12 ++++++++++++
 drivers/media/tuners/tda18212.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index abe256e1f843..05a4ac9edb6b 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -150,6 +150,8 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 	#define DVBT2_8  5
 	#define DVBC_6   6
 	#define DVBC_8   7
+	#define ATSC_VSB 8
+	#define ATSC_QAM 9
 	static const u8 bw_params[][3] = {
 		     /* reg:   0f    13    23 */
 		[DVBT_6]  = { 0xb3, 0x20, 0x03 },
@@ -160,6 +162,8 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		[DVBT2_8] = { 0xbc, 0x22, 0x01 },
 		[DVBC_6]  = { 0x92, 0x50, 0x03 },
 		[DVBC_8]  = { 0x92, 0x53, 0x03 },
+		[ATSC_VSB] = { 0x7d, 0x20, 0x63 },
+		[ATSC_QAM] = { 0x7d, 0x20, 0x63 },
 	};
 
 	dev_dbg(&priv->i2c->dev,
@@ -171,6 +175,14 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
 
 	switch (c->delivery_system) {
+	case SYS_ATSC:
+		if_khz = priv->cfg->if_atsc_vsb;
+		i = ATSC_VSB;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		if_khz = priv->cfg->if_atsc_qam;
+		i = ATSC_QAM;
+		break;
 	case SYS_DVBT:
 		switch (c->bandwidth_hz) {
 		case 6000000:
diff --git a/drivers/media/tuners/tda18212.h b/drivers/media/tuners/tda18212.h
index 7e0d503baf05..c36b49e4b274 100644
--- a/drivers/media/tuners/tda18212.h
+++ b/drivers/media/tuners/tda18212.h
@@ -35,6 +35,8 @@ struct tda18212_config {
 	u16 if_dvbt2_7;
 	u16 if_dvbt2_8;
 	u16 if_dvbc;
+	u16 if_atsc_vsb;
+	u16 if_atsc_qam;
 };
 
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18212)
-- 
1.8.5.3

