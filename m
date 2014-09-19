Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaISQC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 12:02:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] em28xx: Get rid of some unused modprobe parameters at vbi code
Date: Fri, 19 Sep 2014 13:02:11 -0300
Message-Id: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two modprobe parameters for VBI that aren't used
anywhere (one for debug, the other one related to the buffer
size). Get rid of them!

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
index 6d7f657f6f55..34ee1e03a732 100644
--- a/drivers/media/usb/em28xx/em28xx-vbi.c
+++ b/drivers/media/usb/em28xx/em28xx-vbi.c
@@ -29,17 +29,6 @@
 #include "em28xx.h"
 #include "em28xx-v4l.h"
 
-static unsigned int vbibufs = 5;
-module_param(vbibufs, int, 0644);
-MODULE_PARM_DESC(vbibufs, "number of vbi buffers, range 2-32");
-
-static unsigned int vbi_debug;
-module_param(vbi_debug, int, 0644);
-MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
-
-#define dprintk(level, fmt, arg...)	if (vbi_debug >= level) \
-	printk(KERN_DEBUG "%s: " fmt, dev->core->name , ## arg)
-
 /* ------------------------------------------------------------------ */
 
 static int vbi_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
-- 
1.9.3

