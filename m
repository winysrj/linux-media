Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47616 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3GCKwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 06:52:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/2] v4l: of: Drop acquired reference to node when getting next endpoint
Date: Wed,  3 Jul 2013 12:52:49 +0200
Message-Id: <1372848769-6390-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1372848769-6390-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The of_get_child_by_name() function takes a reference to the node it
returns. Make sure to drop it when looking for the ports node in
v4l2_of_get_next_endpoint().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index f64d953..ed305d8 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -186,6 +186,7 @@ struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
 		if (!endpoint)
 			pr_err("%s(): no endpoint nodes specified for %s\n",
 			       __func__, parent->full_name);
+		of_node_put(node);
 	} else {
 		port = of_get_parent(prev);
 		if (!port)
-- 
1.8.1.5

