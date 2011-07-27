Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab1G0Pu5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 11:50:57 -0400
Message-ID: <4E3033D6.7020703@redhat.com>
Date: Wed, 27 Jul 2011 12:50:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Alina Friedrichsen <x-alina@gmx.net>, linux-media@vger.kernel.org,
	rglowery@exemail.com.au
Subject: Re: [PATCH v3] tuner_xc2028: Allow selection of the frequency adjustment
 code for XC3028
References: <20110722183552.169950@gmx.net> <4E302207.8050409@redhat.com> <CAGoCfiyx8d_ALG6N+9Zru8Hps3iACx=jCq+bUDkadQMFae=6gg@mail.gmail.com>
In-Reply-To: <CAGoCfiyx8d_ALG6N+9Zru8Hps3iACx=jCq+bUDkadQMFae=6gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-07-2011 11:58, Devin Heitmueller escreveu:
> On Wed, Jul 27, 2011 at 10:34 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Btw, what's the video standard that you're using? DTV7? Does your device use
>> a xc3028 or xc3028xl? Whats's your demod and board?
> 
> It was in the first sentence of his email.  He's got an HVR-1400,
> which uses the xc3028L and dib7000p.

Hmm...

	case CX23885_BOARD_HAUPPAUGE_HVR1400:
		i2c_bus = &dev->i2c_bus[0];
		fe0->dvb.frontend = dvb_attach(dib7000p_attach,
			&i2c_bus->i2c_adap,
			0x12, &hauppauge_hvr1400_dib7000_config);
		if (fe0->dvb.frontend != NULL) {
			struct dvb_frontend *fe;
			struct xc2028_config cfg = {
				.i2c_adap  = &dev->i2c_bus[1].i2c_adap,
				.i2c_addr  = 0x64,
			};
			static struct xc2028_ctrl ctl = {
				.fname   = XC3028L_DEFAULT_FIRMWARE,
				.max_len = 64,
				.demod   = 5000,
				/* This is true for all demods with
					v36 firmware? */
				.type    = XC2028_D2633,
			};

The entry for xc2028 there seems to be wrong! it is specifying a magic value for
.demod, instead of using one of the defined values for it.

On a quick look, this seems to be the only case where the macro is not used:

$ grep -E "demod\s+\=" `find drivers/media/ -type f`
drivers/media/video/cx231xx/cx231xx-cards.c:			.demod = 0;
drivers/media/video/cx23885/cx23885-dvb.c:				.demod       = XC3028_FE_OREN538,
drivers/media/video/cx23885/cx23885-dvb.c:				.demod   = 5000,
drivers/media/video/cx23885/cx23885-dvb.c:				.demod       = XC3028_FE_ZARLINK456,
drivers/media/video/cx23885/cx23885-dvb.c:				.demod       = XC3028_FE_ZARLINK456,
drivers/media/video/cx88/cx88-cards.c:		ctl->demod = XC3028_FE_ZARLINK456;
drivers/media/video/cx88/cx88-cards.c:		ctl->demod = XC3028_FE_OREN538;
drivers/media/video/cx88/cx88-cards.c:		ctl->demod = XC3028_FE_ZARLINK456;
drivers/media/video/cx88/cx88-cards.c:		ctl->demod = XC3028_FE_OREN538;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_ZARLINK456;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_ZARLINK456;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_DEFAULT;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_DEFAULT;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_DEFAULT;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_CHINA;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_CHINA;
drivers/media/video/em28xx/em28xx-cards.c:		ctl->demod = XC3028_FE_OREN538;
drivers/media/video/cx18/cx18-dvb.c:				.demod   = XC3028_FE_ZARLINK456,
drivers/media/video/cx18/cx18-dvb.c:				.demod   = XC3028_FE_ZARLINK456,
drivers/media/video/cx18/cx18-dvb.c:				.demod   = XC3028_FE_ZARLINK456,
drivers/media/video/saa7134/saa7134-cards.c:			ctl.demod = XC3028_FE_ZARLINK456;
drivers/media/video/saa7134/saa7134-cards.c:			ctl.demod = XC3028_FE_OREN538;
drivers/media/dvb/dvb-usb/cxusb.c:		.demod       = XC3028_FE_ZARLINK456,
drivers/media/dvb/dvb-usb/dib0700_devices.c:	.demod = XC3028_FE_DIBCOM52,
(non-relevant results removed)

In the specific case of this device, it should be using this macro:

#define	XC3028_FE_DIBCOM52	5200

As it uses a Dibcom firmware. The logic inside tuner-xc2028 assumes that
those macros are used.

> It's also worth noting that he isn't the first person to complain
> about tuning offset problems with the xc3028L.  Just look at the
> rather nasty hack some random user did for the EVGA inDtube (which is
> xc3208L/s5h1409).

As some drivers are properly using the macros while others aren't that
explains why when someone fixes xc3028 for a device, it breaks support
for other devices.

We should make sure that all devices will use the proper macros, and then
look into a fix for the logic.

> 
> http://linuxtv.org/wiki/index.php/EVGA_inDtube
> 
> Bear in mind that it worked when I added the original support.
> Somebody caused a regression since then though.
> 
> In short, I can appreciate why the user is frustrated.  The xc3028L
> support worked at one point and then somebody broke the xc3028 driver.
> 
> Devin
> 

