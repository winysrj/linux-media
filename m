Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45383 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2AWNvj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 08:51:39 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY900GSJ7U0VU60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY9003U87TZ1R@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 13:51:36 +0000 (GMT)
Date: Mon, 23 Jan 2012 14:51:14 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 09/10] v4l: fimc: integrate capture i-face with dmabuf
In-reply-to: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	pawel@osciak.com
Message-id: <1327326675-8431-10-git-send-email-t.stanislaws@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 2cc3b91..ba11c4a 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1002,6 +1002,14 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
 	return vb2_qbuf(&fimc->vid_cap.vbq, buf);
 }
 
+static int fimc_cap_expbuf(struct file *file, void *priv,
+			  unsigned int offset)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_expbuf(&fimc->vid_cap.vbq, offset);
+}
+
 static int fimc_cap_dqbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
@@ -1072,6 +1080,7 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 
 	.vidioc_qbuf			= fimc_cap_qbuf,
 	.vidioc_dqbuf			= fimc_cap_dqbuf,
+	.vidioc_expbuf			= fimc_cap_expbuf,
 
 	.vidioc_streamon		= fimc_cap_streamon,
 	.vidioc_streamoff		= fimc_cap_streamoff,
@@ -1451,7 +1460,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	q = &fimc->vid_cap.vbq;
 	memset(q, 0, sizeof(*q));
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	q->io_modes = VB2_MMAP | VB2_USERPTR;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
 	q->drv_priv = fimc->vid_cap.ctx;
 	q->ops = &fimc_capture_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.5.4

