Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4101 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaA0OfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 09:35:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 17/22] v4l2-ctrls: return elem_size instead of strlen
Date: Mon, 27 Jan 2014 15:34:19 +0100
Message-Id: <1390833264-8503-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
References: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When getting a string and the size given by the application is too
short return the max length the string can have (elem_size) instead
of the string length + 1. That makes more sense.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b4a9ada..160e4c7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1298,7 +1298,7 @@ static int ptr_to_user(struct v4l2_ext_control *c,
 	case V4L2_CTRL_TYPE_STRING:
 		len = strlen(ptr.p_char);
 		if (c->size < len + 1) {
-			c->size = len + 1;
+			c->size = ctrl->elem_size;
 			return -ENOSPC;
 		}
 		return copy_to_user(c->string, ptr.p_char, len + 1) ?
-- 
1.8.5.2

