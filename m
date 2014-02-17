Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4170 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaBQJ66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 04:58:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 18/35] v4l2-ctrl: fix error return of copy_to/from_user.
Date: Mon, 17 Feb 2014 10:57:33 +0100
Message-Id: <1392631070-41868-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
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
index c55cabb..1886b79 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1292,7 +1292,8 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 	u32 len;
 
 	if (ctrl->is_ptr && !ctrl->is_string)
-		return copy_to_user(c->p, ptr.p, c->size);
+		return copy_to_user(c->p, ptr.p, c->size) ?
+		       -EFAULT : 0;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_STRING:
@@ -1302,7 +1303,7 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 			return -ENOSPC;
 		}
 		return copy_to_user(c->string, ptr.p_char, len + 1) ?
-								-EFAULT : 0;
+		       -EFAULT : 0;
 	case V4L2_CTRL_TYPE_INTEGER64:
 		c->value64 = *ptr.p_s64;
 		break;
@@ -1339,7 +1340,7 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 	if (ctrl->is_ptr && !ctrl->is_string) {
 		unsigned idx;
 
-		ret = copy_from_user(ptr.p, c->p, c->size);
+		ret = copy_from_user(ptr.p, c->p, c->size) ? -EFAULT : 0;
 		if (ret || !ctrl->is_matrix)
 			return ret;
 		for (idx = c->size / ctrl->elem_size;
@@ -1358,7 +1359,7 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 			return -ERANGE;
 		if (size > ctrl->maximum + 1)
 			size = ctrl->maximum + 1;
-		ret = copy_from_user(ptr.p_char, c->string, size);
+		ret = copy_from_user(ptr.p_char, c->string, size) ? -EFAULT : 0;
 		if (!ret) {
 			char last = ptr.p_char[size - 1];
 
@@ -1368,7 +1369,7 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 			if (strlen(ptr.p_char) == ctrl->maximum && last)
 				return -ERANGE;
 		}
-		return ret ? -EFAULT : 0;
+		return ret;
 	default:
 		*ptr.p_s32 = c->value;
 		break;
-- 
1.8.4.rc3

