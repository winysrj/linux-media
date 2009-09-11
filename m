Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:42670 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbZIKQVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 12:21:17 -0400
Date: Fri, 11 Sep 2009 18:21:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 2/8] drivers/media/video/uvc: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0909111821010.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Error handling code following kmalloc should free the allocated data.

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
 drivers/media/video/uvc/uvc_video.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 5b757f3..ce2c484 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -128,8 +128,11 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	if (data == NULL)
 		return -ENOMEM;
 
-	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
-		return -EIO;
+	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
+			query == UVC_GET_DEF) {
+		ret = -EIO;
+		goto out;
+	}
 
 	ret = __uvc_query_ctrl(stream->dev, query, 0, stream->intfnum,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
