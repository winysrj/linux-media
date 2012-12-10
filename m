Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17172 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2LJTmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:44 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
	thomas.abraham@linaro.org, t.figa@samsung.com,
	sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 12/13] v4l2-of: Corrected v4l2_of_parse_link() function
 declaration
Date: Mon, 10 Dec 2012 20:41:38 +0100
Message-id: <1355168499-5847-13-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_of_parse_link() return value type is int, not void.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-of.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 9b036e6..686d04b 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -49,10 +49,13 @@ int v4l2_of_parse_data_lanes(const struct device_node *node,
 struct device_node *v4l2_of_get_next_link(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *v4l2_of_get_remote(const struct device_node *node);
-#else
-static inline void v4l2_of_parse_link(const struct device_node *node,
+
+#else /* CONFIG_OF */
+
+static inline int v4l2_of_parse_link(const struct device_node *node,
 				      struct v4l2_of_link *link)
 {
+	return -ENOSYS;
 }
 
 static inline int v4l2_of_parse_data_lanes(const struct device_node *node,
-- 
1.7.9.5

