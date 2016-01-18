Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41497 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbcARQSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:18:36 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1501FT3PAXRO10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:18:34 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 07/15] mediactl: libv4l2subdev: add VYUY8_2X8 mbus code
Date: Mon, 18 Jan 2016 17:17:32 +0100
Message-id: <1453133860-21571-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
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
index 069ded6..5175188 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -780,6 +780,7 @@ static struct {
 	{ "YUYV", MEDIA_BUS_FMT_YUYV8_1X16 },
 	{ "YUYV1_5X8", MEDIA_BUS_FMT_YUYV8_1_5X8 },
 	{ "YUYV2X8", MEDIA_BUS_FMT_YUYV8_2X8 },
+	{ "VYUY8_2X8", V4L2_MBUS_FMT_VYUY8_2X8 },
 	{ "UYVY", MEDIA_BUS_FMT_UYVY8_1X16 },
 	{ "UYVY1_5X8", MEDIA_BUS_FMT_UYVY8_1_5X8 },
 	{ "UYVY2X8", MEDIA_BUS_FMT_UYVY8_2X8 },
-- 
1.7.9.5

