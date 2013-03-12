Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3CLM1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 08:27:17 -0400
Date: Tue, 12 Mar 2013 13:27:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] mt9m111: fix Oops - initialise context before dereferencing
Message-ID: <Pine.LNX.4.64.1303121326451.680@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent commit "[media] soc-camera: Push probe-time power management to
drivers" causes an Oops during mt9m111 driver probing because its .ctx
private data field is now dereferenced before it is initialised. Fix this
by initialising the field earlier.

Reported-by: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/mt9m111.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index ea874ce..cfdda50 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -784,8 +784,6 @@ static int mt9m111_init(struct mt9m111 *mt9m111)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
-	/* Default HIGHPOWER context */
-	mt9m111->ctx = &context_b;
 	ret = mt9m111_enable(mt9m111);
 	if (!ret)
 		ret = mt9m111_reset(mt9m111);
@@ -974,6 +972,9 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
+	/* Default HIGHPOWER context */
+	mt9m111->ctx = &context_b;
+
 	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
 	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
 	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
-- 
1.7.2.5

