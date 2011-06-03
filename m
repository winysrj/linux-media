Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:55484 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1FCP1d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 11:27:33 -0400
Received: from [94.248.227.103]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSWHa-0003KO-Q6
	for linux-media@vger.kernel.org; Fri, 03 Jun 2011 17:27:32 +0200
Message-ID: <4DE8FD62.406@mailbox.hu>
Date: Fri, 03 Jun 2011 17:27:30 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: fixed frequency error
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080703060100050808070204"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------080703060100050808070204
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The xc_get_frequency_error() function reported the frequency error
incorrectly. The data read from the hardware is a signed integer, in
15625 Hz units. The attached patch fixes the bug.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------080703060100050808070204
Content-Type: text/x-patch;
 name="xc4000_freqerr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_freqerr.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-03 17:09:54.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-03 17:14:12.000000000 +0200
@@ -418,8 +418,9 @@
 	if (result != XC_RESULT_SUCCESS)
 		return result;
 
-	tmp = (u32)regData;
-	(*freq_error_hz) = (tmp * 15625) / 1000;
+	tmp = (u32)regData & 0xFFFFU;
+	tmp = (tmp < 0x8000U ? tmp : 0x10000U - tmp);
+	(*freq_error_hz) = tmp * 15625;
 	return result;
 }
 

--------------080703060100050808070204--
