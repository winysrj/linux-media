Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbcKGMxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 07:53:00 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] [media] gp8psk: fix gp8psk_usb_in_op() logic
Date: Mon,  7 Nov 2016 10:52:51 -0200
Message-Id: <65d65d048e6fa6964ccf679f400b964afac5d782.1478523166.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset bc29131ecb10 ("[media] gp8psk: don't do DMA on stack")
fixed the usage of DMA on stack, but the memcpy was wrong
for gp8psk_usb_in_op(). Fix it.

Suggested-by: Johannes Stezenbach <js@linuxtv.org>
Fixes: bc29131ecb10 ("[media] gp8psk: don't do DMA on stack")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/gp8psk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index adfd76491451..2829e3082d15 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -67,7 +67,6 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 		return ret;
 
 	while (ret >= 0 && ret != blen && try < 3) {
-		memcpy(st->data, b, blen);
 		ret = usb_control_msg(d->udev,
 			usb_rcvctrlpipe(d->udev,0),
 			req,
@@ -81,8 +80,10 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 	if (ret < 0 || ret != blen) {
 		warn("usb in %d operation failed.", req);
 		ret = -EIO;
-	} else
+	} else {
 		ret = 0;
+		memcpy(b, st->data, blen);
+	}
 
 	deb_xfer("in: req. %x, val: %x, ind: %x, buffer: ",req,value,index);
 	debug_dump(b,blen,deb_xfer);
-- 
2.7.4

