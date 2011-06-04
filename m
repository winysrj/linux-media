Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:36259 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab1FDO4W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 10:56:22 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsGx-0002S0-7N
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 16:56:21 +0200
Message-ID: <4DEA4792.8@mailbox.hu>
Date: Sat, 04 Jun 2011 16:56:18 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: simplified load_scode
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010902010206030006070003"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010902010206030006070003
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Removed unused code from load_scode() (all SCODE firmwares are
assumed to have the HAS_IF bit set).

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------010902010206030006070003
Content-Type: text/x-patch;
 name="xc4000_scode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_scode.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 13:10:37.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 13:19:55.000000000 +0200
@@ -781,8 +781,7 @@
 		p += sizeof(size);
 
 		if (!size || size > endp - p) {
-			printk("Firmware type ");
-			printk("(%x), id %llx is corrupted "
+			printk("Firmware type (%x), id %llx is corrupted "
 			       "(size=%d, expected %d)\n",
 			       type, (unsigned long long)id,
 			       (unsigned)(endp - p), size);
@@ -840,10 +839,10 @@
 			 v4l2_std_id *id, __u16 int_freq, int scode)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
-	int                pos, rc;
-	unsigned char	   *p;
-	u8 scode_buf[13];
-	u8 indirect_mode[5];
+	int		pos, rc;
+	unsigned char	*p;
+	u8		scode_buf[13];
+	u8		indirect_mode[5];
 
 	dprintk(1, "%s called int_freq=%d\n", __func__, int_freq);
 
@@ -863,18 +862,9 @@
 
 	p = priv->firm[pos].ptr;
 
-	if (priv->firm[pos].type & HAS_IF) {
-		if (priv->firm[pos].size != 12 * 16 || scode >= 16)
-			return -EINVAL;
-		p += 12 * scode;
-	} else {
-		/* 16 SCODE entries per file; each SCODE entry is 12 bytes and
-		 * has a 2-byte size header in the firmware format. */
-		if (priv->firm[pos].size != 14 * 16 || scode >= 16 ||
-		    le16_to_cpu(*(__u16 *)(p + 14 * scode)) != 12)
-			return -EINVAL;
-		p += 14 * scode + 2;
-	}
+	if (priv->firm[pos].size != 12 * 16 || scode >= 16)
+		return -EINVAL;
+	p += 12 * scode;
 
 	tuner_info("Loading SCODE for type=");
 	dump_firm_type_and_int_freq(priv->firm[pos].type,

--------------010902010206030006070003--
