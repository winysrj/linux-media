Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221AbbLPRLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:11:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/5] [media] DocBook: document media_entity_graph_walk_cleanup()
Date: Wed, 16 Dec 2015 15:11:12 -0200
Message-Id: <737a622a2544f271310ba05b5c30e50c0f5966f9.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function was added recently, but weren't documented.
Add documentation for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-entity.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index c4aaeb85229c..f90ff56888d4 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -705,6 +705,12 @@ struct media_entity *media_entity_get(struct media_entity *entity);
 
 __must_check int media_entity_graph_walk_init(
 	struct media_entity_graph *graph, struct media_device *mdev);
+
+/**
+ * media_entity_graph_walk_cleanup - Release resources used by graph walk.
+ *
+ * @graph: Media graph structure that will be used to walk the graph
+ */
 void media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
 
 /**
-- 
2.5.0

