Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44608 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751968AbdDJHvt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 03:51:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.12] videodev2.h: fix outdated comment
Message-ID: <baec3430-9b4e-ba54-ee9c-1450958ac2eb@xs4all.nl>
Date: Mon, 10 Apr 2017 09:51:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The XV601/709 Y'CbCr encoding was changed to limited range, but the comment
still indicates full range.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 316be62f3a45..5d842a61d94a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -362,8 +362,7 @@ enum v4l2_quantization {
 	/*
 	 * The default for R'G'B' quantization is always full range, except
 	 * for the BT2020 colorspace. For Y'CbCr the quantization is always
-	 * limited range, except for COLORSPACE_JPEG, XV601 or XV709: those
-	 * are full range.
+	 * limited range, except for COLORSPACE_JPEG: this is full range.
 	 */
 	V4L2_QUANTIZATION_DEFAULT     = 0,
 	V4L2_QUANTIZATION_FULL_RANGE  = 1,
