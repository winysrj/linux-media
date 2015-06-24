Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34091 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbbFXPLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:46 -0400
Received: by wgqq4 with SMTP id q4so39054089wgq.1
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:43 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 08/12] [media] tsin: c8sectpfe: Add LDVB helper functions.
Date: Wed, 24 Jun 2015 16:11:06 +0100
Message-Id: <1435158670-7195-9-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These functions are used by the core code for creating the LDVB
devices and adapter.

Addtionally some older SoC's (and potentially newer ones) have different
frontend HW which would allow those devices to be easily supported
in the future by keeping the code specific to the IP separate from the
more generic code.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/tsin/c8sectpfe/c8sectpfe-common.c | 266 ++++++++++++++++++++++++
 drivers/media/tsin/c8sectpfe/c8sectpfe-common.h |  66 ++++++
 2 files changed, 332 insertions(+)
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-common.c
 create mode 100644 drivers/media/tsin/c8sectpfe/c8sectpfe-common.h

diff --git a/drivers/media/tsin/c8sectpfe/c8sectpfe-common.c b/drivers/media/tsin/c8sectpfe/c8sectpfe-common.c
new file mode 100644
index 0000000..c8d607d
--- /dev/null
+++ b/drivers/media/tsin/c8sectpfe/c8sectpfe-common.c
@@ -0,0 +1,266 @@
+/*
+ * c8sectpfe-common.c - C8SECTPFE STi DVB driver
+ *
+ * Copyright (c) STMicroelectronics 2015
+ *
+ *   Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License as
+ *      published by the Free Software Foundation; either version 2 of
+ *      the License, or (at your option) any later version.
+ */
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dvb/dmx.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/wait.h>
+
+#include "dmxdev.h"
+#include "dvbdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+
+#include "c8sectpfe-common.h"
+#include "c8sectpfe-core.h"
+#include "c8sectpfe-dvb.h"
+
+static int register_dvb(struct stdemux *demux, struct dvb_adapter *adap,
+				void *start_feed, void *stop_feed,
+				struct c8sectpfei *fei)
+{
+	int result;
+
+	demux->dvb_demux.dmx.capabilities = DMX_TS_FILTERING |
+					DMX_SECTION_FILTERING |
+					DMX_MEMORY_BASED_FILTERING;
+
+	demux->dvb_demux.priv = demux;
+	demux->dvb_demux.filternum = C8SECTPFE_MAXCHANNEL;
+	demux->dvb_demux.feednum = C8SECTPFE_MAXCHANNEL;
+
+	demux->dvb_demux.start_feed = start_feed;
+	demux->dvb_demux.stop_feed = stop_feed;
+	demux->dvb_demux.write_to_decoder = NULL;
+
+	result = dvb_dmx_init(&demux->dvb_demux);
+	if (result < 0) {
+		dev_err(fei->dev, "dvb_dmx_init failed (errno = %d)\n",
+			result);
+		goto err_dmx;
+	}
+
+	demux->dmxdev.filternum = demux->dvb_demux.filternum;
+	demux->dmxdev.demux = &demux->dvb_demux.dmx;
+	demux->dmxdev.capabilities = 0;
+
+	result = dvb_dmxdev_init(&demux->dmxdev, adap);
+	if (result < 0) {
+		dev_err(fei->dev, "dvb_dmxdev_init failed (errno = %d)\n",
+			result);
+
+		goto err_dmxdev;
+	}
+
+	demux->hw_frontend.source = DMX_FRONTEND_0 + demux->tsin_index;
+
+	result = demux->dvb_demux.dmx.add_frontend(&demux->dvb_demux.dmx,
+						&demux->hw_frontend);
+	if (result < 0) {
+		dev_err(fei->dev, "add_frontend failed (errno = %d)\n", result);
+		goto err_fe_hw;
+	}
+
+	demux->mem_frontend.source = DMX_MEMORY_FE;
+	result = demux->dvb_demux.dmx.add_frontend(&demux->dvb_demux.dmx,
+						&demux->mem_frontend);
+	if (result < 0) {
+		dev_err(fei->dev, "add_frontend failed (%d)\n", result);
+		goto err_fe_mem;
+	}
+
+	result = demux->dvb_demux.dmx.connect_frontend(&demux->dvb_demux.dmx,
+							&demux->hw_frontend);
+	if (result < 0) {
+		dev_err(fei->dev, "connect_frontend (%d)\n", result);
+		goto err_fe_con;
+	}
+
+	return 0;
+
+err_fe_con:
+	demux->dvb_demux.dmx.remove_frontend(&demux->dvb_demux.dmx,
+						     &demux->mem_frontend);
+err_fe_mem:
+	demux->dvb_demux.dmx.remove_frontend(&demux->dvb_demux.dmx,
+						     &demux->hw_frontend);
+err_fe_hw:
+	dvb_dmxdev_release(&demux->dmxdev);
+err_dmxdev:
+	dvb_dmx_release(&demux->dvb_demux);
+err_dmx:
+	return result;
+
+}
+
+static void unregister_dvb(struct stdemux *demux)
+{
+
+	demux->dvb_demux.dmx.remove_frontend(&demux->dvb_demux.dmx,
+						     &demux->mem_frontend);
+
+	demux->dvb_demux.dmx.remove_frontend(&demux->dvb_demux.dmx,
+						     &demux->hw_frontend);
+
+	dvb_dmxdev_release(&demux->dmxdev);
+
+	dvb_dmx_release(&demux->dvb_demux);
+}
+
+static struct c8sectpfe *c8sectpfe_create(struct c8sectpfei *fei,
+				void *start_feed,
+				void *stop_feed)
+{
+	struct c8sectpfe *c8sectpfe;
+	int result;
+	int i, j;
+
+	short int ids[] = { -1 };
+
+	c8sectpfe = kzalloc(sizeof(struct c8sectpfe), GFP_KERNEL);
+	if (!c8sectpfe)
+		goto err1;
+
+	mutex_init(&c8sectpfe->lock);
+
+	c8sectpfe->device = fei->dev;
+
+	result = dvb_register_adapter(&c8sectpfe->adapter, "STi c8sectpfe",
+					THIS_MODULE, fei->dev, ids);
+	if (result < 0) {
+		dev_err(fei->dev, "dvb_register_adapter failed (errno = %d)\n",
+			result);
+		goto err2;
+	}
+
+	c8sectpfe->adapter.priv = fei;
+
+	for (i = 0; i < fei->tsin_count; i++) {
+
+		c8sectpfe->demux[i].tsin_index = i;
+		c8sectpfe->demux[i].tsm_channel = fei->channel_data[i]->tsin_id;
+		c8sectpfe->demux[i].c8sectpfei = fei;
+
+		result = register_dvb(&c8sectpfe->demux[i], &c8sectpfe->adapter,
+				start_feed, stop_feed, fei);
+		if (result < 0) {
+			dev_err(fei->dev,
+				"register_dvb feed=%d failed (errno = %d)\n",
+				result, i);
+
+			/* we take a all or nothing approach */
+			for (j = 0; j < i; j++)
+				unregister_dvb(&c8sectpfe->demux[j]);
+			goto err3;
+		}
+	}
+
+	c8sectpfe->num_feeds = fei->tsin_count;
+
+	return c8sectpfe;
+err3:
+	dvb_unregister_adapter(&c8sectpfe->adapter);
+err2:
+	kfree(c8sectpfe);
+err1:
+	return NULL;
+};
+
+static void c8sectpfe_delete(struct c8sectpfe *c8sectpfe)
+{
+	int i;
+
+	if (!c8sectpfe)
+		return;
+
+	for (i = 0; i < c8sectpfe->num_feeds; i++)
+		unregister_dvb(&c8sectpfe->demux[i]);
+
+	dvb_unregister_adapter(&c8sectpfe->adapter);
+
+	kfree(c8sectpfe);
+};
+
+void c8sectpfe_tuner_unregister_frontend(struct c8sectpfe *c8sectpfe,
+					struct c8sectpfei *fei)
+{
+	int n;
+	struct channel_info *tsin;
+
+	for (n = 0; n < fei->tsin_count; n++) {
+
+		tsin = fei->channel_data[n];
+
+		if (tsin && tsin->frontend) {
+			dvb_unregister_frontend(tsin->frontend);
+			dvb_frontend_detach(tsin->frontend);
+		}
+
+		if (tsin && tsin->i2c_adapter)
+			i2c_put_adapter(tsin->i2c_adapter);
+
+		if (tsin && tsin->i2c_client) {
+			if (tsin->i2c_client->dev.driver->owner)
+				module_put(tsin->i2c_client->dev.driver->owner);
+			i2c_unregister_device(tsin->i2c_client);
+		}
+	}
+
+	c8sectpfe_delete(c8sectpfe);
+};
+
+int c8sectpfe_tuner_register_frontend(struct c8sectpfe **c8sectpfe,
+				struct c8sectpfei *fei,
+				void *start_feed,
+				void *stop_feed)
+{
+	struct channel_info *tsin;
+	struct dvb_frontend *frontend;
+	int n, res;
+
+	*c8sectpfe = c8sectpfe_create(fei, start_feed, stop_feed);
+	if (!*c8sectpfe)
+		return -ENOMEM;
+
+	for (n = 0; n < fei->tsin_count; n++) {
+		tsin = fei->channel_data[n];
+
+		res = c8sectpfe_frontend_attach(&frontend, *c8sectpfe, tsin, n);
+		if (res)
+			goto err;
+
+		res = dvb_register_frontend(&c8sectpfe[0]->adapter, frontend);
+		if (res < 0) {
+			dev_err(fei->dev, "dvb_register_frontend failed (%d)\n",
+				res);
+			goto err;
+		}
+
+		tsin->frontend = frontend;
+	}
+
+	return 0;
+
+err:
+	c8sectpfe_tuner_unregister_frontend(*c8sectpfe, fei);
+	return res;
+}
diff --git a/drivers/media/tsin/c8sectpfe/c8sectpfe-common.h b/drivers/media/tsin/c8sectpfe/c8sectpfe-common.h
new file mode 100644
index 0000000..03beed5
--- /dev/null
+++ b/drivers/media/tsin/c8sectpfe/c8sectpfe-common.h
@@ -0,0 +1,66 @@
+/*
+ * c8sectpfe-common.h - C8SECTPFE STi DVB driver
+ *
+ * Copyright (c) STMicroelectronics 2015
+ *
+ *   Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License as
+ *      published by the Free Software Foundation; either version 2 of
+ *      the License, or (at your option) any later version.
+ */
+#ifndef _C8SECTPFE_COMMON_H_
+#define _C8SECTPFE_COMMON_H_
+
+#include <linux/dvb/dmx.h>
+#include <linux/dvb/frontend.h>
+#include <linux/gpio.h>
+#include <linux/version.h>
+
+#include "dmxdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+
+/* Maximum number of channels */
+#define C8SECTPFE_MAXADAPTER (4)
+#define C8SECTPFE_MAXCHANNEL 64
+#define STPTI_MAXCHANNEL 64
+
+#define MAX_INPUTBLOCKS 7
+
+struct c8sectpfe;
+struct stdemux;
+
+struct stdemux {
+	struct dvb_demux	dvb_demux;
+	struct dmxdev		dmxdev;
+	struct dmx_frontend	hw_frontend;
+	struct dmx_frontend	mem_frontend;
+	int			tsm_channel;
+	int			stream_channel;
+	int			tsin_index;
+	int			running_feed_count;
+	struct			c8sectpfei *c8sectpfei;
+};
+
+struct c8sectpfe {
+	struct stdemux demux[MAX_INPUTBLOCKS];
+	struct mutex lock;
+	struct dvb_adapter adapter;
+	struct device *device;
+	int mapping;
+	int num_feeds;
+};
+
+/* Channel registration */
+int c8sectpfe_tuner_register_frontend(struct c8sectpfe **c8sectpfe,
+					struct c8sectpfei *fei,
+					void *start_feed,
+					void *stop_feed);
+
+void c8sectpfe_tuner_unregister_frontend(struct c8sectpfe *c8sectpfe,
+						struct c8sectpfei *fei);
+
+#endif
-- 
1.9.1

