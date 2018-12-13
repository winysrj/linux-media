Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65891C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 341CD20645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 341CD20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbeLMJvX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:21683 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbeLMJvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="283251197"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 13 Dec 2018 01:51:19 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 1E900204CC;
        Thu, 13 Dec 2018 11:51:20 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNeH-0003u7-QA; Thu, 13 Dec 2018 11:51:17 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 18/22] ipu3-imgu: Fix firmware binary location
Date:   Thu, 13 Dec 2018 11:51:03 +0200
Message-Id: <20181213095107.14894-19-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
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

