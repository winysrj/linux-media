Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD87AC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A50E2186A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732970AbfCALYM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:24:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:49819 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732835AbfCALYL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 06:24:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 03:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,427,1544515200"; 
   d="scan'208";a="138223551"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2019 03:24:09 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 4B29320957;
        Fri,  1 Mar 2019 13:24:08 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gzgGo-0006LU-NO; Fri, 01 Mar 2019 13:24:02 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH v2 4/4] Revert "media: ipu3: shut up warnings produced with W=1"
Date:   Fri,  1 Mar 2019 13:24:00 +0200
Message-Id: <20190301112400.24339-5-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
References: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This reverts commit 0bdfc56c13c0ffe003f28395fcde2cd9b5ea0622.

The original patch suppressed compiler and checker warnings and those
warnings have been addressed. Do not attempt to suppress these warnings
anymore.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Rajmohan Mani <rajmohan.mani@intel.com>
---
 drivers/staging/media/ipu3/Makefile | 6 ------
 drivers/staging/media/ipu3/TODO     | 2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/media/ipu3/Makefile b/drivers/staging/media/ipu3/Makefile
index fa7fa3372bcbe..fb146d178bd4b 100644
--- a/drivers/staging/media/ipu3/Makefile
+++ b/drivers/staging/media/ipu3/Makefile
@@ -9,9 +9,3 @@ ipu3-imgu-objs += \
 		ipu3-css.o ipu3-v4l2.o ipu3.o
 
 obj-$(CONFIG_VIDEO_IPU3_IMGU) += ipu3-imgu.o
-
-# HACK! While this driver is in bad shape, don't enable several warnings
-#       that would be otherwise enabled with W=1
-ccflags-y += $(call cc-disable-warning, packed-not-aligned)
-ccflags-y += $(call cc-disable-warning, type-limits)
-ccflags-y += $(call cc-disable-warning, unused-const-variable)
diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
index 5e55baeaea1a3..8b95e74e43a0f 100644
--- a/drivers/staging/media/ipu3/TODO
+++ b/drivers/staging/media/ipu3/TODO
@@ -27,5 +27,3 @@ staging directory.
 - Document different operation modes, and which buffer queues are relevant
   in each mode. To process an image, which queues require a buffer an in
   which ones is it optional?
-
-- Make sure it builds fine with no warnings with W=1
-- 
2.11.0

