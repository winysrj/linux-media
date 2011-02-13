Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40793 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1BMBi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 20:38:59 -0500
Received: by wyb28 with SMTP id 28so3701233wyb.19
        for <linux-media@vger.kernel.org>; Sat, 12 Feb 2011 17:38:58 -0800 (PST)
Subject: [PATCH 2/2] DM04 LME2510(C) Sharp BS2F7HZ0194 Firmware Information
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 01:38:47 +0000
Message-ID: <1297561127.24985.8.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

DM04 LME2510(C) Sharp BS2F7HZ0194 Firmware Information

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 Documentation/dvb/lmedm04.txt |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/dvb/lmedm04.txt b/Documentation/dvb/lmedm04.txt
index 6418865..10b5f04 100644
--- a/Documentation/dvb/lmedm04.txt
+++ b/Documentation/dvb/lmedm04.txt
@@ -4,7 +4,7 @@ following file(s) to this directory.
 for DM04+/QQBOX LME2510C (Sharp 7395 Tuner)
 -------------------------------------------
 
-The Sharp 7395 driver can be found in windows/system32/driver
+The Sharp 7395 driver can be found in windows/system32/drivers
 
 US2A0D.sys (dated 17 Mar 2009)
 
@@ -44,7 +44,7 @@ and run
 
 
 Other LG firmware can be extracted manually from US280D.sys
-only found in windows/system32/driver.
+only found in windows/system32/drivers
 
 dd if=US280D.sys ibs=1 skip=42360 count=3924 of=dvb-usb-lme2510-lg.fw
 
@@ -55,4 +55,16 @@ dd if=US280D.sys ibs=1 skip=35200 count=3850 of=dvb-usb-lme2510c-lg.fw
 
 ---------------------------------------------------------------------
 
+The Sharp 0194 tuner driver can be found in windows/system32/drivers
+
+US290D.sys (dated 09 Apr 2009)
+
+For LME2510
+dd if=US290D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-s0194.fw
+
+
+For LME2510C
+dd if=US290D.sys ibs=1 skip=33152 count=3697 of=dvb-usb-lme2510c-s0194.fw
+
+
 Copy the firmware file(s) to /lib/firmware
-- 
1.7.1

