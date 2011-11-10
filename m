Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1KJXfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:35:42 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:35:42 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 24/25] modified em28xx-dvb for pctv80e support
Date: Thu, 10 Nov 2011 17:31:44 -0600
Message-Id: <1320967905-7932-25-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/video/em28xx/em28xx-dvb.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index cef7a2d..b69e5f3 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -36,6 +36,7 @@
 #include "mt352.h"
 #include "mt352_priv.h" /* FIXME */
 #include "tda1002x.h"
+#include "drx39xxj.h"
 #include "tda18271.h"
 #include "s921.h"
 #include "drxd.h"
@@ -309,6 +310,20 @@ static struct drxd_config em28xx_drxd = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
+
+static struct tda18271_std_map drx_j_std_map = {
+	.atsc_6   = { .if_freq = 5000, .agc_mode = 3, .std = 0, .if_lvl = 1,
+			.rfagc_top = 0x37, },
+	.qam_6    = { .if_freq = 5380, .agc_mode = 3, .std = 3, .if_lvl = 1,
+			.rfagc_top = 0x37, },
+};
+
+static struct tda18271_config pinnacle_80e_dvb_config = {
+	.std_map = &drx_j_std_map,
+	.gate    = TDA18271_GATE_DIGITAL,
+	.role    = TDA18271_MASTER,
+};
+
 struct drxk_config terratec_h5_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
@@ -625,6 +640,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 {
 	int result = 0, mfe_shared = 0;
 	struct em28xx_dvb *dvb;
+	struct dvb_frontend *fe;
 
 	if (!dev->board.has_dvb) {
 		/* This device does not support the extension */
@@ -752,6 +768,15 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 		}
 		break;
+	case EM2874_BOARD_PCTV_HD_MINI_80E:
+		dvb->fe[0] = dvb_attach(drx39xxj_attach, &dev->i2c_adap);
+		if (dvb->fe[0] != NULL) {
+			fe = dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+					&dev->i2c_adap,
+					&pinnacle_80e_dvb_config);
+			printk(KERN_ERR "dvb_attach tuner result=%p\n", fe);
+		}
+		break;
 	case EM2870_BOARD_KWORLD_A340:
 		dvb->fe[0] = dvb_attach(lgdt3305_attach,
 					   &em2870_lgdt3304_dev,
-- 
1.7.5.4

