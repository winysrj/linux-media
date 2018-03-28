Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42241 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752318AbeC1SMq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 14:12:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH for v3.18 07/18] media: v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
Date: Wed, 28 Mar 2018 15:12:26 -0300
Message-Id: <6e6f38fc8542cf41fffcd3067026c4f015564544.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 8ed5a59dcb47a6f76034ee760b36e089f3e82529 upstream.

The struct v4l2_plane32 should set m.userptr as well. The same
happens in v4l2_buffer32 and v4l2-compliance tests for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 47 ++++++++++++++++-----------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index b7dd98168a68..a27fd9105948 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -287,19 +287,24 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
 			 sizeof(up->data_offset)))
 		return -EFAULT;
 
-	if (memory == V4L2_MEMORY_USERPTR) {
+	switch (memory) {
+	case V4L2_MEMORY_MMAP:
+	case V4L2_MEMORY_OVERLAY:
+		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
+				 sizeof(up32->m.mem_offset)))
+			return -EFAULT;
+		break;
+	case V4L2_MEMORY_USERPTR:
 		if (get_user(p, &up32->m.userptr))
 			return -EFAULT;
 		up_pln = compat_ptr(p);
 		if (put_user((unsigned long)up_pln, &up->m.userptr))
 			return -EFAULT;
-	} else if (memory == V4L2_MEMORY_DMABUF) {
+		break;
+	case V4L2_MEMORY_DMABUF:
 		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
 			return -EFAULT;
-	} else {
-		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
-				 sizeof(up32->m.mem_offset)))
-			return -EFAULT;
+		break;
 	}
 
 	return 0;
@@ -308,22 +313,32 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
 static int put_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __user *up32,
 			    enum v4l2_memory memory)
 {
+	unsigned long p;
+
 	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
 	    copy_in_user(&up32->data_offset, &up->data_offset,
 			 sizeof(up->data_offset)))
 		return -EFAULT;
 
-	/* For MMAP, driver might've set up the offset, so copy it back.
-	 * USERPTR stays the same (was userspace-provided), so no copying. */
-	if (memory == V4L2_MEMORY_MMAP)
+	switch (memory) {
+	case V4L2_MEMORY_MMAP:
+	case V4L2_MEMORY_OVERLAY:
 		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
 				 sizeof(up->m.mem_offset)))
 			return -EFAULT;
-	/* For DMABUF, driver might've set up the fd, so copy it back. */
-	if (memory == V4L2_MEMORY_DMABUF)
+		break;
+	case V4L2_MEMORY_USERPTR:
+		if (get_user(p, &up->m.userptr) ||
+		    put_user((compat_ulong_t)ptr_to_compat((__force void *)p),
+			     &up32->m.userptr))
+			return -EFAULT;
+		break;
+	case V4L2_MEMORY_DMABUF:
 		if (copy_in_user(&up32->m.fd, &up->m.fd,
 				 sizeof(up->m.fd)))
 			return -EFAULT;
+		break;
+	}
 
 	return 0;
 }
@@ -383,6 +398,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	} else {
 		switch (kp->memory) {
 		case V4L2_MEMORY_MMAP:
+		case V4L2_MEMORY_OVERLAY:
 			if (get_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
@@ -396,10 +412,6 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 				kp->m.userptr = (unsigned long)compat_ptr(tmp);
 			}
 			break;
-		case V4L2_MEMORY_OVERLAY:
-			if (get_user(kp->m.offset, &up->m.offset))
-				return -EFAULT;
-			break;
 		case V4L2_MEMORY_DMABUF:
 			if (get_user(kp->m.fd, &up->m.fd))
 				return -EFAULT;
@@ -456,6 +468,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	} else {
 		switch (kp->memory) {
 		case V4L2_MEMORY_MMAP:
+		case V4L2_MEMORY_OVERLAY:
 			if (put_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
@@ -463,10 +476,6 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 			if (put_user(kp->m.userptr, &up->m.userptr))
 				return -EFAULT;
 			break;
-		case V4L2_MEMORY_OVERLAY:
-			if (put_user(kp->m.offset, &up->m.offset))
-				return -EFAULT;
-			break;
 		case V4L2_MEMORY_DMABUF:
 			if (put_user(kp->m.fd, &up->m.fd))
 				return -EFAULT;
-- 
2.14.3
