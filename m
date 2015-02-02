Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbBBPTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:19:53 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nibble Max <nibble.max@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>
Subject: [PATCHv2] [media] cx23885: move CI/MAC registration to a separate function
Date: Mon,  2 Feb 2015 13:19:43 -0200
Message-Id: <2b0aac3011bc7a9db27791bed4978554263ef079.1422890342.git.mchehab@osg.samsung.com>
In-Reply-To: <1419349687-17055-1-git-send-email-mchehab@osg.samsung.com>
References: <1419349687-17055-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/cx23885/cx23885-dvb.c:2080 dvb_register() Function too hairy.  Giving up.

This is indeed a too complex function, with lots of stuff inside.
Breaking this into two functions makes it a little bit less hairy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 351fa952f210..45fbe1e4d2d0 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1069,6 +1069,116 @@ static struct dib7000p_config dib7070p_dib7000p_config = {
 	.hostbus_diversity = 1,
 };
 
+static int dvb_register_ci_mac(struct cx23885_tsport *port)
+{
+	struct cx23885_dev *dev = port->dev;
+	struct i2c_client *client_ci = NULL;
+	struct vb2_dvb_frontend *fe0;
+
+	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
+	if (!fe0)
+		return -EINVAL;
+
+	switch (dev->board) {
+	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI: {
+		static struct netup_card_info cinfo;
+
+		netup_get_card_info(&dev->i2c_bus[0].i2c_adap, &cinfo);
+		memcpy(port->frontends.adapter.proposed_mac,
+				cinfo.port[port->nr - 1].mac, 6);
+		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC=%pM\n",
+			port->nr, port->frontends.adapter.proposed_mac);
+
+		netup_ci_init(port);
+		return 0;
+		}
+	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF: {
+		struct altera_ci_config netup_ci_cfg = {
+			.dev = dev,/* magic number to identify*/
+			.adapter = &port->frontends.adapter,/* for CI */
+			.demux = &fe0->dvb.demux,/* for hw pid filter */
+			.fpga_rw = netup_altera_fpga_rw,
+		};
+
+		altera_ci_init(&netup_ci_cfg, port->nr);
+		return 0;
+		}
+	case CX23885_BOARD_TEVII_S470: {
+		u8 eeprom[256]; /* 24C02 i2c eeprom */
+
+		if (port->nr != 1)
+			return 0;
+
+		/* Read entire EEPROM */
+		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, sizeof(eeprom));
+		printk(KERN_INFO "TeVii S470 MAC= %pM\n", eeprom + 0xa0);
+		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
+		return 0;
+		}
+	case CX23885_BOARD_DVBSKY_T9580:
+	case CX23885_BOARD_DVBSKY_S950:
+	case CX23885_BOARD_DVBSKY_S952:
+	case CX23885_BOARD_DVBSKY_T982: {
+		u8 eeprom[256]; /* 24C02 i2c eeprom */
+
+		if (port->nr > 2)
+			return 0;
+
+		/* Read entire EEPROM */
+		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
+				sizeof(eeprom));
+		printk(KERN_INFO "%s port %d MAC address: %pM\n",
+			cx23885_boards[dev->board].name, port->nr,
+			eeprom + 0xc0 + (port->nr-1) * 8);
+		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0 +
+			(port->nr-1) * 8, 6);
+		return 0;
+		}
+	case CX23885_BOARD_DVBSKY_S950C:
+	case CX23885_BOARD_DVBSKY_T980C:
+	case CX23885_BOARD_TT_CT2_4500_CI: {
+		u8 eeprom[256]; /* 24C02 i2c eeprom */
+		struct sp2_config sp2_config;
+		struct i2c_board_info info;
+		struct cx23885_i2c *i2c_bus2 = &dev->i2c_bus[1];
+
+		/* attach CI */
+		memset(&sp2_config, 0, sizeof(sp2_config));
+		sp2_config.dvb_adap = &port->frontends.adapter;
+		sp2_config.priv = port;
+		sp2_config.ci_control = cx23885_sp2_ci_ctrl;
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "sp2", I2C_NAME_SIZE);
+		info.addr = 0x40;
+		info.platform_data = &sp2_config;
+		request_module(info.type);
+		client_ci = i2c_new_device(&i2c_bus2->i2c_adap, &info);
+		if (client_ci == NULL || client_ci->dev.driver == NULL)
+			return -ENODEV;
+		if (!try_module_get(client_ci->dev.driver->owner)) {
+			i2c_unregister_device(client_ci);
+			return -ENODEV;
+		}
+		port->i2c_client_ci = client_ci;
+
+		if (port->nr != 1)
+			return 0;
+
+		/* Read entire EEPROM */
+		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
+				sizeof(eeprom));
+		printk(KERN_INFO "%s MAC address: %pM\n",
+			cx23885_boards[dev->board].name, eeprom + 0xc0);
+		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0, 6);
+		return 0;
+		}
+	}
+	return 0;
+}
+
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct dib7000p_ops dib7000p_ops;
@@ -1077,11 +1187,10 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
 	struct si2168_config si2168_config;
 	struct si2157_config si2157_config;
-	struct sp2_config sp2_config;
 	struct m88ts2022_config m88ts2022_config;
 	struct i2c_board_info info;
 	struct i2c_adapter *adapter;
-	struct i2c_client *client_demod = NULL, *client_tuner = NULL, *client_ci = NULL;
+	struct i2c_client *client_demod = NULL, *client_tuner = NULL;
 	const struct m88ds3103_config *p_m88ds3103_config = NULL;
 	int (*p_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage) = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
@@ -1812,17 +1921,11 @@ static int dvb_register(struct cx23885_tsport *port)
 			request_module(info.type);
 			client_tuner = i2c_new_device(adapter, &info);
 			if (client_tuner == NULL ||
-					client_tuner->dev.driver == NULL) {
-				module_put(client_demod->dev.driver->owner);
-				i2c_unregister_device(client_demod);
-				port->i2c_client_demod = NULL;
+					client_tuner->dev.driver == NULL)
 				goto frontend_detach;
-			}
+
 			if (!try_module_get(client_tuner->dev.driver->owner)) {
 				i2c_unregister_device(client_tuner);
-				module_put(client_demod->dev.driver->owner);
-				i2c_unregister_device(client_demod);
-				port->i2c_client_demod = NULL;
 				goto frontend_detach;
 			}
 			port->i2c_client_tuner = client_tuner;
@@ -1862,17 +1965,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &si2157_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
-		if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
-			module_put(client_demod->dev.driver->owner);
-			i2c_unregister_device(client_demod);
-			port->i2c_client_demod = NULL;
+		if (client_tuner == NULL ||
+				client_tuner->dev.driver == NULL)
 			goto frontend_detach;
-		}
 		if (!try_module_get(client_tuner->dev.driver->owner)) {
 			i2c_unregister_device(client_tuner);
-			module_put(client_demod->dev.driver->owner);
-			i2c_unregister_device(client_demod);
-			port->i2c_client_demod = NULL;
 			goto frontend_detach;
 		}
 		port->i2c_client_tuner = client_tuner;
@@ -2006,17 +2103,11 @@ static int dvb_register(struct cx23885_tsport *port)
 		info.platform_data = &si2157_config;
 		request_module(info.type);
 		client_tuner = i2c_new_device(adapter, &info);
-		if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
-			module_put(client_demod->dev.driver->owner);
-			i2c_unregister_device(client_demod);
-			port->i2c_client_demod = NULL;
+		if (client_tuner == NULL ||
+				client_tuner->dev.driver == NULL)
 			goto frontend_detach;
-		}
 		if (!try_module_get(client_tuner->dev.driver->owner)) {
 			i2c_unregister_device(client_tuner);
-			module_put(client_demod->dev.driver->owner);
-			i2c_unregister_device(client_demod);
-			port->i2c_client_demod = NULL;
 			goto frontend_detach;
 		}
 		port->i2c_client_tuner = client_tuner;
@@ -2144,122 +2235,29 @@ static int dvb_register(struct cx23885_tsport *port)
 	if (ret)
 		goto frontend_detach;
 
-	/* init CI & MAC */
-	switch (dev->board) {
-	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI: {
-		static struct netup_card_info cinfo;
+	ret = dvb_register_ci_mac(port);
+	if (ret)
+		goto frontend_detach;
 
-		netup_get_card_info(&dev->i2c_bus[0].i2c_adap, &cinfo);
-		memcpy(port->frontends.adapter.proposed_mac,
-				cinfo.port[port->nr - 1].mac, 6);
-		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC=%pM\n",
-			port->nr, port->frontends.adapter.proposed_mac);
-
-		netup_ci_init(port);
-		break;
-		}
-	case CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF: {
-		struct altera_ci_config netup_ci_cfg = {
-			.dev = dev,/* magic number to identify*/
-			.adapter = &port->frontends.adapter,/* for CI */
-			.demux = &fe0->dvb.demux,/* for hw pid filter */
-			.fpga_rw = netup_altera_fpga_rw,
-		};
-
-		altera_ci_init(&netup_ci_cfg, port->nr);
-		break;
-		}
-	case CX23885_BOARD_TEVII_S470: {
-		u8 eeprom[256]; /* 24C02 i2c eeprom */
-
-		if (port->nr != 1)
-			break;
-
-		/* Read entire EEPROM */
-		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
-		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, sizeof(eeprom));
-		printk(KERN_INFO "TeVii S470 MAC= %pM\n", eeprom + 0xa0);
-		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
-		break;
-		}
-	case CX23885_BOARD_DVBSKY_T9580:
-	case CX23885_BOARD_DVBSKY_S950:
-	case CX23885_BOARD_DVBSKY_S952:
-	case CX23885_BOARD_DVBSKY_T982: {
-		u8 eeprom[256]; /* 24C02 i2c eeprom */
-
-		if (port->nr > 2)
-			break;
-
-		/* Read entire EEPROM */
-		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
-		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
-				sizeof(eeprom));
-		printk(KERN_INFO "%s port %d MAC address: %pM\n",
-			cx23885_boards[dev->board].name, port->nr,
-			eeprom + 0xc0 + (port->nr-1) * 8);
-		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0 +
-			(port->nr-1) * 8, 6);
-		break;
-		}
-	case CX23885_BOARD_DVBSKY_S950C:
-	case CX23885_BOARD_DVBSKY_T980C:
-	case CX23885_BOARD_TT_CT2_4500_CI: {
-		u8 eeprom[256]; /* 24C02 i2c eeprom */
-
-		/* attach CI */
-		memset(&sp2_config, 0, sizeof(sp2_config));
-		sp2_config.dvb_adap = &port->frontends.adapter;
-		sp2_config.priv = port;
-		sp2_config.ci_control = cx23885_sp2_ci_ctrl;
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "sp2", I2C_NAME_SIZE);
-		info.addr = 0x40;
-		info.platform_data = &sp2_config;
-		request_module(info.type);
-		client_ci = i2c_new_device(&i2c_bus2->i2c_adap, &info);
-		if (client_ci == NULL || client_ci->dev.driver == NULL) {
-			if (client_tuner) {
-				module_put(client_tuner->dev.driver->owner);
-				i2c_unregister_device(client_tuner);
-			}
-			if (client_demod) {
-				module_put(client_demod->dev.driver->owner);
-				i2c_unregister_device(client_demod);
-			}
-			goto frontend_detach;
-		}
-		if (!try_module_get(client_ci->dev.driver->owner)) {
-			i2c_unregister_device(client_ci);
-			if (client_tuner) {
-				module_put(client_tuner->dev.driver->owner);
-				i2c_unregister_device(client_tuner);
-			}
-			if (client_demod) {
-				module_put(client_demod->dev.driver->owner);
-				i2c_unregister_device(client_demod);
-			}
-			goto frontend_detach;
-		}
-		port->i2c_client_ci = client_ci;
-
-		if (port->nr != 1)
-			break;
-
-		/* Read entire EEPROM */
-		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
-		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
-				sizeof(eeprom));
-		printk(KERN_INFO "%s MAC address: %pM\n",
-			cx23885_boards[dev->board].name, eeprom + 0xc0);
-		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0, 6);
-		break;
-		}
-	}
-
-	return ret;
+	return 0;
 
 frontend_detach:
+	/* remove I2C client for tuner */
+	client_tuner = port->i2c_client_tuner;
+	if (client_tuner) {
+		module_put(client_tuner->dev.driver->owner);
+		i2c_unregister_device(client_tuner);
+		port->i2c_client_tuner = NULL;
+	}
+
+	/* remove I2C client for demodulator */
+	client_demod = port->i2c_client_demod;
+	if (client_demod) {
+		module_put(client_demod->dev.driver->owner);
+		i2c_unregister_device(client_demod);
+		port->i2c_client_demod = NULL;
+	}
+
 	port->gate_ctrl = NULL;
 	vb2_dvb_dealloc_frontends(&port->frontends);
 	return -EINVAL;
-- 
2.1.0

