Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53154 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbbBZQA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:00:28 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD002VBZ4QUVC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:00:26 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 07/14] mediactl: libv4l2subdev: add VYUY8_2X8
 mbus code
Date: Thu, 26 Feb 2015 16:59:17 +0100
Message-id: <1424966364-3647-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VYUY8_2X8 media bus format is the only one supported
by the S5C73M3 camera sensor, that is a part of the media
device on the Exynos4412-trats2 board.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libv4l2subdev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 5b9d908..dfd3bd5 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -760,6 +760,7 @@ static struct {
 	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
 	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
 	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
+	{ "VYUY8_2X8", V4L2_MBUS_FMT_VYUY8_2X8 },
 	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
 	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
 	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
-- 
1.7.9.5

