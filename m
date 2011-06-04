Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:44665 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab1FDPAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:00:05 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsKR-0002ZB-15
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:00:03 +0200
Message-ID: <4DEA486A.4020404@mailbox.hu>
Date: Sat, 04 Jun 2011 16:59:54 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: check_firmware() cleanup
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040806010002010708050504"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------040806010002010708050504
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

This patch makes the following fixes in check_firmware():
  - there is only one BASE and INIT1 firmware for XC4000
  - loading SCODE is needed also for FM radio

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------040806010002010708050504
Content-Type: text/x-patch;
 name="xc4000_checkfw.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_checkfw.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 13:23:07.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 13:34:17.000000000 +0200
@@ -904,7 +904,7 @@
 	struct xc4000_priv         *priv = fe->tuner_priv;
 	struct firmware_properties new_fw;
 	int			   rc = 0, is_retry = 0;
-	u16			   version, hwmodel;
+	u16			   version = 0, hwmodel;
 	v4l2_std_id		   std0;
 	u8			   hw_major, hw_minor, fw_major, fw_minor;
 
@@ -946,8 +946,7 @@
 	}
 
 	/* No need to reload base firmware if it matches */
-	if (((BASE | new_fw.type) & BASE_TYPES) ==
-	    (priv->cur_fw.type & BASE_TYPES)) {
+	if (priv->cur_fw.type & BASE) {
 		dprintk(1, "BASE firmware not changed.\n");
 		goto skip_base;
 	}
@@ -962,7 +961,7 @@
 
 	/* BASE firmwares are all std0 */
 	std0 = 0;
-	rc = load_firmware(fe, BASE | new_fw.type, &std0);
+	rc = load_firmware(fe, BASE, &std0);
 	if (rc < 0) {
 		printk("Error %d while loading base firmware\n", rc);
 		goto fail;
@@ -971,10 +970,9 @@
 	/* Load INIT1, if needed */
 	dprintk(1, "Load init1 firmware, if exists\n");
 
-	rc = load_firmware(fe, BASE | INIT1 | new_fw.type, &std0);
+	rc = load_firmware(fe, BASE | INIT1, &std0);
 	if (rc == -ENOENT)
-		rc = load_firmware(fe, (BASE | INIT1 | new_fw.type) & ~F8MHZ,
-				   &std0);
+		rc = load_firmware(fe, BASE | INIT1, &std0);
 	if (rc < 0 && rc != -ENOENT) {
 		tuner_err("Error %d while loading init1 firmware\n",
 			  rc);
@@ -1008,9 +1006,6 @@
 		goto check_device;
 	}
 
-	if (new_fw.type & FM)
-		goto check_device;
-
 	/* Load SCODE firmware, if exists */
 	rc = load_scode(fe, new_fw.type | new_fw.scode_table, &new_fw.id,
 			new_fw.int_freq, new_fw.scode_nr);

--------------040806010002010708050504--
