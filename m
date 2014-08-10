Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34731 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaHJJlm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 05:41:42 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so9387315pad.8
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 02:41:41 -0700 (PDT)
Message-ID: <1407663691.6912.7.camel@phoenix>
Subject: [PATCH] [media] saa6752hs: Convert to devm_kzalloc()
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org
Date: Sun, 10 Aug 2014 17:41:31 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the managed function the kfree() calls can be removed from the
probe error path and the remove handler.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/saa6752hs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
index 04e9e55..4024ea6 100644
--- a/drivers/media/i2c/saa6752hs.c
+++ b/drivers/media/i2c/saa6752hs.c
@@ -660,7 +660,7 @@ static const struct v4l2_subdev_ops saa6752hs_ops = {
 static int saa6752hs_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
-	struct saa6752hs_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
+	struct saa6752hs_state *h;
 	struct v4l2_subdev *sd;
 	struct v4l2_ctrl_handler *hdl;
 	u8 addr = 0x13;
@@ -668,6 +668,8 @@ static int saa6752hs_probe(struct i2c_client *client,
 
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
+
+	h = devm_kzalloc(&client->dev, sizeof(*h), GFP_KERNEL);
 	if (h == NULL)
 		return -ENOMEM;
 	sd = &h->sd;
@@ -752,7 +754,6 @@ static int saa6752hs_probe(struct i2c_client *client,
 		int err = hdl->error;
 
 		v4l2_ctrl_handler_free(hdl);
-		kfree(h);
 		return err;
 	}
 	v4l2_ctrl_cluster(3, &h->video_bitrate_mode);
@@ -767,7 +768,6 @@ static int saa6752hs_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&to_state(sd)->hdl);
-	kfree(to_state(sd));
 	return 0;
 }
 
-- 
1.9.1



