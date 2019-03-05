Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F389C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49B8621019
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfCESvp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:45 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:46799 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbfCESvp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:45 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7AEB4200012;
        Tue,  5 Mar 2019 18:51:42 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v3 10/31] media: entity: Use routing information during graph traversal
Date:   Tue,  5 Mar 2019 19:51:29 +0100
Message-Id: <20190305185150.20776-11-jacopo+renesas@jmondi.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Take internal routing information as reported by the entity has_route
operation into account during graph traversal to avoid following
unrelated links.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/media-entity.c | 44 ++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 8e0ca8b1cfa2..3304e76bbafa 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -257,15 +257,6 @@ bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
 }
 EXPORT_SYMBOL_GPL(media_entity_has_route);
 
-static struct media_pad *
-media_pad_other(struct media_pad *pad, struct media_link *link)
-{
-	if (link->source == pad)
-		return link->sink;
-	else
-		return link->source;
-}
-
 /* push an entity to traversal stack */
 static void stack_push(struct media_graph *graph, struct media_pad *pad)
 {
@@ -336,7 +327,8 @@ static void media_graph_walk_iter(struct media_graph *graph)
 {
 	struct media_pad *pad = stack_top(graph);
 	struct media_link *link;
-	struct media_pad *next;
+	struct media_pad *remote;
+	struct media_pad *local;
 
 	link = list_entry(link_top(graph), typeof(*link), list);
 
@@ -350,23 +342,41 @@ static void media_graph_walk_iter(struct media_graph *graph)
 		return;
 	}
 
-	/* Get the entity in the other end of the link . */
-	next = media_pad_other(pad, link);
+	/*
+	 * Get the local pad, the remote pad and the entity at the other
+	 * end of the link.
+	 */
+	if (link->source->entity == pad->entity) {
+		remote = link->sink;
+		local = link->source;
+	} else {
+		remote = link->source;
+		local = link->sink;
+	}
+
+	/*
+	 * Are the local pad and the pad we came from connected
+	 * internally in the entity ?
+	 */
+	if (!media_entity_has_route(pad->entity, pad->index, local->index)) {
+		link_top(graph) = link_top(graph)->next;
+		return;
+	}
 
 	/* Has the entity already been visited? */
-	if (media_entity_enum_test_and_set(&graph->ent_enum, next->entity)) {
+	if (media_entity_enum_test_and_set(&graph->ent_enum, remote->entity)) {
 		link_top(graph) = link_top(graph)->next;
 		dev_dbg(pad->graph_obj.mdev->dev,
 			"walk: skipping entity '%s' (already seen)\n",
-			next->entity->name);
+			remote->entity->name);
 		return;
 	}
 
 	/* Push the new entity to stack and start over. */
 	link_top(graph) = link_top(graph)->next;
-	stack_push(graph, next);
-	dev_dbg(next->graph_obj.mdev->dev, "walk: pushing '%s':%u on stack\n",
-		next->entity->name, next->index);
+	stack_push(graph, remote);
+	dev_dbg(remote->graph_obj.mdev->dev, "walk: pushing '%s':%u on stack\n",
+		remote->entity->name, remote->index);
 }
 
 struct media_pad *media_graph_walk_next(struct media_graph *graph)
-- 
2.20.1

