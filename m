Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35207 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbcGTMbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 08:31:31 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E42BF180496
	for <linux-media@vger.kernel.org>; Wed, 20 Jul 2016 14:31:25 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: return -ENODATA if the current input doesn't support
 g/s_selection
Message-ID: <1dc0cf10-5278-4430-b925-51eca4dc4599@xs4all.nl>
Date: Wed, 20 Jul 2016 14:31:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Returning -EINVAL indicates wrong arguments, but that's not the case here.

Returning -ENOTTY is also no option, since the ioctl is implemented, but it just is not valid for
this input.

So use -ENODATA instead. This is also used elsewhere when an ioctl isn't valid for a specific
input.

In this case G/S_SELECTION returned -EINVAL for the webcam input. That input doesn't support
cropping, instead it uses ENUM_FRAMESIZES to enumerate a list of discrete frame sizes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
A patch for docs-next will follow.
---
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index d404a7c..d5c84ec 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -823,7 +823,7 @@ int vivid_vid_cap_g_selection(struct file *file, void *priv,
 	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	if (vivid_is_webcam(dev))
-		return -EINVAL;
+		return -ENODATA;

 	sel->r.left = sel->r.top = 0;
 	switch (sel->target) {
@@ -872,7 +872,7 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	if (vivid_is_webcam(dev))
-		return -EINVAL;
+		return -ENODATA;

 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP:
