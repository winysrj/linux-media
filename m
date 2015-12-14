Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47187 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148AbbLNKRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 05:17:06 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 5056FE291F
	for <linux-media@vger.kernel.org>; Mon, 14 Dec 2015 11:17:00 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] saa7134: add DMABUF support
Message-ID: <566E971C.9050909@xs4all.nl>
Date: Mon, 14 Dec 2015 11:17:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since saa7134 is now using vb2, there is no reason why we can't support
dmabuf for this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 3 ++-
 drivers/media/pci/saa7134/saa7134-video.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 56b932c..ca417a4 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -189,6 +189,7 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
 	.vidioc_qbuf			= vb2_ioctl_qbuf,
 	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	.vidioc_g_frequency		= saa7134_g_frequency,
@@ -286,7 +287,7 @@ static int empress_init(struct saa7134_dev *dev)
 	 * transfers that do not start at the beginning of a page. A USERPTR
 	 * can start anywhere in a page, so USERPTR support is a no-go.
 	 */
-	q->io_modes = VB2_MMAP | VB2_READ;
+	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
 	q->drv_priv = &dev->ts_q;
 	q->ops = &saa7134_empress_qops;
 	q->gfp_flags = GFP_DMA32;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4d3a7fb..179df19 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1906,6 +1906,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querybuf		= vb2_ioctl_querybuf,
 	.vidioc_qbuf			= vb2_ioctl_qbuf,
 	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
 	.vidioc_querystd		= saa7134_querystd,
@@ -2089,7 +2090,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	 * USERPTR support is a no-go unless the application knows about these
 	 * limitations and has special support for this.
 	 */
-	q->io_modes = VB2_MMAP | VB2_READ;
+	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
 	if (saa7134_userptr)
 		q->io_modes |= VB2_USERPTR;
 	q->drv_priv = &dev->video_q;
-- 
2.6.4

