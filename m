Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:58791 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbeJDSDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 14:03:42 -0400
From: bwinther@cisco.com
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com,
        =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Subject: [PATCH 2/2] media: vivid: Add 16-bit bayer to format list
Date: Thu,  4 Oct 2018 13:01:14 +0200
Message-Id: <20181004110114.3150-2-bwinther@cisco.com>
In-Reply-To: <20181004110114.3150-1-bwinther@cisco.com>
References: <20181004110114.3150-1-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bård Eirik Winther <bwinther@cisco.com>

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 .../media/platform/vivid/vivid-vid-common.c   | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 27a0000a5973..9645a91b8782 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -449,6 +449,34 @@ struct vivid_fmt vivid_formats[] = {
 		.planes   = 1,
 		.buffers = 1,
 	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SBGGR16, /* Bayer BG/GR */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SGBRG16, /* Bayer GB/RG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SGRBG16, /* Bayer GR/BG */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
+	{
+		.fourcc   = V4L2_PIX_FMT_SRGGB16, /* Bayer RG/GB */
+		.vdownsampling = { 1 },
+		.bit_depth = { 16 },
+		.planes   = 1,
+		.buffers = 1,
+	},
 	{
 		.fourcc   = V4L2_PIX_FMT_HSV24, /* HSV 24bits */
 		.color_enc = TGP_COLOR_ENC_HSV,
-- 
2.17.1
