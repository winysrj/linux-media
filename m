Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37290 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab2FZNpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 09:45:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 2/6] omap3isp: video: Add YUYV8_2X8 and UYVY8_2X8 support
Date: Tue, 26 Jun 2012 15:45:35 +0200
Message-Id: <1340718339-29915-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/omap3isp/ispvideo.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index f0ed2ec..9ce158e 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -114,6 +114,12 @@ static struct isp_format_info formats[] = {
 	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
 	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
 	  V4L2_PIX_FMT_YUYV, 16, 16, },
+	{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
+	  V4L2_MBUS_FMT_UYVY8_2X8, 0,
+	  V4L2_PIX_FMT_UYVY, 8, 16, },
+	{ V4L2_MBUS_FMT_YUYV8_2X8, V4L2_MBUS_FMT_YUYV8_2X8,
+	  V4L2_MBUS_FMT_YUYV8_2X8, 0,
+	  V4L2_PIX_FMT_YUYV, 8, 16, },
 };
 
 const struct isp_format_info *
-- 
1.7.3.4

