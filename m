Return-path: <linux-media-owner@vger.kernel.org>
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:38650 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3BELSz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 06:18:55 -0500
Received: from localhost (localhost [127.0.0.1])
	by filtteri1.pp.htv.fi (Postfix) with ESMTP id 0CF2E21B7B6
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 13:08:44 +0200 (EET)
Received: from smtp5.welho.com ([213.243.153.39])
	by localhost (filtteri1.pp.htv.fi [213.243.153.184]) (amavisd-new, port 10024)
	with ESMTP id O9khESyo8Tjp for <linux-media@vger.kernel.org>;
	Tue,  5 Feb 2013 13:08:43 +0200 (EET)
Received: from cs78145022.pp.htv.fi (cs78145022.pp.htv.fi [62.78.145.22])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp5.welho.com (Postfix) with ESMTPS id 197905BC003
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 13:08:43 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by cs78145022.pp.htv.fi (Postfix) with ESMTP id 8838CB3A
	for <linux-media@vger.kernel.org>; Tue,  5 Feb 2013 13:08:42 +0200 (EET)
Date: Tue, 5 Feb 2013 13:08:42 +0200 (EET)
From: Matti Kurkela <Matti.Kurkela@iki.fi>
To: linux-media@vger.kernel.org
Subject: ttusb2: Kconfig patch to auto-select frontends for TechnoTrend
 CT-3650
Message-ID: <alpine.DEB.2.00.1302051252001.23479@melchior.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The ttusb2 module is already updated to recognize the TechnoTrend CT-3650 
CI DVB C/T USB2.0 receiver in addition to the Pinnacle 400e. But if 
MEDIA_SUBDRV_AUTOSELECT is used, the required tuner and demodulator 
modules are not automatically selected. Here's a patch to fix that and add a 
note of the CT-3650 to the online help of the ttusb2 module.

This patch applies cleanly to 3.7.6 and other 3.7.x kernels.

--- drivers/media/usb/dvb-usb/Kconfig~	2013-01-21 21:45:40.000000000 +0200
+++ drivers/media/usb/dvb-usb/Kconfig	2013-01-23 17:51:26.000000000 +0200
@@ -202,8 +202,12 @@
  	select DVB_TDA10086 if MEDIA_SUBDRV_AUTOSELECT
  	select DVB_LNBP21 if MEDIA_SUBDRV_AUTOSELECT
  	select DVB_TDA826X if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10023 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TDA10048 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA827X if MEDIA_SUBDRV_AUTOSELECT
  	help
-	  Say Y here to support the Pinnacle 400e DVB-S USB2.0 receiver. The
+	  Say Y here to support the Pinnacle 400e DVB-S USB2.0 receiver and
+	  the TechnoTrend CT-3650 CI DVB-C/T USB2.0 receiver. The
  	  firmware protocol used by this module is similar to the one used by the
  	  old ttusb-driver - that's why the module is called dvb-usb-ttusb2.


-- 
Matti.Kurkela (at) iki.fi (tai welho.com)
Puhelin 050 566 5564
