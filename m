Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab1KDRXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 13:23:41 -0400
Received: by wwi36 with SMTP id 36so3804045wwi.1
        for <linux-media@vger.kernel.org>; Fri, 04 Nov 2011 10:23:39 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH 1/1] [media] tvp5150: Delete video standard magic numbers
Date: Fri,  4 Nov 2011 18:23:21 +0100
Message-Id: <1320427401-5444-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit:
64933337e3cb61ca555969a35ab68b477db34ee2
[media] tvp5150: Add video format registers configuration values

Added constants for each video standard supported by TVP5150, so this patch
get rid of the magic numbers.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/media/video/tvp5150.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index e927d25..2a10b03 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -702,21 +702,21 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	/* First tests should be against specific std */
 
 	if (std == V4L2_STD_ALL) {
-		fmt = 0;	/* Autodetect mode */
+		fmt = VIDEO_STD_AUTO_SWITCH_BIT;	/* Autodetect mode */
 	} else if (std & V4L2_STD_NTSC_443) {
-		fmt = 0xa;
+		fmt = VIDEO_STD_NTSC_4_43_BIT;
 	} else if (std & V4L2_STD_PAL_M) {
-		fmt = 0x6;
+		fmt = VIDEO_STD_PAL_M_BIT;
 	} else if (std & (V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
-		fmt = 0x8;
+		fmt = VIDEO_STD_PAL_COMBINATION_N_BIT;
 	} else {
 		/* Then, test against generic ones */
 		if (std & V4L2_STD_NTSC)
-			fmt = 0x2;
+			fmt = VIDEO_STD_NTSC_MJ_BIT;
 		else if (std & V4L2_STD_PAL)
-			fmt = 0x4;
+			fmt = VIDEO_STD_PAL_BDGHIN_BIT;
 		else if (std & V4L2_STD_SECAM)
-			fmt = 0xc;
+			fmt = VIDEO_STD_SECAM_BIT;
 	}
 
 	v4l2_dbg(1, debug, sd, "Set video std register to %d.\n", fmt);
-- 
1.7.4.1

