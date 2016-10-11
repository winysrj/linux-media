Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39714 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcJKKfU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:20 -0400
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
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 10/31] dibusb: handle error code on RC query
Date: Tue, 11 Oct 2016 07:09:25 -0300
Message-Id: <0b195100070bf4ba74dce76362c851d49284d104.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no sense on decoding and generating a RC key code if
there was an error on the URB control message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index 951f3dac9082..b0fd9a609352 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -366,6 +366,7 @@ EXPORT_SYMBOL(rc_map_dibusb_table);
 int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 *buf;
+	int ret;
 
 	buf = kmalloc(5, GFP_KERNEL);
 	if (!buf)
@@ -373,7 +374,9 @@ int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 	buf[0] = DIBUSB_REQ_POLL_REMOTE;
 
-	dvb_usb_generic_rw(d, buf, 1, buf, 5, 0);
+	ret = dvb_usb_generic_rw(d, buf, 1, buf, 5, 0);
+	if (ret < 0)
+		goto ret;
 
 	dvb_usb_nec_rc_key_to_event(d, buf, event, state);
 
@@ -382,6 +385,7 @@ int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 	kfree(buf);
 
-	return 0;
+ret:
+	return ret;
 }
 EXPORT_SYMBOL(dibusb_rc_query);
-- 
2.7.4


