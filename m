Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43016 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbeKRSHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 13:07:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: libcamera-devel@lists.libcamera.org,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH 2/2] Add support for IPU3 raw 10-bit Bayer packed formats
Date: Sun, 18 Nov 2018 09:47:56 +0200
Message-Id: <20181118074756.30811-3-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20181118074756.30811-1-laurent.pinchart@ideasonboard.com>
References: <20181118074756.30811-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacopo Mondi <jacopo@jmondi.org>

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 yavta.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/yavta.c b/yavta.c
index afe96331a520..c7986bd9e031 100644
--- a/yavta.c
+++ b/yavta.c
@@ -224,6 +224,10 @@ static struct v4l2_format_info {
 	{ "SGBRG12", V4L2_PIX_FMT_SGBRG12, 1 },
 	{ "SGRBG12", V4L2_PIX_FMT_SGRBG12, 1 },
 	{ "SRGGB12", V4L2_PIX_FMT_SRGGB12, 1 },
+	{ "IPU3_SBGGR10", V4L2_PIX_FMT_IPU3_SBGGR10, 1 },
+	{ "IPU3_SGBRG10", V4L2_PIX_FMT_IPU3_SGBRG10, 1 },
+	{ "IPU3_SGRBG10", V4L2_PIX_FMT_IPU3_SGRBG10, 1 },
+	{ "IPU3_SRGGB10", V4L2_PIX_FMT_IPU3_SRGGB10, 1 },
 	{ "DV", V4L2_PIX_FMT_DV, 1 },
 	{ "MJPEG", V4L2_PIX_FMT_MJPEG, 1 },
 	{ "MPEG", V4L2_PIX_FMT_MPEG, 1 },
-- 
Regards,

Laurent Pinchart
