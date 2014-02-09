Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:65427 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbaBIPL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 10:11:29 -0500
Message-ID: <1391957777.25424.15.camel@x220>
Subject: [PATCH] [media] si4713: Remove "select SI4713"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 15:56:17 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commits 7391232e1215 ("[media] si4713: Reorganized drivers/media/radio
directory") and b874b39fcd2f ("[media] si4713: Added the USB driver for
Si4713") both added a "select SI4713". But there's no Kconfig symbol
SI4713, so these selects are nops. It's not clear why they were added
but it's safe to remove them anyway.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

 drivers/media/radio/si4713/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
index a7c3ba8..ed51ed0 100644
--- a/drivers/media/radio/si4713/Kconfig
+++ b/drivers/media/radio/si4713/Kconfig
@@ -1,7 +1,6 @@
 config USB_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
 	depends on USB && RADIO_SI4713
-	select SI4713
 	---help---
 	  This is a driver for USB devices with the Silicon Labs SI4713
 	  chip. Currently these devices are known to work.
@@ -16,7 +15,6 @@ config USB_SI4713
 config PLATFORM_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
 	depends on I2C && RADIO_SI4713
-	select SI4713
 	---help---
 	  This is a driver for I2C devices with the Silicon Labs SI4713
 	  chip.
-- 
1.8.5.3



