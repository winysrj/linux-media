Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51050 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754628AbeDBWZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 18:25:06 -0400
From: Nasser Afshin <afshin.nasser@gmail.com>
Cc: Nasser Afshin <Afshin.Nasser@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] media: i2c: tvp5150: Use parentheses for sizeof
Date: Tue,  3 Apr 2018 02:53:20 +0430
Message-Id: <20180402222322.30385-5-Afshin.Nasser@gmail.com>
In-Reply-To: <20180402222322.30385-1-Afshin.Nasser@gmail.com>
References: <d5e8dbe4-b68b-ac4e-0076-a3ee995f8327@embeddedor.com>
 <20180402222322.30385-1-Afshin.Nasser@gmail.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch resolves a checkpatch.pl warning:
    WARNING: sizeof *cap should be sizeof(*cap)

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
