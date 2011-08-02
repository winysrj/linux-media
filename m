Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60855 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1HBJxy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:53:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPA003AYOTTZV40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:53:53 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA00AMNOTRBP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:53:52 +0100 (BST)
Date: Tue, 02 Aug 2011 11:53:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/6] v4l: fimc: integrate capture i-face with shrbuf
In-reply-to: <4E37C7D7.40301@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E37C92C.9070101@samsung.com>
References: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
  drivers/media/video/s5p-fimc/fimc-capture.c |   11 ++++++++++-
  1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c 
b/drivers/media/video/s5p-fimc/fimc-capture.c
index a16f359..0904263 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -981,6 +981,14 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
      return vb2_qbuf(&fimc->vid_cap.vbq, buf);
  }

+static int fimc_cap_expbuf(struct file *file, void *priv,
+              unsigned int offset)
+{
+    struct fimc_dev *fimc = video_drvdata(file);
+
+    return vb2_expbuf(&fimc->vid_cap.vbq, offset);
+}
+
  static int fimc_cap_dqbuf(struct file *file, void *priv,
                 struct v4l2_buffer *buf)
  {
@@ -1051,6 +1059,7 @@ static const struct v4l2_ioctl_ops 
fimc_capture_ioctl_ops = {

      .vidioc_qbuf            = fimc_cap_qbuf,
      .vidioc_dqbuf            = fimc_cap_dqbuf,
+    .vidioc_expbuf            = fimc_cap_expbuf,

      .vidioc_streamon        = fimc_cap_streamon,
      .vidioc_streamoff        = fimc_cap_streamoff,
@@ -1422,7 +1431,7 @@ int fimc_register_capture_device(struct fimc_dev 
*fimc,
      q = &fimc->vid_cap.vbq;
      memset(q, 0, sizeof(*q));
      q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-    q->io_modes = VB2_MMAP | VB2_USERPTR;
+    q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_SHRBUF;
      q->drv_priv = fimc->vid_cap.ctx;
      q->ops = &fimc_capture_qops;
      q->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.6



