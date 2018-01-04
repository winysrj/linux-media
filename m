Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:61093 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbeADKco (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 05:32:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] media: au0828: add VIDEO_V4L2 dependency
Date: Thu,  4 Jan 2018 11:31:32 +0100
Message-Id: <20180104103215.15591-3-arnd@arndb.de>
In-Reply-To: <20180104103215.15591-1-arnd@arndb.de>
References: <20180104103215.15591-1-arnd@arndb.de>
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

This adds the same dependency in au0828 that the other users of videobuf2
have.

Fixes: 03fbdb2fc2b8 ("media: move videobuf2 to drivers/media/common")
Fixes: 05439b1a3693 ("[media] media: au0828 - convert to use videobuf2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/au0828/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 70521e0b4c53..bfaa806633df 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -1,7 +1,7 @@
 
 config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
-	depends on I2C && INPUT && DVB_CORE && USB
+	depends on I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
 	select VIDEOBUF2_VMALLOC
-- 
2.9.0
