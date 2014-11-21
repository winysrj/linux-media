Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31436 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaKUQPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:15:17 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFE003HYD5G7LB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sat, 22 Nov 2014 01:15:16 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 07/11] media-ctl: libv4l2subdev: add VYUY8_2X8 mbus code
Date: Fri, 21 Nov 2014 17:14:36 +0100
Message-id: <1416586480-19982-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
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
index 4c5fb12..a96ed7a 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -704,6 +704,7 @@ static struct {
 	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
 	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
 	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
+	{ "VYUY8_2X8", V4L2_MBUS_FMT_VYUY8_2X8 },
 	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
 	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
 	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
-- 
1.7.9.5

