Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC967C00319
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A913E21019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfCESvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:48 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:46799 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfCESvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:47 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 587EC200007;
        Tue,  5 Mar 2019 18:51:45 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 12/31] media: entity: Add an iterator helper for connected pads
Date:   Tue,  5 Mar 2019 19:51:31 +0100
Message-Id: <20190305185150.20776-13-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Add a helper macro for iterating over pads that are connected through
enabled routes. This can be used to find all the connected pads within an
entity, for instance starting from the pad which has been obtained during
the graph walk.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

- Make __media_entity_next_routed_pad() return NULL and adjust the
  iterator to handle that
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 include/media/media-entity.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 205561545d7e..82f0bdf2a6d1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
 bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
 			    unsigned int pad1);
 
+static inline struct media_pad *__media_entity_next_routed_pad(
+	struct media_pad *start, struct media_pad *iter)
+{
+	struct media_entity *entity = start->entity;
+
+	while (iter < &entity->pads[entity->num_pads] &&
+	       !media_entity_has_route(entity, start->index, iter->index))
+		iter++;
+
+	return iter == &entity->pads[entity->num_pads] ? NULL : iter;
+}
+
+/**
+ * media_entity_for_each_routed_pad - Iterate over entity pads connected by routes
+ *
+ * @start: The stating pad
+ * @iter: The iterator pad
+ *
+ * Iterate over all pads connected through routes from a given pad
+ * within an entity. The iteration will include the starting pad itself.
+ */
+#define media_entity_for_each_routed_pad(start, iter)			\
+	for (iter = __media_entity_next_routed_pad(			\
+		     start, (start)->entity->pads);			\
+	     iter != NULL;						\
+	     iter = __media_entity_next_routed_pad(start, iter + 1))
+
 /**
  * media_graph_walk_cleanup - Release resources used by graph walk.
  *
-- 
2.20.1

