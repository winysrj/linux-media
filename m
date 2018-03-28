Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:45354 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752866AbeC1Nul (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv9 PATCH 10/29] v4l2-ctrls: alloc memory for p_req
Date: Wed, 28 Mar 2018 15:50:11 +0200
Message-Id: <20180328135030.7116-11-hverkuil@xs4all.nl>
In-Reply-To: <20180328135030.7116-1-hverkuil@xs4all.nl>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

To store request data the handler_new_ref() allocates memory
for it if needed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d09f49530d9e..e8d6dee375ef 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1997,6 +1997,7 @@ EXPORT_SYMBOL(v4l2_ctrl_find);
 /* Allocate a new v4l2_ctrl_ref and hook it into the handler. */
 static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 			   struct v4l2_ctrl *ctrl,
+			   struct v4l2_ctrl_ref **ctrl_ref,
 			   bool from_other_dev)
 {
 	struct v4l2_ctrl_ref *ref;
@@ -2004,6 +2005,10 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	u32 id = ctrl->id;
 	u32 class_ctrl = V4L2_CTRL_ID2WHICH(id) | 1;
 	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
+	unsigned int sz_extra = 0;
+
+	if (ctrl_ref)
+		*ctrl_ref = NULL;
 
 	/*
 	 * Automatically add the control class if it is not yet present and
@@ -2017,11 +2022,16 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	if (hdl->error)
 		return hdl->error;
 
-	new_ref = kzalloc(sizeof(*new_ref), GFP_KERNEL);
+	if (hdl->req_obj.req)
+		sz_extra = ctrl->elems * ctrl->elem_size;
+	new_ref = kzalloc(sizeof(*new_ref) + sz_extra, GFP_KERNEL);
 	if (!new_ref)
 		return handler_set_err(hdl, -ENOMEM);
 	new_ref->ctrl = ctrl;
 	new_ref->from_other_dev = from_other_dev;
+	if (sz_extra)
+		new_ref->p_req.p = &new_ref[1];
+
 	if (ctrl->handler == hdl) {
 		/* By default each control starts in a cluster of its own.
 		   new_ref->ctrl is basically a cluster array with one
@@ -2061,6 +2071,8 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	/* Insert the control node in the hash */
 	new_ref->next = hdl->buckets[bucket];
 	hdl->buckets[bucket] = new_ref;
+	if (ctrl_ref)
+		*ctrl_ref = new_ref;
 
 unlock:
 	mutex_unlock(hdl->lock);
@@ -2202,7 +2214,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
 	}
 
-	if (handler_new_ref(hdl, ctrl, false)) {
+	if (handler_new_ref(hdl, ctrl, NULL, false)) {
 		kvfree(ctrl);
 		return NULL;
 	}
@@ -2395,7 +2407,7 @@ int v4l2_ctrl_add_handler(struct v4l2_ctrl_handler *hdl,
 		/* Filter any unwanted controls */
 		if (filter && !filter(ctrl))
 			continue;
-		ret = handler_new_ref(hdl, ctrl, from_other_dev);
+		ret = handler_new_ref(hdl, ctrl, NULL, from_other_dev);
 		if (ret)
 			break;
 	}
-- 
2.16.1
