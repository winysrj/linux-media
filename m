Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:46987 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2HMM7x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:53 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 03/13] [media] iguanair: advertise the resolution and timeout properly
Date: Mon, 13 Aug 2012 13:59:41 +0100
Message-Id: <1344862791-30352-3-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the timeout supplied the interface can go idle. The keymap is
the same one as other drivers which do not come with a remote.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 5885400..7eeabdb 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -75,6 +75,7 @@ struct iguanair {
 
 #define MAX_PACKET_SIZE		8u
 #define TIMEOUT			1000
+#define RX_RESOLUTION		21333
 
 struct packet {
 	uint16_t start;
@@ -142,7 +143,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 			} else {
 				rawir.pulse = (ir->buf_in[i] & 0x80) == 0;
 				rawir.duration = ((ir->buf_in[i] & 0x7f) + 1) *
-									 21330;
+								 RX_RESOLUTION;
 			}
 
 			ir_raw_event_store_with_filter(ir->rc, &rawir);
@@ -504,7 +505,9 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	rc->s_tx_carrier = iguanair_set_tx_carrier;
 	rc->tx_ir = iguanair_tx;
 	rc->driver_name = DRIVER_NAME;
-	rc->map_name = RC_MAP_EMPTY;
+	rc->map_name = RC_MAP_RC6_MCE;
+	rc->timeout = MS_TO_NS(100);
+	rc->rx_resolution = RX_RESOLUTION;
 
 	iguanair_set_tx_carrier(rc, 38000);
 
-- 
1.7.11.2

