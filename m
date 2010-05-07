Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:51990 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab0EGSXr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 14:23:47 -0400
Date: Fri, 7 May 2010 11:22:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] media: vivi and mem2mem_testdev need slab.h to build
Message-Id: <20100507112226.f90494a2.randy.dunlap@oracle.com>
In-Reply-To: <20100507155520.75026a8b.sfr@canb.auug.org.au>
References: <20100507155520.75026a8b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix vivi and mem2mem_testdev build errors: need to #include <linux/slab.h>:

drivers/media/video/vivi.c:1144: error: implicit declaration of function 'kfree'
drivers/media/video/vivi.c:1156: error: implicit declaration of function 'kzalloc'
drivers/media/video/vivi.c:1156: warning: assignment makes pointer from integer without a cast
drivers/media/video/mem2mem_testdev.c:862: error: implicit declaration of function 'kzalloc'
drivers/media/video/mem2mem_testdev.c:862: warning: assignment makes pointer from integer without a cast
drivers/media/video/mem2mem_testdev.c:874: error: implicit declaration of function 'kfree'
drivers/media/video/mem2mem_testdev.c:944: warning: assignment makes pointer from integer without a cast

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/mem2mem_testdev.c |    1 +
 drivers/media/video/vivi.c            |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20100507.orig/drivers/media/video/vivi.c
+++ linux-next-20100507/drivers/media/video/vivi.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/font.h>
 #include <linux/version.h>
 #include <linux/mutex.h>
--- linux-next-20100507.orig/drivers/media/video/mem2mem_testdev.c
+++ linux-next-20100507/drivers/media/video/mem2mem_testdev.c
@@ -22,6 +22,7 @@
 #include <linux/version.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <linux/platform_device.h>
 #include <media/v4l2-mem2mem.h>
