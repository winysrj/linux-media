Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.216.173]:63239 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZK1Lg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 06:36:28 -0500
Received: by mail-px0-f173.google.com with SMTP id 3so1633943pxi.22
        for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 03:36:34 -0800 (PST)
Message-ID: <4B110B3F.6020409@gmail.com>
Date: Sat, 28 Nov 2009 19:36:31 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: [PATCH] atbm8830: use AGC setting from config
Content-Type: multipart/mixed;
 boundary="------------050108020706010403070703"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050108020706010403070703
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   This patch improves ATBM8830 reception by using per card AGC 
configuration rather than register default.

Regards,
David

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>


--------------050108020706010403070703
Content-Type: text/x-patch;
 name="atbm8830_agc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atbm8830_agc.patch"

diff --git a/linux/drivers/media/dvb/dvb-usb/cxusb.c b/linux/drivers/media/dvb/dvb-usb/cxusb.c
--- a/linux/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1187,6 +1187,9 @@
 	.osc_clk_freq = 30400, /* in kHz */
 	.if_freq = 0, /* zero IF */
 	.zif_swap_iq = 1,
+	.agc_min = 0x2E,
+	.agc_max = 0x90,
+	.agc_hold_loop = 0,
 };
 
 static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
diff --git a/linux/drivers/media/dvb/frontends/atbm8830.c b/linux/drivers/media/dvb/frontends/atbm8830.c
--- a/linux/drivers/media/dvb/frontends/atbm8830.c
+++ b/linux/drivers/media/dvb/frontends/atbm8830.c
@@ -164,6 +164,10 @@
 static int set_agc_config(struct atbm_state *priv,
 	u8 min, u8 max, u8 hold_loop)
 {
+	/* no effect if both min and max are zero */
+	if (!min && !max)
+	    return 0;
+
 	atbm8830_write_reg(priv, REG_AGC_MIN, min);
 	atbm8830_write_reg(priv, REG_AGC_MAX, max);
 	atbm8830_write_reg(priv, REG_AGC_HOLD_LOOP, hold_loop);
@@ -227,11 +231,9 @@
 	/*Set IF frequency*/
 	set_if_freq(priv, cfg->if_freq);
 
-#if 0
 	/*Set AGC Config*/
 	set_agc_config(priv, cfg->agc_min, cfg->agc_max,
 		cfg->agc_hold_loop);
-#endif
 
 	/*Set static channel mode*/
 	set_static_channel_mode(priv);
diff --git a/linux/drivers/media/video/cx23885/cx23885-dvb.c b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c
@@ -555,6 +555,9 @@
 	.osc_clk_freq = 30400, /* in kHz */
 	.if_freq = 0, /* zero IF */
 	.zif_swap_iq = 1,
+	.agc_min = 0x2E,
+	.agc_max = 0xFF,
+	.agc_hold_loop = 0,
 };
 
 static struct max2165_config mygic_x8558pro_max2165_cfg1 = {
@@ -571,6 +574,9 @@
 	.osc_clk_freq = 30400, /* in kHz */
 	.if_freq = 0, /* zero IF */
 	.zif_swap_iq = 1,
+	.agc_min = 0x2E,
+	.agc_max = 0xFF,
+	.agc_hold_loop = 0,
 };
 
 static struct max2165_config mygic_x8558pro_max2165_cfg2 = {

--------------050108020706010403070703--
