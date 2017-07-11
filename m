Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46935 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755370AbdGKRUJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 13:20:09 -0400
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: fbtft: make const array gamma_par_mask static
Date: Tue, 11 Jul 2017 18:20:02 +0100
Message-Id: <20170711172002.19757-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate array gamma_par_mask on the stack but instead make it
static.  Makes the object code smaller by 148 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
   2993	   1104	      0	   4097	   1001	drivers/staging/fbtft/fb_st7789v.o

After:
   text	   data	    bss	    dec	    hex	filename
   2757	   1192	      0	   3949	    f6d	drivers/staging/fbtft/fb_st7789v.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/gspca/xirlink_cit.c | 2 +-
 drivers/staging/fbtft/fb_st7789v.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
index b600ea6460d3..68656e7986c7 100644
--- a/drivers/media/usb/gspca/xirlink_cit.c
+++ b/drivers/media/usb/gspca/xirlink_cit.c
@@ -1315,7 +1315,7 @@ static int cit_set_sharpness(struct gspca_dev *gspca_dev, s32 val)
 		break;
 	case CIT_MODEL1: {
 		int i;
-		const unsigned short sa[] = {
+		static const unsigned short sa[] = {
 			0x11, 0x13, 0x16, 0x18, 0x1a, 0x8, 0x0a };
 
 		for (i = 0; i < cit_model1_ntries; i++)
diff --git a/drivers/staging/fbtft/fb_st7789v.c b/drivers/staging/fbtft/fb_st7789v.c
index 8935a97ec048..a5d7c87557f8 100644
--- a/drivers/staging/fbtft/fb_st7789v.c
+++ b/drivers/staging/fbtft/fb_st7789v.c
@@ -189,7 +189,7 @@ static int set_gamma(struct fbtft_par *par, u32 *curves)
 	 * The masks are the same for both positive and negative voltage
 	 * gamma curves.
 	 */
-	const u8 gamma_par_mask[] = {
+	static const u8 gamma_par_mask[] = {
 		0xFF, /* V63[3:0], V0[3:0]*/
 		0x3F, /* V1[5:0] */
 		0x3F, /* V2[5:0] */
-- 
2.11.0
