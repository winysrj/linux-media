Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4255C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 03:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD372147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 03:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfBHDht (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 22:37:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:51818 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfBHDhs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 22:37:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 19:37:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,346,1544515200"; 
   d="scan'208";a="142566580"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga004.fm.intel.com with ESMTP; 07 Feb 2019 19:37:48 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.138) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 7 Feb 2019 19:37:47 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     <linux-media@vger.kernel.org>
CC:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 3/4] media: vivid: Add definitions for the 32-bit packed YUV formats
Date:   Thu, 7 Feb 2019 19:18:45 -0800
Message-ID: <20190208031846.14453-4-vivek.kasireddy@intel.com>
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

Enable vivid to make use of the following formats:
 V4L2_PIX_FMT_AYUV32
 V4L2_PIX_FMT_XYUV32
 V4L2_PIX_FMT_VUYA32
 V4L2_PIX_FMT_VUYX32

Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 30 +++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 661f4015fba1..74b83bcc6119 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -168,6 +168,36 @@ struct vivid_fmt vivid_formats[] = {
 		.buffers = 1,
 		.alpha_mask = 0x000000ff,
 	},
+	{
+		.fourcc   = V4L2_PIX_FMT_AYUV32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0x000000ff,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_XYUV32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_VUYA32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+		.alpha_mask = 0xff000000,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_VUYX32,
+		.vdownsampling = { 1 },
+		.bit_depth = { 32 },
+		.planes   = 1,
+		.buffers = 1,
+	},
 	{
 		.fourcc   = V4L2_PIX_FMT_GREY,
 		.vdownsampling = { 1 },
-- 
2.14.5

