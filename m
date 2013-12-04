Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50022 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933126Ab3LDT3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:29:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] v4l: of: Remove struct v4l2_of_endpoint remote field
Date: Wed,  4 Dec 2013 20:29:07 +0100
Message-Id: <1386185348-2655-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field isn't set when parsing the endpoint. Remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-of.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 3480cd0..541cea4 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -53,7 +53,6 @@ struct v4l2_of_bus_parallel {
  * @port: identifier (value of reg property) of a port this endpoint belongs to
  * @id: identifier (value of reg property) of this endpoint
  * @local_node: pointer to device_node of this endpoint
- * @remote: phandle to remote endpoint node
  * @bus_type: bus type
  * @bus: bus configuration data structure
  * @head: list head for this structure
@@ -62,7 +61,6 @@ struct v4l2_of_endpoint {
 	unsigned int port;
 	unsigned int id;
 	const struct device_node *local_node;
-	const __be32 *remote;
 	enum v4l2_mbus_type bus_type;
 	union {
 		struct v4l2_of_bus_parallel parallel;
-- 
1.8.3.2

