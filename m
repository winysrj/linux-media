Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcB2TSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 14:18:06 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Wesley Post <pa4wdh@xs4all.nl>, Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] gspca: Remove unused ovfx2_vga_mode/ovfx2_cif_mode arrays
Date: Mon, 29 Feb 2016 20:17:52 +0100
Message-Id: <1456773472-8334-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1456773472-8334-1-git-send-email-hdegoede@redhat.com>
References: <1456773472-8334-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the unused ovfx2_vga_mode/ovfx2_cif_mode arrays from the ov519
driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/ov519.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index eb668e7..965372a 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -360,40 +360,6 @@ static const struct v4l2_pix_format ov511_sif_mode[] = {
 		.priv = 0},
 };
 
-static const struct v4l2_pix_format ovfx2_vga_mode[] = {
-	{320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 320,
-		.sizeimage = 320 * 240,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 1},
-	{640, 480, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 640,
-		.sizeimage = 640 * 480,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 0},
-};
-static const struct v4l2_pix_format ovfx2_cif_mode[] = {
-	{160, 120, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 160,
-		.sizeimage = 160 * 120,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 3},
-	{176, 144, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 176,
-		.sizeimage = 176 * 144,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 1},
-	{320, 240, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 320,
-		.sizeimage = 320 * 240,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 2},
-	{352, 288, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
-		.bytesperline = 352,
-		.sizeimage = 352 * 288,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-		.priv = 0},
-};
 static const struct v4l2_pix_format ovfx2_ov2610_mode[] = {
 	{800, 600, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
 		.bytesperline = 800,
-- 
2.7.2

