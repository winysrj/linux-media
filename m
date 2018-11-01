Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38008 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727203AbeKANQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 09:16:53 -0400
Received: by mail-pl1-f195.google.com with SMTP id p7-v6so8304589plk.5
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 21:15:39 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH 1/2] media: video-i2c: check if chip struct has set_power function
Date: Wed, 31 Oct 2018 21:15:33 -0700
Message-Id: <20181101041534.5913-2-matt.ranostay@konsulko.com>
In-Reply-To: <20181101041534.5913-1-matt.ranostay@konsulko.com>
References: <20181101041534.5913-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all future supported video chips will always have power management
support, and so it is important to check before calling set_power() is
defined.

Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 drivers/media/i2c/video-i2c.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index cb5db5bdab12..6d3b6df0b634 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -736,9 +736,11 @@ static int video_i2c_probe(struct i2c_client *client,
 	video_set_drvdata(&data->vdev, data);
 	i2c_set_clientdata(client, data);
 
-	ret = data->chip->set_power(data, true);
-	if (ret)
-		goto error_unregister_device;
+	if (data->chip->set_power) {
+		ret = data->chip->set_power(data, true);
+		if (ret)
+			goto error_unregister_device;
+	}
 
 	pm_runtime_get_noresume(&client->dev);
 	pm_runtime_set_active(&client->dev);
@@ -767,7 +769,8 @@ static int video_i2c_probe(struct i2c_client *client,
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-	data->chip->set_power(data, false);
+	if (data->chip->set_power)
+		data->chip->set_power(data, false);
 
 error_unregister_device:
 	v4l2_device_unregister(v4l2_dev);
@@ -791,7 +794,9 @@ static int video_i2c_remove(struct i2c_client *client)
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-	data->chip->set_power(data, false);
+
+	if (data->chip->set_power)
+		data->chip->set_power(data, false);
 
 	video_unregister_device(&data->vdev);
 
@@ -804,6 +809,9 @@ static int video_i2c_pm_runtime_suspend(struct device *dev)
 {
 	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
 
+	if (!data->chip->set_power)
+		return 0;
+
 	return data->chip->set_power(data, false);
 }
 
@@ -811,6 +819,9 @@ static int video_i2c_pm_runtime_resume(struct device *dev)
 {
 	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
 
+	if (!data->chip->set_power)
+		return 0;
+
 	return data->chip->set_power(data, true);
 }
 
-- 
2.17.1
