Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:56685 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab1FDPVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 11:21:50 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSsf7-00048L-VS
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 17:21:49 +0200
Message-ID: <4DEA4D6D.5030508@mailbox.hu>
Date: Sat, 04 Jun 2011 17:21:17 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: removed redundant tuner reset
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000009090303050708040506"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------000009090303050708040506
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

This patch causes the tuner reset command to be ignored in the firmware
code, since this only happens when the BASE/INIT1 firmware is loaded by
check_firmware(), and in that case check_firmware() already calls the
reset callback before starting to load the firmware.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------000009090303050708040506
Content-Type: text/x-patch;
 name="xc4000_noreset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_noreset.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-04 16:30:28.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 16:35:17.000000000 +0200
@@ -338,10 +338,12 @@
 		len = i2c_sequence[index] * 256 + i2c_sequence[index+1];
 		if (len == 0x0000) {
 			/* RESET command */
-			result = xc4000_TunerReset(fe);
 			index += 2;
+#if 0			/* not needed, as already called by check_firmware() */
+			result = xc4000_TunerReset(fe);
 			if (result != XC_RESULT_SUCCESS)
 				return result;
+#endif
 		} else if (len & 0x8000) {
 			/* WAIT command */
 			xc_wait(len & 0x7FFF);

--------------000009090303050708040506--
