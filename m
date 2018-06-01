Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753658AbeFAU1K (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 16:27:10 -0400
From: Vikash Garodia <vgarodia@codeaurora.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, robh@kernel.org,
        mark.rutland@arm.com, andy.gross@linaro.org,
        bjorn.andersson@linaro.org, stanimir.varbanov@linaro.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, vgarodia@codeaurora.org,
        acourbot@chromium.org
Subject: [PATCH v2 5/5] venus: register separate driver for firmware device
Date: Sat,  2 Jun 2018 01:56:08 +0530
Message-Id: <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A separate child device is added for video firmware.
This is needed to
[1] configure the firmware context bank with the desired SID.
[2] ensure that the iova for firmware region is from 0x0.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
---
 .../devicetree/bindings/media/qcom,venus.txt       |  8 +++-
 drivers/media/platform/qcom/venus/core.c           | 48 +++++++++++++++++++---
 drivers/media/platform/qcom/venus/firmware.c       | 20 ++++++++-
 drivers/media/platform/qcom/venus/firmware.h       |  2 +
 4 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
index 00d0d1b..701cbe8 100644
--- a/Documentation/devicetree/bindings/media/qcom,venus.txt
+++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
@@ -53,7 +53,7 @@
 
 * Subnodes
 The Venus video-codec node must contain two subnodes representing
-video-decoder and video-encoder.
+video-decoder and video-encoder, one optional firmware subnode.
 
 Every of video-encoder or video-decoder subnode should have:
 
@@ -79,6 +79,8 @@ Every of video-encoder or video-decoder subnode should have:
 		    power domain which is responsible for collapsing
 		    and restoring power to the subcore.
 
+The firmware sub node must contain the iommus specifiers for ARM9.
+
 * An Example
 	video-codec@1d00000 {
 		compatible = "qcom,msm8916-venus";
@@ -105,4 +107,8 @@ Every of video-encoder or video-decoder subnode should have:
 			clock-names = "core";
 			power-domains = <&mmcc VENUS_CORE1_GDSC>;
 		};
+		venus-firmware {
+			compatible = "qcom,venus-firmware-no-tz";
+			iommus = <&apps_smmu 0x10b2 0x0>;
+		}
 	};
diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 101612b..5cfb3c2 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -179,6 +179,19 @@ static u32 to_v4l2_codec_type(u32 codec)
 	}
 }
 
+static int store_firmware_dev(struct device *dev, void *data)
+{
+	struct venus_core *core = data;
+
+	if (!core)
+		return -EINVAL;
+
+	if (of_device_is_compatible(dev->of_node, "qcom,venus-firmware-no-tz"))
+		core->fw.dev = dev;
+
+	return 0;
+}
+
 static int venus_enumerate_codecs(struct venus_core *core, u32 type)
 {
 	const struct hfi_inst_ops dummy_ops = {};
@@ -279,6 +292,13 @@ static int venus_probe(struct platform_device *pdev)
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
@@ -303,10 +323,6 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_core_deinit;
 
-	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
-	if (ret)
-		goto err_dev_unregister;
-
 	ret = pm_runtime_put_sync(dev);
 	if (ret)
 		goto err_dev_unregister;
@@ -483,7 +499,29 @@ static __maybe_unused int venus_runtime_resume(struct device *dev)
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
index 058d544..ed29d10 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
@@ -124,7 +125,7 @@ static int venus_load_fw(struct device *dev, const char *fwname,
 	}
 	if (qcom_scm_is_available())
 		ret = qcom_mdt_load(dev, mdt, fwname, VENUS_PAS_ID, mem_va,
-				*mem_phys, *mem_size);
+				*mem_phys, *mem_size, NULL);
 	else
 		ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
 				mem_va, *mem_phys, *mem_size, NULL);
@@ -243,3 +244,20 @@ int venus_shutdown(struct venus_core *core)
 
 	return ret;
 }
+
+static const struct of_device_id firmware_dt_match[] = {
+	{ .compatible = "qcom,venus-firmware-no-tz" },
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
index 67fdd89..23c0409 100644
--- a/drivers/media/platform/qcom/venus/firmware.h
+++ b/drivers/media/platform/qcom/venus/firmware.h
@@ -21,6 +21,8 @@
 
 struct device;
 
+extern struct platform_driver qcom_video_firmware_driver;
+
 int venus_boot(struct venus_core *core);
 int venus_shutdown(struct venus_core *core);
 int venus_set_hw_state(enum tzbsp_video_state, struct venus_core *core);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
