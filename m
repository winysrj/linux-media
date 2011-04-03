Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:54618 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1DCRYg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2011 13:24:36 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, patrick.boettcher@dibcom.fr,
	Florian Mickler <florian@mickler.org>
Subject: [PATCH 1/2] [media] dib0700: get rid of on-stack dma buffers
Date: Sun,  3 Apr 2011 19:23:42 +0200
Message-Id: <1301851423-21969-2-git-send-email-florian@mickler.org>
In-Reply-To: <1301851423-21969-1-git-send-email-florian@mickler.org>
References: <1301851423-21969-1-git-send-email-florian@mickler.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Note: This change is tested to compile only, as I don't have the hardware.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Signed-off-by: Florian Mickler <florian@mickler.org>

---
[v2: use preallocated buffer; fix sizeof in one case]
[v3: use seperate kmalloc mapping for the preallocation,
     dont ignore errors in probe codepaths  ]
[v4: minor style nit: functions opening brace goes onto it's own line ]
[v5: use preallocated buffer whereever we have a dvb_usb_device
available even if it means acquiring i2c_mutex where we did previously
not + found some more on-stack buffers that escaped my first
review somehow...]

drivers/media/dvb/dvb-usb/dib0700.h         |    5 +-
 drivers/media/dvb/dvb-usb/dib0700_core.c    |  142 +++++++++++++++++++++-----
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    9 ++-
 3 files changed, 125 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700.h b/drivers/media/dvb/dvb-usb/dib0700.h
index b2a87f2..368fbcf 100644
--- a/drivers/media/dvb/dvb-usb/dib0700.h
+++ b/drivers/media/dvb/dvb-usb/dib0700.h
@@ -46,8 +46,9 @@ struct dib0700_state {
 	u8 is_dib7000pc;
 	u8 fw_use_new_i2c_api;
 	u8 disable_streaming_master_mode;
-    u32 fw_version;
-    u32 nb_packet_buffer_size;
+	u32 fw_version;
+	u32 nb_packet_buffer_size;
+	u8 *buf; /* protected by dvb_usb_devices i2c_mutex */
 };
 
 extern int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index b79af68..ca80520 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -27,11 +27,16 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
 			u32 *romversion, u32 *ramversion, u32 *fwtype)
 {
-	u8 b[16];
-	int ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
+	struct dib0700_state *st = d->priv;
+	int ret;
+	u8 *b = st->buf;
+
+	mutex_lock(&d->i2c_mutex);
+
+	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-				  b, sizeof(b), USB_CTRL_GET_TIMEOUT);
+				  b, 16, USB_CTRL_GET_TIMEOUT);
 	if (hwversion != NULL)
 		*hwversion  = (b[0] << 24)  | (b[1] << 16)  | (b[2] << 8)  | b[3];
 	if (romversion != NULL)
@@ -40,6 +45,9 @@ int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
 		*ramversion = (b[8] << 24)  | (b[9] << 16)  | (b[10] << 8) | b[11];
 	if (fwtype != NULL)
 		*fwtype     = (b[12] << 24) | (b[13] << 16) | (b[14] << 8) | b[15];
+
+	mutex_unlock(&d->i2c_mutex);
+
 	return ret;
 }
 
@@ -101,16 +109,30 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
 
 int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
 {
-	u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
-	return dib0700_ctrl_wr(d, buf, sizeof(buf));
+	s16 ret;
+	struct dib0700_state *st = d->priv;
+	u8 *buf = st->buf;
+
+	mutex_lock(&d->i2c_mutex);
+
+	buf[0] = REQUEST_SET_GPIO;
+	buf[1] = gpio;
+	buf[2] = ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6);
+	ret = dib0700_ctrl_wr(d, buf, 3);
+
+	mutex_unlock(&d->i2c_mutex);
+
+	return ret;
 }
 
 static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
 {
 	struct dib0700_state *st = d->priv;
-	u8 b[3];
+	u8 *b = st->buf;
 	int ret;
 
+	mutex_lock(&d->i2c_mutex);
+
 	if (st->fw_version >= 0x10201) {
 		b[0] = REQUEST_SET_USB_XFER_LEN;
 		b[1] = (nb_ts_packets >> 8) & 0xff;
@@ -118,12 +140,14 @@ static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
 
 		deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
 
-		ret = dib0700_ctrl_wr(d, b, sizeof(b));
+		ret = dib0700_ctrl_wr(d, b, 3);
 	} else {
 		deb_info("this firmware does not allow to change the USB xfer len\n");
 		ret = -EIO;
 	}
 
+	mutex_unlock(&d->i2c_mutex);
+
 	return ret;
 }
 
@@ -137,11 +161,12 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 	   properly support i2c read calls not preceded by a write */
 
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct dib0700_state *st = d->priv;
 	uint8_t bus_mode = 1;  /* 0=eeprom bus, 1=frontend bus */
 	uint8_t gen_mode = 0; /* 0=master i2c, 1=gpio i2c */
 	uint8_t en_start = 0;
 	uint8_t en_stop = 0;
-	uint8_t buf[255]; /* TBV: malloc ? */
+	uint8_t *buf = st->buf;
 	int result, i;
 
 	/* Ensure nobody else hits the i2c bus while we're sending our
@@ -221,6 +246,7 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 		}
 	}
 	mutex_unlock(&d->i2c_mutex);
+
 	return i;
 }
 
@@ -231,8 +257,9 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 				   struct i2c_msg *msg, int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct dib0700_state *st = d->priv;
 	int i,len;
-	u8 buf[255];
+	u8 *buf = st->buf;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
@@ -264,8 +291,8 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 				break;
 		}
 	}
-
 	mutex_unlock(&d->i2c_mutex);
+
 	return i;
 }
 
@@ -297,15 +324,23 @@ struct i2c_algorithm dib0700_i2c_algo = {
 int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold)
 {
-	u8 b[16];
-	s16 ret = usb_control_msg(udev, usb_rcvctrlpipe(udev,0),
+	s16 ret;
+	u8 *b;
+
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return	-ENOMEM;
+
+
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 		REQUEST_GET_VERSION, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0, b, 16, USB_CTRL_GET_TIMEOUT);
 
 	deb_info("FW GET_VERSION length: %d\n",ret);
 
 	*cold = ret <= 0;
-
 	deb_info("cold: %d\n", *cold);
+
+	kfree(b);
 	return 0;
 }
 
@@ -313,7 +348,14 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
 	u8 pll_src, u8 pll_range, u8 clock_gpio3, u16 pll_prediv,
 	u16 pll_loopdiv, u16 free_div, u16 dsuScaler)
 {
-	u8 b[10];
+	struct dib0700_state *st = d->priv;
+	s16 ret;
+	u8 *b;
+
+	b = st->buf;
+
+	mutex_lock(&d->i2c_mutex);
+
 	b[0] = REQUEST_SET_CLOCK;
 	b[1] = (en_pll << 7) | (pll_src << 6) | (pll_range << 5) | (clock_gpio3 << 4);
 	b[2] = (pll_prediv >> 8)  & 0xff; // MSB
@@ -325,7 +367,11 @@ static int dib0700_set_clock(struct dvb_usb_device *d, u8 en_pll,
 	b[8] = (dsuScaler >> 8)   & 0xff; // MSB
 	b[9] =  dsuScaler         & 0xff; // LSB
 
-	return dib0700_ctrl_wr(d, b, 10);
+	ret = dib0700_ctrl_wr(d, b, 10);
+
+	mutex_unlock(&d->i2c_mutex);
+
+	return ret;
 }
 
 int dib0700_set_i2c_speed(struct dvb_usb_device *d, u16 scl_kHz)
@@ -386,11 +432,14 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 {
 	struct hexline hx;
 	int pos = 0, ret, act_len, i, adap_num;
-	u8 b[16];
+	u8 *b;
 	u32 fw_version;
-
 	u8 buf[260];
 
+	b = kmalloc(16, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	while ((ret = dvb_usb_get_hexline(fw, &hx, &pos)) > 0) {
 		deb_fwdata("writing to address 0x%08x (buffer: 0x%02x %02x)\n",
 				hx.addr, hx.len, hx.chk);
@@ -411,7 +460,7 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 
 		if (ret < 0) {
 			err("firmware download failed at %d with %d",pos,ret);
-			return ret;
+			goto out;
 		}
 	}
 
@@ -432,7 +481,7 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 	usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-				  b, sizeof(b), USB_CTRL_GET_TIMEOUT);
+				  b, 16, USB_CTRL_GET_TIMEOUT);
 	fw_version = (b[8] << 24) | (b[9] << 16) | (b[10] << 8) | b[11];
 
 	/* set the buffer size - DVB-USB is allocating URB buffers
@@ -451,14 +500,15 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 			}
 		}
 	}
-
+out:
+	kfree(b);
 	return ret;
 }
 
 int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dib0700_state *st = adap->dev->priv;
-	u8 b[4];
+	u8 *b = st->buf;
 	int ret;
 
 	if ((onoff != 0) && (st->fw_version >= 0x10201)) {
@@ -468,10 +518,12 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 			st->nb_packet_buffer_size);
 		if (ret < 0) {
 			deb_info("can not set the USB xfer len\n");
-			return ret;
+			goto out;
 		}
 	}
 
+	mutex_lock(&adap->dev->i2c_mutex);
+
 	b[0] = REQUEST_ENABLE_VIDEO;
 	b[1] = (onoff << 4) | 0x00; /* this bit gives a kind of command, rather than enabling something or not */
 
@@ -503,16 +555,21 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	deb_info("data for streaming: %x %x\n", b[1], b[2]);
 
-	return dib0700_ctrl_wr(adap->dev, b, 4);
+	ret = dib0700_ctrl_wr(adap->dev, b, 4);
+
+	mutex_unlock(&adap->dev->i2c_mutex);
+out:
+	return ret;
 }
 
 int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
 {
 	struct dvb_usb_device *d = rc->priv;
 	struct dib0700_state *st = d->priv;
-	u8 rc_setup[3] = { REQUEST_SET_RC, 0, 0 };
+	u8 *rc_setup = st->buf;
 	int new_proto, ret;
 
+
 	/* Set the IR mode */
 	if (rc_type == RC_TYPE_RC5)
 		new_proto = 1;
@@ -526,9 +583,16 @@ int dib0700_change_protocol(struct rc_dev *rc, u64 rc_type)
 	} else
 		return -EINVAL;
 
+	mutex_lock(&d->i2c_mutex);
+
+	rc_setup[0] = REQUEST_SET_RC;
 	rc_setup[1] = new_proto;
+	rc_setup[2] = 0;
+
+	ret = dib0700_ctrl_wr(d, rc_setup, 3);
+
+	mutex_unlock(&d->i2c_mutex);
 
-	ret = dib0700_ctrl_wr(d, rc_setup, sizeof(rc_setup));
 	if (ret < 0) {
 		err("ir protocol setup failed");
 		return ret;
@@ -685,6 +749,7 @@ static int dib0700_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	int i;
+	int ret;
 	struct dvb_usb_device *dev;
 
 	for (i = 0; i < dib0700_device_count; i++)
@@ -693,8 +758,10 @@ static int dib0700_probe(struct usb_interface *intf,
 			struct dib0700_state *st = dev->priv;
 			u32 hwversion, romversion, fw_version, fwtype;
 
-			dib0700_get_version(dev, &hwversion, &romversion,
+			ret = dib0700_get_version(dev, &hwversion, &romversion,
 				&fw_version, &fwtype);
+			if (ret < 0)
+				goto out;
 
 			deb_info("Firmware version: %x, %d, 0x%x, %d\n",
 				hwversion, romversion, fw_version, fwtype);
@@ -708,18 +775,37 @@ static int dib0700_probe(struct usb_interface *intf,
 			else
 				dev->props.rc.core.bulk_mode = false;
 
-			dib0700_rc_setup(dev);
+			ret = dib0700_rc_setup(dev);
+			if (ret)
+				goto out;
+
+			st->buf = kmalloc(255, GFP_KERNEL);
+			if (!st->buf) {
+				ret = -ENOMEM;
+				goto out;
+			}
 
 			return 0;
+out:
+			dvb_usb_device_exit(intf);
+			return ret;
 		}
 
 	return -ENODEV;
 }
 
+static void dib0700_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	struct dib0700_state *st = d->priv;
+	kfree(st->buf);
+	dvb_usb_device_exit(intf);
+}
+
 static struct usb_driver dib0700_driver = {
 	.name       = "dvb_usb_dib0700",
 	.probe      = dib0700_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect = dib0700_disconnect,
 	.id_table   = dib0700_usb_id_table,
 };
 
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 97af266..e9891af 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -487,6 +487,7 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 	u8 toggle;
 	int i;
 	struct dib0700_state *st = d->priv;
+	u8 *buf = st->buf;
 
 	if (st->fw_version >= 0x10200) {
 		/* For 1.20 firmware , We need to keep the RC polling
@@ -496,7 +497,13 @@ static int dib0700_rc_query_old_firmware(struct dvb_usb_device *d)
 		return 0;
 	}
 
-	i = dib0700_ctrl_rd(d, rc_request, 2, key, 4);
+	mutex_lock(&d->i2c_mutex);
+
+	i = dib0700_ctrl_rd(d, rc_request, 2, buf, 4);
+	memcpy(key, buf, 4);
+
+	mutex_unlock(&d->i2c_mutex);
+
 	if (i <= 0) {
 		err("RC Query Failed");
 		return -1;
-- 
1.7.4.1

