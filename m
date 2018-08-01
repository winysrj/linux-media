Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:56819 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbeHAXIr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Aug 2018 19:08:47 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH 2/2] media: v4l2-common: simplify v4l2_i2c_subdev_init name generation
Date: Wed,  1 Aug 2018 23:20:57 +0200
Message-Id: <1533158457-15831-2-git-send-email-phdm@macqel.be>
In-Reply-To: <1533158457-15831-1-git-send-email-phdm@macqel.be>
References: <1533158457-15831-1-git-send-email-phdm@macqel.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When v4l2_i2c_subdev_init is called, dev_name(&client->dev) has already
been set.  Use it to generate subdev's name instead of recreating it
with "%d-%04x".  This improves the similarity in subdev's name creation
between v4l2_i2c_subdev_init and v4l2_spi_subdev_init.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 drivers/media/v4l2-core/v4l2-common.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 5471c6d..b062111 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -121,9 +121,8 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 	v4l2_set_subdevdata(sd, client);
 	i2c_set_clientdata(client, sd);
 	/* initialize name */
-	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
-		client->dev.driver->name, i2c_adapter_id(client->adapter),
-		client->addr);
+	snprintf(sd->name, sizeof(sd->name), "%s %s",
+		client->dev.driver->name, dev_name(&client->dev));
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
-- 
1.8.4
