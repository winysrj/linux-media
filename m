Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:54620 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbZIMUz3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 16:55:29 -0400
Date: Sun, 13 Sep 2009 22:55:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/8] drivers/media/video/uvc: introduce missing kfree
In-Reply-To: <200909132239.21806.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0909132254430.31000@ask.diku.dk>
References: <Pine.LNX.4.64.0909111821010.10552@pc-004.diku.dk>
 <200909132239.21806.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Move the kzalloc and associated test after the stream/query test, to avoid
the need to free the allocated if the stream/query test fails.

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
 drivers/media/video/uvc/uvc_video.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 5b757f3..f960e8e 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -124,13 +124,14 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	int ret;
 
 	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
+	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) &&
+			query == UVC_GET_DEF)
+		return -EIO;
+
 	data = kmalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
-	if ((stream->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
-		return -EIO;
-
 	ret = __uvc_query_ctrl(stream->dev, query, 0, stream->intfnum,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
 		size, UVC_CTRL_STREAMING_TIMEOUT);
