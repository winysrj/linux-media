Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:14528 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbeJHTkT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 15:40:19 -0400
From: bwinther@cisco.com
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com,
        =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
Subject: [PATCH 1/4] common: utils: Add last 3 16-bit bayer formats
Date: Mon,  8 Oct 2018 14:28:44 +0200
Message-Id: <20181008122847.25600-1-bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bård Eirik Winther <bwinther@cisco.com>

Add the remaining 16-bit bayer formats to rle_calc_bpl, namely:
  V4L2_PIX_FMT_SGBRG16
  V4L2_PIX_FMT_SGRBG16
  V4L2_PIX_FMT_SRGGB16

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 utils/common/v4l-stream.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils/common/v4l-stream.c b/utils/common/v4l-stream.c
index 772de727..89f57379 100644
--- a/utils/common/v4l-stream.c
+++ b/utils/common/v4l-stream.c
@@ -51,6 +51,9 @@ unsigned rle_calc_bpl(unsigned bpl, __u32 pixelformat)
 	case V4L2_PIX_FMT_SGRBG12:
 	case V4L2_PIX_FMT_SRGGB12:
 	case V4L2_PIX_FMT_SBGGR16:
+	case V4L2_PIX_FMT_SGBRG16:
+	case V4L2_PIX_FMT_SGRBG16:
+	case V4L2_PIX_FMT_SRGGB16:
 		return 2 * bpl;
 	default:
 		return bpl;
-- 
2.17.1
