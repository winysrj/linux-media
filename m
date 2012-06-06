Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4127 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2FFWJl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 18:09:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: What should CREATE_BUFS do if count == 0?
Date: Thu, 7 Jun 2012 00:09:27 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206070009.27409.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm extending v4l2-compliance with support for VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS,
and I ran into an undefined issue: what happens if VIDIOC_CREATE_BUFS is called with
count set to 0?

I think there should be a separate test for that. Right now queue_setup will receive
a request for 0 buffers, and I don't know if drivers expect a zero value there.

I suggest that CREATE_BUFS with a count of 0 will only check whether memory and
format.type are valid, and if they are it will just return 0 and do nothing.

Also note that this code in vb2_create_bufs is wrong:

        ret = __vb2_queue_alloc(q, create->memory, num_buffers,
                                num_planes);
        if (ret < 0) {
                dprintk(1, "Memory allocation failed with error: %d\n", ret);
                return ret;
        }

It should be:

		if (ret == 0) {

__vb2_queue_alloc() returns the number of buffers it managed to allocate,
which is never < 0.

I propose to add the patch included below.

Comments are welcome!

Regards,

	Hans

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index a0702fd..01a8312 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -647,6 +647,9 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		return -EINVAL;
 	}
 
+	if (create->count == 0)
+		return 0;
+
 	if (q->num_buffers == VIDEO_MAX_FRAME) {
 		dprintk(1, "%s(): maximum number of buffers already allocated\n",
 			__func__);
@@ -675,7 +678,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	/* Finally, allocate buffers and video memory */
 	ret = __vb2_queue_alloc(q, create->memory, num_buffers,
 				num_planes);
-	if (ret < 0) {
+	if (ret == 0) {
 		dprintk(1, "Memory allocation failed with error: %d\n", ret);
 		return ret;
 	}
