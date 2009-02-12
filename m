Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:25112 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbZBLSTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 13:19:49 -0500
Message-ID: <4994682C.8070703@oracle.com>
Date: Thu, 12 Feb 2009 10:19:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media/zoran: fix printk format
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
In-Reply-To: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/media/video/zoran/zoran_driver.c:345: warning: format '%lx' expects type 'long unsigned int', but argument 5 has type 'phys_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/zoran/zoran_driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20090212.orig/drivers/media/video/zoran/zoran_driver.c
+++ linux-next-20090212/drivers/media/video/zoran/zoran_driver.c
@@ -344,9 +344,9 @@ v4l_fbuffer_alloc (struct file *file)
 				SetPageReserved(MAP_NR(mem + off));
 			dprintk(4,
 				KERN_INFO
-				"%s: v4l_fbuffer_alloc() - V4L frame %d mem 0x%lx (bus: 0x%lx)\n",
+				"%s: v4l_fbuffer_alloc() - V4L frame %d mem 0x%lx (bus: 0x%llx)\n",
 				ZR_DEVNAME(zr), i, (unsigned long) mem,
-				virt_to_bus(mem));
+				(unsigned long long)virt_to_bus(mem));
 		} else {
 
 			/* Use high memory which has been left at boot time */
