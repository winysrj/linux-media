Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53870 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaI2HpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 03:45:15 -0400
Received: by mail-lb0-f171.google.com with SMTP id l4so17352475lbv.16
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 00:45:13 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 5/5] cx23855: add CI support for DVBSky T980C
Date: Mon, 29 Sep 2014 10:44:20 +0300
Message-Id: <1411976660-19329-5-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CI support for DVBSky T980C.

I used the new host device independent CIMaX SP2 I2C driver to implement it.

cx23885_sp2_ci_ctrl function is borrowed entirely from cimax2.c.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 105 +++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index cc88997..70dbcd6 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -71,6 +71,7 @@
 #include "si2165.h"
 #include "si2168.h"
 #include "si2157.h"
+#include "sp2.h"
 #include "m88ds3103.h"
 #include "m88ts2022.h"
 
@@ -616,6 +617,76 @@ static int dvbsky_t9580_set_voltage(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int cx23885_sp2_ci_ctrl(void *priv, u8 read, int addr,
+				u8 data, int *mem)
+{
+
+	/* MC417 */
+	#define SP2_DATA              0x000000ff
+	#define SP2_WR                0x00008000
+	#define SP2_RD                0x00004000
+	#define SP2_ACK               0x00001000
+	#define SP2_ADHI              0x00000800
+	#define SP2_ADLO              0x00000400
+	#define SP2_CS1               0x00000200
+	#define SP2_CS0               0x00000100
+	#define SP2_EN_ALL            0x00001000
+	#define SP2_CTRL_OFF          (SP2_CS1 | SP2_CS0 | SP2_WR | SP2_RD)
+
+	struct cx23885_tsport *port = priv;
+	struct cx23885_dev *dev = port->dev;
+	int ret;
+	int tmp;
+	unsigned long timeout;
+
+	mutex_lock(&dev->gpio_lock);
+
+	/* write addr */
+	cx_write(MC417_OEN, SP2_EN_ALL);
+	cx_write(MC417_RWD, SP2_CTRL_OFF |
+				SP2_ADLO | (0xff & addr));
+	cx_clear(MC417_RWD, SP2_ADLO);
+	cx_write(MC417_RWD, SP2_CTRL_OFF |
+				SP2_ADHI | (0xff & (addr >> 8)));
+	cx_clear(MC417_RWD, SP2_ADHI);
+
+	if (read) { /* data in */
+		cx_write(MC417_OEN, SP2_EN_ALL | SP2_DATA);
+	} else /* data out */
+		cx_write(MC417_RWD, SP2_CTRL_OFF | data);
+
+	/* chip select 0 */
+	cx_clear(MC417_RWD, SP2_CS0);
+
+	/* read/write */
+	cx_clear(MC417_RWD, (read) ? SP2_RD : SP2_WR);
+
+	timeout = jiffies + msecs_to_jiffies(1);
+	for (;;) {
+		tmp = cx_read(MC417_RWD);
+		if ((tmp & SP2_ACK) == 0)
+			break;
+		if (time_after(jiffies, timeout))
+			break;
+		udelay(1);
+	}
+
+	cx_set(MC417_RWD, SP2_CTRL_OFF);
+	*mem = tmp & 0xff;
+
+	mutex_unlock(&dev->gpio_lock);
+
+	if (!read)
+		if (*mem < 0) {
+			ret = -EREMOTEIO;
+			goto err;
+		}
+
+	return 0;
+err:
+	return ret;
+}
+
 static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -944,11 +1015,11 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
 	struct si2168_config si2168_config;
 	struct si2157_config si2157_config;
+	struct sp2_config sp2_config;
 	struct m88ts2022_config m88ts2022_config;
 	struct i2c_board_info info;
 	struct i2c_adapter *adapter;
-	struct i2c_client *client_demod;
-	struct i2c_client *client_tuner;
+	struct i2c_client *client_demod, *client_tuner, *client_ci;
 	int mfe_shared = 0; /* bus not shared by default */
 	int ret;
 
@@ -1683,6 +1754,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 	case CX23885_BOARD_DVBSKY_T980C:
 		i2c_bus = &dev->i2c_bus[1];
+		i2c_bus2 = &dev->i2c_bus[0];
 
 		/* attach frontend */
 		memset(&si2168_config, 0, sizeof(si2168_config));
@@ -1820,6 +1892,35 @@ static int dvb_register(struct cx23885_tsport *port)
 	case CX23885_BOARD_DVBSKY_T980C: {
 		u8 eeprom[256]; /* 24C02 i2c eeprom */
 
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
+		if (client_ci == NULL ||
+				client_ci->dev.driver == NULL) {
+			module_put(client_tuner->dev.driver->owner);
+			i2c_unregister_device(client_tuner);
+			module_put(client_demod->dev.driver->owner);
+			i2c_unregister_device(client_demod);
+			goto frontend_detach;
+		}
+		if (!try_module_get(client_ci->dev.driver->owner)) {
+			i2c_unregister_device(client_ci);
+			module_put(client_tuner->dev.driver->owner);
+			i2c_unregister_device(client_tuner);
+			module_put(client_demod->dev.driver->owner);
+			i2c_unregister_device(client_demod);
+			goto frontend_detach;
+		}
+		port->i2c_client_ci = client_ci;
+
 		if (port->nr != 1)
 			break;
 
-- 
1.9.1

