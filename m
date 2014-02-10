Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1268 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaBJKCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:02:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH for 3.14 1/2] si4713: fix Kconfig dependencies
Date: Mon, 10 Feb 2014 11:01:48 +0100
Message-Id: <1392026509-48039-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392026509-48039-1-git-send-email-hverkuil@xs4all.nl>
References: <1392026509-48039-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The SI4713 select should be I2C_SI4713 and the USB driver needs to depend on
I2C as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Reported-by: Richard Weinberger <richard@nod.at>
---
 drivers/media/radio/si4713/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/si4713/Kconfig b/drivers/media/radio/si4713/Kconfig
index a7c3ba8..9c8b887 100644
--- a/drivers/media/radio/si4713/Kconfig
+++ b/drivers/media/radio/si4713/Kconfig
@@ -1,7 +1,7 @@
 config USB_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with USB"
-	depends on USB && RADIO_SI4713
-	select SI4713
+	depends on USB && I2C && RADIO_SI4713
+	select I2C_SI4713
 	---help---
 	  This is a driver for USB devices with the Silicon Labs SI4713
 	  chip. Currently these devices are known to work.
@@ -16,7 +16,7 @@ config USB_SI4713
 config PLATFORM_SI4713
 	tristate "Silicon Labs Si4713 FM Radio Transmitter support with I2C"
 	depends on I2C && RADIO_SI4713
-	select SI4713
+	select I2C_SI4713
 	---help---
 	  This is a driver for I2C devices with the Silicon Labs SI4713
 	  chip.
-- 
1.8.5.2

