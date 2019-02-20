Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572F3C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239A72146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfBTLU5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:20:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:17943 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfBTLU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:20:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 03:20:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,390,1544515200"; 
   d="scan'208";a="125836763"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 20 Feb 2019 03:20:55 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id DE7CC20892;
        Wed, 20 Feb 2019 13:20:54 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gwPut-000243-2B; Wed, 20 Feb 2019 13:19:55 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 2/5] staging: imgu: Fix struct ipu3_uapi_awb_fr_config_s alignment
Date:   Wed, 20 Feb 2019 13:19:50 +0200
Message-Id: <20190220111953.7886-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
References: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

struct ipu3_uapi_awb_fr_config_s is labelled as to be aligned to 32 bytes
but that's not the case in the ISP parameter struct of the driver, struct
ipu3_uapi_acc_param which is packed.

Also there is no need for the alignment as the struct is only handled by the
driver. Remove the alignment from the struct.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/include/intel-ipu3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index cbb62643172be..4cdb4c791ecec 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -450,7 +450,7 @@ struct ipu3_uapi_awb_fr_config_s {
 	__u32 bayer_sign;
 	__u8 bayer_nf;
 	__u8 reserved2[3];
-} __aligned(32) __packed;
+} __packed;
 
 /**
  * struct ipu3_uapi_4a_config - 4A config
-- 
2.11.0

