Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4284 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3BZRgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:36:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/11] s2255: choose YUYV as the default format, not YUV422P
Date: Tue, 26 Feb 2013 18:35:45 +0100
Message-Id: <91ff1aab015104db73d985d7f699bc1c2e12c66e.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The planar YUV422P is quite unusual and few if any applications support it.
Instead choose the common YUYV format as the default.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 59d40e6..cd06f3c 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -416,11 +416,6 @@ MODULE_DEVICE_TABLE(usb, s2255_table);
 /* JPEG formats must be defined last to support jpeg_enable parameter */
 static const struct s2255_fmt formats[] = {
 	{
-		.name = "4:2:2, planar, YUV422P",
-		.fourcc = V4L2_PIX_FMT_YUV422P,
-		.depth = 16
-
-	}, {
 		.name = "4:2:2, packed, YUYV",
 		.fourcc = V4L2_PIX_FMT_YUYV,
 		.depth = 16
@@ -430,6 +425,11 @@ static const struct s2255_fmt formats[] = {
 		.fourcc = V4L2_PIX_FMT_UYVY,
 		.depth = 16
 	}, {
+		.name = "4:2:2, planar, YUV422P",
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.depth = 16
+
+	}, {
 		.name = "8bpp GREY",
 		.fourcc = V4L2_PIX_FMT_GREY,
 		.depth = 8
-- 
1.7.10.4

