Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46877 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941182AbcJGRYv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:51 -0400
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
        Sean Young <sean@mess.org>,
        Jonathan McDowell <noodles@earth.li>
Subject: [PATCH 15/26] dtt200u: handle USB control message errors
Date: Fri,  7 Oct 2016 14:24:25 -0300
Message-Id: <9d890361120bf2a60800248f57636a982fb3e396.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If something bad happens while an USB control message is
transfered, return an error code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index d6023fb6a1d4..ca8965b8b610 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -31,7 +31,7 @@ static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
 	st->data[0] = SET_INIT;
 
 	if (onoff)
-		dvb_usb_generic_write(d, st->data, 2);
+		return dvb_usb_generic_write(d, st->data, 2);
 
 	return 0;
 }
@@ -39,19 +39,20 @@ static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
 static int dtt200u_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dtt200u_state *st = adap->dev->priv;
+	int ret;
 
 	st->data[0] = SET_STREAMING;
 	st->data[1] = onoff;
 
-	dvb_usb_generic_write(adap->dev, st->data, 2);
+	ret = dvb_usb_generic_write(adap->dev, st->data, 2);
+	if (ret < 0)
+		return ret;
 
 	if (onoff)
 		return 0;
 
 	st->data[0] = RESET_PID_FILTER;
-	dvb_usb_generic_write(adap->dev, st->data, 1);
-
-	return 0;
+	return dvb_usb_generic_write(adap->dev, st->data, 1);
 }
 
 static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
@@ -72,10 +73,14 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 {
 	struct dtt200u_state *st = d->priv;
 	u32 scancode;
+	int ret;
 
 	st->data[0] = GET_RC_CODE;
 
-	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (ret < 0)
+		return ret;
+
 	if (st->data[0] == 1) {
 		enum rc_type proto = RC_TYPE_NEC;
 
-- 
2.7.4


