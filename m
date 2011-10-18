Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo13.poczta.onet.pl ([213.180.142.144]:46430 "EHLO
	smtpo13.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1JRTsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 15:48:25 -0400
Date: Tue, 18 Oct 2011 21:48:22 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [RESEND PATCH 2/14] staging/media/as102: checkpatch fixes
Message-ID: <20111018214822.7f3de76e@darkstar>
In-Reply-To: <20111018111140.5b37f91b.chmooreck@poczta.onet.pl>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111140.5b37f91b.chmooreck@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Original source and comment:
# HG changeset patch
# User Devin Heitmueller <dheitmueller@kernellabs.com>
# Date 1267318502 18000
# Node ID e2ba344c99936bddc46722f1f1efec5600c58659
# Parent  a78bda1e1a0badc4a1296be958f1f8a49014ae18
as102: checkpatch fixes

From: Devin Heitmueller <dheitmueller@kernellabs.com>

Fix make checkpatch issues reported against as102_drv.c

Priority: normal

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Piotr Chmura <chmooreck@poczta.onet.pl>

diff --git linux/drivers/staging/media/as102/as102_drv.c linuxb/drivers/media/dvb/as102/as102_drv.c
--- linux/drivers/staging/media/as102/as102_drv.c
+++ linuxb/drivers/staging/media/as102/as102_drv.c
@@ -1,6 +1,7 @@
 /*
  * Abilis Systems Single DVB-T Receiver
  * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -36,23 +37,23 @@
 #warning >>> DVB_CORE not defined !!! <<<
 #endif
 
-int debug = 0;
+int debug;
 module_param_named(debug, debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default: off)");
 
-int dual_tuner = 0;
+int dual_tuner;
 module_param_named(dual_tuner, dual_tuner, int, 0644);
-MODULE_PARM_DESC(dual_tuner, "Activate Dual-Tuner configuration (default: off)");
+MODULE_PARM_DESC(dual_tuner, "Activate Dual-Tuner config (default: off)");
 
 static int fw_upload = 1;
 module_param_named(fw_upload, fw_upload, int, 0644);
 MODULE_PARM_DESC(fw_upload, "Turn on/off default FW upload (default: on)");
 
-static int pid_filtering = 0;
+static int pid_filtering;
 module_param_named(pid_filtering, pid_filtering, int, 0644);
 MODULE_PARM_DESC(pid_filtering, "Activate HW PID filtering (default: off)");
 
-static int ts_auto_disable = 0;
+static int ts_auto_disable;
 module_param_named(ts_auto_disable, ts_auto_disable, int, 0644);
 MODULE_PARM_DESC(ts_auto_disable, "Stream Auto Enable on FW (default: off)");
 
@@ -65,7 +66,8 @@
 #endif
 
 #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
-static void as102_stop_stream(struct as102_dev_t *dev) {
+static void as102_stop_stream(struct as102_dev_t *dev)
+{
 	struct as102_bus_adapter_t *bus_adap;
 
 	if (dev != NULL)
@@ -80,16 +82,15 @@
 		if (mutex_lock_interruptible(&dev->bus_adap.lock))
 			return;
 
-		if (as10x_cmd_stop_streaming(bus_adap) < 0) {
+		if (as10x_cmd_stop_streaming(bus_adap) < 0)
 			dprintk(debug, "as10x_cmd_stop_streaming failed\n");
-		}
 
 		mutex_unlock(&dev->bus_adap.lock);
 	}
 }
 
-static int as102_start_stream(struct as102_dev_t *dev) {
-
+static int as102_start_stream(struct as102_dev_t *dev)
+{
 	struct as102_bus_adapter_t *bus_adap;
 	int ret = -EFAULT;
 
@@ -98,9 +99,8 @@
 	else
 		return ret;
 
-	if (bus_adap->ops->start_stream != NULL) {
+	if (bus_adap->ops->start_stream != NULL)
 		ret = bus_adap->ops->start_stream(dev);
-	}
 
 	if (ts_auto_disable) {
 		if (mutex_lock_interruptible(&dev->bus_adap.lock))
@@ -127,25 +127,25 @@
 		return -EBUSY;
 	}
 
-	switch(onoff) {
-		case 0:
-			ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
-			dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
-					index, pid, ret);
-			break;
-		case 1:
-		{
-			struct as10x_ts_filter filter;
+	switch (onoff) {
+	case 0:
+	    ret = as10x_cmd_del_PID_filter(bus_adap, (uint16_t) pid);
+	    dprintk(debug, "DEL_PID_FILTER([%02d] 0x%04x) ret = %d\n",
+		    index, pid, ret);
+	    break;
+	case 1:
+	{
+	    struct as10x_ts_filter filter;
 
-			filter.type = TS_PID_TYPE_TS;
-			filter.idx = 0xFF;
-			filter.pid = pid;
+	    filter.type = TS_PID_TYPE_TS;
+	    filter.idx = 0xFF;
+	    filter.pid = pid;
 
-			ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
-			dprintk(debug, "ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
-					index, filter.idx, filter.pid, ret);
-			break;
-		}
+	    ret = as10x_cmd_add_PID_filter(bus_adap, &filter);
+	    dprintk(debug, "ADD_PID_FILTER([%02d -> %02d], 0x%04x) ret = %d\n",
+		    index, filter.idx, filter.pid, ret);
+	    break;
+	}
 	}
 
 	mutex_unlock(&dev->bus_adap.lock);
@@ -154,7 +154,8 @@
 	return ret;
 }
 
-static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed) {
+static int as102_dvb_dmx_start_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
 	int ret = 0;
 	struct dvb_demux *demux = dvbdmxfeed->demux;
 	struct as102_dev_t *as102_dev = demux->priv;
@@ -169,16 +170,16 @@
 				dvbdmxfeed->index, dvbdmxfeed->pid, 1);
 	}
 
-	if (as102_dev->streaming++ == 0) {
+	if (as102_dev->streaming++ == 0)
 		ret = as102_start_stream(as102_dev);
-	}
 
 	mutex_unlock(&as102_dev->sem);
 	LEAVE();
 	return ret;
 }
 
-static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed) {
+static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
+{
 	struct dvb_demux *demux = dvbdmxfeed->demux;
 	struct as102_dev_t *as102_dev = demux->priv;
 
@@ -187,9 +188,8 @@
 	if (mutex_lock_interruptible(&as102_dev->sem))
 		return -ERESTARTSYS;
 
-	if (--as102_dev->streaming == 0) {
+	if (--as102_dev->streaming == 0)
 		as102_stop_stream(as102_dev);
-	}
 
 	if (pid_filtering) {
 		as10x_pid_filter(as102_dev,
@@ -202,7 +202,8 @@
 }
 #endif
 
-int as102_dvb_register(struct as102_dev_t *as102_dev) {
+int as102_dvb_register(struct as102_dev_t *as102_dev)
+{
 	int ret = 0;
 	ENTER();
 
@@ -223,7 +224,7 @@
 				   );
 	if (ret < 0) {
 		err("%s: dvb_register_adapter() failed (errno = %d)",
-		    __FUNCTION__, ret);
+		    __func__, ret);
 		goto failed;
 	}
 
@@ -240,23 +241,23 @@
 	as102_dev->dvb_dmxdev.demux = &as102_dev->dvb_dmx.dmx;
 	as102_dev->dvb_dmxdev.capabilities = 0;
 
-	if ((ret = dvb_dmx_init(&as102_dev->dvb_dmx)) < 0) {
-		err("%s: dvb_dmx_init() failed (errno = %d)",
-		    __FUNCTION__, ret);
+	ret = dvb_dmx_init(&as102_dev->dvb_dmx);
+	if (ret < 0) {
+		err("%s: dvb_dmx_init() failed (errno = %d)", __func__, ret);
 		goto failed;
 	}
 
 	ret = dvb_dmxdev_init(&as102_dev->dvb_dmxdev, &as102_dev->dvb_adap);
 	if (ret < 0) {
-		err("%s: dvb_dmxdev_init() failed (errno = %d)",
-		    __FUNCTION__, ret);
+		err("%s: dvb_dmxdev_init() failed (errno = %d)", __func__,
+		    ret);
 		goto failed;
 	}
 
 	ret = as102_dvb_register_fe(as102_dev, &as102_dev->dvb_fe);
 	if (ret < 0) {
 		err("%s: as102_dvb_register_frontend() failed (errno = %d)",
-		    __FUNCTION__, ret);
+		    __func__, ret);
 		goto failed;
 	}
 #endif
@@ -283,7 +284,8 @@
 	return ret;
 }
 
-void as102_dvb_unregister(struct as102_dev_t *as102_dev) {
+void as102_dvb_unregister(struct as102_dev_t *as102_dev)
+{
 	ENTER();
 
 #if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
@@ -300,7 +302,8 @@
 	LEAVE();
 }
 
-static int __init as102_driver_init(void) {
+static int __init as102_driver_init(void)
+{
 	int ret = 0;
 
 	ENTER();
@@ -331,7 +334,8 @@
  * \brief as102 driver exit point. This function is called when device has
  *       to be removed.
  */
-static void __exit as102_driver_exit(void) {
+static void __exit as102_driver_exit(void)
+{
 	ENTER();
 	/* deregister this driver with the low level bus subsystem */
 #if defined(CONFIG_AS102_USB)
