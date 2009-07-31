Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:33052 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZGaWsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 18:48:22 -0400
Date: Fri, 31 Jul 2009 15:47:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org, akpm <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	Antoine Jacquet <royale@zerezo.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media/zr364xx: fix build errors
Message-Id: <20090731154717.43efbbfc.randy.dunlap@oracle.com>
In-Reply-To: <20090731180943.8f30c49d.sfr@canb.auug.org.au>
References: <20090731180943.8f30c49d.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
---
 drivers/media/video/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090729.orig/drivers/media/video/Kconfig
+++ linux-next-20090729/drivers/media/video/Kconfig
@@ -991,6 +991,8 @@ source "drivers/media/video/pwc/Kconfig"
 config USB_ZR364XX
 	tristate "USB ZR364XX Camera support"
 	depends on VIDEO_V4L2
+	select VIDEOBUF_GEN
+	select VIDEOBUF_VMALLOC
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port.




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
