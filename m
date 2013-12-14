Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1654 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3LNL3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:29:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 09/15] saa6752hs: move to media/i2c
Date: Sat, 14 Dec 2013 12:28:31 +0100
Message-Id: <1387020517-26242-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver is independent from saa7134, so there is no reason why this
shouldn't be in media/i2c like all other i2c media drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/Kconfig                      | 12 ++++++++++++
 drivers/media/i2c/Makefile                     |  1 +
 drivers/media/{pci/saa7134 => i2c}/saa6752hs.c |  0
 drivers/media/pci/saa7134/Kconfig              |  1 +
 drivers/media/pci/saa7134/Makefile             |  2 +-
 5 files changed, 15 insertions(+), 1 deletion(-)
 rename drivers/media/{pci/saa7134 => i2c}/saa6752hs.c (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 842654d..91899e4 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -655,6 +655,18 @@ config VIDEO_UPD64083
 	  To compile this driver as a module, choose M here: the
 	  module will be called upd64083.
 
+comment "Audio/Video compression chips"
+
+config VIDEO_SAA6752HS
+	tristate "Philips SAA6752HS MPEG-2 Audio/Video Encoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA6752HS MPEG-2 video and MPEG-audio/AC-3
+	  audio encoder with multiplexer.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa6752hs.
+
 comment "Miscellaneous helper chips"
 
 config VIDEO_THS7303
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index e03f177..6d1cfa5 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
 obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
 obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
 obj-$(CONFIG_VIDEO_SAA7191) += saa7191.o
+obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
 obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
diff --git a/drivers/media/pci/saa7134/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
similarity index 100%
rename from drivers/media/pci/saa7134/saa6752hs.c
rename to drivers/media/i2c/saa6752hs.c
diff --git a/drivers/media/pci/saa7134/Kconfig b/drivers/media/pci/saa7134/Kconfig
index 15b90d6..7883393 100644
--- a/drivers/media/pci/saa7134/Kconfig
+++ b/drivers/media/pci/saa7134/Kconfig
@@ -6,6 +6,7 @@ config VIDEO_SAA7134
 	select VIDEO_TVEEPROM
 	select CRC32
 	select VIDEO_SAA6588 if MEDIA_SUBDRV_AUTOSELECT
+	select VIDEO_SAA6752HS if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This is a video4linux driver for Philips SAA713x based
 	  TV cards.
diff --git a/drivers/media/pci/saa7134/Makefile b/drivers/media/pci/saa7134/Makefile
index 3537548..58de9b0 100644
--- a/drivers/media/pci/saa7134/Makefile
+++ b/drivers/media/pci/saa7134/Makefile
@@ -4,7 +4,7 @@ saa7134-y +=	saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o
 saa7134-y +=	saa7134-video.o
 saa7134-$(CONFIG_VIDEO_SAA7134_RC) += saa7134-input.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa7134.o saa7134-empress.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
-- 
1.8.4.3

