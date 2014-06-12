Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2314 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbaFLLyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 16/34] v4l2-ctrl: fix error return of copy_to/from_user.
Date: Thu, 12 Jun 2014 13:52:48 +0200
Message-Id: <9ea9d9d31524ca60945a374c9bbcac1c38371a50.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

copy_to/from_user returns the number of bytes not copied, it does not
return a 'normal' linux error code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e6e33b3..1086ae3 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1326,7 +1326,8 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 	u32 len;
 
 	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_to_user(c->ptr, ptr.p, c->size);
+		return copy_to_user(c->ptr, ptr.p, c->size) ?
+		       -EFAULT : 0;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
@@ -1336,7 +1337,7 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 			return -ENOSPC;
 		}
 		return copy_to_user(c->string, ptr.p_char, len + 1) ?
-								-EFAULT : 0;
+		       -EFAULT : 0;
 	case V4L2_CTRL_TYPE_INTEGER64:
 		c->value64 = *ptr.p_s64;
 		break;
@@ -1373,7 +1374,7 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 	if (ctrl->is_ptr && !ctrl->is_string) {
 		unsigned idx;
 
-		ret = copy_from_user(ptr.p, c->ptr, c->size);
+		ret = copy_from_user(ptr.p, c->ptr, c->size) ? -EFAULT : 0;
 		if (ret || !ctrl->is_array)
 			return ret;
 		for (idx = c->size / ctrl->elem_size; idx < ctrl->elems; idx++)
@@ -1391,7 +1392,7 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 			return -ERANGE;
 		if (size > ctrl->maximum + 1)
 			size = ctrl->maximum + 1;
-		ret = copy_from_user(ptr.p_char, c->string, size);
+		ret = copy_from_user(ptr.p_char, c->string, size) ? -EFAULT : 0;
 		if (!ret) {
 			char last = ptr.p_char[size - 1];
 
@@ -1401,7 +1402,7 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 			if (strlen(ptr.p_char) == ctrl->maximum && last)
 				return -ERANGE;
 		}
-		return ret ? -EFAULT : 0;
+		return ret;
 	default:
 		*ptr.p_s32 = c->value;
 		break;
-- 
2.0.0.rc0

