Return-Path: <SRS0=IHcP=PI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B03C43387
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 17:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26DA2080D
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 17:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbeLaRrS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 31 Dec 2018 12:47:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:20990 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbeLaRrS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Dec 2018 12:47:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2018 09:47:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,423,1539673200"; 
   d="scan'208";a="287887323"
Received: from minminho-mobl.amr.corp.intel.com (HELO yzhi-desktop.amr.corp.intel.com) ([10.254.56.188])
  by orsmga005.jf.intel.com with ESMTP; 31 Dec 2018 09:47:16 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     tfiga@chromium.org, rajmohan.mani@intel.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 1/1] media: staging/intel-ipu3: Fix Kconfig for unmet direct dependencies
Date:   Mon, 31 Dec 2018 11:46:43 -0600
Message-Id: <1546278403-8306-1-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix link error for specific .config reported by lkp robot:

drivers/staging/media/ipu3/ipu3-dmamap.o: In function `ipu3_dmamap_alloc':
drivers/staging/media/ipu3/ipu3-dmamap.c:111: undefined reference to `alloc_iova'

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
Happy New Year!!

 drivers/staging/media/ipu3/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/Kconfig b/drivers/staging/media/ipu3/Kconfig
index 75cd889f18f7..c486cbbe859a 100644
--- a/drivers/staging/media/ipu3/Kconfig
+++ b/drivers/staging/media/ipu3/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_IPU3_IMGU
 	depends on PCI && VIDEO_V4L2
 	depends on MEDIA_CONTROLLER && VIDEO_V4L2_SUBDEV_API
 	depends on X86
-	select IOMMU_IOVA
+	select IOMMU_IOVA if IOMMU_SUPPORT
 	select VIDEOBUF2_DMA_SG
 	---help---
 	  This is the Video4Linux2 driver for Intel IPU3 image processing unit,
-- 
2.7.4

