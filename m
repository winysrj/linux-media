Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2921 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbaCQMys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 08:54:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH for v3.15 5/5] v4l2-ioctl.c: fix sparse __user-related warnings
Date: Mon, 17 Mar 2014 13:54:23 +0100
Message-Id: <1395060863-42211-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
References: <1395060863-42211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix the use of __user in the check_array_args() prototype: instead of
using 'void * __user *' you should use 'void __user **' for sparse to
understand this correctly.

This also required the use of __force in the '*kernel_ptr = user_ptr'
assignment.

Also replace a wrong cast (void *) with the correct one (void **)
in check_array_args().

This fixes these sparse warnings:

drivers/media/v4l2-core/v4l2-ioctl.c:2284:35: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2301:35: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2319:35: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2386:57: warning: incorrect type in argument 4 (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2420:29: warning: incorrect type in assignment (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d9113cc..f729bd2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2260,7 +2260,7 @@ done:
 }
 
 static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
-			    void * __user *user_ptr, void ***kernel_ptr)
+			    void __user **user_ptr, void ***kernel_ptr)
 {
 	int ret = 0;
 
@@ -2277,7 +2277,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 				break;
 			}
 			*user_ptr = (void __user *)buf->m.planes;
-			*kernel_ptr = (void *)&buf->m.planes;
+			*kernel_ptr = (void **)&buf->m.planes;
 			*array_size = sizeof(struct v4l2_plane) * buf->length;
 			ret = 1;
 		}
@@ -2294,7 +2294,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 				break;
 			}
 			*user_ptr = (void __user *)edid->edid;
-			*kernel_ptr = (void *)&edid->edid;
+			*kernel_ptr = (void **)&edid->edid;
 			*array_size = edid->blocks * 128;
 			ret = 1;
 		}
@@ -2312,7 +2312,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 				break;
 			}
 			*user_ptr = (void __user *)ctrls->controls;
-			*kernel_ptr = (void *)&ctrls->controls;
+			*kernel_ptr = (void **)&ctrls->controls;
 			*array_size = sizeof(struct v4l2_ext_control)
 				    * ctrls->count;
 			ret = 1;
@@ -2412,7 +2412,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	}
 
 	if (has_array_args) {
-		*kernel_ptr = user_ptr;
+		*kernel_ptr = (void __force *)user_ptr;
 		if (copy_to_user(user_ptr, mbuf, array_size))
 			err = -EFAULT;
 		goto out_array_args;
-- 
1.9.0

