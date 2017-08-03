Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35447 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdHCWDt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 18:03:49 -0400
Received: by mail-pf0-f177.google.com with SMTP id t86so66247pfe.2
        for <linux-media@vger.kernel.org>; Thu, 03 Aug 2017 15:03:49 -0700 (PDT)
From: Daniel Mentz <danielmentz@google.com>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] v4l2-compat-ioctl32: Copy v4l2_window->global_alpha
Date: Thu,  3 Aug 2017 15:03:10 -0700
Message-Id: <20170803220310.1550-1-danielmentz@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit b2787845fb91 ("V4L/DVB (5289): Add support for video output
overlays.") added the field global_alpha to struct v4l2_window but did
not update the compat layer accordingly. This change adds global_alpha
to struct v4l2_window32 and copies the value for global_alpha back and
forth.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Daniel Mentz <danielmentz@google.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 6f52970f8b54..84ad195562c7 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -43,6 +43,7 @@ struct v4l2_window32 {
 	compat_caddr_t		clips; /* actually struct v4l2_clip32 * */
 	__u32			clipcount;
 	compat_caddr_t		bitmap;
+	__u8                    global_alpha;
 };
 
 static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
@@ -51,7 +52,8 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 		copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
 		get_user(kp->field, &up->field) ||
 		get_user(kp->chromakey, &up->chromakey) ||
-		get_user(kp->clipcount, &up->clipcount))
+		get_user(kp->clipcount, &up->clipcount) ||
+		get_user(kp->global_alpha, &up->global_alpha))
 			return -EFAULT;
 	if (kp->clipcount > 2048)
 		return -EINVAL;
@@ -84,7 +86,8 @@ static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
 		put_user(kp->field, &up->field) ||
 		put_user(kp->chromakey, &up->chromakey) ||
-		put_user(kp->clipcount, &up->clipcount))
+		put_user(kp->clipcount, &up->clipcount) ||
+		put_user(kp->global_alpha, &up->global_alpha))
 			return -EFAULT;
 	return 0;
 }
-- 
2.14.0.rc1.383.gd1ce394fe2-goog
