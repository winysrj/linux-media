Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:36916 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933991Ab0BEWs6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:48:58 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 10/12] tm6000: bugfix usb DVB transfer
Date: Fri,  5 Feb 2010 23:48:14 +0100
Message-Id: <1265410096-11788-9-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410096-11788-8-git-send-email-stefan.ringel@arcor.de>
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-6-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-7-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-8-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

---
 drivers/staging/tm6000/tm6000-dvb.c |  125 ++++++++++++++++++++++-------------
 1 files changed, 79 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index fdbee30..055a58f 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -17,7 +17,9 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/kernel.h>
 #include <linux/usb.h>
+#include <compat.h>
 
 #include "tm6000.h"
 #include "tm6000-regs.h"
@@ -30,13 +32,58 @@
 
 #include "tuner-xc2028.h"
 
+static void inline print_err_status (struct tm6000_core *dev,
+				     int packet, int status)
+{
+	char *errmsg = "Unknown";
+
+	switch(status) {
+	case -ENOENT:
+		errmsg = "unlinked synchronuously";
+		break;
+	case -ECONNRESET:
+		errmsg = "unlinked asynchronuously";
+		break;
+	case -ENOSR:
+		errmsg = "Buffer error (overrun)";
+		break;
+	case -EPIPE:
+		errmsg = "Stalled (device not responding)";
+		break;
+	case -EOVERFLOW:
+		errmsg = "Babble (bad cable?)";
+		break;
+	case -EPROTO:
+		errmsg = "Bit-stuff error (bad cable?)";
+		break;
+	case -EILSEQ:
+		errmsg = "CRC/Timeout (could be anything)";
+		break;
+	case -ETIME:
+		errmsg = "Device does not respond";
+		break;
+	}
+	if (packet<0) {
+		dprintk(dev, 1, "URB status %d [%s].\n",
+			status, errmsg);
+	} else {
+		dprintk(dev, 1, "URB packet %d, status %d [%s].\n",
+			packet, status, errmsg);
+	}
+}
+
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+static void tm6000_urb_received(struct urb *urb, struct pt_regs *ptregs)
+#else
 static void tm6000_urb_received(struct urb *urb)
+#endif
 {
 	int ret;
 	struct tm6000_core* dev = urb->context;
 
-	if(urb->status != 0){
-		printk(KERN_ERR "tm6000: status != 0\n");
+	if(urb->status != 0) {
+		print_err_status (dev,0,urb->status);
 	}
 	else if(urb->actual_length>0){
 		dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
@@ -56,49 +103,37 @@ static void tm6000_urb_received(struct urb *urb)
 int tm6000_start_stream(struct tm6000_core *dev)
 {
 	int ret;
-	unsigned int pipe, maxPaketSize;
+	unsigned int pipe, size;
 	struct tm6000_dvb *dvb = dev->dvb;
 
 	printk(KERN_INFO "tm6000: got start stream request %s\n",__FUNCTION__);
 
 	tm6000_init_digital_mode(dev);
 
-/*
-	ret = tm6000_set_led_status(tm6000_dev, 0x1);
-	if(ret < 0) {
-		return -1;
-	}
-*/
-
 	dvb->bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if(dvb->bulk_urb == NULL) {
 		printk(KERN_ERR "tm6000: couldn't allocate urb\n");
 		return -ENOMEM;
 	}
 
-	maxPaketSize = dev->bulk_in->desc.wMaxPacketSize;
+	pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in->desc.bEndpointAddress
+							  & USB_ENDPOINT_NUMBER_MASK);
+							  
+	size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
+	size = size * 15; /* 512 x 8 or 12 or 15 */
 
-	dvb->bulk_urb->transfer_buffer = kzalloc(maxPaketSize, GFP_KERNEL);
+	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
 	if(dvb->bulk_urb->transfer_buffer == NULL) {
 		usb_free_urb(dvb->bulk_urb);
 		printk(KERN_ERR "tm6000: couldn't allocate transfer buffer!\n");
 		return -ENOMEM;
 	}
 
-	pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in->desc.bEndpointAddress
-							  & USB_ENDPOINT_NUMBER_MASK);
-
 	usb_fill_bulk_urb(dvb->bulk_urb, dev->udev, pipe,
 						 dvb->bulk_urb->transfer_buffer,
-						 maxPaketSize,
+						 size,
 						 tm6000_urb_received, dev);
 
-	ret = usb_set_interface(dev->udev, 0, 1);
-	if(ret < 0) {
-		printk(KERN_ERR "tm6000: error %i in %s during set interface\n", ret, __FUNCTION__);
-		return ret;
-	}
-
 	ret = usb_clear_halt(dev->udev, pipe);
 	if(ret < 0) {
 		printk(KERN_ERR "tm6000: error %i in %s during pipe reset\n",ret,__FUNCTION__);
@@ -108,14 +143,13 @@ int tm6000_start_stream(struct tm6000_core *dev)
 		printk(KERN_ERR "tm6000: pipe resetted\n");
 	}
 
-// 	mutex_lock(&tm6000_driver.open_close_mutex);
+/*	mutex_lock(&tm6000_driver.open_close_mutex); */
 	ret = usb_submit_urb(dvb->bulk_urb, GFP_KERNEL);
 
-
-// 	mutex_unlock(&tm6000_driver.open_close_mutex);
+/*	mutex_unlock(&tm6000_driver.open_close_mutex); */
 	if (ret) {
 		printk(KERN_ERR "tm6000: submit of urb failed (error=%i)\n",ret);
-
+		
 		kfree(dvb->bulk_urb->transfer_buffer);
 		usb_free_urb(dvb->bulk_urb);
 		return ret;
@@ -126,18 +160,12 @@ int tm6000_start_stream(struct tm6000_core *dev)
 
 void tm6000_stop_stream(struct tm6000_core *dev)
 {
-	int ret;
 	struct tm6000_dvb *dvb = dev->dvb;
 
-// 	tm6000_set_led_status(tm6000_dev, 0x0);
-
-	ret = usb_set_interface(dev->udev, 0, 0);
-	if(ret < 0) {
-		printk(KERN_ERR "tm6000: error %i in %s during set interface\n",ret,__FUNCTION__);
-	}
-
 	if(dvb->bulk_urb) {
+		printk (KERN_INFO "urb killing\n");
 		usb_kill_urb(dvb->bulk_urb);
+		printk (KERN_INFO "urb buffer free\n");
 		kfree(dvb->bulk_urb->transfer_buffer);
 		usb_free_urb(dvb->bulk_urb);
 		dvb->bulk_urb = NULL;
@@ -154,7 +182,7 @@ int tm6000_start_feed(struct dvb_demux_feed *feed)
 	mutex_lock(&dvb->mutex);
 	if(dvb->streams == 0) {
 		dvb->streams = 1;
-// 		mutex_init(&tm6000_dev->streaming_mutex);
+/*		mutex_init(&tm6000_dev->streming_mutex); */
 		tm6000_start_stream(dev);
 	}
 	else {
@@ -173,14 +201,16 @@ int tm6000_stop_feed(struct dvb_demux_feed *feed) {
 	printk(KERN_INFO "tm6000: got stop feed request %s\n",__FUNCTION__);
 
 	mutex_lock(&dvb->mutex);
-	--dvb->streams;
 
-	if(0 == dvb->streams) {
+	printk (KERN_INFO "stream %#x\n", dvb->streams);
+	--(dvb->streams);
+	if(dvb->streams == 0) {
+		printk (KERN_INFO "stop stream\n");
 		tm6000_stop_stream(dev);
-// 		mutex_destroy(&tm6000_dev->streaming_mutex);
+/*		mutex_destroy(&tm6000_dev->streaming_mutex); */
 	}
 	mutex_unlock(&dvb->mutex);
-// 	mutex_destroy(&tm6000_dev->streaming_mutex);
+/*	mutex_destroy(&tm6000_dev->streaming_mutex); */
 
 	return 0;
 }
@@ -191,13 +221,16 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 
 	if(dev->caps.has_zl10353) {
 		struct zl10353_config config =
-				    {.demod_address = dev->demod_addr >> 1,
+				    {.demod_address = dev->demod_addr,
 				     .no_tuner = 1,
-// 				     .input_frequency = 0x19e9,
-// 				     .r56_agc_targets =  0x1c,
+				     .parallel_ts = 1,
+				     .if2 = 45700,
+				     .disable_i2c_gate_ctrl = 1,
+				     .tm6000 = 1,
 				    };
 
 		dvb->frontend = pseudo_zl10353_attach(dev, &config,
+/*		dvb->frontend = dvb_attach (zl10353_attach, &config, */
 							   &dev->i2c_adap);
 	}
 	else {
@@ -259,8 +292,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 	dvb->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING
 							    | DMX_MEMORY_BASED_FILTERING;
 	dvb->demux.priv = dev;
-	dvb->demux.filternum = 256;
-	dvb->demux.feednum = 256;
+	dvb->demux.filternum = 5; /* 256; */
+	dvb->demux.feednum = 5; /* 256; */
 	dvb->demux.start_feed = tm6000_start_feed;
 	dvb->demux.stop_feed = tm6000_stop_feed;
 	dvb->demux.write_to_decoder = NULL;
@@ -308,7 +341,7 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
 		usb_free_urb(bulk_urb);
 	}
 
-// 	mutex_lock(&tm6000_driver.open_close_mutex);
+/*	mutex_lock(&tm6000_driver.open_close_mutex); */
 	if(dvb->frontend) {
 		dvb_frontend_detach(dvb->frontend);
 		dvb_unregister_frontend(dvb->frontend);
@@ -318,6 +351,6 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
 	dvb_dmx_release(&dvb->demux);
 	dvb_unregister_adapter(&dvb->adapter);
 	mutex_destroy(&dvb->mutex);
-// 	mutex_unlock(&tm6000_driver.open_close_mutex);
+/*	mutex_unlock(&tm6000_driver.open_close_mutex); */
 
 }
-- 
1.6.4.2

