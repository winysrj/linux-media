Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35308 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZDDVNw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 17:13:52 -0400
Date: Sat, 4 Apr 2009 23:13:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@pobox.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] pvrusb2: Drop client_register/unregister stubs
Message-ID: <20090404231333.5e136f83@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The client_register and client_unregister methods are optional so
there is no point in defining stub ones. Especially when these methods
are likely to be removed soon.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |   12 ------------
 1 file changed, 12 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 13:58:40.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 22:12:21.000000000 +0200
@@ -595,16 +595,6 @@ static u32 pvr2_i2c_functionality(struct
 	return I2C_FUNC_SMBUS_EMUL | I2C_FUNC_I2C;
 }
 
-static int pvr2_i2c_attach_inform(struct i2c_client *client)
-{
-	return 0;
-}
-
-static int pvr2_i2c_detach_inform(struct i2c_client *client)
-{
-	return 0;
-}
-
 static struct i2c_algorithm pvr2_i2c_algo_template = {
 	.master_xfer   = pvr2_i2c_xfer,
 	.functionality = pvr2_i2c_functionality,
@@ -617,8 +607,6 @@ static struct i2c_adapter pvr2_i2c_adap_
 	.owner         = THIS_MODULE,
 	.class	       = 0,
 	.id            = I2C_HW_B_BT848,
-	.client_register = pvr2_i2c_attach_inform,
-	.client_unregister = pvr2_i2c_detach_inform,
 };
 
 

-- 
Jean Delvare
