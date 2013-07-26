Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55033 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025Ab3GZMoL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 08:44:11 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>,
	<balbi@ti.com>, <kishon@ti.com>, <jg1.han@samsung.com>,
	<s.nawrocki@samsung.com>, <kgene.kim@samsung.com>,
	<stern@rowland.harvard.edu>, <broonie@kernel.org>,
	<tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>,
	<swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
	<balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
	Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 1/8] drivers: phy: add generic PHY framework
Date: Fri, 26 Jul 2013 18:12:55 +0530
Message-ID: <1374842582-13242-2-git-send-email-kishon@ti.com>
In-Reply-To: <1374842582-13242-1-git-send-email-kishon@ti.com>
References: <1374842582-13242-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The PHY framework provides a set of APIs for the PHY drivers to
create/destroy a PHY and APIs for the PHY users to obtain a reference to the
PHY with or without using phandle. For dt-boot, the PHY drivers should
also register *PHY provider* with the framework.

PHY drivers should create the PHY by passing id and ops like init, exit,
power_on and power_off. This framework is also pm runtime enabled.

The documentation for the generic PHY framework is added in
Documentation/phy.txt and the documentation for dt binding can be found at
Documentation/devicetree/bindings/phy/phy-bindings.txt

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../devicetree/bindings/phy/phy-bindings.txt       |   66 ++
 Documentation/phy.txt                              |  166 +++++
 MAINTAINERS                                        |    8 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/phy/Kconfig                                |   18 +
 drivers/phy/Makefile                               |    5 +
 drivers/phy/phy-core.c                             |  714 ++++++++++++++++++++
 include/linux/phy/phy.h                            |  270 ++++++++
 9 files changed, 1251 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-bindings.txt
 create mode 100644 Documentation/phy.txt
 create mode 100644 drivers/phy/Kconfig
 create mode 100644 drivers/phy/Makefile
 create mode 100644 drivers/phy/phy-core.c
 create mode 100644 include/linux/phy/phy.h

diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
new file mode 100644
index 0000000..8ae844f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
@@ -0,0 +1,66 @@
+This document explains only the device tree data binding. For general
+information about PHY subsystem refer to Documentation/phy.txt
+
+PHY device node
+===============
+
+Required Properties:
+#phy-cells:	Number of cells in a PHY specifier;  The meaning of all those
+		cells is defined by the binding for the phy node. The PHY
+		provider can use the values in cells to find the appropriate
+		PHY.
+
+For example:
+
+phys: phy {
+    compatible = "xxx";
+    reg = <...>;
+    .
+    .
+    #phy-cells = <1>;
+    .
+    .
+};
+
+That node describes an IP block (PHY provider) that implements 2 different PHYs.
+In order to differentiate between these 2 PHYs, an additonal specifier should be
+given while trying to get a reference to it.
+
+PHY user node
+=============
+
+Required Properties:
+phys : the phandle for the PHY device (used by the PHY subsystem)
+phy-names : the names of the PHY corresponding to the PHYs present in the
+	    *phys* phandle
+
+Example 1:
+usb1: usb_otg_ss@xxx {
+    compatible = "xxx";
+    reg = <xxx>;
+    .
+    .
+    phys = <&usb2_phy>, <&usb3_phy>;
+    phy-names = "usb2phy", "usb3phy";
+    .
+    .
+};
+
+This node represents a controller that uses two PHYs, one for usb2 and one for
+usb3.
+
+Example 2:
+usb2: usb_otg_ss@xxx {
+    compatible = "xxx";
+    reg = <xxx>;
+    .
+    .
+    phys = <&phys 1>;
+    phy-names = "usbphy";
+    .
+    .
+};
+
+This node represents a controller that uses one of the PHYs of the PHY provider
+device defined previously. Note that the phy handle has an additional specifier
+"1" to differentiate between the two PHYs.
diff --git a/Documentation/phy.txt b/Documentation/phy.txt
new file mode 100644
index 0000000..4e056c4
--- /dev/null
+++ b/Documentation/phy.txt
@@ -0,0 +1,166 @@
+			    PHY SUBSYSTEM
+		  Kishon Vijay Abraham I <kishon@ti.com>
+
+This document explains the Generic PHY Framework along with the APIs provided,
+and how-to-use.
+
+1. Introduction
+
+*PHY* is the abbreviation for physical layer. It is used to connect a device
+to the physical medium e.g., the USB controller has a PHY to provide functions
+such as serialization, de-serialization, encoding, decoding and is responsible
+for obtaining the required data transmission rate. Note that some USB
+controllers have PHY functionality embedded into it and others use an external
+PHY. Other peripherals that use PHY include Wireless LAN, Ethernet,
+SATA etc.
+
+The intention of creating this framework is to bring the PHY drivers spread
+all over the Linux kernel to drivers/phy to increase code re-use and for
+better code maintainability.
+
+This framework will be of use only to devices that use external PHY (PHY
+functionality is not embedded within the controller).
+
+2. Registering/Unregistering the PHY provider
+
+PHY provider refers to an entity that implements one or more PHY instances.
+For the simple case where the PHY provider implements only a single instance of
+the PHY, the framework provides its own implementation of of_xlate in
+of_phy_simple_xlate. If the PHY provider implements multiple instances, it
+should provide its own implementation of of_xlate. of_xlate is used only for
+dt boot case.
+
+#define of_phy_provider_register(dev, xlate)    \
+        __of_phy_provider_register((dev), THIS_MODULE, (xlate))
+
+#define devm_of_phy_provider_register(dev, xlate)       \
+        __of_phy_provider_register((dev), THIS_MODULE, (xlate))
+
+of_phy_provider_register and devm_of_phy_provider_register macros can be used to
+register the phy_provider and it takes device and of_xlate as
+arguments. For the dt boot case, all PHY providers should use one of the above
+2 macros to register the PHY provider.
+
+void devm_of_phy_provider_unregister(struct device *dev,
+	struct phy_provider *phy_provider);
+void of_phy_provider_unregister(struct phy_provider *phy_provider);
+
+devm_of_phy_provider_unregister and of_phy_provider_unregister can be used to
+unregister the PHY.
+
+3. Creating the PHY
+
+The PHY driver should create the PHY in order for other peripheral controllers
+to make use of it. The PHY framework provides 2 APIs to create the PHY.
+
+struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
+        struct phy_init_data *init_data);
+struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
+	struct phy_init_data *init_data);
+
+The PHY drivers can use one of the above 2 APIs to create the PHY by passing
+the device pointer, phy ops and init_data.
+phy_ops is a set of function pointers for performing PHY operations such as
+init, exit, power_on and power_off. *init_data* is mandatory to get a reference
+to the PHY in the case of non-dt boot. See section *Board File Initialization*
+on how init_data should be used.
+
+Inorder to dereference the private data (in phy_ops), the phy provider driver
+can use phy_set_drvdata() after creating the PHY and use phy_get_drvdata() in
+phy_ops to get back the private data.
+
+4. Getting a reference to the PHY
+
+Before the controller can make use of the PHY, it has to get a reference to
+it. This framework provides the following APIs to get a reference to the PHY.
+
+struct phy *phy_get(struct device *dev, const char *string);
+struct phy *devm_phy_get(struct device *dev, const char *string);
+
+phy_get and devm_phy_get can be used to get the PHY. In the case of dt boot,
+the string arguments should contain the phy name as given in the dt data and
+in the case of non-dt boot, it should contain the label of the PHY.
+The only difference between the two APIs is that devm_phy_get associates the
+device with the PHY using devres on successful PHY get. On driver detach,
+release function is invoked on the the devres data and devres data is freed.
+
+5. Releasing a reference to the PHY
+
+When the controller no longer needs the PHY, it has to release the reference
+to the PHY it has obtained using the APIs mentioned in the above section. The
+PHY framework provides 2 APIs to release a reference to the PHY.
+
+void phy_put(struct phy *phy);
+void devm_phy_put(struct device *dev, struct phy *phy);
+
+Both these APIs are used to release a reference to the PHY and devm_phy_put
+destroys the devres associated with this PHY.
+
+6. Destroying the PHY
+
+When the driver that created the PHY is unloaded, it should destroy the PHY it
+created using one of the following 2 APIs.
+
+void phy_destroy(struct phy *phy);
+void devm_phy_destroy(struct device *dev, struct phy *phy);
+
+Both these APIs destroy the PHY and devm_phy_destroy destroys the devres
+associated with this PHY.
+
+7. PM Runtime
+
+This subsystem is pm runtime enabled. So while creating the PHY,
+pm_runtime_enable of the phy device created by this subsystem is called and
+while destroying the PHY, pm_runtime_disable is called. Note that the phy
+device created by this subsystem will be a child of the device that calls
+phy_create (PHY provider device).
+
+So pm_runtime_get_sync of the phy_device created by this subsystem will invoke
+pm_runtime_get_sync of PHY provider device because of parent-child relationship.
+It should also be noted that phy_power_on and phy_power_off performs
+phy_pm_runtime_get_sync and phy_pm_runtime_put respectively.
+There are exported APIs like phy_pm_runtime_get, phy_pm_runtime_get_sync,
+phy_pm_runtime_put, phy_pm_runtime_put_sync, phy_pm_runtime_allow and
+phy_pm_runtime_forbid for performing PM operations.
+
+8. Board File Initialization
+
+Certain board file initialization is necessary in order to get a reference
+to the PHY in the case of non-dt boot.
+Say we have a single device that implements 3 PHYs that of USB, SATA and PCIe,
+then in the board file the following initialization should be done.
+
+struct phy_consumer consumers[] = {
+	PHY_CONSUMER("dwc3.0", "usb"),
+	PHY_CONSUMER("pcie.0", "pcie"),
+	PHY_CONSUMER("sata.0", "sata"),
+};
+PHY_CONSUMER takes 2 parameters, first is the device name of the controller
+(PHY consumer) and second is the port name.
+
+struct phy_init_data init_data = {
+	.consumers = consumers,
+	.num_consumers = ARRAY_SIZE(consumers),
+};
+
+static const struct platform_device pipe3_phy_dev = {
+	.name = "pipe3-phy",
+	.id = -1,
+	.dev = {
+		.platform_data = {
+			.init_data = &init_data,
+		},
+	},
+};
+
+then, while doing phy_create, the PHY driver should pass this init_data
+	phy_create(dev, ops, pdata->init_data);
+
+and the controller driver (phy consumer) should pass the port name along with
+the device to get a reference to the PHY
+	phy_get(dev, "pcie");
+
+9. DeviceTree Binding
+
+The documentation for PHY dt binding can be found @
+Documentation/devicetree/bindings/phy/phy-bindings.txt
diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..96caae7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3594,6 +3594,14 @@ S:	Maintained
 F:	include/asm-generic
 F:	include/uapi/asm-generic
 
+GENERIC PHY FRAMEWORK
+M:	Kishon Vijay Abraham I <kishon@ti.com>
+L:	linux-kernel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git
+S:	Supported
+F:	drivers/phy/
+F:	include/linux/phy/
+
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/Kconfig b/drivers/Kconfig
index aa43b91..8f45144 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -166,4 +166,6 @@ source "drivers/reset/Kconfig"
 
 source "drivers/fmc/Kconfig"
 
+source "drivers/phy/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index ab93de8..687da89 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -8,6 +8,8 @@
 obj-y				+= irqchip/
 obj-y				+= bus/
 
+obj-$(CONFIG_GENERIC_PHY)	+= phy/
+
 # GPIO must come after pinctrl as gpios may need to mux pins etc
 obj-y				+= pinctrl/
 obj-y				+= gpio/
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
new file mode 100644
index 0000000..349bef2
--- /dev/null
+++ b/drivers/phy/Kconfig
@@ -0,0 +1,18 @@
+#
+# PHY
+#
+
+menu "PHY Subsystem"
+
+config GENERIC_PHY
+	tristate "PHY Core"
+	help
+	  Generic PHY support.
+
+	  This framework is designed to provide a generic interface for PHY
+	  devices present in the kernel. This layer will have the generic
+	  API by which phy drivers can create PHY using the phy framework and
+	  phy users can obtain reference to the PHY. All the users of this
+	  framework should select this config.
+
+endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
new file mode 100644
index 0000000..9e9560f
--- /dev/null
+++ b/drivers/phy/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the phy drivers.
+#
+
+obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
new file mode 100644
index 0000000..f1d15e5
--- /dev/null
+++ b/drivers/phy/phy-core.c
@@ -0,0 +1,714 @@
+/*
+ * phy-core.c  --  Generic Phy framework.
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/phy/phy.h>
+#include <linux/idr.h>
+#include <linux/pm_runtime.h>
+
+static struct class *phy_class;
+static DEFINE_MUTEX(phy_provider_mutex);
+static LIST_HEAD(phy_provider_list);
+static DEFINE_IDA(phy_ida);
+
+static int phy_get_id(void)
+{
+	int ret;
+	int id;
+
+	ret = ida_pre_get(&phy_ida, GFP_KERNEL);
+	if (!ret)
+		return -ENOMEM;
+
+	ret = ida_get_new(&phy_ida, &id);
+	if (ret < 0)
+		return ret;
+
+	return id;
+}
+
+static void devm_phy_release(struct device *dev, void *res)
+{
+	struct phy *phy = *(struct phy **)res;
+
+	phy_put(phy);
+}
+
+static void devm_phy_provider_release(struct device *dev, void *res)
+{
+	struct phy_provider *phy_provider = *(struct phy_provider **)res;
+
+	of_phy_provider_unregister(phy_provider);
+}
+
+static void devm_phy_consume(struct device *dev, void *res)
+{
+	struct phy *phy = *(struct phy **)res;
+
+	phy_destroy(phy);
+}
+
+static int devm_phy_match(struct device *dev, void *res, void *match_data)
+{
+	return res == match_data;
+}
+
+static struct phy *phy_lookup(struct device *device, const char *port)
+{
+	unsigned int count;
+	struct phy *phy;
+	struct device *dev;
+	struct phy_consumer *consumers;
+	struct class_dev_iter iter;
+
+	class_dev_iter_init(&iter, phy_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		phy = to_phy(dev);
+		count = phy->init_data->num_consumers;
+		consumers = phy->init_data->consumers;
+		while (count--) {
+			if (!strcmp(consumers->dev_name, dev_name(device)) &&
+					!strcmp(consumers->port, port)) {
+				class_dev_iter_exit(&iter);
+				return phy;
+			}
+			consumers++;
+		}
+	}
+
+	class_dev_iter_exit(&iter);
+	return ERR_PTR(-ENODEV);
+}
+
+static struct phy_provider *of_phy_provider_lookup(struct device_node *node)
+{
+	struct phy_provider *phy_provider;
+
+	list_for_each_entry(phy_provider, &phy_provider_list, list) {
+		if (phy_provider->dev->of_node == node)
+			return phy_provider;
+	}
+
+	return ERR_PTR(-EPROBE_DEFER);
+}
+
+int phy_pm_runtime_get(struct phy *phy)
+{
+	if (!pm_runtime_enabled(&phy->dev))
+		return -ENOTSUPP;
+
+	return pm_runtime_get(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_pm_runtime_get);
+
+int phy_pm_runtime_get_sync(struct phy *phy)
+{
+	if (!pm_runtime_enabled(&phy->dev))
+		return -ENOTSUPP;
+
+	return pm_runtime_get_sync(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_pm_runtime_get_sync);
+
+int phy_pm_runtime_put(struct phy *phy)
+{
+	if (!pm_runtime_enabled(&phy->dev))
+		return -ENOTSUPP;
+
+	return pm_runtime_put(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_pm_runtime_put);
+
+int phy_pm_runtime_put_sync(struct phy *phy)
+{
+	if (!pm_runtime_enabled(&phy->dev))
+		return -ENOTSUPP;
+
+	return pm_runtime_put_sync(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_pm_runtime_put_sync);
+
+void phy_pm_runtime_allow(struct phy *phy)
+{
+	if (!pm_runtime_enabled(&phy->dev))
+		return;
+
+	pm_runtime_allow(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_pm_runtime_allow);
+
+void phy_pm_runtime_forbid(struct phy *phy)
+{
+	if (!pm_runtime_enabled(&phy->dev))
+		return;
+
+	pm_runtime_forbid(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_pm_runtime_forbid);
+
+int phy_init(struct phy *phy)
+{
+	int ret;
+
+	ret = phy_pm_runtime_get_sync(phy);
+	if (ret < 0 && ret != -ENOTSUPP)
+		return ret;
+
+	mutex_lock(&phy->mutex);
+	if (phy->init_count++ == 0 && phy->ops->init) {
+		ret = phy->ops->init(phy);
+		if (ret < 0) {
+			dev_err(&phy->dev, "phy init failed --> %d\n", ret);
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+	phy_pm_runtime_put(phy);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_init);
+
+int phy_exit(struct phy *phy)
+{
+	int ret;
+
+	ret = phy_pm_runtime_get_sync(phy);
+	if (ret < 0 && ret != -ENOTSUPP)
+		return ret;
+
+	mutex_lock(&phy->mutex);
+	if (--phy->init_count == 0 && phy->ops->exit) {
+		ret = phy->ops->exit(phy);
+		if (ret < 0) {
+			dev_err(&phy->dev, "phy exit failed --> %d\n", ret);
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+	phy_pm_runtime_put(phy);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_exit);
+
+int phy_power_on(struct phy *phy)
+{
+	int ret = -ENOTSUPP;
+
+	ret = phy_pm_runtime_get_sync(phy);
+	if (ret < 0 && ret != -ENOTSUPP)
+		return ret;
+
+	mutex_lock(&phy->mutex);
+	if (phy->power_count++ == 0 && phy->ops->power_on) {
+		ret = phy->ops->power_on(phy);
+		if (ret < 0) {
+			dev_err(&phy->dev, "phy poweron failed --> %d\n", ret);
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_power_on);
+
+int phy_power_off(struct phy *phy)
+{
+	int ret = -ENOTSUPP;
+
+	mutex_lock(&phy->mutex);
+	if (--phy->power_count == 0 && phy->ops->power_off) {
+		ret =  phy->ops->power_off(phy);
+		if (ret < 0) {
+			dev_err(&phy->dev, "phy poweroff failed --> %d\n", ret);
+			goto out;
+		}
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+	phy_pm_runtime_put(phy);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_power_off);
+
+/**
+ * of_phy_get() - lookup and obtain a reference to a phy by phandle
+ * @dev: device that requests this phy
+ * @index: the index of the phy
+ *
+ * Returns the phy associated with the given phandle value,
+ * after getting a refcount to it or -ENODEV if there is no such phy or
+ * -EPROBE_DEFER if there is a phandle to the phy, but the device is
+ * not yet loaded. This function uses of_xlate call back function provided
+ * while registering the phy_provider to find the phy instance.
+ */
+static struct phy *of_phy_get(struct device *dev, int index)
+{
+	int ret;
+	struct phy_provider *phy_provider;
+	struct phy *phy = NULL;
+	struct of_phandle_args args;
+
+	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
+		index, &args);
+	if (ret) {
+		dev_dbg(dev, "failed to get phy in %s node\n",
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	mutex_lock(&phy_provider_mutex);
+	phy_provider = of_phy_provider_lookup(args.np);
+	if (IS_ERR(phy_provider) || !try_module_get(phy_provider->owner)) {
+		phy = ERR_PTR(-EPROBE_DEFER);
+		goto err0;
+	}
+
+	phy = phy_provider->of_xlate(phy_provider->dev, &args);
+	module_put(phy_provider->owner);
+
+err0:
+	mutex_unlock(&phy_provider_mutex);
+	of_node_put(args.np);
+
+	return phy;
+}
+
+/**
+ * phy_put() - release the PHY
+ * @phy: the phy returned by phy_get()
+ *
+ * Releases a refcount the caller received from phy_get().
+ */
+void phy_put(struct phy *phy)
+{
+	if (IS_ERR(phy))
+		return;
+
+	module_put(phy->ops->owner);
+	put_device(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_put);
+
+/**
+ * devm_phy_put() - release the PHY
+ * @dev: device that wants to release this phy
+ * @phy: the phy returned by devm_phy_get()
+ *
+ * destroys the devres associated with this phy and invokes phy_put
+ * to release the phy.
+ */
+void devm_phy_put(struct device *dev, struct phy *phy)
+{
+	int r;
+
+	r = devres_destroy(dev, devm_phy_release, devm_phy_match, phy);
+	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
+}
+EXPORT_SYMBOL_GPL(devm_phy_put);
+
+/**
+ * of_phy_simple_xlate() - returns the phy instance from phy provider
+ * @dev: the PHY provider device
+ * @args: of_phandle_args (not used here)
+ *
+ * Intended to be used by phy provider for the common case where #phy-cells is
+ * 0. For other cases where #phy-cells is greater than '0', the phy provider
+ * should provide a custom of_xlate function that reads the *args* and returns
+ * the appropriate phy.
+ */
+struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
+	*args)
+{
+	struct phy *phy;
+	struct class_dev_iter iter;
+	struct device_node *node = dev->of_node;
+
+	class_dev_iter_init(&iter, phy_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		phy = to_phy(dev);
+		if (node != phy->dev.of_node)
+			continue;
+
+		class_dev_iter_exit(&iter);
+		return phy;
+	}
+
+	class_dev_iter_exit(&iter);
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
+
+/**
+ * phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @string: the phy name as given in the dt data or the name of the controller
+ * port for non-dt case
+ *
+ * Returns the phy driver, after getting a refcount to it; or
+ * -ENODEV if there is no such phy.  The caller is responsible for
+ * calling phy_put() to release that count.
+ */
+struct phy *phy_get(struct device *dev, const char *string)
+{
+	int index = 0;
+	struct phy *phy = NULL;
+
+	if (string == NULL) {
+		dev_WARN(dev, "missing string\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (dev->of_node) {
+		index = of_property_match_string(dev->of_node, "phy-names",
+			string);
+		phy = of_phy_get(dev, index);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "unable to find phy\n");
+			return phy;
+		}
+	} else {
+		phy = phy_lookup(dev, string);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "unable to find phy\n");
+			return phy;
+		}
+	}
+
+	if (!try_module_get(phy->ops->owner))
+		return ERR_PTR(-EPROBE_DEFER);
+
+	get_device(&phy->dev);
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(phy_get);
+
+/**
+ * devm_phy_get() - lookup and obtain a reference to a phy.
+ * @dev: device that requests this phy
+ * @string: the phy name as given in the dt data or phy device name
+ * for non-dt case
+ *
+ * Gets the phy using phy_get(), and associates a device with it using
+ * devres. On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ */
+struct phy *devm_phy_get(struct device *dev, const char *string)
+{
+	struct phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy = phy_get(dev, string);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(devm_phy_get);
+
+/**
+ * phy_create() - create a new phy
+ * @dev: device that is creating the new phy
+ * @ops: function pointers for performing phy operations
+ * @init_data: contains the list of PHY consumers or NULL
+ *
+ * Called to create a phy using phy framework.
+ */
+struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
+	struct phy_init_data *init_data)
+{
+	int ret;
+	int id;
+	struct phy *phy;
+
+	if (!dev) {
+		dev_WARN(dev, "no device provided for PHY\n");
+		ret = -EINVAL;
+		goto err0;
+	}
+
+	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
+	if (!phy) {
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	id = phy_get_id();
+	if (id < 0) {
+		dev_err(dev, "unable to get id\n");
+		ret = id;
+		goto err0;
+	}
+
+	device_initialize(&phy->dev);
+	mutex_init(&phy->mutex);
+
+	phy->dev.class = phy_class;
+	phy->dev.parent = dev;
+	phy->dev.of_node = dev->of_node;
+	phy->id = id;
+	phy->ops = ops;
+	phy->init_data = init_data;
+
+	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
+	if (ret)
+		goto err1;
+
+	ret = device_add(&phy->dev);
+	if (ret)
+		goto err1;
+
+	if (pm_runtime_enabled(dev)) {
+		pm_runtime_enable(&phy->dev);
+		pm_runtime_no_callbacks(&phy->dev);
+	}
+
+	return phy;
+
+err1:
+	ida_remove(&phy_ida, phy->id);
+	put_device(&phy->dev);
+	kfree(phy);
+
+err0:
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(phy_create);
+
+/**
+ * devm_phy_create() - create a new phy
+ * @dev: device that is creating the new phy
+ * @ops: function pointers for performing phy operations
+ * @init_data: contains the list of PHY consumers or NULL
+ *
+ * Creates a new PHY device adding it to the PHY class.
+ * While at that, it also associates the device with the phy using devres.
+ * On driver detach, release function is invoked on the devres data,
+ * then, devres data is freed.
+ */
+struct phy *devm_phy_create(struct device *dev, const struct phy_ops *ops,
+	struct phy_init_data *init_data)
+{
+	struct phy **ptr, *phy;
+
+	ptr = devres_alloc(devm_phy_consume, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy = phy_create(dev, ops, init_data);
+	if (!IS_ERR(phy)) {
+		*ptr = phy;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return phy;
+}
+EXPORT_SYMBOL_GPL(devm_phy_create);
+
+/**
+ * phy_destroy() - destroy the phy
+ * @phy: the phy to be destroyed
+ *
+ * Called to destroy the phy.
+ */
+void phy_destroy(struct phy *phy)
+{
+	pm_runtime_disable(&phy->dev);
+	device_unregister(&phy->dev);
+}
+EXPORT_SYMBOL_GPL(phy_destroy);
+
+/**
+ * devm_phy_destroy() - destroy the PHY
+ * @dev: device that wants to release this phy
+ * @phy: the phy returned by devm_phy_get()
+ *
+ * destroys the devres associated with this phy and invokes phy_destroy
+ * to destroy the phy.
+ */
+void devm_phy_destroy(struct device *dev, struct phy *phy)
+{
+	int r;
+
+	r = devres_destroy(dev, devm_phy_consume, devm_phy_match, phy);
+	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
+}
+EXPORT_SYMBOL_GPL(devm_phy_destroy);
+
+/**
+ * __of_phy_provider_register() - create/register phy provider with the framework
+ * @dev: struct device of the phy provider
+ * @owner: the module owner containing of_xlate
+ * @of_xlate: function pointer to obtain phy instance from phy provider
+ *
+ * Creates struct phy_provider from dev and of_xlate function pointer.
+ * This is used in the case of dt boot for finding the phy instance from
+ * phy provider.
+ */
+struct phy_provider *__of_phy_provider_register(struct device *dev,
+	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
+	struct of_phandle_args *args))
+{
+	struct phy_provider *phy_provider;
+
+	phy_provider = kzalloc(sizeof(*phy_provider), GFP_KERNEL);
+	if (!phy_provider)
+		return ERR_PTR(-ENOMEM);
+
+	phy_provider->dev = dev;
+	phy_provider->owner = owner;
+	phy_provider->of_xlate = of_xlate;
+
+	mutex_lock(&phy_provider_mutex);
+	list_add_tail(&phy_provider->list, &phy_provider_list);
+	mutex_unlock(&phy_provider_mutex);
+
+	return phy_provider;
+}
+EXPORT_SYMBOL_GPL(__of_phy_provider_register);
+
+/**
+ * __devm_of_phy_provider_register() - create/register phy provider with the
+ * framework
+ * @dev: struct device of the phy provider
+ * @owner: the module owner containing of_xlate
+ * @of_xlate: function pointer to obtain phy instance from phy provider
+ *
+ * Creates struct phy_provider from dev and of_xlate function pointer.
+ * This is used in the case of dt boot for finding the phy instance from
+ * phy provider. While at that, it also associates the device with the
+ * phy provider using devres. On driver detach, release function is invoked
+ * on the devres data, then, devres data is freed.
+ */
+struct phy_provider *__devm_of_phy_provider_register(struct device *dev,
+	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
+	struct of_phandle_args *args))
+{
+	struct phy_provider **ptr, *phy_provider;
+
+	ptr = devres_alloc(devm_phy_provider_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	phy_provider = __of_phy_provider_register(dev, owner, of_xlate);
+	if (!IS_ERR(phy_provider)) {
+		*ptr = phy_provider;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return phy_provider;
+}
+EXPORT_SYMBOL_GPL(__devm_of_phy_provider_register);
+
+/**
+ * of_phy_provider_unregister() - unregister phy provider from the framework
+ * @phy_provider: phy provider returned by of_phy_provider_register()
+ *
+ * Removes the phy_provider created using of_phy_provider_register().
+ */
+void of_phy_provider_unregister(struct phy_provider *phy_provider)
+{
+	if (IS_ERR(phy_provider))
+		return;
+
+	mutex_lock(&phy_provider_mutex);
+	list_del(&phy_provider->list);
+	kfree(phy_provider);
+	mutex_unlock(&phy_provider_mutex);
+}
+EXPORT_SYMBOL_GPL(of_phy_provider_unregister);
+
+/**
+ * devm_of_phy_provider_unregister() - remove phy provider from the framework
+ * @dev: struct device of the phy provider
+ *
+ * destroys the devres associated with this phy provider and invokes
+ * of_phy_provider_unregister to unregister the phy provider.
+ */
+void devm_of_phy_provider_unregister(struct device *dev,
+	struct phy_provider *phy_provider) {
+	int r;
+
+	r = devres_destroy(dev, devm_phy_provider_release, devm_phy_match,
+		phy_provider);
+	dev_WARN_ONCE(dev, r, "couldn't find PHY provider device resource\n");
+}
+EXPORT_SYMBOL_GPL(devm_of_phy_provider_unregister);
+
+/**
+ * phy_release() - release the phy
+ * @dev: the dev member within phy
+ *
+ * When the last reference to the device is removed, it is called
+ * from the embedded kobject as release method.
+ */
+static void phy_release(struct device *dev)
+{
+	struct phy *phy;
+
+	phy = to_phy(dev);
+	dev_vdbg(dev, "releasing '%s'\n", dev_name(dev));
+	ida_remove(&phy_ida, phy->id);
+	kfree(phy);
+}
+
+static int __init phy_core_init(void)
+{
+	phy_class = class_create(THIS_MODULE, "phy");
+	if (IS_ERR(phy_class)) {
+		pr_err("failed to create phy class --> %ld\n",
+			PTR_ERR(phy_class));
+		return PTR_ERR(phy_class);
+	}
+
+	phy_class->dev_release = phy_release;
+
+	return 0;
+}
+module_init(phy_core_init);
+
+static void __exit phy_core_exit(void)
+{
+	class_destroy(phy_class);
+}
+module_exit(phy_core_exit);
+
+MODULE_DESCRIPTION("Generic PHY Framework");
+MODULE_AUTHOR("Kishon Vijay Abraham I <kishon@ti.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
new file mode 100644
index 0000000..e444b23
--- /dev/null
+++ b/include/linux/phy/phy.h
@@ -0,0 +1,270 @@
+/*
+ * phy.h -- generic phy header file
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Author: Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DRIVERS_PHY_H
+#define __DRIVERS_PHY_H
+
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/device.h>
+#include <linux/pm_runtime.h>
+
+struct phy;
+
+/**
+ * struct phy_ops - set of function pointers for performing phy operations
+ * @init: operation to be performed for initializing phy
+ * @exit: operation to be performed while exiting
+ * @power_on: powering on the phy
+ * @power_off: powering off the phy
+ * @owner: the module owner containing the ops
+ */
+struct phy_ops {
+	int	(*init)(struct phy *phy);
+	int	(*exit)(struct phy *phy);
+	int	(*power_on)(struct phy *phy);
+	int	(*power_off)(struct phy *phy);
+	struct module *owner;
+};
+
+/**
+ * struct phy - represents the phy device
+ * @dev: phy device
+ * @id: id of the phy device
+ * @ops: function pointers for performing phy operations
+ * @init_data: list of PHY consumers (non-dt only)
+ * @mutex: mutex to protect phy_ops
+ * @init_count: used to protect when the PHY is used by multiple consumers
+ * @power_count: used to protect when the PHY is used by multiple consumers
+ */
+struct phy {
+	struct device		dev;
+	int			id;
+	const struct phy_ops	*ops;
+	struct phy_init_data	*init_data;
+	struct mutex		mutex;
+	int			init_count;
+	int			power_count;
+};
+
+/**
+ * struct phy_provider - represents the phy provider
+ * @dev: phy provider device
+ * @owner: the module owner having of_xlate
+ * @of_xlate: function pointer to obtain phy instance from phy pointer
+ * @list: to maintain a linked list of PHY providers
+ */
+struct phy_provider {
+	struct device		*dev;
+	struct module		*owner;
+	struct list_head	list;
+	struct phy * (*of_xlate)(struct device *dev,
+		struct of_phandle_args *args);
+};
+
+/**
+ * struct phy_consumer - represents the phy consumer
+ * @dev_name: the device name of the controller that will use this PHY device
+ * @port: name given to the consumer port
+ */
+struct phy_consumer {
+	const char *dev_name;
+	const char *port;
+};
+
+/**
+ * struct phy_init_data - contains the list of PHY consumers
+ * @num_consumers: number of consumers for this PHY device
+ * @consumers: list of PHY consumers
+ */
+struct phy_init_data {
+	unsigned int num_consumers;
+	struct phy_consumer *consumers;
+};
+
+#define PHY_CONSUMER(_dev_name, _port)				\
+{								\
+	.dev_name	= _dev_name,				\
+	.port		= _port,				\
+}
+
+#define	to_phy(dev)	(container_of((dev), struct phy, dev))
+
+#define	of_phy_provider_register(dev, xlate)	\
+	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
+
+#define	devm_of_phy_provider_register(dev, xlate)	\
+	__of_phy_provider_register((dev), THIS_MODULE, (xlate))
+
+static inline void phy_set_drvdata(struct phy *phy, void *data)
+{
+	dev_set_drvdata(&phy->dev, data);
+}
+
+static inline void *phy_get_drvdata(struct phy *phy)
+{
+	return dev_get_drvdata(&phy->dev);
+}
+
+#if IS_ENABLED(CONFIG_GENERIC_PHY)
+extern int phy_pm_runtime_get(struct phy *phy);
+extern int phy_pm_runtime_get_sync(struct phy *phy);
+extern int phy_pm_runtime_put(struct phy *phy);
+extern int phy_pm_runtime_put_sync(struct phy *phy);
+extern void phy_pm_runtime_allow(struct phy *phy);
+extern void phy_pm_runtime_forbid(struct phy *phy);
+extern int phy_init(struct phy *phy);
+extern int phy_exit(struct phy *phy);
+extern int phy_power_on(struct phy *phy);
+extern int phy_power_off(struct phy *phy);
+extern struct phy *phy_get(struct device *dev, const char *string);
+extern struct phy *devm_phy_get(struct device *dev, const char *string);
+extern void phy_put(struct phy *phy);
+extern void devm_phy_put(struct device *dev, struct phy *phy);
+extern struct phy *of_phy_simple_xlate(struct device *dev,
+	struct of_phandle_args *args);
+extern struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
+	struct phy_init_data *init_data);
+extern struct phy *devm_phy_create(struct device *dev,
+	const struct phy_ops *ops, struct phy_init_data *init_data);
+extern void phy_destroy(struct phy *phy);
+extern void devm_phy_destroy(struct device *dev, struct phy *phy);
+extern struct phy_provider *__of_phy_provider_register(struct device *dev,
+	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
+	struct of_phandle_args *args));
+extern struct phy_provider *__devm_of_phy_provider_register(struct device *dev,
+	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
+	struct of_phandle_args *args));
+extern void of_phy_provider_unregister(struct phy_provider *phy_provider);
+extern void devm_of_phy_provider_unregister(struct device *dev,
+	struct phy_provider *phy_provider);
+#else
+static inline int phy_pm_runtime_get(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline int phy_pm_runtime_get_sync(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline int phy_pm_runtime_put(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline int phy_pm_runtime_put_sync(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline void phy_pm_runtime_allow(struct phy *phy)
+{
+	return;
+}
+
+static inline void phy_pm_runtime_forbid(struct phy *phy)
+{
+	return;
+}
+
+static inline int phy_init(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline int phy_exit(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline int phy_power_on(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline int phy_power_off(struct phy *phy)
+{
+	return -ENOSYS;
+}
+
+static inline struct phy *phy_get(struct device *dev, const char *string)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct phy *devm_phy_get(struct device *dev, const char *string)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void phy_put(struct phy *phy)
+{
+}
+
+static inline void devm_phy_put(struct device *dev, struct phy *phy)
+{
+}
+
+static inline struct phy *of_phy_simple_xlate(struct device *dev,
+	struct of_phandle_args *args)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct phy *phy_create(struct device *dev,
+	const struct phy_ops *ops, struct phy_init_data *init_data)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct phy *devm_phy_create(struct device *dev,
+	const struct phy_ops *ops, struct phy_init_data *init_data)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void phy_destroy(struct phy *phy)
+{
+}
+
+static inline void devm_phy_destroy(struct device *dev, struct phy *phy)
+{
+}
+
+static inline struct phy_provider *__of_phy_provider_register(
+	struct device *dev, struct module *owner, struct phy * (*of_xlate)(
+	struct device *dev, struct of_phandle_args *args))
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct phy_provider *__devm_of_phy_provider_register(struct device
+	*dev, struct module *owner, struct phy * (*of_xlate)(struct device *dev,
+	struct of_phandle_args *args))
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline void of_phy_provider_unregister(struct phy_provider *phy_provider)
+{
+}
+
+static inline void devm_of_phy_provider_unregister(struct device *dev,
+	struct phy_provider *phy_provider)
+{
+}
+#endif
+
+#endif /* __DRIVERS_PHY_H */
-- 
1.7.10.4

