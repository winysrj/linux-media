Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:46726 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbcHHTbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 15:31:22 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 02/14] media: mt9m111: prevent module removal while in use
Date: Mon,  8 Aug 2016 21:30:40 +0200
Message-Id: <1470684652-16295-3-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mt9m111 can be a removable module : the only case where the module
should be kept loaded is while it is used, ie. while an active
transation is ongoing on it.

The notion of active transaction is mapped on the power state of the
module : if powered on the removal is prohibited.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/i2c/soc_camera/mt9m111.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index a7efaa5964d1..ea5b5e709402 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -780,23 +780,33 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
 	struct i2c_client *client = v4l2_get_subdevdata(&mt9m111->subdev);
 	int ret;
 
+	if (!try_module_get(THIS_MODULE))
+		return -ENXIO;
+
 	ret = v4l2_clk_enable(mt9m111->clk);
 	if (ret < 0)
-		return ret;
+		goto out_module_put;
 
 	ret = mt9m111_resume(mt9m111);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
-		v4l2_clk_disable(mt9m111->clk);
+		goto out_clk_disable;
 	}
 
 	return ret;
+
+out_clk_disable:
+	v4l2_clk_disable(mt9m111->clk);
+out_module_put:
+	module_put(THIS_MODULE);
+	return ret;
 }
 
 static void mt9m111_power_off(struct mt9m111 *mt9m111)
 {
 	mt9m111_suspend(mt9m111);
 	v4l2_clk_disable(mt9m111->clk);
+	module_put(THIS_MODULE);
 }
 
 static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
-- 
2.1.4

