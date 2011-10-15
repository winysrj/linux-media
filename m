Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:56506 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:54:23 -0400
Message-ID: <4E99F2FC.5030200@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:54:20 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 1/7] Staging submission: PCTV 74e driver (as102)
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl>
In-Reply-To: <4E999733.2010802@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Staging submission: PCTV 74e driver (as102)

From: Devin Heitmueller<dheitmueller@kernellabs.com>

pull as102 driver from

This is driver for PCTV 74e DVB-T USB tuner, taken from [1],
written by Devin Heitmueller using the GPL reference driver provided by Abilis.

The only change needed to compile it in current git tree [2]
was changing calls usb_buffer_alloc() and usb_buffer_free() to
usb_alloc_coherent() and usb_free_coherent(). It's included in this patch.

Patch was tested by me on amd64.

[1]http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
[2] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel-3.1.0-git9+

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>

diff -Nur linux.clean/drivers/staging/as102/as102_drv.c linux.as102_initial/drivers/staging/as102/as102_drv.c
--- linux.clean/drivers/staging/as102/as102_drv.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_drv.c	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,360 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>
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
+#include<linux/kernel.h>
+#include<linux/errno.h>
+#include<linux/init.h>
+#include<linux/slab.h>
+#include<linux/module.h>
+#include<linux/mm.h>
+#include<linux/kref.h>
+#include<asm/uaccess.h>
+#include<linux/usb.h>
+
+/* header file for Usb device driver*/
+#include "as102_drv.h"
+#include "as102_fw.h"
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+#include "dvbdev.h"
+#else
+#warning>>>  DVB_CORE not defined !!!<<<
+#endif
+
+int debug;
+module_param_named(debug, debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off debugging (default: off)");
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
+#ifdef DVB_DEFINE_MOD_OPT_ADAPTER_NR
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+#endif
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+static void as102_stop_stream(struct as102_dev_t *dev)
+{
+	struct as102_bus_adapter_t *bus_adap;
+
+	if (dev != NULL)
+		bus_adap =&dev->bus_adap;
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
+		if (as10x_cmd_stop_streaming(bus_adap)<  0)
+			dprintk(debug, "as10x_cmd_stop_streaming failed\n");
+
+		mutex_unlock(&dev->bus_adap.lock);
+	}
+}
+
+static int as102_start_stream(struct as102_dev_t *dev)
+{
+	struct as102_bus_adapter_t *bus_adap;
+	int ret = -EFAULT;
+
+	if (dev != NULL)
+		bus_adap =&dev->bus_adap;
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
+	struct as102_bus_adapter_t *bus_adap =&dev->bus_adap;
+	int ret = -EFAULT;
+
+	ENTER();
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock)) {
+		dprintk(debug, "mutex_lock_interruptible(lock) failed !\n");
+		return -EBUSY;
+	}
+
+	switch (onoff) {
+	case 0:
+	    ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
+	    dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+		    index, pid, ret);
+	    break;
+	case 1:
+	{
+	    struct as10x_ts_filter filter;
+
+	    filter.type = TS_PID_TYPE_TS;
+	    filter.idx = 0xFF;
+	    filter.pid = pid;
+
+	    ret = as10x_cmd_add_PID_filter(bus_adap,&filter);
+	    dprintk(debug, "ADD_PID_FILTER([%02d ->  %02d], 0x%04x) ret = %d\n",
+		    index, filter.idx, filter.pid, ret);
+	    break;
+	}
+	}
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	LEAVE();
+	return ret;
+}
+
+static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	int ret = 0;
+	struct dvb_demux *demux = dvbdmxfeed->demux;
+	struct as102_dev_t *as102_dev = demux->priv;
+
+	ENTER();
+
+	if (mutex_lock_interruptible(&as102_dev->sem))
+		return -ERESTARTSYS;
+
+	if (pid_filtering) {
+		as10x_pid_filter(as102_dev,
+				dvbdmxfeed->index, dvbdmxfeed->pid, 1);
+	}
+
+	if (as102_dev->streaming++ == 0)
+		ret = as102_start_stream(as102_dev);
+
+	mutex_unlock(&as102_dev->sem);
+	LEAVE();
+	return ret;
+}
+
+static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
+	struct dvb_demux *demux = dvbdmxfeed->demux;
+	struct as102_dev_t *as102_dev = demux->priv;
+
+	ENTER();
+
+	if (mutex_lock_interruptible(&as102_dev->sem))
+		return -ERESTARTSYS;
+
+	if (--as102_dev->streaming == 0)
+		as102_stop_stream(as102_dev);
+
+	if (pid_filtering) {
+		as10x_pid_filter(as102_dev,
+				dvbdmxfeed->index, dvbdmxfeed->pid, 0);
+	}
+
+	mutex_unlock(&as102_dev->sem);
+	LEAVE();
+	return 0;
+}
+#endif
+
+int as102_dvb_register(struct as102_dev_t *as102_dev)
+{
+	int ret = 0;
+	ENTER();
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+	ret = dvb_register_adapter(&as102_dev->dvb_adap,
+				   as102_dev->name,
+				   THIS_MODULE,
+#if defined(CONFIG_AS102_USB)
+				&as102_dev->bus_adap.usb_dev->dev
+#elif defined(CONFIG_AS102_SPI)
+				&as102_dev->bus_adap.spi_dev->dev
+#else
+#error>>>  dvb_register_adapter<<<
+#endif
+#ifdef DVB_DEFINE_MOD_OPT_ADAPTER_NR
+				   , adapter_nr
+#endif
+				   );
+	if (ret<  0) {
+		err("%s: dvb_register_adapter() failed (errno = %d)",
+		    __func__, ret);
+		goto failed;
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
+	as102_dev->dvb_dmxdev.demux =&as102_dev->dvb_dmx.dmx;
+	as102_dev->dvb_dmxdev.capabilities = 0;
+
+	ret = dvb_dmx_init(&as102_dev->dvb_dmx);
+	if (ret<  0) {
+		err("%s: dvb_dmx_init() failed (errno = %d)", __func__, ret);
+		goto failed;
+	}
+
+	ret = dvb_dmxdev_init(&as102_dev->dvb_dmxdev,&as102_dev->dvb_adap);
+	if (ret<  0) {
+		err("%s: dvb_dmxdev_init() failed (errno = %d)", __func__,
+		    ret);
+		goto failed;
+	}
+
+	ret = as102_dvb_register_fe(as102_dev,&as102_dev->dvb_fe);
+	if (ret<  0) {
+		err("%s: as102_dvb_register_frontend() failed (errno = %d)",
+		    __func__, ret);
+		goto failed;
+	}
+#endif
+
+	/* init bus mutex for token locking */
+	mutex_init(&as102_dev->bus_adap.lock);
+
+	/* init start / stop stream mutex */
+	mutex_init(&as102_dev->sem);
+
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+	/*
+	 * try to load as102 firmware. If firmware upload failed, we'll be
+	 * able to upload it later.
+	 */
+	if (fw_upload)
+		try_then_request_module(as102_fw_upload(&as102_dev->bus_adap),
+				"firmware_class");
+#endif
+
+failed:
+	LEAVE();
+	/* FIXME: free dvb_XXX */
+	return ret;
+}
+
+void as102_dvb_unregister(struct as102_dev_t *as102_dev)
+{
+	ENTER();
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+	/* unregister as102 frontend */
+	as102_dvb_unregister_fe(&as102_dev->dvb_fe);
+
+	/* unregister demux device */
+	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
+	dvb_dmx_release(&as102_dev->dvb_dmx);
+
+	/* unregister dvb adapter */
+	dvb_unregister_adapter(&as102_dev->dvb_adap);
+#endif
+	LEAVE();
+}
+
+static int __init as102_driver_init(void)
+{
+	int ret = 0;
+
+	ENTER();
+
+	/* register this driver with the low level subsystem */
+#if defined(CONFIG_AS102_USB)
+	ret = usb_register(&as102_usb_driver);
+	if (ret)
+		err("usb_register failed (ret = %d)", ret);
+#endif
+#if defined(CONFIG_AS102_SPI)
+	ret = spi_register_driver(&as102_spi_driver);
+	if (ret)
+		printk(KERN_ERR "spi_register failed (ret = %d)", ret);
+#endif
+
+	LEAVE();
+	return ret;
+}
+
+/*
+ * Mandatory function : Adds a special section to the module indicating
+ * where initialisation function is defined
+ */
+module_init(as102_driver_init);
+
+/**
+ * \brief as102 driver exit point. This function is called when device has
+ *       to be removed.
+ */
+static void __exit as102_driver_exit(void)
+{
+	ENTER();
+	/* deregister this driver with the low level bus subsystem */
+#if defined(CONFIG_AS102_USB)
+	usb_deregister(&as102_usb_driver);
+#endif
+#if defined(CONFIG_AS102_SPI)
+	spi_unregister_driver(&as102_spi_driver);
+#endif
+	LEAVE();
+}
+
+/*
+ * required function for unload: Adds a special section to the module
+ * indicating where unload function is defined
+ */
+module_exit(as102_driver_exit);
+/* modinfo details */
+MODULE_DESCRIPTION(DRIVER_FULL_NAME);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pierrick Hascoet<pierrick.hascoet@abilis.com>");
+
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as102_drv.h linux.as102_initial/drivers/staging/as102/as102_drv.h
--- linux.clean/drivers/staging/as102/as102_drv.h	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_drv.h	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,147 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+#if defined(CONFIG_AS102_USB)
+#include<linux/usb.h>
+extern struct usb_driver as102_usb_driver;
+#endif
+
+#if defined(CONFIG_AS102_SPI)
+#include<linux/platform_device.h>
+#include<linux/spi/spi.h>
+#include<linux/cdev.h>
+
+extern struct spi_driver as102_spi_driver;
+#endif
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dmxdev.h"
+#endif
+
+#define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
+#define DRIVER_NAME "as10x_usb"
+
+extern int debug;
+
+#define dprintk(debug, args...) \
+	do { if (debug) {	\
+		printk(KERN_DEBUG "%s: ",__FUNCTION__);	\
+		printk(args);	\
+	} } while (0)
+
+#ifdef TRACE
+#define ENTER()                 printk(">>  enter %s\n", __FUNCTION__)
+#define LEAVE()                 printk("<<  leave %s\n", __FUNCTION__)
+#else
+#define ENTER()
+#define LEAVE()
+#endif
+
+#define AS102_DEVICE_MAJOR	192
+
+#define AS102_USB_BUF_SIZE	512
+#define MAX_STREAM_URB		32
+
+#include "as10x_cmd.h"
+
+#if defined(CONFIG_AS102_USB)
+#include "as102_usb_drv.h"
+#endif
+
+#if defined(CONFIG_AS102_SPI)
+#include "as10x_spi_drv.h"
+#endif
+
+
+struct as102_bus_adapter_t {
+#if defined(CONFIG_AS102_USB)
+	struct usb_device *usb_dev;
+#elif defined(CONFIG_AS102_SPI)
+	struct spi_device *spi_dev;
+	struct cdev cdev; /* spidev raw device */
+
+	struct timer_list timer;
+	struct completion xfer_done;
+#endif
+	/* bus token lock */
+	struct mutex lock;
+	/* low level interface for bus adapter */
+	union as10x_bus_token_t {
+#if defined(CONFIG_AS102_USB)
+		/* usb token */
+		struct as10x_usb_token_cmd_t usb;
+#endif
+#if defined(CONFIG_AS102_SPI)
+		/* spi token */
+		struct as10x_spi_token_cmd_t spi;
+#endif
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
+	struct as102_bus_adapter_t bus_adap;
+	struct list_head device_entry;
+	struct kref kref;
+	unsigned long minor;
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+	struct dvb_adapter dvb_adap;
+	struct dvb_frontend dvb_fe;
+	struct dvb_demux dvb_dmx;
+	struct dmxdev dvb_dmxdev;
+#endif
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
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
+int as102_dvb_unregister_fe(struct dvb_frontend *dev);
+#endif
+
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as102_fe.c linux.as102_initial/drivers/staging/as102/as102_fe.c
--- linux.clean/drivers/staging/as102/as102_fe.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_fe.c	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,675 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>
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
+#include<linux/version.h>
+
+#include "as102_drv.h"
+#include "as10x_types.h"
+#include "as10x_cmd.h"
+
+extern int elna_enable;
+
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
+					 struct as10x_tps *src);
+
+static void as102_fe_copy_tune_parameters(struct as10x_tune_args *dst,
+					  struct dvb_frontend_parameters *src);
+
+#if (LINUX_VERSION_CODE<  KERNEL_VERSION(2, 6, 19))
+static void as102_fe_release(struct dvb_frontend *fe)
+{
+	struct as102_dev_t *dev;
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return;
+
+	/* send abilis command: TURN_OFF */
+	as10x_cmd_turn_off(&dev->bus_adap);
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	/* release frontend callback ops */
+	memset(&fe->ops, 0, sizeof(struct dvb_frontend_ops));
+
+	/* flush statistics */
+	memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
+	dev->signal_strength = 0;
+	dev->ber = -1;
+
+	/* reset tuner private data */
+/* 	fe->tuner_priv = NULL; */
+
+	LEAVE();
+}
+
+static int as102_fe_init(struct dvb_frontend *fe)
+{
+	int ret = 0;
+	struct as102_dev_t *dev;
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	if (elna_enable)
+		ret = as10x_cmd_set_context(&dev->bus_adap, 1010, 0xC0);
+
+	/* send abilis command: TURN_ON */
+	ret = as10x_cmd_turn_on(&dev->bus_adap);
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	LEAVE();
+	return (ret<  0) ? -EINVAL : 0;
+}
+#endif
+
+static int as102_fe_set_frontend(struct dvb_frontend *fe,
+				 struct dvb_frontend_parameters *params)
+{
+	int ret = 0;
+	struct as102_dev_t *dev;
+	struct as10x_tune_args tune_args = { 0 };
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	as102_fe_copy_tune_parameters(&tune_args, params);
+
+	/* send abilis command: SET_TUNE */
+	ret =  as10x_cmd_set_tune(&dev->bus_adap,&tune_args);
+	if (ret != 0)
+		dprintk(debug, "as10x_cmd_set_tune failed. (err = %d)\n", ret);
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	LEAVE();
+	return (ret<  0) ? -EINVAL : 0;
+}
+
+static int as102_fe_get_frontend(struct dvb_frontend *fe,
+				 struct dvb_frontend_parameters *p) {
+	int ret = 0;
+	struct as102_dev_t *dev;
+	struct as10x_tps tps = { 0 };
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TPS */
+	ret = as10x_cmd_get_tps(&dev->bus_adap,&tps);
+
+	if (ret == 0)
+		as10x_fe_copy_tps_parameters(p,&tps);
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	LEAVE();
+	return (ret<  0) ? -EINVAL : 0;
+}
+
+static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
+			struct dvb_frontend_tune_settings *settings) {
+	ENTER();
+
+#if 0
+	dprintk(debug, "step_size    = %d\n", settings->step_size);
+	dprintk(debug, "max_drift    = %d\n", settings->max_drift);
+	dprintk(debug, "min_delay_ms = %d ->  %d\n", settings->min_delay_ms,
+		1000);
+#endif
+
+	settings->min_delay_ms = 1000;
+
+	LEAVE();
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
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dev->bus_adap.lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TUNE_STATUS */
+	ret = as10x_cmd_get_tune_status(&dev->bus_adap,&tstate);
+	if (ret<  0) {
+		dprintk(debug, "as10x_cmd_get_tune_status failed (err = %d)\n",
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
+	dprintk(debug, "tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
+			tstate.tune_state, tstate.signal_strength,
+			tstate.PER, tstate.BER);
+
+	if (*status&  FE_HAS_LOCK) {
+		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
+			(struct as10x_demod_stats *)&dev->demod_stats)<  0) {
+			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
+			dprintk(debug, "as10x_cmd_get_demod_stats failed "
+				"(probably not tuned)\n");
+		} else {
+			dprintk(debug,
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
+	LEAVE();
+	return ret;
+}
+
+/*
+ * Note:
+ * - in AS102 SNR=MER
+ *   - the SNR will be returned in linear terms, i.e. not in dB
+ *   - the accuracy equals �2dB for a SNR range from 4dB to 30dB
+ *   - the accuracy is>2dB for SNR values outside this range
+ */
+static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct as102_dev_t *dev;
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	*snr = dev->demod_stats.mer;
+
+	LEAVE();
+	return 0;
+}
+
+static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct as102_dev_t *dev;
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	*ber = dev->ber;
+
+	LEAVE();
+	return 0;
+}
+
+static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
+					 u16 *strength)
+{
+	struct as102_dev_t *dev;
+
+	ENTER();
+
+	dev = (struct as102_dev_t *) fe->tuner_priv;
+	if (dev == NULL)
+		return -ENODEV;
+
+	*strength = (((0xffff * 400) * dev->signal_strength + 41000) * 2);
+
+	LEAVE();
+	return 0;
+}
+
+static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct as102_dev_t *dev;
+
+	ENTER();
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
+	LEAVE();
+	return 0;
+}
+
+#if (LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 19))
+static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
+{
+	struct as102_dev_t *dev;
+	int ret;
+
+	ENTER();
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
+			as10x_cmd_set_context(&dev->bus_adap, 1010, 0xC0);
+
+		ret = as10x_cmd_turn_on(&dev->bus_adap);
+	} else {
+		ret = as10x_cmd_turn_off(&dev->bus_adap);
+	}
+
+	mutex_unlock(&dev->bus_adap.lock);
+
+	LEAVE();
+	return ret;
+}
+#endif
+
+static struct dvb_frontend_ops as102_fe_ops = {
+	.info = {
+		.name			= "Unknown AS102 device",
+		.type			= FE_OFDM,
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
+
+	.read_status		= as102_fe_read_status,
+	.read_snr		= as102_fe_read_snr,
+	.read_ber		= as102_fe_read_ber,
+	.read_signal_strength	= as102_fe_read_signal_strength,
+	.read_ucblocks		= as102_fe_read_ucblocks,
+
+#if (LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 19))
+	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+#else
+	.release		= as102_fe_release,
+	.init			= as102_fe_init,
+#endif
+};
+
+int as102_dvb_unregister_fe(struct dvb_frontend *fe)
+{
+	/* unregister frontend */
+	dvb_unregister_frontend(fe);
+
+#if (LINUX_VERSION_CODE>= KERNEL_VERSION(2, 6, 19))
+	/* detach frontend */
+	dvb_frontend_detach(fe);
+#endif
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
+	dvb_adap =&as102_dev->dvb_adap;
+
+	/* init frontend callback ops */
+	memcpy(&dvb_fe->ops,&as102_fe_ops, sizeof(struct dvb_frontend_ops));
+	strncpy(dvb_fe->ops.info.name, as102_dev->name,
+		sizeof(dvb_fe->ops.info.name));
+
+	/* register dbvb frontend */
+	errno = dvb_register_frontend(dvb_adap, dvb_fe);
+	if (errno == 0)
+		dvb_fe->tuner_priv = as102_dev;
+
+	return errno;
+}
+
+static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
+					 struct as10x_tps *as10x_tps)
+{
+
+	struct dvb_ofdm_parameters *fe_tps =&dst->u.ofdm;
+
+	/* extract consteallation */
+	switch (as10x_tps->constellation) {
+	case CONST_QPSK:
+		fe_tps->constellation = QPSK;
+		break;
+	case CONST_QAM16:
+		fe_tps->constellation = QAM_16;
+		break;
+	case CONST_QAM64:
+		fe_tps->constellation = QAM_64;
+		break;
+	}
+
+	/* extract hierarchy */
+	switch (as10x_tps->hierarchy) {
+	case HIER_NONE:
+		fe_tps->hierarchy_information = HIERARCHY_NONE;
+		break;
+	case HIER_ALPHA_1:
+		fe_tps->hierarchy_information = HIERARCHY_1;
+		break;
+	case HIER_ALPHA_2:
+		fe_tps->hierarchy_information = HIERARCHY_2;
+		break;
+	case HIER_ALPHA_4:
+		fe_tps->hierarchy_information = HIERARCHY_4;
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
+			  struct dvb_frontend_parameters *params)
+{
+
+	/* set frequency */
+	tune_args->freq = params->frequency / 1000;
+
+	/* fix interleaving_mode */
+	tune_args->interleaving_mode = INTLV_NATIVE;
+
+	switch (params->u.ofdm.bandwidth) {
+	case BANDWIDTH_8_MHZ:
+		tune_args->bandwidth = BW_8_MHZ;
+		break;
+	case BANDWIDTH_7_MHZ:
+		tune_args->bandwidth = BW_7_MHZ;
+		break;
+	case BANDWIDTH_6_MHZ:
+		tune_args->bandwidth = BW_6_MHZ;
+		break;
+	default:
+		tune_args->bandwidth = BW_8_MHZ;
+	}
+
+	switch (params->u.ofdm.guard_interval) {
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
+	switch (params->u.ofdm.constellation) {
+	case QPSK:
+		tune_args->constellation = CONST_QPSK;
+		break;
+	case QAM_16:
+		tune_args->constellation = CONST_QAM16;
+		break;
+	case QAM_64:
+		tune_args->constellation = CONST_QAM64;
+		break;
+	default:
+		tune_args->constellation = CONST_UNKNOWN;
+		break;
+	}
+
+	switch (params->u.ofdm.transmission_mode) {
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
+	switch (params->u.ofdm.hierarchy_information) {
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
+	dprintk(debug, "tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
+			params->frequency,
+			tune_args->bandwidth,
+			tune_args->guard_interval);
+
+	/*
+	 * Detect a hierarchy selection
+	 * if HP/LP are both set to FEC_NONE, HP will be selected.
+	 */
+	if ((tune_args->hierarchy != HIER_NONE)&&
+		       ((params->u.ofdm.code_rate_LP == FEC_NONE) ||
+			(params->u.ofdm.code_rate_HP == FEC_NONE))) {
+
+		if (params->u.ofdm.code_rate_LP == FEC_NONE) {
+			tune_args->hier_select = HIER_HIGH_PRIORITY;
+			tune_args->code_rate =
+			   as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+		}
+
+		if (params->u.ofdm.code_rate_HP == FEC_NONE) {
+			tune_args->hier_select = HIER_LOW_PRIORITY;
+			tune_args->code_rate =
+			   as102_fe_get_code_rate(params->u.ofdm.code_rate_LP);
+		}
+
+		dprintk(debug, "\thierarchy: 0x%02x  "
+				"selected: %s  code_rate_%s: 0x%02x\n",
+			tune_args->hierarchy,
+			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args->code_rate);
+	} else {
+		tune_args->code_rate =
+			as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
+	}
+}
+#endif
+
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as102_fw.c linux.as102_initial/drivers/staging/as102/as102_fw.c
--- linux.clean/drivers/staging/as102/as102_fw.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_fw.c	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,251 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>
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
+#include<linux/kernel.h>
+#include<linux/errno.h>
+#include<linux/ctype.h>
+#include<linux/delay.h>
+#include<linux/firmware.h>
+
+#include "as102_drv.h"
+#include "as102_fw.h"
+
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+char as102_st_fw1[] = "as102_data1_st.hex";
+char as102_st_fw2[] = "as102_data2_st.hex";
+char as102_dt_fw1[] = "as102_data1_dt.hex";
+char as102_dt_fw2[] = "as102_data2_dt.hex";
+
+static unsigned char atohx(unsigned char *dst, char *src)
+{
+	unsigned char value = 0;
+
+	char msb = tolower(*src) - '0';
+	char lsb = tolower(*(src + 1)) - '0';
+
+	if (msb>  9)
+		msb -= 7;
+	if (lsb>  9)
+		lsb -= 7;
+
+	*dst = value = ((msb&  0xF)<<  4) | (lsb&  0xF);
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
+		printk(KERN_ERR "invalid firmware file\n");
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
+static int as102_firmware_upload(struct as102_bus_adapter_t *bus_adap,
+				 unsigned char *cmd,
+				 const struct firmware *firmware) {
+
+	struct as10x_fw_pkt_t fw_pkt;
+	int total_read_bytes = 0, errno = 0;
+	unsigned char addr_has_changed = 0;
+
+	ENTER();
+
+	for (total_read_bytes = 0; total_read_bytes<  firmware->size; ) {
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
+		if (read_bytes<= 0)
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
+							&fw_pkt, 2, 0);
+			if (errno<  0)
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
+								&fw_pkt,
+								     data_len,
+								     0);
+				if (errno<  0)
+					goto error;
+			}
+		}
+	}
+error:
+	LEAVE();
+	return (errno == 0) ? total_read_bytes : errno;
+}
+
+int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
+{
+	int errno = -EFAULT;
+	const struct firmware *firmware;
+	unsigned char *cmd_buf = NULL;
+	char *fw1, *fw2;
+
+#if defined(CONFIG_AS102_USB)
+	struct usb_device *dev = bus_adap->usb_dev;
+#endif
+#if defined(CONFIG_AS102_SPI)
+	struct spi_device *dev = bus_adap->spi_dev;
+#endif
+	ENTER();
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
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+	/* allocate buffer to store firmware upload command and data */
+	cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL);
+	if (cmd_buf == NULL) {
+		errno = -ENOMEM;
+		goto error;
+	}
+
+	/* request kernel to locate firmware file: part1 */
+	errno = request_firmware(&firmware, fw1,&dev->dev);
+	if (errno<  0) {
+		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
+				 DRIVER_NAME, fw1);
+		goto error;
+	}
+
+	/* initiate firmware upload */
+	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
+	if (errno<  0) {
+		printk(KERN_ERR "%s: error during firmware upload part1\n",
+				 DRIVER_NAME);
+		goto error;
+	}
+
+	printk(KERN_INFO "%s: fimrware: %s loaded with success\n",
+			 DRIVER_NAME, fw1);
+	release_firmware(firmware);
+
+	/* wait for boot to complete */
+	mdelay(100);
+
+	/* request kernel to locate firmware file: part2 */
+	errno = request_firmware(&firmware, fw2,&dev->dev);
+	if (errno<  0) {
+		printk(KERN_ERR "%s: unable to locate firmware file: %s\n",
+				 DRIVER_NAME, fw2);
+		goto error;
+	}
+
+	/* initiate firmware upload */
+	errno = as102_firmware_upload(bus_adap, cmd_buf, firmware);
+	if (errno<  0) {
+		printk(KERN_ERR "%s: error during firmware upload part2\n",
+				 DRIVER_NAME);
+		goto error;
+	}
+
+	printk(KERN_INFO "%s: fimrware: %s loaded with success\n",
+			DRIVER_NAME, fw2);
+error:
+	/* free data buffer */
+	kfree(cmd_buf);
+	/* release firmware if needed */
+	if (firmware != NULL)
+		release_firmware(firmware);
+#endif
+	LEAVE();
+	return errno;
+}
+#endif
+
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as102_fw.h linux.as102_initial/drivers/staging/as102/as102_fw.h
--- linux.clean/drivers/staging/as102/as102_fw.h	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_fw.h	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,42 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+#pragma pack(1)
+struct as10x_raw_fw_pkt {
+	unsigned char address[4];
+	unsigned char data[MAX_FW_PKT_SIZE - 6];
+};
+
+struct as10x_fw_pkt_t {
+	union {
+		unsigned char request[2];
+		unsigned char length[2];
+	} u;
+	struct as10x_raw_fw_pkt raw;
+};
+#pragma pack()
+
+#ifdef __KERNEL__
+int as102_fw_upload(struct as102_bus_adapter_t *bus_adap);
+#endif
+
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as102_usb_drv.c linux.as102_initial/drivers/staging/as102/as102_usb_drv.c
--- linux.clean/drivers/staging/as102/as102_usb_drv.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_usb_drv.c	2011-10-14 18:00:19.000000000 +0200
@@ -0,0 +1,484 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>
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
+#include<linux/kernel.h>
+#include<linux/errno.h>
+#include<linux/slab.h>
+#include<linux/mm.h>
+#include<linux/usb.h>
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
+	{ } /* Terminating entry */
+};
+
+/* Note that this table must always have the same number of entries as the
+   as102_usb_id_table struct */
+static const char *as102_device_names[] = {
+	AS102_REFERENCE_DESIGN,
+	AS102_PCTV_74E,
+	AS102_ELGATO_EYETV_DTT_NAME,
+	NULL /* Terminating entry */
+};
+
+struct usb_driver as102_usb_driver = {
+	.name       =  DRIVER_FULL_NAME,
+	.probe      =  as102_usb_probe,
+	.disconnect =  as102_usb_disconnect,
+	.id_table   =  as102_usb_id_table
+};
+
+static const struct file_operations as102_dev_fops = {
+	.owner   = THIS_MODULE,
+	.open    = as102_open,
+	.release = as102_release,
+};
+
+static struct usb_class_driver as102_usb_class_driver = {
+	.name		= "aton2-%d",
+	.fops		=&as102_dev_fops,
+	.minor_base	= AS102_DEVICE_MAJOR,
+};
+
+static int as102_usb_xfer_cmd(struct as102_bus_adapter_t *bus_adap,
+			      unsigned char *send_buf, int send_buf_len,
+			      unsigned char *recv_buf, int recv_buf_len)
+{
+	int ret = 0;
+	ENTER();
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
+		if (ret<  0) {
+			dprintk(debug, "usb_control_msg(send) failed, err %i\n",
+					ret);
+			return ret;
+		}
+
+		if (ret != send_buf_len) {
+			dprintk(debug, "only wrote %d of %d bytes\n",
+					ret, send_buf_len);
+			return -1;
+		}
+	}
+
+	if (recv_buf != NULL) {
+#ifdef TRACE
+		dprintk(debug, "want to read: %d bytes\n", recv_buf_len);
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
+		if (ret<  0) {
+			dprintk(debug, "usb_control_msg(recv) failed, err %i\n",
+					ret);
+			return ret;
+		}
+#ifdef TRACE
+		dprintk(debug, "read %d bytes\n", recv_buf_len);
+#endif
+	}
+
+	LEAVE();
+	return ret;
+}
+
+static int as102_send_ep1(struct as102_bus_adapter_t *bus_adap,
+			  unsigned char *send_buf,
+			  int send_buf_len,
+			  int swap32)
+{
+	int ret = 0, actual_len;
+
+	ret = usb_bulk_msg(bus_adap->usb_dev,
+			   usb_sndbulkpipe(bus_adap->usb_dev, 1),
+			   send_buf, send_buf_len,&actual_len, 200);
+	if (ret) {
+		dprintk(debug, "usb_bulk_msg(send) failed, err %i\n", ret);
+		return ret;
+	}
+
+	if (actual_len != send_buf_len) {
+		dprintk(debug, "only wrote %d of %d bytes\n",
+				actual_len, send_buf_len);
+		return -1;
+	}
+	return ret ? ret : actual_len;
+}
+
+static int as102_read_ep2(struct as102_bus_adapter_t *bus_adap,
+		   unsigned char *recv_buf, int recv_buf_len)
+{
+	int ret = 0, actual_len;
+
+	if (recv_buf == NULL)
+		return -EINVAL;
+
+	ret = usb_bulk_msg(bus_adap->usb_dev,
+			   usb_rcvbulkpipe(bus_adap->usb_dev, 2),
+			   recv_buf, recv_buf_len,&actual_len, 200);
+	if (ret) {
+		dprintk(debug, "usb_bulk_msg(recv) failed, err %i\n", ret);
+		return ret;
+	}
+
+	if (actual_len != recv_buf_len) {
+		dprintk(debug, "only read %d of %d bytes\n",
+				actual_len, recv_buf_len);
+		return -1;
+	}
+	return ret ? ret : actual_len;
+}
+
+struct as102_priv_ops_t as102_priv_ops = {
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
+		dprintk(debug, "%s: usb_submit_urb failed\n", __func__);
+
+	return err;
+}
+
+#if (LINUX_VERSION_CODE<= KERNEL_VERSION(2, 6, 18))
+void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs)
+#else
+void as102_urb_stream_irq(struct urb *urb)
+#endif
+{
+	struct as102_dev_t *as102_dev = urb->context;
+
+	if (urb->actual_length>  0) {
+#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
+		dvb_dmx_swfilter(&as102_dev->dvb_dmx,
+				 urb->transfer_buffer,
+				 urb->actual_length);
+#else
+		/* do nothing ? */
+#endif
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
+	ENTER();
+
+	for (i = 0; i<  MAX_STREAM_URB; i++)
+		usb_free_urb(dev->stream_urb[i]);
+
+	usb_free_coherent(dev->bus_adap.usb_dev,
+			MAX_STREAM_URB * AS102_USB_BUF_SIZE,
+			dev->stream,
+			dev->dma_addr);
+	LEAVE();
+}
+
+static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
+{
+	int i, ret = 0;
+
+	ENTER();
+
+	dev->stream = usb_alloc_coherent(dev->bus_adap.usb_dev,
+				       MAX_STREAM_URB * AS102_USB_BUF_SIZE,
+				       GFP_KERNEL,
+				&dev->dma_addr);
+	if (!dev->stream) {
+		dprintk(debug, "%s: usb_buffer_alloc failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	memset(dev->stream, 0, MAX_STREAM_URB * AS102_USB_BUF_SIZE);
+
+	/* init urb buffers */
+	for (i = 0; i<  MAX_STREAM_URB; i++) {
+		struct urb *urb;
+
+		urb = usb_alloc_urb(0, GFP_ATOMIC);
+		if (urb == NULL) {
+			dprintk(debug, "%s: usb_alloc_urb failed\n", __func__);
+			as102_free_usb_stream_buffer(dev);
+			return -ENOMEM;
+		}
+
+		urb->transfer_buffer = dev->stream + (i * AS102_USB_BUF_SIZE);
+		urb->transfer_buffer_length = AS102_USB_BUF_SIZE;
+
+		dev->stream_urb[i] = urb;
+	}
+	LEAVE();
+	return ret;
+}
+
+static void as102_usb_stop_stream(struct as102_dev_t *dev)
+{
+	int i;
+
+	for (i = 0; i<  MAX_STREAM_URB; i++)
+		usb_kill_urb(dev->stream_urb[i]);
+}
+
+static int as102_usb_start_stream(struct as102_dev_t *dev)
+{
+	int i, ret = 0;
+
+	for (i = 0; i<  MAX_STREAM_URB; i++) {
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
+	ENTER();
+
+	as102_dev = container_of(kref, struct as102_dev_t, kref);
+	if (as102_dev != NULL) {
+		usb_put_dev(as102_dev->bus_adap.usb_dev);
+		kfree(as102_dev);
+	}
+
+	LEAVE();
+}
+
+static void as102_usb_disconnect(struct usb_interface *intf)
+{
+	struct as102_dev_t *as102_dev;
+
+	ENTER();
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
+	usb_deregister_dev(intf,&as102_usb_class_driver);
+
+	/* decrement usage counter */
+	kref_put(&as102_dev->kref, as102_usb_release);
+
+	printk(KERN_INFO "%s: device has been disconnected\n", DRIVER_NAME);
+
+	LEAVE();
+}
+
+static int as102_usb_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	int ret;
+	struct as102_dev_t *as102_dev;
+	int i;
+
+	ENTER();
+
+	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
+	if (as102_dev == NULL) {
+		err("%s: kzalloc failed", __func__);
+		return -ENOMEM;
+	}
+
+	/* This should never actually happen */
+	if ((sizeof(as102_usb_id_table) / sizeof(struct usb_device_id)) !=
+	    (sizeof(as102_device_names) / sizeof(const char *))) {
+		printk(KERN_ERR "Device names table invalid size");
+		return -EINVAL;
+	}
+
+	/* Assign the user-friendly device name */
+	for (i = 0; i<  (sizeof(as102_usb_id_table) /
+			 sizeof(struct usb_device_id)); i++) {
+		if (id ==&as102_usb_id_table[i])
+			as102_dev->name = as102_device_names[i];
+	}
+
+	if (as102_dev->name == NULL)
+		as102_dev->name = "Unknown AS102 device";
+
+	/* set private callback functions */
+	as102_dev->bus_adap.ops =&as102_priv_ops;
+
+	/* init cmd token for usb bus */
+	as102_dev->bus_adap.cmd =&as102_dev->bus_adap.token.usb.c;
+	as102_dev->bus_adap.rsp =&as102_dev->bus_adap.token.usb.r;
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
+	ret = usb_register_dev(intf,&as102_usb_class_driver);
+	if (ret<  0) {
+		/* something prevented us from registering this driver */
+		err("%s: usb_register_dev() failed (errno = %d)",
+		    __func__, ret);
+		goto failed;
+	}
+
+	printk(KERN_INFO "%s: device has been detected\n", DRIVER_NAME);
+
+	/* request buffer allocation for streaming */
+	ret = as102_alloc_usb_stream_buffer(as102_dev);
+	if (ret != 0)
+		goto failed;
+
+	/* register dvb layer */
+	ret = as102_dvb_register(as102_dev);
+
+	LEAVE();
+	return ret;
+
+failed:
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
+	ENTER();
+
+	/* read minor from inode */
+	minor = iminor(inode);
+
+	/* fetch device from usb interface */
+	intf = usb_find_interface(&as102_usb_driver, minor);
+	if (intf == NULL) {
+		printk(KERN_ERR "%s: can't find device for minor %d\n",
+				__func__, minor);
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
+	LEAVE();
+	return ret;
+}
+
+static int as102_release(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+	struct as102_dev_t *dev = NULL;
+
+	ENTER();
+
+	dev = file->private_data;
+	if (dev != NULL) {
+		/* decrement the count on our device */
+		kref_put(&dev->kref, as102_usb_release);
+	}
+
+	LEAVE();
+	return ret;
+}
+
+MODULE_DEVICE_TABLE(usb, as102_usb_id_table);
+
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as102_usb_drv.h linux.as102_initial/drivers/staging/as102/as102_usb_drv.h
--- linux.clean/drivers/staging/as102/as102_usb_drv.h	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as102_usb_drv.h	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,59 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>
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
+#include<linux/version.h>
+
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
+#if (LINUX_VERSION_CODE<= KERNEL_VERSION(2, 6, 18))
+void as102_urb_stream_irq(struct urb *urb, struct pt_regs *regs);
+#else
+void as102_urb_stream_irq(struct urb *urb);
+#endif
+
+
+struct as10x_usb_token_cmd_t {
+	/* token cmd */
+	struct as10x_cmd_t c;
+	/* token response */
+	struct as10x_cmd_t r;
+};
+#endif
+/* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff -Nur linux.clean/drivers/staging/as102/as10x_cmd.c linux.as102_initial/drivers/staging/as102/as10x_cmd.c
--- linux.clean/drivers/staging/as102/as10x_cmd.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as10x_cmd.c	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,481 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller<dheitmueller@kernellabs.com>
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
+#if defined(LINUX)&&  defined(__KERNEL__) /* linux kernel implementation */
+#include<linux/kernel.h>
+#include "as102_drv.h"
+#elif defined(WIN32)
+   #if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
+      /* win32 ddk implementation */
+      #include "wdm.h"
+      #include "Device.h"
+      #include "endian_mgmt.h" /* FIXME */
+   #else /* win32 sdk implementation */
+      #include<windows.h>
+      #include "types.h"
+      #include "util.h"
+      #include "as10x_handle.h"
+      #include "endian_mgmt.h"
+   #endif
+#else /* all other cases */
+   #include<string.h>
+   #include "types.h"
+   #include "util.h"
+   #include "as10x_handle.h"
+   #include "endian_mgmt.h" /* FIXME */
+#endif /* __KERNEL__ */
+
+#include "as10x_types.h"
+#include "as10x_cmd.h"
+
+/**
+   \brief  send turn on command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \return 0 when no error,<  0 in case of error.
+  \callgraph
+*/
+int as10x_cmd_turn_on(as10x_handle_t *phandle)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.turn_on.req));
+
+	/* fill command */
+	pcmd->body.turn_on.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNON);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+					       sizeof(pcmd->body.turn_on.req) +
+					       HEADER_SIZE,
+					       (uint8_t *) prsp,
+					       sizeof(prsp->body.turn_on.rsp) +
+					       HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNON_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send turn off command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_turn_off(as10x_handle_t *phandle)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.turn_off.req));
+
+	/* fill command */
+	pcmd->body.turn_off.req.proc_id = cpu_to_le16(CONTROL_PROC_TURNOFF);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(
+			phandle, (uint8_t *) pcmd,
+			sizeof(pcmd->body.turn_off.req) + HEADER_SIZE,
+			(uint8_t *) prsp,
+			sizeof(prsp->body.turn_off.rsp) + HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_TURNOFF_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send set tune command to AS10x
+   \param  phandle: pointer to AS10x handle
+   \param  ptune:   tune parameters
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+ */
+int as10x_cmd_set_tune(as10x_handle_t *phandle, struct as10x_tune_args *ptune)
+{
+	int error;
+	struct as10x_cmd_t *preq, *prsp;
+
+	ENTER();
+
+	preq = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(preq, (++phandle->cmd_xid),
+			sizeof(preq->body.set_tune.req));
+
+	/* fill command */
+	preq->body.set_tune.req.proc_id = cpu_to_le16(CONTROL_PROC_SETTUNE);
+	preq->body.set_tune.req.args.freq = cpu_to_le32(ptune->freq);
+	preq->body.set_tune.req.args.bandwidth = ptune->bandwidth;
+	preq->body.set_tune.req.args.hier_select = ptune->hier_select;
+	preq->body.set_tune.req.args.constellation = ptune->constellation;
+	preq->body.set_tune.req.args.hierarchy = ptune->hierarchy;
+	preq->body.set_tune.req.args.interleaving_mode  =
+		ptune->interleaving_mode;
+	preq->body.set_tune.req.args.code_rate  = ptune->code_rate;
+	preq->body.set_tune.req.args.guard_interval = ptune->guard_interval;
+	preq->body.set_tune.req.args.transmission_mode  =
+		ptune->transmission_mode;
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+					       (uint8_t *) preq,
+					       sizeof(preq->body.set_tune.req)
+					       + HEADER_SIZE,
+					       (uint8_t *) prsp,
+					       sizeof(prsp->body.set_tune.rsp)
+					       + HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETTUNE_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send get tune status command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \param  pstatus:   pointer to updated status structure of the current tune
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+ */
+int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
+			      struct as10x_tune_status *pstatus)
+{
+	int error;
+	struct as10x_cmd_t  *preq, *prsp;
+
+	ENTER();
+
+	preq = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(preq, (++phandle->cmd_xid),
+			sizeof(preq->body.get_tune_status.req));
+
+	/* fill command */
+	preq->body.get_tune_status.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GETTUNESTAT);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(
+			phandle,
+			(uint8_t *) preq,
+			sizeof(preq->body.get_tune_status.req) + HEADER_SIZE,
+			(uint8_t *) prsp,
+			sizeof(prsp->body.get_tune_status.rsp) + HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTUNESTAT_RSP);
+	if (error<  0)
+		goto out;
+
+	/* Response OK ->  get response data */
+	pstatus->tune_state = prsp->body.get_tune_status.rsp.sts.tune_state;
+	pstatus->signal_strength  =
+		le16_to_cpu(prsp->body.get_tune_status.rsp.sts.signal_strength);
+	pstatus->PER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.PER);
+	pstatus->BER = le16_to_cpu(prsp->body.get_tune_status.rsp.sts.BER);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send get TPS command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \param  ptps:      pointer to TPS parameters structure
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+ */
+int as10x_cmd_get_tps(as10x_handle_t *phandle, struct as10x_tps *ptps)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.get_tps.req));
+
+	/* fill command */
+	pcmd->body.get_tune_status.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GETTPS);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+					       (uint8_t *) pcmd,
+					       sizeof(pcmd->body.get_tps.req) +
+					       HEADER_SIZE,
+					       (uint8_t *) prsp,
+					       sizeof(prsp->body.get_tps.rsp) +
+					       HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GETTPS_RSP);
+	if (error<  0)
+		goto out;
+
+	/* Response OK ->  get response data */
+	ptps->constellation = prsp->body.get_tps.rsp.tps.constellation;
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
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send get demod stats command to AS10x
+   \param  phandle:       pointer to AS10x handle
+   \param  pdemod_stats:  pointer to demod stats parameters structure
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
+			      struct as10x_demod_stats *pdemod_stats)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.get_demod_stats.req));
+
+	/* fill command */
+	pcmd->body.get_demod_stats.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GET_DEMOD_STATS);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+				(uint8_t *) pcmd,
+				sizeof(pcmd->body.get_demod_stats.req)
+				+ HEADER_SIZE,
+				(uint8_t *) prsp,
+				sizeof(prsp->body.get_demod_stats.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_DEMOD_STATS_RSP);
+	if (error<  0)
+		goto out;
+
+	/* Response OK ->  get response data */
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
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send get impulse response command to AS10x
+   \param  phandle:        pointer to AS10x handle
+   \param  is_ready:       pointer to value indicating when impulse
+			   response data is ready
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_get_impulse_resp(as10x_handle_t     *phandle,
+			       uint8_t *is_ready)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.get_impulse_rsp.req));
+
+	/* fill command */
+	pcmd->body.get_impulse_rsp.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_GET_IMPULSE_RESP);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle,
+					(uint8_t *) pcmd,
+					sizeof(pcmd->body.get_impulse_rsp.req)
+					+ HEADER_SIZE,
+					(uint8_t *) prsp,
+					sizeof(prsp->body.get_impulse_rsp.rsp)
+					+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_GET_IMPULSE_RESP_RSP);
+	if (error<  0)
+		goto out;
+
+	/* Response OK ->  get response data */
+	*is_ready = prsp->body.get_impulse_rsp.rsp.is_ready;
+
+out:
+	LEAVE();
+	return error;
+}
+
+
+
+/**
+   \brief  build AS10x command header
+   \param  pcmd:     pointer to AS10x command buffer
+   \param  xid:      sequence id of the command
+   \param  cmd_len:  lenght of the command
+   \return -
+   \callgraph
+*/
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
+   \brief  Parse command response
+   \param  pcmd:       pointer to AS10x command buffer
+   \param  cmd_seqid:  sequence id of the command
+   \param  cmd_len:    lenght of the command
+   \return 0 when no error,<  0 in case of error
+   \callgraph
+*/
+int as10x_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
+{
+	int error;
+
+	/* extract command error code */
+	error = prsp->body.common.rsp.error;
+
+	if ((error == 0)&&
+	    (le16_to_cpu(prsp->body.common.rsp.proc_id) == proc_id)) {
+		return 0;
+	}
+
+	return AS10X_CMD_ERROR;
+}
+
+
diff -Nur linux.clean/drivers/staging/as102/as10x_cmd_cfg.c linux.as102_initial/drivers/staging/as102/as10x_cmd_cfg.c
--- linux.clean/drivers/staging/as102/as10x_cmd_cfg.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as10x_cmd_cfg.c	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,238 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+#if defined(LINUX)&&  defined(__KERNEL__) /* linux kernel implementation */
+#include<linux/kernel.h>
+#include "as102_drv.h"
+#elif defined(WIN32)
+   #if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
+      /* win32 ddk implementation */
+      #include "wdm.h"
+      #include "Device.h"
+      #include "endian_mgmt.h" /* FIXME */
+   #else /* win32 sdk implementation */
+      #include<windows.h>
+      #include "types.h"
+      #include "util.h"
+      #include "as10x_handle.h"
+      #include "endian_mgmt.h"
+   #endif
+#else /* all other cases */
+   #include<string.h>
+   #include "types.h"
+   #include "util.h"
+   #include "as10x_handle.h"
+   #include "endian_mgmt.h" /* FIXME */
+#endif /* __KERNEL__ */
+
+#include "as10x_types.h"
+#include "as10x_cmd.h"
+
+/***************************/
+/* FUNCTION DEFINITION     */
+/***************************/
+
+/**
+   \brief  send get context command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \param  tag:       context tag
+   \param  pvalue:    pointer where to store context value read
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_get_context(as10x_handle_t *phandle, uint16_t tag,
+			  uint32_t *pvalue)
+{
+	int  error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.context.req));
+
+	/* fill command */
+	pcmd->body.context.req.proc_id = cpu_to_le16(CONTROL_PROC_CONTEXT);
+	pcmd->body.context.req.tag = cpu_to_le16(tag);
+	pcmd->body.context.req.type = cpu_to_le16(GET_CONTEXT_DATA);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error  = phandle->ops->xfer_cmd(phandle,
+						(uint8_t *) pcmd,
+						sizeof(pcmd->body.context.req)
+						+ HEADER_SIZE,
+						(uint8_t *) prsp,
+						sizeof(prsp->body.context.rsp)
+						+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response: context command do not follow the common response */
+	/* structure ->  specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+
+	if (error == 0) {
+		/* Response OK ->  get response data */
+		*pvalue = le32_to_cpu(prsp->body.context.rsp.reg_val.u.value32);
+		/* value returned is always a 32-bit value */
+	}
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send set context command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \param  tag:       context tag
+   \param  value:     value to set in context
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_set_context(as10x_handle_t *phandle, uint16_t tag,
+			  uint32_t value)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
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
+	if (phandle->ops->xfer_cmd) {
+		error  = phandle->ops->xfer_cmd(phandle,
+						(uint8_t *) pcmd,
+						sizeof(pcmd->body.context.req)
+						+ HEADER_SIZE,
+						(uint8_t *) prsp,
+						sizeof(prsp->body.context.rsp)
+						+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response: context command do not follow the common response */
+	/* structure ->  specific handling response parse required            */
+	error = as10x_context_rsp_parse(prsp, CONTROL_PROC_CONTEXT_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  send eLNA change mode command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \param  tag:       context tag
+   \param  mode:      mode selected:
+		     - ON    : 0x0 =>  eLNA always ON
+		     - OFF   : 0x1 =>  eLNA always OFF
+		     - AUTO  : 0x2 =>  eLNA follow hysteresis parameters to be
+				      ON or OFF
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.cfg_change_mode.req));
+
+	/* fill command */
+	pcmd->body.cfg_change_mode.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_ELNA_CHANGE_MODE);
+	pcmd->body.cfg_change_mode.req.mode = mode;
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error  = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.cfg_change_mode.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.cfg_change_mode.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_ELNA_CHANGE_MODE_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  Parse context command response. Since this command does not follow
+	   the common response, a specific parse function is required.
+   \param  prsp:       pointer to AS10x command response buffer
+   \param  proc_id:    id of the command
+   \return 0 when no error,<  0 in case of error.
+	   ABILIS_RC_NOK
+   \callgraph
+*/
+int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id)
+{
+	int err;
+
+	err = prsp->body.context.rsp.error;
+
+	if ((err == 0)&&
+	    (le16_to_cpu(prsp->body.context.rsp.proc_id) == proc_id)) {
+		return 0;
+	}
+	return AS10X_CMD_ERROR;
+}
diff -Nur linux.clean/drivers/staging/as102/as10x_cmd.h linux.as102_initial/drivers/staging/as102/as10x_cmd.h
--- linux.clean/drivers/staging/as102/as10x_cmd.h	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as10x_cmd.h	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,540 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+#include<linux/kernel.h>
+#endif
+
+#include "as10x_types.h"
+
+/*********************************/
+/*       MACRO DEFINITIONS       */
+/*********************************/
+#define AS10X_CMD_ERROR -1
+
+#define SERVICE_PROG_ID        0x0002
+#define SERVICE_PROG_VERSION   0x0001
+
+#define HIER_NONE              0x00
+#define HIER_LOW_PRIORITY      0x01
+
+#define HEADER_SIZE (sizeof(struct as10x_cmd_header_t))
+
+/* context request types */
+#define GET_CONTEXT_DATA        1
+#define SET_CONTEXT_DATA        2
+
+/* ODSP suspend modes */
+#define CFG_MODE_ODSP_RESUME  0
+#define CFG_MODE_ODSP_SUSPEND 1
+
+/* Dump memory size */
+#define DUMP_BLOCK_SIZE_MAX   0x20
+
+/*********************************/
+/*     TYPE DEFINITION           */
+/*********************************/
+typedef enum {
+   CONTROL_PROC_TURNON               = 0x0001,
+   CONTROL_PROC_TURNON_RSP           = 0x0100,
+   CONTROL_PROC_SET_REGISTER         = 0x0002,
+   CONTROL_PROC_SET_REGISTER_RSP     = 0x0200,
+   CONTROL_PROC_GET_REGISTER         = 0x0003,
+   CONTROL_PROC_GET_REGISTER_RSP     = 0x0300,
+   CONTROL_PROC_SETTUNE              = 0x000A,
+   CONTROL_PROC_SETTUNE_RSP          = 0x0A00,
+   CONTROL_PROC_GETTUNESTAT          = 0x000B,
+   CONTROL_PROC_GETTUNESTAT_RSP      = 0x0B00,
+   CONTROL_PROC_GETTPS               = 0x000D,
+   CONTROL_PROC_GETTPS_RSP           = 0x0D00,
+   CONTROL_PROC_SETFILTER            = 0x000E,
+   CONTROL_PROC_SETFILTER_RSP        = 0x0E00,
+   CONTROL_PROC_REMOVEFILTER         = 0x000F,
+   CONTROL_PROC_REMOVEFILTER_RSP     = 0x0F00,
+   CONTROL_PROC_GET_IMPULSE_RESP     = 0x0012,
+   CONTROL_PROC_GET_IMPULSE_RESP_RSP = 0x1200,
+   CONTROL_PROC_START_STREAMING      = 0x0013,
+   CONTROL_PROC_START_STREAMING_RSP  = 0x1300,
+   CONTROL_PROC_STOP_STREAMING       = 0x0014,
+   CONTROL_PROC_STOP_STREAMING_RSP   = 0x1400,
+   CONTROL_PROC_GET_DEMOD_STATS      = 0x0015,
+   CONTROL_PROC_GET_DEMOD_STATS_RSP  = 0x1500,
+   CONTROL_PROC_ELNA_CHANGE_MODE     = 0x0016,
+   CONTROL_PROC_ELNA_CHANGE_MODE_RSP = 0x1600,
+   CONTROL_PROC_ODSP_CHANGE_MODE     = 0x0017,
+   CONTROL_PROC_ODSP_CHANGE_MODE_RSP = 0x1700,
+   CONTROL_PROC_AGC_CHANGE_MODE      = 0x0018,
+   CONTROL_PROC_AGC_CHANGE_MODE_RSP  = 0x1800,
+
+   CONTROL_PROC_CONTEXT              = 0x00FC,
+   CONTROL_PROC_CONTEXT_RSP          = 0xFC00,
+   CONTROL_PROC_DUMP_MEMORY          = 0x00FD,
+   CONTROL_PROC_DUMP_MEMORY_RSP      = 0xFD00,
+   CONTROL_PROC_DUMPLOG_MEMORY       = 0x00FE,
+   CONTROL_PROC_DUMPLOG_MEMORY_RSP   = 0xFE00,
+   CONTROL_PROC_TURNOFF              = 0x00FF,
+   CONTROL_PROC_TURNOFF_RSP          = 0xFF00
+} control_proc;
+
+
+#pragma pack(1)
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+   } rsp;
+} TURN_ON;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t err;
+   } rsp;
+} TURN_OFF;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+      /* tune params */
+      struct as10x_tune_args args;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* response error */
+      uint8_t error;
+   } rsp;
+} SET_TUNE;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* response error */
+      uint8_t error;
+      /* tune status */
+      struct as10x_tune_status sts;
+   } rsp;
+} GET_TUNE_STATUS;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* response error */
+      uint8_t error;
+      /* tps details */
+      struct as10x_tps tps;
+   } rsp;
+} GET_TPS;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t  proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* response error */
+      uint8_t error;
+   } rsp;
+} COMMON;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t  proc_id;
+      /* PID to filter */
+      uint16_t  pid;
+      /* stream type (MPE, PSI/SI or PES )*/
+      uint8_t stream_type;
+      /* PID index in filter table */
+      uint8_t idx;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* response error */
+      uint8_t error;
+      /* Filter id */
+      uint8_t filter_id;
+   } rsp;
+} ADD_PID_FILTER;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t  proc_id;
+      /* PID to remove */
+      uint16_t  pid;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* response error */
+      uint8_t error;
+   } rsp;
+} DEL_PID_FILTER;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+   } rsp;
+} START_STREAMING;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+   } rsp;
+} STOP_STREAMING;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+      /* demod stats */
+      struct as10x_demod_stats stats;
+   } rsp;
+} GET_DEMOD_STATS;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+      /* impulse response ready */
+      uint8_t is_ready;
+   } rsp;
+} GET_IMPULSE_RESP;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+      /* value to write (for set context)*/
+      struct as10x_register_value reg_val;
+      /* context tag */
+      uint16_t tag;
+      /* context request type */
+      uint16_t type;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* value read (for get context) */
+      struct as10x_register_value reg_val;
+      /* context request type */
+      uint16_t type;
+      /* error */
+      uint8_t error;
+   } rsp;
+} FW_CONTEXT;
+
+typedef union {
+   /* request */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* register description */
+      struct as10x_register_addr reg_addr;
+      /* register content */
+      struct as10x_register_value reg_val;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+   } rsp;
+} SET_REGISTER;
+
+typedef union {
+   /* request */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* register description */
+      struct as10x_register_addr reg_addr;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+      /* register content */
+      struct as10x_register_value reg_val;
+   } rsp;
+} GET_REGISTER;
+
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+      /* mode */
+      uint8_t mode;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+   } rsp;
+} CFG_CHANGE_MODE;
+
+struct as10x_cmd_header_t {
+   uint16_t req_id;
+   uint16_t prog;
+   uint16_t version;
+   uint16_t data_len;
+};
+
+#define DUMP_BLOCK_SIZE 16
+typedef union {
+   /* request */
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+      /* dump memory type request */
+      uint8_t dump_req;
+      /* register description */
+      struct as10x_register_addr reg_addr;
+      /* nb blocks to read */
+      uint16_t num_blocks;
+   } req;
+   /* response */
+   struct {
+      /* response identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+      /* dump response */
+      uint8_t dump_rsp;
+      /* data */
+      union {
+	 uint8_t  data8[DUMP_BLOCK_SIZE];
+	 uint16_t data16[DUMP_BLOCK_SIZE / sizeof(uint16_t)];
+	 uint32_t data32[DUMP_BLOCK_SIZE / sizeof(uint32_t)];
+      } u;
+   } rsp;
+} DUMP_MEMORY;
+
+typedef union {
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+      /* dump memory type request */
+      uint8_t dump_req;
+   } req;
+   struct {
+      /* request identifier */
+      uint16_t proc_id;
+      /* error */
+      uint8_t error;
+      /* dump response */
+      uint8_t dump_rsp;
+      /* dump data */
+      uint8_t data[DUMP_BLOCK_SIZE];
+   } rsp;
+} DUMPLOG_MEMORY;
+
+typedef union {
+   /* request */
+   struct {
+      uint16_t proc_id;
+      uint8_t data[64 - sizeof(struct as10x_cmd_header_t) -2 /* proc_id */];
+   } req;
+   /* response */
+   struct {
+      uint16_t proc_id;
+      uint8_t error;
+      uint8_t data[64 - sizeof(struct as10x_cmd_header_t) /* header */
+		      - 2 /* proc_id */ - 1 /* rc */];
+   } rsp;
+} RAW_DATA;
+
+struct as10x_cmd_t {
+   /* header */
+   struct as10x_cmd_header_t header;
+   /* body */
+   union {
+      TURN_ON           turn_on;
+      TURN_OFF          turn_off;
+      SET_TUNE          set_tune;
+      GET_TUNE_STATUS   get_tune_status;
+      GET_TPS           get_tps;
+      COMMON            common;
+      ADD_PID_FILTER    add_pid_filter;
+      DEL_PID_FILTER    del_pid_filter;
+      START_STREAMING   start_streaming;
+      STOP_STREAMING    stop_streaming;
+      GET_DEMOD_STATS   get_demod_stats;
+      GET_IMPULSE_RESP  get_impulse_rsp;
+      FW_CONTEXT        context;
+      SET_REGISTER      set_register;
+      GET_REGISTER      get_register;
+      CFG_CHANGE_MODE   cfg_change_mode;
+      DUMP_MEMORY       dump_memory;
+      DUMPLOG_MEMORY    dumplog_memory;
+      RAW_DATA          raw_data;
+   } body;
+};
+
+struct as10x_token_cmd_t {
+   /* token cmd */
+   struct as10x_cmd_t c;
+   /* token response */
+   struct as10x_cmd_t r;
+};
+#pragma pack()
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
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/* as10x cmd */
+int as10x_cmd_turn_on(as10x_handle_t *phandle);
+int as10x_cmd_turn_off(as10x_handle_t *phandle);
+
+int as10x_cmd_set_tune(as10x_handle_t *phandle,
+		       struct as10x_tune_args *ptune);
+
+int as10x_cmd_get_tune_status(as10x_handle_t *phandle,
+			      struct as10x_tune_status *pstatus);
+
+int as10x_cmd_get_tps(as10x_handle_t *phandle,
+		      struct as10x_tps *ptps);
+
+int as10x_cmd_get_demod_stats(as10x_handle_t  *phandle,
+			      struct as10x_demod_stats *pdemod_stats);
+
+int as10x_cmd_get_impulse_resp(as10x_handle_t *phandle,
+			       uint8_t *is_ready);
+
+/* as10x cmd stream */
+int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
+			     struct as10x_ts_filter *filter);
+int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
+			     uint16_t pid_value);
+
+int as10x_cmd_start_streaming(as10x_handle_t *phandle);
+int as10x_cmd_stop_streaming(as10x_handle_t *phandle);
+
+/* as10x cmd cfg */
+int as10x_cmd_set_context(as10x_handle_t *phandle,
+			  uint16_t tag,
+			  uint32_t value);
+int as10x_cmd_get_context(as10x_handle_t *phandle,
+			  uint16_t tag,
+			  uint32_t *pvalue);
+
+int as10x_cmd_eLNA_change_mode(as10x_handle_t *phandle, uint8_t mode);
+int as10x_context_rsp_parse(struct as10x_cmd_t *prsp, uint16_t proc_id);
+#ifdef __cplusplus
+}
+#endif
+#endif
+/* EOF - vim: set textwidth=80 ts=3 sw=3 sts=3 et: */
diff -Nur linux.clean/drivers/staging/as102/as10x_cmd_stream.c linux.as102_initial/drivers/staging/as102/as10x_cmd_stream.c
--- linux.clean/drivers/staging/as102/as10x_cmd_stream.c	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as10x_cmd_stream.c	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,247 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+#if defined(LINUX)&&  defined(__KERNEL__) /* linux kernel implementation */
+#include<linux/kernel.h>
+#include "as102_drv.h"
+#elif defined(WIN32)
+    #if defined(DDK) /* win32 ddk implementation */
+	#include "wdm.h"
+	#include "Device.h"
+	#include "endian_mgmt.h" /* FIXME */
+    #else /* win32 sdk implementation */
+	#include<windows.h>
+	#include "types.h"
+	#include "util.h"
+	#include "as10x_handle.h"
+	#include "endian_mgmt.h"
+    #endif
+#else /* all other cases */
+    #include<string.h>
+    #include "types.h"
+    #include "util.h"
+    #include "as10x_handle.h"
+    #include "endian_mgmt.h" /* FIXME */
+#endif /* __KERNEL__ */
+
+#include "as10x_cmd.h"
+
+
+/**
+   \brief  send add filter command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \param  filter:    TSFilter filter for DVB-T
+   \param  pfilter_handle: pointer where to store filter handle
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_add_PID_filter(as10x_handle_t *phandle,
+			     struct as10x_ts_filter *filter)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.add_pid_filter.req));
+
+	/* fill command */
+	pcmd->body.add_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_SETFILTER);
+	pcmd->body.add_pid_filter.req.pid = cpu_to_le16(filter->pid);
+	pcmd->body.add_pid_filter.req.stream_type = filter->type;
+
+	if (filter->idx<  16)
+		pcmd->body.add_pid_filter.req.idx = filter->idx;
+	else
+		pcmd->body.add_pid_filter.req.idx = 0xFF;
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.add_pid_filter.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.add_pid_filter.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_SETFILTER_RSP);
+
+	if (error == 0) {
+		/* Response OK ->  get response data */
+		filter->idx = prsp->body.add_pid_filter.rsp.filter_id;
+	}
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief  Send delete filter command to AS10x
+   \param  phandle:       pointer to AS10x handle
+   \param  filter_handle: filter handle
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_del_PID_filter(as10x_handle_t *phandle,
+			     uint16_t pid_value)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.del_pid_filter.req));
+
+	/* fill command */
+	pcmd->body.del_pid_filter.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_REMOVEFILTER);
+	pcmd->body.del_pid_filter.req.pid = cpu_to_le16(pid_value);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.del_pid_filter.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.del_pid_filter.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_REMOVEFILTER_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief Send start streaming command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_start_streaming(as10x_handle_t *phandle)
+{
+	int error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.start_streaming.req));
+
+	/* fill command */
+	pcmd->body.start_streaming.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_START_STREAMING);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.start_streaming.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.start_streaming.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_START_STREAMING_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+/**
+   \brief Send stop streaming command to AS10x
+   \param  phandle:   pointer to AS10x handle
+   \return 0 when no error,<  0 in case of error.
+   \callgraph
+*/
+int as10x_cmd_stop_streaming(as10x_handle_t *phandle)
+{
+	int8_t error;
+	struct as10x_cmd_t *pcmd, *prsp;
+
+	ENTER();
+
+	pcmd = phandle->cmd;
+	prsp = phandle->rsp;
+
+	/* prepare command */
+	as10x_cmd_build(pcmd, (++phandle->cmd_xid),
+			sizeof(pcmd->body.stop_streaming.req));
+
+	/* fill command */
+	pcmd->body.stop_streaming.req.proc_id =
+		cpu_to_le16(CONTROL_PROC_STOP_STREAMING);
+
+	/* send command */
+	if (phandle->ops->xfer_cmd) {
+		error = phandle->ops->xfer_cmd(phandle, (uint8_t *) pcmd,
+				sizeof(pcmd->body.stop_streaming.req)
+				+ HEADER_SIZE, (uint8_t *) prsp,
+				sizeof(prsp->body.stop_streaming.rsp)
+				+ HEADER_SIZE);
+	} else {
+		error = AS10X_CMD_ERROR;
+	}
+
+	if (error<  0)
+		goto out;
+
+	/* parse response */
+	error = as10x_rsp_parse(prsp, CONTROL_PROC_STOP_STREAMING_RSP);
+
+out:
+	LEAVE();
+	return error;
+}
+
+
diff -Nur linux.clean/drivers/staging/as102/as10x_handle.h linux.as102_initial/drivers/staging/as102/as10x_handle.h
--- linux.clean/drivers/staging/as102/as10x_handle.h	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as10x_handle.h	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,58 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+struct as102_bus_adapter_t;
+struct as102_dev_t;
+
+#define as10x_handle_t struct as102_bus_adapter_t
+#include "as10x_cmd.h"
+
+/* values for "mode" field */
+#define REGMODE8         8
+#define REGMODE16        16
+#define REGMODE32        32
+
+struct as102_priv_ops_t {
+	int (*upload_fw_pkt) (struct as102_bus_adapter_t *bus_adap,
+			      unsigned char *buf, int buflen, int swap32);
+
+	int (*send_cmd) (struct as102_bus_adapter_t *bus_adap,
+			 unsigned char *buf, int buflen);
+
+	int (*xfer_cmd) (struct as102_bus_adapter_t *bus_adap,
+			 unsigned char *send_buf, int send_buf_len,
+			 unsigned char *recv_buf, int recv_buf_len);
+/*
+	int (*pid_filter) (struct as102_bus_adapter_t *bus_adap,
+			   int index, u16 pid, int onoff);
+*/
+	int (*start_stream) (struct as102_dev_t *dev);
+	void (*stop_stream) (struct as102_dev_t *dev);
+
+	int (*reset_target) (struct as102_bus_adapter_t *bus_adap);
+
+	int (*read_write)(struct as102_bus_adapter_t *bus_adap, uint8_t mode,
+			  uint32_t rd_addr, uint16_t rd_len,
+			  uint32_t wr_addr, uint16_t wr_len);
+
+	int (*as102_read_ep2) (struct as102_bus_adapter_t *bus_adap,
+			       unsigned char *recv_buf,
+			       int recv_buf_len);
+};
+#endif
diff -Nur linux.clean/drivers/staging/as102/as10x_types.h linux.as102_initial/drivers/staging/as102/as10x_types.h
--- linux.clean/drivers/staging/as102/as10x_types.h	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/as10x_types.h	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,198 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet<pierrick.hascoet@abilis.com>
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
+#define BW_5_MHZ           0x00
+#define BW_6_MHZ           0x01
+#define BW_7_MHZ           0x02
+#define BW_8_MHZ           0x03
+
+/* hierarchy priority selection values */
+#define HIER_NO_PRIORITY   0x00
+#define HIER_LOW_PRIORITY  0x01
+#define HIER_HIGH_PRIORITY 0x02
+
+/* constellation available values */
+#define CONST_QPSK         0x00
+#define CONST_QAM16        0x01
+#define CONST_QAM64        0x02
+#define CONST_UNKNOWN      0xFF
+
+/* hierarchy available values */
+#define HIER_NONE         0x00
+#define HIER_ALPHA_1      0x01
+#define HIER_ALPHA_2      0x02
+#define HIER_ALPHA_4      0x03
+#define HIER_UNKNOWN      0xFF
+
+/* interleaving available values */
+#define INTLV_NATIVE      0x00
+#define INTLV_IN_DEPTH    0x01
+#define INTLV_UNKNOWN     0xFF
+
+/* code rate available values */
+#define CODE_RATE_1_2     0x00
+#define CODE_RATE_2_3     0x01
+#define CODE_RATE_3_4     0x02
+#define CODE_RATE_5_6     0x03
+#define CODE_RATE_7_8     0x04
+#define CODE_RATE_UNKNOWN 0xFF
+
+/* guard interval available values */
+#define GUARD_INT_1_32    0x00
+#define GUARD_INT_1_16    0x01
+#define GUARD_INT_1_8     0x02
+#define GUARD_INT_1_4     0x03
+#define GUARD_UNKNOWN     0xFF
+
+/* transmission mode available values */
+#define TRANS_MODE_2K      0x00
+#define TRANS_MODE_8K      0x01
+#define TRANS_MODE_4K      0x02
+#define TRANS_MODE_UNKNOWN 0xFF
+
+/* DVBH signalling available values */
+#define TIMESLICING_PRESENT   0x01
+#define MPE_FEC_PRESENT       0x02
+
+/* tune state available */
+#define TUNE_STATUS_NOT_TUNED       0x00
+#define TUNE_STATUS_IDLE            0x01
+#define TUNE_STATUS_LOCKING         0x02
+#define TUNE_STATUS_SIGNAL_DVB_OK   0x03
+#define TUNE_STATUS_STREAM_DETECTED 0x04
+#define TUNE_STATUS_STREAM_TUNED    0x05
+#define TUNE_STATUS_ERROR           0xFF
+
+/* available TS FID filter types */
+#define TS_PID_TYPE_TS       0
+#define TS_PID_TYPE_PSI_SI   1
+#define TS_PID_TYPE_MPE      2
+
+/* number of echos available */
+#define MAX_ECHOS   15
+
+/* Context types */
+#define CONTEXT_LNA                   1010
+#define CONTEXT_ELNA_HYSTERESIS       4003
+#define CONTEXT_ELNA_GAIN             4004
+#define CONTEXT_MER_THRESHOLD         5005
+#define CONTEXT_MER_OFFSET            5006
+#define CONTEXT_IR_STATE              7000
+#define CONTEXT_TSOUT_MSB_FIRST       7004
+#define CONTEXT_TSOUT_FALLING_EDGE    7005
+
+/* Configuration modes */
+#define CFG_MODE_ON     0
+#define CFG_MODE_OFF    1
+#define CFG_MODE_AUTO   2
+
+#pragma pack(1)
+struct as10x_tps {
+   uint8_t constellation;
+   uint8_t hierarchy;
+   uint8_t interleaving_mode;
+   uint8_t code_rate_HP;
+   uint8_t code_rate_LP;
+   uint8_t guard_interval;
+   uint8_t transmission_mode;
+   uint8_t DVBH_mask_HP;
+   uint8_t DVBH_mask_LP;
+   uint16_t cell_ID;
+};
+
+struct as10x_tune_args {
+   /* frequency */
+   uint32_t freq;
+   /* bandwidth */
+   uint8_t bandwidth;
+   /* hierarchy selection */
+   uint8_t hier_select;
+   /* constellation */
+   uint8_t constellation;
+   /* hierarchy */
+   uint8_t hierarchy;
+   /* interleaving mode */
+   uint8_t interleaving_mode;
+   /* code rate */
+   uint8_t code_rate;
+   /* guard interval */
+   uint8_t guard_interval;
+   /* transmission mode */
+   uint8_t transmission_mode;
+};
+
+struct as10x_tune_status {
+   /* tune status */
+   uint8_t tune_state;
+   /* signal strength */
+   int16_t signal_strength;
+   /* packet error rate 10^-4 */
+   uint16_t PER;
+   /* bit error rate 10^-4 */
+   uint16_t BER;
+};
+
+struct as10x_demod_stats {
+   /* frame counter */
+   uint32_t frame_count;
+   /* Bad frame counter */
+   uint32_t bad_frame_count;
+   /* Number of wrong bytes fixed by Reed-Solomon */
+   uint32_t bytes_fixed_by_rs;
+   /* Averaged MER */
+   uint16_t mer;
+   /* statistics calculation state indicator (started or not) */
+   uint8_t has_started;
+};
+
+struct as10x_ts_filter {
+   uint16_t pid;  /** valid PID value 0x00 : 0x2000 */
+   uint8_t  type; /** Red TS_PID_TYPE_<N>  values */
+   uint8_t  idx;  /** index in filtering table */
+};
+
+struct as10x_register_value {
+   uint8_t       mode;
+   union {
+      uint8_t    value8;    /* 8 bit value */
+      uint16_t   value16;   /* 16 bit value */
+      uint32_t   value32;   /* 32 bit value */
+   }u;
+};
+
+#pragma pack()
+
+struct as10x_register_addr {
+   /* register addr */
+   uint32_t addr;
+   /* register mode access */
+   uint8_t mode;
+};
+
+
+#endif
diff -Nur linux.clean/drivers/staging/as102/Kconfig linux.as102_initial/drivers/staging/as102/Kconfig
--- linux.clean/drivers/staging/as102/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/Kconfig	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,7 @@
+config DVB_AS102
+	tristate "Abilis AS102 DVB receiver"
+	depends on DVB_CORE&&  USB&&  I2C&&  INPUT
+	help
+	  Choose Y or M here if you have a device containing an AS102
+
+	  To compile this driver as a module, choose M here
diff -Nur linux.clean/drivers/staging/as102/Makefile linux.as102_initial/drivers/staging/as102/Makefile
--- linux.clean/drivers/staging/as102/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux.as102_initial/drivers/staging/as102/Makefile	2011-10-14 17:55:02.000000000 +0200
@@ -0,0 +1,5 @@
+dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
+
+obj-$(CONFIG_DVB_AS102) += dvb-as102.o
+
+EXTRA_CFLAGS += -DLINUX -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core
diff -Nur linux.clean/drivers/staging/Kconfig linux.as102_initial/drivers/staging/Kconfig
--- linux.clean/drivers/staging/Kconfig	2011-10-14 15:26:42.000000000 +0200
+++ linux.as102_initial/drivers/staging/Kconfig	2011-10-14 17:21:08.000000000 +0200
@@ -150,4 +150,6 @@

  source "drivers/staging/nvec/Kconfig"

+source "drivers/staging/as102/Kconfig"
+
  endif # STAGING
diff -Nur linux.clean/drivers/staging/Makefile linux.as102_initial/drivers/staging/Makefile
--- linux.clean/drivers/staging/Makefile	2011-10-14 15:26:42.000000000 +0200
+++ linux.as102_initial/drivers/staging/Makefile	2011-10-14 17:33:29.000000000 +0200
@@ -66,3 +66,4 @@
  obj-$(CONFIG_DRM_PSB)		+= gma500/
  obj-$(CONFIG_INTEL_MEI)		+= mei/
  obj-$(CONFIG_MFD_NVEC)		+= nvec/
+obj-$(CONFIG_DVB_AS102)		+= as102/



