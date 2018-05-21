Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28373 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752697AbeEUIzV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:55:21 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v14 24/36] videobuf2-v4l2: Lock the media request for update for QBUF
Date: Mon, 21 May 2018 11:54:49 +0300
Message-Id: <20180521085501.16861-25-sakari.ailus@linux.intel.com>
In-Reply-To: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
References: <20180521085501.16861-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lock the media request for updating on QBUF IOCTL using
media_request_lock_for_update().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 0a68b19b40da7..8b390960ca671 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -398,12 +398,13 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 	if (IS_ERR(req)) {
 		dprintk(1, "%s: invalid request_fd\n", opname);
 		return PTR_ERR(req);
-	}
-
-	if (atomic_read(&req->state) != MEDIA_REQUEST_STATE_IDLE) {
-		dprintk(1, "%s: request is not idle\n", opname);
-		media_request_put(req);
-		return -EBUSY;
+	} else {
+		ret = media_request_lock_for_update(req);
+		if (ret) {
+			media_request_put(req);
+			dprintk(1, "%s: request %d busy\n", opname, b->request_fd);
+			return PTR_ERR(req);
+		}
 	}
 
 	*p_req = req;
@@ -683,8 +684,10 @@ int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
 	if (ret)
 		return ret;
 	ret = vb2_core_qbuf(q, b->index, b, req);
-	if (req)
+	if (req) {
+		media_request_unlock_for_update(req);
 		media_request_put(req);
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
-- 
2.11.0
