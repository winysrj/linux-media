Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52327 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935606AbeFMOHS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:18 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 2/9] media: cedrus: Add wrappers around container_of for our buffers
Date: Wed, 13 Jun 2018 16:07:07 +0200
Message-Id: <20180613140714.1686-3-maxime.ripard@bootlin.com>
In-Reply-To: <20180613140714.1686-1-maxime.ripard@bootlin.com>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cedrus driver sub-classes the vb2_v4l2_buffer structure, but doesn't
provide any function to wrap around the proper container_of call that needs
to be duplicated in every calling site.

Add wrappers to make sure its opaque to the users and they don't have to
care anymore.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 .../platform/sunxi/cedrus/sunxi_cedrus_common.h      | 12 ++++++++++++
 .../media/platform/sunxi/cedrus/sunxi_cedrus_hw.c    |  4 ++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
index ee6883ef9cb7..b1ed1c8cb130 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
@@ -89,6 +89,18 @@ struct sunxi_cedrus_buffer {
 	struct list_head list;
 };
 
+static inline
+struct sunxi_cedrus_buffer *vb2_v4l2_to_cedrus_buffer(const struct vb2_v4l2_buffer *p)
+{
+	return container_of(p, struct sunxi_cedrus_buffer, vb);
+}
+
+static inline
+struct sunxi_cedrus_buffer *vb2_to_cedrus_buffer(const struct vb2_buffer *p)
+{
+	return vb2_v4l2_to_cedrus_buffer(to_vb2_v4l2_buffer(p));
+}
+
 struct sunxi_cedrus_dev {
 	struct v4l2_device v4l2_dev;
 	struct video_device vfd;
diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
index 5783bd985855..fc688a5c1ea3 100644
--- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
+++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_hw.c
@@ -108,8 +108,8 @@ static irqreturn_t sunxi_cedrus_ve_irq(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	src_buffer = container_of(src_vb, struct sunxi_cedrus_buffer, vb);
-	dst_buffer = container_of(dst_vb, struct sunxi_cedrus_buffer, vb);
+	src_buffer = vb2_v4l2_to_cedrus_buffer(src_vb);
+	dst_buffer = vb2_v4l2_to_cedrus_buffer(dst_vb);
 
 	/* First bit of MPEG_STATUS indicates success. */
 	if (ctx->job_abort || !(status & 0x01))
-- 
2.17.0
