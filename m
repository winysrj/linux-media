Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:11008 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752468AbcAOJNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 04:13:48 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH v3] media: v4l2-compat-ioctl32: fix missing length copy in put_v4l2_buffer32
Date: Fri, 15 Jan 2016 17:13:36 +0800
Message-ID: <1452849216-4793-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In v4l2-compliance utility, test QUERYBUF required correct length
value to go through each planar to check planar's length in
multi-planar buffer type

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 327e83a..6181470 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -426,10 +426,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 					&up->timestamp.tv_usec))
 			return -EFAULT;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
-		if (get_user(kp->length, &up->length))
-			return -EFAULT;
+	if (get_user(kp->length, &up->length))
+		return -EFAULT;
 
+	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
 		num_planes = kp->length;
 		if (num_planes == 0) {
 			kp->m.planes = NULL;
@@ -462,16 +462,14 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	} else {
 		switch (kp->memory) {
 		case V4L2_MEMORY_MMAP:
-			if (get_user(kp->length, &up->length) ||
-				get_user(kp->m.offset, &up->m.offset))
+			if (get_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_USERPTR:
 			{
 			compat_long_t tmp;
 
-			if (get_user(kp->length, &up->length) ||
-			    get_user(tmp, &up->m.userptr))
+			if (get_user(tmp, &up->m.userptr))
 				return -EFAULT;
 
 			kp->m.userptr = (unsigned long)compat_ptr(tmp);
@@ -516,6 +514,9 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->reserved, &up->reserved))
 			return -EFAULT;
 
+	if (put_user(kp->length, &up->length))
+		return -EFAULT;
+
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
 		num_planes = kp->length;
 		if (num_planes == 0)
@@ -536,13 +537,11 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 	} else {
 		switch (kp->memory) {
 		case V4L2_MEMORY_MMAP:
-			if (put_user(kp->length, &up->length) ||
-				put_user(kp->m.offset, &up->m.offset))
+			if (put_user(kp->m.offset, &up->m.offset))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_USERPTR:
-			if (put_user(kp->length, &up->length) ||
-				put_user(kp->m.userptr, &up->m.userptr))
+			if (put_user(kp->m.userptr, &up->m.userptr))
 				return -EFAULT;
 			break;
 		case V4L2_MEMORY_OVERLAY:
-- 
1.7.9.5

