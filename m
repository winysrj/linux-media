Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:36495 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZKULth (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 06:49:37 -0500
Date: Sat, 21 Nov 2009 12:49:41 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 1/8] drivers/media/video: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211249090.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
Similarly for usb-alloc urb.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/media/video/hdpvr/hdpvr-video.c        |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 2eb9dc2..b5439ca 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -139,7 +139,7 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
 			v4l2_err(&dev->v4l2_dev, "cannot allocate urb\n");
-			goto exit;
+			goto exit_urb;
 		}
 		buf->urb = urb;
 
@@ -148,7 +148,7 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 		if (!mem) {
 			v4l2_err(&dev->v4l2_dev,
 				 "cannot allocate usb transfer buffer\n");
-			goto exit;
+			goto exit_urb_buffer;
 		}
 
 		usb_fill_bulk_urb(buf->urb, dev->udev,
@@ -161,6 +161,10 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 		list_add_tail(&buf->buff_list, &dev->free_buff_list);
 	}
 	return 0;
+exit_urb_buffer:
+	usb_free_urb(urb);
+exit_urb:
+	kfree(buf);
 exit:
 	hdpvr_free_buffers(dev);
 	return retval;
