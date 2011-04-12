Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:57872 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1DLLQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 07:16:37 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Detlev Zundel <dzu@denx.de>, Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] media: fsl_viu: fix bug in streamon routine
Date: Tue, 12 Apr 2011 13:15:58 +0200
Message-Id: <1302606958-9301-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently video capturing using streaming I/O method
doesn't work if capturing to overlay buffer took place
before.

When enabling the stream we have to check the overlay
enable driver flag and reset it so that the interrupt
handler won't execute the overlay interrupt path after
enabling DMA in streamon routine. Otherwise the capture
interrupt won't be handled correctly causing non working
VIDIOC_DQBUF ioctl.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/fsl-viu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 031af16..4b2bba8 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -911,12 +911,16 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct viu_fh *fh = priv;
+	struct viu_dev *dev = fh->dev;
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	if (fh->type != i)
 		return -EINVAL;
 
+	if (dev->ovenable)
+		dev->ovenable = 0;
+
 	viu_start_dma(fh->dev);
 
 	return videobuf_streamon(&fh->vb_vidq);
-- 
1.7.1

