Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1027 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3FOOtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jun 2013 10:49:31 -0400
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] [media] tvp514x: Fix init seqeunce
Date: Sat, 15 Jun 2013 16:34:36 +0200
Message-Id: <1371306876-8596-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

client->driver->id_table will always point to the first entry in the device id
table. So all devices will use the same init sequence. Use the id table entry
that gets passed to the driver's probe() function to get the right init
sequence.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/tvp514x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7438e01..8640d68 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -123,6 +123,8 @@ struct tvp514x_decoder {
 	/* mc related members */
 	struct media_pad pad;
 	struct v4l2_mbus_framefmt format;
+
+	struct tvp514x_reg *int_seq;
 };
 
 /* TVP514x default register values */
@@ -882,11 +884,8 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable)
 	}
 	case 1:
 	{
-		struct tvp514x_reg *int_seq = (struct tvp514x_reg *)
-				client->driver->id_table->driver_data;
-
 		/* Power Up Sequence */
-		err = tvp514x_write_regs(sd, int_seq);
+		err = tvp514x_write_regs(sd, decoder->int_seq);
 		if (err) {
 			v4l2_err(sd, "Unable to turn on decoder\n");
 			return err;
@@ -1089,6 +1088,8 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
 			sizeof(tvp514x_reg_list_default));
 
+	decoder->int_seq = id->driver_data;
+
 	/* Copy board specific information here */
 	decoder->pdata = client->dev.platform_data;
 
-- 
1.8.0

