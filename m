Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4734 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbaHNJyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 07/20] cx23885: fix format colorspace compliance error
Date: Thu, 14 Aug 2014 11:53:52 +0200
Message-Id: <1408010045-24016-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix v4l2-compliance failure relating to formatting.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 116ce34..ad02912 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -913,6 +913,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fh->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
@@ -957,6 +958,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
-- 
2.1.0.rc1

