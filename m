Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39772 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752488AbbK2TWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:47 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 22/22] media: Update media graph walk documentation for the changed API
Date: Sun, 29 Nov 2015 21:20:23 +0200
Message-Id: <1448824823-10372-23-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_entity_graph_walk_init() and media_entity_graph_walk_cleanup() are
now mandatory.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media-framework.txt | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index b424de6..738a526 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -241,13 +241,22 @@ supported by the graph traversal API. To prevent infinite loops, the graph
 traversal code limits the maximum depth to MEDIA_ENTITY_ENUM_MAX_DEPTH,
 currently defined as 16.
 
-Drivers initiate a graph traversal by calling
+The graph traversal must be initialised calling
+
+	media_entity_graph_walk_init(struct media_entity_graph *graph);
+
+The return value of the function must be checked. Should the number of
+graph entities exceed the pre-allocated memory, it will also allocate
+memory for the enumeration.
+
+Once initialised, the graph walk may be started by calling
 
 	media_entity_graph_walk_start(struct media_entity_graph *graph,
 				      struct media_entity *entity);
 
-The graph structure, provided by the caller, is initialized to start graph
-traversal at the given entity.
+The graph structure, provided by the caller, is initialized to start
+graph traversal at the given entity. It is possible to start the graph
+walk multiple times using the same graph struct.
 
 Drivers can then retrieve the next entity by calling
 
@@ -255,8 +264,11 @@ Drivers can then retrieve the next entity by calling
 
 When the graph traversal is complete the function will return NULL.
 
-Graph traversal can be interrupted at any moment. No cleanup function call is
-required and the graph structure can be freed normally.
+Graph traversal can be interrupted at any moment. Once the graph
+structure is no longer needed, the resources that have been allocated
+by media_entity_graph_walk_init() are released using
+
+	media_entity_graph_walk_cleanup(struct media_entity_graph *graph);
 
 Helper functions can be used to find a link between two given pads, or a pad
 connected to another pad through an enabled link
-- 
2.1.4

