Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40198 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753423AbbDIV0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 17:26:04 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com
Subject: [PATCH v4 1/4] v4l: of: Remove the head field in struct v4l2_of_endpoint
Date: Fri, 10 Apr 2015 00:25:03 +0300
Message-Id: <1428614706-8367-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field is unused. Remove it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/v4l2-of.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index f831c9c..f66b92c 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -57,7 +57,6 @@ struct v4l2_of_bus_parallel {
  * @base: struct of_endpoint containing port, id, and local of_node
  * @bus_type: bus type
  * @bus: bus configuration data structure
- * @head: list head for this structure
  */
 struct v4l2_of_endpoint {
 	struct of_endpoint base;
@@ -66,7 +65,6 @@ struct v4l2_of_endpoint {
 		struct v4l2_of_bus_parallel parallel;
 		struct v4l2_of_bus_mipi_csi2 mipi_csi2;
 	} bus;
-	struct list_head head;
 };
 
 /**
-- 
1.7.10.4

