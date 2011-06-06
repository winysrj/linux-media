Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:33934 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745Ab1FFP5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 11:57:47 -0400
Received: from [94.248.228.122] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTcBU-0004qP-8x
	for linux-media@vger.kernel.org; Mon, 06 Jun 2011 17:57:46 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] XC4000: auto-select XC4000 tuner
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 17:57:43 +0200
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061757.43827.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Automatically select the xc4000 module for dib0700 if the tuner selection is
not customized.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>

diff -uNr xc4000_orig/drivers/media/dvb/dvb-usb/Kconfig xc4000/drivers/media/dvb/dvb-usb/Kconfig
--- xc4000_orig/drivers/media/dvb/dvb-usb/Kconfig	2011-06-06 14:10:12.000000000 +0200
+++ xc4000/drivers/media/dvb/dvb-usb/Kconfig	2011-06-06 14:43:39.000000000 +0200
@@ -81,6 +81,7 @@
 	select MEDIA_TUNER_MT2266 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_XC4000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Support for USB2.0/1.1 DVB receivers based on the DiB0700 USB bridge. The
