Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:51718 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1FCPSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 11:18:06 -0400
Received: from [94.248.227.103]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSW8P-0002ai-7X
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 17:18:03 +0200
Message-ID: <4DE8FB27.5060804@mailbox.hu>
Date: Fri, 03 Jun 2011 17:17:59 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: added support for 7 MHz DVB-T
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070808070100080106040100"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------070808070100080106040100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The following patch implements support for DVB-T with 7 MHz bandwidth.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------070808070100080106040100
Content-Type: text/x-patch;
 name="xc4000_dtv7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_dtv7.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-03 15:47:04.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-03 16:34:25.000000000 +0200
@@ -1183,15 +1183,28 @@
 			type = DTV6;
 			break;
 		case BANDWIDTH_7_MHZ:
-			printk(KERN_ERR "xc4000 bandwidth 7MHz not supported\n");
+			priv->bandwidth = BANDWIDTH_7_MHZ;
+			priv->video_standard = XC4000_DTV7;
+			priv->freq_hz = params->frequency - 2250000;
 			type = DTV7;
-			return -EINVAL;
+			break;
 		case BANDWIDTH_8_MHZ:
 			priv->bandwidth = BANDWIDTH_8_MHZ;
 			priv->video_standard = XC4000_DTV8;
 			priv->freq_hz = params->frequency - 2750000;
 			type = DTV8;
 			break;
+		case BANDWIDTH_AUTO:
+			if (params->frequency < 400000000) {
+				priv->bandwidth = BANDWIDTH_7_MHZ;
+				priv->freq_hz = params->frequency - 2250000;
+			} else {
+				priv->bandwidth = BANDWIDTH_8_MHZ;
+				priv->freq_hz = params->frequency - 2750000;
+			}
+			priv->video_standard = XC4000_DTV7_8;
+			type = DTV78;
+			break;
 		default:
 			printk(KERN_ERR "xc4000 bandwidth not set!\n");
 			return -EINVAL;

--------------070808070100080106040100--
