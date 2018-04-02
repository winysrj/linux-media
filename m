Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43257 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932400AbeDBUAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 16:00:41 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
To: mchehab@kernel.org
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] media: i2c: tvp5150: Use parentheses for sizeof
Date: Tue,  3 Apr 2018 00:29:05 +0430
Message-Id: <20180402195907.14368-4-Afshin.Nasser@gmail.com>
In-Reply-To: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
References: <20180402195907.14368-1-Afshin.Nasser@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch resolves a checkpatch.pl warning

Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
---
 drivers/media/i2c/tvp5150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index d561d87d219a..d528fddbea16 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -625,7 +625,7 @@ static int tvp5150_g_sliced_vbi_cap(struct v4l2_subdev *sd,
 	int line, i;
 
 	dev_dbg_lvl(sd->dev, 1, debug, "g_sliced_vbi_cap\n");
-	memset(cap, 0, sizeof *cap);
+	memset(cap, 0, sizeof(*cap));
 
 	for (i = 0; i < ARRAY_SIZE(vbi_ram_default); i++) {
 		const struct i2c_vbi_ram_value *regs = &vbi_ram_default[i];
-- 
2.15.0
