Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55045 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030324Ab2CGWSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 17:18:08 -0500
Received: by wgbds11 with SMTP id ds11so1006320wgb.1
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 14:18:07 -0800 (PST)
Message-ID: <1331158679.11482.35.camel@tvbox>
Subject: [PATCH 4/4] lmedm04 RS2000 Firmware details
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 07 Mar 2012 22:17:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 Documentation/dvb/lmedm04.txt |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/dvb/lmedm04.txt b/Documentation/dvb/lmedm04.txt
index 10b5f04..f4b720a 100644
--- a/Documentation/dvb/lmedm04.txt
+++ b/Documentation/dvb/lmedm04.txt
@@ -66,5 +66,16 @@ dd if=US290D.sys ibs=1 skip=36856 count=3976 of=dvb-usb-lme2510-s0194.fw
 For LME2510C
 dd if=US290D.sys ibs=1 skip=33152 count=3697 of=dvb-usb-lme2510c-s0194.fw
 
+---------------------------------------------------------------------
+
+The m88rs2000 tuner driver can be found in windows/system32/drivers
+
+US2B0D.sys (dated 29 Jun 2010)
+
+dd if=US2B0D.sys ibs=1 skip=34432 count=3871 of=dvb-usb-lme2510c-rs2000.fw
+
+We need to modify id of rs2000 firmware or it will warm boot id 3344:1120.
+
+echo -ne \\xF0\\x22 | dd conv=notrunc bs=1 count=2 seek=266 of=dvb-usb-lme2510c-rs2000.fw
 
 Copy the firmware file(s) to /lib/firmware
-- 
1.7.9



