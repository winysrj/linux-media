Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754660AbdGNQO0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:14:26 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 5/6] v4l: vsp1: Convert LUT to use a fragment pool
Date: Fri, 14 Jul 2017 17:14:14 +0100
Message-Id: <dee8db9c5ade2b4c47ec0d31f80352c5b1d8633f.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adapt the LUT to allocate a fragment pool for passing the table updates
to hardware.

Two bodies are pre-allocated in the pool to manage a userspace update
before the hardware has taken a previous set of tables.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lut.c | 23 +++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_lut.h |  1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index c67cc60db0db..57482e057e54 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -23,6 +23,8 @@
 #define LUT_MIN_SIZE				4U
 #define LUT_MAX_SIZE				8190U
 
+#define LUT_SIZE				256
+
 /* -----------------------------------------------------------------------------
  * Device Access
  */
@@ -44,11 +46,11 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(lut->entity.vsp1, 256);
+	dlb = vsp1_dl_fragment_get(lut->pool);
 	if (!dlb)
 		return -ENOMEM;
 
-	for (i = 0; i < 256; ++i)
+	for (i = 0; i < LUT_SIZE; ++i)
 		vsp1_dl_fragment_write(dlb, VI6_LUT_TABLE + 4 * i,
 				       ctrl->p_new.p_u32[i]);
 
@@ -56,7 +58,7 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 	swap(lut->lut, dlb);
 	spin_unlock_irq(&lut->lock);
 
-	vsp1_dl_fragment_free(dlb);
+	vsp1_dl_fragment_put(dlb);
 	return 0;
 }
 
@@ -87,7 +89,7 @@ static const struct v4l2_ctrl_config lut_table_control = {
 	.max = 0x00ffffff,
 	.step = 1,
 	.def = 0,
-	.dims = { 256},
+	.dims = { LUT_SIZE },
 };
 
 /* -----------------------------------------------------------------------------
@@ -217,8 +219,16 @@ static void lut_configure(struct vsp1_entity *entity,
 	}
 }
 
+static void lut_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_lut *lut = to_lut(&entity->subdev);
+
+	vsp1_dl_fragment_pool_free(lut->pool);
+}
+
 static const struct vsp1_entity_operations lut_entity_ops = {
 	.configure = lut_configure,
+	.destroy = lut_destroy,
 };
 
 /* -----------------------------------------------------------------------------
@@ -244,6 +254,11 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/* Allocate a fragment pool */
+	lut->pool = vsp1_dl_fragment_pool_alloc(vsp1, 2, LUT_SIZE, 0);
+	if (!lut->pool)
+		return ERR_PTR(-ENOMEM);
+
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&lut->ctrls, 1);
 	v4l2_ctrl_new_custom(&lut->ctrls, &lut_table_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
index f8c4e8f0a79d..538563d57454 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.h
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -33,6 +33,7 @@ struct vsp1_lut {
 
 	spinlock_t lock;
 	struct vsp1_dl_body *lut;
+	struct vsp1_dl_fragment_pool *pool;
 };
 
 static inline struct vsp1_lut *to_lut(struct v4l2_subdev *subdev)
-- 
git-series 0.9.1
