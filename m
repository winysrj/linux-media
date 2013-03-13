Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52296 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3CMEXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 00:23:42 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so650280lab.19
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 21:23:40 -0700 (PDT)
Date: Wed, 13 Mar 2013 14:23:36 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>
Subject: [PATCH] xc5000: fix incorrect debug printnk
Message-ID: <20130313142336.63cc4d55@glory.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I found very small bag in xc5000 source.

When set option debug=1 and listen a radio we see in dmesg

xc5000: xc_SetTVStandard() Standard = M/N-NTSC/PAL-BTSC

at all time.

But true value is "FM Radio-INPUT1_MONO".

It happens because in function xc5000_set_radio_freq get correct value VideoMode and AudioMode for radio and
call xc_SetTVStandard where name of standard get from incorrect place priv->video_standard .

This incorrect debug message do debugging little difficult.

I found very small bag in xc5000 source.

When set option debug=1 and listen a radio we see in dmesg

xc5000: xc_SetTVStandard() Standard = M/N-NTSC/PAL-BTSC

at all time.

But true value is "FM Radio-INPUT1_MONO".

It happens because in function xc5000_set_radio_freq get correct value VideoMode and AudioMode for radio and
call xc_SetTVStandard where name of standard get from incorrect place priv->video_standard .

This incorrect debug message do debugging little difficult.

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index d6be1b6..5cd09a6 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -422,13 +422,19 @@ static int xc_initialize(struct xc5000_priv *priv)
 }
 
 static int xc_SetTVStandard(struct xc5000_priv *priv,
-	u16 VideoMode, u16 AudioMode)
+	u16 VideoMode, u16 AudioMode, u8 RadioMode)
 {
 	int ret;
 	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, VideoMode, AudioMode);
-	dprintk(1, "%s() Standard = %s\n",
-		__func__,
-		XC5000_Standard[priv->video_standard].Name);
+	if (RadioMode) {
+		dprintk(1, "%s() Standard = %s\n",
+			__func__,
+			XC5000_Standard[RadioMode].Name);
+	} else {
+		dprintk(1, "%s() Standard = %s\n",
+			__func__,
+			XC5000_Standard[priv->video_standard].Name);
+	}
 
 	ret = xc_write_reg(priv, XREG_VIDEO_MODE, VideoMode);
 	if (ret == XC_RESULT_SUCCESS)
@@ -824,7 +830,7 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 
 	ret = xc_SetTVStandard(priv,
 		XC5000_Standard[priv->video_standard].VideoMode,
-		XC5000_Standard[priv->video_standard].AudioMode);
+		XC5000_Standard[priv->video_standard].AudioMode, 0);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
 		return -EREMOTEIO;
@@ -940,7 +946,7 @@ tune_channel:
 
 	ret = xc_SetTVStandard(priv,
 		XC5000_Standard[priv->video_standard].VideoMode,
-		XC5000_Standard[priv->video_standard].AudioMode);
+		XC5000_Standard[priv->video_standard].AudioMode, 0);
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
 		return -EREMOTEIO;
@@ -1003,7 +1009,7 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 	priv->rf_mode = XC_RF_MODE_AIR;
 
 	ret = xc_SetTVStandard(priv, XC5000_Standard[radio_input].VideoMode,
-			       XC5000_Standard[radio_input].AudioMode);
+			       XC5000_Standard[radio_input].AudioMode, radio_input);
 
 	if (ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");


Signed-off-by: Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.
