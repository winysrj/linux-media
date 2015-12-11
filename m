Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbLKNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/10] media-entity.c: remove two extra blank lines
Date: Fri, 11 Dec 2015 11:34:13 -0200
Message-Id: <1cc8c76c79e573c72b4afa55a5e349757312d42b.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 849db4f6f1f3..5a5432524c10 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -310,7 +310,6 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
 
-
 /**
  * media_entity_graph_walk_next - Get the next entity in the graph
  * @graph: Media graph structure
@@ -850,7 +849,6 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 }
 EXPORT_SYMBOL_GPL(media_entity_remote_pad);
 
-
 static void media_interface_init(struct media_device *mdev,
 				 struct media_interface *intf,
 				 u32 gobj_type,
@@ -915,7 +913,6 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
 }
 EXPORT_SYMBOL_GPL(media_create_intf_link);
 
-
 void __media_remove_intf_link(struct media_link *link)
 {
 	list_del(&link->list);
-- 
2.5.0


