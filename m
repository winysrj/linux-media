Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbZHFXB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2009 19:01:29 -0400
Message-Id: <200908062301.n76N1JhY030156@imap1.linux-foundation.org>
Subject: [patch 8/9] media/zr364xx: fix build errors
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	randy.dunlap@oracle.com, royale@zerezo.com
From: akpm@linux-foundation.org
Date: Thu, 06 Aug 2009 16:01:19 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors in zr364xx by adding selects:

zr364xx.c:(.text+0x195ed7): undefined reference to `videobuf_streamon'
zr364xx.c:(.text+0x196030): undefined reference to `videobuf_dqbuf'
zr364xx.c:(.text+0x1960c4): undefined reference to `videobuf_qbuf'
zr364xx.c:(.text+0x196123): undefined reference to `videobuf_querybuf'
zr364xx.c:(.text+0x196182): undefined reference to `videobuf_reqbufs'
zr364xx.c:(.text+0x196224): undefined reference to `videobuf_queue_is_busy'
zr364xx.c:(.text+0x196390): undefined reference to `videobuf_vmalloc_free'
zr364xx.c:(.text+0x196571): undefined reference to `videobuf_iolock'
zr364xx.c:(.text+0x196678): undefined reference to `videobuf_mmap_mapper'
zr364xx.c:(.text+0x196760): undefined reference to `videobuf_poll_stream'
zr364xx.c:(.text+0x19689a): undefined reference to `videobuf_read_one'
zr364xx.c:(.text+0x1969ec): undefined reference to `videobuf_mmap_free'
zr364xx.c:(.text+0x197862): undefined reference to `videobuf_queue_vmalloc_init'
zr364xx.c:(.text+0x197a28): undefined reference to `videobuf_streamoff'
zr364xx.c:(.text+0x198203): undefined reference to `videobuf_to_vmalloc'
zr364xx.c:(.text+0x198603): undefined reference to `videobuf_streamoff'
drivers/built-in.o: In function `free_buffer':
zr364xx.c:(.text+0x19930c): undefined reference to `videobuf_vmalloc_free'
drivers/built-in.o: In function `zr364xx_open':
zr364xx.c:(.text+0x19a7de): undefined reference to `videobuf_queue_vmalloc_init'
drivers/built-in.o: In function `read_pipe_completion':
zr364xx.c:(.text+0x19b17f): undefined reference to `videobuf_to_vmalloc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Antoine Jacquet <royale@zerezo.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/media/video/Kconfig~media-zr364xx-fix-build-errors drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~media-zr364xx-fix-build-errors
+++ a/drivers/media/video/Kconfig
@@ -1000,6 +1000,8 @@ source "drivers/media/video/pwc/Kconfig"
 config USB_ZR364XX
 	tristate "USB ZR364XX Camera support"
 	depends on VIDEO_V4L2
+	select VIDEOBUF_GEN
+	select VIDEOBUF_VMALLOC
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port.
_
