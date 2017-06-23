Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.146.82]:34568 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752170AbdFWWhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 18:37:03 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 0A96D4D1442
        for <linux-media@vger.kernel.org>; Fri, 23 Jun 2017 17:37:01 -0500 (CDT)
Date: Fri, 23 Jun 2017 17:37:00 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] i2c: tvp5150: remove useless variable assignment in
 tvp5150_set_vbi()
Message-ID: <20170623223700.GA12476@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Value assigned to variable _type_ at line 678 is overwritten at line 688
before it can be used. This makes such variable assignment useless.

Remove this variable assignment and fix some coding style issues.

Addresses-Coverity-ID: 1226968
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/i2c/tvp5150.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 04e96b3..2fcd2e5 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -658,7 +658,7 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	v4l2_std_id std = decoder->norm;
 	u8 reg;
-	int pos=0;
+	int pos = 0;
 
 	if (std == V4L2_STD_ALL) {
 		dev_err(sd->dev, "VBI can't be configured without knowing number of lines\n");
@@ -668,33 +668,30 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
 		line += 3;
 	}
 
-	if (line<6||line>27)
+	if (line < 6 || line > 27)
 		return 0;
 
-	while (regs->reg != (u16)-1 ) {
+	while (regs->reg != (u16)-1) {
 		if ((type & regs->type.vbi_type) &&
-		    (line>=regs->type.ini_line) &&
-		    (line<=regs->type.end_line)) {
-			type=regs->type.vbi_type;
+		    (line >= regs->type.ini_line) &&
+		    (line <= regs->type.end_line))
 			break;
-		}
 
 		regs++;
 		pos++;
 	}
+
 	if (regs->reg == (u16)-1)
 		return 0;
 
-	type=pos | (flags & 0xf0);
-	reg=((line-6)<<1)+TVP5150_LINE_MODE_INI;
+	type = pos | (flags & 0xf0);
+	reg = ((line - 6) << 1) + TVP5150_LINE_MODE_INI;
 
-	if (fields&1) {
+	if (fields & 1)
 		tvp5150_write(sd, reg, type);
-	}
 
-	if (fields&2) {
-		tvp5150_write(sd, reg+1, type);
-	}
+	if (fields & 2)
+		tvp5150_write(sd, reg + 1, type);
 
 	return type;
 }
-- 
2.5.0
