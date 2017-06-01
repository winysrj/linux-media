Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34417 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdFAHqK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Jun 2017 03:46:10 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>, Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2] [media] mceusb: fix memory leaks in error path
Date: Thu,  1 Jun 2017 09:45:59 +0200
Message-Id: <20170601074600.20548-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix urb and transfer-buffer leaks in an urb-submission error path which
may be hit when a device is disconnected.

Fixes: 66e89522aff7 ("V4L/DVB: IR: add mceusb IR receiver driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.36
Cc: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/rc/mceusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 93b16fe3ab38..0a16bd34ee4e 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -766,6 +766,8 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 	res = usb_submit_urb(async_urb, GFP_ATOMIC);
 	if (res) {
 		dev_err(dev, "receive request FAILED! (res=%d)", res);
+		kfree(async_buf);
+		usb_free_urb(async_urb);
 		return;
 	}
 	dev_dbg(dev, "receive request complete (res=%d)", res);
-- 
2.13.0
