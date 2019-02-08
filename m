Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19B3C282D7
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 03:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C96B321916
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 03:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfBHDht (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 22:37:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:51818 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfBHDht (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 22:37:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 19:37:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,346,1544515200"; 
   d="scan'208";a="142566581"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga004.fm.intel.com with ESMTP; 07 Feb 2019 19:37:48 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.138) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 7 Feb 2019 19:37:48 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     <linux-media@vger.kernel.org>
CC:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/4] media: imx-pxp: Start using the format VUYA32 instead of YUV32
Date:   Thu, 7 Feb 2019 19:18:46 -0800
Message-ID: <20190208031846.14453-5-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190208031846.14453-1-vivek.kasireddy@intel.com>
References: <20190208031846.14453-1-vivek.kasireddy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.22.254.138]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Buffers generated with YUV32 format seems to be incorrect, hence use
VUYA32 instead.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/media/platform/imx-pxp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index f087dc4fc729..70adbe38f802 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -90,7 +90,7 @@ static struct pxp_fmt formats[] = {
 		.depth	= 16,
 		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
-		.fourcc = V4L2_PIX_FMT_YUV32,
+		.fourcc = V4L2_PIX_FMT_VUYA32,
 		.depth	= 32,
 		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
@@ -236,7 +236,7 @@ static u32 pxp_v4l2_pix_fmt_to_ps_format(u32 v4l2_pix_fmt)
 	case V4L2_PIX_FMT_RGB555:  return BV_PXP_PS_CTRL_FORMAT__RGB555;
 	case V4L2_PIX_FMT_RGB444:  return BV_PXP_PS_CTRL_FORMAT__RGB444;
 	case V4L2_PIX_FMT_RGB565:  return BV_PXP_PS_CTRL_FORMAT__RGB565;
-	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_VUYA32:  return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
 	case V4L2_PIX_FMT_UYVY:    return BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
 	case V4L2_PIX_FMT_YUYV:    return BM_PXP_PS_CTRL_WB_SWAP |
 					  BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
@@ -265,7 +265,7 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
 	case V4L2_PIX_FMT_RGB555:   return BV_PXP_OUT_CTRL_FORMAT__RGB555;
 	case V4L2_PIX_FMT_RGB444:   return BV_PXP_OUT_CTRL_FORMAT__RGB444;
 	case V4L2_PIX_FMT_RGB565:   return BV_PXP_OUT_CTRL_FORMAT__RGB565;
-	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_VUYA32:   return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
 	case V4L2_PIX_FMT_UYVY:     return BV_PXP_OUT_CTRL_FORMAT__UYVY1P422;
 	case V4L2_PIX_FMT_VYUY:     return BV_PXP_OUT_CTRL_FORMAT__VYUY1P422;
 	case V4L2_PIX_FMT_GREY:     return BV_PXP_OUT_CTRL_FORMAT__Y8;
@@ -281,7 +281,7 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
 static bool pxp_v4l2_pix_fmt_is_yuv(u32 v4l2_pix_fmt)
 {
 	switch (v4l2_pix_fmt) {
-	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_VUYA32:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_VYUY:
-- 
2.14.5

