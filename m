Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D290FC65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 11:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A181C2086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 11:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A181C2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbeLLLuZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 06:50:25 -0500
Received: from mga06.intel.com ([134.134.136.31]:2308 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbeLLLuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 06:50:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2018 03:50:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,344,1539673200"; 
   d="scan'208";a="118163841"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga001.jf.intel.com with ESMTP; 12 Dec 2018 03:50:22 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 1AB762022B;
        Wed, 12 Dec 2018 13:50:21 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gX31v-0005tG-JC; Wed, 12 Dec 2018 13:50:19 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, rajmohan.mani@intel.com, tfiga@chromium.org
Subject: [PATCH 1/1] ipu3-imgu: Fix firmware binary location
Date:   Wed, 12 Dec 2018 13:50:19 +0200
Message-Id: <20181212115019.22604-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The firmware binary is located under "intel" directory in the
linux-firmware repository. Reflect this in the driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/ipu3-css-fw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css-fw.h b/drivers/staging/media/ipu3/ipu3-css-fw.h
index d1ffe5170e74a..07d8bb8b25f35 100644
--- a/drivers/staging/media/ipu3/ipu3-css-fw.h
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.h
@@ -6,7 +6,7 @@
 
 /******************* Firmware file definitions *******************/
 
-#define IMGU_FW_NAME			"ipu3-fw.bin"
+#define IMGU_FW_NAME			"intel/ipu3-fw.bin"
 
 typedef u32 imgu_fw_ptr;
 
-- 
2.11.0

