Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34898 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdFAHqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 03:46:10 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 2/2] [media] mceusb: drop redundant urb reinitialisation
Date: Thu,  1 Jun 2017 09:46:00 +0200
Message-Id: <20170601074600.20548-2-johan@kernel.org>
In-Reply-To: <20170601074600.20548-1-johan@kernel.org>
References: <20170601074600.20548-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop a since commit e1159cb35712 ("[media] mceusb: remove pointless
mce_flush_rx_buffer function") redundant reinitialisation of two urb
fields immediately after they have been initialised.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/rc/mceusb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 0a16bd34ee4e..cba7ae90c000 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -760,9 +760,6 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 
 	dev_dbg(dev, "receive request called (size=%#x)", size);
 
-	async_urb->transfer_buffer_length = size;
-	async_urb->dev = ir->usbdev;
-
 	res = usb_submit_urb(async_urb, GFP_ATOMIC);
 	if (res) {
 		dev_err(dev, "receive request FAILED! (res=%d)", res);
-- 
2.13.0
