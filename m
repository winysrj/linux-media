Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaHLVuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:32 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/10] [media] as102: promote it out of staging
Date: Tue, 12 Aug 2014 18:50:15 -0300
Message-Id: <1407880224-374-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is stable and doesn't contain any really serious
issue. Move it out of staging.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/Kconfig                      |   1 +
 drivers/media/usb/Makefile                     |   1 +
 drivers/media/usb/as102/Kconfig                |   8 +
 drivers/media/usb/as102/Makefile               |   6 +
 drivers/media/usb/as102/as102_drv.c            | 276 ++++++++++++
 drivers/media/usb/as102/as102_drv.h            |  92 ++++
 drivers/media/usb/as102/as102_fe.c             | 566 +++++++++++++++++++++++++
 drivers/media/usb/as102/as102_fw.c             | 232 ++++++++++
 drivers/media/usb/as102/as102_fw.h             |  38 ++
 drivers/media/usb/as102/as102_usb_drv.c        | 479 +++++++++++++++++++++
 drivers/media/usb/as102/as102_usb_drv.h        |  61 +++
 drivers/media/usb/as102/as10x_cmd.c            | 418 ++++++++++++++++++
 drivers/media/usb/as102/as10x_cmd.h            | 529 +++++++++++++++++++++++
 drivers/media/usb/as102/as10x_cmd_cfg.c        | 206 +++++++++
 drivers/media/usb/as102/as10x_cmd_stream.c     | 211 +++++++++
 drivers/media/usb/as102/as10x_handle.h         |  54 +++
 drivers/media/usb/as102/as10x_types.h          | 194 +++++++++
 drivers/staging/media/Kconfig                  |   2 -
 drivers/staging/media/Makefile                 |   1 -
 drivers/staging/media/as102/Kconfig            |   8 -
 drivers/staging/media/as102/Makefile           |   6 -
 drivers/staging/media/as102/as102_drv.c        | 276 ------------
 drivers/staging/media/as102/as102_drv.h        |  92 ----
 drivers/staging/media/as102/as102_fe.c         | 566 -------------------------
 drivers/staging/media/as102/as102_fw.c         | 232 ----------
 drivers/staging/media/as102/as102_fw.h         |  38 --
 drivers/staging/media/as102/as102_usb_drv.c    | 479 ---------------------
 drivers/staging/media/as102/as102_usb_drv.h    |  61 ---
 drivers/staging/media/as102/as10x_cmd.c        | 418 ------------------
 drivers/staging/media/as102/as10x_cmd.h        | 529 -----------------------
 drivers/staging/media/as102/as10x_cmd_cfg.c    | 206 ---------
 drivers/staging/media/as102/as10x_cmd_stream.c | 211 ---------
 drivers/staging/media/as102/as10x_handle.h     |  54 ---
 drivers/staging/media/as102/as10x_types.h      | 194 ---------
 34 files changed, 3372 insertions(+), 3373 deletions(-)
 create mode 100644 drivers/media/usb/as102/Kconfig
 create mode 100644 drivers/media/usb/as102/Makefile
 create mode 100644 drivers/media/usb/as102/as102_drv.c
 create mode 100644 drivers/media/usb/as102/as102_drv.h
 create mode 100644 drivers/media/usb/as102/as102_fe.c
 create mode 100644 drivers/media/usb/as102/as102_fw.c
 create mode 100644 drivers/media/usb/as102/as102_fw.h
 create mode 100644 drivers/media/usb/as102/as102_usb_drv.c
 create mode 100644 drivers/media/usb/as102/as102_usb_drv.h
 create mode 100644 drivers/media/usb/as102/as10x_cmd.c
 create mode 100644 drivers/media/usb/as102/as10x_cmd.h
 create mode 100644 drivers/media/usb/as102/as10x_cmd_cfg.c
 create mode 100644 drivers/media/usb/as102/as10x_cmd_stream.c
 create mode 100644 drivers/media/usb/as102/as10x_handle.h
 create mode 100644 drivers/media/usb/as102/as10x_types.h
 delete mode 100644 drivers/staging/media/as102/Kconfig
 delete mode 100644 drivers/staging/media/as102/Makefile
 delete mode 100644 drivers/staging/media/as102/as102_drv.c
 delete mode 100644 drivers/staging/media/as102/as102_drv.h
 delete mode 100644 drivers/staging/media/as102/as102_fe.c
 delete mode 100644 drivers/staging/media/as102/as102_fw.c
 delete mode 100644 drivers/staging/media/as102/as102_fw.h
 delete mode 100644 drivers/staging/media/as102/as102_usb_drv.c
 delete mode 100644 drivers/staging/media/as102/as102_usb_drv.h
 delete mode 100644 drivers/staging/media/as102/as10x_cmd.c
 delete mode 100644 drivers/staging/media/as102/as10x_cmd.h
 delete mode 100644 drivers/staging/media/as102/as10x_cmd_cfg.c
 delete mode 100644 drivers/staging/media/as102/as10x_cmd_stream.c
 delete mode 100644 drivers/staging/media/as102/as10x_handle.h
 delete mode 100644 drivers/staging/media/as102/as10x_types.h

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 94d51e092db3..d6e8edc59b6d 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -46,6 +46,7 @@ source "drivers/media/usb/ttusb-budget/Kconfig"
 source "drivers/media/usb/ttusb-dec/Kconfig"
 source "drivers/media/usb/siano/Kconfig"
 source "drivers/media/usb/b2c2/Kconfig"
+source "drivers/media/usb/as102/Kconfig"
 endif
 
 if (MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index f438efffefc5..b5b645b91f4e 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_VIDEO_TM6000) += tm6000/
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_USBTV) += usbtv/
 obj-$(CONFIG_VIDEO_GO7007) += go7007/
+obj-$(CONFIG_DVB_AS102) += as102/
diff --git a/drivers/media/usb/as102/Kconfig b/drivers/media/usb/as102/Kconfig
new file mode 100644
index 000000000000..28aba00dc629
--- /dev/null
+++ b/drivers/media/usb/as102/Kconfig
@@ -0,0 +1,8 @@
+config DVB_AS102
+	tristate "Abilis AS102 DVB receiver"
+	depends on DVB_CORE && USB && I2C && INPUT
+	select FW_LOADER
+	help
+	  Choose Y or M here if you have a device containing an AS102
+
+	  To compile this driver as a module, choose M here
diff --git a/drivers/media/usb/as102/Makefile b/drivers/media/usb/as102/Makefile
new file mode 100644
index 000000000000..8916d8a909bc
--- /dev/null
+++ b/drivers/media/usb/as102/Makefile
@@ -0,0 +1,6 @@
+dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
+		as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
+
+obj-$(CONFIG_DVB_AS102) += dvb-as102.o
+
+ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/media/usb/as102/as102_drv.c b/drivers/media/usb/as102/as102_drv.c
new file mode 100644
index 000000000000..e0ee618e607a
--- /dev/null
+++ b/drivers/media/usb/as102/as102_drv.c
@@ -0,0 +1,276 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/kref.h>
+#include <linux/uaccess.h>
+#include <linux/usb.h>
+
+/* header file for usb device driver*/
+#include "as102_drv.h"
+#include "as102_fw.h"
+#include "dvbdev.h"
+
+int dual_tuner;
+module_param_named(dual_tuner, dual_tuner, int, 0644);
+MODULE_PARM_DESC(dual_tuner, "Activate Dual-Tuner config (default: off)");
+
+static int fw_upload = 1;
+module_param_named(fw_upload, fw_upload, int, 0644);
+MODULE_PARM_DESC(fw_upload, "Turn on/off default FW upload (default: on)");
+
+static int pid_filtering;
+module_param_named(pid_filtering, pid_filtering, int, 0644);
+MODULE_PARM_DESC(pid_filtering, "Activate HW PID filtering (default: off)");
+
+static int ts_auto_disable;
+module_param_named(ts_auto_disable, ts_auto_disable, int, 0644);
+MODULE_PARM_DESC(ts_auto_disable, "Stream Auto Enable on FW (default: off)");
+
+int elna_enable = 1;
+module_param_named(elna_enable, elna_enable, int, 0644);
+MODULE_PARM_DESC(elna_enable, "Activate eLNA (default: on)");
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static void as102_stop_stream(struct as102_dev_t *dev)
+{
+	struct as10x_bus_adapter_t *bus_adap;
+
+	if (dev != NULL)
+		bus_adap = &dev->bus_adap;
+	else
+		return;
+
+	if (bus_adap->ops->stop_stream != NULL)
+		bus_adap->ops->stop_stream(dev);
+
+	if (ts_auto_disable) {
+		if (mutex_lock_interruptible(&dev->bus_adap.lock))
+			return;
+
+		if (as10x_cmd_stop_streaming(bus_adap) < 0)
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"as10x_cmd_stop_streaming failed\n");
+
+		mutex_unlock(&dev->bus_adap.lock);
+	}
+}
+
+static int as102_start_stream(struct as102_dev_t *dev)
+{
+	struct as10x_bus_adapter_t *bus_adap;
+	int ret = -EFAULT;
+
+	if (dev != NULL)
+		bus_adap = &dev->bus_adap;
+	else
+		return ret;
+
+	if (bus_adap->ops->start_stream != NULL)
+		ret = bus_adap->ops->start_stream(dev);
+
+	if (ts_auto_disable) {
+		if (mutex_lock_interruptible(&dev->bus_adap.lock))
+			return -EFAULT;
+
+		ret = as10x_cmd_start_streaming(bus_adap);
+
+		mutex_unlock(&dev->bus_adap.lock);
+	}
+
+	return ret;
+}
+
+static int as10x_pid_filter(struct as102_dev_t *dev,
+			    int index, u16 pid, int onoff) {
+
+	struct as10x_bus_adapter_t *bus_adap = &dev->bus_adap;
+	int ret = -EFAULT;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"amutex_lock_interruptible(lock) failed !\n");
+		return -EBUSY;
+	}
+
+	switch (onoff) {
+	case 0:
+		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+			index, pid, ret);
+		break;
+	case 1:
+	{
+		struct as10x_ts_filter filter;
+
+		filter.type = TS_PID_TYPE_TS;
+		filter.idx = 0xFF;
+		filter.pid = pid;
+
+		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
+			index, filter.idx, filter.pid, ret);
+		break;
+	}
+	}
+
+	mutex_unlock(&dev->bus_adap.lock);
+	return ret;
+}
+
+static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	int ret = 0;
+	struct dvb_demux *demux = dvbdmxfeed->demux;
+	struct as102_dev_t *as102_dev = demux->priv;
+
+	if (mutex_lock_interruptible(&as102_dev->sem))
+		return -ERESTARTSYS;
+
+	if (pid_filtering)
+		as10x_pid_filter(as102_dev, dvbdmxfeed->index,
+				 dvbdmxfeed->pid, 1);
+
+	if (as102_dev->streaming++ == 0)
+		ret = as102_start_stream(as102_dev);
+
+	mutex_unlock(&as102_dev->sem);
+	return ret;
+}
+
+static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *demux = dvbdmxfeed->demux;
+	struct as102_dev_t *as102_dev = demux->priv;
+
+	if (mutex_lock_interruptible(&as102_dev->sem))
+		return -ERESTARTSYS;
+
+	if (--as102_dev->streaming == 0)
+		as102_stop_stream(as102_dev);
+
+	if (pid_filtering)
+		as10x_pid_filter(as102_dev, dvbdmxfeed->index,
+				 dvbdmxfeed->pid, 0);
+
+	mutex_unlock(&as102_dev->sem);
+	return 0;
+}
+
+int as102_dvb_register(struct as102_dev_t *as102_dev)
+{
+	struct device *dev = &as102_dev->bus_adap.usb_dev->dev;
+	int ret;
+
+	ret = dvb_register_adapter(&as102_dev->dvb_adap,
+			   as102_dev->name, THIS_MODULE,
+			   dev, adapter_nr);
+	if (ret < 0) {
+		dev_err(dev, "%s: dvb_register_adapter() failed: %d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	as102_dev->dvb_dmx.priv = as102_dev;
+	as102_dev->dvb_dmx.filternum = pid_filtering ? 16 : 256;
+	as102_dev->dvb_dmx.feednum = 256;
+	as102_dev->dvb_dmx.start_feed = as102_dvb_dmx_start_feed;
+	as102_dev->dvb_dmx.stop_feed = as102_dvb_dmx_stop_feed;
+
+	as102_dev->dvb_dmx.dmx.capabilities = DMX_TS_FILTERING |
+					      DMX_SECTION_FILTERING;
+
+	as102_dev->dvb_dmxdev.filternum = as102_dev->dvb_dmx.filternum;
+	as102_dev->dvb_dmxdev.demux = &as102_dev->dvb_dmx.dmx;
+	as102_dev->dvb_dmxdev.capabilities = 0;
+
+	ret = dvb_dmx_init(&as102_dev->dvb_dmx);
+	if (ret < 0) {
+		dev_err(dev, "%s: dvb_dmx_init() failed: %d\n", __func__, ret);
+		goto edmxinit;
+	}
+
+	ret = dvb_dmxdev_init(&as102_dev->dvb_dmxdev, &as102_dev->dvb_adap);
+	if (ret < 0) {
+		dev_err(dev, "%s: dvb_dmxdev_init() failed: %d\n",
+			__func__, ret);
+		goto edmxdinit;
+	}
+
+	ret = as102_dvb_register_fe(as102_dev, &as102_dev->dvb_fe);
+	if (ret < 0) {
+		dev_err(dev, "%s: as102_dvb_register_frontend() failed: %d",
+		    __func__, ret);
+		goto efereg;
+	}
+
+	/* init bus mutex for token locking */
+	mutex_init(&as102_dev->bus_adap.lock);
+
+	/* init start / stop stream mutex */
+	mutex_init(&as102_dev->sem);
+
+	/*
+	 * try to load as102 firmware. If firmware upload failed, we'll be
+	 * able to upload it later.
+	 */
+	if (fw_upload)
+		try_then_request_module(as102_fw_upload(&as102_dev->bus_adap),
+				"firmware_class");
+
+	pr_info("Registered device %s", as102_dev->name);
+	return 0;
+
+efereg:
+	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
+edmxdinit:
+	dvb_dmx_release(&as102_dev->dvb_dmx);
+edmxinit:
+	dvb_unregister_adapter(&as102_dev->dvb_adap);
+	return ret;
+}
+
+void as102_dvb_unregister(struct as102_dev_t *as102_dev)
+{
+	/* unregister as102 frontend */
+	as102_dvb_unregister_fe(&as102_dev->dvb_fe);
+
+	/* unregister demux device */
+	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
+	dvb_dmx_release(&as102_dev->dvb_dmx);
+
+	/* unregister dvb adapter */
+	dvb_unregister_adapter(&as102_dev->dvb_adap);
+
+	pr_info("Unregistered device %s", as102_dev->name);
+}
+
+module_usb_driver(as102_usb_driver);
+
+/* modinfo details */
+MODULE_DESCRIPTION(DRIVER_FULL_NAME);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pierrick Hascoet <pierrick.hascoet@abilis.com>");
diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
new file mode 100644
index 000000000000..49d0c4259b00
--- /dev/null
+++ b/drivers/media/usb/as102/as102_drv.h
@@ -0,0 +1,92 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/usb.h>
+#include <dvb_demux.h>
+#include <dvb_frontend.h>
+#include <dmxdev.h>
+#include "as10x_cmd.h"
+#include "as102_usb_drv.h"
+
+#define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
+#define DRIVER_NAME "as10x_usb"
+
+#define debug	as102_debug
+extern struct usb_driver as102_usb_driver;
+extern int elna_enable;
+
+#define AS102_DEVICE_MAJOR	192
+
+#define AS102_USB_BUF_SIZE	512
+#define MAX_STREAM_URB		32
+
+struct as10x_bus_adapter_t {
+	struct usb_device *usb_dev;
+	/* bus token lock */
+	struct mutex lock;
+	/* low level interface for bus adapter */
+	union as10x_bus_token_t {
+		/* usb token */
+		struct as10x_usb_token_cmd_t usb;
+	} token;
+
+	/* token cmd xfer id */
+	uint16_t cmd_xid;
+
+	/* as10x command and response for dvb interface*/
+	struct as10x_cmd_t *cmd, *rsp;
+
+	/* bus adapter private ops callback */
+	struct as102_priv_ops_t *ops;
+};
+
+struct as102_dev_t {
+	const char *name;
+	struct as10x_bus_adapter_t bus_adap;
+	struct list_head device_entry;
+	struct kref kref;
+	uint8_t elna_cfg;
+
+	struct dvb_adapter dvb_adap;
+	struct dvb_frontend dvb_fe;
+	struct dvb_demux dvb_dmx;
+	struct dmxdev dvb_dmxdev;
+
+	/* demodulator stats */
+	struct as10x_demod_stats demod_stats;
+	/* signal strength */
+	uint16_t signal_strength;
+	/* bit error rate */
+	uint32_t ber;
+
+	/* timer handle to trig ts stream download */
+	struct timer_list timer_handle;
+
+	struct mutex sem;
+	dma_addr_t dma_addr;
+	void *stream;
+	int streaming;
+	struct urb *stream_urb[MAX_STREAM_URB];
+};
+
+int as102_dvb_register(struct as102_dev_t *dev);
+void as102_dvb_unregister(struct as102_dev_t *dev);
+
+int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
+int as102_dvb_unregister_fe(struct dvb_frontend *dev);
diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
new file mode 100644
index 000000000000..67e55b84493f
--- /dev/null
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -0,0 +1,566 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include "as102_drv.h"
+#include "as10x_types.h"
+#include "as10x_cmd.h"
+
+static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *dst,
+					 struct as10x_tps *src);
+
+static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
+					  struct dtv_frontend_properties *src);
+
+static int as102_fe_set_frontend(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int ret = 0;
+	struct as102_dev_t *dev;
+	struct as10x_tune_args tune_args = { 0 };
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	as102_fe_copy_tune_parameters(&tune_args, p);
+
+	/* send abilis command: SET_TUNE */
+	ret =  as10x_cmd_set_tune(&dev->bus_adap, &tune_args);
+	if (ret != 0)
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	return (ret < 0) ? -EINVAL : 0;
+}
+
+static int as102_fe_get_frontend(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int ret = 0;
+	struct as102_dev_t *dev;
+	struct as10x_tps tps = { 0 };
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TPS */
+	ret = as10x_cmd_get_tps(&dev->bus_adap, &tps);
+
+	if (ret == 0)
+		as10x_fe_copy_tps_parameters(p, &tps);
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	return (ret < 0) ? -EINVAL : 0;
+}
+
+static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
+			struct dvb_frontend_tune_settings *settings) {
+
+	settings->min_delay_ms = 1000;
+
+	return 0;
+}
+
+
+static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	int ret = 0;
+	struct as102_dev_t *dev;
+	struct as10x_tune_status tstate = { 0 };
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TUNE_STATUS */
+	ret = as10x_cmd_get_tune_status(&dev->bus_adap, &tstate);
+	if (ret < 0) {
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"as10x_cmd_get_tune_status failed (err = %d)\n",
+			ret);
+		goto out;
+	}
+
+	dev->signal_strength  = tstate.signal_strength;
+	dev->ber  = tstate.BER;
+
+	switch (tstate.tune_state) {
+	case TUNE_STATUS_SIGNAL_DVB_OK:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		break;
+	case TUNE_STATUS_STREAM_DETECTED:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
+		break;
+	case TUNE_STATUS_STREAM_TUNED:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
+			FE_HAS_LOCK;
+		break;
+	default:
+		*status = TUNE_STATUS_NOT_TUNED;
+	}
+
+	dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
+			tstate.tune_state, tstate.signal_strength,
+			tstate.PER, tstate.BER);
+
+	if (*status & FE_HAS_LOCK) {
+		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
+			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
+			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
+		} else {
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
+				"bytes corrected: 0x%08x , MER: 0x%04x\n",
+				dev->demod_stats.frame_count,
+				dev->demod_stats.bad_frame_count,
+				dev->demod_stats.bytes_fixed_by_rs,
+				dev->demod_stats.mer);
+		}
+	} else {
+		memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
+	}
+
+out:
+	mutex_unlock(&dev->bus_adap.lock);
+	return ret;
+}
+
+/*
+ * Note:
+ * - in AS102 SNR=MER
+ *   - the SNR will be returned in linear terms, i.e. not in dB
+ *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
+ *   - the accuracy is >2dB for SNR values outside this range
+ */
+static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct as102_dev_t *dev;
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	*snr = dev->demod_stats.mer;
+
+	return 0;
+}
+
+static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct as102_dev_t *dev;
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	*ber = dev->ber;
+
+	return 0;
+}
+
+static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
+					 u16 *strength)
+{
+	struct as102_dev_t *dev;
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	*strength = (((0xffff * 400) * dev->signal_strength + 41000) * 2);
+
+	return 0;
+}
+
+static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct as102_dev_t *dev;
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (dev->demod_stats.has_started)
+		*ucblocks = dev->demod_stats.bad_frame_count;
+	else
+		*ucblocks = 0;
+
+	return 0;
+}
+
+static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
+{
+	struct as102_dev_t *dev;
+	int ret;
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	if (acquire) {
+		if (elna_enable)
+			as10x_cmd_set_context(&dev->bus_adap,
+					      CONTEXT_LNA, dev->elna_cfg);
+
+		ret = as10x_cmd_turn_on(&dev->bus_adap);
+	} else {
+		ret = as10x_cmd_turn_off(&dev->bus_adap);
+	}
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	return ret;
+}
+
+static struct dvb_frontend_ops as102_fe_ops = {
+	.delsys = { SYS_DVBT },
+	.info = {
+		.name			= "Unknown AS102 device",
+		.frequency_min		= 174000000,
+		.frequency_max		= 862000000,
+		.frequency_stepsize	= 166667,
+		.caps = FE_CAN_INVERSION_AUTO
+			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
+			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
+			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
+			| FE_CAN_QAM_AUTO
+			| FE_CAN_TRANSMISSION_MODE_AUTO
+			| FE_CAN_GUARD_INTERVAL_AUTO
+			| FE_CAN_HIERARCHY_AUTO
+			| FE_CAN_RECOVER
+			| FE_CAN_MUTE_TS
+	},
+
+	.set_frontend		= as102_fe_set_frontend,
+	.get_frontend		= as102_fe_get_frontend,
+	.get_tune_settings	= as102_fe_get_tune_settings,
+
+	.read_status		= as102_fe_read_status,
+	.read_snr		= as102_fe_read_snr,
+	.read_ber		= as102_fe_read_ber,
+	.read_signal_strength	= as102_fe_read_signal_strength,
+	.read_ucblocks		= as102_fe_read_ucblocks,
+	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+};
+
+int as102_dvb_unregister_fe(struct dvb_frontend *fe)
+{
+	/* unregister frontend */
+	dvb_unregister_frontend(fe);
+
+	/* detach frontend */
+	dvb_frontend_detach(fe);
+
+	return 0;
+}
+
+int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
+			  struct dvb_frontend *dvb_fe)
+{
+	int errno;
+	struct dvb_adapter *dvb_adap;
+
+	if (as102_dev == NULL)
+		return -EINVAL;
+
+	/* extract dvb_adapter */
+	dvb_adap = &as102_dev->dvb_adap;
+
+	/* init frontend callback ops */
+	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
+	strncpy(dvb_fe->ops.info.name, as102_dev->name,
+		sizeof(dvb_fe->ops.info.name));
+
+	/* register dvb frontend */
+	errno = dvb_register_frontend(dvb_adap, dvb_fe);
+	if (errno == 0)
+		dvb_fe->tuner_priv = as102_dev;
+
+	return errno;
+}
+
+static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *fe_tps,
+					 struct as10x_tps *as10x_tps)
+{
+
+	/* extract constellation */
+	switch (as10x_tps->modulation) {
+	case CONST_QPSK:
+		fe_tps->modulation = QPSK;
+		break;
+	case CONST_QAM16:
+		fe_tps->modulation = QAM_16;
+		break;
+	case CONST_QAM64:
+		fe_tps->modulation = QAM_64;
+		break;
+	}
+
+	/* extract hierarchy */
+	switch (as10x_tps->hierarchy) {
+	case HIER_NONE:
+		fe_tps->hierarchy = HIERARCHY_NONE;
+		break;
+	case HIER_ALPHA_1:
+		fe_tps->hierarchy = HIERARCHY_1;
+		break;
+	case HIER_ALPHA_2:
+		fe_tps->hierarchy = HIERARCHY_2;
+		break;
+	case HIER_ALPHA_4:
+		fe_tps->hierarchy = HIERARCHY_4;
+		break;
+	}
+
+	/* extract code rate HP */
+	switch (as10x_tps->code_rate_HP) {
+	case CODE_RATE_1_2:
+		fe_tps->code_rate_HP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		fe_tps->code_rate_HP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		fe_tps->code_rate_HP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		fe_tps->code_rate_HP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		fe_tps->code_rate_HP = FEC_7_8;
+		break;
+	}
+
+	/* extract code rate LP */
+	switch (as10x_tps->code_rate_LP) {
+	case CODE_RATE_1_2:
+		fe_tps->code_rate_LP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		fe_tps->code_rate_LP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		fe_tps->code_rate_LP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		fe_tps->code_rate_LP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		fe_tps->code_rate_LP = FEC_7_8;
+		break;
+	}
+
+	/* extract guard interval */
+	switch (as10x_tps->guard_interval) {
+	case GUARD_INT_1_32:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case GUARD_INT_1_16:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case GUARD_INT_1_8:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case GUARD_INT_1_4:
+		fe_tps->guard_interval = GUARD_INTERVAL_1_4;
+		break;
+	}
+
+	/* extract transmission mode */
+	switch (as10x_tps->transmission_mode) {
+	case TRANS_MODE_2K:
+		fe_tps->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case TRANS_MODE_8K:
+		fe_tps->transmission_mode = TRANSMISSION_MODE_8K;
+		break;
+	}
+}
+
+static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
+{
+	uint8_t c;
+
+	switch (arg) {
+	case FEC_1_2:
+		c = CODE_RATE_1_2;
+		break;
+	case FEC_2_3:
+		c = CODE_RATE_2_3;
+		break;
+	case FEC_3_4:
+		c = CODE_RATE_3_4;
+		break;
+	case FEC_5_6:
+		c = CODE_RATE_5_6;
+		break;
+	case FEC_7_8:
+		c = CODE_RATE_7_8;
+		break;
+	default:
+		c = CODE_RATE_UNKNOWN;
+		break;
+	}
+
+	return c;
+}
+
+static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
+			  struct dtv_frontend_properties *params)
+{
+
+	/* set frequency */
+	tune_args->freq = params->frequency / 1000;
+
+	/* fix interleaving_mode */
+	tune_args->interleaving_mode = INTLV_NATIVE;
+
+	switch (params->bandwidth_hz) {
+	case 8000000:
+		tune_args->bandwidth = BW_8_MHZ;
+		break;
+	case 7000000:
+		tune_args->bandwidth = BW_7_MHZ;
+		break;
+	case 6000000:
+		tune_args->bandwidth = BW_6_MHZ;
+		break;
+	default:
+		tune_args->bandwidth = BW_8_MHZ;
+	}
+
+	switch (params->guard_interval) {
+	case GUARD_INTERVAL_1_32:
+		tune_args->guard_interval = GUARD_INT_1_32;
+		break;
+	case GUARD_INTERVAL_1_16:
+		tune_args->guard_interval = GUARD_INT_1_16;
+		break;
+	case GUARD_INTERVAL_1_8:
+		tune_args->guard_interval = GUARD_INT_1_8;
+		break;
+	case GUARD_INTERVAL_1_4:
+		tune_args->guard_interval = GUARD_INT_1_4;
+		break;
+	case GUARD_INTERVAL_AUTO:
+	default:
+		tune_args->guard_interval = GUARD_UNKNOWN;
+		break;
+	}
+
+	switch (params->modulation) {
+	case QPSK:
+		tune_args->modulation = CONST_QPSK;
+		break;
+	case QAM_16:
+		tune_args->modulation = CONST_QAM16;
+		break;
+	case QAM_64:
+		tune_args->modulation = CONST_QAM64;
+		break;
+	default:
+		tune_args->modulation = CONST_UNKNOWN;
+		break;
+	}
+
+	switch (params->transmission_mode) {
+	case TRANSMISSION_MODE_2K:
+		tune_args->transmission_mode = TRANS_MODE_2K;
+		break;
+	case TRANSMISSION_MODE_8K:
+		tune_args->transmission_mode = TRANS_MODE_8K;
+		break;
+	default:
+		tune_args->transmission_mode = TRANS_MODE_UNKNOWN;
+	}
+
+	switch (params->hierarchy) {
+	case HIERARCHY_NONE:
+		tune_args->hierarchy = HIER_NONE;
+		break;
+	case HIERARCHY_1:
+		tune_args->hierarchy = HIER_ALPHA_1;
+		break;
+	case HIERARCHY_2:
+		tune_args->hierarchy = HIER_ALPHA_2;
+		break;
+	case HIERARCHY_4:
+		tune_args->hierarchy = HIER_ALPHA_4;
+		break;
+	case HIERARCHY_AUTO:
+		tune_args->hierarchy = HIER_UNKNOWN;
+		break;
+	}
+
+	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
+			params->frequency,
+			tune_args->bandwidth,
+			tune_args->guard_interval);
+
+	/*
+	 * Detect a hierarchy selection
+	 * if HP/LP are both set to FEC_NONE, HP will be selected.
+	 */
+	if ((tune_args->hierarchy != HIER_NONE) &&
+		       ((params->code_rate_LP == FEC_NONE) ||
+			(params->code_rate_HP == FEC_NONE))) {
+
+		if (params->code_rate_LP == FEC_NONE) {
+			tune_args->hier_select = HIER_HIGH_PRIORITY;
+			tune_args->code_rate =
+			   as102_fe_get_code_rate(params->code_rate_HP);
+		}
+
+		if (params->code_rate_HP == FEC_NONE) {
+			tune_args->hier_select = HIER_LOW_PRIORITY;
+			tune_args->code_rate =
+			   as102_fe_get_code_rate(params->code_rate_LP);
+		}
+
+		pr_debug("as102: \thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
+			tune_args->hierarchy,
+			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args->code_rate);
+	} else {
+		tune_args->code_rate =
+			as102_fe_get_code_rate(params->code_rate_HP);
+	}
+}
diff --git a/drivers/media/usb/as102/as102_fw.c b/drivers/media/usb/as102/as102_fw.c
new file mode 100644
index 000000000000..f33f752c0aad
--- /dev/null
+++ b/drivers/media/usb/as102/as102_fw.c
@@ -0,0 +1,232 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+
+#include "as102_drv.h"
+#include "as102_fw.h"
+
+static const char as102_st_fw1[] = "as102_data1_st.hex";
+static const char as102_st_fw2[] = "as102_data2_st.hex";
+static const char as102_dt_fw1[] = "as102_data1_dt.hex";
+static const char as102_dt_fw2[] = "as102_data2_dt.hex";
+
+static unsigned char atohx(unsigned char *dst, char *src)
+{
+	unsigned char value = 0;
+
+	char msb = tolower(*src) - '0';
+	char lsb = tolower(*(src + 1)) - '0';
+
+	if (msb > 9)
+		msb -= 7;
+	if (lsb > 9)
+		lsb -= 7;
+
+	*dst = value = ((msb & 0xF) << 4) | (lsb & 0xF);
+	return value;
+}
+
+/*
+ * Parse INTEL HEX firmware file to extract address and data.
+ */
+static int parse_hex_line(unsigned char *fw_data, unsigned char *addr,
+			  unsigned char *data, int *dataLength,
+			  unsigned char *addr_has_changed) {
+
+	int count = 0;
+	unsigned char *src, dst;
+
+	if (*fw_data++ != ':') {
+		pr_err("invalid firmware file\n");
+		return -EFAULT;
+	}
+
+	/* locate end of line */
+	for (src = fw_data; *src != '\n'; src += 2) {
+		atohx(&dst, src);
+		/* parse line to split addr / data */
+		switch (count) {
+		case 0:
+			*dataLength = dst;
+			break;
+		case 1:
+			addr[2] = dst;
+			break;
+		case 2:
+			addr[3] = dst;
+			break;
+		case 3:
+			/* check if data is an address */
+			if (dst == 0x04)
+				*addr_has_changed = 1;
+			else
+				*addr_has_changed = 0;
+			break;
+		case  4:
+		case  5:
+			if (*addr_has_changed)
+				addr[(count - 4)] = dst;
+			else
+				data[(count - 4)] = dst;
+			break;
+		default:
+			data[(count - 4)] = dst;
+			break;
+		}
+		count++;
+	}
+
+	/* return read value + ':' + '\n' */
+	return (count * 2) + 2;
+}
+
+static int as102_firmware_upload(struct as10x_bus_adapter_t *bus_adap,
+				 unsigned char *cmd,
+				 const struct firmware *firmware) {
+
+	struct as10x_fw_pkt_t fw_pkt;
+	int total_read_bytes = 0, errno = 0;
+	unsigned char addr_has_changed = 0;
+
+	for (total_read_bytes = 0; total_read_bytes < firmware->size; ) {
+		int read_bytes = 0, data_len = 0;
+
+		/* parse intel hex line */
+		read_bytes = parse_hex_line(
+				(u8 *) (firmware->data + total_read_bytes),
+				fw_pkt.raw.address,
+				fw_pkt.raw.data,
+				&data_len,
+				&addr_has_changed);
+
+		if (read_bytes <= 0)
+			goto error;
+
+		/* detect the end of file */
+		total_read_bytes += read_bytes;
+		if (total_read_bytes == firmware->size) {
+			fw_pkt.u.request[0] = 0x00;
+			fw_pkt.u.request[1] = 0x03;
+
+			/* send EOF command */
+			errno = bus_adap->ops->upload_fw_pkt(bus_adap,
+							     (uint8_t *)
+							     &fw_pkt, 2, 0);
+			if (errno < 0)
+				goto error;
+		} else {
+			if (!addr_has_changed) {
+				/* prepare command to send */
+				fw_pkt.u.request[0] = 0x00;
+				fw_pkt.u.request[1] = 0x01;
+
+				data_len += sizeof(fw_pkt.u.request);
+				data_len += sizeof(fw_pkt.raw.address);
+
+				/* send cmd to device */
+				errno = bus_adap->ops->upload_fw_pkt(bus_adap,
+								     (uint8_t *)
+								     &fw_pkt,
+								     data_len,
+								     0);
+				if (errno < 0)
+					goto error;
+			}
+		}
+	}
+error:
+	return (errno == 0) ? total_read_bytes : errno;
+}
+
+int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
+{
+	int errno = -EFAULT;
+	const struct firmware *firmware = NULL;
+	unsigned char *cmd_buf = NULL;
+	const char *fw1, *fw2;
+	struct usb_device *dev = bus_adap->usb_dev;
+
+	/* select fw file to upload */
+	if (dual_tuner) {
+		fw1 = as102_dt_fw1;
+		fw2 = as102_dt_fw2;
+	} else {
+		fw1 = as102_st_fw1;
+		fw2 = as102_st_fw2;
+	}
+
+	/* allocate buffer to store firmware upload command and data */
+	cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL);
+	if (cmd_buf == NULL) {
+		errno = -ENOMEM;
+		goto error;
+	}
+
+	/* request kernel to locate firmware file: part1 */
+	errno = request_firmware(&firmware, fw1, &dev->dev);
+	if (errno < 0) {
+		pr_err("%s: unable to locate firmware file: %s\n",
+		       DRIVER_NAME, fw1);
+		goto error;
+	}
+
+	/* initiate firmware upload */
+	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
+	if (errno < 0) {
+		pr_err("%s: error during firmware upload part1\n",
+		       DRIVER_NAME);
+		goto error;
+	}
+
+	pr_info("%s: firmware: %s loaded with success\n",
+		DRIVER_NAME, fw1);
+	release_firmware(firmware);
+
+	/* wait for boot to complete */
+	mdelay(100);
+
+	/* request kernel to locate firmware file: part2 */
+	errno = request_firmware(&firmware, fw2, &dev->dev);
+	if (errno < 0) {
+		pr_err("%s: unable to locate firmware file: %s\n",
+		       DRIVER_NAME, fw2);
+		goto error;
+	}
+
+	/* initiate firmware upload */
+	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
+	if (errno < 0) {
+		pr_err("%s: error during firmware upload part2\n",
+		       DRIVER_NAME);
+		goto error;
+	}
+
+	pr_info("%s: firmware: %s loaded with success\n",
+		DRIVER_NAME, fw2);
+error:
+	kfree(cmd_buf);
+	release_firmware(firmware);
+
+	return errno;
+}
diff --git a/drivers/media/usb/as102/as102_fw.h b/drivers/media/usb/as102/as102_fw.h
new file mode 100644
index 000000000000..4bfc6849d95a
--- /dev/null
+++ b/drivers/media/usb/as102/as102_fw.h
@@ -0,0 +1,38 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#define MAX_FW_PKT_SIZE	64
+
+extern int dual_tuner;
+
+struct as10x_raw_fw_pkt {
+	unsigned char address[4];
+	unsigned char data[MAX_FW_PKT_SIZE - 6];
+} __packed;
+
+struct as10x_fw_pkt_t {
+	union {
+		unsigned char request[2];
+		unsigned char length[2];
+	} __packed u;
+	struct as10x_raw_fw_pkt raw;
+} __packed;
+
+#ifdef __KERNEL__
+int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap);
+#endif
diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
new file mode 100644
index 000000000000..86f83b9b1118
--- /dev/null
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -0,0 +1,479 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/usb.h>
+
+#include "as102_drv.h"
+#include "as102_usb_drv.h"
+#include "as102_fw.h"
+
+static void as102_usb_disconnect(struct usb_interface *interface);
+static int as102_usb_probe(struct usb_interface *interface,
+			   const struct usb_device_id *id);
+
+static int as102_usb_start_stream(struct as102_dev_t *dev);
+static void as102_usb_stop_stream(struct as102_dev_t *dev);
+
+static int as102_open(struct inode *inode, struct file *file);
+static int as102_release(struct inode *inode, struct file *file);
+
+static struct usb_device_id as102_usb_id_table[] = {
+	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
+	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
+	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
+	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
+	{ USB_DEVICE(SKY_IT_DIGITAL_KEY_USB_VID, SKY_IT_DIGITAL_KEY_USB_PID) },
+	{ } /* Terminating entry */
+};
+
+/* Note that this table must always have the same number of entries as the
+   as102_usb_id_table struct */
+static const char * const as102_device_names[] = {
+	AS102_REFERENCE_DESIGN,
+	AS102_PCTV_74E,
+	AS102_ELGATO_EYETV_DTT_NAME,
+	AS102_NBOX_DVBT_DONGLE_NAME,
+	AS102_SKY_IT_DIGITAL_KEY_NAME,
+	NULL /* Terminating entry */
+};
+
+/* eLNA configuration: devices built on the reference design work best
+   with 0xA0, while custom designs seem to require 0xC0 */
+static uint8_t const as102_elna_cfg[] = {
+	0xA0,
+	0xC0,
+	0xC0,
+	0xA0,
+	0xA0,
+	0x00 /* Terminating entry */
+};
+
+struct usb_driver as102_usb_driver = {
+	.name		= DRIVER_FULL_NAME,
+	.probe		= as102_usb_probe,
+	.disconnect	= as102_usb_disconnect,
+	.id_table	= as102_usb_id_table
+};
+
+static const struct file_operations as102_dev_fops = {
+	.owner		= THIS_MODULE,
+	.open		= as102_open,
+	.release	= as102_release,
+};
+
+static struct usb_class_driver as102_usb_class_driver = {
+	.name		= "aton2-%d",
+	.fops		= &as102_dev_fops,
+	.minor_base	= AS102_DEVICE_MAJOR,
+};
+
+static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
+			      unsigned char *send_buf, int send_buf_len,
+			      unsigned char *recv_buf, int recv_buf_len)
+{
+	int ret = 0;
+
+	if (send_buf != NULL) {
+		ret = usb_control_msg(bus_adap->usb_dev,
+				      usb_sndctrlpipe(bus_adap->usb_dev, 0),
+				      AS102_USB_DEVICE_TX_CTRL_CMD,
+				      USB_DIR_OUT | USB_TYPE_VENDOR |
+				      USB_RECIP_DEVICE,
+				      bus_adap->cmd_xid, /* value */
+				      0, /* index */
+				      send_buf, send_buf_len,
+				      USB_CTRL_SET_TIMEOUT /* 200 */);
+		if (ret < 0) {
+			dev_dbg(&bus_adap->usb_dev->dev,
+				"usb_control_msg(send) failed, err %i\n", ret);
+			return ret;
+		}
+
+		if (ret != send_buf_len) {
+			dev_dbg(&bus_adap->usb_dev->dev,
+			"only wrote %d of %d bytes\n", ret, send_buf_len);
+			return -1;
+		}
+	}
+
+	if (recv_buf != NULL) {
+#ifdef TRACE
+		dev_dbg(bus_adap->usb_dev->dev,
+			"want to read: %d bytes\n", recv_buf_len);
+#endif
+		ret = usb_control_msg(bus_adap->usb_dev,
+				      usb_rcvctrlpipe(bus_adap->usb_dev, 0),
+				      AS102_USB_DEVICE_RX_CTRL_CMD,
+				      USB_DIR_IN | USB_TYPE_VENDOR |
+				      USB_RECIP_DEVICE,
+				      bus_adap->cmd_xid, /* value */
+				      0, /* index */
+				      recv_buf, recv_buf_len,
+				      USB_CTRL_GET_TIMEOUT /* 200 */);
+		if (ret < 0) {
+			dev_dbg(&bus_adap->usb_dev->dev,
+				"usb_control_msg(recv) failed, err %i\n", ret);
+			return ret;
+		}
+#ifdef TRACE
+		dev_dbg(bus_adap->usb_dev->dev,
+			"read %d bytes\n", recv_buf_len);
+#endif
+	}
+
+	return ret;
+}
+
+static int as102_send_ep1(struct as10x_bus_adapter_t *bus_adap,
+			  unsigned char *send_buf,
+			  int send_buf_len,
+			  int swap32)
+{
+	int ret = 0, actual_len;
+
+	ret = usb_bulk_msg(bus_adap->usb_dev,
+			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
+			   send_buf, send_buf_len, &actual_len, 200);
+	if (ret) {
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"usb_bulk_msg(send) failed, err %i\n", ret);
+		return ret;
+	}
+
+	if (actual_len != send_buf_len) {
+		dev_dbg(&bus_adap->usb_dev->dev, "only wrote %d of %d bytes\n",
+			actual_len, send_buf_len);
+		return -1;
+	}
+	return ret ? ret : actual_len;
+}
+
+static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
+		   unsigned char *recv_buf, int recv_buf_len)
+{
+	int ret = 0, actual_len;
+
+	if (recv_buf == NULL)
+		return -EINVAL;
+
+	ret = usb_bulk_msg(bus_adap->usb_dev,
+			   usb_rcvbulkpipe(bus_adap->usb_dev, 2),
+			   recv_buf, recv_buf_len, &actual_len, 200);
+	if (ret) {
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"usb_bulk_msg(recv) failed, err %i\n", ret);
+		return ret;
+	}
+
+	if (actual_len != recv_buf_len) {
+		dev_dbg(&bus_adap->usb_dev->dev, "only read %d of %d bytes\n",
+			actual_len, recv_buf_len);
+		return -1;
+	}
+	return ret ? ret : actual_len;
+}
+
+static struct as102_priv_ops_t as102_priv_ops = {
+	.upload_fw_pkt	= as102_send_ep1,
+	.xfer_cmd	= as102_usb_xfer_cmd,
+	.as102_read_ep2	= as102_read_ep2,
+	.start_stream	= as102_usb_start_stream,
+	.stop_stream	= as102_usb_stop_stream,
+};
+
+static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
+{
+	int err;
+
+	usb_fill_bulk_urb(urb,
+			  dev->bus_adap.usb_dev,
+			  usb_rcvbulkpipe(dev->bus_adap.usb_dev, 0x2),
+			  urb->transfer_buffer,
+			  AS102_USB_BUF_SIZE,
+			  as102_urb_stream_irq,
+			  dev);
+
+	err = usb_submit_urb(urb, GFP_ATOMIC);
+	if (err)
+		dev_dbg(&urb->dev->dev,
+			"%s: usb_submit_urb failed\n", __func__);
+
+	return err;
+}
+
+void as102_urb_stream_irq(struct urb *urb)
+{
+	struct as102_dev_t *as102_dev = urb->context;
+
+	if (urb->actual_length > 0) {
+		dvb_dmx_swfilter(&as102_dev->dvb_dmx,
+				 urb->transfer_buffer,
+				 urb->actual_length);
+	} else {
+		if (urb->actual_length == 0)
+			memset(urb->transfer_buffer, 0, AS102_USB_BUF_SIZE);
+	}
+
+	/* is not stopped, re-submit urb */
+	if (as102_dev->streaming)
+		as102_submit_urb_stream(as102_dev, urb);
+}
+
+static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
+{
+	int i;
+
+	for (i = 0; i < MAX_STREAM_URB; i++)
+		usb_free_urb(dev->stream_urb[i]);
+
+	usb_free_coherent(dev->bus_adap.usb_dev,
+			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
+			dev->stream,
+			dev->dma_addr);
+}
+
+static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
+{
+	int i;
+
+	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
+				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
+				       GFP_KERNEL,
+				       &dev->dma_addr);
+	if (!dev->stream) {
+		dev_dbg(&dev->bus_adap.usb_dev->dev,
+			"%s: usb_buffer_alloc failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	memset(dev->stream, 0, MAX_STREAM_URB * AS102_USB_BUF_SIZE);
+
+	/* init urb buffers */
+	for (i = 0; i < MAX_STREAM_URB; i++) {
+		struct urb *urb;
+
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (urb == NULL) {
+			dev_dbg(&dev->bus_adap.usb_dev->dev,
+				"%s: usb_alloc_urb failed\n", __func__);
+			as102_free_usb_stream_buffer(dev);
+			return -ENOMEM;
+		}
+
+		urb->transfer_buffer = dev->stream + (i * AS102_USB_BUF_SIZE);
+		urb->transfer_dma = dev->dma_addr + (i * AS102_USB_BUF_SIZE);
+		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_buffer_length = AS102_USB_BUF_SIZE;
+
+		dev->stream_urb[i] = urb;
+	}
+	return 0;
+}
+
+static void as102_usb_stop_stream(struct as102_dev_t *dev)
+{
+	int i;
+
+	for (i = 0; i < MAX_STREAM_URB; i++)
+		usb_kill_urb(dev->stream_urb[i]);
+}
+
+static int as102_usb_start_stream(struct as102_dev_t *dev)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < MAX_STREAM_URB; i++) {
+		ret = as102_submit_urb_stream(dev, dev->stream_urb[i]);
+		if (ret) {
+			as102_usb_stop_stream(dev);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void as102_usb_release(struct kref *kref)
+{
+	struct as102_dev_t *as102_dev;
+
+	as102_dev = container_of(kref, struct as102_dev_t, kref);
+	if (as102_dev != NULL) {
+		usb_put_dev(as102_dev->bus_adap.usb_dev);
+		kfree(as102_dev);
+	}
+}
+
+static void as102_usb_disconnect(struct usb_interface *intf)
+{
+	struct as102_dev_t *as102_dev;
+
+	/* extract as102_dev_t from usb_device private data */
+	as102_dev = usb_get_intfdata(intf);
+
+	/* unregister dvb layer */
+	as102_dvb_unregister(as102_dev);
+
+	/* free usb buffers */
+	as102_free_usb_stream_buffer(as102_dev);
+
+	usb_set_intfdata(intf, NULL);
+
+	/* usb unregister device */
+	usb_deregister_dev(intf, &as102_usb_class_driver);
+
+	/* decrement usage counter */
+	kref_put(&as102_dev->kref, as102_usb_release);
+
+	pr_info("%s: device has been disconnected\n", DRIVER_NAME);
+}
+
+static int as102_usb_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	int ret;
+	struct as102_dev_t *as102_dev;
+	int i;
+
+	/* This should never actually happen */
+	if (ARRAY_SIZE(as102_usb_id_table) !=
+	    (sizeof(as102_device_names) / sizeof(const char *))) {
+		pr_err("Device names table invalid size");
+		return -EINVAL;
+	}
+
+	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
+	if (as102_dev == NULL)
+		return -ENOMEM;
+
+	/* Assign the user-friendly device name */
+	for (i = 0; i < ARRAY_SIZE(as102_usb_id_table); i++) {
+		if (id == &as102_usb_id_table[i]) {
+			as102_dev->name = as102_device_names[i];
+			as102_dev->elna_cfg = as102_elna_cfg[i];
+		}
+	}
+
+	if (as102_dev->name == NULL)
+		as102_dev->name = "Unknown AS102 device";
+
+	/* set private callback functions */
+	as102_dev->bus_adap.ops = &as102_priv_ops;
+
+	/* init cmd token for usb bus */
+	as102_dev->bus_adap.cmd = &as102_dev->bus_adap.token.usb.c;
+	as102_dev->bus_adap.rsp = &as102_dev->bus_adap.token.usb.r;
+
+	/* init kernel device reference */
+	kref_init(&as102_dev->kref);
+
+	/* store as102 device to usb_device private data */
+	usb_set_intfdata(intf, (void *) as102_dev);
+
+	/* store in as102 device the usb_device pointer */
+	as102_dev->bus_adap.usb_dev = usb_get_dev(interface_to_usbdev(intf));
+
+	/* we can register the device now, as it is ready */
+	ret = usb_register_dev(intf, &as102_usb_class_driver);
+	if (ret < 0) {
+		/* something prevented us from registering this driver */
+		dev_err(&intf->dev,
+			"%s: usb_register_dev() failed (errno = %d)\n",
+			__func__, ret);
+		goto failed;
+	}
+
+	pr_info("%s: device has been detected\n", DRIVER_NAME);
+
+	/* request buffer allocation for streaming */
+	ret = as102_alloc_usb_stream_buffer(as102_dev);
+	if (ret != 0)
+		goto failed_stream;
+
+	/* register dvb layer */
+	ret = as102_dvb_register(as102_dev);
+	if (ret != 0)
+		goto failed_dvb;
+
+	return ret;
+
+failed_dvb:
+	as102_free_usb_stream_buffer(as102_dev);
+failed_stream:
+	usb_deregister_dev(intf, &as102_usb_class_driver);
+failed:
+	usb_put_dev(as102_dev->bus_adap.usb_dev);
+	usb_set_intfdata(intf, NULL);
+	kfree(as102_dev);
+	return ret;
+}
+
+static int as102_open(struct inode *inode, struct file *file)
+{
+	int ret = 0, minor = 0;
+	struct usb_interface *intf = NULL;
+	struct as102_dev_t *dev = NULL;
+
+	/* read minor from inode */
+	minor = iminor(inode);
+
+	/* fetch device from usb interface */
+	intf = usb_find_interface(&as102_usb_driver, minor);
+	if (intf == NULL) {
+		pr_err("%s: can't find device for minor %d\n",
+		       __func__, minor);
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	/* get our device */
+	dev = usb_get_intfdata(intf);
+	if (dev == NULL) {
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	/* save our device object in the file's private structure */
+	file->private_data = dev;
+
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
+
+exit:
+	return ret;
+}
+
+static int as102_release(struct inode *inode, struct file *file)
+{
+	struct as102_dev_t *dev = NULL;
+
+	dev = file->private_data;
+	if (dev != NULL) {
+		/* decrement the count on our device */
+		kref_put(&dev->kref, as102_usb_release);
+	}
+
+	return 0;
+}
+
+MODULE_DEVICE_TABLE(usb, as102_usb_id_table);
diff --git a/drivers/media/usb/as102/as102_usb_drv.h b/drivers/media/usb/as102/as102_usb_drv.h
new file mode 100644
index 000000000000..1ad1ec52b11e
--- /dev/null
+++ b/drivers/media/usb/as102/as102_usb_drv.h
@@ -0,0 +1,61 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _AS102_USB_DRV_H_
+#define _AS102_USB_DRV_H_
+
+#define AS102_USB_DEVICE_TX_CTRL_CMD	0xF1
+#define AS102_USB_DEVICE_RX_CTRL_CMD	0xF2
+
+/* define these values to match the supported devices */
+
+/* Abilis system: "TITAN" */
+#define AS102_REFERENCE_DESIGN		"Abilis Systems DVB-Titan"
+#define AS102_USB_DEVICE_VENDOR_ID	0x1BA6
+#define AS102_USB_DEVICE_PID_0001	0x0001
+
+/* PCTV Systems: PCTV picoStick (74e) */
+#define AS102_PCTV_74E			"PCTV Systems picoStick (74e)"
+#define PCTV_74E_USB_VID		0x2013
+#define PCTV_74E_USB_PID		0x0246
+
+/* Elgato: EyeTV DTT Deluxe */
+#define AS102_ELGATO_EYETV_DTT_NAME	"Elgato EyeTV DTT Deluxe"
+#define ELGATO_EYETV_DTT_USB_VID	0x0fd9
+#define ELGATO_EYETV_DTT_USB_PID	0x002c
+
+/* nBox: nBox DVB-T Dongle */
+#define AS102_NBOX_DVBT_DONGLE_NAME	"nBox DVB-T Dongle"
+#define NBOX_DVBT_DONGLE_USB_VID	0x0b89
+#define NBOX_DVBT_DONGLE_USB_PID	0x0007
+
+/* Sky Italia: Digital Key (green led) */
+#define AS102_SKY_IT_DIGITAL_KEY_NAME	"Sky IT Digital Key (green led)"
+#define SKY_IT_DIGITAL_KEY_USB_VID	0x2137
+#define SKY_IT_DIGITAL_KEY_USB_PID	0x0001
+
+void as102_urb_stream_irq(struct urb *urb);
+
+struct as10x_usb_token_cmd_t {
+	/* token cmd */
+	struct as10x_cmd_t c;
+	/* token response */
+	struct as10x_cmd_t r;
+};
+#endif
diff --git a/drivers/media/usb/as102/as10x_cmd.c b/drivers/media/usb/as102/as10x_cmd.c
new file mode 100644
index 000000000000..9e49f15a7c9f
--- /dev/null
+++ b/drivers/media/usb/as102/as10x_cmd.c
@@ -0,0 +1,418 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include "as102_drv.h"
+#include "as10x_types.h"
+#include "as10x_cmd.h"
+
+/**
+ * as10x_cmd_turn_on - send turn on command to AS10x
+ * @adap:   pointer to AS10x bus adapter
+ *
+ * Return 0 when no error, < 0 in case of error.
+ */
+int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.turn_on.req));
+
+	/* fill command */
+	pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+					    sizeof(pcmd->body.turn_on.req) +
+					    HEADER_SIZE,
+					    (uint8_t *) prsp,
+					    sizeof(prsp->body.turn_on.rsp) +
+					    HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_turn_off - send turn off command to AS10x
+ * @adap:   pointer to AS10x bus adapter
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.turn_off.req));
+
+	/* fill command */
+	pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(
+			adap, (uint8_t *) pcmd,
+			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
+			(uint8_t *) prsp,
+			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_set_tune - send set tune command to AS10x
+ * @adap:    pointer to AS10x bus adapter
+ * @ptune:   tune parameters
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
+		       struct as10x_tune_args *ptune)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t *preq, *prsp;
+
+	preq = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(preq, (++adap->cmd_xid),
+			sizeof(preq->body.set_tune.req));
+
+	/* fill command */
+	preq->body.set_tune.req.proc_id = cpu_to_le16(CONTROL_PROC_SETTUNE);
+	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
+	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
+	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
+	preq->body.set_tune.req.args.modulation = ptune->modulation;
+	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
+	preq->body.set_tune.req.args.interleaving_mode  =
+		ptune->interleaving_mode;
+	preq->body.set_tune.req.args.code_rate  = ptune->code_rate;
+	preq->body.set_tune.req.args.guard_interval = ptune->guard_interval;
+	preq->body.set_tune.req.args.transmission_mode  =
+		ptune->transmission_mode;
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
+					    (uint8_t *) preq,
+					    sizeof(preq->body.set_tune.req)
+					    + HEADER_SIZE,
+					    (uint8_t *) prsp,
+					    sizeof(prsp->body.set_tune.rsp)
+					    + HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_get_tune_status - send get tune status command to AS10x
+ * @adap: pointer to AS10x bus adapter
+ * @pstatus: pointer to updated status structure of the current tune
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
+			      struct as10x_tune_status *pstatus)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t  *preq, *prsp;
+
+	preq = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(preq, (++adap->cmd_xid),
+			sizeof(preq->body.get_tune_status.req));
+
+	/* fill command */
+	preq->body.get_tune_status.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(
+			adap,
+			(uint8_t *) preq,
+			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
+			(uint8_t *) prsp,
+			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTUNESTAT_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
+	pstatus->signal_strength  =
+		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
+	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
+	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_get_tps - send get TPS command to AS10x
+ * @adap:      pointer to AS10x handle
+ * @ptps:      pointer to TPS parameters structure
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.get_tps.req));
+
+	/* fill command */
+	pcmd->body.get_tune_status.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GETTPS);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
+					    (uint8_t *) pcmd,
+					    sizeof(pcmd->body.get_tps.req) +
+					    HEADER_SIZE,
+					    (uint8_t *) prsp,
+					    sizeof(prsp->body.get_tps.rsp) +
+					    HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTPS_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	ptps->modulation = prsp->body.get_tps.rsp.tps.modulation;
+	ptps->hierarchy = prsp->body.get_tps.rsp.tps.hierarchy;
+	ptps->interleaving_mode = prsp->body.get_tps.rsp.tps.interleaving_mode;
+	ptps->code_rate_HP = prsp->body.get_tps.rsp.tps.code_rate_HP;
+	ptps->code_rate_LP = prsp->body.get_tps.rsp.tps.code_rate_LP;
+	ptps->guard_interval = prsp->body.get_tps.rsp.tps.guard_interval;
+	ptps->transmission_mode  = prsp->body.get_tps.rsp.tps.transmission_mode;
+	ptps->DVBH_mask_HP = prsp->body.get_tps.rsp.tps.DVBH_mask_HP;
+	ptps->DVBH_mask_LP = prsp->body.get_tps.rsp.tps.DVBH_mask_LP;
+	ptps->cell_ID = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_get_demod_stats - send get demod stats command to AS10x
+ * @adap:          pointer to AS10x bus adapter
+ * @pdemod_stats:  pointer to demod stats parameters structure
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
+			      struct as10x_demod_stats *pdemod_stats)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.get_demod_stats.req));
+
+	/* fill command */
+	pcmd->body.get_demod_stats.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.get_demod_stats.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.get_demod_stats.rsp)
+				+ HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_DEMOD_STATS_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	pdemod_stats->frame_count =
+		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
+	pdemod_stats->bad_frame_count =
+		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
+	pdemod_stats->bytes_fixed_by_rs =
+		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
+	pdemod_stats->mer =
+		le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
+	pdemod_stats->has_started =
+		prsp->body.get_demod_stats.rsp.stats.has_started;
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_get_impulse_resp - send get impulse response command to AS10x
+ * @adap:     pointer to AS10x bus adapter
+ * @is_ready: pointer to value indicating when impulse
+ *	      response data is ready
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
+			       uint8_t *is_ready)
+{
+	int error = AS10X_CMD_ERROR;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.get_impulse_rsp.req));
+
+	/* fill command */
+	pcmd->body.get_impulse_rsp.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap,
+					(uint8_t *) pcmd,
+					sizeof(pcmd->body.get_impulse_rsp.req)
+					+ HEADER_SIZE,
+					(uint8_t *) prsp,
+					sizeof(prsp->body.get_impulse_rsp.rsp)
+					+ HEADER_SIZE);
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_IMPULSE_RESP_RSP);
+	if (error < 0)
+		goto out;
+
+	/* Response OK -> get response data */
+	*is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_build - build AS10x command header
+ * @pcmd:     pointer to AS10x command buffer
+ * @xid:      sequence id of the command
+ * @cmd_len:  length of the command
+ */
+void as10x_cmd_build(struct as10x_cmd_t *pcmd,
+		     uint16_t xid, uint16_t cmd_len)
+{
+	pcmd->header.req_id = cpu_to_le16(xid);
+	pcmd->header.prog = cpu_to_le16(SERVICE_PROG_ID);
+	pcmd->header.version = cpu_to_le16(SERVICE_PROG_VERSION);
+	pcmd->header.data_len = cpu_to_le16(cmd_len);
+}
+
+/**
+ * as10x_rsp_parse - Parse command response
+ * @prsp:       pointer to AS10x command buffer
+ * @proc_id:    id of the command
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
+{
+	int error;
+
+	/* extract command error code */
+	error = prsp->body.common.rsp.error;
+
+	if ((error == 0) &&
+	    (le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
+		return 0;
+	}
+
+	return AS10X_CMD_ERROR;
+}
diff --git a/drivers/media/usb/as102/as10x_cmd.h b/drivers/media/usb/as102/as10x_cmd.h
new file mode 100644
index 000000000000..e21ec6c702a9
--- /dev/null
+++ b/drivers/media/usb/as102/as10x_cmd.h
@@ -0,0 +1,529 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _AS10X_CMD_H_
+#define _AS10X_CMD_H_
+
+#ifdef __KERNEL__
+#include <linux/kernel.h>
+#endif
+
+#include "as10x_types.h"
+
+/*********************************/
+/*       MACRO DEFINITIONS       */
+/*********************************/
+#define AS10X_CMD_ERROR		-1
+
+#define SERVICE_PROG_ID		0x0002
+#define SERVICE_PROG_VERSION	0x0001
+
+#define HIER_NONE		0x00
+#define HIER_LOW_PRIORITY	0x01
+
+#define HEADER_SIZE (sizeof(struct as10x_cmd_header_t))
+
+/* context request types */
+#define GET_CONTEXT_DATA	1
+#define SET_CONTEXT_DATA	2
+
+/* ODSP suspend modes */
+#define CFG_MODE_ODSP_RESUME	0
+#define CFG_MODE_ODSP_SUSPEND	1
+
+/* Dump memory size */
+#define DUMP_BLOCK_SIZE_MAX	0x20
+
+/*********************************/
+/*     TYPE DEFINITION           */
+/*********************************/
+enum control_proc {
+	CONTROL_PROC_TURNON			= 0x0001,
+	CONTROL_PROC_TURNON_RSP			= 0x0100,
+	CONTROL_PROC_SET_REGISTER		= 0x0002,
+	CONTROL_PROC_SET_REGISTER_RSP		= 0x0200,
+	CONTROL_PROC_GET_REGISTER		= 0x0003,
+	CONTROL_PROC_GET_REGISTER_RSP		= 0x0300,
+	CONTROL_PROC_SETTUNE			= 0x000A,
+	CONTROL_PROC_SETTUNE_RSP		= 0x0A00,
+	CONTROL_PROC_GETTUNESTAT		= 0x000B,
+	CONTROL_PROC_GETTUNESTAT_RSP		= 0x0B00,
+	CONTROL_PROC_GETTPS			= 0x000D,
+	CONTROL_PROC_GETTPS_RSP			= 0x0D00,
+	CONTROL_PROC_SETFILTER			= 0x000E,
+	CONTROL_PROC_SETFILTER_RSP		= 0x0E00,
+	CONTROL_PROC_REMOVEFILTER		= 0x000F,
+	CONTROL_PROC_REMOVEFILTER_RSP		= 0x0F00,
+	CONTROL_PROC_GET_IMPULSE_RESP		= 0x0012,
+	CONTROL_PROC_GET_IMPULSE_RESP_RSP	= 0x1200,
+	CONTROL_PROC_START_STREAMING		= 0x0013,
+	CONTROL_PROC_START_STREAMING_RSP	= 0x1300,
+	CONTROL_PROC_STOP_STREAMING		= 0x0014,
+	CONTROL_PROC_STOP_STREAMING_RSP		= 0x1400,
+	CONTROL_PROC_GET_DEMOD_STATS		= 0x0015,
+	CONTROL_PROC_GET_DEMOD_STATS_RSP	= 0x1500,
+	CONTROL_PROC_ELNA_CHANGE_MODE		= 0x0016,
+	CONTROL_PROC_ELNA_CHANGE_MODE_RSP	= 0x1600,
+	CONTROL_PROC_ODSP_CHANGE_MODE		= 0x0017,
+	CONTROL_PROC_ODSP_CHANGE_MODE_RSP	= 0x1700,
+	CONTROL_PROC_AGC_CHANGE_MODE		= 0x0018,
+	CONTROL_PROC_AGC_CHANGE_MODE_RSP	= 0x1800,
+
+	CONTROL_PROC_CONTEXT			= 0x00FC,
+	CONTROL_PROC_CONTEXT_RSP		= 0xFC00,
+	CONTROL_PROC_DUMP_MEMORY		= 0x00FD,
+	CONTROL_PROC_DUMP_MEMORY_RSP		= 0xFD00,
+	CONTROL_PROC_DUMPLOG_MEMORY		= 0x00FE,
+	CONTROL_PROC_DUMPLOG_MEMORY_RSP		= 0xFE00,
+	CONTROL_PROC_TURNOFF			= 0x00FF,
+	CONTROL_PROC_TURNOFF_RSP		= 0xFF00
+};
+
+union as10x_turn_on {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_turn_off {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t err;
+	} __packed rsp;
+} __packed;
+
+union as10x_set_tune {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* tune params */
+		struct as10x_tune_args args;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_get_tune_status {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* tune status */
+		struct as10x_tune_status sts;
+	} __packed rsp;
+} __packed;
+
+union as10x_get_tps {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* tps details */
+		struct as10x_tps tps;
+	} __packed rsp;
+} __packed;
+
+union as10x_common {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t  proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_add_pid_filter {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t  proc_id;
+		/* PID to filter */
+		uint16_t  pid;
+		/* stream type (MPE, PSI/SI or PES )*/
+		uint8_t stream_type;
+		/* PID index in filter table */
+		uint8_t idx;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+		/* Filter id */
+		uint8_t filter_id;
+	} __packed rsp;
+} __packed;
+
+union as10x_del_pid_filter {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t  proc_id;
+		/* PID to remove */
+		uint16_t  pid;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* response error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_start_streaming {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_stop_streaming {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_get_demod_stats {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* demod stats */
+		struct as10x_demod_stats stats;
+	} __packed rsp;
+} __packed;
+
+union as10x_get_impulse_resp {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* impulse response ready */
+		uint8_t is_ready;
+	} __packed rsp;
+} __packed;
+
+union as10x_fw_context {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* value to write (for set context)*/
+		struct as10x_register_value reg_val;
+		/* context tag */
+		uint16_t tag;
+		/* context request type */
+		uint16_t type;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* value read (for get context) */
+		struct as10x_register_value reg_val;
+		/* context request type */
+		uint16_t type;
+		/* error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_set_register {
+	/* request */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+		/* register content */
+		struct as10x_register_value reg_val;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+union as10x_get_register {
+	/* request */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* register content */
+		struct as10x_register_value reg_val;
+	} __packed rsp;
+} __packed;
+
+union as10x_cfg_change_mode {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* mode */
+		uint8_t mode;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+	} __packed rsp;
+} __packed;
+
+struct as10x_cmd_header_t {
+	uint16_t req_id;
+	uint16_t prog;
+	uint16_t version;
+	uint16_t data_len;
+} __packed;
+
+#define DUMP_BLOCK_SIZE 16
+
+union as10x_dump_memory {
+	/* request */
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* dump memory type request */
+		uint8_t dump_req;
+		/* register description */
+		struct as10x_register_addr reg_addr;
+		/* nb blocks to read */
+		uint16_t num_blocks;
+	} __packed req;
+	/* response */
+	struct {
+		/* response identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* dump response */
+		uint8_t dump_rsp;
+		/* data */
+		union {
+			uint8_t  data8[DUMP_BLOCK_SIZE];
+			uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
+			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
+		} __packed u;
+	} __packed rsp;
+} __packed;
+
+union as10x_dumplog_memory {
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* dump memory type request */
+		uint8_t dump_req;
+	} __packed req;
+	struct {
+		/* request identifier */
+		uint16_t proc_id;
+		/* error */
+		uint8_t error;
+		/* dump response */
+		uint8_t dump_rsp;
+		/* dump data */
+		uint8_t data[DUMP_BLOCK_SIZE];
+	} __packed rsp;
+} __packed;
+
+union as10x_raw_data {
+	/* request */
+	struct {
+		uint16_t proc_id;
+		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
+			     - 2 /* proc_id */];
+	} __packed req;
+	/* response */
+	struct {
+		uint16_t proc_id;
+		uint8_t error;
+		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
+			     - 2 /* proc_id */ - 1 /* rc */];
+	} __packed rsp;
+} __packed;
+
+struct as10x_cmd_t {
+	struct as10x_cmd_header_t header;
+	union {
+		union as10x_turn_on		turn_on;
+		union as10x_turn_off		turn_off;
+		union as10x_set_tune		set_tune;
+		union as10x_get_tune_status	get_tune_status;
+		union as10x_get_tps		get_tps;
+		union as10x_common		common;
+		union as10x_add_pid_filter	add_pid_filter;
+		union as10x_del_pid_filter	del_pid_filter;
+		union as10x_start_streaming	start_streaming;
+		union as10x_stop_streaming	stop_streaming;
+		union as10x_get_demod_stats	get_demod_stats;
+		union as10x_get_impulse_resp	get_impulse_rsp;
+		union as10x_fw_context		context;
+		union as10x_set_register	set_register;
+		union as10x_get_register	get_register;
+		union as10x_cfg_change_mode	cfg_change_mode;
+		union as10x_dump_memory		dump_memory;
+		union as10x_dumplog_memory	dumplog_memory;
+		union as10x_raw_data		raw_data;
+	} __packed body;
+} __packed;
+
+struct as10x_token_cmd_t {
+	/* token cmd */
+	struct as10x_cmd_t c;
+	/* token response */
+	struct as10x_cmd_t r;
+} __packed;
+
+
+/**************************/
+/* FUNCTION DECLARATION   */
+/**************************/
+
+void as10x_cmd_build(struct as10x_cmd_t *pcmd, uint16_t proc_id,
+		      uint16_t cmd_len);
+int as10x_rsp_parse(struct as10x_cmd_t *r, uint16_t proc_id);
+
+/* as10x cmd */
+int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap);
+int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap);
+
+int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
+		       struct as10x_tune_args *ptune);
+
+int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
+			      struct as10x_tune_status *pstatus);
+
+int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap,
+		      struct as10x_tps *ptps);
+
+int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t  *adap,
+			      struct as10x_demod_stats *pdemod_stats);
+
+int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
+			       uint8_t *is_ready);
+
+/* as10x cmd stream */
+int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
+			     struct as10x_ts_filter *filter);
+int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
+			     uint16_t pid_value);
+
+int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap);
+int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap);
+
+/* as10x cmd cfg */
+int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap,
+			  uint16_t tag,
+			  uint32_t value);
+int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap,
+			  uint16_t tag,
+			  uint32_t *pvalue);
+
+int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode);
+int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
+#endif
diff --git a/drivers/media/usb/as102/as10x_cmd_cfg.c b/drivers/media/usb/as102/as10x_cmd_cfg.c
new file mode 100644
index 000000000000..b1e300d88753
--- /dev/null
+++ b/drivers/media/usb/as102/as10x_cmd_cfg.c
@@ -0,0 +1,206 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include "as102_drv.h"
+#include "as10x_types.h"
+#include "as10x_cmd.h"
+
+/***************************/
+/* FUNCTION DEFINITION     */
+/***************************/
+
+/**
+ * as10x_cmd_get_context - Send get context command to AS10x
+ * @adap:      pointer to AS10x bus adapter
+ * @tag:       context tag
+ * @pvalue:    pointer where to store context value read
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
+			  uint32_t *pvalue)
+{
+	int  error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.context.req));
+
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(GET_CONTEXT_DATA);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error  = adap->ops->xfer_cmd(adap,
+					     (uint8_t *) pcmd,
+					     sizeof(pcmd->body.context.req)
+					     + HEADER_SIZE,
+					     (uint8_t *) prsp,
+					     sizeof(prsp->body.context.rsp)
+					     + HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response: context command do not follow the common response */
+	/* structure -> specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+
+	if (error == 0) {
+		/* Response OK -> get response data */
+		*pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
+		/* value returned is always a 32-bit value */
+	}
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_set_context - send set context command to AS10x
+ * @adap:      pointer to AS10x bus adapter
+ * @tag:       context tag
+ * @value:     value to set in context
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
+			  uint32_t value)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.context.req));
+
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	/* pcmd->body.context.req.reg_val.mode initialization is not required */
+	pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(SET_CONTEXT_DATA);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error  = adap->ops->xfer_cmd(adap,
+					     (uint8_t *) pcmd,
+					     sizeof(pcmd->body.context.req)
+					     + HEADER_SIZE,
+					     (uint8_t *) prsp,
+					     sizeof(prsp->body.context.rsp)
+					     + HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response: context command do not follow the common response */
+	/* structure -> specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_eLNA_change_mode - send eLNA change mode command to AS10x
+ * @adap:      pointer to AS10x bus adapter
+ * @mode:      mode selected:
+ *	        - ON    : 0x0 => eLNA always ON
+ *	        - OFF   : 0x1 => eLNA always OFF
+ *	        - AUTO  : 0x2 => eLNA follow hysteresis parameters
+ *				 to be ON or OFF
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.cfg_change_mode.req));
+
+	/* fill command */
+	pcmd->body.cfg_change_mode.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
+	pcmd->body.cfg_change_mode.req.mode = mode;
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error  = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+				sizeof(pcmd->body.cfg_change_mode.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.cfg_change_mode.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_context_rsp_parse - Parse context command response
+ * @prsp:       pointer to AS10x command response buffer
+ * @proc_id:    id of the command
+ *
+ * Since the contex command response does not follow the common
+ * response, a specific parse function is required.
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
+{
+	int err;
+
+	err = prsp->body.context.rsp.error;
+
+	if ((err == 0) &&
+	    (le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
+		return 0;
+	}
+	return AS10X_CMD_ERROR;
+}
diff --git a/drivers/media/usb/as102/as10x_cmd_stream.c b/drivers/media/usb/as102/as10x_cmd_stream.c
new file mode 100644
index 000000000000..1088ca1fe92f
--- /dev/null
+++ b/drivers/media/usb/as102/as10x_cmd_stream.c
@@ -0,0 +1,211 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include "as102_drv.h"
+#include "as10x_cmd.h"
+
+/**
+ * as10x_cmd_add_PID_filter - send add filter command to AS10x
+ * @adap:      pointer to AS10x bus adapter
+ * @filter:    TSFilter filter for DVB-T
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
+			     struct as10x_ts_filter *filter)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.add_pid_filter.req));
+
+	/* fill command */
+	pcmd->body.add_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_SETFILTER);
+	pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
+	pcmd->body.add_pid_filter.req.stream_type = filter->type;
+
+	if (filter->idx < 16)
+		pcmd->body.add_pid_filter.req.idx = filter->idx;
+	else
+		pcmd->body.add_pid_filter.req.idx = 0xFF;
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+				sizeof(pcmd->body.add_pid_filter.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.add_pid_filter.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
+
+	if (error == 0) {
+		/* Response OK -> get response data */
+		filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
+	}
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_del_PID_filter - Send delete filter command to AS10x
+ * @adap:         pointer to AS10x bus adapte
+ * @pid_value:    PID to delete
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
+			     uint16_t pid_value)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.del_pid_filter.req));
+
+	/* fill command */
+	pcmd->body.del_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
+	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+				sizeof(pcmd->body.del_pid_filter.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.del_pid_filter.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_start_streaming - Send start streaming command to AS10x
+ * @adap:   pointer to AS10x bus adapter
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.start_streaming.req));
+
+	/* fill command */
+	pcmd->body.start_streaming.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_START_STREAMING);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+				sizeof(pcmd->body.start_streaming.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.start_streaming.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);
+
+out:
+	return error;
+}
+
+/**
+ * as10x_cmd_stop_streaming - Send stop streaming command to AS10x
+ * @adap:   pointer to AS10x bus adapter
+ *
+ * Return 0 on success or negative value in case of error.
+ */
+int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap)
+{
+	int8_t error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	pcmd = adap->cmd;
+	prsp = adap->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++adap->cmd_xid),
+			sizeof(pcmd->body.stop_streaming.req));
+
+	/* fill command */
+	pcmd->body.stop_streaming.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
+
+	/* send command */
+	if (adap->ops->xfer_cmd) {
+		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
+				sizeof(pcmd->body.stop_streaming.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.stop_streaming.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error < 0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);
+
+out:
+	return error;
+}
diff --git a/drivers/media/usb/as102/as10x_handle.h b/drivers/media/usb/as102/as10x_handle.h
new file mode 100644
index 000000000000..5638b191b780
--- /dev/null
+++ b/drivers/media/usb/as102/as10x_handle.h
@@ -0,0 +1,54 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifdef __KERNEL__
+struct as10x_bus_adapter_t;
+struct as102_dev_t;
+
+#include "as10x_cmd.h"
+
+/* values for "mode" field */
+#define REGMODE8	8
+#define REGMODE16	16
+#define REGMODE32	32
+
+struct as102_priv_ops_t {
+	int (*upload_fw_pkt)(struct as10x_bus_adapter_t *bus_adap,
+			      unsigned char *buf, int buflen, int swap32);
+
+	int (*send_cmd)(struct as10x_bus_adapter_t *bus_adap,
+			 unsigned char *buf, int buflen);
+
+	int (*xfer_cmd)(struct as10x_bus_adapter_t *bus_adap,
+			 unsigned char *send_buf, int send_buf_len,
+			 unsigned char *recv_buf, int recv_buf_len);
+
+	int (*start_stream)(struct as102_dev_t *dev);
+	void (*stop_stream)(struct as102_dev_t *dev);
+
+	int (*reset_target)(struct as10x_bus_adapter_t *bus_adap);
+
+	int (*read_write)(struct as10x_bus_adapter_t *bus_adap, uint8_t mode,
+			  uint32_t rd_addr, uint16_t rd_len,
+			  uint32_t wr_addr, uint16_t wr_len);
+
+	int (*as102_read_ep2)(struct as10x_bus_adapter_t *bus_adap,
+			       unsigned char *recv_buf,
+			       int recv_buf_len);
+};
+#endif
diff --git a/drivers/media/usb/as102/as10x_types.h b/drivers/media/usb/as102/as10x_types.h
new file mode 100644
index 000000000000..af26e057d9a2
--- /dev/null
+++ b/drivers/media/usb/as102/as10x_types.h
@@ -0,0 +1,194 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _AS10X_TYPES_H_
+#define _AS10X_TYPES_H_
+
+#include "as10x_handle.h"
+
+/*********************************/
+/*       MACRO DEFINITIONS       */
+/*********************************/
+
+/* bandwidth constant values */
+#define BW_5_MHZ		0x00
+#define BW_6_MHZ		0x01
+#define BW_7_MHZ		0x02
+#define BW_8_MHZ		0x03
+
+/* hierarchy priority selection values */
+#define HIER_NO_PRIORITY	0x00
+#define HIER_LOW_PRIORITY	0x01
+#define HIER_HIGH_PRIORITY	0x02
+
+/* constellation available values */
+#define CONST_QPSK		0x00
+#define CONST_QAM16		0x01
+#define CONST_QAM64		0x02
+#define CONST_UNKNOWN		0xFF
+
+/* hierarchy available values */
+#define HIER_NONE		0x00
+#define HIER_ALPHA_1		0x01
+#define HIER_ALPHA_2		0x02
+#define HIER_ALPHA_4		0x03
+#define HIER_UNKNOWN		0xFF
+
+/* interleaving available values */
+#define INTLV_NATIVE		0x00
+#define INTLV_IN_DEPTH		0x01
+#define INTLV_UNKNOWN		0xFF
+
+/* code rate available values */
+#define CODE_RATE_1_2		0x00
+#define CODE_RATE_2_3		0x01
+#define CODE_RATE_3_4		0x02
+#define CODE_RATE_5_6		0x03
+#define CODE_RATE_7_8		0x04
+#define CODE_RATE_UNKNOWN	0xFF
+
+/* guard interval available values */
+#define GUARD_INT_1_32		0x00
+#define GUARD_INT_1_16		0x01
+#define GUARD_INT_1_8		0x02
+#define GUARD_INT_1_4		0x03
+#define GUARD_UNKNOWN		0xFF
+
+/* transmission mode available values */
+#define TRANS_MODE_2K		0x00
+#define TRANS_MODE_8K		0x01
+#define TRANS_MODE_4K		0x02
+#define TRANS_MODE_UNKNOWN	0xFF
+
+/* DVBH signalling available values */
+#define TIMESLICING_PRESENT	0x01
+#define MPE_FEC_PRESENT		0x02
+
+/* tune state available */
+#define TUNE_STATUS_NOT_TUNED		0x00
+#define TUNE_STATUS_IDLE		0x01
+#define TUNE_STATUS_LOCKING		0x02
+#define TUNE_STATUS_SIGNAL_DVB_OK	0x03
+#define TUNE_STATUS_STREAM_DETECTED	0x04
+#define TUNE_STATUS_STREAM_TUNED	0x05
+#define TUNE_STATUS_ERROR		0xFF
+
+/* available TS FID filter types */
+#define TS_PID_TYPE_TS		0
+#define TS_PID_TYPE_PSI_SI	1
+#define TS_PID_TYPE_MPE		2
+
+/* number of echos available */
+#define MAX_ECHOS	15
+
+/* Context types */
+#define CONTEXT_LNA			1010
+#define CONTEXT_ELNA_HYSTERESIS		4003
+#define CONTEXT_ELNA_GAIN		4004
+#define CONTEXT_MER_THRESHOLD		5005
+#define CONTEXT_MER_OFFSET		5006
+#define CONTEXT_IR_STATE		7000
+#define CONTEXT_TSOUT_MSB_FIRST		7004
+#define CONTEXT_TSOUT_FALLING_EDGE	7005
+
+/* Configuration modes */
+#define CFG_MODE_ON	0
+#define CFG_MODE_OFF	1
+#define CFG_MODE_AUTO	2
+
+struct as10x_tps {
+	uint8_t modulation;
+	uint8_t hierarchy;
+	uint8_t interleaving_mode;
+	uint8_t code_rate_HP;
+	uint8_t code_rate_LP;
+	uint8_t guard_interval;
+	uint8_t transmission_mode;
+	uint8_t DVBH_mask_HP;
+	uint8_t DVBH_mask_LP;
+	uint16_t cell_ID;
+} __packed;
+
+struct as10x_tune_args {
+	/* frequency */
+	uint32_t freq;
+	/* bandwidth */
+	uint8_t bandwidth;
+	/* hierarchy selection */
+	uint8_t hier_select;
+	/* constellation */
+	uint8_t modulation;
+	/* hierarchy */
+	uint8_t hierarchy;
+	/* interleaving mode */
+	uint8_t interleaving_mode;
+	/* code rate */
+	uint8_t code_rate;
+	/* guard interval */
+	uint8_t guard_interval;
+	/* transmission mode */
+	uint8_t transmission_mode;
+} __packed;
+
+struct as10x_tune_status {
+	/* tune status */
+	uint8_t tune_state;
+	/* signal strength */
+	int16_t signal_strength;
+	/* packet error rate 10^-4 */
+	uint16_t PER;
+	/* bit error rate 10^-4 */
+	uint16_t BER;
+} __packed;
+
+struct as10x_demod_stats {
+	/* frame counter */
+	uint32_t frame_count;
+	/* Bad frame counter */
+	uint32_t bad_frame_count;
+	/* Number of wrong bytes fixed by Reed-Solomon */
+	uint32_t bytes_fixed_by_rs;
+	/* Averaged MER */
+	uint16_t mer;
+	/* statistics calculation state indicator (started or not) */
+	uint8_t has_started;
+} __packed;
+
+struct as10x_ts_filter {
+	uint16_t pid;  /* valid PID value 0x00 : 0x2000 */
+	uint8_t  type; /* Red TS_PID_TYPE_<N> values */
+	uint8_t  idx;  /* index in filtering table */
+} __packed;
+
+struct as10x_register_value {
+	uint8_t mode;
+	union {
+		uint8_t  value8;   /* 8 bit value */
+		uint16_t value16;  /* 16 bit value */
+		uint32_t value32;  /* 32 bit value */
+	} __packed u;
+} __packed;
+
+struct as10x_register_addr {
+	/* register addr */
+	uint32_t addr;
+	/* register mode access */
+	uint8_t mode;
+};
+
+#endif
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 3323eb5e77b0..655cf5037b0b 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -19,8 +19,6 @@ menuconfig STAGING_MEDIA
 if STAGING_MEDIA
 
 # Please keep them in alphabetic order
-source "drivers/staging/media/as102/Kconfig"
-
 source "drivers/staging/media/bcm2048/Kconfig"
 
 source "drivers/staging/media/cxd2099/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 7db83f373f63..6dbe578178cd 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,4 +1,3 @@
-obj-$(CONFIG_DVB_AS102)		+= as102/
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
diff --git a/drivers/staging/media/as102/Kconfig b/drivers/staging/media/as102/Kconfig
deleted file mode 100644
index 28aba00dc629..000000000000
--- a/drivers/staging/media/as102/Kconfig
+++ /dev/null
@@ -1,8 +0,0 @@
-config DVB_AS102
-	tristate "Abilis AS102 DVB receiver"
-	depends on DVB_CORE && USB && I2C && INPUT
-	select FW_LOADER
-	help
-	  Choose Y or M here if you have a device containing an AS102
-
-	  To compile this driver as a module, choose M here
diff --git a/drivers/staging/media/as102/Makefile b/drivers/staging/media/as102/Makefile
deleted file mode 100644
index 8916d8a909bc..000000000000
--- a/drivers/staging/media/as102/Makefile
+++ /dev/null
@@ -1,6 +0,0 @@
-dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
-		as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
-
-obj-$(CONFIG_DVB_AS102) += dvb-as102.o
-
-ccflags-y += -Idrivers/media/dvb-core
diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
deleted file mode 100644
index e0ee618e607a..000000000000
--- a/drivers/staging/media/as102/as102_drv.c
+++ /dev/null
@@ -1,276 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/kref.h>
-#include <linux/uaccess.h>
-#include <linux/usb.h>
-
-/* header file for usb device driver*/
-#include "as102_drv.h"
-#include "as102_fw.h"
-#include "dvbdev.h"
-
-int dual_tuner;
-module_param_named(dual_tuner, dual_tuner, int, 0644);
-MODULE_PARM_DESC(dual_tuner, "Activate Dual-Tuner config (default: off)");
-
-static int fw_upload = 1;
-module_param_named(fw_upload, fw_upload, int, 0644);
-MODULE_PARM_DESC(fw_upload, "Turn on/off default FW upload (default: on)");
-
-static int pid_filtering;
-module_param_named(pid_filtering, pid_filtering, int, 0644);
-MODULE_PARM_DESC(pid_filtering, "Activate HW PID filtering (default: off)");
-
-static int ts_auto_disable;
-module_param_named(ts_auto_disable, ts_auto_disable, int, 0644);
-MODULE_PARM_DESC(ts_auto_disable, "Stream Auto Enable on FW (default: off)");
-
-int elna_enable = 1;
-module_param_named(elna_enable, elna_enable, int, 0644);
-MODULE_PARM_DESC(elna_enable, "Activate eLNA (default: on)");
-
-DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-
-static void as102_stop_stream(struct as102_dev_t *dev)
-{
-	struct as10x_bus_adapter_t *bus_adap;
-
-	if (dev != NULL)
-		bus_adap = &dev->bus_adap;
-	else
-		return;
-
-	if (bus_adap->ops->stop_stream != NULL)
-		bus_adap->ops->stop_stream(dev);
-
-	if (ts_auto_disable) {
-		if (mutex_lock_interruptible(&dev->bus_adap.lock))
-			return;
-
-		if (as10x_cmd_stop_streaming(bus_adap) < 0)
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"as10x_cmd_stop_streaming failed\n");
-
-		mutex_unlock(&dev->bus_adap.lock);
-	}
-}
-
-static int as102_start_stream(struct as102_dev_t *dev)
-{
-	struct as10x_bus_adapter_t *bus_adap;
-	int ret = -EFAULT;
-
-	if (dev != NULL)
-		bus_adap = &dev->bus_adap;
-	else
-		return ret;
-
-	if (bus_adap->ops->start_stream != NULL)
-		ret = bus_adap->ops->start_stream(dev);
-
-	if (ts_auto_disable) {
-		if (mutex_lock_interruptible(&dev->bus_adap.lock))
-			return -EFAULT;
-
-		ret = as10x_cmd_start_streaming(bus_adap);
-
-		mutex_unlock(&dev->bus_adap.lock);
-	}
-
-	return ret;
-}
-
-static int as10x_pid_filter(struct as102_dev_t *dev,
-			    int index, u16 pid, int onoff) {
-
-	struct as10x_bus_adapter_t *bus_adap = &dev->bus_adap;
-	int ret = -EFAULT;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"amutex_lock_interruptible(lock) failed !\n");
-		return -EBUSY;
-	}
-
-	switch (onoff) {
-	case 0:
-		ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
-			index, pid, ret);
-		break;
-	case 1:
-	{
-		struct as10x_ts_filter filter;
-
-		filter.type = TS_PID_TYPE_TS;
-		filter.idx = 0xFF;
-		filter.pid = pid;
-
-		ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
-			index, filter.idx, filter.pid, ret);
-		break;
-	}
-	}
-
-	mutex_unlock(&dev->bus_adap.lock);
-	return ret;
-}
-
-static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
-{
-	int ret = 0;
-	struct dvb_demux *demux = dvbdmxfeed->demux;
-	struct as102_dev_t *as102_dev = demux->priv;
-
-	if (mutex_lock_interruptible(&as102_dev->sem))
-		return -ERESTARTSYS;
-
-	if (pid_filtering)
-		as10x_pid_filter(as102_dev, dvbdmxfeed->index,
-				 dvbdmxfeed->pid, 1);
-
-	if (as102_dev->streaming++ == 0)
-		ret = as102_start_stream(as102_dev);
-
-	mutex_unlock(&as102_dev->sem);
-	return ret;
-}
-
-static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
-{
-	struct dvb_demux *demux = dvbdmxfeed->demux;
-	struct as102_dev_t *as102_dev = demux->priv;
-
-	if (mutex_lock_interruptible(&as102_dev->sem))
-		return -ERESTARTSYS;
-
-	if (--as102_dev->streaming == 0)
-		as102_stop_stream(as102_dev);
-
-	if (pid_filtering)
-		as10x_pid_filter(as102_dev, dvbdmxfeed->index,
-				 dvbdmxfeed->pid, 0);
-
-	mutex_unlock(&as102_dev->sem);
-	return 0;
-}
-
-int as102_dvb_register(struct as102_dev_t *as102_dev)
-{
-	struct device *dev = &as102_dev->bus_adap.usb_dev->dev;
-	int ret;
-
-	ret = dvb_register_adapter(&as102_dev->dvb_adap,
-			   as102_dev->name, THIS_MODULE,
-			   dev, adapter_nr);
-	if (ret < 0) {
-		dev_err(dev, "%s: dvb_register_adapter() failed: %d\n",
-			__func__, ret);
-		return ret;
-	}
-
-	as102_dev->dvb_dmx.priv = as102_dev;
-	as102_dev->dvb_dmx.filternum = pid_filtering ? 16 : 256;
-	as102_dev->dvb_dmx.feednum = 256;
-	as102_dev->dvb_dmx.start_feed = as102_dvb_dmx_start_feed;
-	as102_dev->dvb_dmx.stop_feed = as102_dvb_dmx_stop_feed;
-
-	as102_dev->dvb_dmx.dmx.capabilities = DMX_TS_FILTERING |
-					      DMX_SECTION_FILTERING;
-
-	as102_dev->dvb_dmxdev.filternum = as102_dev->dvb_dmx.filternum;
-	as102_dev->dvb_dmxdev.demux = &as102_dev->dvb_dmx.dmx;
-	as102_dev->dvb_dmxdev.capabilities = 0;
-
-	ret = dvb_dmx_init(&as102_dev->dvb_dmx);
-	if (ret < 0) {
-		dev_err(dev, "%s: dvb_dmx_init() failed: %d\n", __func__, ret);
-		goto edmxinit;
-	}
-
-	ret = dvb_dmxdev_init(&as102_dev->dvb_dmxdev, &as102_dev->dvb_adap);
-	if (ret < 0) {
-		dev_err(dev, "%s: dvb_dmxdev_init() failed: %d\n",
-			__func__, ret);
-		goto edmxdinit;
-	}
-
-	ret = as102_dvb_register_fe(as102_dev, &as102_dev->dvb_fe);
-	if (ret < 0) {
-		dev_err(dev, "%s: as102_dvb_register_frontend() failed: %d",
-		    __func__, ret);
-		goto efereg;
-	}
-
-	/* init bus mutex for token locking */
-	mutex_init(&as102_dev->bus_adap.lock);
-
-	/* init start / stop stream mutex */
-	mutex_init(&as102_dev->sem);
-
-	/*
-	 * try to load as102 firmware. If firmware upload failed, we'll be
-	 * able to upload it later.
-	 */
-	if (fw_upload)
-		try_then_request_module(as102_fw_upload(&as102_dev->bus_adap),
-				"firmware_class");
-
-	pr_info("Registered device %s", as102_dev->name);
-	return 0;
-
-efereg:
-	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
-edmxdinit:
-	dvb_dmx_release(&as102_dev->dvb_dmx);
-edmxinit:
-	dvb_unregister_adapter(&as102_dev->dvb_adap);
-	return ret;
-}
-
-void as102_dvb_unregister(struct as102_dev_t *as102_dev)
-{
-	/* unregister as102 frontend */
-	as102_dvb_unregister_fe(&as102_dev->dvb_fe);
-
-	/* unregister demux device */
-	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
-	dvb_dmx_release(&as102_dev->dvb_dmx);
-
-	/* unregister dvb adapter */
-	dvb_unregister_adapter(&as102_dev->dvb_adap);
-
-	pr_info("Unregistered device %s", as102_dev->name);
-}
-
-module_usb_driver(as102_usb_driver);
-
-/* modinfo details */
-MODULE_DESCRIPTION(DRIVER_FULL_NAME);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pierrick Hascoet <pierrick.hascoet@abilis.com>");
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
deleted file mode 100644
index 49d0c4259b00..000000000000
--- a/drivers/staging/media/as102/as102_drv.h
+++ /dev/null
@@ -1,92 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/usb.h>
-#include <dvb_demux.h>
-#include <dvb_frontend.h>
-#include <dmxdev.h>
-#include "as10x_cmd.h"
-#include "as102_usb_drv.h"
-
-#define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
-#define DRIVER_NAME "as10x_usb"
-
-#define debug	as102_debug
-extern struct usb_driver as102_usb_driver;
-extern int elna_enable;
-
-#define AS102_DEVICE_MAJOR	192
-
-#define AS102_USB_BUF_SIZE	512
-#define MAX_STREAM_URB		32
-
-struct as10x_bus_adapter_t {
-	struct usb_device *usb_dev;
-	/* bus token lock */
-	struct mutex lock;
-	/* low level interface for bus adapter */
-	union as10x_bus_token_t {
-		/* usb token */
-		struct as10x_usb_token_cmd_t usb;
-	} token;
-
-	/* token cmd xfer id */
-	uint16_t cmd_xid;
-
-	/* as10x command and response for dvb interface*/
-	struct as10x_cmd_t *cmd, *rsp;
-
-	/* bus adapter private ops callback */
-	struct as102_priv_ops_t *ops;
-};
-
-struct as102_dev_t {
-	const char *name;
-	struct as10x_bus_adapter_t bus_adap;
-	struct list_head device_entry;
-	struct kref kref;
-	uint8_t elna_cfg;
-
-	struct dvb_adapter dvb_adap;
-	struct dvb_frontend dvb_fe;
-	struct dvb_demux dvb_dmx;
-	struct dmxdev dvb_dmxdev;
-
-	/* demodulator stats */
-	struct as10x_demod_stats demod_stats;
-	/* signal strength */
-	uint16_t signal_strength;
-	/* bit error rate */
-	uint32_t ber;
-
-	/* timer handle to trig ts stream download */
-	struct timer_list timer_handle;
-
-	struct mutex sem;
-	dma_addr_t dma_addr;
-	void *stream;
-	int streaming;
-	struct urb *stream_urb[MAX_STREAM_URB];
-};
-
-int as102_dvb_register(struct as102_dev_t *dev);
-void as102_dvb_unregister(struct as102_dev_t *dev);
-
-int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
-int as102_dvb_unregister_fe(struct dvb_frontend *dev);
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
deleted file mode 100644
index 67e55b84493f..000000000000
--- a/drivers/staging/media/as102/as102_fe.c
+++ /dev/null
@@ -1,566 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include "as102_drv.h"
-#include "as10x_types.h"
-#include "as10x_cmd.h"
-
-static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *dst,
-					 struct as10x_tps *src);
-
-static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
-					  struct dtv_frontend_properties *src);
-
-static int as102_fe_set_frontend(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int ret = 0;
-	struct as102_dev_t *dev;
-	struct as10x_tune_args tune_args = { 0 };
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	as102_fe_copy_tune_parameters(&tune_args, p);
-
-	/* send abilis command: SET_TUNE */
-	ret =  as10x_cmd_set_tune(&dev->bus_adap, &tune_args);
-	if (ret != 0)
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	return (ret < 0) ? -EINVAL : 0;
-}
-
-static int as102_fe_get_frontend(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int ret = 0;
-	struct as102_dev_t *dev;
-	struct as10x_tps tps = { 0 };
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	/* send abilis command: GET_TPS */
-	ret = as10x_cmd_get_tps(&dev->bus_adap, &tps);
-
-	if (ret == 0)
-		as10x_fe_copy_tps_parameters(p, &tps);
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	return (ret < 0) ? -EINVAL : 0;
-}
-
-static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
-			struct dvb_frontend_tune_settings *settings) {
-
-	settings->min_delay_ms = 1000;
-
-	return 0;
-}
-
-
-static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	int ret = 0;
-	struct as102_dev_t *dev;
-	struct as10x_tune_status tstate = { 0 };
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	/* send abilis command: GET_TUNE_STATUS */
-	ret = as10x_cmd_get_tune_status(&dev->bus_adap, &tstate);
-	if (ret < 0) {
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"as10x_cmd_get_tune_status failed (err = %d)\n",
-			ret);
-		goto out;
-	}
-
-	dev->signal_strength  = tstate.signal_strength;
-	dev->ber  = tstate.BER;
-
-	switch (tstate.tune_state) {
-	case TUNE_STATUS_SIGNAL_DVB_OK:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		break;
-	case TUNE_STATUS_STREAM_DETECTED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
-		break;
-	case TUNE_STATUS_STREAM_TUNED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
-			FE_HAS_LOCK;
-		break;
-	default:
-		*status = TUNE_STATUS_NOT_TUNED;
-	}
-
-	dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
-			tstate.tune_state, tstate.signal_strength,
-			tstate.PER, tstate.BER);
-
-	if (*status & FE_HAS_LOCK) {
-		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
-			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
-			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
-		} else {
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
-				"bytes corrected: 0x%08x , MER: 0x%04x\n",
-				dev->demod_stats.frame_count,
-				dev->demod_stats.bad_frame_count,
-				dev->demod_stats.bytes_fixed_by_rs,
-				dev->demod_stats.mer);
-		}
-	} else {
-		memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
-	}
-
-out:
-	mutex_unlock(&dev->bus_adap.lock);
-	return ret;
-}
-
-/*
- * Note:
- * - in AS102 SNR=MER
- *   - the SNR will be returned in linear terms, i.e. not in dB
- *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
- *   - the accuracy is >2dB for SNR values outside this range
- */
-static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	*snr = dev->demod_stats.mer;
-
-	return 0;
-}
-
-static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	*ber = dev->ber;
-
-	return 0;
-}
-
-static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
-					 u16 *strength)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	*strength = (((0xffff * 400) * dev->signal_strength + 41000) * 2);
-
-	return 0;
-}
-
-static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	struct as102_dev_t *dev;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (dev->demod_stats.has_started)
-		*ucblocks = dev->demod_stats.bad_frame_count;
-	else
-		*ucblocks = 0;
-
-	return 0;
-}
-
-static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
-{
-	struct as102_dev_t *dev;
-	int ret;
-
-	dev = (struct as102_dev_t *) fe->tuner_priv;
-	if (dev == NULL)
-		return -ENODEV;
-
-	if (mutex_lock_interruptible(&dev->bus_adap.lock))
-		return -EBUSY;
-
-	if (acquire) {
-		if (elna_enable)
-			as10x_cmd_set_context(&dev->bus_adap,
-					      CONTEXT_LNA, dev->elna_cfg);
-
-		ret = as10x_cmd_turn_on(&dev->bus_adap);
-	} else {
-		ret = as10x_cmd_turn_off(&dev->bus_adap);
-	}
-
-	mutex_unlock(&dev->bus_adap.lock);
-
-	return ret;
-}
-
-static struct dvb_frontend_ops as102_fe_ops = {
-	.delsys = { SYS_DVBT },
-	.info = {
-		.name			= "Unknown AS102 device",
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
-		.caps = FE_CAN_INVERSION_AUTO
-			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
-			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
-			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
-			| FE_CAN_QAM_AUTO
-			| FE_CAN_TRANSMISSION_MODE_AUTO
-			| FE_CAN_GUARD_INTERVAL_AUTO
-			| FE_CAN_HIERARCHY_AUTO
-			| FE_CAN_RECOVER
-			| FE_CAN_MUTE_TS
-	},
-
-	.set_frontend		= as102_fe_set_frontend,
-	.get_frontend		= as102_fe_get_frontend,
-	.get_tune_settings	= as102_fe_get_tune_settings,
-
-	.read_status		= as102_fe_read_status,
-	.read_snr		= as102_fe_read_snr,
-	.read_ber		= as102_fe_read_ber,
-	.read_signal_strength	= as102_fe_read_signal_strength,
-	.read_ucblocks		= as102_fe_read_ucblocks,
-	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
-};
-
-int as102_dvb_unregister_fe(struct dvb_frontend *fe)
-{
-	/* unregister frontend */
-	dvb_unregister_frontend(fe);
-
-	/* detach frontend */
-	dvb_frontend_detach(fe);
-
-	return 0;
-}
-
-int as102_dvb_register_fe(struct as102_dev_t *as102_dev,
-			  struct dvb_frontend *dvb_fe)
-{
-	int errno;
-	struct dvb_adapter *dvb_adap;
-
-	if (as102_dev == NULL)
-		return -EINVAL;
-
-	/* extract dvb_adapter */
-	dvb_adap = &as102_dev->dvb_adap;
-
-	/* init frontend callback ops */
-	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
-	strncpy(dvb_fe->ops.info.name, as102_dev->name,
-		sizeof(dvb_fe->ops.info.name));
-
-	/* register dvb frontend */
-	errno = dvb_register_frontend(dvb_adap, dvb_fe);
-	if (errno == 0)
-		dvb_fe->tuner_priv = as102_dev;
-
-	return errno;
-}
-
-static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *fe_tps,
-					 struct as10x_tps *as10x_tps)
-{
-
-	/* extract constellation */
-	switch (as10x_tps->modulation) {
-	case CONST_QPSK:
-		fe_tps->modulation = QPSK;
-		break;
-	case CONST_QAM16:
-		fe_tps->modulation = QAM_16;
-		break;
-	case CONST_QAM64:
-		fe_tps->modulation = QAM_64;
-		break;
-	}
-
-	/* extract hierarchy */
-	switch (as10x_tps->hierarchy) {
-	case HIER_NONE:
-		fe_tps->hierarchy = HIERARCHY_NONE;
-		break;
-	case HIER_ALPHA_1:
-		fe_tps->hierarchy = HIERARCHY_1;
-		break;
-	case HIER_ALPHA_2:
-		fe_tps->hierarchy = HIERARCHY_2;
-		break;
-	case HIER_ALPHA_4:
-		fe_tps->hierarchy = HIERARCHY_4;
-		break;
-	}
-
-	/* extract code rate HP */
-	switch (as10x_tps->code_rate_HP) {
-	case CODE_RATE_1_2:
-		fe_tps->code_rate_HP = FEC_1_2;
-		break;
-	case CODE_RATE_2_3:
-		fe_tps->code_rate_HP = FEC_2_3;
-		break;
-	case CODE_RATE_3_4:
-		fe_tps->code_rate_HP = FEC_3_4;
-		break;
-	case CODE_RATE_5_6:
-		fe_tps->code_rate_HP = FEC_5_6;
-		break;
-	case CODE_RATE_7_8:
-		fe_tps->code_rate_HP = FEC_7_8;
-		break;
-	}
-
-	/* extract code rate LP */
-	switch (as10x_tps->code_rate_LP) {
-	case CODE_RATE_1_2:
-		fe_tps->code_rate_LP = FEC_1_2;
-		break;
-	case CODE_RATE_2_3:
-		fe_tps->code_rate_LP = FEC_2_3;
-		break;
-	case CODE_RATE_3_4:
-		fe_tps->code_rate_LP = FEC_3_4;
-		break;
-	case CODE_RATE_5_6:
-		fe_tps->code_rate_LP = FEC_5_6;
-		break;
-	case CODE_RATE_7_8:
-		fe_tps->code_rate_LP = FEC_7_8;
-		break;
-	}
-
-	/* extract guard interval */
-	switch (as10x_tps->guard_interval) {
-	case GUARD_INT_1_32:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_32;
-		break;
-	case GUARD_INT_1_16:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_16;
-		break;
-	case GUARD_INT_1_8:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_8;
-		break;
-	case GUARD_INT_1_4:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_4;
-		break;
-	}
-
-	/* extract transmission mode */
-	switch (as10x_tps->transmission_mode) {
-	case TRANS_MODE_2K:
-		fe_tps->transmission_mode = TRANSMISSION_MODE_2K;
-		break;
-	case TRANS_MODE_8K:
-		fe_tps->transmission_mode = TRANSMISSION_MODE_8K;
-		break;
-	}
-}
-
-static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
-{
-	uint8_t c;
-
-	switch (arg) {
-	case FEC_1_2:
-		c = CODE_RATE_1_2;
-		break;
-	case FEC_2_3:
-		c = CODE_RATE_2_3;
-		break;
-	case FEC_3_4:
-		c = CODE_RATE_3_4;
-		break;
-	case FEC_5_6:
-		c = CODE_RATE_5_6;
-		break;
-	case FEC_7_8:
-		c = CODE_RATE_7_8;
-		break;
-	default:
-		c = CODE_RATE_UNKNOWN;
-		break;
-	}
-
-	return c;
-}
-
-static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
-			  struct dtv_frontend_properties *params)
-{
-
-	/* set frequency */
-	tune_args->freq = params->frequency / 1000;
-
-	/* fix interleaving_mode */
-	tune_args->interleaving_mode = INTLV_NATIVE;
-
-	switch (params->bandwidth_hz) {
-	case 8000000:
-		tune_args->bandwidth = BW_8_MHZ;
-		break;
-	case 7000000:
-		tune_args->bandwidth = BW_7_MHZ;
-		break;
-	case 6000000:
-		tune_args->bandwidth = BW_6_MHZ;
-		break;
-	default:
-		tune_args->bandwidth = BW_8_MHZ;
-	}
-
-	switch (params->guard_interval) {
-	case GUARD_INTERVAL_1_32:
-		tune_args->guard_interval = GUARD_INT_1_32;
-		break;
-	case GUARD_INTERVAL_1_16:
-		tune_args->guard_interval = GUARD_INT_1_16;
-		break;
-	case GUARD_INTERVAL_1_8:
-		tune_args->guard_interval = GUARD_INT_1_8;
-		break;
-	case GUARD_INTERVAL_1_4:
-		tune_args->guard_interval = GUARD_INT_1_4;
-		break;
-	case GUARD_INTERVAL_AUTO:
-	default:
-		tune_args->guard_interval = GUARD_UNKNOWN;
-		break;
-	}
-
-	switch (params->modulation) {
-	case QPSK:
-		tune_args->modulation = CONST_QPSK;
-		break;
-	case QAM_16:
-		tune_args->modulation = CONST_QAM16;
-		break;
-	case QAM_64:
-		tune_args->modulation = CONST_QAM64;
-		break;
-	default:
-		tune_args->modulation = CONST_UNKNOWN;
-		break;
-	}
-
-	switch (params->transmission_mode) {
-	case TRANSMISSION_MODE_2K:
-		tune_args->transmission_mode = TRANS_MODE_2K;
-		break;
-	case TRANSMISSION_MODE_8K:
-		tune_args->transmission_mode = TRANS_MODE_8K;
-		break;
-	default:
-		tune_args->transmission_mode = TRANS_MODE_UNKNOWN;
-	}
-
-	switch (params->hierarchy) {
-	case HIERARCHY_NONE:
-		tune_args->hierarchy = HIER_NONE;
-		break;
-	case HIERARCHY_1:
-		tune_args->hierarchy = HIER_ALPHA_1;
-		break;
-	case HIERARCHY_2:
-		tune_args->hierarchy = HIER_ALPHA_2;
-		break;
-	case HIERARCHY_4:
-		tune_args->hierarchy = HIER_ALPHA_4;
-		break;
-	case HIERARCHY_AUTO:
-		tune_args->hierarchy = HIER_UNKNOWN;
-		break;
-	}
-
-	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
-			params->frequency,
-			tune_args->bandwidth,
-			tune_args->guard_interval);
-
-	/*
-	 * Detect a hierarchy selection
-	 * if HP/LP are both set to FEC_NONE, HP will be selected.
-	 */
-	if ((tune_args->hierarchy != HIER_NONE) &&
-		       ((params->code_rate_LP == FEC_NONE) ||
-			(params->code_rate_HP == FEC_NONE))) {
-
-		if (params->code_rate_LP == FEC_NONE) {
-			tune_args->hier_select = HIER_HIGH_PRIORITY;
-			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->code_rate_HP);
-		}
-
-		if (params->code_rate_HP == FEC_NONE) {
-			tune_args->hier_select = HIER_LOW_PRIORITY;
-			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->code_rate_LP);
-		}
-
-		pr_debug("as102: \thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
-			tune_args->hierarchy,
-			tune_args->hier_select == HIER_HIGH_PRIORITY ?
-			"HP" : "LP",
-			tune_args->hier_select == HIER_HIGH_PRIORITY ?
-			"HP" : "LP",
-			tune_args->code_rate);
-	} else {
-		tune_args->code_rate =
-			as102_fe_get_code_rate(params->code_rate_HP);
-	}
-}
diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
deleted file mode 100644
index f33f752c0aad..000000000000
--- a/drivers/staging/media/as102/as102_fw.c
+++ /dev/null
@@ -1,232 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/ctype.h>
-#include <linux/delay.h>
-#include <linux/firmware.h>
-
-#include "as102_drv.h"
-#include "as102_fw.h"
-
-static const char as102_st_fw1[] = "as102_data1_st.hex";
-static const char as102_st_fw2[] = "as102_data2_st.hex";
-static const char as102_dt_fw1[] = "as102_data1_dt.hex";
-static const char as102_dt_fw2[] = "as102_data2_dt.hex";
-
-static unsigned char atohx(unsigned char *dst, char *src)
-{
-	unsigned char value = 0;
-
-	char msb = tolower(*src) - '0';
-	char lsb = tolower(*(src + 1)) - '0';
-
-	if (msb > 9)
-		msb -= 7;
-	if (lsb > 9)
-		lsb -= 7;
-
-	*dst = value = ((msb & 0xF) << 4) | (lsb & 0xF);
-	return value;
-}
-
-/*
- * Parse INTEL HEX firmware file to extract address and data.
- */
-static int parse_hex_line(unsigned char *fw_data, unsigned char *addr,
-			  unsigned char *data, int *dataLength,
-			  unsigned char *addr_has_changed) {
-
-	int count = 0;
-	unsigned char *src, dst;
-
-	if (*fw_data++ != ':') {
-		pr_err("invalid firmware file\n");
-		return -EFAULT;
-	}
-
-	/* locate end of line */
-	for (src = fw_data; *src != '\n'; src += 2) {
-		atohx(&dst, src);
-		/* parse line to split addr / data */
-		switch (count) {
-		case 0:
-			*dataLength = dst;
-			break;
-		case 1:
-			addr[2] = dst;
-			break;
-		case 2:
-			addr[3] = dst;
-			break;
-		case 3:
-			/* check if data is an address */
-			if (dst == 0x04)
-				*addr_has_changed = 1;
-			else
-				*addr_has_changed = 0;
-			break;
-		case  4:
-		case  5:
-			if (*addr_has_changed)
-				addr[(count - 4)] = dst;
-			else
-				data[(count - 4)] = dst;
-			break;
-		default:
-			data[(count - 4)] = dst;
-			break;
-		}
-		count++;
-	}
-
-	/* return read value + ':' + '\n' */
-	return (count * 2) + 2;
-}
-
-static int as102_firmware_upload(struct as10x_bus_adapter_t *bus_adap,
-				 unsigned char *cmd,
-				 const struct firmware *firmware) {
-
-	struct as10x_fw_pkt_t fw_pkt;
-	int total_read_bytes = 0, errno = 0;
-	unsigned char addr_has_changed = 0;
-
-	for (total_read_bytes = 0; total_read_bytes < firmware->size; ) {
-		int read_bytes = 0, data_len = 0;
-
-		/* parse intel hex line */
-		read_bytes = parse_hex_line(
-				(u8 *) (firmware->data + total_read_bytes),
-				fw_pkt.raw.address,
-				fw_pkt.raw.data,
-				&data_len,
-				&addr_has_changed);
-
-		if (read_bytes <= 0)
-			goto error;
-
-		/* detect the end of file */
-		total_read_bytes += read_bytes;
-		if (total_read_bytes == firmware->size) {
-			fw_pkt.u.request[0] = 0x00;
-			fw_pkt.u.request[1] = 0x03;
-
-			/* send EOF command */
-			errno = bus_adap->ops->upload_fw_pkt(bus_adap,
-							     (uint8_t *)
-							     &fw_pkt, 2, 0);
-			if (errno < 0)
-				goto error;
-		} else {
-			if (!addr_has_changed) {
-				/* prepare command to send */
-				fw_pkt.u.request[0] = 0x00;
-				fw_pkt.u.request[1] = 0x01;
-
-				data_len += sizeof(fw_pkt.u.request);
-				data_len += sizeof(fw_pkt.raw.address);
-
-				/* send cmd to device */
-				errno = bus_adap->ops->upload_fw_pkt(bus_adap,
-								     (uint8_t *)
-								     &fw_pkt,
-								     data_len,
-								     0);
-				if (errno < 0)
-					goto error;
-			}
-		}
-	}
-error:
-	return (errno == 0) ? total_read_bytes : errno;
-}
-
-int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap)
-{
-	int errno = -EFAULT;
-	const struct firmware *firmware = NULL;
-	unsigned char *cmd_buf = NULL;
-	const char *fw1, *fw2;
-	struct usb_device *dev = bus_adap->usb_dev;
-
-	/* select fw file to upload */
-	if (dual_tuner) {
-		fw1 = as102_dt_fw1;
-		fw2 = as102_dt_fw2;
-	} else {
-		fw1 = as102_st_fw1;
-		fw2 = as102_st_fw2;
-	}
-
-	/* allocate buffer to store firmware upload command and data */
-	cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL);
-	if (cmd_buf == NULL) {
-		errno = -ENOMEM;
-		goto error;
-	}
-
-	/* request kernel to locate firmware file: part1 */
-	errno = request_firmware(&firmware, fw1, &dev->dev);
-	if (errno < 0) {
-		pr_err("%s: unable to locate firmware file: %s\n",
-		       DRIVER_NAME, fw1);
-		goto error;
-	}
-
-	/* initiate firmware upload */
-	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
-	if (errno < 0) {
-		pr_err("%s: error during firmware upload part1\n",
-		       DRIVER_NAME);
-		goto error;
-	}
-
-	pr_info("%s: firmware: %s loaded with success\n",
-		DRIVER_NAME, fw1);
-	release_firmware(firmware);
-
-	/* wait for boot to complete */
-	mdelay(100);
-
-	/* request kernel to locate firmware file: part2 */
-	errno = request_firmware(&firmware, fw2, &dev->dev);
-	if (errno < 0) {
-		pr_err("%s: unable to locate firmware file: %s\n",
-		       DRIVER_NAME, fw2);
-		goto error;
-	}
-
-	/* initiate firmware upload */
-	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
-	if (errno < 0) {
-		pr_err("%s: error during firmware upload part2\n",
-		       DRIVER_NAME);
-		goto error;
-	}
-
-	pr_info("%s: firmware: %s loaded with success\n",
-		DRIVER_NAME, fw2);
-error:
-	kfree(cmd_buf);
-	release_firmware(firmware);
-
-	return errno;
-}
diff --git a/drivers/staging/media/as102/as102_fw.h b/drivers/staging/media/as102/as102_fw.h
deleted file mode 100644
index 4bfc6849d95a..000000000000
--- a/drivers/staging/media/as102/as102_fw.h
+++ /dev/null
@@ -1,38 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#define MAX_FW_PKT_SIZE	64
-
-extern int dual_tuner;
-
-struct as10x_raw_fw_pkt {
-	unsigned char address[4];
-	unsigned char data[MAX_FW_PKT_SIZE - 6];
-} __packed;
-
-struct as10x_fw_pkt_t {
-	union {
-		unsigned char request[2];
-		unsigned char length[2];
-	} __packed u;
-	struct as10x_raw_fw_pkt raw;
-} __packed;
-
-#ifdef __KERNEL__
-int as102_fw_upload(struct as10x_bus_adapter_t *bus_adap);
-#endif
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
deleted file mode 100644
index 86f83b9b1118..000000000000
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ /dev/null
@@ -1,479 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/usb.h>
-
-#include "as102_drv.h"
-#include "as102_usb_drv.h"
-#include "as102_fw.h"
-
-static void as102_usb_disconnect(struct usb_interface *interface);
-static int as102_usb_probe(struct usb_interface *interface,
-			   const struct usb_device_id *id);
-
-static int as102_usb_start_stream(struct as102_dev_t *dev);
-static void as102_usb_stop_stream(struct as102_dev_t *dev);
-
-static int as102_open(struct inode *inode, struct file *file);
-static int as102_release(struct inode *inode, struct file *file);
-
-static struct usb_device_id as102_usb_id_table[] = {
-	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
-	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
-	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
-	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
-	{ USB_DEVICE(SKY_IT_DIGITAL_KEY_USB_VID, SKY_IT_DIGITAL_KEY_USB_PID) },
-	{ } /* Terminating entry */
-};
-
-/* Note that this table must always have the same number of entries as the
-   as102_usb_id_table struct */
-static const char * const as102_device_names[] = {
-	AS102_REFERENCE_DESIGN,
-	AS102_PCTV_74E,
-	AS102_ELGATO_EYETV_DTT_NAME,
-	AS102_NBOX_DVBT_DONGLE_NAME,
-	AS102_SKY_IT_DIGITAL_KEY_NAME,
-	NULL /* Terminating entry */
-};
-
-/* eLNA configuration: devices built on the reference design work best
-   with 0xA0, while custom designs seem to require 0xC0 */
-static uint8_t const as102_elna_cfg[] = {
-	0xA0,
-	0xC0,
-	0xC0,
-	0xA0,
-	0xA0,
-	0x00 /* Terminating entry */
-};
-
-struct usb_driver as102_usb_driver = {
-	.name		= DRIVER_FULL_NAME,
-	.probe		= as102_usb_probe,
-	.disconnect	= as102_usb_disconnect,
-	.id_table	= as102_usb_id_table
-};
-
-static const struct file_operations as102_dev_fops = {
-	.owner		= THIS_MODULE,
-	.open		= as102_open,
-	.release	= as102_release,
-};
-
-static struct usb_class_driver as102_usb_class_driver = {
-	.name		= "aton2-%d",
-	.fops		= &as102_dev_fops,
-	.minor_base	= AS102_DEVICE_MAJOR,
-};
-
-static int as102_usb_xfer_cmd(struct as10x_bus_adapter_t *bus_adap,
-			      unsigned char *send_buf, int send_buf_len,
-			      unsigned char *recv_buf, int recv_buf_len)
-{
-	int ret = 0;
-
-	if (send_buf != NULL) {
-		ret = usb_control_msg(bus_adap->usb_dev,
-				      usb_sndctrlpipe(bus_adap->usb_dev, 0),
-				      AS102_USB_DEVICE_TX_CTRL_CMD,
-				      USB_DIR_OUT | USB_TYPE_VENDOR |
-				      USB_RECIP_DEVICE,
-				      bus_adap->cmd_xid, /* value */
-				      0, /* index */
-				      send_buf, send_buf_len,
-				      USB_CTRL_SET_TIMEOUT /* 200 */);
-		if (ret < 0) {
-			dev_dbg(&bus_adap->usb_dev->dev,
-				"usb_control_msg(send) failed, err %i\n", ret);
-			return ret;
-		}
-
-		if (ret != send_buf_len) {
-			dev_dbg(&bus_adap->usb_dev->dev,
-			"only wrote %d of %d bytes\n", ret, send_buf_len);
-			return -1;
-		}
-	}
-
-	if (recv_buf != NULL) {
-#ifdef TRACE
-		dev_dbg(bus_adap->usb_dev->dev,
-			"want to read: %d bytes\n", recv_buf_len);
-#endif
-		ret = usb_control_msg(bus_adap->usb_dev,
-				      usb_rcvctrlpipe(bus_adap->usb_dev, 0),
-				      AS102_USB_DEVICE_RX_CTRL_CMD,
-				      USB_DIR_IN | USB_TYPE_VENDOR |
-				      USB_RECIP_DEVICE,
-				      bus_adap->cmd_xid, /* value */
-				      0, /* index */
-				      recv_buf, recv_buf_len,
-				      USB_CTRL_GET_TIMEOUT /* 200 */);
-		if (ret < 0) {
-			dev_dbg(&bus_adap->usb_dev->dev,
-				"usb_control_msg(recv) failed, err %i\n", ret);
-			return ret;
-		}
-#ifdef TRACE
-		dev_dbg(bus_adap->usb_dev->dev,
-			"read %d bytes\n", recv_buf_len);
-#endif
-	}
-
-	return ret;
-}
-
-static int as102_send_ep1(struct as10x_bus_adapter_t *bus_adap,
-			  unsigned char *send_buf,
-			  int send_buf_len,
-			  int swap32)
-{
-	int ret = 0, actual_len;
-
-	ret = usb_bulk_msg(bus_adap->usb_dev,
-			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
-			   send_buf, send_buf_len, &actual_len, 200);
-	if (ret) {
-		dev_dbg(&bus_adap->usb_dev->dev,
-			"usb_bulk_msg(send) failed, err %i\n", ret);
-		return ret;
-	}
-
-	if (actual_len != send_buf_len) {
-		dev_dbg(&bus_adap->usb_dev->dev, "only wrote %d of %d bytes\n",
-			actual_len, send_buf_len);
-		return -1;
-	}
-	return ret ? ret : actual_len;
-}
-
-static int as102_read_ep2(struct as10x_bus_adapter_t *bus_adap,
-		   unsigned char *recv_buf, int recv_buf_len)
-{
-	int ret = 0, actual_len;
-
-	if (recv_buf == NULL)
-		return -EINVAL;
-
-	ret = usb_bulk_msg(bus_adap->usb_dev,
-			   usb_rcvbulkpipe(bus_adap->usb_dev, 2),
-			   recv_buf, recv_buf_len, &actual_len, 200);
-	if (ret) {
-		dev_dbg(&bus_adap->usb_dev->dev,
-			"usb_bulk_msg(recv) failed, err %i\n", ret);
-		return ret;
-	}
-
-	if (actual_len != recv_buf_len) {
-		dev_dbg(&bus_adap->usb_dev->dev, "only read %d of %d bytes\n",
-			actual_len, recv_buf_len);
-		return -1;
-	}
-	return ret ? ret : actual_len;
-}
-
-static struct as102_priv_ops_t as102_priv_ops = {
-	.upload_fw_pkt	= as102_send_ep1,
-	.xfer_cmd	= as102_usb_xfer_cmd,
-	.as102_read_ep2	= as102_read_ep2,
-	.start_stream	= as102_usb_start_stream,
-	.stop_stream	= as102_usb_stop_stream,
-};
-
-static int as102_submit_urb_stream(struct as102_dev_t *dev, struct urb *urb)
-{
-	int err;
-
-	usb_fill_bulk_urb(urb,
-			  dev->bus_adap.usb_dev,
-			  usb_rcvbulkpipe(dev->bus_adap.usb_dev, 0x2),
-			  urb->transfer_buffer,
-			  AS102_USB_BUF_SIZE,
-			  as102_urb_stream_irq,
-			  dev);
-
-	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (err)
-		dev_dbg(&urb->dev->dev,
-			"%s: usb_submit_urb failed\n", __func__);
-
-	return err;
-}
-
-void as102_urb_stream_irq(struct urb *urb)
-{
-	struct as102_dev_t *as102_dev = urb->context;
-
-	if (urb->actual_length > 0) {
-		dvb_dmx_swfilter(&as102_dev->dvb_dmx,
-				 urb->transfer_buffer,
-				 urb->actual_length);
-	} else {
-		if (urb->actual_length == 0)
-			memset(urb->transfer_buffer, 0, AS102_USB_BUF_SIZE);
-	}
-
-	/* is not stopped, re-submit urb */
-	if (as102_dev->streaming)
-		as102_submit_urb_stream(as102_dev, urb);
-}
-
-static void as102_free_usb_stream_buffer(struct as102_dev_t *dev)
-{
-	int i;
-
-	for (i = 0; i < MAX_STREAM_URB; i++)
-		usb_free_urb(dev->stream_urb[i]);
-
-	usb_free_coherent(dev->bus_adap.usb_dev,
-			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
-			dev->stream,
-			dev->dma_addr);
-}
-
-static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
-{
-	int i;
-
-	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
-				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
-				       GFP_KERNEL,
-				       &dev->dma_addr);
-	if (!dev->stream) {
-		dev_dbg(&dev->bus_adap.usb_dev->dev,
-			"%s: usb_buffer_alloc failed\n", __func__);
-		return -ENOMEM;
-	}
-
-	memset(dev->stream, 0, MAX_STREAM_URB * AS102_USB_BUF_SIZE);
-
-	/* init urb buffers */
-	for (i = 0; i < MAX_STREAM_URB; i++) {
-		struct urb *urb;
-
-		urb = usb_alloc_urb(0, GFP_ATOMIC);
-		if (urb == NULL) {
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"%s: usb_alloc_urb failed\n", __func__);
-			as102_free_usb_stream_buffer(dev);
-			return -ENOMEM;
-		}
-
-		urb->transfer_buffer = dev->stream + (i * AS102_USB_BUF_SIZE);
-		urb->transfer_dma = dev->dma_addr + (i * AS102_USB_BUF_SIZE);
-		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_buffer_length = AS102_USB_BUF_SIZE;
-
-		dev->stream_urb[i] = urb;
-	}
-	return 0;
-}
-
-static void as102_usb_stop_stream(struct as102_dev_t *dev)
-{
-	int i;
-
-	for (i = 0; i < MAX_STREAM_URB; i++)
-		usb_kill_urb(dev->stream_urb[i]);
-}
-
-static int as102_usb_start_stream(struct as102_dev_t *dev)
-{
-	int i, ret = 0;
-
-	for (i = 0; i < MAX_STREAM_URB; i++) {
-		ret = as102_submit_urb_stream(dev, dev->stream_urb[i]);
-		if (ret) {
-			as102_usb_stop_stream(dev);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
-static void as102_usb_release(struct kref *kref)
-{
-	struct as102_dev_t *as102_dev;
-
-	as102_dev = container_of(kref, struct as102_dev_t, kref);
-	if (as102_dev != NULL) {
-		usb_put_dev(as102_dev->bus_adap.usb_dev);
-		kfree(as102_dev);
-	}
-}
-
-static void as102_usb_disconnect(struct usb_interface *intf)
-{
-	struct as102_dev_t *as102_dev;
-
-	/* extract as102_dev_t from usb_device private data */
-	as102_dev = usb_get_intfdata(intf);
-
-	/* unregister dvb layer */
-	as102_dvb_unregister(as102_dev);
-
-	/* free usb buffers */
-	as102_free_usb_stream_buffer(as102_dev);
-
-	usb_set_intfdata(intf, NULL);
-
-	/* usb unregister device */
-	usb_deregister_dev(intf, &as102_usb_class_driver);
-
-	/* decrement usage counter */
-	kref_put(&as102_dev->kref, as102_usb_release);
-
-	pr_info("%s: device has been disconnected\n", DRIVER_NAME);
-}
-
-static int as102_usb_probe(struct usb_interface *intf,
-			   const struct usb_device_id *id)
-{
-	int ret;
-	struct as102_dev_t *as102_dev;
-	int i;
-
-	/* This should never actually happen */
-	if (ARRAY_SIZE(as102_usb_id_table) !=
-	    (sizeof(as102_device_names) / sizeof(const char *))) {
-		pr_err("Device names table invalid size");
-		return -EINVAL;
-	}
-
-	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
-	if (as102_dev == NULL)
-		return -ENOMEM;
-
-	/* Assign the user-friendly device name */
-	for (i = 0; i < ARRAY_SIZE(as102_usb_id_table); i++) {
-		if (id == &as102_usb_id_table[i]) {
-			as102_dev->name = as102_device_names[i];
-			as102_dev->elna_cfg = as102_elna_cfg[i];
-		}
-	}
-
-	if (as102_dev->name == NULL)
-		as102_dev->name = "Unknown AS102 device";
-
-	/* set private callback functions */
-	as102_dev->bus_adap.ops = &as102_priv_ops;
-
-	/* init cmd token for usb bus */
-	as102_dev->bus_adap.cmd = &as102_dev->bus_adap.token.usb.c;
-	as102_dev->bus_adap.rsp = &as102_dev->bus_adap.token.usb.r;
-
-	/* init kernel device reference */
-	kref_init(&as102_dev->kref);
-
-	/* store as102 device to usb_device private data */
-	usb_set_intfdata(intf, (void *) as102_dev);
-
-	/* store in as102 device the usb_device pointer */
-	as102_dev->bus_adap.usb_dev = usb_get_dev(interface_to_usbdev(intf));
-
-	/* we can register the device now, as it is ready */
-	ret = usb_register_dev(intf, &as102_usb_class_driver);
-	if (ret < 0) {
-		/* something prevented us from registering this driver */
-		dev_err(&intf->dev,
-			"%s: usb_register_dev() failed (errno = %d)\n",
-			__func__, ret);
-		goto failed;
-	}
-
-	pr_info("%s: device has been detected\n", DRIVER_NAME);
-
-	/* request buffer allocation for streaming */
-	ret = as102_alloc_usb_stream_buffer(as102_dev);
-	if (ret != 0)
-		goto failed_stream;
-
-	/* register dvb layer */
-	ret = as102_dvb_register(as102_dev);
-	if (ret != 0)
-		goto failed_dvb;
-
-	return ret;
-
-failed_dvb:
-	as102_free_usb_stream_buffer(as102_dev);
-failed_stream:
-	usb_deregister_dev(intf, &as102_usb_class_driver);
-failed:
-	usb_put_dev(as102_dev->bus_adap.usb_dev);
-	usb_set_intfdata(intf, NULL);
-	kfree(as102_dev);
-	return ret;
-}
-
-static int as102_open(struct inode *inode, struct file *file)
-{
-	int ret = 0, minor = 0;
-	struct usb_interface *intf = NULL;
-	struct as102_dev_t *dev = NULL;
-
-	/* read minor from inode */
-	minor = iminor(inode);
-
-	/* fetch device from usb interface */
-	intf = usb_find_interface(&as102_usb_driver, minor);
-	if (intf == NULL) {
-		pr_err("%s: can't find device for minor %d\n",
-		       __func__, minor);
-		ret = -ENODEV;
-		goto exit;
-	}
-
-	/* get our device */
-	dev = usb_get_intfdata(intf);
-	if (dev == NULL) {
-		ret = -EFAULT;
-		goto exit;
-	}
-
-	/* save our device object in the file's private structure */
-	file->private_data = dev;
-
-	/* increment our usage count for the device */
-	kref_get(&dev->kref);
-
-exit:
-	return ret;
-}
-
-static int as102_release(struct inode *inode, struct file *file)
-{
-	struct as102_dev_t *dev = NULL;
-
-	dev = file->private_data;
-	if (dev != NULL) {
-		/* decrement the count on our device */
-		kref_put(&dev->kref, as102_usb_release);
-	}
-
-	return 0;
-}
-
-MODULE_DEVICE_TABLE(usb, as102_usb_id_table);
diff --git a/drivers/staging/media/as102/as102_usb_drv.h b/drivers/staging/media/as102/as102_usb_drv.h
deleted file mode 100644
index 1ad1ec52b11e..000000000000
--- a/drivers/staging/media/as102/as102_usb_drv.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#ifndef _AS102_USB_DRV_H_
-#define _AS102_USB_DRV_H_
-
-#define AS102_USB_DEVICE_TX_CTRL_CMD	0xF1
-#define AS102_USB_DEVICE_RX_CTRL_CMD	0xF2
-
-/* define these values to match the supported devices */
-
-/* Abilis system: "TITAN" */
-#define AS102_REFERENCE_DESIGN		"Abilis Systems DVB-Titan"
-#define AS102_USB_DEVICE_VENDOR_ID	0x1BA6
-#define AS102_USB_DEVICE_PID_0001	0x0001
-
-/* PCTV Systems: PCTV picoStick (74e) */
-#define AS102_PCTV_74E			"PCTV Systems picoStick (74e)"
-#define PCTV_74E_USB_VID		0x2013
-#define PCTV_74E_USB_PID		0x0246
-
-/* Elgato: EyeTV DTT Deluxe */
-#define AS102_ELGATO_EYETV_DTT_NAME	"Elgato EyeTV DTT Deluxe"
-#define ELGATO_EYETV_DTT_USB_VID	0x0fd9
-#define ELGATO_EYETV_DTT_USB_PID	0x002c
-
-/* nBox: nBox DVB-T Dongle */
-#define AS102_NBOX_DVBT_DONGLE_NAME	"nBox DVB-T Dongle"
-#define NBOX_DVBT_DONGLE_USB_VID	0x0b89
-#define NBOX_DVBT_DONGLE_USB_PID	0x0007
-
-/* Sky Italia: Digital Key (green led) */
-#define AS102_SKY_IT_DIGITAL_KEY_NAME	"Sky IT Digital Key (green led)"
-#define SKY_IT_DIGITAL_KEY_USB_VID	0x2137
-#define SKY_IT_DIGITAL_KEY_USB_PID	0x0001
-
-void as102_urb_stream_irq(struct urb *urb);
-
-struct as10x_usb_token_cmd_t {
-	/* token cmd */
-	struct as10x_cmd_t c;
-	/* token response */
-	struct as10x_cmd_t r;
-};
-#endif
diff --git a/drivers/staging/media/as102/as10x_cmd.c b/drivers/staging/media/as102/as10x_cmd.c
deleted file mode 100644
index 9e49f15a7c9f..000000000000
--- a/drivers/staging/media/as102/as10x_cmd.c
+++ /dev/null
@@ -1,418 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/kernel.h>
-#include "as102_drv.h"
-#include "as10x_types.h"
-#include "as10x_cmd.h"
-
-/**
- * as10x_cmd_turn_on - send turn on command to AS10x
- * @adap:   pointer to AS10x bus adapter
- *
- * Return 0 when no error, < 0 in case of error.
- */
-int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.turn_on.req));
-
-	/* fill command */
-	pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-					    sizeof(pcmd->body.turn_on.req) +
-					    HEADER_SIZE,
-					    (uint8_t *) prsp,
-					    sizeof(prsp->body.turn_on.rsp) +
-					    HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_turn_off - send turn off command to AS10x
- * @adap:   pointer to AS10x bus adapter
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.turn_off.req));
-
-	/* fill command */
-	pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(
-			adap, (uint8_t *) pcmd,
-			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
-			(uint8_t *) prsp,
-			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_set_tune - send set tune command to AS10x
- * @adap:    pointer to AS10x bus adapter
- * @ptune:   tune parameters
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
-		       struct as10x_tune_args *ptune)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t *preq, *prsp;
-
-	preq = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(preq, (++adap->cmd_xid),
-			sizeof(preq->body.set_tune.req));
-
-	/* fill command */
-	preq->body.set_tune.req.proc_id = cpu_to_le16(CONTROL_PROC_SETTUNE);
-	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
-	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
-	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
-	preq->body.set_tune.req.args.modulation = ptune->modulation;
-	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
-	preq->body.set_tune.req.args.interleaving_mode  =
-		ptune->interleaving_mode;
-	preq->body.set_tune.req.args.code_rate  = ptune->code_rate;
-	preq->body.set_tune.req.args.guard_interval = ptune->guard_interval;
-	preq->body.set_tune.req.args.transmission_mode  =
-		ptune->transmission_mode;
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap,
-					    (uint8_t *) preq,
-					    sizeof(preq->body.set_tune.req)
-					    + HEADER_SIZE,
-					    (uint8_t *) prsp,
-					    sizeof(prsp->body.set_tune.rsp)
-					    + HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_get_tune_status - send get tune status command to AS10x
- * @adap: pointer to AS10x bus adapter
- * @pstatus: pointer to updated status structure of the current tune
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
-			      struct as10x_tune_status *pstatus)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t  *preq, *prsp;
-
-	preq = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(preq, (++adap->cmd_xid),
-			sizeof(preq->body.get_tune_status.req));
-
-	/* fill command */
-	preq->body.get_tune_status.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(
-			adap,
-			(uint8_t *) preq,
-			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
-			(uint8_t *) prsp,
-			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTUNESTAT_RSP);
-	if (error < 0)
-		goto out;
-
-	/* Response OK -> get response data */
-	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
-	pstatus->signal_strength  =
-		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
-	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
-	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_get_tps - send get TPS command to AS10x
- * @adap:      pointer to AS10x handle
- * @ptps:      pointer to TPS parameters structure
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap, struct as10x_tps *ptps)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.get_tps.req));
-
-	/* fill command */
-	pcmd->body.get_tune_status.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GETTPS);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap,
-					    (uint8_t *) pcmd,
-					    sizeof(pcmd->body.get_tps.req) +
-					    HEADER_SIZE,
-					    (uint8_t *) prsp,
-					    sizeof(prsp->body.get_tps.rsp) +
-					    HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTPS_RSP);
-	if (error < 0)
-		goto out;
-
-	/* Response OK -> get response data */
-	ptps->modulation = prsp->body.get_tps.rsp.tps.modulation;
-	ptps->hierarchy = prsp->body.get_tps.rsp.tps.hierarchy;
-	ptps->interleaving_mode = prsp->body.get_tps.rsp.tps.interleaving_mode;
-	ptps->code_rate_HP = prsp->body.get_tps.rsp.tps.code_rate_HP;
-	ptps->code_rate_LP = prsp->body.get_tps.rsp.tps.code_rate_LP;
-	ptps->guard_interval = prsp->body.get_tps.rsp.tps.guard_interval;
-	ptps->transmission_mode  = prsp->body.get_tps.rsp.tps.transmission_mode;
-	ptps->DVBH_mask_HP = prsp->body.get_tps.rsp.tps.DVBH_mask_HP;
-	ptps->DVBH_mask_LP = prsp->body.get_tps.rsp.tps.DVBH_mask_LP;
-	ptps->cell_ID = le16_to_cpu(prsp->body.get_tps.rsp.tps.cell_ID);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_get_demod_stats - send get demod stats command to AS10x
- * @adap:          pointer to AS10x bus adapter
- * @pdemod_stats:  pointer to demod stats parameters structure
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t *adap,
-			      struct as10x_demod_stats *pdemod_stats)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.get_demod_stats.req));
-
-	/* fill command */
-	pcmd->body.get_demod_stats.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap,
-				(uint8_t *) pcmd,
-				sizeof(pcmd->body.get_demod_stats.req)
-				+ HEADER_SIZE,
-				(uint8_t *) prsp,
-				sizeof(prsp->body.get_demod_stats.rsp)
-				+ HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_DEMOD_STATS_RSP);
-	if (error < 0)
-		goto out;
-
-	/* Response OK -> get response data */
-	pdemod_stats->frame_count =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.frame_count);
-	pdemod_stats->bad_frame_count =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bad_frame_count);
-	pdemod_stats->bytes_fixed_by_rs =
-		le32_to_cpu(prsp->body.get_demod_stats.rsp.stats.bytes_fixed_by_rs);
-	pdemod_stats->mer =
-		le16_to_cpu(prsp->body.get_demod_stats.rsp.stats.mer);
-	pdemod_stats->has_started =
-		prsp->body.get_demod_stats.rsp.stats.has_started;
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_get_impulse_resp - send get impulse response command to AS10x
- * @adap:     pointer to AS10x bus adapter
- * @is_ready: pointer to value indicating when impulse
- *	      response data is ready
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
-			       uint8_t *is_ready)
-{
-	int error = AS10X_CMD_ERROR;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.get_impulse_rsp.req));
-
-	/* fill command */
-	pcmd->body.get_impulse_rsp.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap,
-					(uint8_t *) pcmd,
-					sizeof(pcmd->body.get_impulse_rsp.req)
-					+ HEADER_SIZE,
-					(uint8_t *) prsp,
-					sizeof(prsp->body.get_impulse_rsp.rsp)
-					+ HEADER_SIZE);
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_IMPULSE_RESP_RSP);
-	if (error < 0)
-		goto out;
-
-	/* Response OK -> get response data */
-	*is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_build - build AS10x command header
- * @pcmd:     pointer to AS10x command buffer
- * @xid:      sequence id of the command
- * @cmd_len:  length of the command
- */
-void as10x_cmd_build(struct as10x_cmd_t *pcmd,
-		     uint16_t xid, uint16_t cmd_len)
-{
-	pcmd->header.req_id = cpu_to_le16(xid);
-	pcmd->header.prog = cpu_to_le16(SERVICE_PROG_ID);
-	pcmd->header.version = cpu_to_le16(SERVICE_PROG_VERSION);
-	pcmd->header.data_len = cpu_to_le16(cmd_len);
-}
-
-/**
- * as10x_rsp_parse - Parse command response
- * @prsp:       pointer to AS10x command buffer
- * @proc_id:    id of the command
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
-{
-	int error;
-
-	/* extract command error code */
-	error = prsp->body.common.rsp.error;
-
-	if ((error == 0) &&
-	    (le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
-		return 0;
-	}
-
-	return AS10X_CMD_ERROR;
-}
diff --git a/drivers/staging/media/as102/as10x_cmd.h b/drivers/staging/media/as102/as10x_cmd.h
deleted file mode 100644
index e21ec6c702a9..000000000000
--- a/drivers/staging/media/as102/as10x_cmd.h
+++ /dev/null
@@ -1,529 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#ifndef _AS10X_CMD_H_
-#define _AS10X_CMD_H_
-
-#ifdef __KERNEL__
-#include <linux/kernel.h>
-#endif
-
-#include "as10x_types.h"
-
-/*********************************/
-/*       MACRO DEFINITIONS       */
-/*********************************/
-#define AS10X_CMD_ERROR		-1
-
-#define SERVICE_PROG_ID		0x0002
-#define SERVICE_PROG_VERSION	0x0001
-
-#define HIER_NONE		0x00
-#define HIER_LOW_PRIORITY	0x01
-
-#define HEADER_SIZE (sizeof(struct as10x_cmd_header_t))
-
-/* context request types */
-#define GET_CONTEXT_DATA	1
-#define SET_CONTEXT_DATA	2
-
-/* ODSP suspend modes */
-#define CFG_MODE_ODSP_RESUME	0
-#define CFG_MODE_ODSP_SUSPEND	1
-
-/* Dump memory size */
-#define DUMP_BLOCK_SIZE_MAX	0x20
-
-/*********************************/
-/*     TYPE DEFINITION           */
-/*********************************/
-enum control_proc {
-	CONTROL_PROC_TURNON			= 0x0001,
-	CONTROL_PROC_TURNON_RSP			= 0x0100,
-	CONTROL_PROC_SET_REGISTER		= 0x0002,
-	CONTROL_PROC_SET_REGISTER_RSP		= 0x0200,
-	CONTROL_PROC_GET_REGISTER		= 0x0003,
-	CONTROL_PROC_GET_REGISTER_RSP		= 0x0300,
-	CONTROL_PROC_SETTUNE			= 0x000A,
-	CONTROL_PROC_SETTUNE_RSP		= 0x0A00,
-	CONTROL_PROC_GETTUNESTAT		= 0x000B,
-	CONTROL_PROC_GETTUNESTAT_RSP		= 0x0B00,
-	CONTROL_PROC_GETTPS			= 0x000D,
-	CONTROL_PROC_GETTPS_RSP			= 0x0D00,
-	CONTROL_PROC_SETFILTER			= 0x000E,
-	CONTROL_PROC_SETFILTER_RSP		= 0x0E00,
-	CONTROL_PROC_REMOVEFILTER		= 0x000F,
-	CONTROL_PROC_REMOVEFILTER_RSP		= 0x0F00,
-	CONTROL_PROC_GET_IMPULSE_RESP		= 0x0012,
-	CONTROL_PROC_GET_IMPULSE_RESP_RSP	= 0x1200,
-	CONTROL_PROC_START_STREAMING		= 0x0013,
-	CONTROL_PROC_START_STREAMING_RSP	= 0x1300,
-	CONTROL_PROC_STOP_STREAMING		= 0x0014,
-	CONTROL_PROC_STOP_STREAMING_RSP		= 0x1400,
-	CONTROL_PROC_GET_DEMOD_STATS		= 0x0015,
-	CONTROL_PROC_GET_DEMOD_STATS_RSP	= 0x1500,
-	CONTROL_PROC_ELNA_CHANGE_MODE		= 0x0016,
-	CONTROL_PROC_ELNA_CHANGE_MODE_RSP	= 0x1600,
-	CONTROL_PROC_ODSP_CHANGE_MODE		= 0x0017,
-	CONTROL_PROC_ODSP_CHANGE_MODE_RSP	= 0x1700,
-	CONTROL_PROC_AGC_CHANGE_MODE		= 0x0018,
-	CONTROL_PROC_AGC_CHANGE_MODE_RSP	= 0x1800,
-
-	CONTROL_PROC_CONTEXT			= 0x00FC,
-	CONTROL_PROC_CONTEXT_RSP		= 0xFC00,
-	CONTROL_PROC_DUMP_MEMORY		= 0x00FD,
-	CONTROL_PROC_DUMP_MEMORY_RSP		= 0xFD00,
-	CONTROL_PROC_DUMPLOG_MEMORY		= 0x00FE,
-	CONTROL_PROC_DUMPLOG_MEMORY_RSP		= 0xFE00,
-	CONTROL_PROC_TURNOFF			= 0x00FF,
-	CONTROL_PROC_TURNOFF_RSP		= 0xFF00
-};
-
-union as10x_turn_on {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_turn_off {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t err;
-	} __packed rsp;
-} __packed;
-
-union as10x_set_tune {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-		/* tune params */
-		struct as10x_tune_args args;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* response error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_get_tune_status {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* response error */
-		uint8_t error;
-		/* tune status */
-		struct as10x_tune_status sts;
-	} __packed rsp;
-} __packed;
-
-union as10x_get_tps {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* response error */
-		uint8_t error;
-		/* tps details */
-		struct as10x_tps tps;
-	} __packed rsp;
-} __packed;
-
-union as10x_common {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t  proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* response error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_add_pid_filter {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t  proc_id;
-		/* PID to filter */
-		uint16_t  pid;
-		/* stream type (MPE, PSI/SI or PES )*/
-		uint8_t stream_type;
-		/* PID index in filter table */
-		uint8_t idx;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* response error */
-		uint8_t error;
-		/* Filter id */
-		uint8_t filter_id;
-	} __packed rsp;
-} __packed;
-
-union as10x_del_pid_filter {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t  proc_id;
-		/* PID to remove */
-		uint16_t  pid;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* response error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_start_streaming {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_stop_streaming {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_get_demod_stats {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-		/* demod stats */
-		struct as10x_demod_stats stats;
-	} __packed rsp;
-} __packed;
-
-union as10x_get_impulse_resp {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-		/* impulse response ready */
-		uint8_t is_ready;
-	} __packed rsp;
-} __packed;
-
-union as10x_fw_context {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-		/* value to write (for set context)*/
-		struct as10x_register_value reg_val;
-		/* context tag */
-		uint16_t tag;
-		/* context request type */
-		uint16_t type;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* value read (for get context) */
-		struct as10x_register_value reg_val;
-		/* context request type */
-		uint16_t type;
-		/* error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_set_register {
-	/* request */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* register description */
-		struct as10x_register_addr reg_addr;
-		/* register content */
-		struct as10x_register_value reg_val;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-union as10x_get_register {
-	/* request */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* register description */
-		struct as10x_register_addr reg_addr;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-		/* register content */
-		struct as10x_register_value reg_val;
-	} __packed rsp;
-} __packed;
-
-union as10x_cfg_change_mode {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-		/* mode */
-		uint8_t mode;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-	} __packed rsp;
-} __packed;
-
-struct as10x_cmd_header_t {
-	uint16_t req_id;
-	uint16_t prog;
-	uint16_t version;
-	uint16_t data_len;
-} __packed;
-
-#define DUMP_BLOCK_SIZE 16
-
-union as10x_dump_memory {
-	/* request */
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-		/* dump memory type request */
-		uint8_t dump_req;
-		/* register description */
-		struct as10x_register_addr reg_addr;
-		/* nb blocks to read */
-		uint16_t num_blocks;
-	} __packed req;
-	/* response */
-	struct {
-		/* response identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-		/* dump response */
-		uint8_t dump_rsp;
-		/* data */
-		union {
-			uint8_t  data8[DUMP_BLOCK_SIZE];
-			uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
-			uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
-		} __packed u;
-	} __packed rsp;
-} __packed;
-
-union as10x_dumplog_memory {
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-		/* dump memory type request */
-		uint8_t dump_req;
-	} __packed req;
-	struct {
-		/* request identifier */
-		uint16_t proc_id;
-		/* error */
-		uint8_t error;
-		/* dump response */
-		uint8_t dump_rsp;
-		/* dump data */
-		uint8_t data[DUMP_BLOCK_SIZE];
-	} __packed rsp;
-} __packed;
-
-union as10x_raw_data {
-	/* request */
-	struct {
-		uint16_t proc_id;
-		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
-			     - 2 /* proc_id */];
-	} __packed req;
-	/* response */
-	struct {
-		uint16_t proc_id;
-		uint8_t error;
-		uint8_t data[64 - sizeof(struct as10x_cmd_header_t)
-			     - 2 /* proc_id */ - 1 /* rc */];
-	} __packed rsp;
-} __packed;
-
-struct as10x_cmd_t {
-	struct as10x_cmd_header_t header;
-	union {
-		union as10x_turn_on		turn_on;
-		union as10x_turn_off		turn_off;
-		union as10x_set_tune		set_tune;
-		union as10x_get_tune_status	get_tune_status;
-		union as10x_get_tps		get_tps;
-		union as10x_common		common;
-		union as10x_add_pid_filter	add_pid_filter;
-		union as10x_del_pid_filter	del_pid_filter;
-		union as10x_start_streaming	start_streaming;
-		union as10x_stop_streaming	stop_streaming;
-		union as10x_get_demod_stats	get_demod_stats;
-		union as10x_get_impulse_resp	get_impulse_rsp;
-		union as10x_fw_context		context;
-		union as10x_set_register	set_register;
-		union as10x_get_register	get_register;
-		union as10x_cfg_change_mode	cfg_change_mode;
-		union as10x_dump_memory		dump_memory;
-		union as10x_dumplog_memory	dumplog_memory;
-		union as10x_raw_data		raw_data;
-	} __packed body;
-} __packed;
-
-struct as10x_token_cmd_t {
-	/* token cmd */
-	struct as10x_cmd_t c;
-	/* token response */
-	struct as10x_cmd_t r;
-} __packed;
-
-
-/**************************/
-/* FUNCTION DECLARATION   */
-/**************************/
-
-void as10x_cmd_build(struct as10x_cmd_t *pcmd, uint16_t proc_id,
-		      uint16_t cmd_len);
-int as10x_rsp_parse(struct as10x_cmd_t *r, uint16_t proc_id);
-
-/* as10x cmd */
-int as10x_cmd_turn_on(struct as10x_bus_adapter_t *adap);
-int as10x_cmd_turn_off(struct as10x_bus_adapter_t *adap);
-
-int as10x_cmd_set_tune(struct as10x_bus_adapter_t *adap,
-		       struct as10x_tune_args *ptune);
-
-int as10x_cmd_get_tune_status(struct as10x_bus_adapter_t *adap,
-			      struct as10x_tune_status *pstatus);
-
-int as10x_cmd_get_tps(struct as10x_bus_adapter_t *adap,
-		      struct as10x_tps *ptps);
-
-int as10x_cmd_get_demod_stats(struct as10x_bus_adapter_t  *adap,
-			      struct as10x_demod_stats *pdemod_stats);
-
-int as10x_cmd_get_impulse_resp(struct as10x_bus_adapter_t *adap,
-			       uint8_t *is_ready);
-
-/* as10x cmd stream */
-int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
-			     struct as10x_ts_filter *filter);
-int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
-			     uint16_t pid_value);
-
-int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap);
-int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap);
-
-/* as10x cmd cfg */
-int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap,
-			  uint16_t tag,
-			  uint32_t value);
-int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap,
-			  uint16_t tag,
-			  uint32_t *pvalue);
-
-int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode);
-int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
-#endif
diff --git a/drivers/staging/media/as102/as10x_cmd_cfg.c b/drivers/staging/media/as102/as10x_cmd_cfg.c
deleted file mode 100644
index b1e300d88753..000000000000
--- a/drivers/staging/media/as102/as10x_cmd_cfg.c
+++ /dev/null
@@ -1,206 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/kernel.h>
-#include "as102_drv.h"
-#include "as10x_types.h"
-#include "as10x_cmd.h"
-
-/***************************/
-/* FUNCTION DEFINITION     */
-/***************************/
-
-/**
- * as10x_cmd_get_context - Send get context command to AS10x
- * @adap:      pointer to AS10x bus adapter
- * @tag:       context tag
- * @pvalue:    pointer where to store context value read
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_get_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
-			  uint32_t *pvalue)
-{
-	int  error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.context.req));
-
-	/* fill command */
-	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
-	pcmd->body.context.req.tag = cpu_to_le16(tag);
-	pcmd->body.context.req.type = cpu_to_le16(GET_CONTEXT_DATA);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error  = adap->ops->xfer_cmd(adap,
-					     (uint8_t *) pcmd,
-					     sizeof(pcmd->body.context.req)
-					     + HEADER_SIZE,
-					     (uint8_t *) prsp,
-					     sizeof(prsp->body.context.rsp)
-					     + HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response: context command do not follow the common response */
-	/* structure -> specific handling response parse required            */
-	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
-
-	if (error == 0) {
-		/* Response OK -> get response data */
-		*pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
-		/* value returned is always a 32-bit value */
-	}
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_set_context - send set context command to AS10x
- * @adap:      pointer to AS10x bus adapter
- * @tag:       context tag
- * @value:     value to set in context
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
-			  uint32_t value)
-{
-	int error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.context.req));
-
-	/* fill command */
-	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
-	/* pcmd->body.context.req.reg_val.mode initialization is not required */
-	pcmd->body.context.req.reg_val.u.value32 = cpu_to_le32(value);
-	pcmd->body.context.req.tag = cpu_to_le16(tag);
-	pcmd->body.context.req.type = cpu_to_le16(SET_CONTEXT_DATA);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error  = adap->ops->xfer_cmd(adap,
-					     (uint8_t *) pcmd,
-					     sizeof(pcmd->body.context.req)
-					     + HEADER_SIZE,
-					     (uint8_t *) prsp,
-					     sizeof(prsp->body.context.rsp)
-					     + HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response: context command do not follow the common response */
-	/* structure -> specific handling response parse required            */
-	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_eLNA_change_mode - send eLNA change mode command to AS10x
- * @adap:      pointer to AS10x bus adapter
- * @mode:      mode selected:
- *	        - ON    : 0x0 => eLNA always ON
- *	        - OFF   : 0x1 => eLNA always OFF
- *	        - AUTO  : 0x2 => eLNA follow hysteresis parameters
- *				 to be ON or OFF
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_eLNA_change_mode(struct as10x_bus_adapter_t *adap, uint8_t mode)
-{
-	int error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.cfg_change_mode.req));
-
-	/* fill command */
-	pcmd->body.cfg_change_mode.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
-	pcmd->body.cfg_change_mode.req.mode = mode;
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error  = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-				sizeof(pcmd->body.cfg_change_mode.req)
-				+ HEADER_SIZE, (uint8_t *) prsp,
-				sizeof(prsp->body.cfg_change_mode.rsp)
-				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_context_rsp_parse - Parse context command response
- * @prsp:       pointer to AS10x command response buffer
- * @proc_id:    id of the command
- *
- * Since the contex command response does not follow the common
- * response, a specific parse function is required.
- * Return 0 on success or negative value in case of error.
- */
-int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
-{
-	int err;
-
-	err = prsp->body.context.rsp.error;
-
-	if ((err == 0) &&
-	    (le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
-		return 0;
-	}
-	return AS10X_CMD_ERROR;
-}
diff --git a/drivers/staging/media/as102/as10x_cmd_stream.c b/drivers/staging/media/as102/as10x_cmd_stream.c
deleted file mode 100644
index 1088ca1fe92f..000000000000
--- a/drivers/staging/media/as102/as10x_cmd_stream.c
+++ /dev/null
@@ -1,211 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/kernel.h>
-#include "as102_drv.h"
-#include "as10x_cmd.h"
-
-/**
- * as10x_cmd_add_PID_filter - send add filter command to AS10x
- * @adap:      pointer to AS10x bus adapter
- * @filter:    TSFilter filter for DVB-T
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_add_PID_filter(struct as10x_bus_adapter_t *adap,
-			     struct as10x_ts_filter *filter)
-{
-	int error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.add_pid_filter.req));
-
-	/* fill command */
-	pcmd->body.add_pid_filter.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_SETFILTER);
-	pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
-	pcmd->body.add_pid_filter.req.stream_type = filter->type;
-
-	if (filter->idx < 16)
-		pcmd->body.add_pid_filter.req.idx = filter->idx;
-	else
-		pcmd->body.add_pid_filter.req.idx = 0xFF;
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-				sizeof(pcmd->body.add_pid_filter.req)
-				+ HEADER_SIZE, (uint8_t *) prsp,
-				sizeof(prsp->body.add_pid_filter.rsp)
-				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
-
-	if (error == 0) {
-		/* Response OK -> get response data */
-		filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
-	}
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_del_PID_filter - Send delete filter command to AS10x
- * @adap:         pointer to AS10x bus adapte
- * @pid_value:    PID to delete
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_del_PID_filter(struct as10x_bus_adapter_t *adap,
-			     uint16_t pid_value)
-{
-	int error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.del_pid_filter.req));
-
-	/* fill command */
-	pcmd->body.del_pid_filter.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
-	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-				sizeof(pcmd->body.del_pid_filter.req)
-				+ HEADER_SIZE, (uint8_t *) prsp,
-				sizeof(prsp->body.del_pid_filter.rsp)
-				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_start_streaming - Send start streaming command to AS10x
- * @adap:   pointer to AS10x bus adapter
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_start_streaming(struct as10x_bus_adapter_t *adap)
-{
-	int error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.start_streaming.req));
-
-	/* fill command */
-	pcmd->body.start_streaming.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_START_STREAMING);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-				sizeof(pcmd->body.start_streaming.req)
-				+ HEADER_SIZE, (uint8_t *) prsp,
-				sizeof(prsp->body.start_streaming.rsp)
-				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);
-
-out:
-	return error;
-}
-
-/**
- * as10x_cmd_stop_streaming - Send stop streaming command to AS10x
- * @adap:   pointer to AS10x bus adapter
- *
- * Return 0 on success or negative value in case of error.
- */
-int as10x_cmd_stop_streaming(struct as10x_bus_adapter_t *adap)
-{
-	int8_t error;
-	struct as10x_cmd_t *pcmd, *prsp;
-
-	pcmd = adap->cmd;
-	prsp = adap->rsp;
-
-	/* prepare command */
-	as10x_cmd_build(pcmd, (++adap->cmd_xid),
-			sizeof(pcmd->body.stop_streaming.req));
-
-	/* fill command */
-	pcmd->body.stop_streaming.req.proc_id =
-		cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
-
-	/* send command */
-	if (adap->ops->xfer_cmd) {
-		error = adap->ops->xfer_cmd(adap, (uint8_t *) pcmd,
-				sizeof(pcmd->body.stop_streaming.req)
-				+ HEADER_SIZE, (uint8_t *) prsp,
-				sizeof(prsp->body.stop_streaming.rsp)
-				+ HEADER_SIZE);
-	} else {
-		error = AS10X_CMD_ERROR;
-	}
-
-	if (error < 0)
-		goto out;
-
-	/* parse response */
-	error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);
-
-out:
-	return error;
-}
diff --git a/drivers/staging/media/as102/as10x_handle.h b/drivers/staging/media/as102/as10x_handle.h
deleted file mode 100644
index 5638b191b780..000000000000
--- a/drivers/staging/media/as102/as10x_handle.h
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#ifdef __KERNEL__
-struct as10x_bus_adapter_t;
-struct as102_dev_t;
-
-#include "as10x_cmd.h"
-
-/* values for "mode" field */
-#define REGMODE8	8
-#define REGMODE16	16
-#define REGMODE32	32
-
-struct as102_priv_ops_t {
-	int (*upload_fw_pkt)(struct as10x_bus_adapter_t *bus_adap,
-			      unsigned char *buf, int buflen, int swap32);
-
-	int (*send_cmd)(struct as10x_bus_adapter_t *bus_adap,
-			 unsigned char *buf, int buflen);
-
-	int (*xfer_cmd)(struct as10x_bus_adapter_t *bus_adap,
-			 unsigned char *send_buf, int send_buf_len,
-			 unsigned char *recv_buf, int recv_buf_len);
-
-	int (*start_stream)(struct as102_dev_t *dev);
-	void (*stop_stream)(struct as102_dev_t *dev);
-
-	int (*reset_target)(struct as10x_bus_adapter_t *bus_adap);
-
-	int (*read_write)(struct as10x_bus_adapter_t *bus_adap, uint8_t mode,
-			  uint32_t rd_addr, uint16_t rd_len,
-			  uint32_t wr_addr, uint16_t wr_len);
-
-	int (*as102_read_ep2)(struct as10x_bus_adapter_t *bus_adap,
-			       unsigned char *recv_buf,
-			       int recv_buf_len);
-};
-#endif
diff --git a/drivers/staging/media/as102/as10x_types.h b/drivers/staging/media/as102/as10x_types.h
deleted file mode 100644
index af26e057d9a2..000000000000
--- a/drivers/staging/media/as102/as10x_types.h
+++ /dev/null
@@ -1,194 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-#ifndef _AS10X_TYPES_H_
-#define _AS10X_TYPES_H_
-
-#include "as10x_handle.h"
-
-/*********************************/
-/*       MACRO DEFINITIONS       */
-/*********************************/
-
-/* bandwidth constant values */
-#define BW_5_MHZ		0x00
-#define BW_6_MHZ		0x01
-#define BW_7_MHZ		0x02
-#define BW_8_MHZ		0x03
-
-/* hierarchy priority selection values */
-#define HIER_NO_PRIORITY	0x00
-#define HIER_LOW_PRIORITY	0x01
-#define HIER_HIGH_PRIORITY	0x02
-
-/* constellation available values */
-#define CONST_QPSK		0x00
-#define CONST_QAM16		0x01
-#define CONST_QAM64		0x02
-#define CONST_UNKNOWN		0xFF
-
-/* hierarchy available values */
-#define HIER_NONE		0x00
-#define HIER_ALPHA_1		0x01
-#define HIER_ALPHA_2		0x02
-#define HIER_ALPHA_4		0x03
-#define HIER_UNKNOWN		0xFF
-
-/* interleaving available values */
-#define INTLV_NATIVE		0x00
-#define INTLV_IN_DEPTH		0x01
-#define INTLV_UNKNOWN		0xFF
-
-/* code rate available values */
-#define CODE_RATE_1_2		0x00
-#define CODE_RATE_2_3		0x01
-#define CODE_RATE_3_4		0x02
-#define CODE_RATE_5_6		0x03
-#define CODE_RATE_7_8		0x04
-#define CODE_RATE_UNKNOWN	0xFF
-
-/* guard interval available values */
-#define GUARD_INT_1_32		0x00
-#define GUARD_INT_1_16		0x01
-#define GUARD_INT_1_8		0x02
-#define GUARD_INT_1_4		0x03
-#define GUARD_UNKNOWN		0xFF
-
-/* transmission mode available values */
-#define TRANS_MODE_2K		0x00
-#define TRANS_MODE_8K		0x01
-#define TRANS_MODE_4K		0x02
-#define TRANS_MODE_UNKNOWN	0xFF
-
-/* DVBH signalling available values */
-#define TIMESLICING_PRESENT	0x01
-#define MPE_FEC_PRESENT		0x02
-
-/* tune state available */
-#define TUNE_STATUS_NOT_TUNED		0x00
-#define TUNE_STATUS_IDLE		0x01
-#define TUNE_STATUS_LOCKING		0x02
-#define TUNE_STATUS_SIGNAL_DVB_OK	0x03
-#define TUNE_STATUS_STREAM_DETECTED	0x04
-#define TUNE_STATUS_STREAM_TUNED	0x05
-#define TUNE_STATUS_ERROR		0xFF
-
-/* available TS FID filter types */
-#define TS_PID_TYPE_TS		0
-#define TS_PID_TYPE_PSI_SI	1
-#define TS_PID_TYPE_MPE		2
-
-/* number of echos available */
-#define MAX_ECHOS	15
-
-/* Context types */
-#define CONTEXT_LNA			1010
-#define CONTEXT_ELNA_HYSTERESIS		4003
-#define CONTEXT_ELNA_GAIN		4004
-#define CONTEXT_MER_THRESHOLD		5005
-#define CONTEXT_MER_OFFSET		5006
-#define CONTEXT_IR_STATE		7000
-#define CONTEXT_TSOUT_MSB_FIRST		7004
-#define CONTEXT_TSOUT_FALLING_EDGE	7005
-
-/* Configuration modes */
-#define CFG_MODE_ON	0
-#define CFG_MODE_OFF	1
-#define CFG_MODE_AUTO	2
-
-struct as10x_tps {
-	uint8_t modulation;
-	uint8_t hierarchy;
-	uint8_t interleaving_mode;
-	uint8_t code_rate_HP;
-	uint8_t code_rate_LP;
-	uint8_t guard_interval;
-	uint8_t transmission_mode;
-	uint8_t DVBH_mask_HP;
-	uint8_t DVBH_mask_LP;
-	uint16_t cell_ID;
-} __packed;
-
-struct as10x_tune_args {
-	/* frequency */
-	uint32_t freq;
-	/* bandwidth */
-	uint8_t bandwidth;
-	/* hierarchy selection */
-	uint8_t hier_select;
-	/* constellation */
-	uint8_t modulation;
-	/* hierarchy */
-	uint8_t hierarchy;
-	/* interleaving mode */
-	uint8_t interleaving_mode;
-	/* code rate */
-	uint8_t code_rate;
-	/* guard interval */
-	uint8_t guard_interval;
-	/* transmission mode */
-	uint8_t transmission_mode;
-} __packed;
-
-struct as10x_tune_status {
-	/* tune status */
-	uint8_t tune_state;
-	/* signal strength */
-	int16_t signal_strength;
-	/* packet error rate 10^-4 */
-	uint16_t PER;
-	/* bit error rate 10^-4 */
-	uint16_t BER;
-} __packed;
-
-struct as10x_demod_stats {
-	/* frame counter */
-	uint32_t frame_count;
-	/* Bad frame counter */
-	uint32_t bad_frame_count;
-	/* Number of wrong bytes fixed by Reed-Solomon */
-	uint32_t bytes_fixed_by_rs;
-	/* Averaged MER */
-	uint16_t mer;
-	/* statistics calculation state indicator (started or not) */
-	uint8_t has_started;
-} __packed;
-
-struct as10x_ts_filter {
-	uint16_t pid;  /* valid PID value 0x00 : 0x2000 */
-	uint8_t  type; /* Red TS_PID_TYPE_<N> values */
-	uint8_t  idx;  /* index in filtering table */
-} __packed;
-
-struct as10x_register_value {
-	uint8_t mode;
-	union {
-		uint8_t  value8;   /* 8 bit value */
-		uint16_t value16;  /* 16 bit value */
-		uint32_t value32;  /* 32 bit value */
-	} __packed u;
-} __packed;
-
-struct as10x_register_addr {
-	/* register addr */
-	uint32_t addr;
-	/* register mode access */
-	uint8_t mode;
-};
-
-#endif
-- 
1.9.3

