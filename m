Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33775 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKJKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:10:14 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 27/50] USBNET: hso: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:50 +0800
Message-Id: <1373533573-12272-28-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: netdev@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/net/usb/hso.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index cba1d46..c865441 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1008,6 +1008,7 @@ static void read_bulk_callback(struct urb *urb)
 	struct net_device *net;
 	int result;
 	int status = urb->status;
+	unsigned long flags;
 
 	/* is al ok?  (Filip: Who's Al ?) */
 	if (status) {
@@ -1036,11 +1037,11 @@ static void read_bulk_callback(struct urb *urb)
 	if (urb->actual_length) {
 		/* Handle the IP stream, add header and push it onto network
 		 * stack if the packet is complete. */
-		spin_lock(&odev->net_lock);
+		spin_lock_irqsave(&odev->net_lock, flags);
 		packetizeRx(odev, urb->transfer_buffer, urb->actual_length,
 			    (urb->transfer_buffer_length >
 			     urb->actual_length) ? 1 : 0);
-		spin_unlock(&odev->net_lock);
+		spin_unlock_irqrestore(&odev->net_lock, flags);
 	}
 
 	/* We are done with this URB, resubmit it. Prep the USB to wait for
@@ -1201,6 +1202,7 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
 {
 	struct hso_serial *serial = urb->context;
 	int status = urb->status;
+	unsigned long flags;
 
 	/* sanity check */
 	if (!serial) {
@@ -1223,17 +1225,17 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
 		if (serial->parent->port_spec & HSO_INFO_CRC_BUG)
 			fix_crc_bug(urb, serial->in_endp->wMaxPacketSize);
 		/* Valid data, handle RX data */
-		spin_lock(&serial->serial_lock);
+		spin_lock_irqsave(&serial->serial_lock, flags);
 		serial->rx_urb_filled[hso_urb_to_index(serial, urb)] = 1;
 		put_rxbuf_data_and_resubmit_bulk_urb(serial);
-		spin_unlock(&serial->serial_lock);
+		spin_unlock_irqrestore(&serial->serial_lock, flags);
 	} else if (status == -ENOENT || status == -ECONNRESET) {
 		/* Unlinked - check for throttled port. */
 		D2("Port %d, successfully unlinked urb", serial->minor);
-		spin_lock(&serial->serial_lock);
+		spin_lock_irqsave(&serial->serial_lock, flags);
 		serial->rx_urb_filled[hso_urb_to_index(serial, urb)] = 0;
 		hso_resubmit_rx_bulk_urb(serial, urb);
-		spin_unlock(&serial->serial_lock);
+		spin_unlock_irqrestore(&serial->serial_lock, flags);
 	} else {
 		D2("Port %d, status = %d for read urb", serial->minor, status);
 		return;
@@ -1510,12 +1512,13 @@ static void tiocmget_intr_callback(struct urb *urb)
 		DUMP(serial_state_notification,
 		     sizeof(struct hso_serial_state_notification));
 	} else {
+		unsigned long flags;
 
 		UART_state_bitmap = le16_to_cpu(serial_state_notification->
 						UART_state_bitmap);
 		prev_UART_state_bitmap = tiocmget->prev_UART_state_bitmap;
 		icount = &tiocmget->icount;
-		spin_lock(&serial->serial_lock);
+		spin_lock_irqsave(&serial->serial_lock, flags);
 		if ((UART_state_bitmap & B_OVERRUN) !=
 		   (prev_UART_state_bitmap & B_OVERRUN))
 			icount->parity++;
@@ -1538,7 +1541,7 @@ static void tiocmget_intr_callback(struct urb *urb)
 		   (prev_UART_state_bitmap & B_RX_CARRIER))
 			icount->dcd++;
 		tiocmget->prev_UART_state_bitmap = UART_state_bitmap;
-		spin_unlock(&serial->serial_lock);
+		spin_unlock_irqrestore(&serial->serial_lock, flags);
 		tiocmget->intr_completed = 1;
 		wake_up_interruptible(&tiocmget->waitq);
 	}
@@ -1883,8 +1886,9 @@ static void intr_callback(struct urb *urb)
 			serial = get_serial_by_shared_int_and_type(shared_int,
 								   (1 << i));
 			if (serial != NULL) {
+				unsigned long flags;
 				D1("Pending read interrupt on port %d\n", i);
-				spin_lock(&serial->serial_lock);
+				spin_lock_irqsave(&serial->serial_lock, flags);
 				if (serial->rx_state == RX_IDLE &&
 					serial->port.count > 0) {
 					/* Setup and send a ctrl req read on
@@ -1898,7 +1902,7 @@ static void intr_callback(struct urb *urb)
 					D1("Already a read pending on "
 					   "port %d or port not open\n", i);
 				}
-				spin_unlock(&serial->serial_lock);
+				spin_unlock_irqrestore(&serial->serial_lock, flags);
 			}
 		}
 	}
@@ -1925,6 +1929,7 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 {
 	struct hso_serial *serial = urb->context;
 	int status = urb->status;
+	unsigned long flags;
 
 	/* sanity check */
 	if (!serial) {
@@ -1932,9 +1937,9 @@ static void hso_std_serial_write_bulk_callback(struct urb *urb)
 		return;
 	}
 
-	spin_lock(&serial->serial_lock);
+	spin_lock_irqsave(&serial->serial_lock, flags);
 	serial->tx_urb_used = 0;
-	spin_unlock(&serial->serial_lock);
+	spin_unlock_irqrestore(&serial->serial_lock, flags);
 	if (status) {
 		handle_usb_error(status, __func__, serial->parent);
 		return;
@@ -1976,14 +1981,15 @@ static void ctrl_callback(struct urb *urb)
 	struct hso_serial *serial = urb->context;
 	struct usb_ctrlrequest *req;
 	int status = urb->status;
+	unsigned long flags;
 
 	/* sanity check */
 	if (!serial)
 		return;
 
-	spin_lock(&serial->serial_lock);
+	spin_lock_irqsave(&serial->serial_lock, flags);
 	serial->tx_urb_used = 0;
-	spin_unlock(&serial->serial_lock);
+	spin_unlock_irqrestore(&serial->serial_lock, flags);
 	if (status) {
 		handle_usb_error(status, __func__, serial->parent);
 		return;
@@ -1999,9 +2005,9 @@ static void ctrl_callback(struct urb *urb)
 	    (USB_DIR_IN | USB_TYPE_OPTION_VENDOR | USB_RECIP_INTERFACE)) {
 		/* response to a read command */
 		serial->rx_urb_filled[0] = 1;
-		spin_lock(&serial->serial_lock);
+		spin_lock_irqsave(&serial->serial_lock, flags);
 		put_rxbuf_data_and_resubmit_ctrl_urb(serial);
-		spin_unlock(&serial->serial_lock);
+		spin_unlock_irqrestore(&serial->serial_lock, flags);
 	} else {
 		hso_put_activity(serial->parent);
 		tty_port_tty_wakeup(&serial->port);
-- 
1.7.9.5

