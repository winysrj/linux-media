Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39892 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdILLIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 07:08:17 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] gspca: make arrays static, reduces object code size
Date: Tue, 12 Sep 2017 12:08:13 +0100
Message-Id: <20170912110813.883-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack, instead make them
static.  Makes the object code smaller by over 5200 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  58259	   8880	    128	  67267	  106c3	ov519.o

After:
   text	   data	    bss	    dec	    hex	filename
  52155	   9776	    128	  62059	   f26b	ov519.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/gspca/ov519.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index cdb79c5f0c38..f1537daf4e2e 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2865,7 +2865,7 @@ static void sd_reset_snapshot(struct gspca_dev *gspca_dev)
 
 static void ov51x_upload_quan_tables(struct sd *sd)
 {
-	const unsigned char yQuanTable511[] = {
+	static const unsigned char yQuanTable511[] = {
 		0, 1, 1, 2, 2, 3, 3, 4,
 		1, 1, 1, 2, 2, 3, 4, 4,
 		1, 1, 2, 2, 3, 4, 4, 4,
@@ -2876,7 +2876,7 @@ static void ov51x_upload_quan_tables(struct sd *sd)
 		4, 4, 4, 4, 5, 5, 5, 5
 	};
 
-	const unsigned char uvQuanTable511[] = {
+	static const unsigned char uvQuanTable511[] = {
 		0, 2, 2, 3, 4, 4, 4, 4,
 		2, 2, 2, 4, 4, 4, 4, 4,
 		2, 2, 3, 4, 4, 4, 4, 4,
@@ -2888,13 +2888,13 @@ static void ov51x_upload_quan_tables(struct sd *sd)
 	};
 
 	/* OV518 quantization tables are 8x4 (instead of 8x8) */
-	const unsigned char yQuanTable518[] = {
+	static const unsigned char yQuanTable518[] = {
 		5, 4, 5, 6, 6, 7, 7, 7,
 		5, 5, 5, 5, 6, 7, 7, 7,
 		6, 6, 6, 6, 7, 7, 7, 8,
 		7, 7, 6, 7, 7, 7, 8, 8
 	};
-	const unsigned char uvQuanTable518[] = {
+	static const unsigned char uvQuanTable518[] = {
 		6, 6, 6, 7, 7, 7, 7, 7,
 		6, 6, 6, 7, 7, 7, 7, 7,
 		6, 6, 6, 7, 7, 7, 7, 8,
@@ -2943,7 +2943,7 @@ static void ov511_configure(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	/* For 511 and 511+ */
-	const struct ov_regvals init_511[] = {
+	static const struct ov_regvals init_511[] = {
 		{ R51x_SYS_RESET,	0x7f },
 		{ R51x_SYS_INIT,	0x01 },
 		{ R51x_SYS_RESET,	0x7f },
@@ -2953,7 +2953,7 @@ static void ov511_configure(struct gspca_dev *gspca_dev)
 		{ R51x_SYS_RESET,	0x3d },
 	};
 
-	const struct ov_regvals norm_511[] = {
+	static const struct ov_regvals norm_511[] = {
 		{ R511_DRAM_FLOW_CTL,	0x01 },
 		{ R51x_SYS_SNAP,	0x00 },
 		{ R51x_SYS_SNAP,	0x02 },
@@ -2963,7 +2963,7 @@ static void ov511_configure(struct gspca_dev *gspca_dev)
 		{ R511_COMP_LUT_EN,	0x03 },
 	};
 
-	const struct ov_regvals norm_511_p[] = {
+	static const struct ov_regvals norm_511_p[] = {
 		{ R511_DRAM_FLOW_CTL,	0xff },
 		{ R51x_SYS_SNAP,	0x00 },
 		{ R51x_SYS_SNAP,	0x02 },
@@ -2973,7 +2973,7 @@ static void ov511_configure(struct gspca_dev *gspca_dev)
 		{ R511_COMP_LUT_EN,	0x03 },
 	};
 
-	const struct ov_regvals compress_511[] = {
+	static const struct ov_regvals compress_511[] = {
 		{ 0x70, 0x1f },
 		{ 0x71, 0x05 },
 		{ 0x72, 0x06 },
@@ -3009,7 +3009,7 @@ static void ov518_configure(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	/* For 518 and 518+ */
-	const struct ov_regvals init_518[] = {
+	static const struct ov_regvals init_518[] = {
 		{ R51x_SYS_RESET,	0x40 },
 		{ R51x_SYS_INIT,	0xe1 },
 		{ R51x_SYS_RESET,	0x3e },
@@ -3020,7 +3020,7 @@ static void ov518_configure(struct gspca_dev *gspca_dev)
 		{ 0x5d,			0x03 },
 	};
 
-	const struct ov_regvals norm_518[] = {
+	static const struct ov_regvals norm_518[] = {
 		{ R51x_SYS_SNAP,	0x02 }, /* Reset */
 		{ R51x_SYS_SNAP,	0x01 }, /* Enable */
 		{ 0x31,			0x0f },
@@ -3033,7 +3033,7 @@ static void ov518_configure(struct gspca_dev *gspca_dev)
 		{ 0x2f,			0x80 },
 	};
 
-	const struct ov_regvals norm_518_p[] = {
+	static const struct ov_regvals norm_518_p[] = {
 		{ R51x_SYS_SNAP,	0x02 }, /* Reset */
 		{ R51x_SYS_SNAP,	0x01 }, /* Enable */
 		{ 0x31,			0x0f },
-- 
2.14.1
