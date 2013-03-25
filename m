Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611Ab3CYSme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 14:42:34 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] [REGRESSION] bt8xx: Fix too large height in cropcap
Date: Mon, 25 Mar 2013 19:45:54 +0100
Message-Id: <1364237154-2124-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit a1fd287780c8e91fed4957b30c757b0c93021162:
"[media] bttv-driver: fix two warnings"

cropcap.defrect.height and cropcap.bounds.height for the PAL entry are 32
resp 30 pixels too large, if a userspace app (ie xawtv) actually tries to use
the full advertised height, the resulting image is broken in ways only a
screenshot can describe.

The cause of this is the fix for this warning:
drivers/media/pci/bt8xx/bttv-driver.c:308:3: warning: initialized field overwritten [-Woverride-init]

In this chunk of the commit:
@@ -301,11 +301,10 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
                        /* totalwidth */ 1135,
                        /* sqwidth */ 944,
                        /* vdelay */ 0x20,
-                       /* sheight */ 576,
-                       /* videostart0 */ 23)
                /* bt878 (and bt848?) can capture another
                   line below active video. */
-               .cropcap.bounds.height = (576 + 2) + 0x20 - 2,
+                       /* sheight */ (576 + 2) + 0x20 - 2,
+                       /* videostart0 */ 23)
        },{
                .v4l2_id        = V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_KR,
                .name           = "NTSC",

Which replaces the overriding of cropcap.bounds.height initialization outside
of the CROPCAP macro (which also initializes it), with passing a
different sheight value to the CROPCAP macro.

There are 2 problems with this warning fix:
1) The sheight value is used twice in the CROPCAP macro, and the old code
   only changed one resulting value.

2) The old code increased the .cropcap.bounds.height value (and did not
   touch the .cropcap.defrect.height value at all) by 2, where as the fixed
   code increases it by 32, as the fixed code passes (576 + 2) + 0x20 - 2
   to the CROPCAP macro, but the + 0x20 - 2 is already done by the macro so
   now is done twice for .cropcap.bounds.height, and also is applied to
   .cropcap.defrect.height where it should not be applied at all.

This patch fixes this by adding an extraheight parameter to the CROPCAP entry
and using it for the PAL entry.

This is a regression introduced in 3.8 and this fix should be backported to
kernels back to 3.8.x.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/media/pci/bt8xx/bttv-driver.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index e33a2d2..e7d0884 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -263,17 +263,19 @@ static u8 SRAM_Table[][60] =
    vdelay	start of active video in 2 * field lines relative to
 		trailing edge of /VRESET pulse (VDELAY register).
    sheight	height of active video in 2 * field lines.
+   extraheight	Added to sheight for cropcap.bounds.height only
    videostart0	ITU-R frame line number of the line corresponding
 		to vdelay in the first field. */
 #define CROPCAP(minhdelayx1, hdelayx1, swidth, totalwidth, sqwidth,	 \
-		vdelay, sheight, videostart0)				 \
+		vdelay, sheight, extraheight, videostart0)		 \
 	.cropcap.bounds.left = minhdelayx1,				 \
 	/* * 2 because vertically we count field lines times two, */	 \
 	/* e.g. 23 * 2 to 23 * 2 + 576 in PAL-BGHI defrect. */		 \
 	.cropcap.bounds.top = (videostart0) * 2 - (vdelay) + MIN_VDELAY, \
 	/* 4 is a safety margin at the end of the line. */		 \
 	.cropcap.bounds.width = (totalwidth) - (minhdelayx1) - 4,	 \
-	.cropcap.bounds.height = (sheight) + (vdelay) - MIN_VDELAY,	 \
+	.cropcap.bounds.height = (sheight) + (extraheight) + (vdelay) -	 \
+				 MIN_VDELAY,				 \
 	.cropcap.defrect.left = hdelayx1,				 \
 	.cropcap.defrect.top = (videostart0) * 2,			 \
 	.cropcap.defrect.width = swidth,				 \
@@ -314,9 +316,10 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* totalwidth */ 1135,
 			/* sqwidth */ 944,
 			/* vdelay */ 0x20,
-		/* bt878 (and bt848?) can capture another
-		   line below active video. */
-			/* sheight */ (576 + 2) + 0x20 - 2,
+			/* sheight */ 576,
+			/* bt878 (and bt848?) can capture another
+			   line below active video. */
+			/* extraheight */ 2,
 			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_NTSC_M | V4L2_STD_NTSC_M_KR,
@@ -343,6 +346,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 780,
 			/* vdelay */ 0x1a,
 			/* sheight */ 480,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_SECAM,
@@ -368,6 +372,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 944,
 			/* vdelay */ 0x20,
 			/* sheight */ 576,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_PAL_Nc,
@@ -393,6 +398,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 780,
 			/* vdelay */ 0x1a,
 			/* sheight */ 576,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_PAL_M,
@@ -418,6 +424,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 780,
 			/* vdelay */ 0x1a,
 			/* sheight */ 480,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_PAL_N,
@@ -443,6 +450,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 944,
 			/* vdelay */ 0x20,
 			/* sheight */ 576,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	},{
 		.v4l2_id        = V4L2_STD_NTSC_M_JP,
@@ -468,6 +476,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 780,
 			/* vdelay */ 0x16,
 			/* sheight */ 480,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	},{
 		/* that one hopefully works with the strange timing
@@ -497,6 +506,7 @@ const struct bttv_tvnorm bttv_tvnorms[] = {
 			/* sqwidth */ 944,
 			/* vdelay */ 0x1a,
 			/* sheight */ 480,
+			/* extraheight */ 0,
 			/* videostart0 */ 23)
 	}
 };
-- 
1.8.1.4

