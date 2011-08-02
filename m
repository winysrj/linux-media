Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44531 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1HBJvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:51:00 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPA002B9OOZMV@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:50:59 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA00JYTOOXXO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:50:58 +0100 (BST)
Date: Tue, 02 Aug 2011 11:50:59 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/6] v4l: add buffer exporting via shrbuf
In-reply-to: <4E37C7D7.40301@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E37C883.4040102@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch adds extension to V4L2 api. It allow to export a mmap buffer 
as file
descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset 
used by
mmap and return a file descriptor on success.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
  drivers/media/video/v4l2-ioctl.c |   10 ++++++++++
  include/linux/videodev2.h        |    8 ++++++++
  include/media/v4l2-ioctl.h       |    1 +
  3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c 
b/drivers/media/video/v4l2-ioctl.c
index 660b486..0a19fd4 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1145,6 +1145,16 @@ static long __video_do_ioctl(struct file *file,
              dbgbuf(cmd, vfd, p);
          break;
      }
+    case VIDIOC_EXPBUF:
+    {
+        unsigned int *p = arg;
+
+        if (!ops->vidioc_expbuf)
+            break;
+
+        ret = ops->vidioc_expbuf(file, fh, *p);
+        break;
+    }
      case VIDIOC_DQBUF:
      {
          struct v4l2_buffer *p = arg;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7c77c4e..cae7908 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -185,6 +185,7 @@ enum v4l2_memory {
      V4L2_MEMORY_MMAP             = 1,
      V4L2_MEMORY_USERPTR          = 2,
      V4L2_MEMORY_OVERLAY          = 3,
+    V4L2_MEMORY_SHRBUF           = 4,
  };

  /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
@@ -564,6 +565,8 @@ struct v4l2_requestbuffers {
   *            should be passed to mmap() called on the video node)
   * @userptr:        when memory is V4L2_MEMORY_USERPTR, a userspace 
pointer
   *            pointing to this plane
+ * @fd:            when memory is V4L2_MEMORY_SHRBUF, a userspace file
+ *            descriptor associated with this plane
   * @data_offset:    offset in the plane to the start of data; usually 0,
   *            unless there is a header in front of the data
   *
@@ -578,6 +581,7 @@ struct v4l2_plane {
      union {
          __u32        mem_offset;
          unsigned long    userptr;
+        int fd;
      } m;
      __u32            data_offset;
      __u32            reserved[11];
@@ -600,6 +604,8 @@ struct v4l2_plane {
   *        (or a "cookie" that should be passed to mmap() as offset)
   * @userptr:    for non-multiplanar buffers with memory == 
V4L2_MEMORY_USERPTR;
   *        a userspace pointer pointing to this buffer
+ * @fd:            for non-multiplanar buffers with memory == 
V4L2_MEMORY_SHRBUF;
+ *        a userspace file descriptor associated with this buffer
   * @planes:    for multiplanar buffers; userspace pointer to the array 
of plane
   *        info structs for this buffer
   * @length:    size in bytes of the buffer (NOT its payload) for 
single-plane
@@ -626,6 +632,7 @@ struct v4l2_buffer {
          __u32           offset;
          unsigned long   userptr;
          struct v4l2_plane *planes;
+        int fd;
      } m;
      __u32            length;
      __u32            input;
@@ -1868,6 +1875,7 @@ struct v4l2_dbg_chip_ident {
  #define VIDIOC_S_FBUF         _IOW('V', 11, struct v4l2_framebuffer)
  #define VIDIOC_OVERLAY         _IOW('V', 14, int)
  #define VIDIOC_QBUF        _IOWR('V', 15, struct v4l2_buffer)
+#define VIDIOC_EXPBUF        _IOWR('V', 16, unsigned int)
  #define VIDIOC_DQBUF        _IOWR('V', 17, struct v4l2_buffer)
  #define VIDIOC_STREAMON         _IOW('V', 18, int)
  #define VIDIOC_STREAMOFF     _IOW('V', 19, int)
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index dd9f1e7..20932e3 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -121,6 +121,7 @@ struct v4l2_ioctl_ops {
      int (*vidioc_querybuf)(struct file *file, void *fh, struct 
v4l2_buffer *b);
      int (*vidioc_qbuf)    (struct file *file, void *fh, struct 
v4l2_buffer *b);
      int (*vidioc_dqbuf)   (struct file *file, void *fh, struct 
v4l2_buffer *b);
+    int (*vidioc_expbuf)  (struct file *file, void *fh, unsigned int 
offset);


      int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
-- 
1.7.6



