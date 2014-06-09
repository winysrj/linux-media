Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaFIVtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 17:49:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] au0828: add missing tuner Kconfig dependency
Date: Mon,  9 Jun 2014 18:49:01 -0300
Message-Id: <1402350541-20396-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The analog part of au0828 is missing the tuner Kconfig dependency.
That makes the device to not work while in analog mode.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 953a37c613b1..fe48403eadd0 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -20,6 +20,7 @@ config VIDEO_AU0828_V4L2
 	bool "Auvitek AU0828 v4l2 analog video support"
 	depends on VIDEO_AU0828 && VIDEO_V4L2
 	select DVB_AU8522_V4L if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_TUNER
 	default y
 	---help---
 	  This is a video4linux driver for Auvitek's USB device.
-- 
1.9.3

