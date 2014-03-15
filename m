Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1151 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaCONIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:08:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH for v3.15 4/4] v4l2-ioctl.c: fix sparse __user-related warnings
Date: Sat, 15 Mar 2014 14:08:03 +0100
Message-Id: <1394888883-46850-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
References: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the use of __user in the user_ptr variable since the v4l2 structs are
actually defined without __user, instead cast to a __user pointer only
there where it is really needed: in the copy_to/from_user calls.

Also remove unnecessary casts in check_array_args and replace a wrong
cast (void *) with the correct one (void **).

This fixes these sparse warnings:

drivers/media/v4l2-core/v4l2-ioctl.c:2284:35: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2301:35: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2319:35: warning: incorrect type in assignment (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2386:57: warning: incorrect type in argument 4 (different address spaces)
drivers/media/v4l2-core/v4l2-ioctl.c:2420:29: warning: incorrect type in assignment (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d9113cc..3e0cf4f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2260,7 +2260,7 @@ done:
 }
 
 static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
-			    void * __user *user_ptr, void ***kernel_ptr)
+			    void **user_ptr, void ***kernel_ptr)
 {
 	int ret = 0;
 
@@ -2276,8 +2276,8 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 				ret = -EINVAL;
 				break;
 			}
-			*user_ptr = (void __user *)buf->m.planes;
-			*kernel_ptr = (void *)&buf->m.planes;
+			*user_ptr = buf->m.planes;
+			*kernel_ptr = (void **)&buf->m.planes;
 			*array_size = sizeof(struct v4l2_plane) * buf->length;
 			ret = 1;
 		}
@@ -2293,8 +2293,8 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 				ret = -EINVAL;
 				break;
 			}
-			*user_ptr = (void __user *)edid->edid;
-			*kernel_ptr = (void *)&edid->edid;
+			*user_ptr = edid->edid;
+			*kernel_ptr = (void **)&edid->edid;
 			*array_size = edid->blocks * 128;
 			ret = 1;
 		}
@@ -2311,8 +2311,8 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 				ret = -EINVAL;
 				break;
 			}
-			*user_ptr = (void __user *)ctrls->controls;
-			*kernel_ptr = (void *)&ctrls->controls;
+			*user_ptr = ctrls->controls;
+			*kernel_ptr = (void **)&ctrls->controls;
 			*array_size = sizeof(struct v4l2_ext_control)
 				    * ctrls->count;
 			ret = 1;
@@ -2334,7 +2334,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	long	err  = -EINVAL;
 	bool	has_array_args;
 	size_t  array_size = 0;
-	void __user *user_ptr = NULL;
+	void	*user_ptr = NULL;
 	void	**kernel_ptr = NULL;
 
 	/*  Copy arguments into temp kernel buffer  */
@@ -2395,7 +2395,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		if (NULL == mbuf)
 			goto out_array_args;
 		err = -EFAULT;
-		if (copy_from_user(mbuf, user_ptr, array_size))
+		if (copy_from_user(mbuf, (void __user *)user_ptr, array_size))
 			goto out_array_args;
 		*kernel_ptr = mbuf;
 	}
@@ -2413,7 +2413,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 
 	if (has_array_args) {
 		*kernel_ptr = user_ptr;
-		if (copy_to_user(user_ptr, mbuf, array_size))
+		if (copy_to_user((void __user *)user_ptr, mbuf, array_size))
 			err = -EFAULT;
 		goto out_array_args;
 	}
-- 
1.9.0

