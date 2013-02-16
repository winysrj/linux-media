Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:50923 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab3BPVZt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 16:25:49 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] redrat3: missing endian conversions and warnings
Date: Sat, 16 Feb 2013 21:25:45 +0000
Message-Id: <d7dc737be5c894cc03e616d63485a856e6436786.1361020108.git.sean@mess.org>
In-Reply-To: <cover.1361020108.git.sean@mess.org>
References: <cover.1361020108.git.sean@mess.org>
In-Reply-To: <cover.1361020108.git.sean@mess.org>
References: <cover.1361020108.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spotted by sparse.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c |   71 +++++++------------------------------------
 1 files changed, 12 insertions(+), 59 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index ec655b8..12167a6 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -54,7 +54,6 @@
 #include <media/rc-core.h>
 
 /* Driver Information */
-#define DRIVER_VERSION "0.70"
 #define DRIVER_AUTHOR "Jarod Wilson <jarod@redhat.com>"
 #define DRIVER_AUTHOR2 "The Dweller, Stephen Cox"
 #define DRIVER_DESC "RedRat3 USB IR Transceiver Driver"
@@ -199,14 +198,9 @@ struct redrat3_dev {
 
 	/* the send endpoint */
 	struct usb_endpoint_descriptor *ep_out;
-	/* the buffer to send data */
-	unsigned char *bulk_out_buf;
-	/* the urb used to send data */
-	struct urb *write_urb;
 
 	/* usb dma */
 	dma_addr_t dma_in;
-	dma_addr_t dma_out;
 
 	/* rx signal timeout timer */
 	struct timer_list rx_timeout;
@@ -239,7 +233,6 @@ static void redrat3_issue_async(struct redrat3_dev *rr3)
 
 	rr3_ftr(rr3->dev, "Entering %s\n", __func__);
 
-	memset(rr3->bulk_in_buf, 0, rr3->ep_in->wMaxPacketSize);
 	res = usb_submit_urb(rr3->read_urb, GFP_ATOMIC);
 	if (res)
 		rr3_dbg(rr3->dev, "%s: receive request FAILED! "
@@ -368,7 +361,7 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
 	struct device *dev;
-	int i, trailer = 0;
+	unsigned i, trailer = 0;
 	unsigned sig_size, single_len, offset, val;
 	unsigned long delay;
 	u32 mod_freq;
@@ -510,15 +503,11 @@ static inline void redrat3_delete(struct redrat3_dev *rr3,
 {
 	rr3_ftr(rr3->dev, "%s cleaning up\n", __func__);
 	usb_kill_urb(rr3->read_urb);
-	usb_kill_urb(rr3->write_urb);
 
 	usb_free_urb(rr3->read_urb);
-	usb_free_urb(rr3->write_urb);
 
-	usb_free_coherent(udev, rr3->ep_in->wMaxPacketSize,
+	usb_free_coherent(udev, le16_to_cpu(rr3->ep_in->wMaxPacketSize),
 			  rr3->bulk_in_buf, rr3->dma_in);
-	usb_free_coherent(udev, rr3->ep_out->wMaxPacketSize,
-			  rr3->bulk_out_buf, rr3->dma_out);
 
 	kfree(rr3);
 }
@@ -566,7 +555,7 @@ static void redrat3_reset(struct redrat3_dev *rr3)
 	rxpipe = usb_rcvctrlpipe(udev, 0);
 	txpipe = usb_sndctrlpipe(udev, 0);
 
-	val = kzalloc(len, GFP_KERNEL);
+	val = kmalloc(len, GFP_KERNEL);
 	if (!val) {
 		dev_err(dev, "Memory allocation failure\n");
 		return;
@@ -620,7 +609,7 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
 	rr3_ftr(rr3->dev, "Exiting %s\n", __func__);
 }
 
-static void redrat3_read_packet_start(struct redrat3_dev *rr3, int len)
+static void redrat3_read_packet_start(struct redrat3_dev *rr3, unsigned len)
 {
 	struct redrat3_header *header = rr3->bulk_in_buf;
 	unsigned pktlen, pkttype;
@@ -659,7 +648,7 @@ static void redrat3_read_packet_start(struct redrat3_dev *rr3, int len)
 	}
 }
 
-static void redrat3_read_packet_continue(struct redrat3_dev *rr3, int len)
+static void redrat3_read_packet_continue(struct redrat3_dev *rr3, unsigned len)
 {
 	void *irdata = &rr3->irdata;
 
@@ -679,7 +668,7 @@ static void redrat3_read_packet_continue(struct redrat3_dev *rr3, int len)
 }
 
 /* gather IR data from incoming urb, process it when we have enough */
-static int redrat3_get_ir_data(struct redrat3_dev *rr3, int len)
+static int redrat3_get_ir_data(struct redrat3_dev *rr3, unsigned len)
 {
 	struct device *dev = rr3->dev;
 	unsigned pkttype;
@@ -755,22 +744,6 @@ static void redrat3_handle_async(struct urb *urb)
 	}
 }
 
-static void redrat3_write_bulk_callback(struct urb *urb)
-{
-	struct redrat3_dev *rr3;
-	int len;
-
-	if (!urb)
-		return;
-
-	rr3 = urb->context;
-	if (rr3) {
-		len = urb->actual_length;
-		rr3_ftr(rr3->dev, "%s: called (status=%d len=%d)\n",
-			__func__, urb->status, len);
-	}
-}
-
 static u16 mod_freq_to_val(unsigned int mod_freq)
 {
 	int mult = 6000000;
@@ -799,11 +772,11 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
 	struct redrat3_irdata *irdata = NULL;
-	int i, ret, ret_len;
+	int ret, ret_len;
 	int lencheck, cur_sample_len, pipe;
 	int *sample_lens = NULL;
 	u8 curlencheck = 0;
-	int sendbuf_len;
+	unsigned i, sendbuf_len;
 
 	rr3_ftr(dev, "Entering %s\n", __func__);
 
@@ -1015,38 +988,18 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	}
 
 	rr3->ep_in = ep_in;
-	rr3->bulk_in_buf = usb_alloc_coherent(udev, ep_in->wMaxPacketSize,
-					      GFP_ATOMIC, &rr3->dma_in);
+	rr3->bulk_in_buf = usb_alloc_coherent(udev,
+		le16_to_cpu(ep_in->wMaxPacketSize), GFP_ATOMIC, &rr3->dma_in);
 	if (!rr3->bulk_in_buf) {
 		dev_err(dev, "Read buffer allocation failure\n");
 		goto error;
 	}
 
 	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
-	usb_fill_bulk_urb(rr3->read_urb, udev, pipe,
-			  rr3->bulk_in_buf, ep_in->wMaxPacketSize,
-			  redrat3_handle_async, rr3);
-
-	/* set up bulk-out endpoint*/
-	rr3->write_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rr3->write_urb) {
-		dev_err(dev, "Write urb allocation failure\n");
-		goto error;
-	}
+	usb_fill_bulk_urb(rr3->read_urb, udev, pipe, rr3->bulk_in_buf,
+		le16_to_cpu(ep_in->wMaxPacketSize), redrat3_handle_async, rr3);
 
 	rr3->ep_out = ep_out;
-	rr3->bulk_out_buf = usb_alloc_coherent(udev, ep_out->wMaxPacketSize,
-					       GFP_ATOMIC, &rr3->dma_out);
-	if (!rr3->bulk_out_buf) {
-		dev_err(dev, "Write buffer allocation failure\n");
-		goto error;
-	}
-
-	pipe = usb_sndbulkpipe(udev, ep_out->bEndpointAddress);
-	usb_fill_bulk_urb(rr3->write_urb, udev, pipe,
-			  rr3->bulk_out_buf, ep_out->wMaxPacketSize,
-			  redrat3_write_bulk_callback, rr3);
-
 	rr3->udev = udev;
 
 	redrat3_reset(rr3);
-- 
1.7.2.5

