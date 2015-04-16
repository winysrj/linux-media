Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48149 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbDPH6l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 03:58:41 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id AC0492074F
	for <linux-media@vger.kernel.org>; Thu, 16 Apr 2015 09:56:39 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] media-ctl: libv4l2subdev: Add missing formats
Date: Thu, 16 Apr 2015 10:58:37 +0300
Message-Id: <1429171117-4866-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1429171117-4866-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1429171117-4866-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the RGB888_1X24, RGB888_1X32_PADHI and VUY8_1X24
formats.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/libv4l2subdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 6ea6648..16aa530 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -708,6 +708,7 @@ static struct {
 	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16 },
 	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8 },
 	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8 },
+	{ "VUY24", MEDIA_BUS_FMT_VUY8_1X24 },
 	{ "SBGGR8", MEDIA_BUS_FMT_SBGGR8_1X8 },
 	{ "SGBRG8", MEDIA_BUS_FMT_SGBRG8_1X8 },
 	{ "SGRBG8", MEDIA_BUS_FMT_SGRBG8_1X8 },
@@ -725,6 +726,8 @@ static struct {
 	{ "SGRBG12", MEDIA_BUS_FMT_SGRBG12_1X12 },
 	{ "SRGGB12", MEDIA_BUS_FMT_SRGGB12_1X12 },
 	{ "AYUV32", MEDIA_BUS_FMT_AYUV8_1X32 },
+	{ "RBG24", MEDIA_BUS_FMT_RBG888_1X24 },
+	{ "RGB32", MEDIA_BUS_FMT_RGB888_1X32_PADHI },
 	{ "ARGB32", MEDIA_BUS_FMT_ARGB8888_1X32 },
 };
 
-- 
2.0.5

