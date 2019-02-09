Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E125EC169C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACEE2217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 01:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfBIBtg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 20:49:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:64023 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbfBIBtg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 20:49:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 17:49:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,349,1544515200"; 
   d="scan'208";a="317531830"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga006.fm.intel.com with ESMTP; 08 Feb 2019 17:49:35 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.140) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 8 Feb 2019 17:49:35 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     <linux-media@vger.kernel.org>
CC:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v2 2/4] media: v4l2-tpg-core: Add support for 32-bit packed YUV formats (v2)
Date:   Fri, 8 Feb 2019 17:29:32 -0800
Message-ID: <20190209012932.620-1-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <201902081808.jJTzoaUK%fengguang.wu@intel.com>
References: <201902081808.jJTzoaUK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.22.254.140]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for the following formats to tpg:
 V4L2_PIX_FMT_AYUV32
 V4L2_PIX_FMT_XYUV32
 V4L2_PIX_FMT_VUYA32
 V4L2_PIX_FMT_VUYX32

Changes from v1:
Remove the duplicate case value

Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index d9a590ae7545..07e0629af8ed 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -246,6 +246,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_YUV555:
 	case V4L2_PIX_FMT_YUV565:
 	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_AYUV32:
+	case V4L2_PIX_FMT_XYUV32:
+	case V4L2_PIX_FMT_VUYA32:
+	case V4L2_PIX_FMT_VUYX32:
 		tpg->color_enc = TGP_COLOR_ENC_YCBCR;
 		break;
 	case V4L2_PIX_FMT_YUV420M:
@@ -372,6 +376,10 @@ bool tpg_s_fourcc(struct tpg_data *tpg, u32 fourcc)
 	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_ABGR32:
 	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_AYUV32:
+	case V4L2_PIX_FMT_XYUV32:
+	case V4L2_PIX_FMT_VUYA32:
+	case V4L2_PIX_FMT_VUYX32:
 	case V4L2_PIX_FMT_HSV32:
 		tpg->twopixelsize[0] = 2 * 4;
 		break;
@@ -1267,10 +1275,12 @@ static void gen_twopix(struct tpg_data *tpg,
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
 	case V4L2_PIX_FMT_HSV32:
+	case V4L2_PIX_FMT_XYUV32:
 		alpha = 0;
 		/* fall through */
 	case V4L2_PIX_FMT_YUV32:
 	case V4L2_PIX_FMT_ARGB32:
+	case V4L2_PIX_FMT_AYUV32:
 		buf[0][offset] = alpha;
 		buf[0][offset + 1] = r_y_h;
 		buf[0][offset + 2] = g_u_s;
@@ -1278,9 +1288,11 @@ static void gen_twopix(struct tpg_data *tpg,
 		break;
 	case V4L2_PIX_FMT_BGR32:
 	case V4L2_PIX_FMT_XBGR32:
+	case V4L2_PIX_FMT_VUYX32:
 		alpha = 0;
 		/* fall through */
 	case V4L2_PIX_FMT_ABGR32:
+	case V4L2_PIX_FMT_VUYA32:
 		buf[0][offset] = b_v;
 		buf[0][offset + 1] = g_u_s;
 		buf[0][offset + 2] = r_y_h;
-- 
2.14.5

