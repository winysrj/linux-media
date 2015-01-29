Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57632 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbbA2QNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:13:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] [media] davinci: add V4L2 dependencies
Date: Thu, 29 Jan 2015 17:12:05 +0100
Message-ID: <1598982.NztnJrsrWo@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The davinci media drivers use videobuf2, which they enable through
a 'select' statement. If one of these drivers is built-in, but
the v4l2 core is a loadable modules, we end up with a link
error:

drivers/built-in.o: In function `vb2_fop_mmap':
:(.text+0x113e84): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_create_bufs':
:(.text+0x114710): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_reqbufs':
:(.text+0x114ed8): undefined reference to `video_devdata'
drivers/built-in.o: In function `vb2_ioctl_querybuf':
:(.text+0x115530): undefined reference to `video_devdata'

To solve this, we need to add a dependency on VIDEO_V4L2,
which enforces that the davinci drivers themselves can only
be loadable modules if V4L2 is not built-in, and they do
not cause the videobuf2 code to be built-in.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
index d9e1ddb586b1..469e9d28cec0 100644
--- a/drivers/media/platform/davinci/Kconfig
+++ b/drivers/media/platform/davinci/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_DAVINCI_VPIF_DISPLAY
 	tristate "TI DaVinci VPIF V4L2-Display driver"
-	depends on VIDEO_DEV
+	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
@@ -16,7 +16,7 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
 
 config VIDEO_DAVINCI_VPIF_CAPTURE
 	tristate "TI DaVinci VPIF video capture driver"
-	depends on VIDEO_DEV
+	depends on VIDEO_V4L2
 	depends on ARCH_DAVINCI || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
@@ -75,7 +75,7 @@ config VIDEO_DM365_ISIF
 
 config VIDEO_DAVINCI_VPBE_DISPLAY
 	tristate "TI DaVinci VPBE V4L2-Display driver"
-	depends on ARCH_DAVINCI
+	depends on VIDEO_V4L2 && ARCH_DAVINCI
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	help

