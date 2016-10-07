Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46761 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938814AbcJGRYq (ORCPT
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
Subject: [PATCH 02/26] cinergyT2-core: don't do DMA on stack
Date: Fri,  7 Oct 2016 14:24:12 -0300
Message-Id: <9589abc05caa366003d399d6f3fe5a5ca2ab8c97.1475860773.git.mchehab@s-opensource.com>
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
 drivers/media/usb/dvb-usb/cinergyT2-core.c | 45 ++++++++++++++++++------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 9fd1527494eb..91640c927776 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -41,6 +41,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct cinergyt2_state {
 	u8 rc_counter;
+	unsigned char data[64];
 };
 
 /* We are missing a release hook with usb_device data */
@@ -50,29 +51,36 @@ static struct dvb_usb_device_properties cinergyt2_properties;
 
 static int cinergyt2_streaming_ctrl(struct dvb_usb_adapter *adap, int enable)
 {
-	char buf[] = { CINERGYT2_EP1_CONTROL_STREAM_TRANSFER, enable ? 1 : 0 };
-	char result[64];
-	return dvb_usb_generic_rw(adap->dev, buf, sizeof(buf), result,
-				sizeof(result), 0);
+	struct dvb_usb_device *d = adap->dev;
+	struct cinergyt2_state *st = d->priv;
+
+	st->data[0] = CINERGYT2_EP1_CONTROL_STREAM_TRANSFER;
+	st->data[1] = enable ? 1 : 0;
+
+	return dvb_usb_generic_rw(d, st->data, 2, st->data, 64, 0);
 }
 
 static int cinergyt2_power_ctrl(struct dvb_usb_device *d, int enable)
 {
-	char buf[] = { CINERGYT2_EP1_SLEEP_MODE, enable ? 0 : 1 };
-	char state[3];
-	return dvb_usb_generic_rw(d, buf, sizeof(buf), state, sizeof(state), 0);
+	struct cinergyt2_state *st = d->priv;
+
+	st->data[0] = CINERGYT2_EP1_SLEEP_MODE;
+	st->data[1] = enable ? 0 : 1;
+
+	return dvb_usb_generic_rw(d, st->data, 2, st->data, 3, 0);
 }
 
 static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	char query[] = { CINERGYT2_EP1_GET_FIRMWARE_VERSION };
-	char state[3];
+	struct dvb_usb_device *d = adap->dev;
+	struct cinergyt2_state *st = d->priv;
 	int ret;
 
 	adap->fe_adap[0].fe = cinergyt2_fe_attach(adap->dev);
 
-	ret = dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
-				sizeof(state), 0);
+	st->data[0] = CINERGYT2_EP1_GET_FIRMWARE_VERSION;
+
+	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 3, 0);
 	if (ret < 0) {
 		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
 			"state info\n");
@@ -141,13 +149,14 @@ static int repeatable_keys[] = {
 static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	struct cinergyt2_state *st = d->priv;
-	u8 key[5] = {0, 0, 0, 0, 0}, cmd = CINERGYT2_EP1_GET_RC_EVENTS;
 	int i;
 
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
-	if (key[4] == 0xff) {
+	st->data[0] = CINERGYT2_EP1_GET_RC_EVENTS;
+
+	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (st->data[4] == 0xff) {
 		/* key repeat */
 		st->rc_counter++;
 		if (st->rc_counter > RC_REPEAT_DELAY) {
@@ -166,13 +175,13 @@ static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	}
 
 	/* hack to pass checksum on the custom field */
-	key[2] = ~key[1];
-	dvb_usb_nec_rc_key_to_event(d, key, event, state);
-	if (key[0] != 0) {
+	st->data[2] = ~st->data[1];
+	dvb_usb_nec_rc_key_to_event(d, st->data, event, state);
+	if (st->data[0] != 0) {
 		if (*event != d->last_event)
 			st->rc_counter = 0;
 
-		deb_rc("key: %*ph\n", 5, key);
+		deb_rc("key: %*ph\n", 5, st->data);
 	}
 	return 0;
 }
-- 
2.7.4


