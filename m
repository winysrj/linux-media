Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D387C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 21:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47086217D9
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 21:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfABVRu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 16:17:50 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54036 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726089AbfABVRu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Jan 2019 16:17:50 -0500
Received: from vihersipuli.localdomain (vihersipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::84:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6371F634C84;
        Wed,  2 Jan 2019 23:16:57 +0200 (EET)
Received: from sailus by vihersipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@iki.fi>)
        id 1gensn-0003RT-8l; Wed, 02 Jan 2019 23:16:57 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     yong.zhi@intel.com, iommu@lists.linux-foundation.org,
        linux-media@vger.kernel.org, tfiga@chromium.org,
        rajmohan.mani@intel.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        bingbu.cao@intel.com, tian.shu.qiu@intel.com
Subject: [PATCH 1/1] iova: Allow compiling the library without IOMMU support
Date:   Wed,  2 Jan 2019 23:16:57 +0200
Message-Id: <20190102211657.13192-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Drivers such as the Intel IPU3 ImgU driver use the IOVA library to manage
the device's own virtual address space while not implementing the IOMMU
API. Currently the IOVA library is only compiled if the IOMMU support is
enabled, resulting into a failure during linking due to missing symbols.

Fix this by defining IOVA library Kconfig bits independently of IOMMU
support configuration, and descending to the iommu directory
unconditionally during the build.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/Makefile      | 2 +-
 drivers/iommu/Kconfig | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index 578f469f72fb..d9c469983592 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -56,7 +56,7 @@ obj-y				+= tty/
 obj-y				+= char/
 
 # iommu/ comes before gpu as gpu are using iommu controllers
-obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
+obj-y				+= iommu/
 
 # gpu/ comes after char for AGP vs DRM startup and after iommu
 obj-y				+= gpu/
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d9a25715650e..d2c83e62873d 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -1,3 +1,7 @@
+# The IOVA library may also be used by non-IOMMU_API users
+config IOMMU_IOVA
+	tristate
+
 # IOMMU_API always gets selected by whoever wants it.
 config IOMMU_API
 	bool
@@ -81,9 +85,6 @@ config IOMMU_DEFAULT_PASSTHROUGH
 
 	  If unsure, say N here.
 
-config IOMMU_IOVA
-	tristate
-
 config OF_IOMMU
        def_bool y
        depends on OF && IOMMU_API
-- 
2.11.0

