Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:40937 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3CJOMx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:53 -0400
Received: by mail-la0-f47.google.com with SMTP id fj20so3039239lab.20
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:52 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 6/7] hverkuil/go7007: staging: media: go7007: Cleanup Unused modet code
Date: Sun, 10 Mar 2013 18:04:45 +0400
Message-Id: <1362924286-23995-6-git-send-email-volokh84@gmail.com>
In-Reply-To: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
References: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   94 ----------------------------
 1 files changed, 0 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 7ea0ea1..30ae939 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -292,64 +292,6 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	return 0;
 }
 
-#if 0
-static int clip_to_modet_map(struct go7007 *go, int region,
-		struct v4l2_clip *clip_list)
-{
-	struct v4l2_clip clip, *clip_ptr;
-	int x, y, mbnum;
-
-	/* Check if coordinates are OK and if any macroblocks are already
-	 * used by other regions (besides 0) */
-	clip_ptr = clip_list;
-	while (clip_ptr) {
-		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
-			return -EFAULT;
-		if (clip.c.left < 0 || (clip.c.left & 0xF) ||
-				clip.c.width <= 0 || (clip.c.width & 0xF))
-			return -EINVAL;
-		if (clip.c.left + clip.c.width > go->width)
-			return -EINVAL;
-		if (clip.c.top < 0 || (clip.c.top & 0xF) ||
-				clip.c.height <= 0 || (clip.c.height & 0xF))
-			return -EINVAL;
-		if (clip.c.top + clip.c.height > go->height)
-			return -EINVAL;
-		for (y = 0; y < clip.c.height; y += 16)
-			for (x = 0; x < clip.c.width; x += 16) {
-				mbnum = (go->width >> 4) *
-						((clip.c.top + y) >> 4) +
-					((clip.c.left + x) >> 4);
-				if (go->modet_map[mbnum] != 0 &&
-						go->modet_map[mbnum] != region)
-					return -EBUSY;
-			}
-		clip_ptr = clip.next;
-	}
-
-	/* Clear old region macroblocks */
-	for (mbnum = 0; mbnum < 1624; ++mbnum)
-		if (go->modet_map[mbnum] == region)
-			go->modet_map[mbnum] = 0;
-
-	/* Claim macroblocks in this list */
-	clip_ptr = clip_list;
-	while (clip_ptr) {
-		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
-			return -EFAULT;
-		for (y = 0; y < clip.c.height; y += 16)
-			for (x = 0; x < clip.c.width; x += 16) {
-				mbnum = (go->width >> 4) *
-						((clip.c.top + y) >> 4) +
-					((clip.c.left + x) >> 4);
-				go->modet_map[mbnum] = region;
-			}
-		clip_ptr = clip.next;
-	}
-	return 0;
-}
-#endif
-
 static int go7007_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct go7007 *go =
@@ -1045,42 +987,6 @@ static int vidioc_log_status(struct file *file, void *priv)
 	return call_all(&go->v4l2_dev, core, log_status);
 }
 
-/* FIXME:
-	Those ioctls are private, and not needed, since several standard
-	extended controls already provide streaming control.
-	So, those ioctls should be converted into vidioc_g_ext_ctrls()
-	and vidioc_s_ext_ctrls()
- */
-
-#if 0
-	case GO7007IOC_S_MD_PARAMS:
-	{
-		struct go7007_md_params *mdp = arg;
-
-		if (mdp->region > 3)
-			return -EINVAL;
-		if (mdp->trigger > 0) {
-			go->modet[mdp->region].pixel_threshold =
-					mdp->pixel_threshold >> 1;
-			go->modet[mdp->region].motion_threshold =
-					mdp->motion_threshold >> 1;
-			go->modet[mdp->region].mb_threshold =
-					mdp->trigger >> 1;
-			go->modet[mdp->region].enable = 1;
-		} else
-			go->modet[mdp->region].enable = 0;
-		/* fall-through */
-	}
-	case GO7007IOC_S_MD_REGION:
-	{
-		struct go7007_md_region *region = arg;
-
-		if (region->region < 1 || region->region > 3)
-			return -EINVAL;
-		return clip_to_modet_map(go, region->region, region->clips);
-	}
-#endif
-
 static struct v4l2_ctrl_ops go7007_ctrl_ops = {
 	.s_ctrl = go7007_s_ctrl,
 };
-- 
1.7.7.6

