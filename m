Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaCCKIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:04 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 66/79] [media] drx-j: get rid of function prototypes at drx_dap_fasi.c
Date: Mon,  3 Mar 2014 07:07:00 -0300
Message-Id: <1393841233-24840-67-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorder functions and data at drx_dap_fasi.c, in order to avoid
having function prototypes.

This is in preparation to merge this code inside drxj, removing
some duplicated bits there, and getting rid of yet another
abstraction layer.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    | 178 +++++++--------------
 1 file changed, 59 insertions(+), 119 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index b81b4f9cd4b0..3e456ba780eb 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -47,82 +47,6 @@
 
 /*============================================================================*/
 
-/* Function prototypes */
-static int drxdap_fasi_write_block(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					  u32 addr,	/* address of register/memory   */
-					  u16 datasize,	/* size of data                 */
-					  u8 *data,	/* data to send                 */
-					  u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 u32 addr,	/* address of register/memory   */
-					 u16 datasize,	/* size of data                 */
-					 u8 *data,	/* data to send                 */
-					 u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_write_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 u32 addr,	/* address of register          */
-					 u8 data,	/* data to write                */
-					 u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					u32 addr,	/* address of register          */
-					u8 *data,	/* buffer to receive data       */
-					u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_modify_write_reg8(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						   u32 waddr,	/* address of register          */
-						   u32 raddr,	/* address to read back from    */
-						   u8 datain,	/* data to send                 */
-						   u8 *dataout);	/* data to receive back         */
-
-static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					  u32 addr,	/* address of register          */
-					  u16 data,	/* data to write                */
-					  u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_reg16(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 u32 addr,	/* address of register          */
-					 u16 *data,	/* buffer to receive data       */
-					 u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						    u32 waddr,	/* address of register          */
-						    u32 raddr,	/* address to read back from    */
-						    u16 datain,	/* data to send                 */
-						    u16 *dataout);	/* data to receive back         */
-
-static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					  u32 addr,	/* address of register          */
-					  u32 data,	/* data to write                */
-					  u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-					 u32 addr,	/* address of register          */
-					 u32 *data,	/* buffer to receive data       */
-					 u32 flags);	/* special device flags         */
-
-static int drxdap_fasi_read_modify_write_reg32(struct i2c_device_addr *dev_addr,	/* address of I2C device        */
-						    u32 waddr,	/* address of register          */
-						    u32 raddr,	/* address to read back from    */
-						    u32 datain,	/* data to send                 */
-						    u32 *dataout);	/* data to receive back         */
-
-/* The structure containing the protocol interface */
-struct drx_access_func drx_dap_fasi_funct_g = {
-	drxdap_fasi_write_block,	/* Supported */
-	drxdap_fasi_read_block,	/* Supported */
-	drxdap_fasi_write_reg8,	/* Not supported */
-	drxdap_fasi_read_reg8,	/* Not supported */
-	drxdap_fasi_read_modify_write_reg8,	/* Not supported */
-	drxdap_fasi_write_reg16,	/* Supported */
-	drxdap_fasi_read_reg16,	/* Supported */
-	drxdap_fasi_read_modify_write_reg16,	/* Supported */
-	drxdap_fasi_write_reg32,	/* Supported */
-	drxdap_fasi_read_reg32,	/* Supported */
-	drxdap_fasi_read_modify_write_reg32	/* Not supported */
-};
-
 /*============================================================================*/
 
 /* Functions not supported by protocol*/
@@ -346,49 +270,6 @@ static int drxdap_fasi_read_block(struct i2c_device_addr *dev_addr,
 	return rc;
 }
 
-/******************************
-*
-* int drxdap_fasi_read_modify_write_reg16 (
-*      struct i2c_device_addr *dev_addr,   -- address of I2C device
-*      u32 waddr,     -- address of chip register/memory
-*      u32 raddr,     -- chip address to read back from
-*      u16            wdata,     -- data to send
-*      u16 *rdata)     -- data to receive back
-*
-* Write 16-bit data, then read back the original contents of that location.
-* Requires long addressing format to be allowed.
-*
-* Before sending data, the data is converted to little endian. The
-* data received back is converted back to the target platform's endianness.
-*
-* WARNING: This function is only guaranteed to work if there is one
-* master on the I2C bus.
-*
-* Output:
-* - 0     if reading was successful
-*                  in that case: read back data is at *rdata
-* - -EIO  if anything went wrong
-*
-******************************/
-
-static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
-						    u32 waddr,
-						    u32 raddr,
-						    u16 wdata, u16 *rdata)
-{
-	int rc = -EIO;
-
-#if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
-	if (rdata == NULL)
-		return -EINVAL;
-
-	rc = drxdap_fasi_write_reg16(dev_addr, waddr, wdata, DRXDAP_FASI_RMW);
-	if (rc == 0)
-		rc = drxdap_fasi_read_reg16(dev_addr, raddr, rdata, 0);
-#endif
-
-	return rc;
-}
 
 /******************************
 *
@@ -628,6 +509,50 @@ static int drxdap_fasi_write_reg16(struct i2c_device_addr *dev_addr,
 
 /******************************
 *
+* int drxdap_fasi_read_modify_write_reg16 (
+*      struct i2c_device_addr *dev_addr,   -- address of I2C device
+*      u32 waddr,     -- address of chip register/memory
+*      u32 raddr,     -- chip address to read back from
+*      u16            wdata,     -- data to send
+*      u16 *rdata)     -- data to receive back
+*
+* Write 16-bit data, then read back the original contents of that location.
+* Requires long addressing format to be allowed.
+*
+* Before sending data, the data is converted to little endian. The
+* data received back is converted back to the target platform's endianness.
+*
+* WARNING: This function is only guaranteed to work if there is one
+* master on the I2C bus.
+*
+* Output:
+* - 0     if reading was successful
+*                  in that case: read back data is at *rdata
+* - -EIO  if anything went wrong
+*
+******************************/
+
+static int drxdap_fasi_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
+						    u32 waddr,
+						    u32 raddr,
+						    u16 wdata, u16 *rdata)
+{
+	int rc = -EIO;
+
+#if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
+	if (rdata == NULL)
+		return -EINVAL;
+
+	rc = drxdap_fasi_write_reg16(dev_addr, waddr, wdata, DRXDAP_FASI_RMW);
+	if (rc == 0)
+		rc = drxdap_fasi_read_reg16(dev_addr, raddr, rdata, 0);
+#endif
+
+	return rc;
+}
+
+/******************************
+*
 * int drxdap_fasi_write_reg32 (
 *     struct i2c_device_addr *dev_addr, -- address of I2C device
 *     u32 addr,    -- address of chip register/memory
@@ -656,3 +581,18 @@ static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,
 
 	return drxdap_fasi_write_block(dev_addr, addr, sizeof(data), buf, flags);
 }
+
+/* The structure containing the protocol interface */
+struct drx_access_func drx_dap_fasi_funct_g = {
+	drxdap_fasi_write_block,	/* Supported */
+	drxdap_fasi_read_block,	/* Supported */
+	drxdap_fasi_write_reg8,	/* Not supported */
+	drxdap_fasi_read_reg8,	/* Not supported */
+	drxdap_fasi_read_modify_write_reg8,	/* Not supported */
+	drxdap_fasi_write_reg16,	/* Supported */
+	drxdap_fasi_read_reg16,	/* Supported */
+	drxdap_fasi_read_modify_write_reg16,	/* Supported */
+	drxdap_fasi_write_reg32,	/* Supported */
+	drxdap_fasi_read_reg32,	/* Supported */
+	drxdap_fasi_read_modify_write_reg32	/* Not supported */
+};
-- 
1.8.5.3

