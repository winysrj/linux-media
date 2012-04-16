Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50894 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2DPN7A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:00 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2K00F7FS4CSZ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:57:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K00D6US683Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:56 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:52 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 5/8] v4l: s5p-tv: hdmi: fix mode synchronization
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-6-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
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

