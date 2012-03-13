Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60009 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2CMNfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 09:35:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0T00HQWSEV3D90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Mar 2012 13:35:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0T001GKSEV2Q@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 13 Mar 2012 13:35:19 +0000 (GMT)
Date: Tue, 13 Mar 2012 14:35:12 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 4/6] v4l: s5p-tv: hdmi: fix mode synchronization
In-reply-to: <1331645714-24535-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: sachin.kamat@linaro.org, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Message-id: <1331645714-24535-5-git-send-email-t.stanislaws@samsung.com>
References: <1331645714-24535-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mode setup was applied on HDMI hardware only on resume event.  This caused
problem if HDMI was not suspended between mode switches.  This patch fixes this
problem by setting a dirty flag on a mode change event.  If flag is set them
new mode is applied on the next stream-on event.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/hdmi_drv.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index eefb903..20cb6ee 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -87,6 +87,8 @@ struct hdmi_device {
 	struct v4l2_subdev *mhl_sd;
 	/** configuration of current graphic mode */
 	const struct hdmi_timings *cur_conf;
+	/** flag indicating that timings are dirty */
+	int cur_conf_dirty;
 	/** current preset */
 	u32 cur_preset;
 	/** other resources */
@@ -253,6 +255,10 @@ static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	/* skip if conf is already synchronized with HW */
+	if (!hdmi_dev->cur_conf_dirty)
+		return 0;
+
 	/* reset hdmiphy */
 	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
 	mdelay(10);
@@ -278,6 +284,8 @@ static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
 	/* setting core registers */
 	hdmi_timing_apply(hdmi_dev, conf);
 
+	hdmi_dev->cur_conf_dirty = 0;
+
 	return 0;
 }
 
@@ -500,6 +508,10 @@ static int hdmi_streamon(struct hdmi_device *hdev)
 
 	dev_dbg(dev, "%s\n", __func__);
 
+	ret = hdmi_conf_apply(hdev);
+	if (ret)
+		return ret;
+
 	ret = v4l2_subdev_call(hdev->phy_sd, video, s_stream, 1);
 	if (ret)
 		return ret;
@@ -620,6 +632,7 @@ static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 	hdev->cur_conf = conf;
+	hdev->cur_conf_dirty = 1;
 	hdev->cur_preset = preset->preset;
 	return 0;
 }
@@ -689,6 +702,8 @@ static int hdmi_runtime_suspend(struct device *dev)
 	dev_dbg(dev, "%s\n", __func__);
 	v4l2_subdev_call(hdev->mhl_sd, core, s_power, 0);
 	hdmi_resource_poweroff(&hdev->res);
+	/* flag that device context is lost */
+	hdev->cur_conf_dirty = 1;
 	return 0;
 }
 
@@ -702,10 +717,6 @@ static int hdmi_runtime_resume(struct device *dev)
 
 	hdmi_resource_poweron(&hdev->res);
 
-	ret = hdmi_conf_apply(hdev);
-	if (ret)
-		goto fail;
-
 	/* starting MHL */
 	ret = v4l2_subdev_call(hdev->mhl_sd, core, s_power, 1);
 	if (hdev->mhl_sd && ret)
@@ -946,6 +957,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
 	/* FIXME: missing fail preset is not supported */
 	hdmi_dev->cur_conf = hdmi_preset2timings(hdmi_dev->cur_preset);
+	hdmi_dev->cur_conf_dirty = 1;
 
 	/* storing subdev for call that have only access to struct device */
 	dev_set_drvdata(dev, sd);
-- 
1.7.5.4

