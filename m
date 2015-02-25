Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:39320 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbbBYRSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 12:18:10 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] cx18: Fix bytes_per_line
Date: Wed, 25 Feb 2015 16:47:34 +0000
Message-Id: <1424882854-17768-1-git-send-email-simon.farnsworth@onelan.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current GStreamer userspace respects the bytes_per_line from the driver. Set
it to something reasonable for the format chosen.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---

I'm hoping this is trivially correct - I've only tested UYVY.

 drivers/media/pci/cx18/cx18-driver.h | 1 +
 drivers/media/pci/cx18/cx18-ioctl.c  | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.h b/drivers/media/pci/cx18/cx18-driver.h
index 207d6e82..ec40f2d 100644
--- a/drivers/media/pci/cx18/cx18-driver.h
+++ b/drivers/media/pci/cx18/cx18-driver.h
@@ -409,6 +409,7 @@ struct cx18_stream {
 	/* Videobuf for YUV video */
 	u32 pixelformat;
 	u32 vb_bytes_per_frame;
+	u32 vb_bytes_per_line;
 	struct list_head vb_capture;    /* video capture queue */
 	spinlock_t vb_lock;
 	struct timer_list vb_timeout;
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index b8e4b68..c2e0093 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -159,7 +159,7 @@ static int cx18_g_fmt_vid_cap(struct file *file, void *fh,
 	if (id->type == CX18_ENC_STREAM_TYPE_YUV) {
 		pixfmt->pixelformat = s->pixelformat;
 		pixfmt->sizeimage = s->vb_bytes_per_frame;
-		pixfmt->bytesperline = 720;
+		pixfmt->bytesperline = s->vb_bytes_per_line;
 	} else {
 		pixfmt->pixelformat = V4L2_PIX_FMT_MPEG;
 		pixfmt->sizeimage = 128 * 1024;
@@ -287,10 +287,13 @@ static int cx18_s_fmt_vid_cap(struct file *file, void *fh,
 	s->pixelformat = fmt->fmt.pix.pixelformat;
 	/* HM12 YUV size is (Y=(h*720) + UV=(h*(720/2)))
 	   UYUV YUV size is (Y=(h*720) + UV=(h*(720))) */
-	if (s->pixelformat == V4L2_PIX_FMT_HM12)
+	if (s->pixelformat == V4L2_PIX_FMT_HM12) {
 		s->vb_bytes_per_frame = h * 720 * 3 / 2;
-	else
+		s->vb_bytes_per_line = 720; /* First plane */
+	} else {
 		s->vb_bytes_per_frame = h * 720 * 2;
+		s->vb_bytes_per_line = 1440; /* Packed */
+	}
 
 	mbus_fmt.width = cx->cxhdl.width = w;
 	mbus_fmt.height = cx->cxhdl.height = h;
-- 
2.1.0

