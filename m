Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935727AbcJGRYq (ORCPT
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
Subject: [PATCH 26/26] digitv: handle error code on RC query
Date: Fri,  7 Oct 2016 14:24:36 -0300
Message-Id: <9191b3e28e65ea9f3bae7b7b01441ff748f94998.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no sense on decoding and generating a RC key code if
there was an error on the URB control message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/digitv.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/digitv.c b/drivers/media/usb/dvb-usb/digitv.c
index 09f8c28bd4db..4284f6984dc1 100644
--- a/drivers/media/usb/dvb-usb/digitv.c
+++ b/drivers/media/usb/dvb-usb/digitv.c
@@ -29,7 +29,9 @@ static int digitv_ctrl_msg(struct dvb_usb_device *d,
 		u8 cmd, u8 vv, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
 	struct digitv_state *st = d->priv;
-	int wo = (rbuf == NULL || rlen == 0); /* write-only */
+	int ret, wo;
+
+	wo = (rbuf == NULL || rlen == 0); /* write-only */
 
 	memset(st->sndbuf, 0, 7);
 	memset(st->rcvbuf, 0, 7);
@@ -40,12 +42,12 @@ static int digitv_ctrl_msg(struct dvb_usb_device *d,
 
 	if (wo) {
 		memcpy(&st->sndbuf[3], wbuf, wlen);
-		dvb_usb_generic_write(d, st->sndbuf, 7);
+		ret = dvb_usb_generic_write(d, st->sndbuf, 7);
 	} else {
-		dvb_usb_generic_rw(d, st->sndbuf, 7, st->rcvbuf, 7, 10);
+		ret = dvb_usb_generic_rw(d, st->sndbuf, 7, st->rcvbuf, 7, 10);
 		memcpy(rbuf, &st->rcvbuf[3], rlen);
 	}
-	return 0;
+	return ret;
 }
 
 /* I2C */
-- 
2.7.4


