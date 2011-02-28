Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:51672 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1B1LDP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:03:15 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v20 1/3] MFD: Wl1273 FM radio core: Add I2C IO functions.
Date: Mon, 28 Feb 2011 13:02:29 +0200
Message-Id: <1298890951-23339-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1298890951-23339-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1298890951-23339-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add I2C IO functions.
Change the IO operation from read to write in wl1273_fm_set_volume.
Update the year of the copyright statement.
Remove two unnecessary calls to i2c_set_clientdata.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/mfd/Kconfig             |    2 +-
 drivers/mfd/wl1273-core.c       |  149 ++++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/wl1273-core.h |    2 +
 3 files changed, 149 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fd01836..9db079b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -615,7 +615,7 @@ config MFD_VX855
 	  and/or vx855_gpio drivers for this to do anything useful.
 
 config MFD_WL1273_CORE
-	tristate
+	tristate "Support for TI WL1273 FM radio."
 	depends on I2C
 	select MFD_CORE
 	default n
diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index d2ecc24..4025a4b 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -1,7 +1,7 @@
 /*
  * MFD driver for wl1273 FM radio and audio codec submodules.
  *
- * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2011 Nokia Corporation
  * Author: Matti Aaltonen <matti.j.aaltonen@nokia.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -31,6 +31,145 @@ static struct i2c_device_id wl1273_driver_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, wl1273_driver_id_table);
 
+static int wl1273_fm_read_reg(struct wl1273_core *core, u8 reg, u16 *value)
+{
+	struct i2c_client *client = core->client;
+	u8 b[2];
+	int r;
+
+	r = i2c_smbus_read_i2c_block_data(client, reg, sizeof(b), b);
+	if (r != 2) {
+		dev_err(&client->dev, "%s: Read: %d fails.\n", __func__, reg);
+		return -EREMOTEIO;
+	}
+
+	*value = (u16)b[0] << 8 | b[1];
+
+	return 0;
+}
+
+static int wl1273_fm_write_cmd(struct wl1273_core *core, u8 cmd, u16 param)
+{
+	struct i2c_client *client = core->client;
+	u8 buf[] = { (param >> 8) & 0xff, param & 0xff };
+	int r;
+
+	r = i2c_smbus_write_i2c_block_data(client, cmd, sizeof(buf), buf);
+	if (r) {
+		dev_err(&client->dev, "%s: Cmd: %d fails.\n", __func__, cmd);
+		return r;
+	}
+
+	return 0;
+}
+
+static int wl1273_fm_write_data(struct wl1273_core *core, u8 *data, u16 len)
+{
+	struct i2c_client *client = core->client;
+	struct i2c_msg msg;
+	int r;
+
+	msg.addr = client->addr;
+	msg.flags = 0;
+	msg.buf = data;
+	msg.len = len;
+
+	r = i2c_transfer(client->adapter, &msg, 1);
+	if (r != 1) {
+		dev_err(&client->dev, "%s: write error.\n", __func__);
+		return -EREMOTEIO;
+	}
+
+	return 0;
+}
+
+/**
+ * wl1273_fm_set_audio() -	Set audio mode.
+ * @core:			A pointer to the device struct.
+ * @new_mode:			The new audio mode.
+ *
+ * Audio modes are WL1273_AUDIO_DIGITAL and WL1273_AUDIO_ANALOG.
+ */
+static int wl1273_fm_set_audio(struct wl1273_core *core, unsigned int new_mode)
+{
+	int r = 0;
+
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
+		return -EPERM;
+
+	if (core->mode == WL1273_MODE_RX && new_mode == WL1273_AUDIO_DIGITAL) {
+		r = wl1273_fm_write_cmd(core, WL1273_PCM_MODE_SET,
+					WL1273_PCM_DEF_MODE);
+		if (r)
+			goto out;
+
+		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
+					core->i2s_mode);
+		if (r)
+			goto out;
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
+					WL1273_AUDIO_ENABLE_I2S);
+		if (r)
+			goto out;
+
+	} else if (core->mode == WL1273_MODE_RX &&
+		   new_mode == WL1273_AUDIO_ANALOG) {
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
+					WL1273_AUDIO_ENABLE_ANALOG);
+		if (r)
+			goto out;
+
+	} else if (core->mode == WL1273_MODE_TX &&
+		   new_mode == WL1273_AUDIO_DIGITAL) {
+		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
+					core->i2s_mode);
+		if (r)
+			goto out;
+
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
+					WL1273_AUDIO_IO_SET_I2S);
+		if (r)
+			goto out;
+
+	} else if (core->mode == WL1273_MODE_TX &&
+		   new_mode == WL1273_AUDIO_ANALOG) {
+		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
+					WL1273_AUDIO_IO_SET_ANALOG);
+		if (r)
+			goto out;
+	}
+
+	core->audio_mode = new_mode;
+out:
+	return r;
+}
+
+/**
+ * wl1273_fm_set_volume() -	Set volume.
+ * @core:			A pointer to the device struct.
+ * @volume:			The new volume value.
+ */
+static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
+{
+	u16 val;
+	int r;
+
+	if (volume > WL1273_MAX_VOLUME)
+		return -EINVAL;
+
+	if (core->volume == volume)
+		return 0;
+
+	r = wl1273_fm_write_cmd(core, WL1273_VOLUME_SET, volume);
+	if (r)
+		return r;
+
+	core->volume = volume;
+	return 0;
+}
+
 static int wl1273_core_remove(struct i2c_client *client)
 {
 	struct wl1273_core *core = i2c_get_clientdata(client);
@@ -38,7 +177,6 @@ static int wl1273_core_remove(struct i2c_client *client)
 	dev_dbg(&client->dev, "%s\n", __func__);
 
 	mfd_remove_devices(&client->dev);
-	i2c_set_clientdata(client, NULL);
 	kfree(core);
 
 	return 0;
@@ -83,6 +221,12 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 	cell->data_size = sizeof(core);
 	children++;
 
+	core->read = wl1273_fm_read_reg;
+	core->write = wl1273_fm_write_cmd;
+	core->write_data = wl1273_fm_write_data;
+	core->set_audio = wl1273_fm_set_audio;
+	core->set_volume = wl1273_fm_set_volume;
+
 	if (pdata->children & WL1273_CODEC_CHILD) {
 		cell = &core->cells[children];
 
@@ -104,7 +248,6 @@ static int __devinit wl1273_core_probe(struct i2c_client *client,
 	return 0;
 
 err:
-	i2c_set_clientdata(client, NULL);
 	pdata->free_resources();
 	kfree(core);
 
diff --git a/include/linux/mfd/wl1273-core.h b/include/linux/mfd/wl1273-core.h
index 9787293..db2f3f4 100644
--- a/include/linux/mfd/wl1273-core.h
+++ b/include/linux/mfd/wl1273-core.h
@@ -280,7 +280,9 @@ struct wl1273_core {
 
 	struct i2c_client *client;
 
+	int (*read)(struct wl1273_core *core, u8, u16 *);
 	int (*write)(struct wl1273_core *core, u8, u16);
+	int (*write_data)(struct wl1273_core *core, u8 *, u16);
 	int (*set_audio)(struct wl1273_core *core, unsigned int);
 	int (*set_volume)(struct wl1273_core *core, unsigned int);
 };
-- 
1.6.1.3

