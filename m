Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17097 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LJTmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 14:42:04 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
	thomas.abraham@linaro.org, t.figa@samsung.com,
	sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 02/13] of: add a dummy inline function for when CONFIG_OF
 is not defined
Date: Mon, 10 Dec 2012 20:41:28 +0100
Message-id: <1355168499-5847-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

If CONFIG_OF isn't defined, no declaration of of_get_parent will be found
and compilation can fail. This patch adds a dummy inline function
definition to fix the problem.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/of.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index b4e50d5..9ba8cf1 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -427,6 +427,11 @@ static inline int of_parse_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline struct device_node *of_get_parent(const struct device_node *np)
+{
+	return NULL;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
-- 
1.7.9.5

