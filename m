Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:34446 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbbKXSqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2015 13:46:45 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] cx18: Fix VIDIOC_TRY_FMT to fill in sizeimage and bytesperline
Date: Tue, 24 Nov 2015 18:09:40 +0000
Message-Id: <1448388580-22082-1-git-send-email-simon.farnsworth@onelan.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was having trouble capturing raw video from GStreamer; turns out that I
now need VIDIOC_TRY_FMT to fill in sizeimage and bytesperline to make it work.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---

I'm leaving ONELAN on Friday, so this is a drive-by patch being sent for the
benefit of anyone else trying to use raw capture from a cx18 card. If it's
not suitable for applying as-is, please feel free to just leave it in the
archives so that someone else hitting the same problem can find my fix.

 drivers/media/pci/cx18/cx18-ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 55525af..1c9924a 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -234,6 +234,13 @@ static int cx18_try_fmt_vid_cap(struct file *file, void *fh,
 
 	fmt->fmt.pix.width = w;
 	fmt->fmt.pix.height = h;
+	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_HM12) {
+		fmt->fmt.pix.sizeimage = h * 720 * 3 / 2;
+		fmt->fmt.pix.bytesperline = 720; /* First plane */
+	} else {
+		fmt->fmt.pix.sizeimage = h * 720 * 2;
+		fmt->fmt.pix.bytesperline = 1440; /* Packed */
+	}
 	return 0;
 }
 
-- 
2.1.0

