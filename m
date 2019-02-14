Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4D6C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 10:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3ED7222A4
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 10:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395314AbfBNKup (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 05:50:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:5693 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387932AbfBNKup (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 05:50:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2019 02:50:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,368,1544515200"; 
   d="scan'208";a="124427817"
Received: from ipu5-build.bj.intel.com ([10.238.232.171])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2019 02:50:43 -0800
From:   bingbu.cao@intel.com
To:     linux-media@vger.kernel.org
Cc:     sakari.ailus@linux.intel.com, tfiga@chromium.org,
        andy.yeh@intel.com, bingbu.cao@linux.intel.com
Subject: [PATCH] media:staging/intel-ipu3: update minimal GDC envelope size to 4
Date:   Thu, 14 Feb 2019 18:56:57 +0800
Message-Id: <1550141817-25453-1-git-send-email-bingbu.cao@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Bingbu Cao <bingbu.cao@intel.com>

The ipu3 GDC function need some envelope to do filtering and the
minimal envelope size(GDC in - out) for ipu3 should be 4.
Current value 4 was defined for older version GDC, this patch
correct it.

Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
---
 drivers/staging/media/ipu3/ipu3-css.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 44c55639389a..8864206fd7e3 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -23,9 +23,8 @@
 #define IPU3_CSS_MAX_H		3136
 #define IPU3_CSS_MAX_W		4224
 
-/* filter size from graph settings is fixed as 4 */
-#define FILTER_SIZE             4
-#define MIN_ENVELOPE            8
+/* minimal envelope size(GDC in - out) should be 4 */
+#define MIN_ENVELOPE            4
 
 /*
  * pre-allocated buffer size for CSS ABI, auxiliary frames
@@ -1821,9 +1820,9 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
 	vf->width   = ipu3_css_adjust(vf->width, VF_ALIGN_W);
 	vf->height  = ipu3_css_adjust(vf->height, 1);
 
-	s = (bds->width - gdc->width) / 2 - FILTER_SIZE;
+	s = (bds->width - gdc->width) / 2;
 	env->width = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
-	s = (bds->height - gdc->height) / 2 - FILTER_SIZE;
+	s = (bds->height - gdc->height) / 2;
 	env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
 
 	css->pipes[pipe].bindex =
@@ -2245,9 +2244,8 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 				css_pipe->aux_frames[a].height,
 				css_pipe->rect[g].width,
 				css_pipe->rect[g].height,
-				css_pipe->rect[e].width + FILTER_SIZE,
-				css_pipe->rect[e].height +
-				FILTER_SIZE);
+				css_pipe->rect[e].width,
+				css_pipe->rect[e].height);
 		}
 	}
 
-- 
1.9.1

