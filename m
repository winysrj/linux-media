Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31716 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2BQGns (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 01:43:48 -0500
Date: Fri, 17 Feb 2012 09:43:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dean Anderson <linux-dev@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pete Eberlein <pete@sensoray.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] s2255drv: cleanup vidioc_enum_fmt_cap()
Message-ID: <20120217064327.GA3666@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"f" wasn't checked consistently, so static checkers complain.  This
function is always called with a valid "f" pointer, so I have removed
the check.

Also the indenting was messed up.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index c1bef61..3505242 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -852,15 +852,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 			       struct v4l2_fmtdesc *f)
 {
-	int index = 0;
-	if (f)
-		index = f->index;
+	int index = f->index;
 
 	if (index >= ARRAY_SIZE(formats))
 		return -EINVAL;
-    if (!jpeg_enable && ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
-			 (formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
-	return -EINVAL;
+	if (!jpeg_enable && ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
+			(formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
+		return -EINVAL;
 	dprintk(4, "name %s\n", formats[index].name);
 	strlcpy(f->description, formats[index].name, sizeof(f->description));
 	f->pixelformat = formats[index].fourcc;
