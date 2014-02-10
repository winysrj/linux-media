Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4997 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaBJLJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 06:09:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 5/5] vivi: queue_setup improvements.
Date: Mon, 10 Feb 2014 12:08:47 +0100
Message-Id: <1392030527-32661-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
References: <1392030527-32661-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the vid_limit module option: there is really no need to limit this.
No other driver does that. If you try to allocate more buffers then vb2
will automatically reduce the number of buffers anyway.

Also add sanity checks if the size in the fmt argument is going to be
used and drop the code that checks against *nbuffers == 0: this can
never happen (the vb2 framework ensures that) and the code was wrong
anyway since *nbuffers should have been set to the minimum number of
required buffers which is 1 for this driver.

Since vivi is often used as a template driver it is good to have this
driver be as compliant as possible. This broken code was for example
copied to the s2255 driver (which is being fixed as well).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 4114bb6..e9cd96e 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -70,10 +70,6 @@ static unsigned debug;
 module_param(debug, uint, 0644);
 MODULE_PARM_DESC(debug, "activates debug info");
 
-static unsigned int vid_limit = 16;
-module_param(vid_limit, uint, 0644);
-MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
-
 /* Global font descriptor */
 static const u8 *font8x16;
 
@@ -816,19 +812,15 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
 	unsigned long size;
 
-	if (fmt)
+	size = dev->width * dev->height * dev->pixelsize;
+	if (fmt) {
+		if (fmt->fmt.pix.sizeimage < size)
+			return -EINVAL;
 		size = fmt->fmt.pix.sizeimage;
-	else
-		size = dev->width * dev->height * dev->pixelsize;
-
-	if (size == 0)
-		return -EINVAL;
-
-	if (0 == *nbuffers)
-		*nbuffers = 32;
-
-	while (size * *nbuffers > vid_limit * 1024 * 1024)
-		(*nbuffers)--;
+		/* check against insane over 8K resolution buffers */
+		if (size > 7680 * 4320 * dev->pixelsize)
+			return -EINVAL;
+	}
 
 	*nplanes = 1;
 
-- 
1.8.5.2

