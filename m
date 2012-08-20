Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47453 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab2HTBYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 21:24:30 -0400
Received: by mail-gh0-f174.google.com with SMTP id r11so4807916ghr.19
        for <linux-media@vger.kernel.org>; Sun, 19 Aug 2012 18:24:30 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 3/4] stk1160: Fix s_fmt and try_fmt implementation
Date: Sun, 19 Aug 2012 22:23:45 -0300
Message-Id: <1345425826-13429-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
References: <1345425826-13429-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver was expecting to get a valid pixelformat on s_fmt and try_fmt.
This is wrong, since the user may pass a bitmask and expect the driver
to change it, returning a valid (fourcc) pixelformat.

This problem was spotted by v4l2-compliance.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-v4l.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 1ad4ac1..63c5832 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -318,12 +318,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct stk1160 *dev = video_drvdata(file);
 
-	if (f->fmt.pix.pixelformat != format[0].fourcc) {
-		stk1160_err("fourcc format 0x%08x invalid\n",
-			f->fmt.pix.pixelformat);
-		return -EINVAL;
-	}
-
 	/*
 	 * User can't choose size at his own will,
 	 * so we just return him the current size chosen
@@ -331,6 +325,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	 * TODO: Implement frame scaling?
 	 */
 
+	f->fmt.pix.pixelformat = dev->fmt->fourcc;
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
@@ -346,14 +341,11 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct stk1160 *dev = video_drvdata(file);
 	struct vb2_queue *q = &dev->vb_vidq;
-	int rc;
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
-	rc = vidioc_try_fmt_vid_cap(file, priv, f);
-	if (rc < 0)
-		return rc;
+	vidioc_try_fmt_vid_cap(file, priv, f);
 
 	/* We don't support any format changes */
 
-- 
1.7.8.6

