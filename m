Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55092 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbcGZHJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:37 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 1/7] si2165: support i2c_client attach
Date: Tue, 26 Jul 2016 09:09:02 +0200
Message-Id: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Afterwards it is possible to convert attaching in card drivers.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 149 +++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/si2165.h |  22 ++++++
 2 files changed, 171 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 8bf716a..2d9bbdd 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -40,6 +40,8 @@
  */
 
 struct si2165_state {
+	struct i2c_client *client;
+
 	struct i2c_adapter *i2c;
 
 	struct dvb_frontend fe;
@@ -1157,6 +1159,153 @@ error:
 }
 EXPORT_SYMBOL(si2165_attach);
 
+static int si2165_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct si2165_state *state = NULL;
+	struct si2165_platform_data *pdata = client->dev.platform_data;
+	int n;
+	int ret = 0;
+	u8 val;
+	char rev_char;
+	const char *chip_name;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct si2165_state), GFP_KERNEL);
+	if (state == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	/* setup the state */
+	state->client = client;
+	state->i2c = client->adapter;
+	state->config.i2c_addr = client->addr;
+	state->config.chip_mode = pdata->chip_mode;
+	state->config.ref_freq_Hz = pdata->ref_freq_Hz;
+	state->config.inversion = pdata->inversion;
+
+	if (state->config.ref_freq_Hz < 4000000
+	    || state->config.ref_freq_Hz > 27000000) {
+		dev_err(&state->i2c->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
+			 KBUILD_MODNAME, state->config.ref_freq_Hz);
+		ret = -EINVAL;
+		goto error;
+	}
+
+	/* create dvb_frontend */
+	memcpy(&state->fe.ops, &si2165_ops,
+		sizeof(struct dvb_frontend_ops));
+	state->fe.ops.release = NULL;
+	state->fe.demodulator_priv = state;
+	i2c_set_clientdata(client, state);
+
+	/* powerup */
+	ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
+	if (ret < 0)
+		goto nodev_error;
+
+	ret = si2165_readreg8(state, 0x0000, &val);
+	if (ret < 0)
+		goto nodev_error;
+	if (val != state->config.chip_mode)
+		goto nodev_error;
+
+	ret = si2165_readreg8(state, 0x0023, &state->chip_revcode);
+	if (ret < 0)
+		goto nodev_error;
+
+	ret = si2165_readreg8(state, 0x0118, &state->chip_type);
+	if (ret < 0)
+		goto nodev_error;
+
+	/* powerdown */
+	ret = si2165_writereg8(state, 0x0000, SI2165_MODE_OFF);
+	if (ret < 0)
+		goto nodev_error;
+
+	if (state->chip_revcode < 26)
+		rev_char = 'A' + state->chip_revcode;
+	else
+		rev_char = '?';
+
+	switch (state->chip_type) {
+	case 0x06:
+		chip_name = "Si2161";
+		state->has_dvbt = true;
+		break;
+	case 0x07:
+		chip_name = "Si2165";
+		state->has_dvbt = true;
+		state->has_dvbc = true;
+		break;
+	default:
+		dev_err(&state->i2c->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
+			KBUILD_MODNAME, state->chip_type, state->chip_revcode);
+		goto nodev_error;
+	}
+
+	dev_info(&state->i2c->dev,
+		"%s: Detected Silicon Labs %s-%c (type %d, rev %d)\n",
+		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
+		state->chip_revcode);
+
+	strlcat(state->fe.ops.info.name, chip_name,
+			sizeof(state->fe.ops.info.name));
+
+	n = 0;
+	if (state->has_dvbt) {
+		state->fe.ops.delsys[n++] = SYS_DVBT;
+		strlcat(state->fe.ops.info.name, " DVB-T",
+			sizeof(state->fe.ops.info.name));
+	}
+	if (state->has_dvbc) {
+		state->fe.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
+		strlcat(state->fe.ops.info.name, " DVB-C",
+			sizeof(state->fe.ops.info.name));
+	}
+
+	/* return fe pointer */
+	*pdata->fe = &state->fe;
+
+	return 0;
+
+nodev_error:
+	ret = -ENODEV;
+error:
+	kfree(state);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int si2165_remove(struct i2c_client *client)
+{
+	struct si2165_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	kfree(state);
+	return 0;
+}
+
+static const struct i2c_device_id si2165_id_table[] = {
+	{"si2165", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, si2165_id_table);
+
+static struct i2c_driver si2165_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "si2165",
+	},
+	.probe		= si2165_probe,
+	.remove		= si2165_remove,
+	.id_table	= si2165_id_table,
+};
+
+module_i2c_driver(si2165_driver);
+
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
diff --git a/drivers/media/dvb-frontends/si2165.h b/drivers/media/dvb-frontends/si2165.h
index 8a15d6a..abbebc9 100644
--- a/drivers/media/dvb-frontends/si2165.h
+++ b/drivers/media/dvb-frontends/si2165.h
@@ -28,6 +28,28 @@ enum {
 	SI2165_MODE_PLL_XTAL = 0x21
 };
 
+/* I2C addresses
+ * possible values: 0x64,0x65,0x66,0x67
+ */
+struct si2165_platform_data {
+	/*
+	 * frontend
+	 * returned by driver
+	 */
+	struct dvb_frontend **fe;
+
+	/* external clock or XTAL */
+	u8 chip_mode;
+
+	/* frequency of external clock or xtal in Hz
+	 * possible values: 4000000, 16000000, 20000000, 240000000, 27000000
+	 */
+	u32 ref_freq_Hz;
+
+	/* invert the spectrum */
+	bool inversion;
+};
+
 struct si2165_config {
 	/* i2c addr
 	 * possible values: 0x64,0x65,0x66,0x67 */
-- 
2.9.2

