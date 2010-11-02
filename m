Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41694 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0KBVCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 17:02:21 -0400
Received: by wwe15 with SMTP id 15so7831164wwe.1
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 14:02:20 -0700 (PDT)
Subject: [PATCH][UPDATE_for_2.6.37]  DM04/QQBOX Corrected Firmware
 Information.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 21:02:08 +0000
Message-ID: <1288731728.4859.9.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Corrected Firmware Information for LG on LME2510.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>






diff --git a/Documentation/dvb/lmedm04.txt b/Documentation/dvb/lmedm04.txt
old mode 100755
new mode 100644
index e175784..6418865
--- a/Documentation/dvb/lmedm04.txt
+++ b/Documentation/dvb/lmedm04.txt
@@ -46,7 +46,7 @@ and run
 Other LG firmware can be extracted manually from US280D.sys
 only found in windows/system32/driver.
 
-dd if=US280D.sys ibs=1 skip=42616 count=3668 of=dvb-usb-lme2510-lg.fw
+dd if=US280D.sys ibs=1 skip=42360 count=3924 of=dvb-usb-lme2510-lg.fw
 
 for DM04 LME2510C (LG Tuner)
 ---------------------------

