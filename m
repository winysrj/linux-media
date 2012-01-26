Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46721 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab2AZRMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 12:12:01 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYF0015C13ZNO@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 17:11:59 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYF0067213YY2@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jan 2012 17:11:59 +0000 (GMT)
Date: Thu, 26 Jan 2012 18:11:52 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 3/3] v4l: s5p-tv: hdmi: integrate with MHL
In-reply-to: <1327597912-30105-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1327597912-30105-4-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1327597912-30105-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding support for using MHL (SiI9234 or other) chip if its configuration was
passed to HDMI by platfrom data.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/hdmi_drv.c |   52 ++++++++++++++++++++++++++++----
 1 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index ab3a2d3..ddb9fb6 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -67,6 +67,8 @@ struct hdmi_device {
 	struct v4l2_device v4l2_dev;
 	/** subdev of HDMIPHY interface */
 	struct v4l2_subdev *phy_sd;
+	/** subdev of MHL interface */
+	struct v4l2_subdev *mhl_sd;
 	/** configuration of current graphic mode */
 	const struct hdmi_preset_conf *cur_conf;
 	/** current preset */
@@ -572,7 +574,15 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 	if (tries == 0) {
 		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
 		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
-		hdmi_dumpregs(hdev, "s_stream");
+		hdmi_dumpregs(hdev, "hdmiphy - s_stream");
+		return -EIO;
+	}
+
+	/* starting MHL */
+	ret = v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 1);
+	if (hdev->mhl_sd && ret) {
+		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
+		hdmi_dumpregs(hdev, "mhl - s_stream");
 		return -EIO;
 	}
 
@@ -603,6 +613,7 @@ static int hdmi_streamoff(struct hdmi_device *hdev)
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	clk_enable(res->sclk_hdmi);
 
+	v4l2_subdev_call(hdev->mhl_sd, video, s_stream, 0);
 	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
 
 	hdmi_dumpregs(hdev, "streamoff");
@@ -724,6 +735,7 @@ static int hdmi_runtime_suspend(struct device *dev)
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
 
 	dev_dbg(dev, "%s\n", __func__);
+	v4l2_subdev_call(hdev->mhl_sd, core, s_power, 0);
 	hdmi_resource_poweroff(&hdev->res);
 	return 0;
 }
@@ -742,6 +754,11 @@ static int hdmi_runtime_resume(struct device *dev)
 	if (ret)
 		goto fail;
 
+	/* starting MHL */
+	ret = v4l2_subdev_call(hdev->mhl_sd, core, s_power, 1);
+	if (hdev->mhl_sd && ret)
+		goto fail;
+
 	dev_dbg(dev, "poweron succeed\n");
 
 	return 0;
@@ -852,7 +869,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
-	struct i2c_adapter *phy_adapter;
+	struct i2c_adapter *adapter;
 	struct v4l2_subdev *sd;
 	struct hdmi_device *hdmi_dev = NULL;
 	struct s5p_hdmi_platform_data *pdata = dev->platform_data;
@@ -925,23 +942,44 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		goto fail_vdev;
 	}
 
-	phy_adapter = i2c_get_adapter(pdata->hdmiphy_bus);
-	if (phy_adapter == NULL) {
-		dev_err(dev, "adapter request failed\n");
+	adapter = i2c_get_adapter(pdata->hdmiphy_bus);
+	if (adapter == NULL) {
+		dev_err(dev, "hdmiphy adapter request failed\n");
 		ret = -ENXIO;
 		goto fail_vdev;
 	}
 
 	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->v4l2_dev,
-		phy_adapter, pdata->hdmiphy_info, NULL);
+		adapter, pdata->hdmiphy_info, NULL);
 	/* on failure or not adapter is no longer useful */
-	i2c_put_adapter(phy_adapter);
+	i2c_put_adapter(adapter);
 	if (hdmi_dev->phy_sd == NULL) {
 		dev_err(dev, "missing subdev for hdmiphy\n");
 		ret = -ENODEV;
 		goto fail_vdev;
 	}
 
+	/* initialization of MHL interface if present */
+	if (pdata->mhl_info) {
+		adapter = i2c_get_adapter(pdata->mhl_bus);
+		if (adapter == NULL) {
+			dev_err(dev, "MHL adapter request failed\n");
+			ret = -ENXIO;
+			goto fail_vdev;
+		}
+
+		hdmi_dev->mhl_sd = v4l2_i2c_new_subdev_board(
+			&hdmi_dev->v4l2_dev, adapter,
+			pdata->mhl_info, NULL);
+		/* on failure or not adapter is no longer useful */
+		i2c_put_adapter(adapter);
+		if (hdmi_dev->mhl_sd == NULL) {
+			dev_err(dev, "missing subdev for MHL\n");
+			ret = -ENODEV;
+			goto fail_vdev;
+		}
+	}
+
 	clk_enable(hdmi_dev->res.hdmi);
 
 	pm_runtime_enable(dev);
-- 
1.7.5.4

