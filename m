Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4693 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3HSOor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 09/20] ad9389b: change initial register configuration in ad9389b_setup()
Date: Mon, 19 Aug 2013 16:44:18 +0200
Message-Id: <1376923469-30694-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

- register 0x17: CSC scaling factor was set to +/- 2.0. This register
  is set by ad9389b_csc_conversion_mode() to the right value.
- register 0x3b: bits for pixel repetition and CSC was set to zero,
  but that is the default value.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index d78fd3d..92cdb25 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -894,11 +894,9 @@ static void ad9389b_setup(struct v4l2_subdev *sd)
 	ad9389b_wr_and_or(sd, 0x15, 0xf1, 0x0);
 	/* Output format: RGB 4:4:4 */
 	ad9389b_wr_and_or(sd, 0x16, 0x3f, 0x0);
-	/* CSC fixed point: +/-2, 1st order interpolation 4:2:2 -> 4:4:4 up
-	   conversion, Aspect ratio: 16:9 */
-	ad9389b_wr_and_or(sd, 0x17, 0xe1, 0x0e);
-	/* Disable pixel repetition and CSC */
-	ad9389b_wr_and_or(sd, 0x3b, 0x9e, 0x0);
+	/* 1st order interpolation 4:2:2 -> 4:4:4 up conversion,
+	   Aspect ratio: 16:9 */
+	ad9389b_wr_and_or(sd, 0x17, 0xf9, 0x06);
 	/* Output format: RGB 4:4:4, Active Format Information is valid. */
 	ad9389b_wr_and_or(sd, 0x45, 0xc7, 0x08);
 	/* Underscanned */
-- 
1.8.3.2

