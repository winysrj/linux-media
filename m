Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAF2E7je025729
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 21:14:07 -0500
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAF2Dqh8000974
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 21:13:52 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Ben Klein <shacklein@gmail.com>
In-Reply-To: <d7e40be30811141518w15af2371p15195d2024bc9cb1@mail.gmail.com>
References: <491339D9.2010504@personnelware.com> <4913E9DB.8040801@hhs.nl>
	<200811071050.25149.hverkuil@xs4all.nl>
	<20081107161956.c096dd03.ospite@studenti.unina.it>
	<alpine.DEB.1.10.0811071416380.25756@vegas>
	<alpine.DEB.1.10.0811130651170.2643@vegas>
	<d9def9db0811130440t17b05c58q603a14e446e417e5@mail.gmail.com>
	<alpine.DEB.1.10.0811141033000.23321@vegas>
	<d9def9db0811140750s15969a1fh1272402de897944d@mail.gmail.com>
	<d7e40be30811141517p5700f803t731ec578f1cabd59@mail.gmail.com>
	<d7e40be30811141518w15af2371p15195d2024bc9cb1@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 03:11:18 +0100
Message-Id: <1226715078.2705.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: USB Capture device
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

some interesting ideas.

Am Samstag, den 15.11.2008, 10:18 +1100 schrieb Ben Klein:
> (oops, forgot to send this to the mailing list)
> 
> In general, there is no price advantage with getting a capture device
> without a tuner. There are at least two reasons for this:

Major hardware providers still have a fine grained offer.
A capture only device without tuner, radio, remote etc. is still
cheapest. I agree, that it might come to a point, given that tuners are
becoming cheaper these days, it won't make much sense anymore to provide
capture only devices.

But you still pay more for each additional tuner/demod on every card.
It is not such remarkable anymore like on the PVR500 in the beginning,
but still visible for triple capable devices, because current systems
are running out of available PCI slots.

The future fights on the markets will happen on multi tuner PCIe and
DVB-S2 capable devices as a next step and DVB-T2 will follow.

> 1) Less demand for just a capture device. People want to turn their
> computers into idiot boxes

That does not make any difference. From an external device you can feed
any BS coming from external tuners or anything else too ...

> 2) Most capture-only cards are (probably) TV tuners with the tuner disabled.
> It's cheaper for them to make that way.

That I do seriously doubt for now. Give some examples.

> I got a cheap-and-nasty USB em28xx that pretty much *just* works, but it's
> enough for me. It has a usb-audio device in it which seems to not sync up
> with the video. The only em28xx card= options that work with it are for
> cards with tuners (though that doesn't necessarily mean that the card has a
> tuner).
> 
> I also have a PCI K-World Vstream Xpert DVB-T (cx88), which I selected due
> to it having a good price and analogue capture. Turns out I've used the
> analogue capture more than the digital reception. :) The analogue capture
> *looks like* a full TV tuner with the tuner disabled, but I could be wrong
> about this too.

Maybe, the analog tuner at least is disabled.

cx88-cards.c.

	[CX88_BOARD_KWORLD_DVB_T] = {
		.name           = "KWorld/VStream XPert DVB-T",
		.tuner_type     = TUNER_ABSENT,
		.radio_type     = UNSET,
		.tuner_addr	= ADDR_UNSET,
		.radio_addr	= ADDR_UNSET,
		.input          = {{
			.type   = CX88_VMUX_COMPOSITE1,
			.vmux   = 1,
			.gpio0  = 0x0700,
			.gpio2  = 0x0101,
		},{
			.type   = CX88_VMUX_SVIDEO,
			.vmux   = 2,
			.gpio0  = 0x0700,
			.gpio2  = 0x0101,
		}},
		.mpeg           = CX88_MPEG_DVB,
	},

cx88-dvb.c.

	case CX88_BOARD_KWORLD_DVB_T:
	case CX88_BOARD_DNTV_LIVE_DVB_T:
	case CX88_BOARD_ADSTECH_DVB_T_PCI:
		fe0->dvb.frontend = dvb_attach(mt352_attach,
					       &dntv_live_dvbt_config,
					       &core->i2c_adap);
		if (fe0->dvb.frontend != NULL) {
			if (!dvb_attach(dvb_pll_attach, fe0->dvb.frontend,
					0x61, NULL, DVB_PLL_UNKNOWN_1))
				goto frontend_detach;
		}
		break;

dvb-pll.c.

static struct dvb_pll_desc dvb_pll_unknown_1 = {
	.name  = "unknown 1", /* used by dntv live dvb-t */
	.min   = 174000000,
	.max   = 862000000,
	.iffreq= 36166667,
	.count = 9,
	.entries = {
		{  150000000, 166667, 0xb4, 0x01 },
		{  173000000, 166667, 0xbc, 0x01 },
		{  250000000, 166667, 0xb4, 0x02 },
		{  400000000, 166667, 0xbc, 0x02 },
		{  420000000, 166667, 0xf4, 0x02 },
		{  470000000, 166667, 0xfc, 0x02 },
		{  600000000, 166667, 0xbc, 0x08 },
		{  730000000, 166667, 0xf4, 0x08 },
		{  999999999, 166667, 0xfc, 0x08 },
	},
};

Cheers,
Hermann


> 2008/11/15 Markus Rechberger <mrechberger@gmail.com>
> 
> On Fri, Nov 14, 2008 at 4:37 PM, Keith Lawson <lawsonk@lawson-tech.com>
> > wrote:
> > >
> > >
> > > On Thu, 13 Nov 2008, Markus Rechberger wrote:
> > > <snip>
> > >>
> > >> are you sure this device is tm6000 based? I just remember the same
> > >> product package used for em2820 based devices.
> > >>
> > >> http://mcentral.de/wiki/index.php5/Em2880#Devices
> > >
> > > It's a TM5600 device. I've been able to capture video from it using the
> > > tm5600/tm6000/tm6010 module from Mauro's mercurial repository
> > > but I'm having an issue with green flickering a the top of the video, I'm
> > > not sure if that's a driver issue or an mplayer issue.
> > >
> > > Are you aware of a em2820 based USB "dongle" device? I don't require a
> > > tuner, I'm just trying to capture input from S-video and composite (RCA).
> > >
> >
> > I just had a rough look right now, the prices vary alot between
> > different manufacturers.
> > I haven't seen a price advantage for devices without tuner actually.
> > You might pick a few devices from that site and compare.
> >
> > br,
> > Markus
> >
> > >>
> > >> br,
> > >> Markus
> > >>
> > >>> Thanks,
> > >>> Keith.
> > >>>
> > >>> On Fri, 7 Nov 2008, Keith Lawson wrote:
> > >>>
> > >>>> Hello,
> > >>>>
> > >>>> Can anyone suggest a good USB catpure device that has S-Video input
> > and
> > >>>> a
> > >>>> stable kernel driver? I've been playing with this device:
> > >>>>
> > >>>> http://www.diamondmm.com/VC500.php
> > >>>>
> > >>>> using the development drivers from
> > >>>> http://linuxtv.org/hg/~mchehab/tm6010/<http://linuxtv.org/hg/%7Emchehab/tm6010/>
> > >>>> but I haven't had any luck with S-Video (only composite).
> > >>>>
> > >>>> Can anyone suggest a device with stable drivers in 2.6.27.5?
> > >>>>
> > >>>> Thanks, Keith.
> > >>>>


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
