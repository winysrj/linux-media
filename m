Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60596 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754452AbbLPNet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:49 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 05/23] media: Add KernelDoc documentation for struct media_entity_graph
Date: Wed, 16 Dec 2015 15:32:20 +0200
Message-Id: <1450272758-29446-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

KernelDoc doesn't appear to handle anonymous structs defined inside
another gracefully. As the struct is internal to the framework graph walk
algorithm, detailed documentation isn't seen very important.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 4f789a4..3068c30 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -97,6 +97,15 @@ struct media_entity_enum {
 	int idx_max;
 };
 
+/**
+ * struct media_entity_graph - Media graph traversal state
+ *
+ * @stack:		Graph traversal stack; the stack contains information
+ *			on the path the media entities to be walked and the
+ *			links through which they were reached.
+ * @entities:		Visited entities
+ * @top:		The top of the stack
+ */
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-- 
2.1.4

