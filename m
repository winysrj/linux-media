Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57020 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754376AbcDFLqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 07:46:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com
Subject: [PATCH 2/2] videobuf2-v4l2: Verify planes array in buffer dequeueing
Date: Wed,  6 Apr 2016 14:46:08 +0300
Message-Id: <1459943168-18406-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a buffer is being dequeued using VIDIOC_DQBUF IOCTL, the exact buffer
which will be dequeued is not known until the buffer has been removed from
the queue. The number of planes is specific to a buffer, not to the queue.

This does lead to the situation where multi-plane buffers may be requested
and queued with n planes, but VIDIOC_DQBUF IOCTL may be passed an argument
struct with fewer planes.

__fill_v4l2_buffer() however uses the number of planes from the dequeued
videobuf2 buffer, overwriting kernel memory (the m.planes array allocated
in video_usercopy() in v4l2-ioctl.c)  if the user provided fewer
planes than the dequeued buffer had. Oops!

Fixes: b0e0e1f83de3 ("[media] media: videobuf2: Prepare to divide videobuf2")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 91f5521..8da7470 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -74,6 +74,11 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
 	return 0;
 }
 
+static int __verify_planes_array_core(struct vb2_buffer *vb, const void *pb)
+{
+	return __verify_planes_array(vb, pb);
+}
+
 /**
  * __verify_length() - Verify that the bytesused value for each plane fits in
  * the plane length and that the data offset doesn't exceed the bytesused value.
@@ -437,6 +442,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 }
 
 static const struct vb2_buf_ops v4l2_buf_ops = {
+	.verify_planes_array	= __verify_planes_array_core,
 	.fill_user_buffer	= __fill_v4l2_buffer,
 	.fill_vb2_buffer	= __fill_vb2_buffer,
 	.copy_timestamp		= __copy_timestamp,
-- 
2.1.4

