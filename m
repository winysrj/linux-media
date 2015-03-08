Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35393 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbbCHHyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:54:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] videodev2.h: fix comment
Date: Sun,  8 Mar 2015 08:53:32 +0100
Message-Id: <1425801213-14230-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
References: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..15b21e4 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -268,9 +268,10 @@ enum v4l2_ycbcr_encoding {
 
 enum v4l2_quantization {
 	/*
-	 * The default for R'G'B' quantization is always full range. For
-	 * Y'CbCr the quantization is always limited range, except for
-	 * SYCC, XV601, XV709 or JPEG: those are full range.
+	 * The default for R'G'B' quantization is always full range, except
+	 * for the BT2020 colorspace. For Y'CbCr the quantization is always
+	 * limited range, except for COLORSPACE_JPEG, SYCC, XV601 or XV709:
+	 * those are full range.
 	 */
 	V4L2_QUANTIZATION_DEFAULT     = 0,
 	V4L2_QUANTIZATION_FULL_RANGE  = 1,
-- 
2.1.4

