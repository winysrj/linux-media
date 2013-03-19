Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:47191 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3CSPl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 11:41:59 -0400
Received: by mail-ve0-f174.google.com with SMTP id pb11so527232veb.33
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 08:41:59 -0700 (PDT)
From: Eduardo Valentin <edubezval@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCH 1/4] media: radio: CodingStyle changes on si4713
Date: Tue, 19 Mar 2013 11:41:31 -0400
Message-Id: <1363707694-27224-2-git-send-email-edubezval@gmail.com>
In-Reply-To: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minor changes to make alignment match on open parenthesis.

Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/radio-si4713.c |   53 +++++++++++++++++------------------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 1507c9d..5b5c42b 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -94,7 +94,7 @@ static int radio_si4713_querycap(struct file *file, void *priv,
 {
 	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
 	strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
-				sizeof(capability->card));
+		sizeof(capability->card));
 	capability->capabilities = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
 
 	return 0;
@@ -102,7 +102,7 @@ static int radio_si4713_querycap(struct file *file, void *priv,
 
 /* radio_si4713_queryctrl - enumerate control items */
 static int radio_si4713_queryctrl(struct file *file, void *priv,
-						struct v4l2_queryctrl *qc)
+				  struct v4l2_queryctrl *qc)
 {
 	/* Must be sorted from low to high control ID! */
 	static const u32 user_ctrls[] = {
@@ -152,7 +152,7 @@ static int radio_si4713_queryctrl(struct file *file, void *priv,
 		return v4l2_ctrl_query_fill(qc, 0, 0, 0, 0);
 
 	return v4l2_device_call_until_err(&rsdev->v4l2_dev, 0, core,
-						queryctrl, qc);
+					  queryctrl, qc);
 }
 
 /*
@@ -165,66 +165,66 @@ static inline struct v4l2_device *get_v4l2_dev(struct file *file)
 }
 
 static int radio_si4713_g_ext_ctrls(struct file *file, void *p,
-						struct v4l2_ext_controls *vecs)
+				    struct v4l2_ext_controls *vecs)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
-							g_ext_ctrls, vecs);
+					  g_ext_ctrls, vecs);
 }
 
 static int radio_si4713_s_ext_ctrls(struct file *file, void *p,
-						struct v4l2_ext_controls *vecs)
+				    struct v4l2_ext_controls *vecs)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
-							s_ext_ctrls, vecs);
+					  s_ext_ctrls, vecs);
 }
 
 static int radio_si4713_g_ctrl(struct file *file, void *p,
-						struct v4l2_control *vc)
+			       struct v4l2_control *vc)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
-							g_ctrl, vc);
+					  g_ctrl, vc);
 }
 
 static int radio_si4713_s_ctrl(struct file *file, void *p,
-						struct v4l2_control *vc)
+			       struct v4l2_control *vc)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
-							s_ctrl, vc);
+					  s_ctrl, vc);
 }
 
 static int radio_si4713_g_modulator(struct file *file, void *p,
-						struct v4l2_modulator *vm)
+				    struct v4l2_modulator *vm)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-							g_modulator, vm);
+					  g_modulator, vm);
 }
 
 static int radio_si4713_s_modulator(struct file *file, void *p,
-						const struct v4l2_modulator *vm)
+				    const struct v4l2_modulator *vm)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-							s_modulator, vm);
+					  s_modulator, vm);
 }
 
 static int radio_si4713_g_frequency(struct file *file, void *p,
-						struct v4l2_frequency *vf)
+				    struct v4l2_frequency *vf)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-							g_frequency, vf);
+					  g_frequency, vf);
 }
 
 static int radio_si4713_s_frequency(struct file *file, void *p,
-						struct v4l2_frequency *vf)
+				    struct v4l2_frequency *vf)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, tuner,
-							s_frequency, vf);
+					  s_frequency, vf);
 }
 
 static long radio_si4713_default(struct file *file, void *p,
-				bool valid_prio, int cmd, void *arg)
+				 bool valid_prio, int cmd, void *arg)
 {
 	return v4l2_device_call_until_err(get_v4l2_dev(file), 0, core,
-							ioctl, cmd, arg);
+					  ioctl, cmd, arg);
 }
 
 static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
@@ -285,13 +285,13 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	adapter = i2c_get_adapter(pdata->i2c_bus);
 	if (!adapter) {
 		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
-							pdata->i2c_bus);
+			pdata->i2c_bus);
 		rval = -ENODEV;
 		goto unregister_v4l2_dev;
 	}
 
 	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter,
-					pdata->subdev_board_info, NULL);
+				       pdata->subdev_board_info, NULL);
 	if (!sd) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
 		rval = -ENODEV;
@@ -306,7 +306,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	}
 
 	memcpy(rsdev->radio_dev, &radio_si4713_vdev_template,
-			sizeof(radio_si4713_vdev_template));
+	       sizeof(radio_si4713_vdev_template));
 	video_set_drvdata(rsdev->radio_dev, rsdev);
 	if (video_register_device(rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
 		dev_err(&pdev->dev, "Could not register video device.\n");
@@ -331,13 +331,12 @@ exit:
 static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
-	struct radio_si4713_device *rsdev = container_of(v4l2_dev,
-						struct radio_si4713_device,
-						v4l2_dev);
 	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
 					    struct v4l2_subdev, list);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct radio_si4713_device *rsdev;
 
+	rsdev = container_of(v4l2_dev, struct radio_si4713_device, v4l2_dev);
 	video_unregister_device(rsdev->radio_dev);
 	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&rsdev->v4l2_dev);
-- 
1.7.7.1.488.ge8e1c

