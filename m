Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33775 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbbFOLeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/14] mt9t112: JPEG -> SRGB
Date: Mon, 15 Jun 2015 13:33:33 +0200
Message-Id: <1434368021-7467-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The JPEG colorspace should only be used for JPEG encoded images. This is
just a regular sRGB sensor.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/mt9t112.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index de10a76..2f35d31 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -104,22 +104,22 @@ struct mt9t112_priv {
 static const struct mt9t112_format mt9t112_cfmts[] = {
 	{
 		.code		= MEDIA_BUS_FMT_UYVY8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.fmt		= 1,
 		.order		= 0,
 	}, {
 		.code		= MEDIA_BUS_FMT_VYUY8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.fmt		= 1,
 		.order		= 1,
 	}, {
 		.code		= MEDIA_BUS_FMT_YUYV8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.fmt		= 1,
 		.order		= 2,
 	}, {
 		.code		= MEDIA_BUS_FMT_YVYU8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.fmt		= 1,
 		.order		= 3,
 	}, {
-- 
2.1.4

