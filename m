Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:33536 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752201AbdKMOeL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 09:34:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/6] v4l2-ctrls: prepare internal structs for request API
Date: Mon, 13 Nov 2017 15:34:04 +0100
Message-Id: <20171113143408.19644-3-hverkuil@xs4all.nl>
In-Reply-To: <20171113143408.19644-1-hverkuil@xs4all.nl>
References: <20171113143408.19644-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a refcount and is_request bool to struct v4l2_ctrl_handler:
this is used to refcount a handler that represents a request.

Add a p_req field to struct v4l2_ctrl_ref that will store the
request value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
 include/media/v4l2-ctrls.h           | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 2e58381444d1..1ff8fc59fff5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1761,6 +1761,7 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
 				      sizeof(hdl->buckets[0]),
 				      GFP_KERNEL | __GFP_ZERO);
 	hdl->error = hdl->buckets ? 0 : -ENOMEM;
+	hdl->is_request = false;
 	return hdl->error;
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_init_class);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a762f3392d90..a215f25a82cf 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -18,6 +18,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
 
@@ -250,6 +251,7 @@ struct v4l2_ctrl_ref {
 	struct v4l2_ctrl_ref *next;
 	struct v4l2_ctrl *ctrl;
 	struct v4l2_ctrl_helper *helper;
+	union v4l2_ctrl_ptr p_req;
 	bool from_other_dev;
 };
 
@@ -285,7 +287,9 @@ struct v4l2_ctrl_handler {
 	v4l2_ctrl_notify_fnc notify;
 	void *notify_priv;
 	u16 nr_of_buckets;
+	bool is_request;
 	int error;
+	struct kref ref;
 };
 
 /**
-- 
2.14.1
