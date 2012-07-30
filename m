Return-path: <linux-media-owner@vger.kernel.org>
Received: from faith.oztechninja.com ([202.4.233.235]:60908 "EHLO
	faith.oztechninja.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2G3M4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 08:56:49 -0400
Date: Mon, 30 Jul 2012 22:56:47 +1000
From: David Basden <davidb-git@rcpt.to>
To: poma <pomidorabelisima@gmail.com>
Cc: davidb-git@rcpt.to, Thomas Mair <thomas.mair86@googlemail.com>,
	Hans-Frieder Vogt <hfvogt@gmx.net>,
	Antti Palosaari <crope@iki.fi>, mchehab@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: rtl28xxu - rtl2832 frontend attach
Message-ID: <20120730125647.GJ9047@faith.oztechninja.com>
References: <4FB92428.3080201@gmail.com>
 <4FB94F2C.4050905@iki.fi>
 <4FB95E4B.9090006@googlemail.com>
 <4FC0443F.8030004@gmail.com>
 <4FC32233.1040407@googlemail.com>
 <4FC3902D.3090506@googlemail.com>
 <4FE9EEB4.9010005@gmail.com>
 <4FEA9849.5010105@googlemail.com>
 <5016328E.3040909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016328E.3040909@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> >>> Right now I really don't know where I should look for the solution of
> >>> the problem. It seems that the tuner reset does not have any effect on the 
> >>> tuner whatsoever.

Can I suggest setting GPIO5 to 1, leave it there, and see if it breaks. If it
doesn't, GPIO5 on the RTL isn't setup correctly somehow.

At the same time, I was rereading code from:

http://git.linuxtv.org/anttip/media_tree.git/blob/3efd26330fda97e06279cbca170ae4a0dee53220:/drivers/media/dvb/dvb-usb/rtl28xxu.c#l898

and at no point is GPIO5 actually set to an output or enabled that I can find.
rtl2832u_frontend_attach skips doing so. (Actually, I seem to remember running
into this problem while trying to use some DVB driver code as an example of
how to setup the RTL to talk to the FC0012)

Try giving the patch below a go. Sorry, I don't have a build environment to
hand, so there might be a typo I haven't picked up, but the upshot is that 
I'm moving the FC0012 detection to the end, setting up GPIO5, resetting the
tuner and then trying to probe for the FC0012.

Please let me know if this helps :)

David

--- a/rtl28xxu.c	2012-07-30 22:31:53.789638678 +1000
+++ b/rtl28xxu.c	2012-07-30 22:48:35.774607232 +1000
@@ -550,15 +550,6 @@
 
 	priv->tuner = TUNER_NONE;
 
-	/* check FC0012 ID register; reg=00 val=a1 */
-	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
-	if (ret == 0 && buf[0] == 0xa1) {
-		priv->tuner = TUNER_RTL2832_FC0012;
-		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
-		info("%s: FC0012 tuner found", __func__);
-		goto found;
-	}
-
 	/* check FC0013 ID register; reg=00 val=a3 */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0013);
 	if (ret == 0 && buf[0] == 0xa3) {
@@ -640,6 +631,71 @@
 		goto unsupported;
 	}
 
+	/* If it's a FC0012, we need to bring GPIO5/RESET
+	   out of floating or it's not going to show up.
+	   We set GPIO5 to an output, enable the output, then
+	   reset the tuner by bringing GPIO5 high then low again.
+
+	   We're testing this last so that we don't accidentally
+	   mess with other hardware that wouldn't like us messing
+	   with whatever is connected to the rtl2832's GPIO5
+	*/
+
+	/* close demod I2C gate */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_close);
+	if (ret)
+		goto err;
+
+	/* Set GPIO5 to be an output */
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_DIR, &val);
+	if (ret)
+		goto err;
+
+	val &= 0xdf;
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_DIR, val);
+	if (ret)
+		goto err;
+
+	/* enable as output GPIO5 */
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_EN, &val);
+	if (ret)
+		goto err;
+
+	val |= 0x20;
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_EN, val);
+	if (ret)
+		goto err;
+
+	/* set GPIO5 high to reset fc0012 (if it exists) */
+	ret = rtl28xx_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &val);
+	if (ret)
+		goto err;
+
+	val |= 0x20; 
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, val);
+	if (ret)
+		goto err;
+
+	/* bring GPIO5 low again after reset */
+	val &= 0xdf;
+	ret = rtl28xx_wr_reg(adap->dev, SYS_GPIO_OUT_VAL, val);
+	if (ret)
+		goto err;
+
+	/* re-open demod I2C gate */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_open);
+	if (ret)
+		goto err;
+
+	/* check FC0012 ID register; reg=00 val=a1 */
+	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
+	if (ret == 0 && buf[0] == 0xa1) {
+		priv->tuner = TUNER_RTL2832_FC0012;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		info("%s: FC0012 tuner found", __func__);
+		goto found;
+	}
+
 unsupported:
 	/* close demod I2C gate */
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_close);
