Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50290 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbeEUOV7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 10:21:59 -0400
Received: by mail-wm0-f66.google.com with SMTP id t11-v6so25733565wmt.0
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 07:21:59 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] media: platform: Add ChromeOS EC CEC driver
Date: Mon, 21 May 2018 16:21:46 +0200
Message-Id: <1526912506-18406-6-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1526912506-18406-1-git-send-email-narmstrong@baylibre.com>
References: <1526912506-18406-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ChromeOS Embedded Controller can expose a CEC bus, this patch add the
driver for such feature of the Embedded Controller.

This driver is part of the cros-ec MFD and will be add as a sub-device when
the feature bit is exposed by the EC.

The controller will only handle a single logical address and handles
all the messages retries and will only expose Success or Error.

The controller will be tied to the HDMI CEC notifier by using the platform
DMI Data and the i915 device name and connector name.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
---
 drivers/media/platform/Kconfig                   |  11 +
 drivers/media/platform/Makefile                  |   2 +
 drivers/media/platform/cros-ec-cec/Makefile      |   1 +
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 347 +++++++++++++++++++++++
 4 files changed, 361 insertions(+)
 create mode 100644 drivers/media/platform/cros-ec-cec/Makefile
 create mode 100644 drivers/media/platform/cros-ec-cec/cros-ec-cec.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7a1cf8..bc37ecf 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -546,6 +546,17 @@ menuconfig CEC_PLATFORM_DRIVERS
 
 if CEC_PLATFORM_DRIVERS
 
+config VIDEO_CROS_EC_CEC
+	tristate "ChromeOS EC CEC driver"
+	depends on MFD_CROS_EC || COMPILE_TEST
+	select CEC_CORE
+	select CEC_NOTIFIER
+	---help---
+	  If you say yes here you will get support for the
+	  ChromeOS Embedded Controller's CEC.
+	  The CEC bus is present in the HDMI connector and enables communication
+	  between compatible devices.
+
 config VIDEO_MESON_AO_CEC
 	tristate "Amlogic Meson AO CEC driver"
 	depends on ARCH_MESON || COMPILE_TEST
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 932515d..830696f 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -92,3 +92,5 @@ obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss-8x16/
 obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
 
 obj-y					+= meson/
+
+obj-y					+= cros-ec-cec/
diff --git a/drivers/media/platform/cros-ec-cec/Makefile b/drivers/media/platform/cros-ec-cec/Makefile
new file mode 100644
index 0000000..9ce97f9
--- /dev/null
+++ b/drivers/media/platform/cros-ec-cec/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_CROS_EC_CEC) += cros-ec-cec.o
diff --git a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
new file mode 100644
index 0000000..7f897a2
--- /dev/null
+++ b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
@@ -0,0 +1,347 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * CEC driver for ChromeOS Embedded Controller
+ *
+ * Copyright (c) 2018 BayLibre, SAS
+ * Author: Neil Armstrong <narmstrong@baylibre.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/dmi.h>
+#include <linux/pci.h>
+#include <linux/cec.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <media/cec.h>
+#include <media/cec-notifier.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+
+#define DRV_NAME	"cros-ec-cec"
+
+/**
+ * struct cros_ec_cec - Driver data for EC CEC
+ *
+ * @cros_ec: Pointer to EC device
+ * @notifier: Notifier info for responding to EC events
+ * @adap: CEC adapter
+ * @notify: CEC notifier pointer
+ * @rx_msg: storage for a received message
+ */
+struct cros_ec_cec {
+	struct cros_ec_device *cros_ec;
+	struct notifier_block notifier;
+	struct cec_adapter *adap;
+	struct cec_notifier *notify;
+	struct cec_msg rx_msg;
+};
+
+static void handle_cec_message(struct cros_ec_cec *cros_ec_cec)
+{
+	struct cros_ec_device *cros_ec = cros_ec_cec->cros_ec;
+	uint8_t *cec_message = cros_ec->event_data.data.cec_message;
+	unsigned int len = cros_ec->event_size;
+
+	cros_ec_cec->rx_msg.len = len;
+	memcpy(cros_ec_cec->rx_msg.msg, cec_message, len);
+
+	cec_received_msg(cros_ec_cec->adap, &cros_ec_cec->rx_msg);
+}
+
+static void handle_cec_event(struct cros_ec_cec *cros_ec_cec)
+{
+	struct cros_ec_device *cros_ec = cros_ec_cec->cros_ec;
+	uint32_t events = cros_ec->event_data.data.cec_events;
+
+	if (events & EC_MKBP_CEC_SEND_OK)
+		cec_transmit_attempt_done(cros_ec_cec->adap,
+					  CEC_TX_STATUS_OK);
+
+	/* FW takes care of all retries, tell core to avoid more retries */
+	if (events & EC_MKBP_CEC_SEND_FAILED)
+		cec_transmit_attempt_done(cros_ec_cec->adap,
+					  CEC_TX_STATUS_MAX_RETRIES |
+					  CEC_TX_STATUS_NACK);
+}
+
+static int cros_ec_cec_event(struct notifier_block *nb,
+			     unsigned long queued_during_suspend,
+			     void *_notify)
+{
+	struct cros_ec_cec *cros_ec_cec;
+	struct cros_ec_device *cros_ec;
+
+	cros_ec_cec = container_of(nb, struct cros_ec_cec, notifier);
+	cros_ec = cros_ec_cec->cros_ec;
+
+	if (cros_ec->event_data.event_type == EC_MKBP_CEC_EVENT) {
+		handle_cec_event(cros_ec_cec);
+		return NOTIFY_OK;
+	}
+
+	if (cros_ec->event_data.event_type == EC_MKBP_EVENT_CEC_MESSAGE) {
+		handle_cec_message(cros_ec_cec);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int cros_ec_cec_set_log_addr(struct cec_adapter *adap, u8 logical_addr)
+{
+	struct cros_ec_cec *cros_ec_cec = adap->priv;
+	struct cros_ec_device *cros_ec = cros_ec_cec->cros_ec;
+	struct {
+		struct cros_ec_command msg;
+		struct ec_params_cec_set data;
+	} __packed msg = {};
+	int ret;
+
+	msg.msg.command = EC_CMD_CEC_SET;
+	msg.msg.outsize = sizeof(msg.data);
+	msg.data.cmd = CEC_CMD_LOGICAL_ADDRESS;
+	msg.data.address = logical_addr;
+
+	ret = cros_ec_cmd_xfer_status(cros_ec, &msg.msg);
+	if (ret < 0) {
+		dev_err(cros_ec->dev,
+			"error setting CEC logical address on EC: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int cros_ec_cec_transmit(struct cec_adapter *adap, u8 attempts,
+				u32 signal_free_time, struct cec_msg *cec_msg)
+{
+	struct cros_ec_cec *cros_ec_cec = adap->priv;
+	struct cros_ec_device *cros_ec = cros_ec_cec->cros_ec;
+	struct {
+		struct cros_ec_command msg;
+		struct ec_params_cec_write data;
+	} __packed msg = {};
+	int ret;
+
+	msg.msg.command = EC_CMD_CEC_WRITE_MSG;
+	msg.msg.outsize = cec_msg->len;
+	memcpy(msg.data.msg, cec_msg->msg, cec_msg->len);
+
+	ret = cros_ec_cmd_xfer_status(cros_ec, &msg.msg);
+	if (ret < 0) {
+		dev_err(cros_ec->dev,
+			"error writing CEC msg on EC: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int cros_ec_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct cros_ec_cec *cros_ec_cec = adap->priv;
+	struct cros_ec_device *cros_ec = cros_ec_cec->cros_ec;
+	struct {
+		struct cros_ec_command msg;
+		struct ec_params_cec_set data;
+	} __packed msg = {};
+	int ret;
+
+	msg.msg.command = EC_CMD_CEC_SET;
+	msg.msg.outsize = sizeof(msg.data);
+	msg.data.cmd = CEC_CMD_ENABLE;
+	msg.data.enable = enable;
+
+	ret = cros_ec_cmd_xfer_status(cros_ec, &msg.msg);
+	if (ret < 0) {
+		dev_err(cros_ec->dev,
+			"error %sabling CEC on EC: %d\n",
+			(enable ? "en" : "dis"), ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct cec_adap_ops cros_ec_cec_ops = {
+	.adap_enable = cros_ec_cec_adap_enable,
+	.adap_log_addr = cros_ec_cec_set_log_addr,
+	.adap_transmit = cros_ec_cec_transmit,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int cros_ec_cec_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct cros_ec_cec *cros_ec_cec = dev_get_drvdata(&pdev->dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(cros_ec_cec->cros_ec->irq);
+
+	return 0;
+}
+
+static int cros_ec_cec_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct cros_ec_cec *cros_ec_cec = dev_get_drvdata(&pdev->dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(cros_ec_cec->cros_ec->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(cros_ec_cec_pm_ops,
+	cros_ec_cec_suspend, cros_ec_cec_resume);
+
+#if IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_DMI)
+
+/*
+ * The Firmware only handles a single CEC interface tied to a single HDMI
+ * connector we specify along with the DRM device name handling the HDMI output
+ */
+
+struct cec_dmi_match {
+	char *sys_vendor;
+	char *product_name;
+	char *devname;
+	char *conn;
+};
+
+static const struct cec_dmi_match cec_dmi_match_table[] = {
+	/* Google Fizz */
+	{ "Google", "Fizz", "0000:00:02.0", "Port B" },
+};
+
+static int cros_ec_cec_get_notifier(struct device *dev,
+				    struct cec_notifier **notify)
+{
+	int i;
+
+	for (i = 0 ; i < ARRAY_SIZE(cec_dmi_match_table) ; ++i) {
+		const struct cec_dmi_match *m = &cec_dmi_match_table[i];
+
+		if (dmi_match(DMI_SYS_VENDOR, m->sys_vendor) &&
+		    dmi_match(DMI_PRODUCT_NAME, m->product_name)) {
+			struct device *d;
+
+			/* Find the device, bail out if not yet registered */
+			d = bus_find_device_by_name(&pci_bus_type, NULL,
+						    m->devname);
+			if (!d)
+				return -EPROBE_DEFER;
+
+			*notify = cec_notifier_get_conn(d, m->conn);
+			return 0;
+		}
+	}
+
+	/* Hardware support must be added in the cec_dmi_match_table */
+	dev_warn(dev, "CEC notifier not configured for this hardware\n");
+
+	return -ENODEV;
+}
+
+#else
+
+static int cros_ec_cec_get_notifier(struct device *dev,
+				    struct cec_notifier **notify)
+{
+	return -ENODEV;
+}
+
+#endif
+
+static int cros_ec_cec_probe(struct platform_device *pdev)
+{
+	struct cros_ec_dev *ec_dev = dev_get_drvdata(pdev->dev.parent);
+	struct cros_ec_device *cros_ec = ec_dev->ec_dev;
+	struct cros_ec_cec *cros_ec_cec;
+	int ret;
+
+	cros_ec_cec = devm_kzalloc(&pdev->dev, sizeof(*cros_ec_cec),
+				   GFP_KERNEL);
+	if (!cros_ec_cec)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, cros_ec_cec);
+	cros_ec_cec->cros_ec = cros_ec;
+
+	ret = cros_ec_cec_get_notifier(&pdev->dev, &cros_ec_cec->notify);
+	if (ret)
+		return ret;
+
+	ret = device_init_wakeup(&pdev->dev, 1);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to initialize wakeup\n");
+		return ret;
+	}
+
+	cros_ec_cec->adap = cec_allocate_adapter(&cros_ec_cec_ops, cros_ec_cec,
+						 DRV_NAME, CEC_CAP_DEFAULTS, 1);
+	if (IS_ERR(cros_ec_cec->adap))
+		return PTR_ERR(cros_ec_cec->adap);
+
+	/* Get CEC events from the EC. */
+	cros_ec_cec->notifier.notifier_call = cros_ec_cec_event;
+	ret = blocking_notifier_chain_register(&cros_ec->event_notifier,
+					       &cros_ec_cec->notifier);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register notifier\n");
+		cec_delete_adapter(cros_ec_cec->adap);
+		return ret;
+	}
+
+	ret = cec_register_adapter(cros_ec_cec->adap, &pdev->dev);
+	if (ret < 0) {
+		cec_delete_adapter(cros_ec_cec->adap);
+		return ret;
+	}
+
+	cec_register_cec_notifier(cros_ec_cec->adap, cros_ec_cec->notify);
+
+	return 0;
+}
+
+static int cros_ec_cec_remove(struct platform_device *pdev)
+{
+	struct cros_ec_cec *cros_ec_cec = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	ret = blocking_notifier_chain_unregister(
+			&cros_ec_cec->cros_ec->event_notifier,
+			&cros_ec_cec->notifier);
+
+	if (ret) {
+		dev_err(dev, "failed to unregister notifier\n");
+		return ret;
+	}
+
+	cec_unregister_adapter(cros_ec_cec->adap);
+
+	if (cros_ec_cec->notify)
+		cec_notifier_put(cros_ec_cec->notify);
+
+	return 0;
+}
+
+static struct platform_driver cros_ec_cec_driver = {
+	.probe = cros_ec_cec_probe,
+	.remove  = cros_ec_cec_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.pm = &cros_ec_cec_pm_ops,
+	},
+};
+
+module_platform_driver(cros_ec_cec_driver);
+
+MODULE_DESCRIPTION("CEC driver for ChromeOS ECs");
+MODULE_AUTHOR("Neil Armstrong <narmstrong@baylibre.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
2.7.4
