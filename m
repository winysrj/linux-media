Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:57607 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034085AbdD0WnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 18:43:05 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 2/2] media: entity: Add media_entity_pad_from_dt_regs() function
Date: Fri, 28 Apr 2017 00:33:23 +0200
Message-Id: <20170427223323.13861-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170427223323.13861-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a wrapper around the media entity pad_from_dt_regs operation.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/media-entity.c | 21 +++++++++++++++++++++
 include/media/media-entity.h | 22 ++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5640ca29da8c9bbc..6ef76186d552724e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -386,6 +386,27 @@ struct media_entity *media_graph_walk_next(struct media_graph *graph)
 }
 EXPORT_SYMBOL_GPL(media_graph_walk_next);
 
+int media_entity_pad_from_dt_regs(struct media_entity *entity,
+				  int port_reg, int reg, unsigned int *pad)
+{
+	int ret;
+
+	if (!entity->ops || !entity->ops->pad_from_dt_regs) {
+		*pad = port_reg;
+		return 0;
+	}
+
+	ret = entity->ops->pad_from_dt_regs(port_reg, reg, pad);
+	if (ret)
+		return ret;
+
+	if (*pad >= entity->num_pads)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_entity_pad_from_dt_regs);
+
 /* -----------------------------------------------------------------------------
  * Pipeline management
  */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 47efaf4d825e671b..c60a3713d0a21baf 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -820,6 +820,28 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad);
 struct media_entity *media_entity_get(struct media_entity *entity);
 
 /**
+ * media_entity_pad_from_dt_regs - Get pad number from DT regs
+ *
+ * @entity: The entity
+ * @port_reg: DT port
+ * @reg: DT reg
+ * @pad: Pointer to pad which will be filled in
+ *
+ * This function can be used to resolve the media pad number from
+ * DT port and reg numbers. This is useful for devices which
+ * uses more complex mappings of media pads then that the
+ * DT port number is equivalent to the media pad number.
+ *
+ * If the entity do not implement the pad_from_dt_regs() operation
+ * this function assumes DT port is equivalent to media pad number
+ * and sets @pad to @port_reg.
+ *
+ * Return: 0 on success else -EINVAL.
+ */
+int media_entity_pad_from_dt_regs(struct media_entity *entity,
+				  int port_reg, int reg, unsigned int *pad);
+
+/**
  * media_graph_walk_init - Allocate resources used by graph walk.
  *
  * @graph: Media graph structure that will be used to walk the graph
-- 
2.12.2
