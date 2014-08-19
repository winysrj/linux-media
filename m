Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51135 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaHSNC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 09:02:58 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/8] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Tue, 19 Aug 2014 15:02:41 +0200
Message-Id: <1408453366-1366-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
References: <1408453366-1366-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Decrementing the reference count of the previous endpoint node allows to
use the of_graph_get_next_endpoint function in a for_each_... style macro.
Prior to this patch, all current users of this function that actually pass
a non-NULL prev parameter should be changed to not decrement the passed
prev argument's refcount themselves.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d8574ad..a49b5628 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2058,8 +2058,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
  * @prev: previous endpoint node, or NULL to get first
  *
  * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
+ * of the passed @prev node is decremented.
  */
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *prev)
@@ -2095,12 +2094,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
 			      __func__, prev->full_name))
 			return NULL;
-
-		/*
-		 * Avoid dropping prev node refcount to 0 when getting the next
-		 * child below.
-		 */
-		of_node_get(prev);
 	}
 
 	while (1) {
-- 
2.1.0.rc1

