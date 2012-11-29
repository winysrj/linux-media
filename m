Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45388 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2K2C4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 21:56:16 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so10395601qcr.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 18:56:15 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 28 Nov 2012 21:56:15 -0500
Message-ID: <CAPgLHd_6U7mMeU5r6Axc9WmpUhO1+fv5vnWXVau19zTC_qdz=g@mail.gmail.com>
Subject: [PATCH -next] [media] mt9v022: fix potential NULL pointer dereference
 in mt9v022_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: g.liakhovetski@gmx.de, mchehab@redhat.com, agust@denx.de
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'icl' should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/soc_camera/mt9v022.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index d40a885..7509802 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -875,7 +875,7 @@ static int mt9v022_probe(struct i2c_client *client,
 	struct mt9v022 *mt9v022;
 	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
-	struct mt9v022_platform_data *pdata = icl->priv;
+	struct mt9v022_platform_data *pdata;
 	int ret;
 
 	if (!icl) {
@@ -893,6 +893,7 @@ static int mt9v022_probe(struct i2c_client *client,
 	if (!mt9v022)
 		return -ENOMEM;
 
+	pdata = icl->priv;
 	v4l2_i2c_subdev_init(&mt9v022->subdev, client, &mt9v022_subdev_ops);
 	v4l2_ctrl_handler_init(&mt9v022->hdl, 6);
 	v4l2_ctrl_new_std(&mt9v022->hdl, &mt9v022_ctrl_ops,


