Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44789 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2AVKsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jan 2012 05:48:35 -0500
Received: by wics10 with SMTP id s10so1469939wic.19
        for <linux-media@vger.kernel.org>; Sun, 22 Jan 2012 02:48:34 -0800 (PST)
Message-ID: <1327229307.2540.10.camel@tvbox>
Subject: [PATCH 3/3] lmedm04 m88rs2000 Firmware details
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 22 Jan 2012 10:48:27 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware details RS2000

Note: Firmware needs to be patched to return from cold boot with correct ID.

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
1.7.8.3



