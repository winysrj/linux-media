Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49615 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751179AbdHFKBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 Aug 2017 06:01:08 -0400
Date: Sun, 6 Aug 2017 11:01:06 +0100
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Maciej Purski <m.purski@samsung.com>,
        dri-devel@lists.freedesktop.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent.pinchart@ideasonboard.com, b.zolnierkie@samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] drm/bridge/sii8620: add remote control support
Message-ID: <20170806100106.g7fc3wumfk5js56g@gofer.mess.org>
References: <CGME20170803074438eucas1p2539839818326721fdcf4d607ea8bc80e@eucas1p2.samsung.com>
 <1501746262-5193-1-git-send-email-m.purski@samsung.com>
 <86fabc47-a095-1580-f83b-eadd104c25ef@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fabc47-a095-1580-f83b-eadd104c25ef@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maciej,

On Thu, Aug 03, 2017 at 10:28:04AM +0200, Hans Verkuil wrote:
> Hi Maciej,
> 
> Unfortunately I do not have the MHL spec, but I was wondering what the
> relationship between RCP and CEC is. CEC has remote control support as
> well, so is RCP that subset of the CEC specification or is it completely
> separate?
> 
> I'm CC-ing Sean Young and the linux-media mailinglist as well since Sean
> maintains the rc subsystem. Which you probably should use, but I'm not the
> expert on that.

Yes, I agree. Using rc core the keymap can be changed from user space, and
is defined elsewhere. 

In include/media/rc-map.h you'll have to define a new protocol (unless the
protocol is CEC).

In drivers/media/rc/keymaps/ a new keymap should be defined.

Use devm_rc_allocate_device(RC_DRIVER_SCANCODE) to create the device; then
you'll need to at least set these members:

        input_phys = DRIVER_NAME "/input0";
        input_id.bustype = BUS_HOST;
        map_name = RC_MAP_RCP;
        allowed_protocols = RC_BIT_RCP;
        driver_name = DRIVER_NAME;
        device_name = DEVICE_NAME;

Then register with devm_rc_register_device(), and report keys with 
rc_keydown() and rc_keyup().

> On 08/03/17 09:44, Maciej Purski wrote:
> > MHL specification defines Remote Control Protocol(RCP) to
> > send input events between MHL devices.
> > The driver now recognizes RCP messages and reacts to them
> > by reporting key events to input subsystem, allowing
> > a user to control a device using TV remote control.
> > 
> > Signed-off-by: Maciej Purski <m.purski@samsung.com>
> > ---
> >  drivers/gpu/drm/bridge/sil-sii8620.c | 188 ++++++++++++++++++++++++++++++++++-
> >  include/drm/bridge/mhl.h             |   4 +
> >  2 files changed, 187 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/bridge/sil-sii8620.c b/drivers/gpu/drm/bridge/sil-sii8620.c
> > index 2d51a22..7e75f2f 100644
> > --- a/drivers/gpu/drm/bridge/sil-sii8620.c
> > +++ b/drivers/gpu/drm/bridge/sil-sii8620.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/gpio/consumer.h>
> >  #include <linux/i2c.h>
> > +#include <linux/input.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/irq.h>
> >  #include <linux/kernel.h>
> > @@ -58,6 +59,7 @@ enum sii8620_mt_state {
> >  struct sii8620 {
> >  	struct drm_bridge bridge;
> >  	struct device *dev;
> > +	struct input_dev *rcp_input_dev;
> >  	struct clk *clk_xtal;
> >  	struct gpio_desc *gpio_reset;
> >  	struct gpio_desc *gpio_int;
> > @@ -106,6 +108,82 @@ struct sii8620_mt_msg {
> >  	sii8620_cb continuation;
> >  };
> >  
> > +static struct {
> > +	u16 key;
> > +	u16 extra_key;
> > +	bool autorepeat;

Again let the input layer handle autorepeat, see REP_DELAY and REP_PERIOD.

> > +}  rcp_keymap[] = {
> > +	[0x00] = { KEY_SELECT },
> > +	[0x01] = { KEY_UP, 0, true },
> > +	[0x02] = { KEY_DOWN, 0, true },
> > +	[0x03] = { KEY_LEFT, 0, true },
> > +	[0x04] = { KEY_RIGHT, 0, true },
> > +
> > +	[0x05] = { KEY_RIGHT, KEY_UP, true },
> > +	[0x06] = { KEY_RIGHT, KEY_DOWN, true },
> > +	[0x07] = { KEY_LEFT,  KEY_UP, true },
> > +	[0x08] = { KEY_LEFT,  KEY_DOWN, true },

This should be replaced with KEY_RIGHT_UP, RC_RIGHT_DOWN, etc.

> > +
> > +	[0x09] = { KEY_MENU },
> > +	[0x0A] = { KEY_UNKNOWN },
> > +	[0x0B] = { KEY_UNKNOWN },
> > +	[0x0C] = { KEY_BOOKMARKS },
> > +	[0x0D] = { KEY_EXIT },
> > +
> > +	[0x20] = { KEY_NUMERIC_0 },
> > +	[0x21] = { KEY_NUMERIC_1 },
> > +	[0x22] = { KEY_NUMERIC_2 },
> > +	[0x23] = { KEY_NUMERIC_3 },
> > +	[0x24] = { KEY_NUMERIC_4 },
> > +	[0x25] = { KEY_NUMERIC_5 },
> > +	[0x26] = { KEY_NUMERIC_6 },
> > +	[0x27] = { KEY_NUMERIC_7 },
> > +	[0x28] = { KEY_NUMERIC_8 },
> > +	[0x29] = { KEY_NUMERIC_9 },
> > +
> > +	[0x2A] = { KEY_DOT },
> > +	[0x2B] = { KEY_ENTER },
> > +	[0x2C] = { KEY_CLEAR },
> > +
> > +	[0x30] = { KEY_CHANNELUP, 0, true },
> > +	[0x31] = { KEY_CHANNELDOWN, 0, true },
> > +
> > +	[0x33] = { KEY_SOUND },
> > +	[0x35] = { KEY_PROGRAM }, /* Show Information */
> > +
> > +	[0x37] = { KEY_PAGEUP, 0, true },
> > +	[0x38] = { KEY_PAGEDOWN, 0, true },
> > +
> > +	[0x41] = { KEY_VOLUMEUP, 0, true },
> > +	[0x42] = { KEY_VOLUMEDOWN, 0, true },
> > +	[0x43] = { KEY_MUTE },
> > +	[0x44] = { KEY_PLAY },
> > +	[0x45] = { KEY_STOP },
> > +	[0x46] = { KEY_PLAYPAUSE }, /* Pause */
> > +	[0x47] = { KEY_RECORD },
> > +	[0x48] = { KEY_REWIND, 0, true },
> > +	[0x49] = { KEY_FASTFORWARD, 0, true },
> > +	[0x4A] = { KEY_EJECTCD },
> > +	[0x4B] = { KEY_NEXTSONG, 0, true }, /* Forward */
> > +	[0x4C] = { KEY_PREVIOUSSONG, 0, true }, /* Backward */
> > +
> > +	[0x60] = { KEY_PLAYPAUSE }, /* Play */
> > +	[0x61] = { KEY_PLAYPAUSE }, /* Pause the Play */
> > +	[0x62] = { KEY_RECORD },
> > +	[0x63] = { KEY_PAUSE },
> > +	[0x64] = { KEY_STOP },
> > +	[0x65] = { KEY_MUTE },
> > +	[0x66] = { KEY_MUTE }, /* Restore Mute */
> > +
> > +	[0x71] = { KEY_F1 },
> > +	[0x72] = { KEY_F2 },
> > +	[0x73] = { KEY_F3 },
> > +	[0x74] = { KEY_F4 },
> > +	[0x75] = { KEY_F5 },
> > +
> > +	[0x7E] = { KEY_VENDOR },
> > +};
> > +
> >  static const u8 sii8620_i2c_page[] = {
> >  	0x39, /* Main System */
> >  	0x3d, /* TDM and HSIC */
> > @@ -431,6 +509,16 @@ static void sii8620_mt_rap(struct sii8620 *ctx, u8 code)
> >  	sii8620_mt_msc_msg(ctx, MHL_MSC_MSG_RAP, code);
> >  }
> >  
> > +static void sii8620_mt_rcpk(struct sii8620 *ctx, u8 code)
> > +{
> > +	sii8620_mt_msc_msg(ctx, MHL_MSC_MSG_RCPK, code);
> > +}
> > +
> > +static void sii8620_mt_rcpe(struct sii8620 *ctx, u8 code)
> > +{
> > +	sii8620_mt_msc_msg(ctx, MHL_MSC_MSG_RCPE, code);
> > +}
> > +
> >  static void sii8620_mt_read_devcap_send(struct sii8620 *ctx,
> >  					struct sii8620_mt_msg *msg)
> >  {
> > @@ -1753,6 +1841,43 @@ static void sii8620_send_features(struct sii8620 *ctx)
> >  	sii8620_write_buf(ctx, REG_MDT_XMIT_WRITE_PORT, buf, ARRAY_SIZE(buf));
> >  }
> >  
> > +static void sii8620_rcp_report_key(struct sii8620 *ctx, u8 keycode, bool pressed)
> > +{
> > +	input_report_key(ctx->rcp_input_dev,
> > +			rcp_keymap[keycode].key, pressed);
> > +
> > +	if (rcp_keymap[keycode].extra_key)
> > +		input_report_key(ctx->rcp_input_dev,
> > +				rcp_keymap[keycode].extra_key, pressed);
> > +}
> > +
> > +static bool sii8620_rcp_consume(struct sii8620 *ctx, u8 keycode)
> > +{
> > +	bool pressed = !(keycode & MHL_RCP_KEY_RELEASED_MASK);
> > +
> > +	if (!ctx->rcp_input_dev) {
> > +		dev_dbg(ctx->dev, "RCP input device not initialized\n");
> > +		return false;
> > +	}
> > +
> > +	keycode &= MHL_RCP_KEY_ID_MASK;
> > +	if (keycode >= ARRAY_SIZE(rcp_keymap) || !rcp_keymap[keycode].key) {
> > +		dev_dbg(ctx->dev, "Unsupported RCP key code: %d\n", keycode);
> > +		return false;
> > +	}
> > +
> > +	if (rcp_keymap[keycode].autorepeat && pressed) {
> > +		sii8620_rcp_report_key(ctx, keycode, true);
> > +		sii8620_rcp_report_key(ctx, keycode, false);
> > +	} else if (!rcp_keymap[keycode].autorepeat) {
> > +		sii8620_rcp_report_key(ctx, keycode, pressed);
> > +	}
> > +
> > +	input_sync(ctx->rcp_input_dev);
> > +
> > +	return true;
> > +}
> > +
> >  static void sii8620_msc_mr_set_int(struct sii8620 *ctx)
> >  {
> >  	u8 ints[MHL_INT_SIZE];
> > @@ -1804,19 +1929,25 @@ static void sii8620_msc_mt_done(struct sii8620 *ctx)
> >  
> >  static void sii8620_msc_mr_msc_msg(struct sii8620 *ctx)
> >  {
> > -	struct sii8620_mt_msg *msg = sii8620_msc_msg_first(ctx);
> > +	struct sii8620_mt_msg *msg;
> >  	u8 buf[2];
> >  
> > -	if (!msg)
> > -		return;
> > -
> >  	sii8620_read_buf(ctx, REG_MSC_MR_MSC_MSG_RCVD_1ST_DATA, buf, 2);
> >  
> >  	switch (buf[0]) {
> >  	case MHL_MSC_MSG_RAPK:
> > +		msg = sii8620_msc_msg_first(ctx);
> > +		if (!msg)
> > +			return;
> >  		msg->ret = buf[1];
> >  		ctx->mt_state = MT_STATE_DONE;
> >  		break;
> > +	case MHL_MSC_MSG_RCP:
> > +		if (!sii8620_rcp_consume(ctx, buf[1]))
> > +			sii8620_mt_rcpe(ctx,
> > +					MHL_RCPE_STATUS_INEFFECTIVE_KEY_CODE);
> > +		sii8620_mt_rcpk(ctx, buf[1]);
> > +		break;
> >  	default:
> >  		dev_err(ctx->dev, "%s message type %d,%d not supported",
> >  			__func__, buf[0], buf[1]);
> > @@ -2102,6 +2233,51 @@ static void sii8620_cable_in(struct sii8620 *ctx)
> >  	enable_irq(to_i2c_client(ctx->dev)->irq);
> >  }
> >  
> > +static void sii8620_init_rcp_input_dev(struct sii8620 *ctx)
> > +{
> > +	struct input_dev *i_dev = input_allocate_device();
> > +	int ret, i;
> > +	u16 keycode;
> > +
> > +	if (!i_dev) {
> > +		dev_err(ctx->dev, "Failed to allocate RCP input device\n");
> > +		ctx->error = -ENOMEM;
> > +	}
> > +
> > +	set_bit(EV_KEY, i_dev->evbit);
> > +	i_dev->name = "MHL Remote Control";
> > +	i_dev->keycode = rcp_keymap;
> > +	i_dev->keycodesize = sizeof(u16);
> > +	i_dev->keycodemax = ARRAY_SIZE(rcp_keymap);
> > +
> > +	for (i = 0; i < ARRAY_SIZE(rcp_keymap); i++) {
> > +		keycode = rcp_keymap[i].key;
> > +		if (keycode)
> > +			__set_bit(keycode, i_dev->keybit);
> > +	}
> > +
> > +	i_dev->id.bustype = BUS_VIRTUAL;
> > +	ret = input_register_device(i_dev);
> > +
> > +	if (ret) {
> > +		dev_err(ctx->dev, "Failed to register rcp input device\n");
> > +		input_free_device(i_dev);
> > +		ctx->error = ret;
> > +	}
> > +
> > +	ctx->rcp_input_dev = i_dev;
> > +}
> > +
> > +static void sii8620_remove_rcp_input_dev(struct sii8620 *ctx)
> > +{
> > +	if (!ctx->rcp_input_dev)
> > +		return;
> > +
> > +	input_unregister_device(ctx->rcp_input_dev);
> > +	input_free_device(ctx->rcp_input_dev);
> > +	ctx->rcp_input_dev = NULL;
> > +}
> > +
> >  static inline struct sii8620 *bridge_to_sii8620(struct drm_bridge *bridge)
> >  {
> >  	return container_of(bridge, struct sii8620, bridge);
> > @@ -2207,6 +2383,7 @@ static int sii8620_probe(struct i2c_client *client,
> >  	ctx->bridge.of_node = dev->of_node;
> >  	drm_bridge_add(&ctx->bridge);
> >  
> > +	sii8620_init_rcp_input_dev(ctx);
> >  	sii8620_cable_in(ctx);
> >  
> >  	return 0;
> > @@ -2217,8 +2394,9 @@ static int sii8620_remove(struct i2c_client *client)
> >  	struct sii8620 *ctx = i2c_get_clientdata(client);
> >  
> >  	disable_irq(to_i2c_client(ctx->dev)->irq);
> > -	drm_bridge_remove(&ctx->bridge);
> >  	sii8620_hw_off(ctx);
> > +	sii8620_remove_rcp_input_dev(ctx);
> > +	drm_bridge_remove(&ctx->bridge);
> >  
> >  	return 0;
> >  }
> > diff --git a/include/drm/bridge/mhl.h b/include/drm/bridge/mhl.h
> > index fbdfc8d..96a5e0f 100644
> > --- a/include/drm/bridge/mhl.h
> > +++ b/include/drm/bridge/mhl.h
> > @@ -262,6 +262,10 @@ enum {
> >  #define MHL_RAPK_UNSUPPORTED	0x02	/* Rcvd RAP action code not supported */
> >  #define MHL_RAPK_BUSY		0x03	/* Responder too busy to respond */
> >  
> > +/* Bit masks for RCP messages */
> > +#define MHL_RCP_KEY_RELEASED_MASK	0x80
> > +#define MHL_RCP_KEY_ID_MASK		0x7F
> > +
> >  /*
> >   * Error status codes for RCPE messages
> >   */
> > 
