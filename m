Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab0GFBpk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 21:45:40 -0400
Message-ID: <4C328AC5.1000307@redhat.com>
Date: Mon, 05 Jul 2010 22:45:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: walingdijkstra@hotmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT CT-3650 IR and CI support
References: <BLU0-SMTP16F4D7CDAFB30FE6B13188CDC40@phx.gbl>
In-Reply-To: <BLU0-SMTP16F4D7CDAFB30FE6B13188CDC40@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-06-2010 19:48, Waling Dijkstra escreveu:
> Hi linux-media,
> 
> adding support for IR and CI on the TT CT-3650.

It is better to break IR and CI into different patches. Make easier for people to review.

> CI code was mainly copied from pctv452e (PCTV 452e DVB driver).
> IR support is same as on TT-S1500 (and 452e).
> 
> Signed-off-by: Waling Dijkstra <walingdijkstra@hotmail.com>
> 
> rgrds,
> 
> 
> Waling
> 
> diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
> index a6de489..5ce6a51 100644
> --- a/drivers/media/dvb/dvb-usb/ttusb2.c
> +++ b/drivers/media/dvb/dvb-usb/ttusb2.c
> @@ -32,6 +32,8 @@
>  #include "tda1002x.h"
>  #include "tda827x.h"
>  #include "lnbp21.h"
> +/* CA */
> +#include "dvb_ca_en50221.h"

You should likely patch also the Kconfig to auto-select en50221.

>  
>  /* debug */
>  static int dvb_usb_ttusb2_debug;
> @@ -41,7 +43,26 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able))." DVB_USB_DEBUG_
>  
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
> +#define ci_dbg(format, arg...)                \
> +do {                                          \
> +	if (0)                                    \

	Huh?

> +		printk (KERN_DEBUG DVB_USB_LOG_PREFIX \
> +			": " format "\n" , ## arg);       \
> +} while (0)
> +
> +enum {
> +	TT3650_CMD_CI_TEST = 0x40,
> +	TT3650_CMD_CI_RD_CTRL,
> +	TT3650_CMD_CI_WR_CTRL,
> +	TT3650_CMD_CI_RD_ATTR,
> +	TT3650_CMD_CI_WR_ATTR,
> +	TT3650_CMD_CI_RESET,
> +	TT3650_CMD_CI_SET_VIDEO_PORT
> +};
> +
>  struct ttusb2_state {
> +	struct dvb_ca_en50221 ca;
> +	struct mutex ca_mutex;
>  	u8 id;
>  };
>  
> @@ -128,6 +149,333 @@ static struct i2c_algorithm ttusb2_i2c_algo = {
>  	.functionality = ttusb2_i2c_func,
>  };
>  
> +/* IR */
> +/* Remote Control Stuff for CT-3650 (copied from TT-S1500): */
> +static struct dvb_usb_rc_key tt_connect_CT_3650_rc_key[] = {
> +	{0x1501, KEY_POWER},
> +	{0x1502, KEY_SHUFFLE}, /* ? double-arrow key */
> +	{0x1503, KEY_1},
> +	{0x1504, KEY_2},
> +	{0x1505, KEY_3},
> +	{0x1506, KEY_4},
> +	{0x1507, KEY_5},
> +	{0x1508, KEY_6},
> +	{0x1509, KEY_7},
> +	{0x150a, KEY_8},
> +	{0x150b, KEY_9},
> +	{0x150c, KEY_0},
> +	{0x150d, KEY_UP},
> +	{0x150e, KEY_LEFT},
> +	{0x150f, KEY_OK},
> +	{0x1510, KEY_RIGHT},
> +	{0x1511, KEY_DOWN},
> +	{0x1512, KEY_INFO},
> +	{0x1513, KEY_EXIT},
> +	{0x1514, KEY_RED},
> +	{0x1515, KEY_GREEN},
> +	{0x1516, KEY_YELLOW},
> +	{0x1517, KEY_BLUE},
> +	{0x1518, KEY_MUTE},
> +	{0x1519, KEY_TEXT},
> +	{0x151a, KEY_MODE},  /* ? TV/Radio */
> +	{0x1521, KEY_OPTION},
> +	{0x1522, KEY_EPG},
> +	{0x1523, KEY_CHANNELUP},
> +	{0x1524, KEY_CHANNELDOWN},
> +	{0x1525, KEY_VOLUMEUP},
> +	{0x1526, KEY_VOLUMEDOWN},
> +	{0x1527, KEY_SETUP},
> +	{0x153a, KEY_RECORD},/* these keys are only in the black remote */
> +	{0x153b, KEY_PLAY},
> +	{0x153c, KEY_STOP},
> +	{0x153d, KEY_REWIND},
> +	{0x153e, KEY_PAUSE},
> +	{0x153f, KEY_FORWARD}
> +};
> +
> +static int tt3650_rc_query(struct dvb_usb_device *d, u32 *keyevent, int *keystate)
> +{
> +	u8 keybuf[5];
> +	int ret;
> +	u8 b[36];/* this was (CMD_BUFFER_SIZE) u8 b[0x28] - dvb_usb_generic_rw adds another 4 */
> +	u8 rx[60];/* same (64 -4) */
> +	ret = ttusb2_msg(d, CMD_GET_IR_CODE, b, 0, rx, 9);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (rx[8] & 0x01) {
> +		/* got a "press" event */
> +/*		if (debug > 2) {
> +			printk("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
> +		}
> +*/

If the code is dead, just remove it. Otherwise, keep, but removing the {}

> +		keybuf[0] = 0x01;/* DVB_USB_RC_NEC_KEY_PRESSED; why is this #define'd privately? */
> +		keybuf[1] = rx[3];
> +		keybuf[2] = ~keybuf[1]; /* fake checksum */
> +		keybuf[3] = rx[2];
> +		keybuf[4] = ~keybuf[3]; /* fake checksum */
> +		dvb_usb_nec_rc_key_to_event(d, keybuf, keyevent, keystate);
> +	}
> +	return 0;
> +}
> +
> +/* ci */
> +static int tt3650_ci_msg (struct dvb_usb_device *d, u8 cmd, u8 *data,
> +							unsigned int write_len, unsigned int read_len)
> +{
> +    int ret;
> +    u8 rx[60];/* (64 -4) */
> +    ret = ttusb2_msg(d, cmd, data, write_len, rx, read_len);
> +    if (ret == 0)

Use just:
	if (!ret)

(there are other similar issues like this. I won't comment it on everyplace ;) )

> +		memcpy (data, rx, read_len);
> +    return ret;
> +}
> +
> +static int tt3650_ci_msg_locked(struct dvb_ca_en50221 *ca,
> +								u8 cmd, u8 *data, unsigned int write_len, unsigned int read_len)
> +{
> +	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
> +	struct ttusb2_state *state = (struct ttusb2_state *)d->priv;

Don't use typecasts when it is not needed.

> +	int ret;
> +
> +	mutex_lock(&state->ca_mutex);
> +	ret = tt3650_ci_msg(d, cmd, data, write_len, read_len);
> +	mutex_unlock(&state->ca_mutex);
> +
> +	return ret;
> +}
> +
> +static int tt3650_ci_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)
> +{
> +	u8 buf[3];
> +	int ret;
> +
> +	if (0 != slot)

if (slot)

> +		return -EINVAL;
> +
> +	buf[0] = (address >> 8) & 0x0F;
> +	buf[1] = address;
> +
> +	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_ATTR, buf, 2, 3);
> +
> +	ci_dbg ("%s %04x -> %d 0x%02x",
> +		__func__, address, ret, buf[2]);

Just put everything into a single line, if the size is lower than 80 cols.
Btw, it makes sense to put __func__ at the debug definition, instead of
needing to repeat it everywhere.

> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return buf[2];
> +}
> +
> +static int tt3650_ci_write_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address, u8 value)
> +{
> +	u8 buf[3];
> +
> +	ci_dbg("%s %d 0x%04x 0x%02x",
> +		__func__, slot, address, value);
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	buf[0] = (address >> 8) & 0x0F;
> +	buf[1] = address;
> +	buf[2] = value;
> +
> +	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_ATTR, buf, 3, 3);
> +}
> +
> +static int tt3650_ci_read_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 address)
> +{
> +	u8 buf[2];
> +	int ret;
> +
> +	if (0 != slot)

if (slot)

> +		return -EINVAL;
> +
> +	buf[0] = address & 3;
> +
> +	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_RD_CTRL, buf, 1, 2);
> +
> +	ci_dbg("%s 0x%02x -> %d 0x%02x",
> +		__func__, address, ret, buf[1]);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return buf[1];
> +}
> +
> +static int tt3650_ci_write_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 address, u8 value)
> +{
> +	u8 buf[2];
> +
> +	ci_dbg("%s %d 0x%02x 0x%02x",
> +		__func__, slot, address, value);
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	buf[0] = address;
> +	buf[1] = value;
> +
> +	return tt3650_ci_msg_locked(ca, TT3650_CMD_CI_WR_CTRL, buf, 2, 2);
> +}
> +
> +static int tt3650_ci_set_video_port(struct dvb_ca_en50221 *ca, int slot, int enable)
> +{
> +	u8 buf[1];
> +	int ret;
> +
> +	ci_dbg("%s %d %d", __func__, slot, enable);
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	enable = !!enable;
> +	buf[0] = enable;

This is ugly. Instead, the better is to do something like:

	buf[0] = enable? 0xff : 0;

> +
> +	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (enable != buf[0]) {
> +		err("CI not %sabled.", enable ? "en" : "dis");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tt3650_ci_slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
> +{
> +	return tt3650_ci_set_video_port(ca, slot, /* enable */ 0);
> +}
> +
> +static int tt3650_ci_slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
> +{
> +	return tt3650_ci_set_video_port(ca, slot, /* enable */ 1);


Hmm... both 1 and 0 means enable? 

> +}
> +
> +static int tt3650_ci_slot_reset(struct dvb_ca_en50221 *ca, int slot)
> +{
> +	struct dvb_usb_device *d = (struct dvb_usb_device *)ca->data;
> +	struct ttusb2_state *state = (struct ttusb2_state *)d->priv;

No typecasts, please.

> +	u8 buf[1];
> +	int ret;
> +
> +	ci_dbg ("%s %d", __func__, slot);
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	buf[0] = 0;
> +
> +	mutex_lock (&state->ca_mutex);
> +
> +	ret = tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
> +	if (0 != ret)
> +		goto failed;
> +
> +	msleep (500);
> +
> +	buf[0] = 1;
> +
> +	ret = tt3650_ci_msg(d, TT3650_CMD_CI_RESET, buf, 1, 1);
> +	if (0 != ret)
> +		goto failed;
> +
> +	msleep (500);
> +
> +	buf[0] = 0; /* FTA */
> +
> +	ret = tt3650_ci_msg(d, TT3650_CMD_CI_SET_VIDEO_PORT, buf, 1, 1);
> +
> + failed:
> +	mutex_unlock (&state->ca_mutex);
> +
> +	return ret;
> +}
> +
> +static int tt3650_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
> +{
> +	u8 buf[1];
> +	int ret;
> +
> +	if (0 != slot)
> +		return -EINVAL;
> +
> +	ret = tt3650_ci_msg_locked(ca, TT3650_CMD_CI_TEST, buf, 0, 1);
> +	if (0 != ret)
> +		return ret;
> +
> +	if (1 == buf[0]) {
> +		return DVB_CA_EN50221_POLL_CAM_PRESENT |
> +			DVB_CA_EN50221_POLL_CAM_READY;
> +	} else {
> +		return 0;
> +	}

You shouldn't use {} when there's just one condition. Also, you don't need an else here.
It would be better to write the above as:

	if (1 == buf[0])
		return DVB_CA_EN50221_POLL_CAM_PRESENT |
			DVB_CA_EN50221_POLL_CAM_READY;
	return 0;


> +}
> +
> +static void tt3650_ci_uninit(struct dvb_usb_device *d)
> +{
> +	struct ttusb2_state *state;
> +
> +	ci_dbg("%s", __func__);
> +
> +	if (NULL == d)
> +		return;
> +
> +	state = (struct ttusb2_state *)d->priv;

no typecasts.

> +	if (NULL == state)
> +		return;
> +
> +	if (NULL == state->ca.data)
> +		return;
> +
> +	/* Error ignored. */
> +	tt3650_ci_set_video_port(&state->ca, /* slot */ 0, /* enable */ 0);
> +
> +	dvb_ca_en50221_release(&state->ca);
> +
> +	memset(&state->ca, 0, sizeof(state->ca));
> +}
> +
> +static int tt3650_ci_init(struct dvb_usb_adapter *a)
> +{
> +	struct dvb_usb_device *d = a->dev;
> +	struct ttusb2_state *state = (struct ttusb2_state *)d->priv;
> +	int ret;
> +
> +	ci_dbg ("%s", __func__);
> +
> +	mutex_init(&state->ca_mutex);
> +
> +	state->ca.owner = THIS_MODULE;
> +	state->ca.read_attribute_mem = tt3650_ci_read_attribute_mem;
> +	state->ca.write_attribute_mem = tt3650_ci_write_attribute_mem;
> +	state->ca.read_cam_control = tt3650_ci_read_cam_control;
> +	state->ca.write_cam_control = tt3650_ci_write_cam_control;
> +	state->ca.slot_reset = tt3650_ci_slot_reset;
> +	state->ca.slot_shutdown = tt3650_ci_slot_shutdown;
> +	state->ca.slot_ts_enable = tt3650_ci_slot_ts_enable;
> +	state->ca.poll_slot_status = tt3650_ci_poll_slot_status;
> +	state->ca.data = d;
> +
> +	ret = dvb_ca_en50221_init (&a->dvb_adap,
> +				   &state->ca,
> +				   /* flags */ 0,
> +				   /* n_slots */ 1);
> +	if (0 != ret) {
> +		err ("Cannot initialize CI: Error %d.", ret);
> +		memset (&state->ca, 0, sizeof (state->ca));
> +		return ret;
> +	}
> +
> +	info ("CI initialized.");
> +
> +	return 0;
> +}
> +
>  /* Callbacks for DVB USB */
>  static int ttusb2_identify_state (struct usb_device *udev, struct
>  		dvb_usb_device_properties *props, struct dvb_usb_device_description **desc,
> @@ -177,12 +525,19 @@ static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
>  
>  static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
>  {
> +	struct usb_device_id *id;
>  	if (usb_set_interface(adap->dev->udev, 0, 3) < 0)
>  		err("set interface to alts=3 failed");
>  	if ((adap->fe = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
>  		deb_info("TDA10023 attach failed\n");
>  		return -ENODEV;
>  	}
> +	id = adap->dev->desc->warm_ids[0];
> +	if (USB_VID_TECHNOTREND == id->idVendor
> +	    && USB_PID_TECHNOTREND_CONNECT_CT3650 == id->idProduct) {
> +		/* Error ignored. */
> +		tt3650_ci_init (adap);
> +	}
>  	return 0;
>  }
>  
> @@ -214,6 +569,14 @@ static struct dvb_usb_device_properties ttusb2_properties;
>  static struct dvb_usb_device_properties ttusb2_properties_s2400;
>  static struct dvb_usb_device_properties ttusb2_properties_ct3650;
>  
> +static void ttusb2_usb_disconnect (struct usb_interface *intf)
> +{
> +	struct dvb_usb_device *d = usb_get_intfdata (intf);
> +
> +	tt3650_ci_uninit (d);
> +	dvb_usb_device_exit (intf);
> +}
> +
>  static int ttusb2_probe(struct usb_interface *intf,
>  		const struct usb_device_id *id)
>  {
> @@ -345,6 +708,11 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
>  
>  	.size_of_priv = sizeof(struct ttusb2_state),
>  
> +	.rc_key_map = tt_connect_CT_3650_rc_key,
> +	.rc_key_map_size = ARRAY_SIZE(tt_connect_CT_3650_rc_key),
> +	.rc_query = tt3650_rc_query,
> +	.rc_interval = 500,
> +
>  	.num_adapters = 1,
>  	.adapter = {
>  		{
> @@ -387,7 +755,7 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
>  static struct usb_driver ttusb2_driver = {
>  	.name		= "dvb_usb_ttusb2",
>  	.probe		= ttusb2_probe,
> -	.disconnect = dvb_usb_device_exit,
> +	.disconnect = ttusb2_usb_disconnect,
>  	.id_table	= ttusb2_table,
>  };
>  
> diff --git a/drivers/media/dvb/dvb-usb/ttusb2.h b/drivers/media/dvb/dvb-usb/ttusb2.h
> index 52a63af..1bd5d54 100644
> --- a/drivers/media/dvb/dvb-usb/ttusb2.h
> +++ b/drivers/media/dvb/dvb-usb/ttusb2.h
> @@ -45,6 +45,9 @@
>  #define CMD_DISEQC          0x18
>  /* out data: <master=0xff/burst=??> <cmdlen> <cmdbytes>[cmdlen] */
>  
> +/* command to poll IR receiver (copied from pctv452e.c) */
> +#define CMD_GET_IR_CODE     0x1b
> +
>  #define CMD_PID_ENABLE      0x22
>  /* out data: <index> <type: ts=1/sec=2> <pid msb> <pid lsb> */
>  


There are also other CodingStyle issues, as pointed by scripts/checkpatch.pl:

WARNING: space prohibited between function name and open parenthesis '('
#49: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:49:
+		printk (KERN_DEBUG DVB_USB_LOG_PREFIX \

WARNING: line over 80 characters
#117: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:196:
+static int tt3650_rc_query(struct dvb_usb_device *d, u32 *keyevent, int *keystate)

WARNING: line over 80 characters
#121: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:200:
+	u8 b[36];/* this was (CMD_BUFFER_SIZE) u8 b[0x28] - dvb_usb_generic_rw adds another 4 */

WARNING: line over 80 characters
#130: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:209:
+			printk("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);

WARNING: line over 80 characters
#133: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:212:
+		keybuf[0] = 0x01;/* DVB_USB_RC_NEC_KEY_PRESSED; why is this #define'd privately? */

WARNING: space prohibited between function name and open parenthesis '('
#144: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:223:
+static int tt3650_ci_msg (struct dvb_usb_device *d, u8 cmd, u8 *data,

WARNING: line over 80 characters
#145: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:224:
+							unsigned int write_len, unsigned int read_len)

WARNING: space prohibited between function name and open parenthesis '('
#151: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:230:
+		memcpy (data, rx, read_len);

WARNING: line over 80 characters
#156: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:235:
+								u8 cmd, u8 *data, unsigned int write_len, unsigned int read_len)

WARNING: line over 80 characters
#169: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:248:
+static int tt3650_ci_read_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address)

WARNING: space prohibited between function name and open parenthesis '('
#182: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:261:
+	ci_dbg ("%s %04x -> %d 0x%02x",

WARNING: line over 80 characters
#191: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:270:
+static int tt3650_ci_write_attribute_mem(struct dvb_ca_en50221 *ca, int slot, int address, u8 value)

WARNING: line over 80 characters
#208: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:287:
+static int tt3650_ci_read_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 address)

WARNING: line over 80 characters
#229: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:308:
+static int tt3650_ci_write_cam_control(struct dvb_ca_en50221 *ca, int slot, u8 address, u8 value)

WARNING: line over 80 characters
#245: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:324:
+static int tt3650_ci_set_video_port(struct dvb_ca_en50221 *ca, int slot, int enable)

WARNING: space prohibited between function name and open parenthesis '('
#287: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:366:
+	ci_dbg ("%s %d", __func__, slot);

WARNING: space prohibited between function name and open parenthesis '('
#294: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:373:
+	mutex_lock (&state->ca_mutex);

WARNING: space prohibited between function name and open parenthesis '('
#300: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:379:
+	msleep (500);

WARNING: space prohibited between function name and open parenthesis '('
#308: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:387:
+	msleep (500);

WARNING: space prohibited between function name and open parenthesis '('
#315: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:394:
+	mutex_unlock (&state->ca_mutex);

WARNING: line over 80 characters
#320: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:399:
+static int tt3650_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)

WARNING: space prohibited between function name and open parenthesis '('
#370: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:449:
+	ci_dbg ("%s", __func__);

WARNING: space prohibited between function name and open parenthesis '('
#385: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:464:
+	ret = dvb_ca_en50221_init (&a->dvb_adap,

WARNING: space prohibited between function name and open parenthesis '('
#390: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:469:
+		err ("Cannot initialize CI: Error %d.", ret);

WARNING: space prohibited between function name and open parenthesis '('
#391: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:470:
+		memset (&state->ca, 0, sizeof (state->ca));

WARNING: space prohibited between function name and open parenthesis '('
#391: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:470:
+		memset (&state->ca, 0, sizeof (state->ca));

WARNING: space prohibited between function name and open parenthesis '('
#395: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:474:
+	info ("CI initialized.");

WARNING: space prohibited between function name and open parenthesis '('
#418: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:539:
+		tt3650_ci_init (adap);

WARNING: space prohibited between function name and open parenthesis '('
#427: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:572:
+static void ttusb2_usb_disconnect (struct usb_interface *intf)

WARNING: space prohibited between function name and open parenthesis '('
#429: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:574:
+	struct dvb_usb_device *d = usb_get_intfdata (intf);

WARNING: space prohibited between function name and open parenthesis '('
#431: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:576:
+	tt3650_ci_uninit (d);

WARNING: space prohibited between function name and open parenthesis '('
#432: FILE: drivers/media/dvb/dvb-usb/ttusb2.c:577:
+	dvb_usb_device_exit (intf);

total: 0 errors, 32 warnings, 428 lines checked

