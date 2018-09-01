Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:34074 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbeIAQ6O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Sep 2018 12:58:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 07/10] v4l2-ctrls: use media_request_(un)lock_for_access
Date: Sat,  1 Sep 2018 14:46:08 +0200
Message-Id: <20180901124611.45345-8-hverkuil@xs4all.nl>
In-Reply-To: <20180901124611.45345-1-hverkuil@xs4all.nl>
References: <20180901124611.45345-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When getting control values from a completed request, we have
to protect the request against being re-inited when it is
being accessed by calling media_request_(un)lock_for_access.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ccaf3068de6d..cc266a4a6e88 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3289,11 +3289,10 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 		     struct v4l2_ext_controls *cs)
 {
 	struct media_request_object *obj = NULL;
+	struct media_request *req = NULL;
 	int ret;
 
 	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
-		struct media_request *req;
-
 		if (!mdev || cs->request_fd < 0)
 			return -EINVAL;
 
@@ -3306,11 +3305,18 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 			return -EACCES;
 		}
 
+		ret = media_request_lock_for_access(req);
+		if (ret) {
+			media_request_put(req);
+			return ret;
+		}
+
 		obj = v4l2_ctrls_find_req_obj(hdl, req, false);
-		/* Reference to the request held through obj */
-		media_request_put(req);
-		if (IS_ERR(obj))
+		if (IS_ERR(obj)) {
+			media_request_unlock_for_access(req);
+			media_request_put(req);
 			return PTR_ERR(obj);
+		}
 
 		hdl = container_of(obj, struct v4l2_ctrl_handler,
 				   req_obj);
@@ -3318,8 +3324,11 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
 
 	ret = v4l2_g_ext_ctrls_common(hdl, cs);
 
-	if (obj)
+	if (obj) {
+		media_request_unlock_for_access(req);
 		media_request_object_put(obj);
+		media_request_put(req);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_g_ext_ctrls);
-- 
2.18.0
