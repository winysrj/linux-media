Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76778C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 332FA2054F
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 19:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544124930;
	bh=8Ad4K5e3QDbSPDzXcYq7hTcseeCUZHC35OlrPGK01wQ=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=YsSGeI72kK2DJsE5mVKb3IrcxHu+Z8+2J7PXtBhXhAsnuKR7Lh3bfV8QV7drwzaaq
	 Rh+CE1RpOG9IgStAaSTPQ5A0k1pPWlMkg0SXV0A+bL/zYk3sLFvzPrPHBVwqPYELLD
	 xi88zioS72nTHrZm1ROP8yD7ENKvXlbklYOhhpXU=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 332FA2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbeLFTfY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 14:35:24 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45895 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbeLFTfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2018 14:35:23 -0500
Received: by mail-ot1-f65.google.com with SMTP id 32so1501912ota.12;
        Thu, 06 Dec 2018 11:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oXsFqVkQvC9jOdOHTS5EB/PSIvwqVFJymMgC+jRnc5E=;
        b=Oc7lbnLnQjgenLapXplLbMaCvEr/kqxGBWFmTbNWVgqiGbd8lP4aWTH0u+xknbos7/
         Yj/dKS9w1RdVMC8A/IaPQbceOLPrVO7BBwEXAPeiQVvxe8GLZn4YxSlomH++vgGVO6ry
         T7FoU4lIoDHeA5JTus5YN2Sa6dEBY1cghiqLuM65Epp3Ze2JjAaORM0wvDKveVEIxKmU
         yl6eiYjaFRJOP0BI+UBD7LEt6QpBCjaDX5WwsTa92WzqLKpovYBmChk3PfkaYBfjaq8y
         tCIvDBhdbgMqidZPoCU6p36F3MF6s3icnqMqvvf0TI/z3RH7JXXHrwCH7sCA7XlJ00Rr
         +1qQ==
X-Gm-Message-State: AA+aEWaicTmTWLQSASu8kvvfrL4UUdQKQKpzSXjumcSUQe8E8x/qhYWD
        smKrlzJBp0aTgT40QzMON5g09b8=
X-Google-Smtp-Source: AFSGD/W8XFH2Psgs0x83Hrsvy1LIY2/jRtw6qCC/mA0S8JBZN7c2SpwLaeyi50GDB1avIdxRhe5qZQ==
X-Received: by 2002:a9d:a78:: with SMTP id 111mr18561582otg.229.1544124921409;
        Thu, 06 Dec 2018 11:35:21 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id i5sm479863oia.46.2018.12.06.11.35.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Dec 2018 11:35:20 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [PATCH v2] media: Use of_node_name_eq for node name comparisons
Date:   Thu,  6 Dec 2018 13:35:19 -0600
Message-Id: <20181206193519.13367-1-robh@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Convert string compares of DT node names to use of_node_name_eq helper
instead. This removes direct access to the node name pointer.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
- Also convert tabs to spaces between the 'if' and '('

 drivers/media/platform/exynos4-is/media-dev.c | 12 ++++++------
 drivers/media/platform/ti-vpe/cal.c           |  4 ++--
 drivers/media/platform/xilinx/xilinx-tpg.c    |  2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c         |  6 ++----
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 870501b0f351..463f2d84553e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -445,7 +445,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	 */
 	np = of_get_parent(rem);
 
-	if (np && !of_node_cmp(np->name, "i2c-isp"))
+	if (of_node_name_eq(np, "i2c-isp"))
 		pd->fimc_bus_type = FIMC_BUS_TYPE_ISP_WRITEBACK;
 	else
 		pd->fimc_bus_type = pd->sensor_bus_type;
@@ -495,7 +495,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 	for_each_available_child_of_node(parent, node) {
 		struct device_node *port;
 
-		if (of_node_cmp(node->name, "csis"))
+		if (!of_node_name_eq(node, "csis"))
 			continue;
 		/* The csis node can have only port subnode. */
 		port = of_get_next_child(node, NULL);
@@ -720,13 +720,13 @@ static int fimc_md_register_platform_entities(struct fimc_md *fmd,
 			continue;
 
 		/* If driver of any entity isn't ready try all again later. */
-		if (!strcmp(node->name, CSIS_OF_NODE_NAME))
+		if (of_node_name_eq(node, CSIS_OF_NODE_NAME))
 			plat_entity = IDX_CSIS;
-		else if	(!strcmp(node->name, FIMC_IS_OF_NODE_NAME))
+		else if (of_node_name_eq(node, FIMC_IS_OF_NODE_NAME))
 			plat_entity = IDX_IS_ISP;
-		else if (!strcmp(node->name, FIMC_LITE_OF_NODE_NAME))
+		else if (of_node_name_eq(node, FIMC_LITE_OF_NODE_NAME))
 			plat_entity = IDX_FLITE;
-		else if	(!strcmp(node->name, FIMC_OF_NODE_NAME) &&
+		else if (of_node_name_eq(node, FIMC_OF_NODE_NAME) &&
 			 !of_property_read_bool(node, "samsung,lcd-wb"))
 			plat_entity = IDX_FIMC;
 
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 95a093f41905..fc3c212b96e1 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1615,7 +1615,7 @@ of_get_next_port(const struct device_node *parent,
 				return NULL;
 			}
 			prev = port;
-		} while (of_node_cmp(port->name, "port") != 0);
+		} while (!of_node_name_eq(port, "port"));
 	}
 
 	return port;
@@ -1635,7 +1635,7 @@ of_get_next_endpoint(const struct device_node *parent,
 		if (!ep)
 			return NULL;
 		prev = ep;
-	} while (of_node_cmp(ep->name, "endpoint") != 0);
+	} while (!of_node_name_eq(ep, "endpoint"));
 
 	return ep;
 }
diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c b/drivers/media/platform/xilinx/xilinx-tpg.c
index 851d20dcd550..ce686b8d6cff 100644
--- a/drivers/media/platform/xilinx/xilinx-tpg.c
+++ b/drivers/media/platform/xilinx/xilinx-tpg.c
@@ -725,7 +725,7 @@ static int xtpg_parse_of(struct xtpg_device *xtpg)
 		const struct xvip_video_format *format;
 		struct device_node *endpoint;
 
-		if (!port->name || of_node_cmp(port->name, "port"))
+		if (!of_node_name_eq(port, "port"))
 			continue;
 
 		format = xvip_of_get_format(port);
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 218f0da0ce76..849326241b17 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -564,8 +564,7 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
 	fwnode = fwnode_get_parent(__fwnode);
 	fwnode_property_read_u32(fwnode, port_prop, &link->local_port);
 	fwnode = fwnode_get_next_parent(fwnode);
-	if (is_of_node(fwnode) &&
-	    of_node_cmp(to_of_node(fwnode)->name, "ports") == 0)
+	if (is_of_node(fwnode) && of_node_name_eq(to_of_node(fwnode), "ports"))
 		fwnode = fwnode_get_next_parent(fwnode);
 	link->local_node = fwnode;
 
@@ -578,8 +577,7 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
 	fwnode = fwnode_get_parent(fwnode);
 	fwnode_property_read_u32(fwnode, port_prop, &link->remote_port);
 	fwnode = fwnode_get_next_parent(fwnode);
-	if (is_of_node(fwnode) &&
-	    of_node_cmp(to_of_node(fwnode)->name, "ports") == 0)
+	if (is_of_node(fwnode) && of_node_name_eq(to_of_node(fwnode), "ports"))
 		fwnode = fwnode_get_next_parent(fwnode);
 	link->remote_node = fwnode;
 
-- 
2.19.1

