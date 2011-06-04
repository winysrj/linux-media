Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:55001 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490Ab1FDPEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:04:55 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsPE-0002pl-51
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:04:54 +0200
Message-ID: <4DEA4993.1060906@mailbox.hu>
Date: Sat, 04 Jun 2011 17:04:51 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: firmware initialization
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020209090208020901040403"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------020209090208020901040403
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

This patch fixes/cleans up the loading of the firmware file when the
driver is loaded and initialized.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------020209090208020901040403
Content-Type: text/x-patch;
 name="xc4000_fwinit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_fwinit.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 13:58:03.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 14:12:06.000000000 +0200
@@ -1400,21 +1400,8 @@
 
 static int xc4000_init(struct dvb_frontend *fe)
 {
-	struct xc4000_priv *priv = fe->tuner_priv;
-	int	ret;
 	dprintk(1, "%s()\n", __func__);
 
-	mutex_lock(&priv->lock);
-	ret = check_firmware(fe, DTV8, 0, priv->if_khz);
-	mutex_unlock(&priv->lock);
-	if (ret != XC_RESULT_SUCCESS) {
-		printk(KERN_ERR "xc4000: Unable to initialise tuner\n");
-		return -EREMOTEIO;
-	}
-
-	if (debug)
-		xc_debug_dump(priv);
-
 	return 0;
 }
 
@@ -1511,8 +1498,14 @@
 	   instance of the driver has loaded the firmware.
 	 */
 
-	if (xc4000_readreg(priv, XREG_PRODUCT_ID, &id) != XC_RESULT_SUCCESS)
+	if (instance == 1) {
+		if (xc4000_readreg(priv, XREG_PRODUCT_ID, &id)
+		    != XC_RESULT_SUCCESS)
 			goto fail;
+	} else {
+		id = ((priv->cur_fw.type & BASE) != 0 ?
+		      priv->hwmodel : XC_PRODUCT_ID_FW_NOT_LOADED);
+	}
 
 	switch (id) {
 	case XC_PRODUCT_ID_FW_LOADED:
@@ -1541,16 +1534,19 @@
 	memcpy(&fe->ops.tuner_ops, &xc4000_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 
-	/* FIXME: For now, load the firmware at startup.  We will remove this
-	   before the code goes to production... */
-	mutex_lock(&priv->lock);
-	check_firmware(fe, DTV8, 0, priv->if_khz);
-	mutex_unlock(&priv->lock);
+	if (instance == 1) {
+		int	ret;
+		mutex_lock(&priv->lock);
+		ret = xc4000_fwupload(fe);
+		mutex_unlock(&priv->lock);
+		if (ret != XC_RESULT_SUCCESS)
+			goto fail2;
+	}
 
 	return fe;
 fail:
 	mutex_unlock(&xc4000_list_mutex);
-
+fail2:
 	xc4000_release(fe);
 	return NULL;
 }

--------------020209090208020901040403--
