Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab1JaQ0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 12:26:04 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so5444413eye.19
        for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 09:26:03 -0700 (PDT)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>
Subject: [PATCH 16/17] staging: as102: Unconditionally compile code dependent on DVB_CORE
Date: Mon, 31 Oct 2011 17:24:54 +0100
Message-Id: <1320078295-3379-17-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
References: <1320078295-3379-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver depends on DVB_CORE so there is no need for conditional
compilation of parts of the code depending on CONFIG_DVB_CORE as
the driver is never compiled with CONFIG_DVB_CORE* disabled.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c     |   12 +-----------
 drivers/staging/media/as102/as102_drv.h     |    6 ------
 drivers/staging/media/as102/as102_fe.c      |    2 --
 drivers/staging/media/as102/as102_usb_drv.c |    4 ----
 4 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 27a1571..d335c7d 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -30,12 +30,7 @@
 /* header file for Usb device driver*/
 #include "as102_drv.h"
 #include "as102_fw.h"
-
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 #include "dvbdev.h"
-#else
-#warning >>> DVB_CORE not defined !!! <<<
-#endif
 
 int debug;
 module_param_named(debug, debug, int, 0644);
@@ -65,7 +60,6 @@ MODULE_PARM_DESC(elna_enable, "Activate eLNA (default: on)");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #endif
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 static void as102_stop_stream(struct as102_dev_t *dev)
 {
 	struct as102_bus_adapter_t *bus_adap;
@@ -200,14 +194,12 @@ static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	LEAVE();
 	return 0;
 }
-#endif
 
 int as102_dvb_register(struct as102_dev_t *as102_dev)
 {
 	int ret = 0;
 	ENTER();
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 	ret = dvb_register_adapter(&as102_dev->dvb_adap,
 				   as102_dev->name,
 				   THIS_MODULE,
@@ -260,7 +252,6 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 		    __func__, ret);
 		goto failed;
 	}
-#endif
 
 	/* init bus mutex for token locking */
 	mutex_init(&as102_dev->bus_adap.lock);
@@ -288,7 +279,6 @@ void as102_dvb_unregister(struct as102_dev_t *as102_dev)
 {
 	ENTER();
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 	/* unregister as102 frontend */
 	as102_dvb_unregister_fe(&as102_dev->dvb_fe);
 
@@ -298,7 +288,7 @@ void as102_dvb_unregister(struct as102_dev_t *as102_dev)
 
 	/* unregister dvb adapter */
 	dvb_unregister_adapter(&as102_dev->dvb_adap);
-#endif
+
 	LEAVE();
 }
 
diff --git a/drivers/staging/media/as102/as102_drv.h b/drivers/staging/media/as102/as102_drv.h
index cd11b16..bcda635 100644
--- a/drivers/staging/media/as102/as102_drv.h
+++ b/drivers/staging/media/as102/as102_drv.h
@@ -30,11 +30,9 @@ extern struct usb_driver as102_usb_driver;
 extern struct spi_driver as102_spi_driver;
 #endif
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 #include "dvb_demux.h"
 #include "dvb_frontend.h"
 #include "dmxdev.h"
-#endif
 
 #define DRIVER_FULL_NAME "Abilis Systems as10x usb driver"
 #define DRIVER_NAME "as10x_usb"
@@ -112,12 +110,10 @@ struct as102_dev_t {
 	struct kref kref;
 	unsigned long minor;
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 	struct dvb_adapter dvb_adap;
 	struct dvb_frontend dvb_fe;
 	struct dvb_demux dvb_dmx;
 	struct dmxdev dvb_dmxdev;
-#endif
 
 	/* demodulator stats */
 	struct as10x_demod_stats demod_stats;
@@ -139,9 +135,7 @@ struct as102_dev_t {
 int as102_dvb_register(struct as102_dev_t *dev);
 void as102_dvb_unregister(struct as102_dev_t *dev);
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 int as102_dvb_register_fe(struct as102_dev_t *dev, struct dvb_frontend *fe);
 int as102_dvb_unregister_fe(struct dvb_frontend *dev);
-#endif
 
 /* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 0495486..874c698 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -25,7 +25,6 @@
 
 extern int elna_enable;
 
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 static void as10x_fe_copy_tps_parameters(struct dvb_frontend_parameters *dst,
 					 struct as10x_tps *src);
 
@@ -672,6 +671,5 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
 			as102_fe_get_code_rate(params->u.ofdm.code_rate_HP);
 	}
 }
-#endif
 
 /* EOF - vim: set textwidth=80 ts=8 sw=8 sts=8 noet: */
diff --git a/drivers/staging/media/as102/as102_usb_drv.c b/drivers/staging/media/as102/as102_usb_drv.c
index 70b21f3..ae1d38d 100644
--- a/drivers/staging/media/as102/as102_usb_drv.c
+++ b/drivers/staging/media/as102/as102_usb_drv.c
@@ -214,13 +214,9 @@ void as102_urb_stream_irq(struct urb *urb)
 	struct as102_dev_t *as102_dev = urb->context;
 
 	if (urb->actual_length > 0) {
-#if defined(CONFIG_DVB_CORE) || defined(CONFIG_DVB_CORE_MODULE)
 		dvb_dmx_swfilter(&as102_dev->dvb_dmx,
 				 urb->transfer_buffer,
 				 urb->actual_length);
-#else
-		/* do nothing ? */
-#endif
 	} else {
 		if (urb->actual_length == 0)
 			memset(urb->transfer_buffer, 0, AS102_USB_BUF_SIZE);
-- 
1.7.4.1

