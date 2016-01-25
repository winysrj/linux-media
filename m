Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:45996 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbcAYWaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 17:30:20 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net,
	Richard Weinberger <richard@nod.at>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: [PATCH 17/22] media: Fix dependencies for !HAS_IOMEM archs
Date: Mon, 25 Jan 2016 23:24:16 +0100
Message-Id: <1453760661-1444-18-git-send-email-richard@nod.at>
In-Reply-To: <1453760661-1444-1-git-send-email-richard@nod.at>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not every arch has io memory.
While the driver has correct dependencies the select statement
will bypass the HAS_IOMEM dependency.
So, unbreak the build by rendering it into a real dependency.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/media/Kconfig             | 3 +--
 drivers/media/usb/cx231xx/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a8518fb..5553cb1 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -187,8 +187,7 @@ config MEDIA_SUBDRV_AUTOSELECT
 	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT || MEDIA_SDR_SUPPORT
 	depends on HAS_IOMEM
-	select I2C
-	select I2C_MUX
+	depends on I2C_MUX && I2C
 	default y
 	help
 	  By default, a media driver auto-selects all possible ancillary
diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 0cced3e..30ae67d 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -1,13 +1,13 @@
 config VIDEO_CX231XX
 	tristate "Conexant cx231xx USB video capture support"
 	depends on VIDEO_DEV && I2C
+	depends on I2C_MUX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	depends on RC_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
-	select I2C_MUX
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
-- 
1.8.4.5

