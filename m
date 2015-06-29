Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:57263 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbbF2Npz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 09:45:55 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] adv7604/cobalt: Allow compile test if !GPIOLIB
Date: Mon, 29 Jun 2015 15:45:56 +0200
Message-Id: <1435585556-13584-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GPIO subsystem provides dummy GPIO consumer functions if GPIOLIB is
not enabled. Hence drivers that depend on GPIOLIB, but use GPIO consumer
functionality only, can still be compiled if GPIOLIB is not enabled.

Relax the dependency of VIDEO_ADV7604 and VIDEO_COBALT (the latter
selects the former) on GPIOLIB if COMPILE_TEST is enabled.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The VIDEO_COBALT part was untested, but I assume it's OK given the
dependency was added because of the select, cfr. commit 29fba6a84bc73b92
("[media] adv7604/cobalt: missing GPIOLIB dependency").
---
 drivers/media/i2c/Kconfig        | 3 ++-
 drivers/media/pci/cobalt/Kconfig | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 71ee8f586430991f..8d1268648fe0b291 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -196,7 +196,8 @@ config VIDEO_ADV7183
 
 config VIDEO_ADV7604
 	tristate "Analog Devices ADV7604 decoder"
-	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && GPIOLIB
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	depends on GPIOLIB || COMPILE_TEST
 	select HDMI
 	---help---
 	  Support for the Analog Devices ADV7604 video decoder.
diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index 3be1b2c3c3860ec4..9beef39a7303cf6c 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -1,7 +1,8 @@
 config VIDEO_COBALT
 	tristate "Cisco Cobalt support"
 	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
-	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS && GPIOLIB
+	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
+	depends on GPIOLIB || COMPILE_TEST
 	select I2C_ALGOBIT
 	select VIDEO_ADV7604
 	select VIDEO_ADV7511
-- 
1.9.1

