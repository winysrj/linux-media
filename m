Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31505 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2BPSYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 13:24:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZI007W10G4XR80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZI00FAK0G3MA@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 18:24:04 +0000 (GMT)
Date: Thu, 16 Feb 2012 19:23:54 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 1/6] V4L: Add V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 media bus
 format
In-reply-to: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329416639-19454-2-git-send-email-s.nawrocki@samsung.com>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds media bus pixel code for the interleaved JPEG/YUYV image
format used by S5C73MX Samsung cameras. The interleaved image data is
transferred on MIPI-CSI2 bus as User Defined Byte-based Data.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/v4l2-mediabus.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5ea7f75..c2f0e4e 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -92,6 +92,9 @@ enum v4l2_mbus_pixelcode {
 
 	/* JPEG compressed formats - next is 0x4002 */
 	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
+
+	/* Interleaved JPEG and YUV formats - next is 0x4102 */
+	V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 = 0x4101,
 };
 
 /**
-- 
1.7.9

