Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BF5C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24632147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfBHImo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:42:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:51145 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbfBHIml (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:42:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 00:42:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="scan'208";a="317337153"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga006.fm.intel.com with ESMTP; 08 Feb 2019 00:42:39 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 17D9B20951;
        Fri,  8 Feb 2019 10:42:39 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gs1jJ-0002bn-Mg; Fri, 08 Feb 2019 10:41:49 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 4/4] soc_camera: Depend on BROKEN
Date:   Fri,  8 Feb 2019 10:41:47 +0200
Message-Id: <20190208084147.9973-5-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
References: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch makes the SoC camera framework as well as effectively the few
remaining sensor drivers depend on BROKEN, rendering it uncompileable
without changes in Kconfig.

The purpose is to leave the code around if someone wishes to convert the
drivers to the modern day V4L2 sub-device framework without having to go
to see development history in git.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/soc_camera/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/soc_camera/Kconfig b/drivers/staging/media/soc_camera/Kconfig
index 6a6aa6d2d150e..bacd30f0348dc 100644
--- a/drivers/staging/media/soc_camera/Kconfig
+++ b/drivers/staging/media/soc_camera/Kconfig
@@ -1,6 +1,6 @@
 config SOC_CAMERA
 	tristate "SoC camera support"
-	depends on VIDEO_V4L2 && HAS_DMA && I2C
+	depends on VIDEO_V4L2 && HAS_DMA && I2C && BROKEN
 	select VIDEOBUF2_CORE
 	help
 	  SoC Camera is a common API to several cameras, not connecting
-- 
2.11.0

