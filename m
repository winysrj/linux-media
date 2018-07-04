Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41950 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753061AbeGDTH5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 15:07:57 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, robh@kernel.org, mark.rutland@arm.com,
        andy.gross@linaro.org, arnd@arndb.de, bjorn.andersson@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org
Subject: [PATCH v3 4/4] venus: firmware: register separate driver for firmware device
Date: Thu,  5 Jul 2018 00:36:52 +0530
Message-Id: <1530731212-30474-5-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
References: <1530731212-30474-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A separate child device is added for video firmware.
This is needed to
[1] configure the firmware context bank with the desired SID.
[2] ensure that the iova for firmware region is from 0x0.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 .../devicetree/bindings/media/qcom,venus.txt       | 17 +++++++-
 drivers/media/platform/qcom/venus/core.c           | 49 +++++++++++++++++++---
 drivers/media/platform/qcom/venus/firmware.c       | 18 ++++++++
 drivers/media/platform/qcom/venus/firmware.h       |  2 +
 4 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
index 00d0d1b..975fb12 100644
--- a/Documentation/devicetree/bindings/media/qcom,venus.txt
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -53,7 +53,7 @@
 
 * Subnodes
 The Venus video-codec node must contain two subnodes representing
-video-decoder and video-encoder.
+video-decoder and video-encoder, one optional firmware subnode.
 
 Every of video-encoder or video-decoder subnode should have:
 
@@ -79,6 +79,17 @@ Every of video-encoder or video-decoder subnode should have:
 		    power domain which is responsible for collapsing
 		    and restoring power to the subcore.
 
+The firmware sub node must have:
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Value should contain "venus-firmware"
+- iommus:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
+
 * An Example
 	video-codec@1d00000 {
 		compatible = "qcom,msm8916-venus";
@@ -105,4 +116,8 @@ Every of video-encoder or video-decoder subnode should have:
 			clock-names = "core";
 			power-domains = <&mmcc VENUS_CORE1_GDSC>;
 		};
+		venus-firmware {
+			compatible = "qcom,venus-firmware";
+			iommus = <&apps_smmu 0x10b2 0x0>;
+		}
 	};
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 393994e..420dca3 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -179,6 +179,20 @@ static u32 to_v4l2_codec_type(u32 codec)
 	}
 }
 
+static int store_firmware_dev(struct device *dev, void *data)
+{
+	struct venus_core *core = data;
+	if (!core)
+		return -EINVAL;
+
+	if (of_device_is_compatible(dev->of_node, "qcom,venus-firmware")) {
+		core->fw.dev = dev;
+		core->no_tz = true;
+	}
+
+	return 0;
+}
+
 static int venus_enumerate_codecs(struct venus_core *core, u32 type)
 {
 	const struct hfi_inst_ops dummy_ops = {};
@@ -284,6 +298,13 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_runtime_disable;
 
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (ret)
+		goto err_runtime_disable;
+
+	/* Attempt to store firmware device */
+	device_for_each_child(dev, core, store_firmware_dev);
+
 	ret = venus_boot(core);
 	if (ret)
 		goto err_runtime_disable;
@@ -308,10 +329,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_core_deinit;
 
-	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
-	if (ret)
-		goto err_dev_unregister;
-
 	ret = pm_runtime_put_sync(dev);
 	if (ret)
 		goto err_dev_unregister;
@@ -488,7 +505,29 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
 		.pm = &venus_pm_ops,
 	},
 };
-module_platform_driver(qcom_venus_driver);
+
+static int __init venus_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&qcom_video_firmware_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&qcom_venus_driver);
+	if (ret)
+		platform_driver_unregister(&qcom_video_firmware_driver);
+
+	return ret;
+}
+module_init(venus_init);
+
+static void __exit venus_exit(void)
+{
+	platform_driver_unregister(&qcom_venus_driver);
+	platform_driver_unregister(&qcom_video_firmware_driver);
+}
+module_exit(venus_exit);
 
 MODULE_ALIAS("platform:qcom-venus");
 MODULE_DESCRIPTION("Qualcomm Venus video encoder and decoder driver");
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 2a98d9e..4c0d808 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
@@ -231,3 +232,20 @@ int venus_shutdown(struct venus_core *core)
 
 	return ret;
 }
+
+static const struct of_device_id firmware_dt_match[] = {
+	{ .compatible = "qcom,venus-firmware" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, firmware_dt_match);
+
+struct platform_driver qcom_video_firmware_driver = {
+	.driver = {
+			.name = "qcom-video-firmware",
+			.of_match_table = firmware_dt_match,
+	},
+};
+
+MODULE_ALIAS("platform:qcom-video-firmware");
+MODULE_DESCRIPTION("Qualcomm Venus firmware driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/platform/qcom/venus/firmware.h b/drivers/media/platform/qcom/venus/firmware.h
index 92736d6..8f4848f 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -16,6 +16,8 @@
 
 struct device;
 
+extern struct platform_driver qcom_video_firmware_driver;
+
 int venus_boot(struct venus_core *core);
 int venus_shutdown(struct venus_core *core);
 int venus_set_hw_state(struct venus_core *core, bool suspend);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
