Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56814 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbbCIVYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:24:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 16/18] ov7670: use colorspace SRGB instead of JPEG
Date: Mon,  9 Mar 2015 22:22:21 +0100
Message-Id: <1425936143-5658-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Even though the format is Y'CbCr, the colorspace used by the sensor
is almost certainly SRGB. The sensor is also not generating JPEG data,
so it makes no sense to use V4L2_COLORSPACE_JPEG here.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 81a1e44..504472b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -639,7 +639,7 @@ static struct ov7670_format_struct {
 } ov7670_formats[] = {
 	{
 		.mbus_code	= MEDIA_BUS_FMT_YUYV8_2X8,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.colorspace	= V4L2_COLORSPACE_SRGB,
 		.regs 		= ov7670_fmt_yuv422,
 		.cmatrix	= { 128, -128, 0, -34, -94, 128 },
 	},
-- 
2.1.4

