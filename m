Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:54458 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaBFJqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 04:46:37 -0500
Received: by mail-ea0-f172.google.com with SMTP id l9so650291eaj.3
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 01:46:36 -0800 (PST)
From: David Jedelsky <david.jedelsky@gmail.com>
To: linux-media@vger.kernel.org
Cc: David Jedelsky <david.jedelsky@gmail.com>
Subject: [PATCH] [media] stb0899: Fix DVB-S2 support for TechniSat SkyStar 2 HD CI USB ID 14f7:0002
Date: Thu,  6 Feb 2014 10:45:07 +0100
Message-Id: <1391679907-17876-1-git-send-email-david.jedelsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My TechniSat SkyStar 2 HD CI USB ID 14f7:0002 wasn't tuning DVB-S2 channels.
Investigation revealed that it doesn't read DVB-S2 registers out of stb0899.
Comparison with usb trafic of the Windows driver showed the correct
communication scheme. This patch implements it.
The question is, whether the changed communication doesn't break other devices.
But the read part of patched _stb0899_read_s2reg routine is now functinally
same as (not changed) stb0899_read_regs which reads ordinrary DVB-S registers.
Giving high chance that it should work correctly on other devices too.

Signed-off-by: David Jedelsky <david.jedelsky@gmail.com>
---
 drivers/media/dvb-frontends/stb0899_drv.c |   44 +++++++++++------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 07cd5ea..3084cb2 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -305,19 +305,20 @@ u32 _stb0899_read_s2reg(struct stb0899_state *state,
 		.len	= 6
 	};
 
-	struct i2c_msg msg_1 = {
-		.addr	= state->config->demod_address,
-		.flags	= 0,
-		.buf	= buf_1,
-		.len	= 2
+	struct i2c_msg msg[] = {
+		{
+			.addr	= state->config->demod_address,
+			.flags	= 0,
+			.buf	= buf_1,
+			.len	= 2
+		}, {
+			.addr	= state->config->demod_address,
+			.flags	= I2C_M_RD,
+			.buf	= buf,
+			.len	= 4
+		}
 	};
 
-	struct i2c_msg msg_r = {
-		.addr	= state->config->demod_address,
-		.flags	= I2C_M_RD,
-		.buf	= buf,
-		.len	= 4
-	};
 
 	tmpaddr = stb0899_reg_offset & 0xff00;
 	if (!(stb0899_reg_offset & 0x8))
@@ -326,6 +327,7 @@ u32 _stb0899_read_s2reg(struct stb0899_state *state,
 	buf_1[0] = GETBYTE(tmpaddr, BYTE1);
 	buf_1[1] = GETBYTE(tmpaddr, BYTE0);
 
+	/* Write address	*/
 	status = i2c_transfer(state->i2c, &msg_0, 1);
 	if (status < 1) {
 		if (status != -ERESTARTSYS)
@@ -336,28 +338,16 @@ u32 _stb0899_read_s2reg(struct stb0899_state *state,
 	}
 
 	/* Dummy	*/
-	status = i2c_transfer(state->i2c, &msg_1, 1);
-	if (status < 1)
-		goto err;
-
-	status = i2c_transfer(state->i2c, &msg_r, 1);
-	if (status < 1)
+	status = i2c_transfer(state->i2c, msg, 2);
+	if (status < 2)
 		goto err;
 
 	buf_1[0] = GETBYTE(stb0899_reg_offset, BYTE1);
 	buf_1[1] = GETBYTE(stb0899_reg_offset, BYTE0);
 
 	/* Actual	*/
-	status = i2c_transfer(state->i2c, &msg_1, 1);
-	if (status < 1) {
-		if (status != -ERESTARTSYS)
-			printk(KERN_ERR "%s ERR(2), Device=[0x%04x], Base address=[0x%08x], Offset=[0x%04x], Status=%d\n",
-			       __func__, stb0899_i2cdev, stb0899_base_addr, stb0899_reg_offset, status);
-		goto err;
-	}
-
-	status = i2c_transfer(state->i2c, &msg_r, 1);
-	if (status < 1) {
+	status = i2c_transfer(state->i2c, msg, 2);
+	if (status < 2) {
 		if (status != -ERESTARTSYS)
 			printk(KERN_ERR "%s ERR(3), Device=[0x%04x], Base address=[0x%08x], Offset=[0x%04x], Status=%d\n",
 			       __func__, stb0899_i2cdev, stb0899_base_addr, stb0899_reg_offset, status);
-- 
1.7.10.4

