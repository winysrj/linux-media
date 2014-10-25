Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu004-omc3s13.hotmail.com ([65.55.116.88]:56298 "EHLO
	BLU004-OMC3S13.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbaJYURi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Oct 2014 16:17:38 -0400
Message-ID: <BLU437-SMTP74BE1F144D7E1FA3B30A30BA900@phx.gbl>
From: Michael Krufky <mkrufky@hotmail.com>
To: linux-media <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 3/3] au8522: improve lock performance with ZeeVee modulators
Date: Sat, 25 Oct 2014 16:17:23 -0400
In-Reply-To: <1414268243-29514-1-git-send-email-mkrufky@linuxtv.org>
References: <1414268243-29514-1-git-send-email-mkrufky@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Richard Vollkommer <linux@hauppauge.com>

Improves lock performance with signals from the ZeeVee family
of modulators.

Signed-off-by: Richard Vollkommer <linux@hauppauge.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb-frontends/au8522_dig.c | 117 +++++++++++++++++++++++++++++--
 1 file changed, 110 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index a68974f..5d06c99 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -29,6 +29,7 @@
 #include "au8522_priv.h"
 
 static int debug;
+static int zv_mode = 1; /* default to on */
 
 #define dprintk(arg...)\
 	do { if (debug)\
@@ -469,6 +470,87 @@ static struct {
 	{ 0x8526, 0x01 },
 };
 
+static struct {
+	u16 reg;
+	u16 data;
+} QAM256_mod_tab_zv_mode[] = {
+	{ 0x80a3, 0x09 },
+	{ 0x80a4, 0x00 },
+	{ 0x8081, 0xc4 },
+	{ 0x80a5, 0x40 },
+	{ 0x80b5, 0xfb },
+	{ 0x80b6, 0x8e },
+	{ 0x80b7, 0x39 },
+	{ 0x80aa, 0x77 },
+	{ 0x80ad, 0x77 },
+	{ 0x80a6, 0x67 },
+	{ 0x8262, 0x20 },
+	{ 0x821c, 0x30 },
+	{ 0x80b8, 0x3e },
+	{ 0x80b9, 0xf0 },
+	{ 0x80ba, 0x01 },
+	{ 0x80bb, 0x18 },
+	{ 0x80bc, 0x50 },
+	{ 0x80bd, 0x00 },
+	{ 0x80be, 0xea },
+	{ 0x80bf, 0xef },
+	{ 0x80c0, 0xfc },
+	{ 0x80c1, 0xbd },
+	{ 0x80c2, 0x1f },
+	{ 0x80c3, 0xfc },
+	{ 0x80c4, 0xdd },
+	{ 0x80c5, 0xaf },
+	{ 0x80c6, 0x00 },
+	{ 0x80c7, 0x38 },
+	{ 0x80c8, 0x30 },
+	{ 0x80c9, 0x05 },
+	{ 0x80ca, 0x4a },
+	{ 0x80cb, 0xd0 },
+	{ 0x80cc, 0x01 },
+	{ 0x80cd, 0xd9 },
+	{ 0x80ce, 0x6f },
+	{ 0x80cf, 0xf9 },
+	{ 0x80d0, 0x70 },
+	{ 0x80d1, 0xdf },
+	{ 0x80d2, 0xf7 },
+	{ 0x80d3, 0xc2 },
+	{ 0x80d4, 0xdf },
+	{ 0x80d5, 0x02 },
+	{ 0x80d6, 0x9a },
+	{ 0x80d7, 0xd0 },
+	{ 0x8250, 0x0d },
+	{ 0x8251, 0xcd },
+	{ 0x8252, 0xe0 },
+	{ 0x8253, 0x05 },
+	{ 0x8254, 0xa7 },
+	{ 0x8255, 0xff },
+	{ 0x8256, 0xed },
+	{ 0x8257, 0x5b },
+	{ 0x8258, 0xae },
+	{ 0x8259, 0xe6 },
+	{ 0x825a, 0x3d },
+	{ 0x825b, 0x0f },
+	{ 0x825c, 0x0d },
+	{ 0x825d, 0xea },
+	{ 0x825e, 0xf2 },
+	{ 0x825f, 0x51 },
+	{ 0x8260, 0xf5 },
+	{ 0x8261, 0x06 },
+	{ 0x821a, 0x01 },
+	{ 0x8546, 0x40 },
+	{ 0x8210, 0x26 },
+	{ 0x8211, 0xf6 },
+	{ 0x8212, 0x84 },
+	{ 0x8213, 0x02 },
+	{ 0x8502, 0x01 },
+	{ 0x8121, 0x04 },
+	{ 0x8122, 0x04 },
+	{ 0x852e, 0x10 },
+	{ 0x80a4, 0xca },
+	{ 0x80a7, 0x40 },
+	{ 0x8526, 0x01 },
+};
+
 static int au8522_enable_modulation(struct dvb_frontend *fe,
 				    fe_modulation_t m)
 {
@@ -495,12 +577,23 @@ static int au8522_enable_modulation(struct dvb_frontend *fe,
 		au8522_set_if(fe, state->config->qam_if);
 		break;
 	case QAM_256:
-		dprintk("%s() QAM 256\n", __func__);
-		for (i = 0; i < ARRAY_SIZE(QAM256_mod_tab); i++)
-			au8522_writereg(state,
-				QAM256_mod_tab[i].reg,
-				QAM256_mod_tab[i].data);
-		au8522_set_if(fe, state->config->qam_if);
+		if (zv_mode) {
+			dprintk("%s() QAM 256 (zv_mode)\n", __func__);
+			for (i = 0; i < ARRAY_SIZE(QAM256_mod_tab_zv_mode); i++)
+				au8522_writereg(state,
+					QAM256_mod_tab_zv_mode[i].reg,
+					QAM256_mod_tab_zv_mode[i].data);
+			au8522_set_if(fe, state->config->qam_if);
+			msleep(100);
+			au8522_writereg(state, 0x821a, 0x00);
+		} else {
+			dprintk("%s() QAM 256\n", __func__);
+			for (i = 0; i < ARRAY_SIZE(QAM256_mod_tab); i++)
+				au8522_writereg(state,
+					QAM256_mod_tab[i].reg,
+					QAM256_mod_tab[i].data);
+			au8522_set_if(fe, state->config->qam_if);
+		}
 		break;
 	default:
 		dprintk("%s() Invalid modulation\n", __func__);
@@ -537,7 +630,12 @@ static int au8522_set_frontend(struct dvb_frontend *fe)
 		return ret;
 
 	/* Allow the tuner to settle */
-	msleep(100);
+	if (zv_mode) {
+		dprintk("%s() increase tuner settling time for zv_mode\n",
+			__func__);
+		msleep(250);
+	} else
+		msleep(100);
 
 	au8522_enable_modulation(fe, c->modulation);
 
@@ -823,6 +921,11 @@ static struct dvb_frontend_ops au8522_ops = {
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Enable verbose debug messages");
 
+module_param(zv_mode, int, 0644);
+MODULE_PARM_DESC(zv_mode, "Turn on/off ZeeVee modulator compatability mode (default:on).\n"
+	"\t\ton - modified AU8522 QAM256 initialization.\n"
+	"\t\tProvides faster lock when using ZeeVee modulator based sources");
+
 MODULE_DESCRIPTION("Auvitek AU8522 QAM-B/ATSC Demodulator driver");
 MODULE_AUTHOR("Steven Toth");
 MODULE_LICENSE("GPL");
-- 
1.9.1

