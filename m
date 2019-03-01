Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788E8C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E0C206DD
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbfCALYJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:24:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:24990 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbfCALYJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 06:24:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 03:24:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,427,1544515200"; 
   d="scan'208";a="323190746"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2019 03:24:07 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id E696320728;
        Fri,  1 Mar 2019 13:24:06 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gzgGn-0006LL-CN; Fri, 01 Mar 2019 13:24:01 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH v2 1/4] staging: imgu: Address a compiler warning on alignment
Date:   Fri,  1 Mar 2019 13:23:57 +0200
Message-Id: <20190301112400.24339-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
References: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Address a compiler warnings on alignment of struct ipu3_uapi_awb_fr_config_s
by adding __attribute__((aligned(32))) to a struct member of that type as
well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/staging/media/ipu3/include/intel-ipu3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index eb6f52aca9929..4a0e97b0cfd2b 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -2472,7 +2472,7 @@ struct ipu3_uapi_acc_param {
 	struct ipu3_uapi_yuvp1_yds_config yds2 __attribute__((aligned(32)));
 	struct ipu3_uapi_yuvp2_tcc_static_config tcc __attribute__((aligned(32)));
 	struct ipu3_uapi_anr_config anr;
-	struct ipu3_uapi_awb_fr_config_s awb_fr;
+	struct ipu3_uapi_awb_fr_config_s awb_fr __attribute__((aligned(32)));
 	struct ipu3_uapi_ae_config ae;
 	struct ipu3_uapi_af_config_s af;
 	struct ipu3_uapi_awb_config awb;
-- 
2.11.0

