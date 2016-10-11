Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39721 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbcJKKfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:23 -0400
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
Subject: [PATCH v2 06/31] cxusb: don't do DMA on stack
Date: Tue, 11 Oct 2016 07:09:21 -0300
Message-Id: <1a139aed3180ae56379f5663e57e90bf9a8a641a.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/cxusb.c | 62 ++++++++++++++++++++++-----------------
 drivers/media/usb/dvb-usb/cxusb.h |  6 ++++
 2 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 907ac01ae297..39772812269d 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -45,9 +45,6 @@
 #include "si2168.h"
 #include "si2157.h"
 
-/* Max transfer size done by I2C transfer functions */
-#define MAX_XFER_SIZE  80
-
 /* debug */
 static int dvb_usb_cxusb_debug;
 module_param_named(debug, dvb_usb_cxusb_debug, int, 0644);
@@ -61,23 +58,27 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static int cxusb_ctrl_msg(struct dvb_usb_device *d,
 			  u8 cmd, u8 *wbuf, int wlen, u8 *rbuf, int rlen)
 {
-	int wo = (rbuf == NULL || rlen == 0); /* write-only */
-	u8 sndbuf[MAX_XFER_SIZE];
+	struct cxusb_state *st = d->priv;
+	int ret, wo;
 
-	if (1 + wlen > sizeof(sndbuf)) {
-		warn("i2c wr: len=%d is too big!\n",
-		     wlen);
+	if (1 + wlen > MAX_XFER_SIZE) {
+		warn("i2c wr: len=%d is too big!\n", wlen);
 		return -EOPNOTSUPP;
 	}
 
-	memset(sndbuf, 0, 1+wlen);
+	wo = (rbuf == NULL || rlen == 0); /* write-only */
 
-	sndbuf[0] = cmd;
-	memcpy(&sndbuf[1], wbuf, wlen);
+	mutex_lock(&st->data_mutex);
+	st->data[0] = cmd;
+	memcpy(&st->data[1], wbuf, wlen);
 	if (wo)
-		return dvb_usb_generic_write(d, sndbuf, 1+wlen);
+		ret = dvb_usb_generic_write(d, st->data, 1 + wlen);
 	else
-		return dvb_usb_generic_rw(d, sndbuf, 1+wlen, rbuf, rlen, 0);
+		ret = dvb_usb_generic_rw(d, st->data, 1 + wlen,
+					 rbuf, rlen, 0);
+
+	mutex_unlock(&st->data_mutex);
+	return ret;
 }
 
 /* GPIO */
@@ -1460,36 +1461,43 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
 {
+	struct dvb_usb_device *d;
+	struct cxusb_state *st;
+
 	if (0 == dvb_usb_device_init(intf, &cxusb_medion_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgh064f_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dee1601_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_lgz201_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dtt7579_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_dualdig4_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_bluebird_nano2_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf,
 				&cxusb_bluebird_nano2_needsfirmware_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_aver_a868r_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf,
 				     &cxusb_bluebird_dualdig4_rev2_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_d680_dmb_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_mygica_d689_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
-	    0)
+				     THIS_MODULE, &d, adapter_nr) ||
+	    0) {
+		st = d->priv;
+		mutex_init(&st->data_mutex);
+
 		return 0;
+	}
 
 	return -EINVAL;
 }
diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
index 527ff7905e15..9f3ee0e47d5c 100644
--- a/drivers/media/usb/dvb-usb/cxusb.h
+++ b/drivers/media/usb/dvb-usb/cxusb.h
@@ -28,10 +28,16 @@
 #define CMD_ANALOG        0x50
 #define CMD_DIGITAL       0x51
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  80
+
 struct cxusb_state {
 	u8 gpio_write_state[3];
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
+
+	unsigned char data[MAX_XFER_SIZE];
+	struct mutex data_mutex;
 };
 
 #endif
-- 
2.7.4


