Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:56552 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbeIGDEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Sep 2018 23:04:53 -0400
From: Paul Kocialkowski <contact@paulk.fr>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <contact@paulk.fr>
Subject: [PATCH v9 1/9] media: videobuf2-core: Rework and rename helper for request buffer count
Date: Fri,  7 Sep 2018 00:24:34 +0200
Message-Id: <20180906222442.14825-2-contact@paulk.fr>
In-Reply-To: <20180906222442.14825-1-contact@paulk.fr>
References: <20180906222442.14825-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The helper indicating whether buffers are associated with the request is
reworked and renamed to return the number of associated buffer objects.

This is useful for drivers that need to check how many buffers are in
the request to validate it.

Existing users of the helper don't need particular adaptation since the
meaning of zero/non-zero remains consistent.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
---
 .../media/common/videobuf2/videobuf2-core.c    | 18 ++++++++----------
 .../media/common/videobuf2/videobuf2-v4l2.c    |  2 +-
 include/media/videobuf2-core.h                 |  4 ++--
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index cb86b02afd4a..194b9188ad3e 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1368,23 +1368,21 @@ bool vb2_request_object_is_buffer(struct media_request_object *obj)
 }
 EXPORT_SYMBOL_GPL(vb2_request_object_is_buffer);
 
-bool vb2_request_has_buffers(struct media_request *req)
+unsigned int vb2_request_buffer_cnt(struct media_request *req)
 {
 	struct media_request_object *obj;
 	unsigned long flags;
-	bool has_buffers = false;
+	unsigned int buffer_cnt = 0;
 
 	spin_lock_irqsave(&req->lock, flags);
-	list_for_each_entry(obj, &req->objects, list) {
-		if (vb2_request_object_is_buffer(obj)) {
-			has_buffers = true;
-			break;
-		}
-	}
+	list_for_each_entry(obj, &req->objects, list)
+		if (vb2_request_object_is_buffer(obj))
+			buffer_cnt++;
 	spin_unlock_irqrestore(&req->lock, flags);
-	return has_buffers;
+
+	return buffer_cnt;
 }
-EXPORT_SYMBOL_GPL(vb2_request_has_buffers);
+EXPORT_SYMBOL_GPL(vb2_request_buffer_cnt);
 
 int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 {
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 6831a2eb1859..a17033ab2c22 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -1139,7 +1139,7 @@ int vb2_request_validate(struct media_request *req)
 	struct media_request_object *obj;
 	int ret = 0;
 
-	if (!vb2_request_has_buffers(req))
+	if (!vb2_request_buffer_cnt(req))
 		return -ENOENT;
 
 	list_for_each_entry(obj, &req->objects, list) {
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 6c76b9802589..e86981d615ae 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1191,10 +1191,10 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 bool vb2_request_object_is_buffer(struct media_request_object *obj);
 
 /**
- * vb2_request_has_buffers() - return true if the request contains buffers
+ * vb2_request_buffer_cnt() - return the number of buffers in the request
  *
  * @req:	the request.
  */
-bool vb2_request_has_buffers(struct media_request *req);
+unsigned int vb2_request_buffer_cnt(struct media_request *req);
 
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
2.18.0
