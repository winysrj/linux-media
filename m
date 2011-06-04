Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:56561 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1FDPSp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:18:45 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSscc-0003r0-DT
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:18:45 +0200
Message-ID: <4DEA4CD1.1040003@mailbox.hu>
Date: Sat, 04 Jun 2011 17:18:41 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: xc_tune_channel() cleanup
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060302090208030409020407"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------060302090208030409020407
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Minor coding changes related to the xc_tune_channel() function.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------060302090208030409020407
Content-Type: text/x-patch;
 name="xc4000_tune.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_tune.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 16:22:18.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 16:29:34.000000000 +0200
@@ -516,12 +516,10 @@
 	return lockState;
 }
 
-#define XC_TUNE_ANALOG  0
-#define XC_TUNE_DIGITAL 1
-static int xc_tune_channel(struct xc4000_priv *priv, u32 freq_hz, int mode)
+static int xc_tune_channel(struct xc4000_priv *priv, u32 freq_hz)
 {
-	int	found = 0;
-	int	result = 0;
+	int	found = 1;
+	int	result;
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
@@ -533,9 +531,10 @@
 	if (result != XC_RESULT_SUCCESS)
 		return 0;
 
-	if (mode == XC_TUNE_ANALOG) {
-		if (WaitForLock(priv) == 1)
-			found = 1;
+	/* wait for lock only in analog TV mode */
+	if ((priv->cur_fw.type & (FM | DTV6 | DTV7 | DTV78 | DTV8)) == 0) {
+		if (WaitForLock(priv) != 1)
+			found = 0;
 	}
 
 	/* Wait for stats to stabilize.
@@ -1269,7 +1268,7 @@
 		}
 	}
 
-	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_DIGITAL);
+	xc_tune_channel(priv, priv->freq_hz);
 
 	ret = 0;
 
@@ -1468,7 +1467,7 @@
 		}
 	}
 
-	xc_tune_channel(priv, priv->freq_hz, XC_TUNE_ANALOG);
+	xc_tune_channel(priv, priv->freq_hz);
 
 	ret = 0;
 

--------------060302090208030409020407--
