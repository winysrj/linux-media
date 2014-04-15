Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34507 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaDOJcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/10] si2157: Silicon Labs Si2157 silicon tuner driver
Date: Tue, 15 Apr 2014 12:31:37 +0300
Message-Id: <1397554306-14561-2-git-send-email-crope@iki.fi>
In-Reply-To: <1397554306-14561-1-git-send-email-crope@iki.fi>
References: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silicon Labs Si2157 silicon tuner driver.
Currently it supports only DVB-T.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/Kconfig       |   7 ++
 drivers/media/tuners/Makefile      |   1 +
 drivers/media/tuners/si2157.c      | 244 +++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/si2157.h      |  18 +++
 drivers/media/tuners/si2157_priv.h |  21 ++++
 5 files changed, 291 insertions(+)
 create mode 100644 drivers/media/tuners/si2157.c
 create mode 100644 drivers/media/tuners/si2157.h
 create mode 100644 drivers/media/tuners/si2157_priv.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index a128488..22b6b8b 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -230,6 +230,13 @@ config MEDIA_TUNER_TUA9001
 	help
 	  Infineon TUA 9001 silicon tuner driver.
 
+config MEDIA_TUNER_SI2157
+	tristate "Silicon Labs Si2157 silicon tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Silicon Labs Si2157 silicon tuner driver.
+
 config MEDIA_TUNER_IT913X
 	tristate "ITE Tech IT913x silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index efe82a9..a6ff0c6 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
 obj-$(CONFIG_MEDIA_TUNER_E4000) += e4000.o
 obj-$(CONFIG_MEDIA_TUNER_FC2580) += fc2580.o
 obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
+obj-$(CONFIG_MEDIA_TUNER_SI2157) += si2157.o
 obj-$(CONFIG_MEDIA_TUNER_M88TS2022) += m88ts2022.o
 obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
new file mode 100644
index 0000000..953f2e3
--- /dev/null
+++ b/drivers/media/tuners/si2157.c
@@ -0,0 +1,244 @@
+#include "si2157_priv.h"
+
+/* execute firmware command */
+static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
+{
+	int ret;
+	u8 buf[1];
+	unsigned long timeout;
+
+	mutex_lock(&s->i2c_mutex);
+
+	if (cmd->len) {
+		/* write cmd and args for firmware */
+		ret = i2c_master_send(s->client, cmd->args, cmd->len);
+		if (ret < 0) {
+			goto err_mutex_unlock;
+		} else if (ret != cmd->len) {
+			ret = -EREMOTEIO;
+			goto err_mutex_unlock;
+		}
+	}
+
+	/* wait cmd execution terminate */
+	#define TIMEOUT 80
+	timeout = jiffies + msecs_to_jiffies(TIMEOUT);
+	while (!time_after(jiffies, timeout)) {
+		ret = i2c_master_recv(s->client, buf, 1);
+		if (ret < 0) {
+			goto err_mutex_unlock;
+		} else if (ret != 1) {
+			ret = -EREMOTEIO;
+			goto err_mutex_unlock;
+		}
+
+		/* firmware ready? */
+		if ((buf[0] >> 7) & 0x01)
+			break;
+	}
+
+	dev_dbg(&s->client->dev, "%s: cmd execution took %d ms\n", __func__,
+			jiffies_to_msecs(jiffies) -
+			(jiffies_to_msecs(timeout) - TIMEOUT));
+
+	if (!(buf[0] >> 7) & 0x01) {
+		ret = -ETIMEDOUT;
+		goto err_mutex_unlock;
+	} else {
+		ret = 0;
+	}
+
+err_mutex_unlock:
+	mutex_unlock(&s->i2c_mutex);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int si2157_init(struct dvb_frontend *fe)
+{
+	struct si2157 *s = fe->tuner_priv;
+
+	dev_dbg(&s->client->dev, "%s:\n", __func__);
+
+	s->active = true;
+
+	return 0;
+}
+
+static int si2157_sleep(struct dvb_frontend *fe)
+{
+	struct si2157 *s = fe->tuner_priv;
+
+	dev_dbg(&s->client->dev, "%s:\n", __func__);
+
+	s->active = false;
+
+	return 0;
+}
+
+static int si2157_set_params(struct dvb_frontend *fe)
+{
+	struct si2157 *s = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	struct si2157_cmd cmd;
+
+	dev_dbg(&s->client->dev,
+			"%s: delivery_system=%d frequency=%u bandwidth_hz=%u\n",
+			__func__, c->delivery_system, c->frequency,
+			c->bandwidth_hz);
+
+	if (!s->active) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	/* configure? */
+	cmd.args[0] = 0xc0;
+	cmd.args[1] = 0x00;
+	cmd.args[2] = 0x0c;
+	cmd.args[3] = 0x00;
+	cmd.args[4] = 0x00;
+	cmd.args[5] = 0x01;
+	cmd.args[6] = 0x01;
+	cmd.args[7] = 0x01;
+	cmd.args[8] = 0x01;
+	cmd.args[9] = 0x01;
+	cmd.args[10] = 0x01;
+	cmd.args[11] = 0x02;
+	cmd.args[12] = 0x00;
+	cmd.args[13] = 0x00;
+	cmd.args[14] = 0x01;
+	cmd.len = 15;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	cmd.args[0] = 0x02;
+	cmd.len = 1;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	cmd.args[0] = 0x01;
+	cmd.args[1] = 0x01;
+	cmd.len = 2;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	/* set frequency */
+	cmd.args[0] = 0x41;
+	cmd.args[1] = 0x00;
+	cmd.args[2] = 0x00;
+	cmd.args[3] = 0x00;
+	cmd.args[4] = (c->frequency >>  0) & 0xff;
+	cmd.args[5] = (c->frequency >>  8) & 0xff;
+	cmd.args[6] = (c->frequency >> 16) & 0xff;
+	cmd.args[7] = (c->frequency >> 24) & 0xff;
+	cmd.len = 8;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static const struct dvb_tuner_ops si2157_tuner_ops = {
+	.info = {
+		.name           = "Silicon Labs Si2157",
+		.frequency_min  = 174000000,
+		.frequency_max  = 862000000,
+	},
+
+	.init = si2157_init,
+	.sleep = si2157_sleep,
+	.set_params = si2157_set_params,
+};
+
+static int si2157_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct si2157_config *cfg = client->dev.platform_data;
+	struct dvb_frontend *fe = cfg->fe;
+	struct si2157 *s;
+	struct si2157_cmd cmd;
+	int ret;
+
+	s = kzalloc(sizeof(struct si2157), GFP_KERNEL);
+	if (!s) {
+		ret = -ENOMEM;
+		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
+
+	s->client = client;
+	s->fe = cfg->fe;
+	mutex_init(&s->i2c_mutex);
+
+	/* check if the tuner is there */
+	cmd.len = 0;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	fe->tuner_priv = s;
+	memcpy(&fe->ops.tuner_ops, &si2157_tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
+	i2c_set_clientdata(client, s);
+
+	dev_info(&s->client->dev,
+			"%s: Silicon Labs Si2157 successfully attached\n",
+			KBUILD_MODNAME);
+	return 0;
+err:
+	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	kfree(s);
+
+	return ret;
+}
+
+static int si2157_remove(struct i2c_client *client)
+{
+	struct si2157 *s = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = s->fe;
+
+	dev_dbg(&client->dev, "%s:\n", __func__);
+
+	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = NULL;
+	kfree(s);
+
+	return 0;
+}
+
+static const struct i2c_device_id si2157_id[] = {
+	{"si2157", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, si2157_id);
+
+static struct i2c_driver si2157_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "si2157",
+	},
+	.probe		= si2157_probe,
+	.remove		= si2157_remove,
+	.id_table	= si2157_id,
+};
+
+module_i2c_driver(si2157_driver);
+
+MODULE_DESCRIPTION("Silicon Labs Si2157 silicon tuner driver");
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
new file mode 100644
index 0000000..5de47d4
--- /dev/null
+++ b/drivers/media/tuners/si2157.h
@@ -0,0 +1,18 @@
+#ifndef SI2157_H
+#define SI2157_H
+
+#include <linux/kconfig.h>
+#include "dvb_frontend.h"
+
+/*
+ * I2C address
+ * 0x60
+ */
+struct si2157_config {
+	/*
+	 * frontend
+	 */
+	struct dvb_frontend *fe;
+};
+
+#endif
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
new file mode 100644
index 0000000..6018851
--- /dev/null
+++ b/drivers/media/tuners/si2157_priv.h
@@ -0,0 +1,21 @@
+#ifndef SI2157_PRIV_H
+#define SI2157_PRIV_H
+
+#include "si2157.h"
+
+/* state struct */
+struct si2157 {
+	struct mutex i2c_mutex;
+	struct i2c_client *client;
+	struct dvb_frontend *fe;
+	bool active;
+};
+
+/* firmare command struct */
+#define SI2157_ARGLEN      30
+struct si2157_cmd {
+	u8 args[SI2157_ARGLEN];
+	unsigned len;
+};
+
+#endif
-- 
1.9.0

