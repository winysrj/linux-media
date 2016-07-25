Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35267 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbcGYKDB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 06:03:01 -0400
MIME-Version: 1.0
From: Stephen Backway <stev391@gmail.com>
Date: Mon, 25 Jul 2016 20:03:00 +1000
Message-ID: <CAMMNwaJEpVqnfD1T3EfbE9f+pxJ6vNVNza4DADXxrFJrA0M5Pw@mail.gmail.com>
Subject: [PATCH] cx23885: Add support for Hauppauge WinTV quadHD ATSC version
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support fo the Hauppauge WinTV quadHD ATSC version.
IR support has not been provided, all 4 tuners, demodulators etc are working.
Further documentation can be found on Linux TV wiki.

Signed-Off-by: Stephen Backway <stev391@gmail.com>

---

diff --git a/Documentation/video4linux/CARDLIST.cx23885
b/Documentation/video4linux/CARDLIST.cx23885
index c9b4959..fe2601e 100644
--- a/Documentation/video4linux/CARDLIST.cx23885
+++ b/Documentation/video4linux/CARDLIST.cx23885
@@ -55,3 +55,4 @@
  54 -> ViewCast 260e                                       [1576:0260]
  55 -> ViewCast 460e                                       [1576:0460]
  56 -> Hauppauge WinTV-quadHD (DVB)               [0070:6a28,0070:6b28]
+ 57 -> Hauppauge WinTV-quadHD (ATSC)              [0070:6a18,0070:6b18]
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c
b/drivers/media/pci/cx23885/cx23885-cards.c
index 4abf50f..99ba8d6 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -770,6 +770,11 @@ struct cx23885_board cx23885_boards[] = {
  .portb        = CX23885_MPEG_DVB,
  .portc        = CX23885_MPEG_DVB,
  },
+ [CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC] = {
+ .name        = "Hauppauge WinTV-QuadHD-ATSC",
+ .portb        = CX23885_MPEG_DVB,
+ .portc        = CX23885_MPEG_DVB,
+ },
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);

@@ -1073,6 +1078,14 @@ struct cx23885_subid cx23885_subids[] = {
  .subvendor = 0x0070,
  .subdevice = 0x6b28,
  .card      = CX23885_BOARD_HAUPPAUGE_QUADHD_DVB, /* Tuner Pair 2 */
+ }, {
+ .subvendor = 0x0070,
+ .subdevice = 0x6a18,
+ .card      = CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC, /* Tuner Pair 1 */
+ }, {
+ .subvendor = 0x0070,
+ .subdevice = 0x6b18,
+ .card      = CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC, /* Tuner Pair 2 */
  },
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1278,6 +1291,18 @@ static void hauppauge_eeprom(struct cx23885_dev
*dev, u8 *eeprom_data)
  /* WinTV-QuadHD (DVB) Tuner Pair 2 (PCIe, IR, half height,
    DVB-T/T2/C, DVB-T/T2/C */
  break;
+ case 165100:
+ /*
+ * WinTV-QuadHD (ATSC) Tuner Pair 1 (PCIe, IR, half height,
+ * ATSC, ATSC
+ */
+ break;
+ case 165101:
+ /*
+ * WinTV-QuadHD (DVB) Tuner Pair 2 (PCIe, IR, half height,
+ * ATSC, ATSC
+ */
+ break;
  default:
  printk(KERN_WARNING "%s: warning: "
  "unknown hauppauge model #%d\n",
@@ -1751,6 +1776,7 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
  break;
  case CX23885_BOARD_HAUPPAUGE_HVR5525:
  case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+ case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
  /*
  * HVR5525 GPIO Details:
  *  GPIO-00 IR_WIDE
@@ -1826,6 +1852,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
  case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
  case CX23885_BOARD_HAUPPAUGE_HVR1210:
  case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+ case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
  /* FIXME: Implement me */
  break;
  case CX23885_BOARD_HAUPPAUGE_HVR1270:
@@ -2025,6 +2052,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
  case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
  case CX23885_BOARD_HAUPPAUGE_HVR5525:
  case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+ case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
  if (dev->i2c_bus[0].i2c_rc == 0)
  hauppauge_eeprom(dev, eeprom+0xc0);
  break;
@@ -2171,6 +2199,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
  ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
  break;
  case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+ case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
  ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
  ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
  ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c
b/drivers/media/pci/cx23885/cx23885-dvb.c
index e5748a9..c5daa23 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -74,6 +74,7 @@
 #include "sp2.h"
 #include "m88ds3103.h"
 #include "m88rs6000t.h"
+#include "lgdt3306a.h"

 static unsigned int debug;

@@ -574,6 +575,30 @@ static struct stb6100_config prof_8000_stb6100_config = {
  .refclock = 27000000,
 };

+static struct lgdt3306a_config hauppauge_quadHD_ATSC_a_config = {
+ .i2c_addr               = 0x59,
+ .qam_if_khz             = 4000,
+ .vsb_if_khz             = 3250,
+ .deny_i2c_rptr          = 1, /* Disabled */
+ .spectral_inversion     = 0, /* Disabled */
+ .mpeg_mode              = LGDT3306A_MPEG_SERIAL,
+ .tpclk_edge             = LGDT3306A_TPCLK_RISING_EDGE,
+ .tpvalid_polarity       = LGDT3306A_TP_VALID_HIGH,
+ .xtalMHz                = 25, /* 24 or 25 */
+};
+
+static struct lgdt3306a_config hauppauge_quadHD_ATSC_b_config = {
+ .i2c_addr               = 0x0e,
+ .qam_if_khz             = 4000,
+ .vsb_if_khz             = 3250,
+ .deny_i2c_rptr          = 1, /* Disabled */
+ .spectral_inversion     = 0, /* Disabled */
+ .mpeg_mode              = LGDT3306A_MPEG_SERIAL,
+ .tpclk_edge             = LGDT3306A_TPCLK_RISING_EDGE,
+ .tpvalid_polarity       = LGDT3306A_TP_VALID_HIGH,
+ .xtalMHz                = 25, /* 24 or 25 */
+};
+
 static int p8000_set_voltage(struct dvb_frontend *fe,
      enum fe_sec_voltage voltage)
 {
@@ -2365,6 +2390,81 @@ static int dvb_register(struct cx23885_tsport *port)
  break;
  }
  break;
+ case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+ switch (port->nr) {
+ /* port b - Terrestrial/cable */
+ case 1:
+ /* attach frontend */
+ i2c_bus = &dev->i2c_bus[0];
+ fe0->dvb.frontend = dvb_attach(lgdt3306a_attach,
+ &hauppauge_quadHD_ATSC_a_config, &i2c_bus->i2c_adap);
+ if (fe0->dvb.frontend == NULL)
+ break;
+
+ /* attach tuner */
+ memset(&si2157_config, 0, sizeof(si2157_config));
+ si2157_config.fe = fe0->dvb.frontend;
+ si2157_config.if_port = 1;
+ si2157_config.inversion = 1;
+ memset(&info, 0, sizeof(struct i2c_board_info));
+ strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+ info.addr = 0x60;
+ info.platform_data = &si2157_config;
+ request_module("%s", info.type);
+ client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+ if (!client_tuner || !client_tuner->dev.driver) {
+ module_put(client_demod->dev.driver->owner);
+ i2c_unregister_device(client_demod);
+ port->i2c_client_demod = NULL;
+ goto frontend_detach;
+ }
+ if (!try_module_get(client_tuner->dev.driver->owner)) {
+ i2c_unregister_device(client_tuner);
+ module_put(client_demod->dev.driver->owner);
+ i2c_unregister_device(client_demod);
+ port->i2c_client_demod = NULL;
+ goto frontend_detach;
+ }
+ port->i2c_client_tuner = client_tuner;
+ break;
+
+ /* port c - terrestrial/cable */
+ case 2:
+ /* attach frontend */
+ i2c_bus = &dev->i2c_bus[0];
+ fe0->dvb.frontend = dvb_attach(lgdt3306a_attach,
+ &hauppauge_quadHD_ATSC_b_config, &i2c_bus->i2c_adap);
+ if (fe0->dvb.frontend == NULL)
+ break;
+
+ /* attach tuner */
+ memset(&si2157_config, 0, sizeof(si2157_config));
+ si2157_config.fe = fe0->dvb.frontend;
+ si2157_config.if_port = 1;
+ si2157_config.inversion = 1;
+ memset(&info, 0, sizeof(struct i2c_board_info));
+ strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+ info.addr = 0x62;
+ info.platform_data = &si2157_config;
+ request_module("%s", info.type);
+ client_tuner = i2c_new_device(&dev->i2c_bus[1].i2c_adap, &info);
+ if (!client_tuner || !client_tuner->dev.driver) {
+ module_put(client_demod->dev.driver->owner);
+ i2c_unregister_device(client_demod);
+ port->i2c_client_demod = NULL;
+ goto frontend_detach;
+ }
+ if (!try_module_get(client_tuner->dev.driver->owner)) {
+ i2c_unregister_device(client_tuner);
+ module_put(client_demod->dev.driver->owner);
+ i2c_unregister_device(client_demod);
+ port->i2c_client_demod = NULL;
+ goto frontend_detach;
+ }
+ port->i2c_client_tuner = client_tuner;
+ break;
+ }
+ break;

  default:
  printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
diff --git a/drivers/media/pci/cx23885/cx23885.h
b/drivers/media/pci/cx23885/cx23885.h
index 24a0a6c..2ebece9 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -103,7 +103,8 @@
 #define CX23885_BOARD_HAUPPAUGE_STARBURST      53
 #define CX23885_BOARD_VIEWCAST_260E            54
 #define CX23885_BOARD_VIEWCAST_460E            55
-#define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB    56
+#define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB     56
+#define CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC    57

 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
