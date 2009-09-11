Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:42704 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbZIKQVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 12:21:34 -0400
Date: Fri, 11 Sep 2009 18:21:35 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 3/8] drivers/media/video/hdpvr: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
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
 drivers/media/video/hdpvr/hdpvr-video.c        |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 2eb9dc2..0d17ce5 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -132,7 +132,7 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 		buf = kzalloc(sizeof(struct hdpvr_buffer), GFP_KERNEL);
 		if (!buf) {
 			v4l2_err(&dev->v4l2_dev, "cannot allocate buffer\n");
-			goto exit;
+			goto exit_nobuf;
 		}
 		buf->dev = dev;
 
@@ -162,6 +162,8 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 	}
 	return 0;
 exit:
+	kfree(buf);
+exit_nobuf:
 	hdpvr_free_buffers(dev);
 	return retval;
 }
