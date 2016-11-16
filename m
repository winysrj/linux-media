Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49727 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932177AbcKPQnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:17 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 33/35] [media] tvp5150: get rid of KERN_CONT
Date: Wed, 16 Nov 2016 14:43:05 -0200
Message-Id: <4923c7bd264909449749681f20f315231c9483e0.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately, KERN_CONT doesn't work with dev_foo(),
producing weird messages like:

	tvp5150 6-005c: tvp5150: read 0xf6 = 0xff
	ff

So, we need to get rid of it.

As we're always printing read/write in hexa when dumping
multiple register values, also remove the "0x" from the
read/write debug messages too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvp5150.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index d0dbdd7ea233..6737685d5be5 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -102,20 +102,22 @@ static int tvp5150_write(struct v4l2_subdev *sd, unsigned char addr,
 static void dump_reg_range(struct v4l2_subdev *sd, char *s, u8 init,
 				const u8 end, int max_line)
 {
-	int i = 0;
-
-	while (init != (u8)(end + 1)) {
-		if ((i % max_line) == 0) {
-			if (i > 0)
-				printk("\n");
-			printk("tvp5150: %s reg 0x%02x = ", s, init);
-		}
-		printk("%02x ", tvp5150_read(sd, init));
-
-		init++;
-		i++;
+	u8 buf[16];
+	int i = 0, j, len;
+
+	if (max_line > 16) {
+		dprintk0(sd->dev, "too much data to dump\n");
+		return;
+	}
+
+	for (i = init; i < end; i += max_line) {
+		len = (end - i > max_line) ? max_line : end - i;
+
+		for (j = 0; j < len; j++)
+			buf[j] = tvp5150_read(sd, i + j);
+
+		dprintk0(sd->dev, "%s reg %02x = %*ph\n", s, i, len, buf);
 	}
-	printk("\n");
 }
 
 static int tvp5150_log_status(struct v4l2_subdev *sd)
-- 
2.7.4


