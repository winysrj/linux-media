Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35080 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1DBNr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 09:47:58 -0400
Received: by wwa36 with SMTP id 36so5028860wwa.1
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 06:47:56 -0700 (PDT)
Subject: [PATCH 1/2] DM04/QQBOX stv0288 register 42 - incorrect setting.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Apr 2011 14:47:50 +0100
Message-ID: <1301752070.7763.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 stv0288 Register 42 bits 6 & 7 should be set to 0.
 This is causing intermittent lock, the dvb-usb-lmedm04 driver uses
 register 50 (auto fine mode) to correct for this, this register is
 now returned to its default setting.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.h b/drivers/media/dvb/dvb-usb/lmedm04.h
index e6af16c..3a30ab1 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.h
+++ b/drivers/media/dvb/dvb-usb/lmedm04.h
@@ -108,14 +108,14 @@ static u8 s7395_inittab[] = {
 	0x3d, 0x30,
 	0x40, 0x63,
 	0x41, 0x04,
-	0x42, 0x60,
+	0x42, 0x20,
 	0x43, 0x00,
 	0x44, 0x00,
 	0x45, 0x00,
 	0x46, 0x00,
 	0x47, 0x00,
 	0x4a, 0x00,
-	0x50, 0x12,
+	0x50, 0x10,
 	0x51, 0x36,
 	0x52, 0x21,
 	0x53, 0x94,
-- 
1.7.4.1

