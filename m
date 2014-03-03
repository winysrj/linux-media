Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaCCKIF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:05 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 68/79] [media] drx-j: get rid of struct drx_dap_fasi_funct_g
Date: Mon,  3 Mar 2014 07:07:02 -0300
Message-Id: <1393841233-24840-69-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This struct contains the first abstraction layer for the I2C
access routines. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 45 ++++++++++-------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 94c3d6f0d5b8..8dc53345dd06 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2073,27 +2073,12 @@ static int drxdap_fasi_write_reg32(struct i2c_device_addr *dev_addr,
 	return drxdap_fasi_write_block(dev_addr, addr, sizeof(data), buf, flags);
 }
 
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
 static int drxj_dap_read_block(struct i2c_device_addr *dev_addr,
 				      u32 addr,
 				      u16 datasize,
 				      u8 *data, u32 flags)
 {
-	return drx_dap_fasi_funct_g.read_block_func(dev_addr,
+	return drxdap_fasi_read_block(dev_addr,
 					       addr, datasize, data, flags);
 }
 
@@ -2104,7 +2089,7 @@ static int drxj_dap_read_modify_write_reg8(struct i2c_device_addr *dev_addr,
 						u32 raddr,
 						u8 wdata, u8 *rdata)
 {
-	return drx_dap_fasi_funct_g.read_modify_write_reg8func(dev_addr,
+	return drxdap_fasi_read_modify_write_reg8(dev_addr,
 							 waddr,
 							 raddr, wdata, rdata);
 }
@@ -2143,23 +2128,23 @@ static int drxj_dap_rm_write_reg16short(struct i2c_device_addr *dev_addr,
 		return -EINVAL;
 
 	/* Set RMW flag */
-	rc = drx_dap_fasi_funct_g.write_reg16func(dev_addr,
+	rc = drxdap_fasi_write_reg16(dev_addr,
 					      SIO_HI_RA_RAM_S0_FLG_ACC__A,
 					      SIO_HI_RA_RAM_S0_FLG_ACC_S0_RWM__M,
 					      0x0000);
 	if (rc == 0) {
 		/* Write new data: triggers RMW */
-		rc = drx_dap_fasi_funct_g.write_reg16func(dev_addr, waddr, wdata,
+		rc = drxdap_fasi_write_reg16(dev_addr, waddr, wdata,
 						      0x0000);
 	}
 	if (rc == 0) {
 		/* Read old data */
-		rc = drx_dap_fasi_funct_g.read_reg16func(dev_addr, raddr, rdata,
+		rc = drxdap_fasi_read_reg16(dev_addr, raddr, rdata,
 						     0x0000);
 	}
 	if (rc == 0) {
 		/* Reset RMW flag */
-		rc = drx_dap_fasi_funct_g.write_reg16func(dev_addr,
+		rc = drxdap_fasi_write_reg16(dev_addr,
 						      SIO_HI_RA_RAM_S0_FLG_ACC__A,
 						      0, 0x0000);
 	}
@@ -2179,7 +2164,7 @@ static int drxj_dap_read_modify_write_reg16(struct i2c_device_addr *dev_addr,
 	   now long format has higher prio then short because short also
 	   needs virt bnks (not impl yet) for certain audio registers */
 #if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
-	return drx_dap_fasi_funct_g.read_modify_write_reg16func(dev_addr,
+	return drxdap_fasi_read_modify_write_reg16(dev_addr,
 							  waddr,
 							  raddr, wdata, rdata);
 #else
@@ -2194,7 +2179,7 @@ static int drxj_dap_read_modify_write_reg32(struct i2c_device_addr *dev_addr,
 						 u32 raddr,
 						 u32 wdata, u32 *rdata)
 {
-	return drx_dap_fasi_funct_g.read_modify_write_reg32func(dev_addr,
+	return drxdap_fasi_read_modify_write_reg32(dev_addr,
 							  waddr,
 							  raddr, wdata, rdata);
 }
@@ -2205,7 +2190,7 @@ static int drxj_dap_read_reg8(struct i2c_device_addr *dev_addr,
 				     u32 addr,
 				     u8 *data, u32 flags)
 {
-	return drx_dap_fasi_funct_g.read_reg8func(dev_addr, addr, data, flags);
+	return drxdap_fasi_read_reg8(dev_addr, addr, data, flags);
 }
 
 /*============================================================================*/
@@ -2311,7 +2296,7 @@ static int drxj_dap_read_reg16(struct i2c_device_addr *dev_addr,
 	if (is_handled_by_aud_tr_if(addr))
 		stat = drxj_dap_read_aud_reg16(dev_addr, addr, data);
 	else
-		stat = drx_dap_fasi_funct_g.read_reg16func(dev_addr,
+		stat = drxdap_fasi_read_reg16(dev_addr,
 							   addr, data, flags);
 
 	return stat;
@@ -2323,7 +2308,7 @@ static int drxj_dap_read_reg32(struct i2c_device_addr *dev_addr,
 				      u32 addr,
 				      u32 *data, u32 flags)
 {
-	return drx_dap_fasi_funct_g.read_reg32func(dev_addr, addr, data, flags);
+	return drxdap_fasi_read_reg32(dev_addr, addr, data, flags);
 }
 
 /*============================================================================*/
@@ -2333,7 +2318,7 @@ static int drxj_dap_write_block(struct i2c_device_addr *dev_addr,
 				       u16 datasize,
 				       u8 *data, u32 flags)
 {
-	return drx_dap_fasi_funct_g.write_block_func(dev_addr,
+	return drxdap_fasi_write_block(dev_addr,
 						addr, datasize, data, flags);
 }
 
@@ -2343,7 +2328,7 @@ static int drxj_dap_write_reg8(struct i2c_device_addr *dev_addr,
 				      u32 addr,
 				      u8 data, u32 flags)
 {
-	return drx_dap_fasi_funct_g.write_reg8func(dev_addr, addr, data, flags);
+	return drxdap_fasi_write_reg8(dev_addr, addr, data, flags);
 }
 
 /*============================================================================*/
@@ -2420,7 +2405,7 @@ static int drxj_dap_write_reg16(struct i2c_device_addr *dev_addr,
 	if (is_handled_by_aud_tr_if(addr))
 		stat = drxj_dap_write_aud_reg16(dev_addr, addr, data);
 	else
-		stat = drx_dap_fasi_funct_g.write_reg16func(dev_addr,
+		stat = drxdap_fasi_write_reg16(dev_addr,
 							    addr, data, flags);
 
 	return stat;
@@ -2432,7 +2417,7 @@ static int drxj_dap_write_reg32(struct i2c_device_addr *dev_addr,
 				       u32 addr,
 				       u32 data, u32 flags)
 {
-	return drx_dap_fasi_funct_g.write_reg32func(dev_addr, addr, data, flags);
+	return drxdap_fasi_write_reg32(dev_addr, addr, data, flags);
 }
 
 /*============================================================================*/
-- 
1.8.5.3

