Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40955 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754457AbeDBWY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 18:24:57 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] media: i2c: tvp5150: Use the correct comment style
Date: Tue,  3 Apr 2018 02:53:18 +0430
Message-Id: <20180402222322.30385-3-Afshin.Nasser@gmail.com>
In-Reply-To: <20180402222322.30385-1-Afshin.Nasser@gmail.com>
References: <d5e8dbe4-b68b-ac4e-0076-a3ee995f8327@embeddedor.com>
 <20180402222322.30385-1-Afshin.Nasser@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch resolves checkpatch.pl warnings:
    WARNING: Block comments use * on subsequent lines
    WARNING: Block comments use a trailing */ on a separate line

Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
---
 drivers/media/i2c/tvp5150.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index af56a5a6db65..fd23138cc6a3 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -502,8 +502,10 @@ struct i2c_vbi_ram_value {
 
 static struct i2c_vbi_ram_value vbi_ram_default[] =
 {
-	/* FIXME: Current api doesn't handle all VBI types, those not
-	   yet supported are placed under #if 0 */
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
