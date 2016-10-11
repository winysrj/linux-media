Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39707 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbcJKKfH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:07 -0400
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
Subject: [PATCH v2 16/31] dtt200u: handle USB control message errors
Date: Tue, 11 Oct 2016 07:09:31 -0300
Message-Id: <5c82c97cddb18682b549fcc3a9066ee2e2579fda.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If something bad happens while an USB control message is
transfered, return an error code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index 7706938b5167..f88572c7ae7c 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -28,37 +28,42 @@ struct dtt200u_state {
 static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	struct dtt200u_state *st = d->priv;
+	int ret = 0;
 
 	mutex_lock(&st->data_mutex);
 
 	st->data[0] = SET_INIT;
 
 	if (onoff)
-		dvb_usb_generic_write(d, st->data, 2);
+		ret = dvb_usb_generic_write(d, st->data, 2);
 
 	mutex_unlock(&st->data_mutex);
-	return 0;
+	return ret;
 }
 
 static int dtt200u_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dtt200u_state *st = adap->dev->priv;
+	int ret;
 
 	mutex_lock(&st->data_mutex);
 	st->data[0] = SET_STREAMING;
 	st->data[1] = onoff;
 
-	dvb_usb_generic_write(adap->dev, st->data, 2);
+	ret = dvb_usb_generic_write(adap->dev, st->data, 2);
+	if (ret < 0)
+		goto ret;
 
 	if (onoff)
-		return 0;
+		goto ret;
 
 	st->data[0] = RESET_PID_FILTER;
-	dvb_usb_generic_write(adap->dev, st->data, 1);
+	ret = dvb_usb_generic_write(adap->dev, st->data, 1);
 
+ret:
 	mutex_unlock(&st->data_mutex);
 
-	return 0;
+	return ret;
 }
 
 static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
@@ -84,11 +89,15 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 {
 	struct dtt200u_state *st = d->priv;
 	u32 scancode;
+	int ret;
 
 	mutex_lock(&st->data_mutex);
 	st->data[0] = GET_RC_CODE;
 
-	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	ret = dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (ret < 0)
+		goto ret;
+
 	if (st->data[0] == 1) {
 		enum rc_type proto = RC_TYPE_NEC;
 
@@ -116,8 +125,9 @@ static int dtt200u_rc_query(struct dvb_usb_device *d)
 	if (st->data[0] != 0)
 		deb_info("st->data: %*ph\n", 5, st->data);
 
+ret:
 	mutex_unlock(&st->data_mutex);
-	return 0;
+	return ret;
 }
 
 static int dtt200u_frontend_attach(struct dvb_usb_adapter *adap)
-- 
2.7.4


