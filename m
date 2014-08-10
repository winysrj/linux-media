Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4274 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaHJL6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/19] cx23885: fix format colorspace compliance error
Date: Sun, 10 Aug 2014 13:57:44 +0200
Message-Id: <1407671876-39386-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
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
2.0.1

