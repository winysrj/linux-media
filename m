Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1435 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaITNTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 09:19:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/2] cx23885: fix size helper functions
Date: Sat, 20 Sep 2014 15:19:33 +0200
Message-Id: <1411219173-32869-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411219173-32869-1-git-send-email-hverkuil@xs4all.nl>
References: <1411219173-32869-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The norm_swidth function was unused and is dropped. It's not clear
what the purpose of that function was.

The norm_maxh function was changed so it tests for 60 Hz standards
rather than for 50 Hz standards. The is the preferred order.

The norm_maxw function was poorly written and used: it gives the maximum
allowed line width for the given standard. For 60 Hz that's 720, but
for 50 Hz that's 768 which allows for 768x576 which gives you square
pixels. For 60 Hz formats it is 640x480 that gives square pixels, so
there is no need to go beyond 720.

The initial width was set using norm_maxh(), which was wrong. Just set
to 720, that's what you normally use. Since the initial standard was
NTSC anyway the initial width was always 720 anyway.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 2 +-
 drivers/media/pci/cx23885/cx23885.h       | 9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index f0ea904..682a4f9 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1154,7 +1154,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	dev->tvnorm = V4L2_STD_NTSC_M;
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
 	dev->field = V4L2_FIELD_INTERLACED;
-	dev->width = norm_maxw(dev->tvnorm);
+	dev->width = 720;
 	dev->height = norm_maxh(dev->tvnorm);
 
 	/* init video dma queues */
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 0e4f406..39a8985 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -612,15 +612,10 @@ extern int cx23885_risc_databuffer(struct pci_dev *pci,
 
 static inline unsigned int norm_maxw(v4l2_std_id norm)
 {
-	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 720 : 768;
+	return (norm & V4L2_STD_525_60) ? 720 : 768;
 }
 
 static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
-	return (norm & V4L2_STD_625_50) ? 576 : 480;
-}
-
-static inline unsigned int norm_swidth(v4l2_std_id norm)
-{
-	return (norm & (V4L2_STD_MN & ~V4L2_STD_PAL_Nc)) ? 754 : 922;
+	return (norm & V4L2_STD_525_60) ? 480 : 576;
 }
-- 
2.1.0

