Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2LOByp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 20:54:45 -0500
Date: Fri, 14 Dec 2012 23:54:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20121214235412.2598c91c@redhat.com>
In-Reply-To: <50CBCAB9.602@iki.fi>
References: <50B5779A.9090807@pyther.net>
	<50C12302.80603@pyther.net>
	<50C34628.5030407@googlemail.com>
	<50C34A50.6000207@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
	<CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
	<50C4BA20.8060003@googlemail.com>
	<50C4BAFB.60304@googlemail.com>
	<50C4C525.6020006@googlemail.com>
	<50C4D011.6010700@pyther.net>
	<50C60220.8050908@googlemail.com>
	<CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
	<50C60772.2010904@googlemail.com>
	<CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
	<50C6226C.8090302@iki! .fi>
	<50C636E7.8060003@googlemail.com>
	<50C64AB0.7020407@iki.fi>
	<50C79CD6.4060501@googlemail.com>
	<50C79E9A.3050301@iki.fi>
	<20121213182336.2cca9da6@redhat.! com>
	<50CB46CE.60407@googlemail.com>
	<20121214173950.79bb963e@redhat.com>
	<20121214222631.1f191d6e@redhat.co!
 m>
	<50CBCAB9.602@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Dec 2012 02:56:25 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 12/15/2012 02:26 AM, Mauro Carvalho Chehab wrote:
> > Em Fri, 14 Dec 2012 17:39:50 -0200
> > Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> >
> >>> Anyway, first we have to GET the bytes from the hardware. That's our
> >>> current problem !
> >>> And the hardware seems to need a different setup for reg 0x50 for the
> >>> different NEC sub protocols.
> >>> Which means that the we need to know the sub protocol BEFORE we get any
> >>> bytes from the device.
> >>
> >> No. All em28xx needs is to make sure that the NEC protocol will return
> >> the full 32 bits scancode.
> >
> > It seems a way easier/quicker to just add the proper support there at the
> > driver than keep answering to this thread ;)
> >
> > Tested here with a Terratec HTC stick, and using two different IR's:
> > 	- a Terratec IR (address code 0x14 - standard NEC);
> > 	- a Pixelview IR (address code 0x866b - 24 bits NEC).
> >
> > All tests were done with the very latest version of ir-keytable, found at
> > v4l-utils.git tree (http://git.linuxtv.org/v4l-utils.git).
> >
> > See the results, with the Terratec table loaded (default when the
> > driver is loaded):
> >
> > 	# ir-keytable -t
> > 	Testing events. Please, press CTRL-C to abort.
> > 		# Terratec IR
> > 	1355529698.198046: event type EV_MSC(0x04): scancode = 0x1402
> > 	1355529698.198046: event type EV_KEY(0x01) key_down: KEY_1(0x0001)
> > 	1355529698.198046: event type EV_SYN(0x00).
> > 	11355529698.298170: event type EV_MSC(0x04): scancode = 0x1402
> > 	1355529698.298170: event type EV_SYN(0x00).
> > 	1355529698.547998: event type EV_KEY(0x01) key_up: KEY_1(0x0001)
> > 	1355529698.547998: event type EV_SYN(0x00).
> > 		# Pixelview IR
> > 	1355530261.416415: event type EV_MSC(0x04): scancode = 0x866b01
> > 	1355530261.416415: event type EV_SYN(0x00).
> > 	1355530262.216301: event type EV_MSC(0x04): scancode = 0x866b0b
> > 	1355530262.216301: event type EV_SYN(0x00).
> >
> > Replacing the keytable to the Pixelview's one:
> >
> > 	# ir-keytable -w /etc/rc_keymaps/pixelview_002t -c
> > 	Read pixelview_002t table
> > 	Old keytable cleared
> > 	Wrote 26 keycode(s) to driver
> > 	Protocols changed to NEC
> >
> > 	# ir-keytable -t
> > 	Testing events. Please, press CTRL-C to abort.
> > 	1355530569.420398: event type EV_MSC(0x04): scancode = 0x1402
> > 	1355530569.420398: event type EV_SYN(0x00).
> > 	1355530588.120409: event type EV_MSC(0x04): scancode = 0x866b01
> > 	1355530588.120409: event type EV_KEY(0x01) key_down: KEY_1(0x0001)
> > 	1355530591.670077: event type EV_SYN(0x00).
> >
> > And, finally, keeping both keytables active at the same time:
> >
> > 	# ir-keytable -c -w /etc/rc_keymaps/pixelview_002t -w /etc/rc_keymaps/nec_terratec_cinergy_xs
> > 	Read pixelview_002t table
> > 	Read nec_terratec_cinergy_xs table
> > 	Old keytable cleared
> > 	Wrote 74 keycode(s) to driver
> > 	Protocols changed to NEC
> >
> > 	# sudo ir-keytable  -t
> > 	Testing events. Please, press CTRL-C to abort.
> > 	1355530856.325201: event type EV_MSC(0x04): scancode = 0x866b01
> > 	1355530856.325201: event type EV_KEY(0x01) key_down: KEY_1(0x0001)
> > 	1355530856.325201: event type EV_SYN(0x00).
> > 	11355530856.575070: event type EV_KEY(0x01) key_up: KEY_1(0x0001)
> > 	1355530856.575070: event type EV_SYN(0x00).
> > 	1355530869.125226: event type EV_MSC(0x04): scancode = 0x1402
> > 	1355530869.125226: event type EV_KEY(0x01) key_down: KEY_1(0x0001)
> > 	1355530869.125226: event type EV_SYN(0x00).
> > 	11355530869.225216: event type EV_MSC(0x04): scancode = 0x1402
> > 	1355530869.225216: event type EV_SYN(0x00).
> > 	1355530869.475075: event type EV_KEY(0x01) key_up: KEY_1(0x0001)
> > 	1355530869.475075: event type EV_SYN(0x00).
> >
> > -
> >
> > em28xx: add support for 24bits/32 bits NEC variants on em2874 and upper
> >
> > By disabling the NEC parity check, it is possible to handle all 3 NEC
> > protocol variants (32, 24 or 16 bits).
> >
> > Change the driver in order to handle all of them.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> 
> 
> 
> NACK. NEC variant selection logic is broken by design.
> 
> 
> 
> 
> 
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> > index 97d36b4..c84e4c8 100644
> > --- a/drivers/media/usb/em28xx/em28xx-input.c
> > +++ b/drivers/media/usb/em28xx/em28xx-input.c
> > @@ -57,8 +57,8 @@ MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
> >   struct em28xx_ir_poll_result {
> >   	unsigned int toggle_bit:1;
> >   	unsigned int read_count:7;
> > -	u8 rc_address;
> > -	u8 rc_data[4]; /* 1 byte on em2860/2880, 4 on em2874 */
> > +
> > +	u32 scancode;
> >   };
> >
> >   struct em28xx_IR {
> > @@ -72,6 +72,7 @@ struct em28xx_IR {
> >   	struct delayed_work work;
> >   	unsigned int full_code:1;
> >   	unsigned int last_readcount;
> > +	u64 rc_type;
> >
> >   	int  (*get_key)(struct em28xx_IR *, struct em28xx_ir_poll_result *);
> >   };
> > @@ -236,11 +237,8 @@ static int default_polling_getkey(struct em28xx_IR *ir,
> >   	/* Infrared read count (Reg 0x45[6:0] */
> >   	poll_result->read_count = (msg[0] & 0x7f);
> >
> > -	/* Remote Control Address (Reg 0x46) */
> > -	poll_result->rc_address = msg[1];
> > -
> > -	/* Remote Control Data (Reg 0x47) */
> > -	poll_result->rc_data[0] = msg[2];
> > +	/* Remote Control Address/Data (Regs 0x46/0x47) */
> > +	poll_result->scancode = msg[1] << 8 | msg[2];
> >
> >   	return 0;
> >   }
> > @@ -266,13 +264,30 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
> >   	/* Infrared read count (Reg 0x51[6:0] */
> >   	poll_result->read_count = (msg[0] & 0x7f);
> >
> > -	/* Remote Control Address (Reg 0x52) */
> > -	poll_result->rc_address = msg[1];
> > -
> > -	/* Remote Control Data (Reg 0x53-55) */
> > -	poll_result->rc_data[0] = msg[2];
> > -	poll_result->rc_data[1] = msg[3];
> > -	poll_result->rc_data[2] = msg[4];
> > +		/* Remote Control Address (Reg 0x52) */
> > +		/* Remote Control Data (Reg 0x53-0x55) */
> > +	switch (ir->rc_type) {
> > +	case RC_TYPE_RC5:
> > +		poll_result->scancode = msg[1] << 8 | msg[2];
> > +		break;
> > +	case RC_TYPE_NEC:
> > +		if ((msg[3] ^ msg[4]) != 0xff) 		/* 32 bits NEC */
> 
> See for example KEY_CYCLEWINDOWS from RC_MAP_TIVO. Do you think it 
> works..... :-(

	{ 0xa10cfa05, KEY_CYCLEWINDOWS }, /* Window */

You're right: for it to work, this key would be needed to be defined as:

	{ 0xa10c05, KEY_CYCLEWINDOWS }, /* Window */

I agree, that's weird, but a vendor that uses a key definition like
that doesn't know what he's doing, as a remote control with address = 0xa10c
will very likely produce the same code.

Btw, the way it is currently declared won't work either with mceusb, as
the IR decoder also does the same thing.

(c/c Jarod, as he added the Tivo IR).

...

> OK, it is much better and I can even see that in Kernel than keeping 
> old, very limited implementation.
> 
> My aim was just to probe whole variant selection method is quite broken, 
> and it is impossible to get working with 100% reliable. As I have said 
> loudly :) , I want 32bit scancodes for all NEC remotes, no variants at 
> all. I think you are about the only person who wants to keep current 
> multiple NEC variant implementation...

I'm not bound to it, and no, I'm not the only one that voted for this
implementation. This were discussed in the past, when support for "extended"
nec got added (24 bits). When the first 32 bits NEC-yet-another-weird-variant
arrived, the choice was natural.

The thing is: userspace can't be broken by whatever change we do. The way
it got implemented were the one that wouldn't generate regressions.
It is as simple as that.

Cheers,
Mauro
