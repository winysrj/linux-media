Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36328 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbAGNFR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 08:05:17 -0500
Received: by mail-pd0-f182.google.com with SMTP id p10so4537216pdj.13
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 05:05:16 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2] dvb-core: add template code for i2c binding model
Date: Wed,  7 Jan 2015 22:05:00 +0900
Message-Id: <1420635900-32221-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Changes in v2:
- rename some varibles for consistency and readability
- (registering of tuner subdev media_entity is NOT implemented yet).

Define a standard interface for demod/tuner i2c driver modules.
A module client calls dvb_i2c_attach_{fe,tuner}(),
and a module driver defines struct dvb_i2c_module_param and
calls DEFINE_DVB_I2C_MODULE() macro.

This template provides implicit module requests and ref-counting,
alloc/free's private data structures,
fixes the usage of clientdata of i2c devices,
and defines the platformdata structures for passing around
device specific config/output parameters between drivers and clients.
These kinds of code are common to (almost) all dvb i2c drivers/client,
but they were scattered over adapter modules and demod/tuner modules.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-core/Makefile       |   4 +
 drivers/media/dvb-core/dvb_frontend.h |   1 +
 drivers/media/dvb-core/dvb_i2c.c      | 219 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_i2c.h      | 110 +++++++++++++++++
 4 files changed, 334 insertions(+)
 create mode 100644 drivers/media/dvb-core/dvb_i2c.c
 create mode 100644 drivers/media/dvb-core/dvb_i2c.h

diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
index 8f22bcd..271648d 100644
--- a/drivers/media/dvb-core/Makefile
+++ b/drivers/media/dvb-core/Makefile
@@ -8,4 +8,8 @@ dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
 		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
 
+ifneq ($(CONFIG_I2C)$(CONFIG_I2C_MODULE),)
+dvb-core-objs += dvb_i2c.o
+endif
+
 obj-$(CONFIG_DVB_CORE) += dvb-core.o
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 816269e..903719a 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -415,6 +415,7 @@ struct dtv_frontend_properties {
 struct dvb_frontend {
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
+	struct i2c_client *fe_i2c_client;
 	void *demodulator_priv;
 	void *tuner_priv;
 	void *frontend_priv;
diff --git a/drivers/media/dvb-core/dvb_i2c.c b/drivers/media/dvb-core/dvb_i2c.c
new file mode 100644
index 0000000..09c3078
--- /dev/null
+++ b/drivers/media/dvb-core/dvb_i2c.c
@@ -0,0 +1,219 @@
+/*
+ * dvb_i2c.c
+ *
+ * Copyright 2014 Akihiro Tsukada <tskd08 AT gmail DOT com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include "dvb_i2c.h"
+
+static struct i2c_client *
+dvb_i2c_new_subdev(struct i2c_adapter *adap, struct i2c_board_info *info,
+		   const unsigned short *probe_addrs)
+{
+	struct i2c_client *cl;
+
+	request_module(I2C_MODULE_PREFIX "%s", info->type);
+	/* Create the i2c client */
+	if (info->addr == 0 && probe_addrs)
+		cl = i2c_new_probed_device(adap, info, probe_addrs, NULL);
+	else
+		cl = i2c_new_device(adap, info);
+	if (!cl || !cl->dev.driver)
+		return NULL;
+	return cl;
+}
+
+struct dvb_frontend *
+dvb_i2c_attach_fe(struct i2c_adapter *adap, const struct i2c_board_info *info,
+		  const void *cfg_template, void **out)
+{
+	struct i2c_client *cl;
+	struct i2c_board_info tmp_info;
+	struct dvb_i2c_dev_config cfg;
+
+	cfg.priv_cfg = cfg_template;
+	cfg.out = out;
+	tmp_info = *info;
+	tmp_info.platform_data = &cfg;
+
+	cl = dvb_i2c_new_subdev(adap, &tmp_info, NULL);
+	if (!cl)
+		return NULL;
+	return i2c_get_clientdata(cl);
+}
+EXPORT_SYMBOL(dvb_i2c_attach_fe);
+
+struct i2c_client *
+dvb_i2c_attach_tuner(struct i2c_adapter *adap,
+		     const struct i2c_board_info *info,
+		     struct dvb_frontend *fe,
+		     const void *cfg_template, void **out)
+{
+	struct i2c_board_info tmp_info;
+	struct dvb_i2c_tuner_config cfg;
+
+	cfg.fe = fe;
+	cfg.devcfg.priv_cfg = cfg_template;
+	cfg.devcfg.out = out;
+	tmp_info = *info;
+	tmp_info.platform_data = &cfg;
+
+	return dvb_i2c_new_subdev(adap, &tmp_info, NULL);
+}
+EXPORT_SYMBOL(dvb_i2c_attach_tuner);
+
+
+static int
+probe_tuner(struct i2c_client *client, const struct i2c_device_id *id,
+	    const struct dvb_i2c_module_param *param,
+	    struct module *this_module)
+{
+	struct dvb_frontend *fe;
+	struct dvb_i2c_tuner_config *cfg;
+	int ret;
+
+	if (!try_module_get(this_module))
+		return -ENODEV;
+
+	cfg = client->dev.platform_data;
+	fe = cfg->fe;
+	i2c_set_clientdata(client, fe);
+
+	if (param->priv_size > 0) {
+		fe->tuner_priv = kzalloc(param->priv_size, GFP_KERNEL);
+		if (!fe->tuner_priv) {
+			ret = -ENOMEM;
+			goto err_mem;
+		}
+	}
+
+	if (param->ops.tuner_ops)
+		memcpy(&fe->ops.tuner_ops, param->ops.tuner_ops,
+			sizeof(fe->ops.tuner_ops));
+
+	ret = 0;
+	if (param->priv_probe)
+		ret = param->priv_probe(client, id);
+	if (ret != 0) {
+		dev_info(&client->dev, "driver private probe failed.\n");
+		goto err_priv;
+	}
+	return 0;
+
+err_priv:
+	kfree(fe->tuner_priv);
+err_mem:
+	fe->tuner_priv = NULL;
+	module_put(this_module);
+	return ret;
+}
+
+static int remove_tuner(struct i2c_client *client,
+			const struct dvb_i2c_module_param *param,
+			struct module *this_module)
+{
+	struct dvb_frontend *fe;
+
+	if (param->priv_remove)
+		param->priv_remove(client);
+	fe = i2c_get_clientdata(client);
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	module_put(this_module);
+	return 0;
+}
+
+
+static int probe_fe(struct i2c_client *client, const struct i2c_device_id *id,
+		    const struct dvb_i2c_module_param *param,
+		    struct module *this_module)
+{
+	struct dvb_frontend *fe;
+	int ret;
+
+	if (!try_module_get(this_module))
+		return -ENODEV;
+
+	fe = kzalloc(sizeof(*fe), GFP_KERNEL);
+	if (!fe) {
+		ret = -ENOMEM;
+		goto err_fe_kfree;
+	}
+	i2c_set_clientdata(client, fe);
+	fe->fe_i2c_client = client;
+
+	if (param->priv_size > 0) {
+		fe->demodulator_priv = kzalloc(param->priv_size, GFP_KERNEL);
+		if (!fe->demodulator_priv) {
+			ret = -ENOMEM;
+			goto err_fe_kfree;
+		}
+	}
+
+	if (param->ops.fe_ops)
+		memcpy(&fe->ops, param->ops.fe_ops, sizeof(fe->ops));
+
+	ret = 0;
+	if (param->priv_probe)
+		ret = param->priv_probe(client, id);
+	if (ret != 0) {
+		dev_info(&client->dev, "driver private probe failed.\n");
+		goto err_priv_kfree;
+	}
+	return 0;
+
+err_priv_kfree:
+	kfree(fe->demodulator_priv);
+err_fe_kfree:
+	kfree(fe);
+	module_put(this_module);
+	return ret;
+}
+
+static int remove_fe(struct i2c_client *client,
+		     const struct dvb_i2c_module_param *param,
+		     struct module *this_module)
+{
+	struct dvb_frontend *fe;
+
+	if (param->priv_remove)
+		param->priv_remove(client);
+	fe = i2c_get_clientdata(client);
+	kfree(fe->demodulator_priv);
+	kfree(fe);
+	module_put(this_module);
+	return 0;
+}
+
+
+int dvb_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id,
+		  const struct dvb_i2c_module_param *param,
+		  struct module *this_module)
+{
+	return param->is_tuner ? probe_tuner(client, id, param, this_module) :
+				 probe_fe(client, id, param, this_module);
+}
+EXPORT_SYMBOL(dvb_i2c_probe);
+
+int dvb_i2c_remove(struct i2c_client *client,
+		   const struct dvb_i2c_module_param *param,
+		   struct module *this_module)
+{
+	return param->is_tuner ? remove_tuner(client, param, this_module) :
+				 remove_fe(client, param, this_module);
+}
+EXPORT_SYMBOL(dvb_i2c_remove);
diff --git a/drivers/media/dvb-core/dvb_i2c.h b/drivers/media/dvb-core/dvb_i2c.h
new file mode 100644
index 0000000..4a5365d
--- /dev/null
+++ b/drivers/media/dvb-core/dvb_i2c.h
@@ -0,0 +1,110 @@
+/*
+ * dvb_i2c.h
+ *
+ * Copyright 2014 Akihiro Tsukada <tskd08 AT gmail DOT com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+/* template code for i2c driver modules */
+
+#ifndef _DVB_I2C_H_
+#define _DVB_I2C_H_
+
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "dvb_frontend.h"
+
+/* interface for module clients */
+
+struct dvb_frontend *dvb_i2c_attach_fe(struct i2c_adapter *adap,
+				       const struct i2c_board_info *info,
+				       const void *cfg_template, void **out);
+
+struct i2c_client *dvb_i2c_attach_tuner(struct i2c_adapter *adap,
+					const struct i2c_board_info *info,
+					struct dvb_frontend *fe,
+					const void *cfg_template, void **out);
+
+/* interface for module drivers */
+
+/* data structures that are set to i2c_client.dev.platform_data */
+
+struct dvb_i2c_dev_config {
+	const void *priv_cfg;
+	/* @out [OUT] pointer to per-device data returned from driver */
+	void **out;
+};
+
+struct dvb_i2c_tuner_config {
+	struct dvb_frontend *fe;
+	struct dvb_i2c_dev_config devcfg;
+};
+
+typedef int (*dvb_i2c_probe_func)(struct i2c_client *client,
+				  const struct i2c_device_id *id);
+typedef int (*dvb_i2c_remove_func)(struct i2c_client *client);
+
+struct dvb_i2c_module_param {
+	union {
+		const struct dvb_frontend_ops *fe_ops;
+		const struct dvb_tuner_ops *tuner_ops;
+	} ops;
+	/* driver private probe/remove functions */
+	dvb_i2c_probe_func  priv_probe;
+	dvb_i2c_remove_func priv_remove;
+
+	u32 priv_size; /* sizeof(device private data) */
+	bool is_tuner;
+};
+
+
+int dvb_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id,
+		  const struct dvb_i2c_module_param *param,
+		  struct module *this_module);
+
+int dvb_i2c_remove(struct i2c_client *client,
+		   const struct dvb_i2c_module_param *param,
+		   struct module *this_module);
+
+
+#define DEFINE_DVB_I2C_MODULE(dname, idtab, param) \
+static int _##dname##_probe(struct i2c_client *client,\
+				const struct i2c_device_id *id)\
+{\
+	return dvb_i2c_probe(client, id, &(param), THIS_MODULE);\
+} \
+\
+static int _##dname##_remove(struct i2c_client *client)\
+{\
+	return dvb_i2c_remove(client, &(param), THIS_MODULE);\
+} \
+\
+MODULE_DEVICE_TABLE(i2c, idtab);\
+\
+static struct i2c_driver dname##_driver = {\
+	.driver = {\
+		.name = #dname,\
+	},\
+	.probe    = _##dname##_probe,\
+	.remove   = _##dname##_remove,\
+	.id_table = idtab,\
+};\
+\
+module_i2c_driver(dname##_driver)
+
+#endif /* _DVB_I2C_H */
-- 
2.2.1

