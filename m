Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:35949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AWTcp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 14:32:45 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 09/14] s5p-fimc: Use pinctrl API for camera ports
 configuration
Date: Wed, 23 Jan 2013 20:31:24 +0100
Message-id: <1358969489-20420-10-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
References: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before the camera ports can be used the pinmux needs to be configured
properly. This patch adds a function to get the pinctrl states and to
set default camera port pinmux state during the media driver's probe().
The camera port(s) are configured for video bus operation in this way.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyugmin Park <kyungmin.park@samsung.com>

Changes since v3:
 - removed the "inactive" pinctrl state, it will be added later if required
---
 .../devicetree/bindings/media/soc/samsung-fimc.txt |    4 ++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |   14 ++++++++++++++
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |    2 ++
 3 files changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
index 0538990..f844b4a 100644
--- a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
+++ b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
@@ -18,6 +18,10 @@ Required properties:
 
 - compatible	   : must be "samsung,fimc", "simple-bus"
 
+- pinctrl-names    : pinctrl names for camera port pinmux control, at least
+		     "default" need to be specified.
+- pinctrl-0...N	   : pinctrl properties corresponding to pinctrl-names
+
 The 'camera' node must include at least one 'fimc' child node.
 
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index a21db59..c3cd2ad 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1137,6 +1137,14 @@ static ssize_t fimc_md_sysfs_store(struct device *dev,
 static DEVICE_ATTR(subdev_conf_mode, S_IWUSR | S_IRUGO,
 		   fimc_md_sysfs_show, fimc_md_sysfs_store);
 
+static int fimc_md_get_pinctrl(struct fimc_md *fmd)
+{
+	fmd->pinctl = devm_pinctrl_get_select_default(&fmd->pdev->dev);
+	if (IS_ERR(fmd->pinctl))
+		return PTR_ERR(fmd->pinctl);
+	return 0;
+}
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1181,6 +1189,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 	/* Protect the media graph while we're registering entities */
 	mutex_lock(&fmd->media_dev.graph_mutex);
 
+	if (dev->of_node) {
+		ret = fimc_md_get_pinctrl(fmd);
+		if (ret < 0)
+			goto err_unlock;
+	}
+
 	if (fmd->pdev->dev.of_node)
 		ret = fimc_md_register_of_platform_entities(fmd, dev->of_node);
 	else
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
index 38006ba..8be68a7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
@@ -10,6 +10,7 @@
 #define FIMC_MDEVICE_H_
 
 #include <linux/clk.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <media/media-device.h>
@@ -85,6 +86,7 @@ struct fimc_md {
 	struct media_device media_dev;
 	struct v4l2_device v4l2_dev;
 	struct platform_device *pdev;
+	struct pinctrl *pinctl;
 	bool user_subdev_api;
 	spinlock_t slock;
 };
-- 
1.7.9.5

