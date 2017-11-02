Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52592 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752237AbdKBJ7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 05:59:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: devicetree@vger.kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        robh@kernel.org, hyun.kwon@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RESEND PATCH 1/1] of: Make return types of to_of_node and of_fwnode_handle macros consistent
Date: Thu,  2 Nov 2017 11:59:18 +0200
Message-Id: <20171102095918.7041-1-sakari.ailus@linux.intel.com>
In-Reply-To: <2117711.dO2rQLXOup@avalon>
References: <2117711.dO2rQLXOup@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Fixed Mauro's e-mail.)

to_of_node() macro checks whether the fwnode_handle passed to it is not an
OF node, and if so, returns NULL in order to be NULL-safe. Otherwise it
returns the pointer to the OF node which the fwnode_handle contains.

The problem with returning NULL is that its type was void *, which
sometimes matters. Explicitly return struct device_node * instead.

Make a similar change to of_fwnode_handle() as well.

Fixes: d20dc1493db4 ("of: Support const and non-const use for to_of_node()")
Fixes: debd3a3b27c7 ("of: Make of_fwnode_handle() safer")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Mauro,

Could you check whether this addresses the smatch issue with the xilinx
driver?

Thanks.

 include/linux/of.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index b240ed69dc96..0651231c115e 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -161,7 +161,7 @@ static inline bool is_of_node(const struct fwnode_handle *fwnode)
 		is_of_node(__to_of_node_fwnode) ?			\
 			container_of(__to_of_node_fwnode,		\
 				     struct device_node, fwnode) :	\
-			NULL;						\
+			(struct device_node *)NULL;			\
 	})
 
 #define of_fwnode_handle(node)						\
@@ -169,7 +169,8 @@ static inline bool is_of_node(const struct fwnode_handle *fwnode)
 		typeof(node) __of_fwnode_handle_node = (node);		\
 									\
 		__of_fwnode_handle_node ?				\
-			&__of_fwnode_handle_node->fwnode : NULL;	\
+			&__of_fwnode_handle_node->fwnode :		\
+			(struct fwnode_handle *)NULL;			\
 	})
 
 static inline bool of_have_populated_dt(void)
-- 
2.11.0
