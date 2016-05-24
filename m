Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35478 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbcEXPGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:06:22 -0400
Received: by mail-pf0-f172.google.com with SMTP id g64so7962000pfb.2
        for <linux-media@vger.kernel.org>; Tue, 24 May 2016 08:06:22 -0700 (PDT)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	ricardo.ribalda@gmail.com, p.zabel@pengutronix.de,
	wuchengli@chromium.org, shuahkh@osg.samsung.com,
	hans.verkuil@cisco.com, renesas@ideasonboard.com,
	guennadi.liakhovetski@intel.com, sakari.ailus@linux.intel.com,
	posciak@chromium.org, djkurtz@chromium.org,
	tiffany.lin@mediatek.com, pc.chen@mediatek.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] videodev2.h: add V4L2_PIX_FMT_VP9 format.
Date: Tue, 24 May 2016 23:05:21 +0800
Message-Id: <1464102324-53965-2-git-send-email-wuchengli@chromium.org>
In-Reply-To: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
References: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds VP9 video coding format, a successor to VP8.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 8f95191..a95f940 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -594,6 +594,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
+#define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-- 
2.8.0.rc3.226.g39d4020

