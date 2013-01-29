Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:34581 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3A2MTe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 07:19:34 -0500
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH 5/5] [media] redrat3: fix transmit return value and overrun
Date: Tue, 29 Jan 2013 12:19:31 +0000
Message-Id: <1359461971-27492-5-git-send-email-sean@mess.org>
In-Reply-To: <1359461971-27492-1-git-send-email-sean@mess.org>
References: <1359461971-27492-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If more than 127 different lengths are transmitted then the driver causes
an overrun on sample_lens. Try to send as much as possible and return the
amount sent.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/redrat3.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 1800326..1b37fe2 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -195,9 +195,6 @@ struct redrat3_dev {
 	dma_addr_t dma_in;
 	dma_addr_t dma_out;
 
-	/* locks this structure */
-	struct mutex lock;
-
 	/* rx signal timeout timer */
 	struct timer_list rx_timeout;
 	u32 hw_timeout;
@@ -922,8 +919,7 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		return -EAGAIN;
 	}
 
-	if (count > (RR3_DRIVER_MAXLENS * 2))
-		return -EINVAL;
+	count = min_t(unsigned, count, RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN);
 
 	/* rr3 will disable rc detector on transmit */
 	rr3->det_enabled = false;
@@ -936,24 +932,22 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	}
 
 	for (i = 0; i < count; i++) {
+		cur_sample_len = redrat3_us_to_len(txbuf[i]);
 		for (lencheck = 0; lencheck < curlencheck; lencheck++) {
-			cur_sample_len = redrat3_us_to_len(txbuf[i]);
 			if (sample_lens[lencheck] == cur_sample_len)
 				break;
 		}
 		if (lencheck == curlencheck) {
-			cur_sample_len = redrat3_us_to_len(txbuf[i]);
 			rr3_dbg(dev, "txbuf[%d]=%u, pos %d, enc %u\n",
 				i, txbuf[i], curlencheck, cur_sample_len);
-			if (curlencheck < 255) {
+			if (curlencheck < RR3_DRIVER_MAXLENS) {
 				/* now convert the value to a proper
 				 * rr3 value.. */
 				sample_lens[curlencheck] = cur_sample_len;
 				curlencheck++;
 			} else {
-				dev_err(dev, "signal too long\n");
-				ret = -EINVAL;
-				goto out;
+				count = i - 1;
+				break;
 			}
 		}
 	}
@@ -1087,6 +1081,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
 	rc->driver_name = DRIVER_NAME;
+	rc->rx_resolution = US_TO_NS(2);
 	rc->map_name = RC_MAP_HAUPPAUGE;
 
 	ret = rc_register_device(rc);
@@ -1202,7 +1197,6 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 			  rr3->bulk_out_buf, ep_out->wMaxPacketSize,
 			  (usb_complete_t)redrat3_write_bulk_callback, rr3);
 
-	mutex_init(&rr3->lock);
 	rr3->udev = udev;
 
 	redrat3_reset(rr3);
-- 
1.8.1

