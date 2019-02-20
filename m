Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEA2C10F02
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7B412146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfBTLU7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:20:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:35976 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfBTLU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:20:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 03:20:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,390,1544515200"; 
   d="scan'208";a="144997514"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 20 Feb 2019 03:20:56 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 7358B209D2;
        Wed, 20 Feb 2019 13:20:55 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gwPut-000246-Np; Wed, 20 Feb 2019 13:19:55 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 3/5] staging: imgu: Remove redundant checks
Date:   Wed, 20 Feb 2019 13:19:51 +0200
Message-Id: <20190220111953.7886-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
References: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove redundant checks for less than zero on unsigned variables.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/ipu3-css-fw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css-fw.c b/drivers/staging/media/ipu3/ipu3-css-fw.c
index 4122d4e42db6c..45aff76198e2c 100644
--- a/drivers/staging/media/ipu3/ipu3-css-fw.c
+++ b/drivers/staging/media/ipu3/ipu3-css-fw.c
@@ -200,13 +200,11 @@ int imgu_css_fw_init(struct imgu_css *css)
 			goto bad_fw;
 
 		for (j = 0; j < bi->info.isp.num_output_formats; j++)
-			if (bi->info.isp.output_formats[j] < 0 ||
-			    bi->info.isp.output_formats[j] >=
+			if (bi->info.isp.output_formats[j] >=
 			    IMGU_ABI_FRAME_FORMAT_NUM)
 				goto bad_fw;
 		for (j = 0; j < bi->info.isp.num_vf_formats; j++)
-			if (bi->info.isp.vf_formats[j] < 0 ||
-			    bi->info.isp.vf_formats[j] >=
+			if (bi->info.isp.vf_formats[j] >=
 			    IMGU_ABI_FRAME_FORMAT_NUM)
 				goto bad_fw;
 
-- 
2.11.0

