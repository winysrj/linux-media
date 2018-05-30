Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:41101 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932431AbeE3WH4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 18:07:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: v4l: omap: add VIDEO_V4L2 dependency
Date: Thu, 31 May 2018 00:07:11 +0200
Message-Id: <20180530220735.1651221-2-arnd@arndb.de>
In-Reply-To: <20180530220735.1651221-1-arnd@arndb.de>
References: <20180530220735.1651221-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap media driver can be built-in while the v4l2 core is a loadable
module. This is a mistake and leads to link errors:

drivers/media/platform/omap/omap_vout.o: In function `omap_vout_remove':
omap_vout.c:(.text+0xec): undefined reference to `v4l2_device_unregister'
omap_vout.c:(.text+0x140): undefined reference to `video_device_release'
omap_vout.c:(.text+0x150): undefined reference to `video_unregister_device'
omap_vout.c:(.text+0x15c): undefined reference to `v4l2_ctrl_handler_free'

An explicit Kconfig dependency on VIDEO_V4L2 avoids the problem.
I ran into this problem for the first time today during my randconfig
builds, but could not find what caused it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/omap/Kconfig b/drivers/media/platform/omap/Kconfig
index d827b6c285a6..4b5e55d41ad4 100644
--- a/drivers/media/platform/omap/Kconfig
+++ b/drivers/media/platform/omap/Kconfig
@@ -8,6 +8,7 @@ config VIDEO_OMAP2_VOUT
 	depends on MMU
 	depends on FB_OMAP2 || (COMPILE_TEST && FB_OMAP2=n)
 	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST
+	depends on VIDEO_V4L2
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
-- 
2.9.0
