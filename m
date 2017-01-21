Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35414 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdAUBCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 20:02:12 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH RESEND] staging: media: lirc: use new parport device model
Date: Sat, 21 Jan 2017 00:55:54 +0000
Message-Id: <1484960154-6355-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

Modify lirc_parallel driver to use the new parallel port device model.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---

Resending after more than one year.
Prevoius patch is at https://patchwork.kernel.org/patch/7883591/

 drivers/staging/media/lirc/lirc_parallel.c | 93 ++++++++++++++++++++----------
 1 file changed, 62 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index bfb76a4..0a43bac2b 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -626,41 +626,26 @@ static void kf(void *handle)
 
 /*** module initialization and cleanup ***/
 
-static int __init lirc_parallel_init(void)
+static void lirc_parallel_attach(struct parport *port)
 {
-	int result;
-
-	result = platform_driver_register(&lirc_parallel_driver);
-	if (result) {
-		pr_notice("platform_driver_register returned %d\n", result);
-		return result;
-	}
+	struct pardev_cb lirc_parallel_cb;
 
-	lirc_parallel_dev = platform_device_alloc(LIRC_DRIVER_NAME, 0);
-	if (!lirc_parallel_dev) {
-		result = -ENOMEM;
-		goto exit_driver_unregister;
-	}
+	if (port->base != io)
+		return;
 
-	result = platform_device_add(lirc_parallel_dev);
-	if (result)
-		goto exit_device_put;
+	pport = port;
+	memset(&lirc_parallel_cb, 0, sizeof(lirc_parallel_cb));
+	lirc_parallel_cb.preempt = pf;
+	lirc_parallel_cb.wakeup = kf;
+	lirc_parallel_cb.irq_func = lirc_lirc_irq_handler;
 
-	pport = parport_find_base(io);
-	if (!pport) {
-		pr_notice("no port at %x found\n", io);
-		result = -ENXIO;
-		goto exit_device_del;
-	}
-	ppdevice = parport_register_device(pport, LIRC_DRIVER_NAME,
-					   pf, kf, lirc_lirc_irq_handler, 0,
-					   NULL);
-	parport_put_port(pport);
+	ppdevice = parport_register_dev_model(port, LIRC_DRIVER_NAME,
+					      &lirc_parallel_cb, 0);
 	if (!ppdevice) {
 		pr_notice("parport_register_device() failed\n");
-		result = -ENXIO;
-		goto exit_device_del;
+		return;
 	}
+
 	if (parport_claim(ppdevice) != 0)
 		goto skip_init;
 	is_claimed = 1;
@@ -688,18 +673,64 @@ static int __init lirc_parallel_init(void)
 
 	is_claimed = 0;
 	parport_release(ppdevice);
+
  skip_init:
+	return;
+}
+
+static void lirc_parallel_detach(struct parport *port)
+{
+	if (port->base != io)
+		return;
+
+	parport_unregister_device(ppdevice);
+}
+
+static struct parport_driver lirc_parport_driver = {
+	.name = LIRC_DRIVER_NAME,
+	.match_port = lirc_parallel_attach,
+	.detach = lirc_parallel_detach,
+	.devmodel = true,
+};
+
+static int __init lirc_parallel_init(void)
+{
+	int result;
+
+	result = platform_driver_register(&lirc_parallel_driver);
+	if (result) {
+		pr_notice("platform_driver_register returned %d\n", result);
+		return result;
+	}
+
+	lirc_parallel_dev = platform_device_alloc(LIRC_DRIVER_NAME, 0);
+	if (!lirc_parallel_dev) {
+		result = -ENOMEM;
+		goto exit_driver_unregister;
+	}
+
+	result = platform_device_add(lirc_parallel_dev);
+	if (result)
+		goto exit_device_put;
+
+	result = parport_register_driver(&lirc_parport_driver);
+	if (result) {
+		pr_notice("parport_register_driver returned %d\n", result);
+		goto exit_device_del;
+	}
+
 	driver.dev = &lirc_parallel_dev->dev;
 	driver.minor = lirc_register_driver(&driver);
 	if (driver.minor < 0) {
 		pr_notice("register_chrdev() failed\n");
-		parport_unregister_device(ppdevice);
 		result = -EIO;
-		goto exit_device_del;
+		goto exit_unregister;
 	}
 	pr_info("installed using port 0x%04x irq %d\n", io, irq);
 	return 0;
 
+exit_unregister:
+	parport_unregister_driver(&lirc_parport_driver);
 exit_device_del:
 	platform_device_del(lirc_parallel_dev);
 exit_device_put:
@@ -711,9 +742,9 @@ static int __init lirc_parallel_init(void)
 
 static void __exit lirc_parallel_exit(void)
 {
-	parport_unregister_device(ppdevice);
 	lirc_unregister_driver(driver.minor);
 
+	parport_unregister_driver(&lirc_parport_driver);
 	platform_device_unregister(lirc_parallel_dev);
 	platform_driver_unregister(&lirc_parallel_driver);
 }
-- 
1.9.1

