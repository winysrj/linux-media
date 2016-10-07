Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936256AbcJGRYq (ORCPT
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
Subject: [PATCH 19/26] nova-t-usb2: don't do DMA on stack
Date: Fri,  7 Oct 2016 14:24:29 -0300
Message-Id: <feab21d551e08f3929d713483a50419ae48386a1.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/nova-t-usb2.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index fc7569e2728d..26d7188a1163 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -74,22 +74,29 @@ static struct rc_map_table rc_map_haupp_table[] = {
  */
 static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	u8 key[5],cmd[2] = { DIBUSB_REQ_POLL_REMOTE, 0x35 }, data,toggle,custom;
+	u8 *buf, data, toggle, custom;
 	u16 raw;
 	int i;
 	struct dibusb_device_state *st = d->priv;
 
-	dvb_usb_generic_rw(d,cmd,2,key,5,0);
+	buf = kmalloc(5, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	buf[0] = DIBUSB_REQ_POLL_REMOTE;
+	buf[1] = 0x35;
+	dvb_usb_generic_rw(d, buf, 2, buf, 5, 0);
 
 	*state = REMOTE_NO_KEY_PRESSED;
-	switch (key[0]) {
+	switch (buf[0]) {
 		case DIBUSB_RC_HAUPPAUGE_KEY_PRESSED:
-			raw = ((key[1] << 8) | key[2]) >> 3;
+			raw = ((buf[1] << 8) | buf[2]) >> 3;
 			toggle = !!(raw & 0x800);
 			data = raw & 0x3f;
 			custom = (raw >> 6) & 0x1f;
 
-			deb_rc("raw key code 0x%02x, 0x%02x, 0x%02x to c: %02x d: %02x toggle: %d\n",key[1],key[2],key[3],custom,data,toggle);
+			deb_rc("raw key code 0x%02x, 0x%02x, 0x%02x to c: %02x d: %02x toggle: %d\n",
+			       buf[1], buf[2], buf[3], custom, data, toggle);
 
 			for (i = 0; i < ARRAY_SIZE(rc_map_haupp_table); i++) {
 				if (rc5_data(&rc_map_haupp_table[i]) == data &&
@@ -117,6 +124,7 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			break;
 	}
 
+	kfree(buf);
 	return 0;
 }
 
-- 
2.7.4


