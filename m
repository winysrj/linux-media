Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF89C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6417F20896
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfANNjD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:39:03 -0500
Received: from mail.bootlin.com ([62.4.15.54]:51445 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfANNjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:39:03 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id E27AA20955; Mon, 14 Jan 2019 14:39:00 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id 6D91620728;
        Mon, 14 Jan 2019 14:39:00 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC 1/4] media: vb2: Add helpers to access unselected buffers
Date:   Mon, 14 Jan 2019 14:38:36 +0100
Message-Id: <20190114133839.29967-2-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
References: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Introduce helpers to request and release access to buffers that are
not currently selected as current output or capture buffers.

This is useful to ensure proper access to buffers imported via dma-buf
that are used as reference and thus require associated map/unmap calls
before access.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 .../media/common/videobuf2/videobuf2-core.c   | 46 +++++++++++++++++++
 include/media/videobuf2-core.h                | 15 ++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 70e8c3366f9c..2a0c5de4d683 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -986,6 +986,52 @@ void vb2_discard_done(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_discard_done);
 
+int vb2_buffer_access_request(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+	int ret;
+
+	/* Only dmabuf-imported buffers need to be mapped before access. */
+	if (q->memory != VB2_MEMORY_DMABUF)
+		return -EINVAL;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		if (vb->planes[plane].dbuf_mapped)
+			continue;
+
+		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
+		if (ret) {
+			dprintk(1, "failed to map dmabuf for plane %d\n",
+				plane);
+			return ret;
+		}
+		vb->planes[plane].dbuf_mapped = 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vb2_buffer_access_request);
+
+void vb2_buffer_access_release(struct vb2_buffer *vb)
+{
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+
+	/* Only dmabuf-imported buffers need to be unmapped after access. */
+	if (q->memory != VB2_MEMORY_DMABUF)
+		return;
+
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		if (!vb->planes[plane].dbuf_mapped)
+			continue;
+
+		call_void_memop(vb, unmap_dmabuf, vb->planes[plane].mem_priv);
+		vb->planes[plane].dbuf_mapped = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(vb2_buffer_access_release);
+
 /*
  * __prepare_mmap() - prepare an MMAP buffer
  */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4a737b2c610b..bf378c1e718b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -1199,4 +1199,19 @@ bool vb2_request_object_is_buffer(struct media_request_object *obj);
  */
 unsigned int vb2_request_buffer_cnt(struct media_request *req);
 
+/**
+ * vb2_buffer_access_request() - request out-of-band data access to a buffer
+ *
+ * @vb:		buffer to request data access for
+ */
+int vb2_buffer_access_request(struct vb2_buffer *vb);
+
+
+/**
+ * vb2_buffer_access_release() - release out-of-band data access to a buffer
+ *
+ * @vb:		buffer to release data access for
+ */
+void vb2_buffer_access_release(struct vb2_buffer *vb);
+
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
2.20.1

