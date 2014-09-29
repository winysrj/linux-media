Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:58036 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2PhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 11:37:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] vivid: add CONFIG_FB dependency
Date: Mon, 29 Sep 2014 17:36:58 +0200
Message-ID: <6161514.UBprKDKKES@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 6699184d4b791e8a108888380d3b75be837607d3 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 29 Sep 2014 17:33:25 +0200
Subject: [PATCH] [media] vivid: add CONFIG_FB dependency

The vivid test driver creates a framebuffer, which fails if the the framebuffer
layer is not enabled:

drivers/built-in.o: In function `vivid_fb_release_buffers':
:(.text+0x2acfe8): undefined reference to `fb_dealloc_cmap'
drivers/built-in.o: In function `vivid_fb_init':
:(.text+0x2ad344): undefined reference to `fb_alloc_cmap'
:(.text+0x2ad34c): undefined reference to `register_framebuffer'
drivers/built-in.o: In function `vivid_exit':
:(.exit.text+0x4354): undefined reference to `unregister_framebuffer'
drivers/built-in.o:(.data+0x55f88): undefined reference to `cfb_fillrect'
drivers/built-in.o:(.data+0x55f8c): undefined reference to `cfb_copyarea'
drivers/built-in.o:(.data+0x55f90): undefined reference to `cfb_imageblit'

This adds the dependency in Kconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index d71139a2ae00..4c31421fd90d 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_VIVID
 	tristate "Virtual Video Test Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on VIDEO_DEV && VIDEO_V4L2 && FB && !SPARC32 && !SPARC64
 	select FONT_SUPPORT
 	select FONT_8x16
 	select VIDEOBUF2_VMALLOC

