Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38506 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGO51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:57:27 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] of: Fix of_graph_parse_endpoint stub for !CONFIG_OF builds
Date: Fri,  7 Mar 2014 15:57:15 +0100
Message-Id: <1394204235-28706-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the following build error:

   In file included from drivers/media/i2c/adv7343.c:29:0:
>> include/linux/of_graph.h:41:1: error: expected identifier or '(' before '{' token
    {
    ^
   include/linux/of_graph.h:39:19: warning: 'of_graph_parse_endpoint' declared 'static' but never defined [-Wunused-function]
    static inline int of_graph_parse_endpoint(const struct device_node *node,
                      ^

vim +41 include/linux/of_graph.h

    35                                          const struct device_node *node);
    36  struct device_node *of_graph_get_remote_port(const struct device_node *node);
    37  #else
    38
    39  static inline int of_graph_parse_endpoint(const struct device_node *node,
    40                                          struct of_endpoint *endpoint);
  > 41  {
    42          return -ENOSYS;
    43  }
    44

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/linux/of_graph.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 17f28eb..46795b3 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -45,7 +45,7 @@ struct device_node *of_graph_get_remote_port(const struct device_node *node);
 #else
 
 static inline int of_graph_parse_endpoint(const struct device_node *node,
-					struct of_endpoint *endpoint);
+					struct of_endpoint *endpoint)
 {
 	return -ENOSYS;
 }
-- 
1.9.0

