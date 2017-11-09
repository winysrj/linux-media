Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29028 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbdKIV2b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Nov 2017 16:28:31 -0500
Date: Fri, 10 Nov 2017 00:28:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] cpia2: Fix a couple off by one bugs
Message-ID: <20171109212814.usd6uygieeyuzfrv@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cam->buffers[] array has cam->num_frames elements so the > needs to
be changed to >= to avoid going beyond the end of the array.  The
->buffers[] array is allocated in cpia2_allocate_buffers() if you want
to confirm.

Fixes: ab33d5071de7 ("V4L/DVB (3376): Add cpia2 camera support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 3dedd83f0b19..a1c59f19cf2d 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -808,7 +808,7 @@ static int cpia2_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	struct camera_data *cam = video_drvdata(file);
 
 	if(buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-	   buf->index > cam->num_frames)
+	   buf->index >= cam->num_frames)
 		return -EINVAL;
 
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
@@ -859,7 +859,7 @@ static int cpia2_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 
 	if(buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 	   buf->memory != V4L2_MEMORY_MMAP ||
-	   buf->index > cam->num_frames)
+	   buf->index >= cam->num_frames)
 		return -EINVAL;
 
 	DBG("QBUF #%d\n", buf->index);
