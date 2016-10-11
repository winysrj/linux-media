Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39784 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbcJKKht (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:37:49 -0400
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
Subject: [PATCH v2 25/31] nova-t-usb2: handle error code on RC query
Date: Tue, 11 Oct 2016 07:09:40 -0300
Message-Id: <94b9c99b381cf64468868aef2f64e80639b3238a.1476179975.git.mchehab@s-opensource.com>
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
 drivers/media/usb/dvb-usb/nova-t-usb2.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/nova-t-usb2.c b/drivers/media/usb/dvb-usb/nova-t-usb2.c
index 26d7188a1163..1babd3341910 100644
--- a/drivers/media/usb/dvb-usb/nova-t-usb2.c
+++ b/drivers/media/usb/dvb-usb/nova-t-usb2.c
@@ -76,7 +76,7 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 *buf, data, toggle, custom;
 	u16 raw;
-	int i;
+	int i, ret;
 	struct dibusb_device_state *st = d->priv;
 
 	buf = kmalloc(5, GFP_KERNEL);
@@ -85,7 +85,9 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 
 	buf[0] = DIBUSB_REQ_POLL_REMOTE;
 	buf[1] = 0x35;
-	dvb_usb_generic_rw(d, buf, 2, buf, 5, 0);
+	ret = dvb_usb_generic_rw(d, buf, 2, buf, 5, 0);
+	if (ret < 0)
+		goto ret;
 
 	*state = REMOTE_NO_KEY_PRESSED;
 	switch (buf[0]) {
@@ -124,8 +126,9 @@ static int nova_t_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 			break;
 	}
 
+ret:
 	kfree(buf);
-	return 0;
+	return ret;
 }
 
 static int nova_t_read_mac_address (struct dvb_usb_device *d, u8 mac[6])
-- 
2.7.4


