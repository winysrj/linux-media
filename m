Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:52836 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800Ab1FFQAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 12:00:23 -0400
Received: from [94.248.228.122] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTcDy-00053f-1A
	for linux-media@vger.kernel.org; Mon, 06 Jun 2011 18:00:22 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] XC4000: check firmware version
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 18:00:17 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061800.17374.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Enabled code to check if the version of the firmware reported by the hardware
is correct after uploading it.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-06 14:40:53.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-06 15:01:25.000000000 +0200
@@ -919,7 +919,7 @@
 	struct xc4000_priv         *priv = fe->tuner_priv;
 	struct firmware_properties new_fw;
 	int			   rc = 0, is_retry = 0;
-	u16			   version = 0, hwmodel;
+	u16			   hwmodel;
 	v4l2_std_id		   std0;
 	u8			   hw_major, hw_minor, fw_major, fw_minor;
 
@@ -1032,23 +1032,23 @@
 		hwmodel, hw_major, hw_minor, fw_major, fw_minor);
 
 	/* Check firmware version against what we downloaded. */
-#ifdef DJH_DEBUG
-	if (priv->firm_version != ((version & 0xf0) << 4 | (version & 0x0f))) {
-		printk("Incorrect readback of firmware version %x.\n",
-		       (version & 0xff));
+	if (priv->firm_version != ((fw_major << 8) | fw_minor)) {
+		printk(KERN_WARNING
+		       "Incorrect readback of firmware version %d.%d.\n",
+		       fw_major, fw_minor);
 		goto fail;
 	}
-#endif
 
 	/* Check that the tuner hardware model remains consistent over time. */
 	if (priv->hwmodel == 0 &&
 	    (hwmodel == XC_PRODUCT_ID_XC4000 ||
 	     hwmodel == XC_PRODUCT_ID_XC4100)) {
 		priv->hwmodel = hwmodel;
-		priv->hwvers  = version & 0xff00;
+		priv->hwvers = (hw_major << 8) | hw_minor;
 	} else if (priv->hwmodel == 0 || priv->hwmodel != hwmodel ||
-		   priv->hwvers != (version & 0xff00)) {
-		printk("Read invalid device hardware information - tuner "
+		   priv->hwvers != ((hw_major << 8) | hw_minor)) {
+		printk(KERN_WARNING
+		       "Read invalid device hardware information - tuner "
 		       "hung?\n");
 		goto fail;
 	}
