Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761105Ab0J0Mbl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:41 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5/7] gspca_xirlink_cit: Frames have a 4 byte footer
Date: Wed, 27 Oct 2010 14:35:24 +0200
Message-Id: <1288182926-25400-6-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Atleast on the ibm netcam pro frames have a 4 byte footer, take this
into account when calculating sizeimage.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/xirlink_cit.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/gspca/xirlink_cit.c b/drivers/media/video/gspca/xirlink_cit.c
index f0f6279..ea73377 100644
--- a/drivers/media/video/gspca/xirlink_cit.c
+++ b/drivers/media/video/gspca/xirlink_cit.c
@@ -185,60 +185,60 @@ static const struct ctrl sd_ctrls[] = {
 static const struct v4l2_pix_format cif_yuv_mode[] = {
 	{176, 144, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 176,
-		.sizeimage = 176 * 144 * 3 / 2,
+		.sizeimage = 176 * 144 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{352, 288, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 352,
-		.sizeimage = 352 * 288 * 3 / 2,
+		.sizeimage = 352 * 288 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 };
 
 static const struct v4l2_pix_format vga_yuv_mode[] = {
 	{160, 120, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 160,
-		.sizeimage = 160 * 120 * 3 / 2,
+		.sizeimage = 160 * 120 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{320, 240, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 320,
-		.sizeimage = 320 * 240 * 3 / 2,
+		.sizeimage = 320 * 240 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{640, 480, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 640,
-		.sizeimage = 640 * 480 * 3 / 2,
+		.sizeimage = 640 * 480 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 };
 
 static const struct v4l2_pix_format model0_mode[] = {
 	{160, 120, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 160,
-		.sizeimage = 160 * 120 * 3 / 2,
+		.sizeimage = 160 * 120 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{176, 144, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 176,
-		.sizeimage = 176 * 144 * 3 / 2,
+		.sizeimage = 176 * 144 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{320, 240, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 320,
-		.sizeimage = 320 * 240 * 3 / 2,
+		.sizeimage = 320 * 240 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 };
 
 static const struct v4l2_pix_format model2_mode[] = {
 	{160, 120, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 160,
-		.sizeimage = 160 * 120 * 3 / 2,
+		.sizeimage = 160 * 120 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{176, 144, V4L2_PIX_FMT_CIT_YYVYUY, V4L2_FIELD_NONE,
 		.bytesperline = 176,
-		.sizeimage = 176 * 144 * 3 / 2,
+		.sizeimage = 176 * 144 * 3 / 2 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{320, 240, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
 		.bytesperline = 320,
-		.sizeimage = 320 * 240,
+		.sizeimage = 320 * 240 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 	{352, 288, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
 		.bytesperline = 352,
-		.sizeimage = 352 * 288,
+		.sizeimage = 352 * 288 + 4,
 		.colorspace = V4L2_COLORSPACE_SRGB},
 };
 
-- 
1.7.3.1

