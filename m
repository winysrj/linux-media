Return-path: <linux-media-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:50632 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbeK0DlL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 22:41:11 -0500
From: Priit Laes <plaes@plaes.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Priit Laes <plaes@plaes.org>
Subject: [PATCH] media: Kconfig: Add configuration entry for MEDIA_MEM2MEM_SUPPORT
Date: Mon, 26 Nov 2018 18:38:44 +0200
Message-Id: <20181126163844.18729-1-plaes@plaes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there is no easy way to enable mem2mem based video
processor drivers (cedrus for example). Simplify this by adding
separate category to media support.

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/media/Kconfig | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8add62a18293..f2a773896dcf 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -56,6 +56,14 @@ config MEDIA_DIGITAL_TV_SUPPORT
 	  Say Y when you have a board with digital support or a board with
 	  hybrid digital TV and analog TV.
 
+config MEDIA_MEM2MEM_SUPPORT
+    bool "Mem2mem devices (stateless media decoders/encoders support)"
+    ---help---
+	  Enable support for mem2mem / stateless media decoders/encoders.
+
+	  Say Y when you have a system with stateless media encoder/decoder
+	  support.
+
 config MEDIA_RADIO_SUPPORT
 	bool "AM/FM radio receivers/transmitters support"
 	---help---
@@ -95,7 +103,7 @@ source "drivers/media/cec/Kconfig"
 
 config MEDIA_CONTROLLER
 	bool "Media Controller API"
-	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_MEM2MEM_SUPPORT
 	---help---
 	  Enable the media controller API used to query media devices internal
 	  topology and configure it dynamically.
@@ -118,7 +126,7 @@ config MEDIA_CONTROLLER_DVB
 config VIDEO_DEV
 	tristate
 	depends on MEDIA_SUPPORT
-	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT || MEDIA_MEM2MEM_SUPPORT
 	default y
 
 config VIDEO_V4L2_SUBDEV_API
-- 
2.19.1
