Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37570 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbbLKRRZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:25 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 10/10] [media] media-entity: remove unneded enclosing parenthesis
Date: Fri, 11 Dec 2015 14:16:36 -0300
Message-Id: <1449854196-13296-11-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 86ee417578a2 ("[media] media: convert links from array to list")
had many changes that were automated using coccinelle but the semantic
patch was not smart enough to rely on operators precedence and avoid
using unnecessary enclosing parenthesis.

This patch removes them since are not needed.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses an issue Laurent pointed in patch [0]:

- No need for parentheses

[0]: [media-workshop] [PATCH v8.4 24/83] [media] media: convert links
from array to list

(unfortunately I didn't find a public archive for the media-workshop ML).

 drivers/media/media-entity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ada2b44ea4e1..181ca0de6e52 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -225,7 +225,7 @@ static void stack_push(struct media_entity_graph *graph,
 		return;
 	}
 	graph->top++;
-	graph->stack[graph->top].link = (&entity->links)->next;
+	graph->stack[graph->top].link = entity->links.next;
 	graph->stack[graph->top].entity = entity;
 }
 
@@ -268,7 +268,7 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 	 * top of the stack until no more entities on the level can be
 	 * found.
 	 */
-	while (link_top(graph) != &(stack_top(graph)->links)) {
+	while (link_top(graph) != &stack_top(graph)->links) {
 		struct media_entity *entity = stack_top(graph);
 		struct media_link *link;
 		struct media_entity *next;
-- 
2.4.3

