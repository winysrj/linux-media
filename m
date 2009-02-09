Return-path: <linux-media-owner@vger.kernel.org>
Received: from symlink.to.noone.org ([85.10.207.172]:58281 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZBIV1W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 16:27:22 -0500
Date: Mon, 9 Feb 2009 22:06:49 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	video4linux-list@redhat.com, kernel-janitors@vger.kernel.org,
	trivial@kernel.org
Subject: [PATCH] V4L: Storage class should be before const qualifier
Message-ID: <20090209210649.GA7378@xenon.distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/media/video/gspca/t613.c |    2 +-
 drivers/media/video/tcm825x.c    |   22 +++++++++++-----------
 drivers/media/video/tcm825x.h    |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/gspca/t613.c b/drivers/media/video/gspca/t613.c
index 6ee111a..8b8c029 100644
--- a/drivers/media/video/gspca/t613.c
+++ b/drivers/media/video/gspca/t613.c
@@ -271,7 +271,7 @@ struct additional_sensor_data {
 	const __u8 stream[4];
 };
 
-const static struct additional_sensor_data sensor_data[] = {
+static const struct additional_sensor_data sensor_data[] = {
     {				/* TAS5130A */
 	.data1 =
 		{0xd0, 0xbb, 0xd1, 0x28, 0xd2, 0x10, 0xd3, 0x10,
diff --git a/drivers/media/video/tcm825x.c b/drivers/media/video/tcm825x.c
index 29991d1..b30c492 100644
--- a/drivers/media/video/tcm825x.c
+++ b/drivers/media/video/tcm825x.c
@@ -50,7 +50,7 @@ struct tcm825x_sensor {
 };
 
 /* list of image formats supported by TCM825X sensor */
-const static struct v4l2_fmtdesc tcm825x_formats[] = {
+static const struct v4l2_fmtdesc tcm825x_formats[] = {
 	{
 		.description = "YUYV (YUV 4:2:2), packed",
 		.pixelformat = V4L2_PIX_FMT_UYVY,
@@ -76,15 +76,15 @@ const static struct v4l2_fmtdesc tcm825x_formats[] = {
  * TCM825X register configuration for all combinations of pixel format and
  * image size
  */
-const static struct tcm825x_reg subqcif	=	{ 0x20, TCM825X_PICSIZ };
-const static struct tcm825x_reg qcif	=	{ 0x18, TCM825X_PICSIZ };
-const static struct tcm825x_reg cif	=	{ 0x14, TCM825X_PICSIZ };
-const static struct tcm825x_reg qqvga	=	{ 0x0c, TCM825X_PICSIZ };
-const static struct tcm825x_reg qvga	=	{ 0x04, TCM825X_PICSIZ };
-const static struct tcm825x_reg vga	=	{ 0x00, TCM825X_PICSIZ };
+static const struct tcm825x_reg subqcif	=	{ 0x20, TCM825X_PICSIZ };
+static const struct tcm825x_reg qcif	=	{ 0x18, TCM825X_PICSIZ };
+static const struct tcm825x_reg cif	=	{ 0x14, TCM825X_PICSIZ };
+static const struct tcm825x_reg qqvga	=	{ 0x0c, TCM825X_PICSIZ };
+static const struct tcm825x_reg qvga	=	{ 0x04, TCM825X_PICSIZ };
+static const struct tcm825x_reg vga	=	{ 0x00, TCM825X_PICSIZ };
 
-const static struct tcm825x_reg yuv422	=	{ 0x00, TCM825X_PICFMT };
-const static struct tcm825x_reg rgb565	=	{ 0x02, TCM825X_PICFMT };
+static const struct tcm825x_reg yuv422	=	{ 0x00, TCM825X_PICFMT };
+static const struct tcm825x_reg rgb565	=	{ 0x02, TCM825X_PICFMT };
 
 /* Our own specific controls */
 #define V4L2_CID_ALC				V4L2_CID_PRIVATE_BASE
@@ -248,10 +248,10 @@ static struct vcontrol {
 };
 
 
-const static struct tcm825x_reg *tcm825x_siz_reg[NUM_IMAGE_SIZES] =
+static const struct tcm825x_reg *tcm825x_siz_reg[NUM_IMAGE_SIZES] =
 { &subqcif, &qqvga, &qcif, &qvga, &cif, &vga };
 
-const static struct tcm825x_reg *tcm825x_fmt_reg[NUM_PIXEL_FORMATS] =
+static const struct tcm825x_reg *tcm825x_fmt_reg[NUM_PIXEL_FORMATS] =
 { &yuv422, &rgb565 };
 
 /*
diff --git a/drivers/media/video/tcm825x.h b/drivers/media/video/tcm825x.h
index 770ebac..5b7e696 100644
--- a/drivers/media/video/tcm825x.h
+++ b/drivers/media/video/tcm825x.h
@@ -188,7 +188,7 @@ struct tcm825x_platform_data {
 /* Array of image sizes supported by TCM825X.  These must be ordered from
  * smallest image size to largest.
  */
-const static struct capture_size tcm825x_sizes[] = {
+static const struct capture_size tcm825x_sizes[] = {
 	{ 128,  96 }, /* subQCIF */
 	{ 160, 120 }, /* QQVGA */
 	{ 176, 144 }, /* QCIF */
-- 
1.5.6.5

