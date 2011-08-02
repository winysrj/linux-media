Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24224 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1HBJyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:54:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPA003Y8OUUWB30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:54:30 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA00JD5OUSXO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:54:29 +0100 (BST)
Date: Tue, 02 Aug 2011 11:54:30 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6/6] v4l: s5p-tv: mixer: integrate with shrbuf
In-reply-to: <4E37C7D7.40301@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E37C956.1080008@samsung.com>
References: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
  drivers/media/video/s5p-tv/mixer_video.c |   11 ++++++++++-
  1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c 
b/drivers/media/video/s5p-tv/mixer_video.c
index 43ac22f..52cb51a 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -591,6 +591,14 @@ static int mxr_dqbuf(struct file *file, void *priv, 
struct v4l2_buffer *p)
      return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
  }

+static int mxr_expbuf(struct file *file, void *priv, unsigned int offset)
+{
+    struct mxr_layer *layer = video_drvdata(file);
+
+    mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+    return vb2_expbuf(&layer->vb_queue, offset);
+}
+
  static int mxr_streamon(struct file *file, void *priv, enum 
v4l2_buf_type i)
  {
      struct mxr_layer *layer = video_drvdata(file);
@@ -618,6 +626,7 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
      .vidioc_querybuf = mxr_querybuf,
      .vidioc_qbuf = mxr_qbuf,
      .vidioc_dqbuf = mxr_dqbuf,
+    .vidioc_expbuf = mxr_expbuf,
      /* Streaming control */
      .vidioc_streamon = mxr_streamon,
      .vidioc_streamoff = mxr_streamoff,
@@ -972,7 +981,7 @@ struct mxr_layer *mxr_base_layer_create(struct 
mxr_device *mdev,

      layer->vb_queue = (struct vb2_queue) {
          .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
-        .io_modes = VB2_MMAP | VB2_USERPTR,
+        .io_modes = VB2_MMAP | VB2_USERPTR | VB2_SHRBUF,
          .drv_priv = layer,
          .buf_struct_size = sizeof(struct mxr_buffer),
          .ops = &mxr_video_qops,
-- 
1.7.6



