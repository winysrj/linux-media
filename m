Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51578 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751859AbbCVVw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 17:52:28 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	snawrocki@samsung.com
Subject: [PATCH v2 1/4] v4l: of: Remove the head field in struct v4l2_of_endpoint
Date: Sun, 22 Mar 2015 23:51:36 +0200
Message-Id: <1427061099-17438-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1427061099-17438-1-git-send-email-sakari.ailus@iki.fi>
References: <1427061099-17438-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field is unused. Remove it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/v4l2-of.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 70fa7b7..dc468de 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -54,7 +54,6 @@ struct v4l2_of_bus_parallel {
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
  * @bus: bus configuration data structure
- * @head: list head for this structure
  */
 struct v4l2_of_endpoint {
 	struct of_endpoint base;
@@ -63,7 +62,6 @@ struct v4l2_of_endpoint {
 		struct v4l2_of_bus_parallel parallel;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
-	struct list_head head;
 };
 
 #ifdef CONFIG_OF
-- 
1.7.10.4

