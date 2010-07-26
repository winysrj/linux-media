Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:58116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753909Ab0GZQUc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 12:20:32 -0400
Date: Mon, 26 Jul 2010 18:20:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 1/5] V4L2: mediabus: add 12-bit Bayer and YUV420 pixel formats
In-Reply-To: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
Message-ID: <Pine.LNX.4.64.1007261748450.9816@axis700.grange>
References: <Pine.LNX.4.64.1007261739180.9816@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These formats belong to the standard format set, defined by the MIPI CSI-2
specification.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-mediabus.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 865cda7..584e1b1 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -41,6 +41,11 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
 	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SBGGR12_1X12,
+	V4L2_MBUS_FMT_YUYV8_1_5X8,
+	V4L2_MBUS_FMT_YVYU8_1_5X8,
+	V4L2_MBUS_FMT_UYVY8_1_5X8,
+	V4L2_MBUS_FMT_VYUY8_1_5X8,
 };
 
 /**
-- 
1.6.2.4

