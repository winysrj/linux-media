Return-path: <mchehab@pedra>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54943 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab0KJM0t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:26:49 -0500
From: Jimmy Rubin <jimmy.rubin@stericsson.com>
To: <linux-fbdev@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	Jimmy Rubin <jimmy.rubin@stericsson.com>
Subject: [PATCH 09/10] MCDE: Add build files and bus
Date: Wed, 10 Nov 2010 13:04:12 +0100
Message-ID: <1289390653-6111-10-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-9-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-3-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-4-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-5-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-6-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-7-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-8-git-send-email-jimmy.rubin@stericsson.com>
 <1289390653-6111-9-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for the MCDE, Memory-to-display controller,
found in the ST-Ericsson ux500 products.

This patch adds the necessary build files for MCDE and the bus that
all displays are connected to.

Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij.stericsson.com>
---
 drivers/video/Kconfig         |    2 +
 drivers/video/Makefile        |    1 +
 drivers/video/mcde/Kconfig    |   39 ++++++
 drivers/video/mcde/Makefile   |   12 ++
 drivers/video/mcde/mcde_bus.c |  259 +++++++++++++++++++++++++++++++++++++++++
 drivers/video/mcde/mcde_mod.c |   67 +++++++++++
 6 files changed, 380 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/mcde/Kconfig
 create mode 100644 drivers/video/mcde/Makefile
 create mode 100644 drivers/video/mcde/mcde_bus.c
 create mode 100644 drivers/video/mcde/mcde_mod.c

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 935cdc2..04aecf4 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2260,6 +2260,8 @@ config FB_JZ4740
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 
+source "drivers/video/mcde/Kconfig"
+
 source "drivers/video/backlight/Kconfig"
 source "drivers/video/display/Kconfig"
 
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 485e8ed..325cdcc 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_FB_SH_MOBILE_HDMI)	  += sh_mobile_hdmi.o
 obj-$(CONFIG_FB_SH_MOBILE_LCDC)	  += sh_mobile_lcdcfb.o
 obj-$(CONFIG_FB_OMAP)             += omap/
 obj-y                             += omap2/
+obj-$(CONFIG_FB_MCDE)             += mcde/
 obj-$(CONFIG_XEN_FBDEV_FRONTEND)  += xen-fbfront.o
 obj-$(CONFIG_FB_CARMINE)          += carminefb.o
 obj-$(CONFIG_FB_MB862XX)	  += mb862xx/
diff --git a/drivers/video/mcde/Kconfig b/drivers/video/mcde/Kconfig
new file mode 100644
index 0000000..5dab37b
--- /dev/null
+++ b/drivers/video/mcde/Kconfig
@@ -0,0 +1,39 @@
+config FB_MCDE
+	tristate "MCDE support"
+	depends on FB
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	---help---
+	  This enables support for MCDE based frame buffer driver.
+
+	  Please read the file <file:Documentation/fb/mcde.txt>
+
+config MCDE_DISPLAY_GENERIC_DSI
+	tristate "Generic display driver"
+	depends on FB_MCDE
+
+config FB_MCDE_DEBUG
+	bool "MCDE debug messages"
+	depends on FB_MCDE
+	---help---
+	  Say Y here if you want the MCDE driver to output debug messages
+
+config FB_MCDE_VDEBUG
+	bool "MCDE verbose debug messages"
+	depends on FB_MCDE_DEBUG
+	---help---
+	  Say Y here if you want the MCDE driver to output more debug messages
+
+config MCDE_FB_AVOID_REALLOC
+	bool "MCDE early allocate framebuffer"
+	default n
+	depends on FB_MCDE
+	---help---
+	  If you say Y here maximum frame buffer size is allocated and
+	  used for all resolutions. If you say N here, the frame buffer is
+	  reallocated when resolution is changed. This reallocation might
+	  fail because of fragmented memory. Note that this memory will
+	  never be deallocated, while the MCDE framebuffer is used.
+
diff --git a/drivers/video/mcde/Makefile b/drivers/video/mcde/Makefile
new file mode 100644
index 0000000..f90979a
--- /dev/null
+++ b/drivers/video/mcde/Makefile
@@ -0,0 +1,12 @@
+
+mcde-objs			:= mcde_mod.o mcde_hw.o mcde_dss.o mcde_display.o mcde_bus.o mcde_fb.o
+obj-$(CONFIG_FB_MCDE)		+= mcde.o
+
+obj-$(CONFIG_MCDE_DISPLAY_GENERIC_DSI)	+= display-generic_dsi.o
+
+ifdef CONFIG_FB_MCDE_DEBUG
+EXTRA_CFLAGS += -DDEBUG
+endif
+ifdef CONFIG_FB_MCDE_VDEBUG
+EXTRA_CFLAGS += -DVERBOSE_DEBUG
+endif
diff --git a/drivers/video/mcde/mcde_bus.c b/drivers/video/mcde/mcde_bus.c
new file mode 100644
index 0000000..bc1f048
--- /dev/null
+++ b/drivers/video/mcde/mcde_bus.c
@@ -0,0 +1,259 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE display bus driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/notifier.h>
+
+#include <video/mcde/mcde_display.h>
+#include <video/mcde/mcde_dss.h>
+
+#define to_mcde_display_driver(__drv) \
+	container_of((__drv), struct mcde_display_driver, driver)
+
+static BLOCKING_NOTIFIER_HEAD(bus_notifier_list);
+
+static int mcde_drv_suspend(struct device *_dev, pm_message_t state);
+static int mcde_drv_resume(struct device *_dev);
+struct bus_type mcde_bus_type;
+
+static int mcde_suspend_device(struct device *dev, void *data)
+{
+	pm_message_t* state = (pm_message_t *) data;
+	if (dev->driver->suspend)
+		return dev->driver->suspend(dev, *state);
+	return 0;
+}
+
+static int mcde_resume_device(struct device *dev, void *data)
+{
+	if (dev->driver->resume)
+		return dev->driver->resume(dev);
+	return 0;
+}
+
+/* Bus driver */
+
+static int mcde_bus_match(struct device *_dev, struct device_driver *driver)
+{
+	pr_debug("Matching device %s with driver %s\n",
+		dev_name(_dev), driver->name);
+
+	return strncmp(dev_name(_dev), driver->name, strlen(driver->name)) == 0;
+}
+
+static int mcde_bus_suspend(struct device *_dev, pm_message_t state)
+{
+	int ret;
+	ret = bus_for_each_dev(&mcde_bus_type, NULL, &state,
+				mcde_suspend_device);
+	if (ret) {
+		/* TODO Resume all suspended devices */
+		/* mcde_bus_resume(dev); */
+		return ret;
+	}
+	return 0;
+}
+
+static int mcde_bus_resume(struct device *_dev)
+{
+	return bus_for_each_dev(&mcde_bus_type, NULL, NULL, mcde_resume_device);
+}
+
+struct bus_type mcde_bus_type = {
+	.name = "mcde_bus",
+	.match = mcde_bus_match,
+	.suspend = mcde_bus_suspend,
+	.resume = mcde_bus_resume,
+};
+
+static int mcde_drv_probe(struct device *_dev)
+{
+	struct mcde_display_driver *drv = to_mcde_display_driver(_dev->driver);
+	struct mcde_display_device *dev = to_mcde_display_device(_dev);
+
+	return drv->probe(dev);
+}
+
+static int mcde_drv_remove(struct device *_dev)
+{
+	struct mcde_display_driver *drv = to_mcde_display_driver(_dev->driver);
+	struct mcde_display_device *dev = to_mcde_display_device(_dev);
+
+	return drv->remove(dev);
+}
+
+static void mcde_drv_shutdown(struct device *_dev)
+{
+	struct mcde_display_driver *drv = to_mcde_display_driver(_dev->driver);
+	struct mcde_display_device *dev = to_mcde_display_device(_dev);
+
+	drv->shutdown(dev);
+}
+
+static int mcde_drv_suspend(struct device *_dev, pm_message_t state)
+{
+	struct mcde_display_driver *drv = to_mcde_display_driver(_dev->driver);
+	struct mcde_display_device *dev = to_mcde_display_device(_dev);
+
+	return drv->suspend(dev, state);
+}
+
+static int mcde_drv_resume(struct device *_dev)
+{
+	struct mcde_display_driver *drv = to_mcde_display_driver(_dev->driver);
+	struct mcde_display_device *dev = to_mcde_display_device(_dev);
+
+	return drv->resume(dev);
+}
+
+/* Bus device */
+
+static void mcde_bus_release(struct device *dev)
+{
+}
+
+struct device mcde_bus = {
+	.init_name = "mcde_bus",
+	.release  = mcde_bus_release
+};
+
+/* Public bus API */
+
+int mcde_display_driver_register(struct mcde_display_driver *drv)
+{
+	drv->driver.bus = &mcde_bus_type;
+	if (drv->probe)
+		drv->driver.probe = mcde_drv_probe;
+	if (drv->remove)
+		drv->driver.remove = mcde_drv_remove;
+	if (drv->shutdown)
+		drv->driver.shutdown = mcde_drv_shutdown;
+	if (drv->suspend)
+		drv->driver.suspend = mcde_drv_suspend;
+	if (drv->resume)
+		drv->driver.resume = mcde_drv_resume;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL(mcde_display_driver_register);
+
+void mcde_display_driver_unregister(struct mcde_display_driver *drv)
+{
+	driver_unregister(&drv->driver);
+}
+EXPORT_SYMBOL(mcde_display_driver_unregister);
+
+static void mcde_display_dev_release(struct device *dev)
+{
+	/* Do nothing */
+}
+
+int mcde_display_device_register(struct mcde_display_device *dev)
+{
+	/* Setup device */
+	if (!dev)
+		return -EINVAL;
+	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	dev->dev.bus = &mcde_bus_type;
+	if (dev->dev.parent != NULL)
+		dev->dev.parent = &mcde_bus;
+	dev->dev.release = mcde_display_dev_release;
+	if (dev->id != -1)
+		dev_set_name(&dev->dev, "%s.%d", dev->name,  dev->id);
+	else
+		dev_set_name(&dev->dev, dev->name);
+
+	mcde_display_init_device(dev);
+
+	return device_register(&dev->dev);
+}
+EXPORT_SYMBOL(mcde_display_device_register);
+
+void mcde_display_device_unregister(struct mcde_display_device *dev)
+{
+	device_unregister(&dev->dev);
+}
+EXPORT_SYMBOL(mcde_display_device_unregister);
+
+/* Notifications */
+int mcde_dss_register_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&bus_notifier_list, nb);
+}
+EXPORT_SYMBOL(mcde_dss_register_notifier);
+
+int mcde_dss_unregister_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&bus_notifier_list, nb);
+}
+EXPORT_SYMBOL(mcde_dss_unregister_notifier);
+
+static int bus_notify_callback(struct notifier_block *nb,
+	unsigned long event, void *dev)
+{
+	struct mcde_display_device *ddev = to_mcde_display_device(dev);
+
+	if (event == BUS_NOTIFY_BOUND_DRIVER) {
+		ddev->initialized = true;
+		blocking_notifier_call_chain(&bus_notifier_list,
+			MCDE_DSS_EVENT_DISPLAY_REGISTERED, ddev);
+	} else if (event == BUS_NOTIFY_UNBIND_DRIVER) {
+		ddev->initialized = false;
+		blocking_notifier_call_chain(&bus_notifier_list,
+			MCDE_DSS_EVENT_DISPLAY_UNREGISTERED, ddev);
+	}
+	return 0;
+}
+
+struct notifier_block bus_nb = {
+	.notifier_call = bus_notify_callback,
+};
+
+/* Driver init/exit */
+
+int __init mcde_display_init(void)
+{
+	int ret;
+
+	ret = bus_register(&mcde_bus_type);
+	if (ret) {
+		pr_warning("Unable to register bus type\n");
+		return ret;
+	}
+	ret = device_register(&mcde_bus);
+	if (ret) {
+		pr_warning("Unable to register bus device\n");
+		goto no_device_registration;
+	}
+	ret = bus_register_notifier(&mcde_bus_type, &bus_nb);
+	if (ret) {
+		pr_warning("Unable to register bus notifier\n");
+		goto no_bus_notifier;
+	}
+
+	return 0;
+
+no_bus_notifier:
+	device_unregister(&mcde_bus);
+no_device_registration:
+	bus_unregister(&mcde_bus_type);
+	return ret;
+}
+
+void mcde_display_exit(void)
+{
+	bus_unregister_notifier(&mcde_bus_type, &bus_nb);
+	device_unregister(&mcde_bus);
+	bus_unregister(&mcde_bus_type);
+}
diff --git a/drivers/video/mcde/mcde_mod.c b/drivers/video/mcde/mcde_mod.c
new file mode 100644
index 0000000..297857f
--- /dev/null
+++ b/drivers/video/mcde/mcde_mod.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include <video/mcde/mcde.h>
+#include <video/mcde/mcde_fb.h>
+#include <video/mcde/mcde_dss.h>
+#include <video/mcde/mcde_display.h>
+
+/* Module init */
+
+static int __init mcde_subsystem_init(void)
+{
+	int ret;
+	pr_info("MCDE subsystem init begin\n");
+
+	/* MCDE module init sequence */
+	ret = mcde_init();
+	if (ret)
+		return ret;
+	ret = mcde_display_init();
+	if (ret)
+		goto mcde_display_failed;
+	ret = mcde_dss_init();
+	if (ret)
+		goto mcde_dss_failed;
+	ret = mcde_fb_init();
+	if (ret)
+		goto mcde_fb_failed;
+	pr_info("MCDE subsystem init done\n");
+
+	return 0;
+mcde_fb_failed:
+	mcde_dss_exit();
+mcde_dss_failed:
+	mcde_display_exit();
+mcde_display_failed:
+	mcde_exit();
+	return ret;
+}
+#ifdef MODULE
+module_init(mcde_subsystem_init);
+#else
+fs_initcall(mcde_subsystem_init);
+#endif
+
+static void __exit mcde_module_exit(void)
+{
+	mcde_exit();
+	mcde_display_exit();
+	mcde_dss_exit();
+}
+module_exit(mcde_module_exit);
+
+MODULE_AUTHOR("Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ST-Ericsson MCDE driver");
+
-- 
1.6.3.3

