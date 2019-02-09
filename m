Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D79C169C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BCC217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfBIB47 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:56:59 -0500
Received: from mga12.intel.com ([192.55.52.136]:34303 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfBIB47 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 20:56:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 17:56:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,349,1544515200"; 
   d="scan'208";a="317532834"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga006.fm.intel.com with ESMTP; 08 Feb 2019 17:56:59 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.139) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 8 Feb 2019 17:56:58 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     <linux-media@vger.kernel.org>
CC:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 4/4] media: imx-pxp: Start using the format VUYA32 instead of YUV32 (v2)
Date:   Fri, 8 Feb 2019 17:38:18 -0800
Message-ID: <20190209013818.979-1-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <1549621864.3305.5.camel@pengutronix.de>
References: <1549621864.3305.5.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.22.254.139]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Buffers generated with YUV32 format seems to be incorrect, hence use
VUYA32 instead.

Changes from v1:
Add both formats VUYA32 and VUYX32 but associate only VUYX32 to the
output queue as the alpha channel of buffers is ignored on this queue.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/media/platform/imx-pxp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index f087dc4fc729..0bcfc5aa8f3d 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -90,7 +90,11 @@ static struct pxp_fmt formats[] = {
 		.depth	= 16,
 		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
-		.fourcc = V4L2_PIX_FMT_YUV32,
+		.fourcc = V4L2_PIX_FMT_VUYA32,
+		.depth	= 32,
+		.types	= MEM2MEM_CAPTURE,
+	}, {
+		.fourcc = V4L2_PIX_FMT_VUYX32,
 		.depth	= 32,
 		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
 	}, {
@@ -236,7 +240,7 @@ static u32 pxp_v4l2_pix_fmt_to_ps_format(u32 v4l2_pix_fmt)
 	case V4L2_PIX_FMT_RGB555:  return BV_PXP_PS_CTRL_FORMAT__RGB555;
 	case V4L2_PIX_FMT_RGB444:  return BV_PXP_PS_CTRL_FORMAT__RGB444;
 	case V4L2_PIX_FMT_RGB565:  return BV_PXP_PS_CTRL_FORMAT__RGB565;
-	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_VUYX32:  return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
 	case V4L2_PIX_FMT_UYVY:    return BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
 	case V4L2_PIX_FMT_YUYV:    return BM_PXP_PS_CTRL_WB_SWAP |
 					  BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
@@ -265,7 +269,8 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
 	case V4L2_PIX_FMT_RGB555:   return BV_PXP_OUT_CTRL_FORMAT__RGB555;
 	case V4L2_PIX_FMT_RGB444:   return BV_PXP_OUT_CTRL_FORMAT__RGB444;
 	case V4L2_PIX_FMT_RGB565:   return BV_PXP_OUT_CTRL_FORMAT__RGB565;
-	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_VUYA32:
+	case V4L2_PIX_FMT_VUYX32:   return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
 	case V4L2_PIX_FMT_UYVY:     return BV_PXP_OUT_CTRL_FORMAT__UYVY1P422;
 	case V4L2_PIX_FMT_VYUY:     return BV_PXP_OUT_CTRL_FORMAT__VYUY1P422;
 	case V4L2_PIX_FMT_GREY:     return BV_PXP_OUT_CTRL_FORMAT__Y8;
@@ -281,7 +286,8 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
 static bool pxp_v4l2_pix_fmt_is_yuv(u32 v4l2_pix_fmt)
 {
 	switch (v4l2_pix_fmt) {
-	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_VUYA32:
+	case V4L2_PIX_FMT_VUYX32:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_VYUY:
-- 
2.14.5

