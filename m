Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:24757 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbZFEINo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 04:13:44 -0400
Date: Fri, 5 Jun 2009 10:13:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH] i2c: Don't advertise i2c functions when not available
Message-ID: <20090605101330.2f93e9ab@hyperion.delvare>
In-Reply-To: <20090602093431.GA19390@rakim.wolfsonmicro.main>
References: <20090527070850.GA11221@linux-sh.org>
	<20090527091831.26b60d6d@hyperion.delvare>
	<20090527120140.GC1970@sirena.org.uk>
	<20090602091229.0810f54b@hyperion.delvare>
	<20090602093431.GA19390@rakim.wolfsonmicro.main>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2 Jun 2009 10:34:32 +0100, Mark Brown wrote:
> On Tue, Jun 02, 2009 at 09:12:29AM +0200, Jean Delvare wrote:
> > What could be done, OTOH, is to surround all the function declarations
> > in <linux/i2c.h> with a simple #ifdef CONFIG_I2C, so that mistakes are
> > caught earlier (build time instead of link time.)
> 
> That'd be helpful, yes.

Here you go:

From: Jean Delvare <khali@linux-fr.org>
Subject: i2c: Don't advertise i2c functions when not available

Surround i2c function declarations with ifdefs, so that they aren't
advertised when i2c-core isn't actually built. That way, drivers using
these functions unconditionally will result in an immediate build
failure, rather than a late linking failure which is harder to figure
out.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 include/linux/i2c.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.30-rc8.orig/include/linux/i2c.h	2009-06-05 08:43:48.000000000 +0200
+++ linux-2.6.30-rc8/include/linux/i2c.h	2009-06-05 09:34:27.000000000 +0200
@@ -47,6 +47,7 @@ struct i2c_driver;
 union i2c_smbus_data;
 struct i2c_board_info;
 
+#if defined CONFIG_I2C || defined CONFIG_I2C_MODULE
 /*
  * The master routines are the ones normally used to transmit data to devices
  * on a bus (or read from them). Apart from two basic transfer functions to
@@ -93,6 +94,7 @@ extern s32 i2c_smbus_read_i2c_block_data
 extern s32 i2c_smbus_write_i2c_block_data(struct i2c_client *client,
 					  u8 command, u8 length,
 					  const u8 *values);
+#endif /* I2C */
 
 /**
  * struct i2c_driver - represent an I2C device driver
@@ -260,6 +262,7 @@ struct i2c_board_info {
 	.type = dev_type, .addr = (dev_addr)
 
 
+#if defined CONFIG_I2C || defined CONFIG_I2C_MODULE
 /* Add-on boards should register/unregister their devices; e.g. a board
  * with integrated I2C, a config eeprom, sensors, and a codec that's
  * used in conjunction with the primary hardware.
@@ -283,6 +286,7 @@ extern struct i2c_client *
 i2c_new_dummy(struct i2c_adapter *adap, u16 address);
 
 extern void i2c_unregister_device(struct i2c_client *);
+#endif /* I2C */
 
 /* Mainboard arch_initcall() code should register all its I2C devices.
  * This is done at arch_initcall time, before declaring any i2c adapters.
@@ -299,7 +303,7 @@ i2c_register_board_info(int busnum, stru
 {
 	return 0;
 }
-#endif
+#endif /* I2C_BOARDINFO */
 
 /*
  * The following structs are for those who like to implement new bus drivers:
@@ -394,6 +398,7 @@ struct i2c_client_address_data {
 
 /* administration...
  */
+#if defined CONFIG_I2C || defined CONFIG_I2C_MODULE
 extern int i2c_add_adapter(struct i2c_adapter *);
 extern int i2c_del_adapter(struct i2c_adapter *);
 extern int i2c_add_numbered_adapter(struct i2c_adapter *);
@@ -435,6 +440,7 @@ static inline int i2c_adapter_id(struct
 {
 	return adap->nr;
 }
+#endif /* I2C */
 #endif /* __KERNEL__ */
 
 /**



-- 
Jean Delvare
