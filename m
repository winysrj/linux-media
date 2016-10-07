Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46775 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935812AbcJGRYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:46 -0400
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
Subject: [PATCH 23/26] dvb-usb: warn if return value for USB read/write routines is not checked
Date: Fri,  7 Oct 2016 14:24:33 -0300
Message-Id: <ace9874a2d3bf1bcb4161086dc58b7b5a762ee1a.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the return values for dvb_usb_generic_rw() and dvb_usb_generic_write()
should be checked, as otherwise the drivers won't be doing the right
thing in the case of errors.

So, add __must_check to both declarations.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dvb-usb.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index 639c4678c65b..1448c3d27ea2 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -462,8 +462,10 @@ extern int dvb_usb_device_init(struct usb_interface *,
 extern void dvb_usb_device_exit(struct usb_interface *);
 
 /* the generic read/write method for device control */
-extern int dvb_usb_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16,int);
-extern int dvb_usb_generic_write(struct dvb_usb_device *, u8 *, u16);
+extern int __must_check
+dvb_usb_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16, int);
+extern int __must_check
+dvb_usb_generic_write(struct dvb_usb_device *, u8 *, u16);
 
 /* commonly used remote control parsing */
 extern int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *, u8[], u32 *, int *);
-- 
2.7.4


