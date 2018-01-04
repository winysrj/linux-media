Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:60653 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbeADNoH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 08:44:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] media: au0828: fix VIDEO_V4L2 dependency
Date: Thu,  4 Jan 2018 14:43:50 +0100
Message-Id: <20180104134401.2642255-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the move of videobuf2 into the common directory, selecting the
au0828 driver with CONFIG_V4L2 disabled started causing a link failure,
as we now attempt to build videobuf2 but it still requires v4l2:

ERROR: "v4l2_event_pending" [drivers/media/common/videobuf/videobuf2-v4l2.ko] undefined!
ERROR: "v4l2_fh_release" [drivers/media/common/videobuf/videobuf2-v4l2.ko] undefined!
ERROR: "video_devdata" [drivers/media/common/videobuf/videobuf2-v4l2.ko] undefined!
ERROR: "__tracepoint_vb2_buf_done" [drivers/media/common/videobuf/videobuf2-core.ko] undefined!
ERROR: "__tracepoint_vb2_dqbuf" [drivers/media/common/videobuf/videobuf2-core.ko] undefined!
ERROR: "v4l_vb2q_enable_media_source" [drivers/media/common/videobuf/videobuf2-core.ko] undefined!

We want to be able to build the core au0828 support without V4L2,
so this makes the 'select' conditional on V4L2, and refines the
dependencies in VIDEO_AU0828_V4L2 so it can only be enabled in
the exact conditions that have VIDEOBUF2_VMALLOC reachable.

Fixes: 03fbdb2fc2b8 ("media: move videobuf2 to drivers/media/common")
Fixes: 05439b1a3693 ("[media] media: au0828 - convert to use videobuf2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/au0828/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 70521e0b4c53..18630b033d5b 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_AU0828
 	depends on I2C && INPUT && DVB_CORE && USB
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
-	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_VMALLOC if VIDEO_V4L2
 	select DVB_AU8522_DTV if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
@@ -18,7 +18,8 @@ config VIDEO_AU0828
 
 config VIDEO_AU0828_V4L2
 	bool "Auvitek AU0828 v4l2 analog video support"
-	depends on VIDEO_AU0828 && VIDEO_V4L2
+	depends on VIDEO_AU0828
+	depends on VIDEO_V4L2=y || VIDEO_V4L2=VIDEO_AU0828
 	select DVB_AU8522_V4L if MEDIA_SUBDRV_AUTOSELECT
 	select VIDEO_TUNER
 	default y
-- 
2.9.0
