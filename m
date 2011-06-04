Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:45918 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930Ab1FDPZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:25:23 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsj1-0004Nq-Ml
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:25:21 +0200
Message-ID: <4DEA4E5F.1010206@mailbox.hu>
Date: Sat, 04 Jun 2011 17:25:19 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: detect XC4100
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060200060109020400080704"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------060200060109020400080704
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Added code to detect the XC4100 chip, which is presumably an analog-only
"value" version of the XC4000. It is not sure, however, if any devices
using this have actually been produced and sold, so the patch may be
unneeded.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------060200060109020400080704
Content-Type: text/x-patch;
 name="xc4000_xc4100.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_xc4100.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 16:35:50.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 16:40:09.000000000 +0200
@@ -140,7 +140,8 @@
 
 /* Product id */
 #define XC_PRODUCT_ID_FW_NOT_LOADED	0x2000
-#define XC_PRODUCT_ID_FW_LOADED	0x0FA0
+#define XC_PRODUCT_ID_XC4000		0x0FA0
+#define XC_PRODUCT_ID_XC4100		0x1004
 
 /* Registers (Write-only) */
 #define XREG_INIT         0x00
@@ -1071,7 +1072,9 @@
 #endif
 
 	/* Check that the tuner hardware model remains consistent over time. */
-	if (priv->hwmodel == 0 && hwmodel == 4000) {
+	if (priv->hwmodel == 0 &&
+	    (hwmodel == XC_PRODUCT_ID_XC4000 ||
+	     hwmodel == XC_PRODUCT_ID_XC4100)) {
 		priv->hwmodel = hwmodel;
 		priv->hwvers  = version & 0xff00;
 	} else if (priv->hwmodel == 0 || priv->hwmodel != hwmodel ||
@@ -1678,7 +1681,8 @@
 	}
 
 	switch (id) {
-	case XC_PRODUCT_ID_FW_LOADED:
+	case XC_PRODUCT_ID_XC4000:
+	case XC_PRODUCT_ID_XC4100:
 		printk(KERN_INFO
 			"xc4000: Successfully identified at address 0x%02x\n",
 			cfg->i2c_address);

--------------060200060109020400080704--
