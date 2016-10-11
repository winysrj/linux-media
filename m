Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbcJKKfA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
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
        Jonathan McDowell <noodles@earth.li>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 15/31] dtt200u: don't do DMA on stack
Date: Tue, 11 Oct 2016 07:09:30 -0300
Message-Id: <718881f8b98faffba1fdc658b4f9aa6bdf0b762d.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u.c | 104 ++++++++++++++++++++++++++----------
 1 file changed, 75 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u.c b/drivers/media/usb/dvb-usb/dtt200u.c
index d2a01b50af0d..7706938b5167 100644
--- a/drivers/media/usb/dvb-usb/dtt200u.c
+++ b/drivers/media/usb/dvb-usb/dtt200u.c
@@ -20,74 +20,103 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2 (or-able))." DVB_USB
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+struct dtt200u_state {
+	unsigned char data[80];
+	struct mutex data_mutex;
+};
+
 static int dtt200u_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	u8 b = SET_INIT;
+	struct dtt200u_state *st = d->priv;
+
+	mutex_lock(&st->data_mutex);
+
+	st->data[0] = SET_INIT;
 
 	if (onoff)
-		dvb_usb_generic_write(d,&b,2);
+		dvb_usb_generic_write(d, st->data, 2);
 
+	mutex_unlock(&st->data_mutex);
 	return 0;
 }
 
 static int dtt200u_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	u8 b_streaming[2] = { SET_STREAMING, onoff };
-	u8 b_rst_pid = RESET_PID_FILTER;
+	struct dtt200u_state *st = adap->dev->priv;
 
-	dvb_usb_generic_write(adap->dev, b_streaming, 2);
+	mutex_lock(&st->data_mutex);
+	st->data[0] = SET_STREAMING;
+	st->data[1] = onoff;
+
+	dvb_usb_generic_write(adap->dev, st->data, 2);
+
+	if (onoff)
+		return 0;
+
+	st->data[0] = RESET_PID_FILTER;
+	dvb_usb_generic_write(adap->dev, st->data, 1);
+
+	mutex_unlock(&st->data_mutex);
 
-	if (onoff == 0)
-		dvb_usb_generic_write(adap->dev, &b_rst_pid, 1);
 	return 0;
 }
 
 static int dtt200u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
 {
-	u8 b_pid[4];
+	struct dtt200u_state *st = adap->dev->priv;
+	int ret;
+
 	pid = onoff ? pid : 0;
 
-	b_pid[0] = SET_PID_FILTER;
-	b_pid[1] = index;
-	b_pid[2] = pid & 0xff;
-	b_pid[3] = (pid >> 8) & 0x1f;
+	mutex_lock(&st->data_mutex);
+	st->data[0] = SET_PID_FILTER;
+	st->data[1] = index;
+	st->data[2] = pid & 0xff;
+	st->data[3] = (pid >> 8) & 0x1f;
 
-	return dvb_usb_generic_write(adap->dev, b_pid, 4);
+	ret = dvb_usb_generic_write(adap->dev, st->data, 4);
+	mutex_unlock(&st->data_mutex);
+
+	return ret;
 }
 
 static int dtt200u_rc_query(struct dvb_usb_device *d)
 {
-	u8 key[5],cmd = GET_RC_CODE;
+	struct dtt200u_state *st = d->priv;
 	u32 scancode;
 
-	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
-	if (key[0] == 1) {
+	mutex_lock(&st->data_mutex);
+	st->data[0] = GET_RC_CODE;
+
+	dvb_usb_generic_rw(d, st->data, 1, st->data, 5, 0);
+	if (st->data[0] == 1) {
 		enum rc_type proto = RC_TYPE_NEC;
 
-		scancode = key[1];
-		if ((u8) ~key[1] != key[2]) {
+		scancode = st->data[1];
+		if ((u8) ~st->data[1] != st->data[2]) {
 			/* Extended NEC */
 			scancode = scancode << 8;
-			scancode |= key[2];
+			scancode |= st->data[2];
 			proto = RC_TYPE_NECX;
 		}
 		scancode = scancode << 8;
-		scancode |= key[3];
+		scancode |= st->data[3];
 
 		/* Check command checksum is ok */
-		if ((u8) ~key[3] == key[4])
+		if ((u8) ~st->data[3] == st->data[4])
 			rc_keydown(d->rc_dev, proto, scancode, 0);
 		else
 			rc_keyup(d->rc_dev);
-	} else if (key[0] == 2) {
+	} else if (st->data[0] == 2) {
 		rc_repeat(d->rc_dev);
 	} else {
 		rc_keyup(d->rc_dev);
 	}
 
-	if (key[0] != 0)
-		deb_info("key: %*ph\n", 5, key);
+	if (st->data[0] != 0)
+		deb_info("st->data: %*ph\n", 5, st->data);
 
+	mutex_unlock(&st->data_mutex);
 	return 0;
 }
 
@@ -106,17 +135,24 @@ static struct dvb_usb_device_properties wt220u_miglia_properties;
 static int dtt200u_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
+	struct dvb_usb_device *d;
+	struct dtt200u_state *st;
+
 	if (0 == dvb_usb_device_init(intf, &dtt200u_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &wt220u_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &wt220u_fc_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &wt220u_zl0353_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
+				     THIS_MODULE, &d, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &wt220u_miglia_properties,
-				     THIS_MODULE, NULL, adapter_nr))
+				     THIS_MODULE, &d, adapter_nr)) {
+		st = d->priv;
+		mutex_init(&st->data_mutex);
+
 		return 0;
+	}
 
 	return -ENODEV;
 }
@@ -140,6 +176,8 @@ static struct dvb_usb_device_properties dtt200u_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-dtt200u-01.fw",
 
+	.size_of_priv     = sizeof(struct dtt200u_state),
+
 	.num_adapters = 1,
 	.adapter = {
 		{
@@ -190,6 +228,8 @@ static struct dvb_usb_device_properties wt220u_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-wt220u-02.fw",
 
+	.size_of_priv     = sizeof(struct dtt200u_state),
+
 	.num_adapters = 1,
 	.adapter = {
 		{
@@ -240,6 +280,8 @@ static struct dvb_usb_device_properties wt220u_fc_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-wt220u-fc03.fw",
 
+	.size_of_priv     = sizeof(struct dtt200u_state),
+
 	.num_adapters = 1,
 	.adapter = {
 		{
@@ -290,6 +332,8 @@ static struct dvb_usb_device_properties wt220u_zl0353_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-wt220u-zl0353-01.fw",
 
+	.size_of_priv     = sizeof(struct dtt200u_state),
+
 	.num_adapters = 1,
 	.adapter = {
 		{
@@ -340,6 +384,8 @@ static struct dvb_usb_device_properties wt220u_miglia_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-wt220u-miglia-01.fw",
 
+	.size_of_priv     = sizeof(struct dtt200u_state),
+
 	.num_adapters = 1,
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-- 
2.7.4


