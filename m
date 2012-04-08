Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48371 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753986Ab2DHDyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Apr 2012 23:54:47 -0400
Received: by obbtb4 with SMTP id tb4so5196912obb.31
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 20:54:46 -0700 (PDT)
From: saaguirre@ti.com
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH] Add support for YUV420 formats
Date: Sat,  7 Apr 2012 22:54:34 -0500
Message-Id: <1333857274-9435-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergio Aguirre <saaguirre@ti.com>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 src/v4l2subdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index b886b72..e28ed49 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -498,8 +498,10 @@ static struct {
 	{ "Y12", V4L2_MBUS_FMT_Y12_1X12 },
 	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
 	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
+	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
 	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
 	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
+	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
 	{ "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
 	{ "SGBRG8", V4L2_MBUS_FMT_SGBRG8_1X8 },
 	{ "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
-- 
1.7.5.4

