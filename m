Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938867AbcJGRYq (ORCPT
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
Subject: [PATCH 03/26] cinergyT2-core:: handle error code on RC query
Date: Fri,  7 Oct 2016 14:24:13 -0300
Message-Id: <b43f79337e2d2dadc909b339ca214d44c320e180.1475860773.git.mchehab@s-opensource.com>
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
 drivers/media/usb/dvb-usb/cinergyT2-core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 91640c927776..c9633f5dd482 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -89,7 +89,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	/* Copy this pointer as we are gonna need it in the release phase */
 	cinergyt2_usb_device = adap->dev;
 
-	return 0;
+	return ret;
 }
 
 static struct rc_map_table rc_map_cinergyt2_table[] = {
@@ -149,13 +149,16 @@ static int repeatable_keys[] = {
 static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	struct cinergyt2_state *st = d->priv;
-	int i;
+	int i, ret;
 
 	*state = REMOTE_NO_KEY_PRESSED;
 
 	st->data[0] = CINERGYT2_EP1_GET_RC_EVENTS;
 
-	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (ret < 0)
+		return ret;
+
 	if (st->data[4] == 0xff) {
 		/* key repeat */
 		st->rc_counter++;
-- 
2.7.4


