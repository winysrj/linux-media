Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:51265 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKFKMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:17 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00MRK4CFF220@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:15 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 07/11] mediactl: Add VYUY8_2X8 media bus format
Date: Thu, 06 Nov 2014 11:11:38 +0100
Message-id: <1415268702-23685-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VYUY8_2X8 media bus format is the only one supported
by the S5C73M3 camera sensor, that is a part of the media
device on the Exynos4412-trats2 board.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 449565c..0c6aaef 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -705,6 +705,7 @@ static struct {
 	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
 	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
 	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
+	{ "VYUY8_2X8", V4L2_MBUS_FMT_VYUY8_2X8 },
 	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
 	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
 	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
-- 
1.7.9.5

