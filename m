Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39767 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752403AbbK2TWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:43 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 05/22] media: Add KernelDoc documentation for struct media_entity_graph
Date: Sun, 29 Nov 2015 21:20:06 +0200
Message-Id: <1448824823-10372-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 2601bb0..8fd888f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -95,6 +95,14 @@ struct media_entity_enum {
 	int idx_max;
 };
 
+/*
+ * struct media_entity_graph - Media graph traversal state
+ *
+ * @stack.entity:	Media entity in the stack
+ * @stack.link:		Link through which the entity was reached
+ * @entities:		Visited entities
+ * @top:		The top of the stack
+ */
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-- 
2.1.4

