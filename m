Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46718 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab0GCBra convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jul 2010 21:47:30 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 03 Jul 2010 02:47:23 +0100
Message-ID: <1278121643.4878.277.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH] V4L/DVB: mantis: Rename gpio_set_bits to
 mantis_gpio_set_bits
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is declared extern and exported, and should not be given
a generic name which may conflict with gpiolib in future.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/mantis/hopper_vp3028.c |    4 ++--
 drivers/media/dvb/mantis/mantis_core.c   |    2 +-
 drivers/media/dvb/mantis/mantis_dvb.c    |   14 +++++++-------
 drivers/media/dvb/mantis/mantis_ioc.c    |    4 ++--
 drivers/media/dvb/mantis/mantis_ioc.h    |    2 +-
 drivers/media/dvb/mantis/mantis_vp1034.c |    8 ++++----
 drivers/media/dvb/mantis/mantis_vp3030.c |    4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/dvb/mantis/hopper_vp3028.c b/drivers/media/dvb/mantis/hopper_vp3028.c
index 96674c7..d958449 100644
--- a/drivers/media/dvb/mantis/hopper_vp3028.c
+++ b/drivers/media/dvb/mantis/hopper_vp3028.c
@@ -47,11 +47,11 @@ static int vp3028_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 	struct mantis_hwconfig *config	= mantis->hwconfig;
 	int err = 0;
 
-	gpio_set_bits(mantis, config->reset, 0);
+	mantis_gpio_set_bits(mantis, config->reset, 0);
 	msleep(100);
 	err = mantis_frontend_power(mantis, POWER_ON);
 	msleep(100);
-	gpio_set_bits(mantis, config->reset, 1);
+	mantis_gpio_set_bits(mantis, config->reset, 1);
 
 	err = mantis_frontend_power(mantis, POWER_ON);
 	if (err == 0) {
diff --git a/drivers/media/dvb/mantis/mantis_core.c b/drivers/media/dvb/mantis/mantis_core.c
index 8113b23..1ac4d12 100644
--- a/drivers/media/dvb/mantis/mantis_core.c
+++ b/drivers/media/dvb/mantis/mantis_core.c
@@ -201,7 +201,7 @@ int mantis_core_exit(struct mantis_pci *mantis)
 }
 
 /* Turn the given bit on or off. */
-void gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
+void mantis_gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
 {
 	u32 cur;
 
diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index 99d82ee..a8e5719 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -47,15 +47,15 @@ int mantis_frontend_power(struct mantis_pci *mantis, enum mantis_power power)
 	switch (power) {
 	case POWER_ON:
 		dprintk(MANTIS_DEBUG, 1, "Power ON");
-		gpio_set_bits(mantis, config->power, POWER_ON);
+		mantis_gpio_set_bits(mantis, config->power, POWER_ON);
 		msleep(100);
-		gpio_set_bits(mantis, config->power, POWER_ON);
+		mantis_gpio_set_bits(mantis, config->power, POWER_ON);
 		msleep(100);
 		break;
 
 	case POWER_OFF:
 		dprintk(MANTIS_DEBUG, 1, "Power OFF");
-		gpio_set_bits(mantis, config->power, POWER_OFF);
+		mantis_gpio_set_bits(mantis, config->power, POWER_OFF);
 		msleep(100);
 		break;
 
@@ -73,13 +73,13 @@ void mantis_frontend_soft_reset(struct mantis_pci *mantis)
 	struct mantis_hwconfig *config = mantis->hwconfig;
 
 	dprintk(MANTIS_DEBUG, 1, "Frontend RESET");
-	gpio_set_bits(mantis, config->reset, 0);
+	mantis_gpio_set_bits(mantis, config->reset, 0);
 	msleep(100);
-	gpio_set_bits(mantis, config->reset, 0);
+	mantis_gpio_set_bits(mantis, config->reset, 0);
 	msleep(100);
-	gpio_set_bits(mantis, config->reset, 1);
+	mantis_gpio_set_bits(mantis, config->reset, 1);
 	msleep(100);
-	gpio_set_bits(mantis, config->reset, 1);
+	mantis_gpio_set_bits(mantis, config->reset, 1);
 	msleep(100);
 
 	return;
diff --git a/drivers/media/dvb/mantis/mantis_ioc.c b/drivers/media/dvb/mantis/mantis_ioc.c
index de148de..e97cb63 100644
--- a/drivers/media/dvb/mantis/mantis_ioc.c
+++ b/drivers/media/dvb/mantis/mantis_ioc.c
@@ -82,7 +82,7 @@ int mantis_get_mac(struct mantis_pci *mantis)
 EXPORT_SYMBOL_GPL(mantis_get_mac);
 
 /* Turn the given bit on or off. */
-void gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
+void mantis_gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
 {
 	u32 cur;
 
@@ -97,7 +97,7 @@ void gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value)
 	mmwrite(mantis->gpio_status, MANTIS_GPIF_ADDR);
 	mmwrite(0x00, MANTIS_GPIF_DOUT);
 }
-EXPORT_SYMBOL_GPL(gpio_set_bits);
+EXPORT_SYMBOL_GPL(mantis_gpio_set_bits);
 
 int mantis_stream_control(struct mantis_pci *mantis, enum mantis_stream_control stream_ctl)
 {
diff --git a/drivers/media/dvb/mantis/mantis_ioc.h b/drivers/media/dvb/mantis/mantis_ioc.h
index 188fe5a..d56e002 100644
--- a/drivers/media/dvb/mantis/mantis_ioc.h
+++ b/drivers/media/dvb/mantis/mantis_ioc.h
@@ -44,7 +44,7 @@ enum mantis_stream_control {
 };
 
 extern int mantis_get_mac(struct mantis_pci *mantis);
-extern void gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value);
+extern void mantis_gpio_set_bits(struct mantis_pci *mantis, u32 bitpos, u8 value);
 
 extern int mantis_stream_control(struct mantis_pci *mantis, enum mantis_stream_control stream_ctl);
 
diff --git a/drivers/media/dvb/mantis/mantis_vp1034.c b/drivers/media/dvb/mantis/mantis_vp1034.c
index 8e6ae55..b31fcb1 100644
--- a/drivers/media/dvb/mantis/mantis_vp1034.c
+++ b/drivers/media/dvb/mantis/mantis_vp1034.c
@@ -50,13 +50,13 @@ int vp1034_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 	switch (voltage) {
 	case SEC_VOLTAGE_13:
 		dprintk(MANTIS_ERROR, 1, "Polarization=[13V]");
-		gpio_set_bits(mantis, 13, 1);
-		gpio_set_bits(mantis, 14, 0);
+		mantis_gpio_set_bits(mantis, 13, 1);
+		mantis_gpio_set_bits(mantis, 14, 0);
 		break;
 	case SEC_VOLTAGE_18:
 		dprintk(MANTIS_ERROR, 1, "Polarization=[18V]");
-		gpio_set_bits(mantis, 13, 1);
-		gpio_set_bits(mantis, 14, 1);
+		mantis_gpio_set_bits(mantis, 13, 1);
+		mantis_gpio_set_bits(mantis, 14, 1);
 		break;
 	case SEC_VOLTAGE_OFF:
 		dprintk(MANTIS_ERROR, 1, "Frontend (dummy) POWERDOWN");
diff --git a/drivers/media/dvb/mantis/mantis_vp3030.c b/drivers/media/dvb/mantis/mantis_vp3030.c
index 1f43342..da39de0 100644
--- a/drivers/media/dvb/mantis/mantis_vp3030.c
+++ b/drivers/media/dvb/mantis/mantis_vp3030.c
@@ -59,11 +59,11 @@ static int vp3030_frontend_init(struct mantis_pci *mantis, struct dvb_frontend *
 	struct mantis_hwconfig *config	= mantis->hwconfig;
 	int err = 0;
 
-	gpio_set_bits(mantis, config->reset, 0);
+	mantis_gpio_set_bits(mantis, config->reset, 0);
 	msleep(100);
 	err = mantis_frontend_power(mantis, POWER_ON);
 	msleep(100);
-	gpio_set_bits(mantis, config->reset, 1);
+	mantis_gpio_set_bits(mantis, config->reset, 1);
 
 	if (err == 0) {
 		msleep(250);
-- 
1.7.1


