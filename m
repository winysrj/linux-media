Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46293
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752220AbcJLCiQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 22:38:16 -0400
Date: Tue, 11 Oct 2016 23:13:44 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Subject: [PATCH v2.1 03/31] cinergyT2-core: handle error code on RC query
Message-ID: <20161011231344.7c4f44e6@vento.lan>
In-Reply-To: <20c0b835583ef0a027bd9777a3419a4750f14b28.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
        <20c0b835583ef0a027bd9777a3419a4750f14b28.1476179975.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no sense on decoding and generating a RC key code if
there was an error on the URB control message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index d85c0c4d4042..8ac825413d5a 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -102,7 +102,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	/* Copy this pointer as we are gonna need it in the release phase */
 	cinergyt2_usb_device = adap->dev;
 
-	return 0;
+	return ret;
 }
 
 static struct rc_map_table rc_map_cinergyt2_table[] = {
@@ -162,14 +162,16 @@ static int repeatable_keys[] = {
 static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	struct cinergyt2_state *st = d->priv;
-	int i;
+	int i, ret;
 
 	*state = REMOTE_NO_KEY_PRESSED;
 
 	mutex_lock(&st->data_mutex);
 	st->data[0] = CINERGYT2_EP1_GET_RC_EVENTS;
 
-	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (ret < 0)
+		goto ret;
 
 	if (st->data[4] == 0xff) {
 		/* key repeat */
