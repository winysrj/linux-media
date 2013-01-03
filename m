Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:48990 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3ACNX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 08:23:58 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] tvp514x: use devm_kzalloc() instead of kzalloc()
Date: Thu,  3 Jan 2013 18:52:41 +0530
Message-Id: <1357219362-9080-3-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
References: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/i2c/tvp514x.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index d5e1021..53608ee 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -951,7 +951,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
 
@@ -995,11 +995,8 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
 	sd->ctrl_handler = &decoder->hdl;
 	if (decoder->hdl.error) {
-		int err = decoder->hdl.error;
-
 		v4l2_ctrl_handler_free(&decoder->hdl);
-		kfree(decoder);
-		return err;
+		return decoder->hdl.error;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
 
@@ -1023,7 +1020,6 @@ static int tvp514x_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
-	kfree(decoder);
 	return 0;
 }
 /* TVP5146 Init/Power on Sequence */
-- 
1.7.4.1

