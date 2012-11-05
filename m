Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:35237 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070Ab2KEX2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 18:28:35 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 1/5] [media] dvb-usb: add a pre_init hook to struct dvb_usb_device_properties
Date: Tue,  6 Nov 2012 00:28:12 +0100
Message-Id: <1352158096-17737-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices need to issue a pre-initialization command sequence via
i2c in order to "enable" the communication with some adapter components.

This happens for instance in the vp7049 USB DVB-T stick on which the
frontend cannot be detected without first sending a certain sequence of
commands via i2c.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

If this approach is OK I can send a similar patch for dvb-usb-v2.

Are all the dvb-usb drivers going to be ported to dvb-usb-v2 eventually?


 drivers/media/usb/dvb-usb/dvb-usb.h      |    5 +++++
 drivers/media/usb/dvb-usb/dvb-usb-init.c |    6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index aab0f99..1fcea68 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -233,6 +233,9 @@ enum dvb_usb_mode {
  * @size_of_priv: how many bytes shall be allocated for the private field
  *  of struct dvb_usb_device.
  *
+ * @pre_init: function executed after i2c initialization but
+ *   before the adapters get initialized
+ *
  * @power_ctrl: called to enable/disable power of the device.
  * @read_mac_address: called to read the MAC address of the device.
  * @identify_state: called to determine the state (cold or warm), when it
@@ -274,6 +277,8 @@ struct dvb_usb_device_properties {
 
 	int size_of_priv;
 
+	int (*pre_init) (struct dvb_usb_device *);
+
 	int num_adapters;
 	struct dvb_usb_adapter_properties adapter[MAX_NO_OF_ADAPTER_PER_DEVICE];
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 169196e..8ab916e 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -31,6 +31,12 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 	struct dvb_usb_adapter *adap;
 	int ret, n, o;
 
+	if (d->props.pre_init) {
+		ret = d->props.pre_init(d);
+		if (ret < 0)
+			return ret;
+	}
+
 	for (n = 0; n < d->props.num_adapters; n++) {
 		adap = &d->adapter[n];
 		adap->dev = d;
-- 
1.7.10.4

