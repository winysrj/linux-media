Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KOZlk-00027i-Sb
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 17:08:46 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K4V00EQOM1JBM31@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 31 Jul 2008 11:08:08 -0400 (EDT)
Date: Thu, 31 Jul 2008 11:08:07 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080731042433.GA21788@kryten>
To: Anton Blanchard <anton@samba.org>, "stev391@email.com" <stev391@email.com>
Message-id: <4891D557.10901@linuxtv.org>
MIME-version: 1.0
References: <20080630235654.CCD891CE833@ws1-6.us4.outblaze.com>
	<20080731042433.GA21788@kryten>
Cc: linux-dvb@linuxtv.org, linuxdvb@itee.uq.edu.au
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Anton Blanchard wrote:
> Hi Stephen,
> 
> Thanks a lot for doing this! I have one of these cards and was working
> on Chris Pascoe's patch as a base, but just noticed this mail where you
> have done the same.
> 
> I have a few comments after comparing the two patches (mine is attached).
> 
>> +#if 0
>> +    .portb    = CX23885_MPEG_DVB,
>> +#endif
> 
> I noticed recent changes to the cx32885 SRAM definitions in the upstream
> git tree and I was able to get both ports working, so I guess this can
> be re-enabled (as you suggest in your comment).
> 
> cx23885_gpio_setup():
>> +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
>> +    /* GPIO-0 portb xc3028 reset */
>> +    /* GPIO-1 portb zl10353 reset */
>> +    /* GPIO-2 portc xc3028 reset */
>> +    /* GPIO-3 portc zl10353 reset */
>> +    cx_write(GP0_IO, 0x002f1000);
>> +    break;
> 
> I'm wondering where this magic number came from (did Chris get it from a
> register dump out of Windows?). All of the other cards (including the
> Fusion HDTV7 dual express) just take the tuner and demodulator out of
> reset here. Thats what I'm doing in my patch below and it seems to
> work fine.
> 
>>  #include "xc5000.h"
>>  #include "tda10048.h"
>>  #include "tuner-xc2028.h"
>> +#include "tuner-xc2028-types.h"
> 
> This looks like a private header and after your change to the firmware
> load code (so it no longer references ZARLINK456) we can remove it.
> 
> cx23885_dvico_xc2028_callback():
>> +    if (port->nr == 0)
>> +    reset_mask = 0x0101;
>> +    else if (port->nr == 1)
>> +    reset_mask = 0x0404;
> 
> Do we need to hit both GPIO bits (0x101)? I was only hitting the lower
> bit (0x1) and it works fine. (cc-ing Stephen Toth since I noticed an
> email from him about this in the archives).
> 
> dvb_register():
>> +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
>> +    i2c_bus = &dev->i2c_bus[port->nr - 1];
>> +
>> +    /* Take demod and tuner out of reset */
>> +    if (port->nr == 1)
>> +    cx_set(GP0_IO, 0x0303);
>> +    else if (port->nr == 2)
>> +    cx_set(GP0_IO, 0x0c0c);
>> +    mdelay(5);
> 
> Taking the tuner and demodulator out of reset here makes this driver the
> odd one out, I'd suggest putting it into the gpio_setup routine.
> 
> Anton
> 
> --
> 
> Add support for DViCO FusionHDTV DVB-T Dual Express, based on work by 
> Chris Pascoe and Stephen Backway.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> diff --git a/Documentation/video4linux/CARDLIST.cx23885 b/Documentation/video4linux/CARDLIST.cx23885
> index f0e613b..bccafd3 100644
> --- a/Documentation/video4linux/CARDLIST.cx23885
> +++ b/Documentation/video4linux/CARDLIST.cx23885
> @@ -9,3 +9,4 @@
>    8 -> Hauppauge WinTV-HVR1700                             [0070:8101]
>    9 -> Hauppauge WinTV-HVR1400                             [0070:8010]
>   10 -> DViCO FusionHDTV7 Dual Express                      [18ac:d618]
> + 11 -> DViCO FusionHDTV DVB-T Dual Express                 [18ac:db78]
> diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
> index a19de85..d21adc8 100644
> --- a/drivers/media/video/cx23885/cx23885-cards.c
> +++ b/drivers/media/video/cx23885/cx23885-cards.c
> @@ -148,6 +148,11 @@ struct cx23885_board cx23885_boards[] = {
>  		.portb		= CX23885_MPEG_DVB,
>  		.portc		= CX23885_MPEG_DVB,
>  	},
> +	[CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] = {
> +		.name		= "DViCO FusionHDTV DVB-T Dual Express",
> +		.portb		= CX23885_MPEG_DVB,
> +		.portc		= CX23885_MPEG_DVB,
> +	},
>  };
>  const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>  
> @@ -219,6 +224,10 @@ struct cx23885_subid cx23885_subids[] = {
>  		.subvendor = 0x18ac,
>  		.subdevice = 0xd618,
>  		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
> +	},{
> +		.subvendor = 0x18ac,
> +		.subdevice = 0xdb78,
> +		.card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
>  	},
>  };
>  const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -465,6 +474,19 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
>  		mdelay(20);
>  		cx_set(GP0_IO, 0x000f000f);
>  		break;
> +	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
> +		/* GPIO-0 portb xc3028 reset */
> +		/* GPIO-1 portb zl10353 reset */
> +		/* GPIO-2 portc xc3028 reset */
> +		/* GPIO-3 portc zl10353 reset */
> +
> +		/* Put the parts into reset and back */
> +		cx_set(GP0_IO, 0x000f0000);
> +		mdelay(20);
> +		cx_clear(GP0_IO, 0x0000000f);
> +		mdelay(20);
> +		cx_set(GP0_IO, 0x000f000f);
> +		break;
>  	}
>  }
>  
> @@ -516,6 +538,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>  
>  	switch (dev->board) {
>  	case CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP:
> +	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
>  		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
>  		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>  		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
> index 0a2e655..c5a5306 100644
> --- a/drivers/media/video/cx23885/cx23885-dvb.c
> +++ b/drivers/media/video/cx23885/cx23885-dvb.c
> @@ -42,6 +42,7 @@
>  #include "tuner-simple.h"
>  #include "dib7000p.h"
>  #include "dibx000_common.h"
> +#include "zl10353.h"
>  
>  static unsigned int debug;
>  
> @@ -333,6 +334,44 @@ static int cx23885_hvr1500_xc3028_callback(void *ptr, int command, int arg)
>  	return 0;
>  }
>  
> +static int cx23885_dvico_xc2028_callback(void *ptr, int command, int arg)
> +{
> +	struct cx23885_tsport *port = ptr;
> +	struct cx23885_dev *dev = port->dev;
> +	u32 reset_mask = 0;
> +
> +	switch (command) {
> +	case XC2028_TUNER_RESET:
> +		dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __FUNCTION__,
> +			arg, port->nr);
> +
> +		if (port->nr == 0)
> +			reset_mask = 0x01;
> +		else if (port->nr == 1)
> +			reset_mask = 0x04;
> +
> +		cx_clear(GP0_IO, reset_mask);
> +		mdelay(20);
> +		cx_set(GP0_IO, reset_mask);
> +		break;
> +	case XC2028_RESET_CLK:
> +		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
> +		break;
> +	default:
> +		dprintk(1, "%s: unknown command %d, arg %d\n", __FUNCTION__,
> +		       command, arg);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct zl10353_config dvico_fusionhdtv_xc3028 = {
> +	.demod_address = 0x0f,
> +	.if2           = 45600,
> +	.no_tuner      = 1,
> +};
> +
>  static int dvb_register(struct cx23885_tsport *port)
>  {
>  	struct cx23885_dev *dev = port->dev;
> @@ -495,6 +534,33 @@ static int dvb_register(struct cx23885_tsport *port)
>  				&i2c_bus->i2c_adap,
>  				&dvico_xc5000_tunerconfig, i2c_bus);
>  		break;
> +	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
> +		i2c_bus = &dev->i2c_bus[port->nr - 1];
> +
> +		port->dvb.frontend = dvb_attach(zl10353_attach,
> +					       &dvico_fusionhdtv_xc3028,
> +					       &i2c_bus->i2c_adap);
> +		if (port->dvb.frontend != NULL) {
> +			struct dvb_frontend      *fe;
> +			struct xc2028_config	  cfg = {
> +				.i2c_adap  = &i2c_bus->i2c_adap,
> +				.i2c_addr  = 0x61,
> +				.video_dev = port,
> +				.callback  = cx23885_dvico_xc2028_callback,
> +			};
> +			static struct xc2028_ctrl ctl = {
> +				.fname       = "xc3028-v27.fw",
> +				.max_len     = 64,
> +				.demod       = XC3028_FE_ZARLINK456,
> +			};
> +
> +			fe = dvb_attach(xc2028_attach, port->dvb.frontend,
> +					&cfg);
> +			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
> +				fe->ops.tuner_ops.set_config(fe, &ctl);
> +		}
> +		break;
> +	}
>  	default:
>  		printk("%s: The frontend of your DVB/ATSC card isn't supported yet\n",
>  		       dev->name);
> diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
> index 00dfdc8..7b3ec5b 100644
> --- a/drivers/media/video/cx23885/cx23885.h
> +++ b/drivers/media/video/cx23885/cx23885.h
> @@ -64,6 +64,7 @@
>  #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
>  #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
>  #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
> +#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
>  
>  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
>  #define CX23885_NORMS (\

Please try to confirm to the callback cx23885_tuner_callback, we don't 
want/need a dvico specific callback.:

http://linuxtv.org/hg/~stoth/v4l-dvb/rev/2d925110d38a

If you have a specific reason why you need a 2028 callback, let's 
discuss, we should refactor the current callback.

Please refine the tuner callback and rebase the patch from the current 
v4l-dvb tree.

Good work, thanks, you're almost done.

- Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
