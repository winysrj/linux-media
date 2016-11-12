Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933360AbcKLOrA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 09:47:00 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/3] [media] gp8psk: fix gp8psk_usb_in_op() logic
Date: Sat, 12 Nov 2016 12:46:27 -0200
Message-Id: <63f2a40077c69be7a37f8b1918c9cdccf429d353.1478960480.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1478960480.git.mchehab@osg.samsung.com>
References: <cover.1478960480.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1478960480.git.mchehab@osg.samsung.com>
References: <cover.1478960480.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Changeset bc29131ecb10 ("[media] gp8psk: don't do DMA on stack")
fixed the usage of DMA on stack, but the memcpy was wrong
for gp8psk_usb_in_op(). Fix it.

>From Derek's email:
	"Fix confirmed using 2 different Skywalker models with
	 HD mpeg4, SD mpeg2."

Suggested-by: Johannes Stezenbach <js@linuxtv.org>
Fixes: bc29131ecb10 ("[media] gp8psk: don't do DMA on stack")
Tested-by: Derek <user.vdr@gmail.com>
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
2.9.3

