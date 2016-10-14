Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757047AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 42/57] [media] pwc: don't break long lines
Date: Fri, 14 Oct 2016 17:20:30 -0300
Message-Id: <fe31e6628c63c5129f280b5c06c5cfae4f468cfb.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/pwc/pwc-if.c  | 3 +--
 drivers/media/usb/pwc/pwc-v4l.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index ff657644b6b3..aba3d4fad388 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -238,8 +238,7 @@ static void pwc_frame_complete(struct pwc_device *pdev)
 	} else {
 		/* Check for underflow first */
 		if (fbuf->filled < pdev->frame_total_size) {
-			PWC_DEBUG_FLOW("Frame buffer underflow (%d bytes);"
-				       " discarded.\n", fbuf->filled);
+			PWC_DEBUG_FLOW("Frame buffer underflow (%d bytes); discarded.\n", fbuf->filled);
 		} else {
 			fbuf->vb.field = V4L2_FIELD_NONE;
 			fbuf->vb.sequence = pdev->vframe_count;
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 3d987984602f..92f04db6bbae 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -406,8 +406,7 @@ static void pwc_vidioc_fill_fmt(struct v4l2_format *f,
 	f->fmt.pix.bytesperline = f->fmt.pix.width;
 	f->fmt.pix.sizeimage	= f->fmt.pix.height * f->fmt.pix.width * 3 / 2;
 	f->fmt.pix.colorspace	= V4L2_COLORSPACE_SRGB;
-	PWC_DEBUG_IOCTL("pwc_vidioc_fill_fmt() "
-			"width=%d, height=%d, bytesperline=%d, sizeimage=%d, pixelformat=%c%c%c%c\n",
+	PWC_DEBUG_IOCTL("pwc_vidioc_fill_fmt() width=%d, height=%d, bytesperline=%d, sizeimage=%d, pixelformat=%c%c%c%c\n",
 			f->fmt.pix.width,
 			f->fmt.pix.height,
 			f->fmt.pix.bytesperline,
@@ -473,8 +472,7 @@ static int pwc_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f)
 
 	pixelformat = f->fmt.pix.pixelformat;
 
-	PWC_DEBUG_IOCTL("Trying to set format to: width=%d height=%d fps=%d "
-			"format=%c%c%c%c\n",
+	PWC_DEBUG_IOCTL("Trying to set format to: width=%d height=%d fps=%d format=%c%c%c%c\n",
 			f->fmt.pix.width, f->fmt.pix.height, pdev->vframes,
 			(pixelformat)&255,
 			(pixelformat>>8)&255,
-- 
2.7.4


