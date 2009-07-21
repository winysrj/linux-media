Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36104 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZGUAY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 20:24:58 -0400
Subject: Re: [PATCH 2/3] 2/3: cx18: Add i2c initialization for
 Z8F0811/Hauppage  IR transceivers
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mark Lord <lkml@rtr.ca>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
In-Reply-To: <20090719153854.55fb9df7@hyperion.delvare>
References: <1247862585.10066.16.camel@palomino.walls.org>
	 <1247863615.10066.33.camel@palomino.walls.org>
	 <20090719153854.55fb9df7@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 20:26:20 -0400
Message-Id: <1248135980.3148.95.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-07-19 at 15:38 +0200, Jean Delvare wrote:
> Hi Andy,

Jean,

Thanks for tking the time to answer my questions and review.  My
responses are inline.

> On Fri, 17 Jul 2009 16:46:55 -0400, Andy Walls wrote:
> > This patch add support to the cx18 driver for setting up the
> > Z8F0811/Hauppauge IR Tx/Rx chip with the i2c binding model in newer
> > kernels.
> > 
> > My concerns/questions:
> > 
> > 1. When using the new i2c binding model, I'm not saving the returned
> > pointer from i2c_new_probed_device() and am hence taking no action on
> > trying to clean up IR i2c devices on module unload.  Will the i2c
> > subsystem clean up this automatically when the adapter is unregistered
> > on module unload?
> 
> While this isn't currently documented, yes it will. If this ever
> changes, I will first let i2c-core emit warnings and still clean up
> orphan clients. But I suspect the current behavior is easier for
> everyone and I couldn't see any reason to change it at this point.

OK.  Sounds good. :)

> > 2. When using the new i2c binding model, I'm calling
> > i2c_new_probed_device() twice: once for Rx (addr 0x71 of the Z8F0811)
> > and another time for Tx (addr 0x70 of the Z8F0811).  Is it a problem to
> > have two Linux i2c devices for two distinct addresses of the same
> > underlying hardware device?
> 
> No, this is not a problem. The fact that this is the same device behind
> both addresses is an implementation detail. As long as both functions
> are independent, it should work just fine.

OK. :)


> > 3. When using the new i2c binding model, I opted not to use ir_video for
> > the Z8F0811 loaded with microcode from Zilog/Hauppauge.  Since I needed
> > one name for Rx binding and one for Tx binding, I used these names:
> > 
> >  	"ir_tx_z8f0811_haup"
> > 	"ir_rx_z8f0811_haup"
> > 
> > [Which is ir_(func)_(part number)_(firmware_oem)].  It made sense to me.
> > I assume these are the names to which ir-kbd-i2c and lirc_* will have to
> > bind.  Is that correct?
> 
> Yes, this is correct, and the approach is good.

OK. :)

>  Ideally the "ir_video"
> type would not exist (or would go away over time) and we would have a
> separate type name for each IR chip, resulting in much cleaner code.
> The reason for the current implementation is solely historical.

OK, I had suspected the reason was this.



> Review:
> 
> > diff -r d754a2d5a376 linux/drivers/media/video/cx18/cx18-cards.c
> > --- a/linux/drivers/media/video/cx18/cx18-cards.c	Wed Jul 15 07:28:02 2009 -0300
> > +++ b/linux/drivers/media/video/cx18/cx18-cards.c	Fri Jul 17 16:05:28 2009 -0400
> > @@ -56,7 +56,8 @@
> >  	.hw_audio_ctrl = CX18_HW_418_AV,
> >  	.hw_muxer = CX18_HW_CS5345,
> >  	.hw_all = CX18_HW_TVEEPROM | CX18_HW_418_AV | CX18_HW_TUNER |
> > -		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL,
> > +		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL |
> > +		  CX18_HW_Z8F0811_IR_HAUP,
> >  	.video_inputs = {
> >  		{ CX18_CARD_INPUT_VID_TUNER,  0, CX18_AV_COMPOSITE7 },
> >  		{ CX18_CARD_INPUT_SVIDEO1,    1, CX18_AV_SVIDEO1    },
> > @@ -102,7 +103,8 @@
> >  	.hw_audio_ctrl = CX18_HW_418_AV,
> >  	.hw_muxer = CX18_HW_CS5345,
> >  	.hw_all = CX18_HW_TVEEPROM | CX18_HW_418_AV | CX18_HW_TUNER |
> > -		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL,
> > +		  CX18_HW_CS5345 | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL |
> > +		  CX18_HW_Z8F0811_IR_HAUP,
> >  	.video_inputs = {
> >  		{ CX18_CARD_INPUT_VID_TUNER,  0, CX18_AV_COMPOSITE7 },
> >  		{ CX18_CARD_INPUT_SVIDEO1,    1, CX18_AV_SVIDEO1    },
> > diff -r d754a2d5a376 linux/drivers/media/video/cx18/cx18-cards.h
> > --- a/linux/drivers/media/video/cx18/cx18-cards.h	Wed Jul 15 07:28:02 2009 -0300
> > +++ b/linux/drivers/media/video/cx18/cx18-cards.h	Fri Jul 17 16:05:28 2009 -0400
> > @@ -22,13 +22,17 @@
> >   */
> >  
> >  /* hardware flags */
> > -#define CX18_HW_TUNER		(1 << 0)
> > -#define CX18_HW_TVEEPROM	(1 << 1)
> > -#define CX18_HW_CS5345		(1 << 2)
> > -#define CX18_HW_DVB		(1 << 3)
> > -#define CX18_HW_418_AV		(1 << 4)
> > -#define CX18_HW_GPIO_MUX	(1 << 5)
> > -#define CX18_HW_GPIO_RESET_CTRL	(1 << 6)
> > +#define CX18_HW_TUNER			(1 << 0)
> > +#define CX18_HW_TVEEPROM		(1 << 1)
> > +#define CX18_HW_CS5345			(1 << 2)
> > +#define CX18_HW_DVB			(1 << 3)
> > +#define CX18_HW_418_AV			(1 << 4)
> > +#define CX18_HW_GPIO_MUX		(1 << 5)
> > +#define CX18_HW_GPIO_RESET_CTRL		(1 << 6)
> > +#define CX18_HW_Z8F0811_IR_TX_HAUP	(1 << 7)
> > +#define CX18_HW_Z8F0811_IR_RX_HAUP	(1 << 8)
> > +#define CX18_HW_Z8F0811_IR_HAUP	(CX18_HW_Z8F0811_IR_RX_HAUP | \
> > +				 CX18_HW_Z8F0811_IR_TX_HAUP)
> >  
> >  /* video inputs */
> >  #define	CX18_CARD_INPUT_VID_TUNER	1
> > diff -r d754a2d5a376 linux/drivers/media/video/cx18/cx18-i2c.c
> > --- a/linux/drivers/media/video/cx18/cx18-i2c.c	Wed Jul 15 07:28:02 2009 -0300
> > +++ b/linux/drivers/media/video/cx18/cx18-i2c.c	Fri Jul 17 16:05:28 2009 -0400
> > @@ -40,16 +40,20 @@
> >  #define GETSDL_BIT      0x0008
> >  
> >  #define CX18_CS5345_I2C_ADDR		0x4c
> > +#define CX18_Z8F0811_IR_TX_I2C_ADDR	0x70
> > +#define CX18_Z8F0811_IR_RX_I2C_ADDR	0x71
> >  
> >  /* This array should match the CX18_HW_ defines */
> >  static const u8 hw_addrs[] = {
> > -	0,			/* CX18_HW_TUNER */
> > -	0,			/* CX18_HW_TVEEPROM */
> > -	CX18_CS5345_I2C_ADDR,	/* CX18_HW_CS5345 */
> > -	0,			/* CX18_HW_DVB */
> > -	0,			/* CX18_HW_418_AV */
> > -	0,			/* CX18_HW_GPIO_MUX */
> > -	0,			/* CX18_HW_GPIO_RESET_CTRL */
> > +	0,				/* CX18_HW_TUNER */
> > +	0,				/* CX18_HW_TVEEPROM */
> > +	CX18_CS5345_I2C_ADDR,		/* CX18_HW_CS5345 */
> > +	0,				/* CX18_HW_DVB */
> > +	0,				/* CX18_HW_418_AV */
> > +	0,				/* CX18_HW_GPIO_MUX */
> > +	0,				/* CX18_HW_GPIO_RESET_CTRL */
> > +	CX18_Z8F0811_IR_TX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_TX_HAUP */
> > +	CX18_Z8F0811_IR_RX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_RX_HAUP */
> >  };
> >  
> >  /* This array should match the CX18_HW_ defines */
> > @@ -62,6 +66,8 @@
> >  	0,	/* CX18_HW_418_AV */
> >  	0,	/* CX18_HW_GPIO_MUX */
> >  	0,	/* CX18_HW_GPIO_RESET_CTRL */
> > +	0,	/* CX18_HW_Z8F0811_IR_TX_HAUP */
> > +	0,	/* CX18_HW_Z8F0811_IR_RX_HAUP */
> >  };
> >  
> >  /* This array should match the CX18_HW_ defines */
> > @@ -73,6 +79,8 @@
> >  	NULL,		/* CX18_HW_418_AV */
> >  	NULL,		/* CX18_HW_GPIO_MUX */
> >  	NULL,		/* CX18_HW_GPIO_RESET_CTRL */
> > +	NULL,		/* CX18_HW_Z8F0811_IR_TX_HAUP */
> > +	NULL,		/* CX18_HW_Z8F0811_IR_RX_HAUP */
> >  };
> >  
> >  /* This array should match the CX18_HW_ defines */
> > @@ -84,8 +92,43 @@
> >  	"cx23418_AV",
> >  	"gpio_mux",
> >  	"gpio_reset_ctrl",
> > +	"ir_tx_z8f0811_haup",
> > +	"ir_rx_z8f0811_haup",
> >  };
> >  
> > +static int cx18_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
> > +			   u8 addr)
> > +{
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> > +	struct i2c_board_info info;
> > +	struct IR_i2c_init_data ir_init_data;
> > +	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
> > +
> > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > +	strlcpy(info.type, type, I2C_NAME_SIZE);
> > +
> > +	/* Our default information for ir-kbd-i2c.c to use */
> > +	memset(&ir_init_data, 0, sizeof(struct IR_i2c_init_data));
> > +	switch (hw) {
> > +	case CX18_HW_Z8F0811_IR_RX_HAUP:
> > +		ir_init_data.ir_codes = ir_codes_hauppauge_new;
> > +		ir_init_data.get_key = NULL;
> 
> This is a no-op, as ir_init_data was cleared with memset() right above.

Agree.  I'll get rid of it.

> 
> > +		ir_init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
> > +		ir_init_data.type = IR_TYPE_RC5;
> > +		ir_init_data.name = "CX23418 Z8F0811 Hauppauge";
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +	if (ir_init_data.name)
> > +		info.platform_data = &ir_init_data;
> 
> Not sure why you don't just put this in the switch to save a test? Even
> the memset could go there as far as I can see.


If this were the only I2C IR Rx device I had plans for in the cx18
driver, I would have used an if() statement for the whole thing instead
of a switch().  However, the LeadTek boards have an IR device that I
plan to support someday, so I left the common elements split out.

The biggest penalty here is probably the memset() for the IR Tx portion
of the Z8F0811 chip that doesn't use the ir_init_data, so I'll make the
change as you suggest.



> > +
> > +	return i2c_new_probed_device(adap, &info, addr_list) == NULL ? -1 : 0;
> > +#else
> > +	return -1;
> > +#endif
> > +}
> > +
> >  int cx18_i2c_register(struct cx18 *cx, unsigned idx)
> >  {
> >  	struct v4l2_subdev *sd;
> > @@ -119,7 +162,10 @@
> >  	if (!hw_addrs[idx])
> >  		return -1;
> >  
> > -	/* It's an I2C device other than an analog tuner */
> > +	if (hw & CX18_HW_Z8F0811_IR_HAUP)
> > +		return cx18_i2c_new_ir(adap, hw, type, hw_addrs[idx]);
> 
> For consistency I'd move this up a bit (although I agree it is
> functionally equivalent.)

No problem.


> > +
> > +	/* It's an I2C device other than an analog tuner or IR chip */
> >  	sd = v4l2_i2c_new_subdev(&cx->v4l2_dev, adap, mod, type, hw_addrs[idx]);
> >  	if (sd != NULL)
> >  		sd->grp_id = hw;
> > 
> > 
> 
> The rest looks OK.

OK.  Thanks.

-Andy

