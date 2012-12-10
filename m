Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:20597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2LJTms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:48 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
	thomas.abraham@linaro.org, t.figa@samsung.com,
	sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 13/13] v4l2-of: Replace "remote" property with
 "remote-endpoint"
Date: Mon, 10 Dec 2012 20:41:39 +0100
Message-id: <1355168499-5847-14-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As agreed (I hope I'm not wrong) on the LMML use "remote-endpoint"
property instead of "remote". Also add kerneldoc description for
the function.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-of.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 032ee67..10a06e4 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -186,13 +186,19 @@ struct device_node *v4l2_of_get_next_link(const struct device_node *parent,
 }
 EXPORT_SYMBOL(v4l2_of_get_next_link);
 
-/* Return a refcounted DT node, owning the link, referenced by "remote" */
+/**
+ * v4l2_of_get_remote() - get device node corresponding to remote enpoint
+ * @node: local endpoint node
+ *
+ * Return: Remote device node associated with remote endpoint node linked
+ *	   to @node. Use of_node_put() on it when done.
+ */
 struct device_node *v4l2_of_get_remote(const struct device_node *node)
 {
 	struct device_node *remote, *tmp;
 
-	/* Get remote link DT node */
-	remote = of_parse_phandle(node, "remote", 0);
+	/* Get remote endpoint DT node */
+	remote = of_parse_phandle(node, "remote-endpoint", 0);
 	if (!remote)
 		return NULL;
 
-- 
1.7.9.5

