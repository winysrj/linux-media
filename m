Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2297 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934522Ab3DHK7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/12] hdpvr: small fixes
Date: Mon,  8 Apr 2013 12:58:36 +0200
Message-Id: <1365418721-23859-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- return EBUSY instead of EAGAIN.
- add missing break.
- remove unnecessary buf type check (done by the core).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 406eda8..e14bf49 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -594,7 +594,7 @@ static int vidioc_s_input(struct file *file, void *private_data,
 		return -EINVAL;
 
 	if (dev->status != STATUS_IDLE)
-		return -EAGAIN;
+		return -EBUSY;
 
 	retval = hdpvr_config_call(dev, CTRL_VIDEO_INPUT_VALUE, index+1);
 	if (!retval)
@@ -646,7 +646,7 @@ static int vidioc_s_audio(struct file *file, void *private_data,
 		return -EINVAL;
 
 	if (dev->status != STATUS_IDLE)
-		return -EAGAIN;
+		return -EBUSY;
 
 	retval = hdpvr_set_audio(dev, audio->index+1, dev->options.audio_codec);
 	if (!retval)
@@ -777,7 +777,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
 				    struct v4l2_fmtdesc *f)
 {
 
-	if (f->index != 0 || f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (f->index != 0)
 		return -EINVAL;
 
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
-- 
1.7.10.4

