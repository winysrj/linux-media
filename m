Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58312 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0BXEjd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 23:39:33 -0500
Received: from [192.168.1.2] (01-180.155.popsite.net [66.217.131.180])
	(authenticated bits=0)
	by mail1.radix.net (8.13.4/8.13.4) with ESMTP id o1O4dSwu000547
	for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 23:39:29 -0500 (EST)
Subject: [PATCH v1] dvb_dummy_adapter
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 23 Feb 2010 23:38:38 -0500
Message-Id: <1266986318.3093.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements a dvb_dummy_adapter module capable of creating up
to DVB_MAX_ADAPTERS software DVB adapters.  It's probably not much good
except for testing applications.  It works with femon.  I have not
tested writing to the dvr0 device and reading back yet.

One can instantiate adapeters with different dummy frontends:

# modprobe dvb_dummy_adapter debug=1 fe_type=0,1,2,1

Will yield 4 adapters with dummy DVB-C, DVB-T, DVB-S, and DVB-T
frontends.

Since I stole a good bit of this from the dvb portion of the cx18
driver, I suspect I have too many items set up the device
initialization.

Comments welcome.

Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 9d3b80c9f15a linux/drivers/media/dvb/Kconfig
--- a/linux/drivers/media/dvb/Kconfig	Thu Feb 18 20:56:08 2010 -0200
+++ b/linux/drivers/media/dvb/Kconfig	Tue Feb 23 23:21:23 2010 -0500
@@ -80,6 +80,10 @@
 	depends on DVB_CORE && PCI && I2C
 	source "drivers/media/dvb/ngene/Kconfig"
 
+comment "Supported Dummy DVB Adapters"
+	depends on DVB_CORE
+	source "drivers/media/dvb/dummy/Kconfig"
+
 comment "Supported DVB Frontends"
 	depends on DVB_CORE
 source "drivers/media/dvb/frontends/Kconfig"
diff -r 9d3b80c9f15a linux/drivers/media/dvb/Makefile
--- a/linux/drivers/media/dvb/Makefile	Thu Feb 18 20:56:08 2010 -0200
+++ b/linux/drivers/media/dvb/Makefile	Tue Feb 23 23:21:23 2010 -0500
@@ -15,6 +15,7 @@
 		dm1105/		\
 		pt1/		\
 		mantis/		\
-		ngene/
+		ngene/		\
+		dummy/
 
 obj-$(CONFIG_DVB_FIREDTV)	+= firewire/
diff -r 9d3b80c9f15a linux/drivers/media/dvb/dummy/Kconfig
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dummy/Kconfig	Tue Feb 23 23:21:23 2010 -0500
@@ -0,0 +1,10 @@
+config DVB_DUMMY_ADAPTER
+	tristate "Dummy DVB adapter driver"
+	depends on DVB_CORE
+	select DVB_DUMMY_FE if !DVB_FE_CUSTOMISE
+	default n
+	help
+	  A software only dummy DVB adapter driver.  Possibly useful for
+	  application test and development without using actual DVB hardware.
+
+	  Most people will want to say N for this driver.
diff -r 9d3b80c9f15a linux/drivers/media/dvb/dummy/Makefile
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dummy/Makefile	Tue Feb 23 23:21:23 2010 -0500
@@ -0,0 +1,3 @@
+obj-$(CONFIG_DVB_DUMMY_ADAPTER) += dvb_dummy_adapter.o
+
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
diff -r 9d3b80c9f15a linux/drivers/media/dvb/dummy/dvb_dummy_adapter.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/dummy/dvb_dummy_adapter.c	Tue Feb 23 23:21:23 2010 -0500
@@ -0,0 +1,364 @@
+/*
+ *  Dummy DVB adapter driver
+ *
+ *  Copyright (C) 2010 Andy Walls <awalls@radix.net>
+ *
+ *  Partially based on cx18-dvb.c driver code
+ *  Copyright (C) 2008 Steve Toth <stoth@kernellabs.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+
+#include <linux/platform_device.h>
+
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+#include "dvbdev.h"
+#include "dmxdev.h"
+#include "dvb_dummy_fe.h"
+
+MODULE_AUTHOR("Andy Walls");
+MODULE_DESCRIPTION("Dummy DVB adapter driver");
+MODULE_LICENSE("GPL");
+#define DVB_DUMMY_VERSION "0:0.1"
+MODULE_VERSION(DVB_DUMMY_VERSION);
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static int debug;
+
+static int fe_type[DVB_MAX_ADAPTERS];
+static unsigned int fe_type_c = 1;
+
+module_param(debug, int, 0644);
+module_param_array(fe_type, int, &fe_type_c, 0644);
+
+MODULE_PARM_DESC(debug, "Debug level. Default: 0");
+MODULE_PARM_DESC(fe_type, "Frontend type\n"
+			  "\t\t\t0: DVB-C\n"
+			  "\t\t\t1: DVB-T\n"
+			  "\t\t\t2: DVB-S\n"
+			  "\t\t\tDefault: 0: DVB-C");
+
+struct dvb_dummy {
+	struct platform_device *plat_dev;
+	int instance;
+
+	struct dmx_frontend hw_frontend;
+	struct dmx_frontend mem_frontend;
+	struct dmxdev dmxdev;
+	struct dvb_adapter dvb_adapter;
+	struct dvb_demux demux;
+	struct dvb_frontend *fe;
+	struct dvb_net dvbnet;
+
+	int feeding;
+	struct mutex feedlock; /* protects feeding variable */
+};
+
+static int dvb_dummy_start_feed(struct dvb_demux_feed *feed)
+{
+	struct dvb_demux *demux = feed->demux;
+	struct dvb_dummy *dummy = (struct dvb_dummy *) demux->priv;
+
+	if (dummy == NULL)
+		return -EINVAL;
+
+	if (debug)
+		printk(KERN_INFO "dvb_dummy_adapter%d: "
+		       "Start feed: pid = 0x%x index = %d\n",
+		       dummy->instance, feed->pid, feed->index);
+
+	if (!demux->dmx.frontend)
+		return -EINVAL;
+
+	mutex_lock(&dummy->feedlock);
+	if (dummy->feeding++ == 0 && debug)
+		printk(KERN_INFO
+		       "dvb_dummy_adapter%d: Starting transport\n",
+		       dummy->instance);
+	mutex_unlock(&dummy->feedlock);
+	return 0;
+}
+
+static int dvb_dummy_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct dvb_demux *demux = feed->demux;
+	struct dvb_dummy *dummy = (struct dvb_dummy *) demux->priv;
+
+	if (dummy == NULL)
+		return -EINVAL;
+
+	if (debug)
+		printk(KERN_INFO "dvb_dummy_adapter%d: "
+		       "Stop feed: pid = 0x%x index = %d\n",
+		       dummy->instance, feed->pid, feed->index);
+
+	mutex_lock(&dummy->feedlock);
+	if (--dummy->feeding == 0 && debug)
+		printk(KERN_INFO
+		       "dvb_dummy_adapter%d: Stopping transport\n",
+		       dummy->instance);
+	mutex_unlock(&dummy->feedlock);
+
+	return 0;
+}
+
+static int __devinit dvb_dummy_register(struct dvb_dummy *dummy)
+{
+	struct dvb_adapter *dvb_adapter;
+	struct dvb_demux *dvbdemux;
+	struct dmx_demux *dmx;
+	int ret;
+
+	ret = dvb_register_adapter(&dummy->dvb_adapter, "dvb_dummy_adapter",
+				   THIS_MODULE, &dummy->plat_dev->dev,
+				   adapter_nr);
+	if (ret < 0)
+		goto err_out;
+
+	dvb_adapter = &dummy->dvb_adapter;
+
+	dvbdemux = &dummy->demux;
+
+	dvbdemux->priv = (void *) dummy;
+
+	dvbdemux->filternum = 256;
+	dvbdemux->feednum = 256;
+	dvbdemux->start_feed = dvb_dummy_start_feed;
+	dvbdemux->stop_feed = dvb_dummy_stop_feed;
+	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
+		DMX_SECTION_FILTERING | DMX_MEMORY_BASED_FILTERING);
+	ret = dvb_dmx_init(dvbdemux);
+	if (ret < 0)
+		goto err_dvb_unregister_adapter;
+
+	dmx = &dvbdemux->dmx;
+
+	dummy->hw_frontend.source = DMX_FRONTEND_0;
+	dummy->mem_frontend.source = DMX_MEMORY_FE;
+	dummy->dmxdev.filternum = 256;
+	dummy->dmxdev.demux = dmx;
+
+	ret = dvb_dmxdev_init(&dummy->dmxdev, dvb_adapter);
+	if (ret < 0)
+		goto err_dvb_dmx_release;
+
+	ret = dmx->add_frontend(dmx, &dummy->hw_frontend);
+	if (ret < 0)
+		goto err_dvb_dmxdev_release;
+
+	ret = dmx->add_frontend(dmx, &dummy->mem_frontend);
+	if (ret < 0)
+		goto err_remove_hw_frontend;
+
+	ret = dmx->connect_frontend(dmx, &dummy->hw_frontend);
+	if (ret < 0)
+		goto err_remove_mem_frontend;
+
+	switch (fe_type[dummy->instance]) {
+	case 1:
+		dummy->fe = dvb_attach(dvb_dummy_fe_ofdm_attach);
+		break;
+	case 2:
+		dummy->fe = dvb_attach(dvb_dummy_fe_qpsk_attach);
+		break;
+	default:
+		dummy->fe = dvb_attach(dvb_dummy_fe_qam_attach);
+		break;
+	}
+	ret = (dummy->fe == NULL) ? -1 : 0;
+	if (ret < 0)
+		goto err_disconnect_frontend;
+
+	ret = dvb_register_frontend(dvb_adapter, dummy->fe);
+	if (ret < 0)
+		goto err_release_frontend;
+
+	dvb_net_init(dvb_adapter, &dummy->dvbnet, dmx);
+
+	printk(KERN_INFO "dvb_dummy_adapter%d: DVB Frontend registered\n",
+	       dummy->instance);
+	printk(KERN_INFO "dvb_dummy_adapter%d: Registered DVB adapter%d\n",
+	       dummy->instance, dummy->dvb_adapter.num);
+
+	mutex_init(&dummy->feedlock);
+	return ret;
+
+err_release_frontend:
+	if (dummy->fe->ops.release)
+		dummy->fe->ops.release(dummy->fe);
+err_disconnect_frontend:
+	dmx->disconnect_frontend(dmx);
+err_remove_mem_frontend:
+	dmx->remove_frontend(dmx, &dummy->mem_frontend);
+err_remove_hw_frontend:
+	dmx->remove_frontend(dmx, &dummy->hw_frontend);
+err_dvb_dmxdev_release:
+	dvb_dmxdev_release(&dummy->dmxdev);
+err_dvb_dmx_release:
+	dvb_dmx_release(dvbdemux);
+err_dvb_unregister_adapter:
+	dvbdemux->priv = NULL;
+	dvb_unregister_adapter(dvb_adapter);
+err_out:
+	return ret;
+}
+
+static void dvb_dummy_unregister(struct dvb_dummy *dummy)
+{
+	struct dvb_adapter *dvb_adapter;
+	struct dvb_demux *dvbdemux;
+	struct dmx_demux *dmx;
+
+	printk(KERN_INFO "dvb_dummy_adapter%d: DVB Frontend unegister\n",
+	       dummy->instance);
+	printk(KERN_INFO "dvb_dummy_adapter%d: Unregister DVB adapter%d\n",
+	       dummy->instance, dummy->dvb_adapter.num);
+
+	dvb_adapter = &dummy->dvb_adapter;
+	dvbdemux = &dummy->demux;
+	dmx = &dvbdemux->dmx;
+
+	dmx->close(dmx);
+	dvb_net_release(&dummy->dvbnet);
+	dmx->remove_frontend(dmx, &dummy->mem_frontend);
+	dmx->remove_frontend(dmx, &dummy->hw_frontend);
+	dvb_dmxdev_release(&dummy->dmxdev);
+	dvb_dmx_release(dvbdemux);
+	dvbdemux->priv = NULL;
+	dvb_unregister_frontend(dummy->fe);
+	dvb_frontend_detach(dummy->fe);
+	dvb_unregister_adapter(dvb_adapter);
+}
+
+
+static int __devinit dvb_dummy_probe(struct platform_device *plat_dev)
+{
+	int ret;
+	struct dvb_dummy *dummy;
+
+	dummy = kzalloc(sizeof(struct dvb_dummy), GFP_KERNEL);
+	if (dummy == NULL) {
+		printk(KERN_ERR
+		       "dvb_dummy_adapter: out of memory for adapter %d\n",
+		       plat_dev->id);
+		return -ENOMEM;
+	}
+
+	dummy->plat_dev = plat_dev;
+	dummy->instance = plat_dev->id;
+
+	platform_set_drvdata(plat_dev, dummy);
+
+	ret = dvb_dummy_register(dummy);
+	if (ret < 0) {
+		platform_set_drvdata(plat_dev, NULL);
+		kfree(dummy);
+	}
+	return ret;
+}
+
+static int dvb_dummy_remove(struct platform_device *plat_dev)
+{
+	struct dvb_dummy *dummy;
+
+	dummy = platform_get_drvdata(plat_dev);
+	if (dummy == NULL)
+		return 0;
+
+	dvb_dummy_unregister(dummy);
+
+	platform_set_drvdata(plat_dev, NULL);
+	kfree(dummy);
+	return 0;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+static struct platform_device_id dvb_dummy_platform_id_table[] = {
+	{ "dvb_dummy_adapter", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, dvb_dummy_platform_id_table);
+#endif
+
+static struct platform_driver dvb_dummy_platform_driver = {
+	.probe = dvb_dummy_probe,
+	.remove = dvb_dummy_remove,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+	.id_table = dvb_dummy_platform_id_table,
+#endif
+	.driver = {
+		.name = "dvb_dummy_adapter",
+	},
+};
+
+static int __init dvb_dummy_init(void)
+{
+	int ret = 0;
+	int i, n;
+	struct platform_device *plat_dev;
+
+	printk(KERN_INFO
+	       "dvb_dummy_adapter: Begin initialization, version %s\n",
+	       DVB_DUMMY_VERSION);
+
+	n = fe_type_c;
+	if (n < 1 || n >= DVB_MAX_ADAPTERS) {
+		printk(KERN_ERR "dvb_dummy_adapter: "
+		       "Illegal number (%d) of frontend types specified\n", n);
+		ret = -EINVAL;
+		goto init_exit;
+	}
+
+	ret = platform_driver_register(&dvb_dummy_platform_driver);
+	if (ret) {
+		printk(KERN_ERR "dvb_dummy_adapter: "
+		       "Error %d from platform_driver_register()\n", ret);
+		goto init_exit;
+	}
+
+	for (i = 0; i < n; i++) {
+		plat_dev = platform_device_register_simple("dvb_dummy_adapter",
+							   i, NULL, 0);
+		if (IS_ERR(plat_dev)) {
+			printk(KERN_ERR "dvb_dummy_adapter: could not allocate"
+			       "and register instance %d\n", i);
+			ret = (i == 0) ? -ENODEV : 0;
+			break;
+		}
+	}
+
+init_exit:
+	printk(KERN_INFO "dvb_dummy_adapter: End initialization\n");
+	return ret;
+}
+
+static void __exit dvb_dummy_exit(void)
+{
+	printk(KERN_INFO "dvb_dummy_adapter: Begin exit\n");
+	platform_driver_unregister(&dvb_dummy_platform_driver);
+	printk(KERN_INFO "dvb_dummy_adapter: End exit\n");
+}
+
+module_init(dvb_dummy_init);
+module_exit(dvb_dummy_exit);


