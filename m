Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:44870 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab1FDPDI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:03:08 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsNT-0002mK-Ur
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:03:06 +0200
Message-ID: <4DEA4927.2060007@mailbox.hu>
Date: Sat, 04 Jun 2011 17:03:03 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: implemented power management
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020508080603050407010702"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------020508080603050407010702
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

The following patch implements the xc4000_sleep() function.
The 'no_powerdown' module parameter is now interpreted differently:
  - 0 uses a device-specific default
  - 1 disables power management like before
  - 2 enables power management

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------020508080603050407010702
Content-Type: text/x-patch;
 name="xc4000_powerdown.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_powerdown.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 13:35:59.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 13:57:11.000000000 +0200
@@ -43,9 +43,11 @@
 
 static int no_poweroff;
 module_param(no_poweroff, int, 0644);
-MODULE_PARM_DESC(no_poweroff, "0 (default) powers device off when not used.\n"
-	"\t\t1 keep device energized and with tuner ready all the times.\n"
-	"\t\tFaster, but consumes more power and keeps the device hotter");
+MODULE_PARM_DESC(no_poweroff, "\n\t\t1: keep device energized and with tuner "
+	"ready all the times.\n"
+	"\t\tFaster, but consumes more power and keeps the device hotter.\n"
+	"\t\t2: powers device off when not used.\n"
+	"\t\t0 (default): use device-specific default mode.");
 
 #define XC4000_DEFAULT_FIRMWARE "xc4000.fw"
 
@@ -102,6 +104,7 @@
 /* Misc Defines */
 #define MAX_TV_STANDARD			24
 #define XC_MAX_I2C_WRITE_LENGTH		64
+#define XC_POWERED_DOWN			0x80000000U
 
 /* Signal Types */
 #define XC_RF_MODE_AIR			0
@@ -1365,8 +1368,34 @@
 
 static int xc4000_sleep(struct dvb_frontend *fe)
 {
-	/* FIXME: djh disable this for now... */
-	return XC_RESULT_SUCCESS;
+	struct xc4000_priv *priv = fe->tuner_priv;
+	int	ret = XC_RESULT_SUCCESS;
+
+	dprintk(1, "%s()\n", __func__);
+
+	mutex_lock(&priv->lock);
+
+	/* Avoid firmware reload on slow devices */
+	if ((no_poweroff == 2 ||
+	     (no_poweroff == 0 &&
+	      priv->card_type != XC4000_CARD_WINFAST_CX88)) &&
+	    (priv->cur_fw.type & BASE) != 0) {
+		/* force reset and firmware reload */
+		priv->cur_fw.type = XC_POWERED_DOWN;
+
+		if (xc_write_reg(priv, XREG_POWER_DOWN, 0)
+		    != XC_RESULT_SUCCESS) {
+			printk(KERN_ERR
+			       "xc4000: %s() unable to shutdown tuner\n",
+			       __func__);
+			ret = -EREMOTEIO;
+		}
+		xc_wait(20);
+	}
+
+	mutex_unlock(&priv->lock);
+
+	return ret;
 }
 
 static int xc4000_init(struct dvb_frontend *fe)

--------------020508080603050407010702--
