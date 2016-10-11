Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39695 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbcJKKeu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:34:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>
Subject: [PATCH v2 19/31] gp8psk: don't go past the buffer size
Date: Tue, 11 Oct 2016 07:09:34 -0300
Message-Id: <0b4b9ad015d89927b6dce85bcd9a6e3d58bf2e36.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add checks to avoid going out of the buffer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/gp8psk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index fa215ad37f7b..a745cf636846 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -60,6 +60,9 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 	struct gp8psk_state *st = d->priv;
 	int ret = 0,try = 0;
 
+	if (blen > sizeof(st->data))
+		return -EIO;
+
 	if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
 		return ret;
 
@@ -98,6 +101,9 @@ int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 	deb_xfer("out: req. %x, val: %x, ind: %x, buffer: ",req,value,index);
 	debug_dump(b,blen,deb_xfer);
 
+	if (blen > sizeof(st->data))
+		return -EIO;
+
 	if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
 		return ret;
 
@@ -151,6 +157,11 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 			err("failed to load bcm4500 firmware.");
 			goto out_free;
 		}
+		if (buflen > 64) {
+			err("firmare chunk size bigger than 64 bytes.");
+			goto out_free;
+		}
+
 		memcpy(buf, ptr, buflen);
 		if (dvb_usb_generic_write(d, buf, buflen)) {
 			err("failed to load bcm4500 firmware.");
-- 
2.7.4


