Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36992 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441AbcBQKrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 05:47:32 -0500
Received: by mail-wm0-f50.google.com with SMTP id g62so21951320wme.0
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 02:47:31 -0800 (PST)
From: Kevin Grandemange <grandemange.kevin@gmail.com>
To: linux-media@vger.kernel.org
Cc: Kevin Grandemange <grandemange.kevin@gmail.com>
Subject: [PATCH] [media] media/core: copy user v4l2_buffer.length in DMABUF case
Date: Wed, 17 Feb 2016 11:47:23 +0100
Message-Id: <1455706043-7160-1-git-send-email-grandemange.kevin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

in __qbuf_dmabuf, we check the dmabuf size against the plane size.

In the monoplanar case, this length was not copied from the userspace
and we were getting a random value.

Signed-off-by: Kevin Grandemange <grandemange.kevin@gmail.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8fd84a6..af0e01c 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -482,7 +482,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_DMABUF:
-			if (get_user(kp->m.fd, &up->m.fd))
+			if (get_user(kp->length, &up->length) ||
+			    get_user(kp->m.fd, &up->m.fd))
 				return -EFAULT;
 			break;
 		}
-- 
2.7.0.rc3

