Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49589 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbbA2Bn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:43:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: [PATCH v2 2/6] v4l2-ctrls: Don't initialize array tail when setting a control
Date: Wed, 28 Jan 2015 11:17:15 +0200
Message-Id: <1422436639-18292-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting an array control subset isn't allowed by the control framework,
which returns an error in prepare_ext_ctrls() if the control size
specified by userspace is smaller than the total size. There is thus no
need to initialize the array tail to its default value, as the tail will
always be empty.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 301abb7..adac93e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1518,13 +1518,9 @@ static int user_to_ptr(struct v4l2_ext_control *c,
 
 	ctrl->is_new = 1;
 	if (ctrl->is_ptr && !ctrl->is_string) {
-		unsigned idx;
-
 		ret = copy_from_user(ptr.p, c->ptr, c->size) ? -EFAULT : 0;
 		if (ret || !ctrl->is_array)
 			return ret;
-		for (idx = c->size / ctrl->elem_size; idx < ctrl->elems; idx++)
-			ctrl->type_ops->init(ctrl, idx, ptr);
 		return 0;
 	}
 
-- 
2.0.5

