Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46062 "EHLO
        homiemail-a125.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751383AbeDRQMM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 12:12:12 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/5] lgdt3306a v4.6 i2c mux backport
Date: Wed, 18 Apr 2018 11:12:06 -0500
Message-Id: <1524067927-12113-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
References: <1524067927-12113-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Based on other included backports.

Includes unlocked i2c gate control callbacks.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 backports/v4.6_i2c_mux.patch | 213 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 213 insertions(+)

diff --git a/backports/v4.6_i2c_mux.patch b/backports/v4.6_i2c_mux.patch
index 8f1ab88..ce89faa 100644
--- a/backports/v4.6_i2c_mux.patch
+++ b/backports/v4.6_i2c_mux.patch
@@ -1455,3 +1455,216 @@ index c76e78f..5c805f8 100644
  		pdata.dvb_frontend = adap->fe[0];
  		pdata.dvb_usb_device = d;
  		pdata.v4l2_subdev = subdev;
+diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
+index ab16d3a..2988262 100644
+--- a/drivers/media/dvb-frontends/lgdt3306a.c
++++ b/drivers/media/dvb-frontends/lgdt3306a.c
+@@ -79,8 +79,6 @@ struct lgdt3306a_state {
+ 	enum fe_modulation current_modulation;
+ 	u32 current_frequency;
+ 	u32 snr;
+-
+-	struct i2c_mux_core *muxc;
+ };
+ 
+ /*
+@@ -2182,20 +2180,142 @@ static const struct dvb_frontend_ops lgdt3306a_ops = {
+ 	.search               = lgdt3306a_search,
+ };
+ 
+-static int lgdt3306a_select(struct i2c_mux_core *muxc, u32 chan)
++/*
++ * I2C gate logic
++ * We must use unlocked I2C I/O because I2C adapter lock is already taken
++ * by the caller (usually tuner driver).
++ * select/unselect are unlocked versions of lgdt3306a_i2c_gate_ctrl
++ */
++static int lgdt3306a_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+ {
+-	struct i2c_client *client = i2c_mux_priv(muxc);
+-	struct lgdt3306a_state *state = i2c_get_clientdata(client);
++	struct i2c_client *client = mux_priv;
++	int ret;
++	u8 val;
++	u8 buf[3];
++
++	struct i2c_msg read_msg_1 = {
++		.addr = client->addr,
++		.flags = 0,
++		.buf = "\x00\x02",
++		.len = 2,
++	};
++	struct i2c_msg read_msg_2 = {
++		.addr = client->addr,
++		.flags = I2C_M_RD,
++		.buf = &val,
++		.len = 1,
++	};
++
++	struct i2c_msg write_msg = {
++		.addr = client->addr,
++		.flags = 0,
++		.len = 3,
++		.buf = buf,
++	};
++
++	ret = __i2c_transfer(client->adapter, &read_msg_1, 1);
++	if (ret != 1)
++	{
++		pr_err("error (addr %02x reg 0x002 error (ret == %i)\n",
++		       client->addr, ret);
++		if (ret < 0)
++			return ret;
++		else
++			return -EREMOTEIO;
++	}
+ 
+-	return lgdt3306a_i2c_gate_ctrl(&state->frontend, 1);
++	ret = __i2c_transfer(client->adapter, &read_msg_2, 1);
++	if (ret != 1)
++	{
++		pr_err("error (addr %02x reg 0x002 error (ret == %i)\n",
++		       client->addr, ret);
++		if (ret < 0)
++			return ret;
++		else
++			return -EREMOTEIO;
++	}
++
++	buf[0] = 0x00;
++	buf[1] = 0x02;
++	val &= 0x7F;
++	val |= LG3306_TUNERI2C_ON;
++	buf[2] = val;
++	ret = __i2c_transfer(client->adapter, &write_msg, 1);
++	if (ret != 1) {
++		pr_err("error (addr %02x %02x <- %02x, err = %i)\n",
++		       write_msg.buf[0], write_msg.buf[1], write_msg.buf[2], ret);
++		if (ret < 0)
++			return ret;
++		else
++			return -EREMOTEIO;
++	}
++	return 0;
+ }
+ 
+-static int lgdt3306a_deselect(struct i2c_mux_core *muxc, u32 chan)
++static int lgdt3306a_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+ {
+-	struct i2c_client *client = i2c_mux_priv(muxc);
+-	struct lgdt3306a_state *state = i2c_get_clientdata(client);
++	struct i2c_client *client = mux_priv;
++	int ret;
++	u8 val;
++	u8 buf[3];
++
++	struct i2c_msg read_msg_1 = {
++		.addr = client->addr,
++		.flags = 0,
++		.buf = "\x00\x02",
++		.len = 2,
++	};
++	struct i2c_msg read_msg_2 = {
++		.addr = client->addr,
++		.flags = I2C_M_RD,
++		.buf = &val,
++		.len = 1,
++	};
+ 
+-	return lgdt3306a_i2c_gate_ctrl(&state->frontend, 0);
++	struct i2c_msg write_msg = {
++		.addr = client->addr,
++		.flags = 0,
++		.len = 3,
++		.buf = buf,
++	};
++
++	ret = __i2c_transfer(client->adapter, &read_msg_1, 1);
++	if (ret != 1)
++	{
++		pr_err("error (addr %02x reg 0x002 error (ret == %i)\n",
++		       client->addr, ret);
++		if (ret < 0)
++			return ret;
++		else
++			return -EREMOTEIO;
++	}
++
++	ret = __i2c_transfer(client->adapter, &read_msg_2, 1);
++	if (ret != 1)
++	{
++		pr_err("error (addr %02x reg 0x002 error (ret == %i)\n",
++		       client->addr, ret);
++		if (ret < 0)
++			return ret;
++		else
++			return -EREMOTEIO;
++	}
++
++	buf[0] = 0x00;
++	buf[1] = 0x02;
++	val &= 0x7F;
++	val |= LG3306_TUNERI2C_OFF;
++	buf[2] = val;
++	ret = __i2c_transfer(client->adapter, &write_msg, 1);
++	if (ret != 1) {
++		pr_err("error (addr %02x %02x <- %02x, err = %i)\n",
++		       write_msg.buf[0], write_msg.buf[1], write_msg.buf[2], ret);
++		if (ret < 0)
++			return ret;
++		else
++			return -EREMOTEIO;
++	}
++	return 0;
+ }
+ 
+ static int lgdt3306a_probe(struct i2c_client *client,
+@@ -2227,21 +2347,16 @@ static int lgdt3306a_probe(struct i2c_client *client,
+ 	state->frontend.ops.release = NULL;
+ 
+ 	/* create mux i2c adapter for tuner */
+-	state->muxc = i2c_mux_alloc(client->adapter, &client->dev,
+-				  1, 0, I2C_MUX_LOCKED,
+-				  lgdt3306a_select, lgdt3306a_deselect);
+-	if (!state->muxc) {
+-		ret = -ENOMEM;
++	state->i2c_adap = i2c_add_mux_adapter(client->adapter, &client->dev,
++			client, 0, 0, 0, lgdt3306a_select, lgdt3306a_deselect);
++	if (state->i2c_adap == NULL) {
++		ret = -ENODEV;
+ 		goto err_kfree;
+ 	}
+-	state->muxc->priv = client;
+-	ret = i2c_mux_add_adapter(state->muxc, 0, 0, 0);
+-	if (ret)
+-		goto err_kfree;
+ 
+ 	/* create dvb_frontend */
+ 	fe->ops.i2c_gate_ctrl = NULL;
+-	*config->i2c_adapter = state->muxc->adapter[0];
++	*config->i2c_adapter = state->i2c_adap;
+ 	*config->fe = fe;
+ 
+ 	dev_info(&client->dev, "LG Electronics LGDT3306A successfully identified\n");
+@@ -2261,7 +2376,7 @@ static int lgdt3306a_remove(struct i2c_client *client)
+ {
+ 	struct lgdt3306a_state *state = i2c_get_clientdata(client);
+ 
+-	i2c_mux_del_adapters(state->muxc);
++	i2c_del_mux_adapter(state->i2c_adap);
+ 
+ 	state->frontend.ops.release = NULL;
+ 	state->frontend.demodulator_priv = NULL;
+diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
+index 8b53044..99b28be 100644
+--- a/drivers/media/dvb-frontends/lgdt3306a.h
++++ b/drivers/media/dvb-frontends/lgdt3306a.h
+@@ -21,6 +21,8 @@
+ #include <linux/i2c.h>
+ #include <media/dvb_frontend.h>
+ 
++#define LG3306_TUNERI2C_ON  0x00
++#define LG3306_TUNERI2C_OFF 0x80
+ 
+ enum lgdt3306a_mpeg_mode {
+ 	LGDT3306A_MPEG_PARALLEL = 0,
-- 
2.7.4
