Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23924C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC4020818
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732946AbfCALYM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:24:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:13529 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732302AbfCALYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 06:24:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 03:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,427,1544515200"; 
   d="scan'208";a="130377202"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2019 03:24:08 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id CA36320951;
        Fri,  1 Mar 2019 13:24:07 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gzgGo-0006LR-97; Fri, 01 Mar 2019 13:24:02 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH v2 3/4] staging: imgu: Address compiler / checker warnings in MMU code
Date:   Fri,  1 Mar 2019 13:23:59 +0200
Message-Id: <20190301112400.24339-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
References: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Address C compiler, sparse and smatch warnings and little style issues in
the IMGU MMU code.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/staging/media/ipu3/ipu3-mmu.c | 39 +++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-mmu.c b/drivers/staging/media/ipu3/ipu3-mmu.c
index cfc2bdfb14b33..a55ff39be1882 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.c
+++ b/drivers/staging/media/ipu3/ipu3-mmu.c
@@ -275,7 +275,17 @@ static size_t imgu_mmu_pgsize(unsigned long pgsize_bitmap,
 	return pgsize;
 }
 
-/* drivers/iommu/iommu.c/iommu_map() */
+/**
+ * imgu_mmu_map - map a buffer to a physical address
+ *
+ * @info: MMU mappable range
+ * @iova: the virtual address
+ * @paddr: the physical address
+ * @size: length of the mappable area
+ *
+ * The function has been adapted from iommu_map() in
+ * drivers/iommu/iommu.c .
+ */
 int imgu_mmu_map(struct imgu_mmu_info *info, unsigned long iova,
 		 phys_addr_t paddr, size_t size)
 {
@@ -321,7 +331,17 @@ int imgu_mmu_map(struct imgu_mmu_info *info, unsigned long iova,
 	return ret;
 }
 
-/* drivers/iommu/iommu.c/default_iommu_map_sg() */
+/**
+ * imgu_mmu_map_sg - Map a scatterlist
+ *
+ * @info: MMU mappable range
+ * @iova: the virtual address
+ * @sg: the scatterlist to map
+ * @nents: number of entries in the scatterlist
+ *
+ * The function has been adapted from default_iommu_map_sg() in
+ * drivers/iommu/iommu.c .
+ */
 size_t imgu_mmu_map_sg(struct imgu_mmu_info *info, unsigned long iova,
 		       struct scatterlist *sg, unsigned int nents)
 {
@@ -394,7 +414,16 @@ static size_t __imgu_mmu_unmap(struct imgu_mmu *mmu,
 	return unmap;
 }
 
-/* drivers/iommu/iommu.c/iommu_unmap() */
+/**
+ * imgu_mmu_unmap - Unmap a buffer
+ *
+ * @info: MMU mappable range
+ * @iova: the virtual address
+ * @size: the length of the buffer
+ *
+ * The function has been adapted from iommu_unmap() in
+ * drivers/iommu/iommu.c .
+ */
 size_t imgu_mmu_unmap(struct imgu_mmu_info *info, unsigned long iova,
 		      size_t size)
 {
@@ -444,6 +473,7 @@ size_t imgu_mmu_unmap(struct imgu_mmu_info *info, unsigned long iova,
 
 /**
  * imgu_mmu_init() - initialize IPU3 MMU block
+ *
  * @parent:	struct device parent
  * @base:	IOMEM base of hardware registers.
  *
@@ -523,7 +553,8 @@ struct imgu_mmu_info *imgu_mmu_init(struct device *parent, void __iomem *base)
 
 /**
  * imgu_mmu_exit() - clean up IPU3 MMU block
- * @info: IPU3 MMU private data
+ *
+ * @info: MMU mappable range
  */
 void imgu_mmu_exit(struct imgu_mmu_info *info)
 {
-- 
2.11.0

