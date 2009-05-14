Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53694 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZENXxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 19:53:21 -0400
Subject: Re: v4l-dvb rev 11757 broke building under Ubuntu Hardy
From: Andy Walls <awalls@radix.net>
To: david.ward@gatech.edu
Cc: Chaithrika U S <chaithrika@ti.com>, linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 14 May 2009 19:53:50 -0400
Message-Id: <1242345230.3169.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


David Ward wrote:

> I am using v4l-dvb in order to add the cx18 driver under Ubuntu Hardy
> (8.04).
> 
> The build is currently broken under Hardy, which uses kernel 2.6.24. I
> have traced the origin of the problem to revision 11757. As seen in
> the latest cron job output, the build produces the error when trying
> to compile adv7343.c:
> 
> /usr/local/src/v4l-dvb/v4l/adv7343.c:506: error: array type has incomplete element type
> /usr/local/src/v4l-dvb/v4l/adv7343.c:518: warning: initialization from incompatible pointer type
> /usr/local/src/v4l-dvb/v4l/adv7343.c:520: error: unknown field 'id_table' specified in initializer
> 
> Thanks for resolving this.
> 
> David Ward

David,

Please try the patch below.

Chaithrika,

Please review (and test if it is OK) the patch below.  It modifies
adv7343.c to what the cs5345.c file does for backward compatability.

It adds some checks against kernel version, which would not go into the
actual kernel, and changes some code to use the v4l2 i2c module template
from v4l2-i2c-drv.h, which *would* go into the actual kenrel.


Regards,
Andy


Signed-off-by: Andy Walls <awalls@radix.net>

diff -r 0018ed9bbca3 linux/drivers/media/video/adv7343.c
--- a/linux/drivers/media/video/adv7343.c	Tue May 12 16:13:13 2009 +0000
+++ b/linux/drivers/media/video/adv7343.c	Thu May 14 19:51:10 2009 -0400
@@ -29,6 +29,8 @@
 #include <media/adv7343.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/v4l2-i2c-drv.h>
+#include "compat.h"
 
 #include "adv7343_regs.h"
 
@@ -503,6 +505,7 @@
 	return 0;
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 static const struct i2c_device_id adv7343_id[] = {
 	{"adv7343", 0},
 	{},
@@ -510,25 +513,12 @@
 
 MODULE_DEVICE_TABLE(i2c, adv7343_id);
 
-static struct i2c_driver adv7343_driver = {
-	.driver = {
-		.owner	= THIS_MODULE,
-		.name	= "adv7343",
-	},
+#endif
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+	.name		= "adv7343",
 	.probe		= adv7343_probe,
 	.remove		= adv7343_remove,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	.id_table	= adv7343_id,
+#endif
 };
-
-static __init int init_adv7343(void)
-{
-	return i2c_add_driver(&adv7343_driver);
-}
-
-static __exit void exit_adv7343(void)
-{
-	i2c_del_driver(&adv7343_driver);
-}
-
-module_init(init_adv7343);
-module_exit(exit_adv7343);


