Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00234C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 15:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD97F20896
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 15:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfANPOX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:14:23 -0500
Received: from foss.arm.com ([217.140.101.70]:35430 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbfANPOX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 10:14:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9599E80D;
        Mon, 14 Jan 2019 07:14:22 -0800 (PST)
Received: from e110467-lin.cambridge.arm.com (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3F0013F70D;
        Mon, 14 Jan 2019 07:14:21 -0800 (PST)
From:   Robin Murphy <robin.murphy@arm.com>
To:     robh+dt@kernel.org, frowand.list@gmail.com
Cc:     devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH RESEND] media: s5p-mfc: Fix memdev DMA configuration
Date:   Mon, 14 Jan 2019 15:14:14 +0000
Message-Id: <4235afdd39766f11a3bf4c8daa0d1f4e6a1cd6dc.1547476835.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.20.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Having of_reserved_mem_device_init() forcibly reconfigure DMA for all
callers, potentially overriding the work done by a bus-specific
.dma_configure method earlier, is at best a bad idea and at worst
actively harmful. If drivers really need virtual devices to own
dma-coherent memory, they should explicitly configure those devices
based on the appropriate firmware node as they create them.

It looks like the only driver not passing in a proper OF platform device
is s5p-mfc, so move the rogue of_dma_configure() call into that driver
where it logically belongs.

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---

Hi Rob, Frank,

Bit of an old one bit it's rebased cleanly - Mauro reckoned[1] this
would suit the OF tree better than media, are you happy to pick it up?

Thanks,
Robin.

[1] https://patchwork.kernel.org/patch/10598085/


 drivers/media/platform/s5p-mfc/s5p_mfc.c | 7 +++++++
 drivers/of/of_reserved_mem.c             | 4 ----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8a5ba3bec3af..6db33704b1a8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1094,6 +1094,13 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 	child->dma_mask = dev->dma_mask;
 	child->release = s5p_mfc_memdev_release;
 
+	/*
+	 * The memdevs are not proper OF platform devices, so in order for them
+	 * to be treated as valid DMA masters we need a bit of a hack to force
+	 * them to inherit the MFC node's DMA configuration.
+	 */
+	of_dma_configure(child, dev->of_node, true);
+
 	if (device_add(child) == 0) {
 		ret = of_reserved_mem_device_init_by_idx(child, dev->of_node,
 							 idx);
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 1977ee0adcb1..9e02a5d80225 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -340,10 +340,6 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
 		mutex_lock(&of_rmem_assigned_device_mutex);
 		list_add(&rd->list, &of_rmem_assigned_device_list);
 		mutex_unlock(&of_rmem_assigned_device_mutex);
-		/* ensure that dma_ops is set for virtual devices
-		 * using reserved memory
-		 */
-		of_dma_configure(dev, np, true);
 
 		dev_info(dev, "assigned reserved memory node %s\n", rmem->name);
 	} else {
-- 
2.20.1.dirty

