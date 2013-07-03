Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47612 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3GCKwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 06:52:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/2] v4l: of: Use of_get_child_by_name()
Date: Wed,  3 Jul 2013 12:52:48 +0200
Message-Id: <1372848769-6390-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace a manual loop through child nodes with a call to
of_get_child_by_name().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-of.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index aa59639..f64d953 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -173,12 +173,8 @@ struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
 		if (node)
 			parent = node;
 
-		for_each_child_of_node(parent, node) {
-			if (!of_node_cmp(node->name, "port")) {
-				port = node;
-				break;
-			}
-		}
+		port = of_get_child_by_name(parent, "port");
+
 		if (port) {
 			/* Found a port, get an endpoint. */
 			endpoint = of_get_next_child(port, NULL);
-- 
1.8.1.5

