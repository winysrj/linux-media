Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:43242 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932400AbeDBUAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 16:00:37 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
To: mchehab@kernel.org
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] media: i2c: tvp5150: Use the correct comment style
Date: Tue,  3 Apr 2018 00:29:04 +0430
Message-Id: <20180402195907.14368-3-Afshin.Nasser@gmail.com>
In-Reply-To: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
References: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch resolves some checkpatch.pl warnings about comments.

Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
---
 drivers/media/i2c/tvp5150.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index af56a5a6db65..d561d87d219a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -500,10 +500,12 @@ struct i2c_vbi_ram_value {
  * and so on. There are 16 possible locations from 0 to 15.
  */
 
-static struct i2c_vbi_ram_value vbi_ram_default[] =
-{
-	/* FIXME: Current api doesn't handle all VBI types, those not
-	   yet supported are placed under #if 0 */
+static struct i2c_vbi_ram_value vbi_ram_default[] = {
+
+	/*
+	 * FIXME: Current api doesn't handle all VBI types, those not
+	 * yet supported are placed under #if 0
+	 */
 #if 0
 	[0] = {0x010, /* Teletext, SECAM, WST System A */
 		{V4L2_SLICED_TELETEXT_SECAM, 6, 23, 1},
@@ -1101,11 +1103,14 @@ static int tvp5150_s_routing(struct v4l2_subdev *sd,
 
 static int tvp5150_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt)
 {
-	/* this is for capturing 36 raw vbi lines
-	   if there's a way to cut off the beginning 2 vbi lines
-	   with the tvp5150 then the vbi line count could be lowered
-	   to 17 lines/field again, although I couldn't find a register
-	   which could do that cropping */
+	/*
+	 * this is for capturing 36 raw vbi lines
+	 * if there's a way to cut off the beginning 2 vbi lines
+	 * with the tvp5150 then the vbi line count could be lowered
+	 * to 17 lines/field again, although I couldn't find a register
+	 * which could do that cropping
+	 */
+
 	if (fmt->sample_format == V4L2_PIX_FMT_GREY)
 		tvp5150_write(sd, TVP5150_LUMA_PROC_CTL_1, 0x70);
 	if (fmt->count[0] == 18 && fmt->count[1] == 18) {
-- 
2.15.0
