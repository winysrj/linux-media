Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:47000 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2HMM7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:54 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 06/13] [media] iguanair: reset the IR state after rx overflow or receiver enable
Date: Mon, 13 Aug 2012 13:59:44 +0100
Message-Id: <1344862791-30352-6-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index a6a19eb..9810008 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -124,6 +124,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 			break;
 		case CMD_RX_OVERFLOW:
 			dev_warn(ir->dev, "receive overflow\n");
+			ir_raw_event_reset(ir->rc);
 			break;
 		default:
 			dev_warn(ir->dev, "control code %02x received\n",
@@ -256,6 +257,9 @@ static int iguanair_receiver(struct iguanair *ir, bool enable)
 	struct packet packet = { 0, DIR_OUT, enable ?
 				CMD_RECEIVER_ON : CMD_RECEIVER_OFF };
 
+	if (enable)
+		ir_raw_event_reset(ir->rc);
+
 	return iguanair_send(ir, &packet, sizeof(packet));
 }
 
-- 
1.7.11.2

