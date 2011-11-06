Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:18 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498582faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:18 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 03/13] staging: as102: Remove leftovers of the SPI bus driver
Date: Sun,  6 Nov 2011 21:31:40 +0100
Message-Id: <1320611510-3326-4-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SPI bus driver support is not included in this module, the SPI
driver files are missing. But some bits are still present so
clean up the unused code.
The SPI driver support can be properly added later if needed.

Then CONFIG_AS102_SPI and CONFIG_AS102_USB is now not needed
and the pre-processor statements using these config options
can now be removed from *.c files.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/Makefile    |    2 +-
 drivers/staging/media/as102/as102_drv.c |   33 ++--------------------
 drivers/staging/media/as102/as102_drv.h |   46 ++++---------------------------
 drivers/staging/media/as102/as102_fw.c  |    7 +----
 4 files changed, 11 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/media/as102/Makefile b/drivers/staging/media/as102/Makefile
index e7dbb6f..1bca43e 100644
--- a/drivers/staging/media/as102/Makefile
+++ b/drivers/staging/media/as102/Makefile
@@ -3,4 +3,4 @@ dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
 
 obj-$(CONFIG_DVB_AS102) += dvb-as102.o
 
-EXTRA_CFLAGS += -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 771d550..0bcc55c 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -56,9 +56,7 @@ int elna_enable = 1;
 module_param_named(elna_enable, elna_enable, int, 0644);
 MODULE_PARM_DESC(elna_enable, "Activate eLNA (default: on)");
 
-#ifdef DVB_DEFINE_MOD_OPT_ADAPTER_NR
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-#endif
 
 static void as102_stop_stream(struct as102_dev_t *dev)
 {
@@ -203,16 +201,8 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 	ret = dvb_register_adapter(&as102_dev->dvb_adap,
 				   as102_dev->name,
 				   THIS_MODULE,
-#if defined(CONFIG_AS102_USB)
-				   &as102_dev->bus_adap.usb_dev->dev
-#elif defined(CONFIG_AS102_SPI)
-				   &as102_dev->bus_adap.spi_dev->dev
-#else
-#error >>> dvb_register_adapter <<<
-#endif
-#ifdef DVB_DEFINE_MOD_OPT_ADAPTER_NR
-				   , adapter_nr
-#endif
+				   &as102_dev->bus_adap.usb_dev->dev,
+				   adapter_nr
 				   );
 	if (ret < 0) {
 		err("%s: dvb_register_adapter() failed (errno = %d)",
@@ -294,23 +284,13 @@ void as102_dvb_unregister(struct as102_dev_t *as102_dev)
 
 static int __init as102_driver_init(void)
 {
-	int ret = 0;
-
-	ENTER();
+	int ret;
 
 	/* register this driver with the low level subsystem */
-#if defined(CONFIG_AS102_USB)
 	ret = usb_register(&as102_usb_driver);
 	if (ret)
 		err("usb_register failed (ret = %d)", ret);
-#endif
-#if defined(CONFIG_AS102_SPI)
-	ret = spi_register_driver(&as102_spi_driver);
-	if (ret)
-		printk(KERN_ERR "spi_register failed (ret = %d)", ret);
-#endif
 
-	LEAVE();
 	return ret;
 }
 
@@ -327,15 +307,8 @@ module_init(as102_driver_init);
  */
 static void __exit as102_driver_exit(void)
 {
-	ENTER();
 	/* deregister this driver with the low level bus subsystem */
-#if defined(CONFIG_AS102_USB)
 	usb_deregister(&as102_usb_driver);
-#endif
-#if defined(CONFIG_AS102_SPI)
-	spi_unregister_driver(&as102_spi_driver);
-#endif
-	LEAVE();
 }
 
 /*
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index 7f56f64..af2bf1e 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -17,27 +17,18 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#if defined(CONFIG_AS102_USB)
 #include <linux/usb.h>
-extern struct usb_driver as102_usb_driver;
-#endif
-
-#if defined(CONFIG_AS102_SPI)
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
-#include <linux/cdev.h>
-
-extern struct spi_driver as102_spi_driver;
-#endif
-
-#include "dvb_demux.h"
-#include "dvb_frontend.h"
-#include "dmxdev.h"
+#include <dvb_demux.h>
+#include <dvb_frontend.h>
+#include <dmxdev.h>
+#include "as10x_cmd.h"
+#include "as102_usb_drv.h"
 
 #define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
 #define DRIVER_NAME "as10x_usb"
 
 extern int debug;
+extern struct usb_driver as102_usb_driver;
 
 #define dprintk(debug, args...) \
 	do { if (debug) {	\
@@ -58,39 +49,14 @@ extern int debug;
 #define AS102_USB_BUF_SIZE	512
 #define MAX_STREAM_URB		32
 
-#include "as10x_cmd.h"
-
-#if defined(CONFIG_AS102_USB)
-#include "as102_usb_drv.h"
-#endif
-
-#if defined(CONFIG_AS102_SPI)
-#include "as10x_spi_drv.h"
-#endif
-
-
 struct as102_bus_adapter_t {
-#if defined(CONFIG_AS102_USB)
 	struct usb_device *usb_dev;
-#elif defined(CONFIG_AS102_SPI)
-	struct spi_device *spi_dev;
-	struct cdev cdev; /* spidev raw device */
-
-	struct timer_list timer;
-	struct completion xfer_done;
-#endif
 	/* bus token lock */
 	struct mutex lock;
 	/* low level interface for bus adapter */
 	union as10x_bus_token_t {
-#if defined(CONFIG_AS102_USB)
 		/* usb token */
 		struct as10x_usb_token_cmd_t usb;
-#endif
-#if defined(CONFIG_AS102_SPI)
-		/* spi token */
-		struct as10x_spi_token_cmd_t spi;
-#endif
 	} token;
 
 	/* token cmd xfer id */
diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index 4fb2987..3aa4aad 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -169,13 +169,8 @@ int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
 	const struct firmware *firmware;
 	unsigned char *cmd_buf = NULL;
 	char *fw1, *fw2;
-
-#if defined(CONFIG_AS102_USB)
 	struct usb_device *dev = bus_adap->usb_dev;
-#endif
-#if defined(CONFIG_AS102_SPI)
-	struct spi_device *dev = bus_adap->spi_dev;
-#endif
+
 	ENTER();
 
 	/* select fw file to upload */
-- 
1.7.5.4

