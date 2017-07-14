Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753446AbdGNQOa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:14:30 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 4/6] v4l: vsp1: Convert CLU to use a fragment pool
Date: Fri, 14 Jul 2017 17:14:13 +0100
Message-Id: <efd134fda974a976acf47c220984243eaf4b1317.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6756808fb978882ae2db0cde7745c7e12b177713.1500047489.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adapt the CLU to allocate a fragment pool for passing the table updates
to hardware.

Two bodies are pre-allocated in the pool to manage a userspace update
before the hardware has taken a previous set of tables.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_clu.c | 18 ++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_clu.h |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index f2fb26e5ab4e..6079c6465435 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -47,7 +47,7 @@ static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
 	struct vsp1_dl_body *dlb;
 	unsigned int i;
 
-	dlb = vsp1_dl_fragment_alloc(clu->entity.vsp1, 1 + 17 * 17 * 17);
+	dlb = vsp1_dl_fragment_get(clu->pool);
 	if (!dlb)
 		return -ENOMEM;
 
@@ -59,7 +59,7 @@ static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
 	swap(clu->clu, dlb);
 	spin_unlock_irq(&clu->lock);
 
-	vsp1_dl_fragment_free(dlb);
+	vsp1_dl_fragment_put(dlb);
 	return 0;
 }
 
@@ -261,8 +261,16 @@ static void clu_configure(struct vsp1_entity *entity,
 	}
 }
 
+static void clu_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_clu *clu = to_clu(&entity->subdev);
+
+	vsp1_dl_fragment_pool_free(clu->pool);
+}
+
 static const struct vsp1_entity_operations clu_entity_ops = {
 	.configure = clu_configure,
+	.destroy = clu_destroy,
 };
 
 /* -----------------------------------------------------------------------------
@@ -288,6 +296,12 @@ struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1)
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	/* Allocate a fragment pool */
+	clu->pool = vsp1_dl_fragment_pool_alloc(clu->entity.vsp1, 2,
+			1 + 17 * 17 * 17, 0);
+	if (!clu->pool)
+		return ERR_PTR(-ENOMEM);
+
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&clu->ctrls, 2);
 	v4l2_ctrl_new_custom(&clu->ctrls, &clu_table_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
index 036e0a2f1a42..601ffb558e30 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.h
+++ b/drivers/media/platform/vsp1/vsp1_clu.h
@@ -36,6 +36,7 @@ struct vsp1_clu {
 	spinlock_t lock;
 	unsigned int mode;
 	struct vsp1_dl_body *clu;
+	struct vsp1_dl_fragment_pool *pool;
 };
 
 static inline struct vsp1_clu *to_clu(struct v4l2_subdev *subdev)
-- 
git-series 0.9.1
