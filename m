Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:56912 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728290AbeH1Rk7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Aug 2018 13:40:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 08/10] v4l2-ctrls: improve media_request_(un)lock_for_update
Date: Tue, 28 Aug 2018 15:49:09 +0200
Message-Id: <20180828134911.44086-9-hverkuil@xs4all.nl>
In-Reply-To: <20180828134911.44086-1-hverkuil@xs4all.nl>
References: <20180828134911.44086-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The request reference count was decreased again once a reference to the
request object was taken. Postpone this until we finished using the object.

In theory I think it is possible that the request_fd can be closed by
the application from another thread. In that case when request_put is
called the whole request would be freed.

It's highly unlikely, but let's just be safe and fix this potential
race condition.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index cc266a4a6e88..95d065d54308 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3657,10 +3657,9 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 		}
 
 		obj = v4l2_ctrls_find_req_obj(hdl, req, set);
-		/* Reference to the request held through obj */
-		media_request_put(req);
 		if (IS_ERR(obj)) {
 			media_request_unlock_for_update(req);
+			media_request_put(req);
 			return PTR_ERR(obj);
 		}
 		hdl = container_of(obj, struct v4l2_ctrl_handler,
@@ -3670,8 +3669,9 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh,
 	ret = try_set_ext_ctrls_common(fh, hdl, cs, set);
 
 	if (obj) {
-		media_request_unlock_for_update(obj->req);
+		media_request_unlock_for_update(req);
 		media_request_object_put(obj);
+		media_request_put(req);
 	}
 
 	return ret;
-- 
2.18.0
