Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:17024 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755620AbcH2R4I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 13:56:08 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 02/13] media: mt9m111: use only the SRGB colorspace
Date: Mon, 29 Aug 2016 19:55:47 +0200
Message-Id: <1472493358-24618-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
References: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mt9m111 being a camera sensor, its colorspace should always be SRGB, for
both RGB based formats or YCbCr based ones.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/i2c/soc_camera/mt9m111.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index a7efaa5964d1..b7c4f371bae1 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -188,10 +188,10 @@ struct mt9m111_datafmt {
 };
 
 static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
-	{MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
-	{MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
-	{MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG},
-	{MEDIA_BUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_JPEG},
+	{MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB},
+	{MEDIA_BUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_SRGB},
 	{MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 	{MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE, V4L2_COLORSPACE_SRGB},
 	{MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
-- 
2.1.4

