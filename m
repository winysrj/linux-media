Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50023 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3LDT3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 14:29:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] v4l: of: Drop endpoint node reference in v4l2_of_get_remote_port()
Date: Wed,  4 Dec 2013 20:29:08 +0100
Message-Id: <1386185348-2655-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386185348-2655-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_get_remote_port() function acquires a reference to an
endpoint node through a phandle and then returns the node's parent,
without dropping the reference to the endpoint node. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index 66a0e23..42e3e8a 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -266,6 +266,6 @@ struct device_node *v4l2_of_get_remote_port(const struct device_node *node)
 	np = of_parse_phandle(node, "remote-endpoint", 0);
 	if (!np)
 		return NULL;
-	return of_get_parent(np);
+	return of_get_next_parent(np);
 }
 EXPORT_SYMBOL(v4l2_of_get_remote_port);
-- 
1.8.3.2

