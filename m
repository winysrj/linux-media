Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35986 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359AbcCKINN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 03:13:13 -0500
Date: Fri, 11 Mar 2016 11:13:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] em28xx-i2c: rt_mutex_trylock() returns zero on
 failure
Message-ID: <20160311081301.GD31887@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code is checking for negative returns but it should be checking for
zero.

Fixes: aab3125c43d8 ('[media] em28xx: add support for registering multiple i2c buses')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Is -EBUSY correct?  -EAGAIN?

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index a19b5c8..f80dd3a 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -507,9 +507,8 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	if (dev->disconnected)
 		return -ENODEV;
 
-	rc = rt_mutex_trylock(&dev->i2c_bus_lock);
-	if (rc < 0)
-		return rc;
+	if (!rt_mutex_trylock(&dev->i2c_bus_lock))
+		return -EBUSY;
 
 	/* Switch I2C bus if needed */
 	if (bus != dev->cur_i2c_bus &&
