Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40007 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbbCBOyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 09:54:36 -0500
Received: by wesx3 with SMTP id x3so33807797wes.7
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 06:54:34 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: drop call to v4l2_device_unregister_subdev()
Date: Mon,  2 Mar 2015 14:54:07 +0000
Message-Id: <1425308047-24756-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

These drivers are moved to support asynchronous probing,
v4l2_async_unregister_subdev() unregisters the subdev so
there isn't a need to explicitly call v4l2_device_unregister_subdev().

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/adv7343.c                        | 1 -
 drivers/media/i2c/adv7604.c                        | 1 -
 drivers/media/i2c/mt9v032.c                        | 1 -
 drivers/media/i2c/soc_camera/mt9m111.c             | 1 -
 drivers/media/i2c/ths8200.c                        | 1 -
 drivers/media/i2c/tvp514x.c                        | 1 -
 drivers/media/i2c/tvp7002.c                        | 1 -
 drivers/media/platform/soc_camera/sh_mobile_csi2.c | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 9d38f7b..7c50833 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -506,7 +506,6 @@ static int adv7343_remove(struct i2c_client *client)
 	struct adv7343_state *state = to_state(sd);
 
 	v4l2_async_unregister_subdev(&state->sd);
-	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
 
 	return 0;
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d228b7c..af6363d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2879,7 +2879,6 @@ static int adv7604_remove(struct i2c_client *client)
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
 	v4l2_async_unregister_subdev(sd);
-	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7604_unregister_clients(to_state(sd));
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index bd3f979..3267c18 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -1016,7 +1016,6 @@ static int mt9v032_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(subdev);
 	v4l2_ctrl_handler_free(&mt9v032->ctrls);
-	v4l2_device_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
 
 	return 0;
diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
index 5992ea9..441e0fd 100644
--- a/drivers/media/i2c/soc_camera/mt9m111.c
+++ b/drivers/media/i2c/soc_camera/mt9m111.c
@@ -1016,7 +1016,6 @@ static int mt9m111_remove(struct i2c_client *client)
 
 	v4l2_async_unregister_subdev(&mt9m111->subdev);
 	v4l2_clk_put(mt9m111->clk);
-	v4l2_device_unregister_subdev(&mt9m111->subdev);
 	v4l2_ctrl_handler_free(&mt9m111->hdl);
 
 	return 0;
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 4ebd329..73fc42b 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -479,7 +479,6 @@ static int ths8200_remove(struct i2c_client *client)
 
 	ths8200_s_power(sd, false);
 	v4l2_async_unregister_subdev(&decoder->sd);
-	v4l2_device_unregister_subdev(sd);
 
 	return 0;
 }
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 2042042..c6b3dc5 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1209,7 +1209,6 @@ static int tvp514x_remove(struct i2c_client *client)
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 
 	v4l2_async_unregister_subdev(&decoder->sd);
-	v4l2_device_unregister_subdev(sd);
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&decoder->sd.entity);
 #endif
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index fe4870e..9233194 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -1116,7 +1116,6 @@ static int tvp7002_remove(struct i2c_client *c)
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	media_entity_cleanup(&device->sd.entity);
 #endif
-	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&device->hdl);
 	return 0;
 }
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index c4e7aa0..cd93241 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -380,7 +380,6 @@ static int sh_csi2_remove(struct platform_device *pdev)
 	struct sh_csi2 *priv = container_of(subdev, struct sh_csi2, subdev);
 
 	v4l2_async_unregister_subdev(&priv->subdev);
-	v4l2_device_unregister_subdev(subdev);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
-- 
1.9.1

