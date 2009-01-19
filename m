Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:56250 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbZASRQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 12:16:01 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, CityK <cityk@rogers.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <20090119090819.3f4a1656@pedra.chehab.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <200901182241.10047.hverkuil@xs4all.nl> <4973BD03.4060702@rogers.com>
	 <200901190853.19327.hverkuil@xs4all.nl>
	 <20090119090819.3f4a1656@pedra.chehab.org>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 18:16:21 +0100
Message-Id: <1232385381.3238.23.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 19.01.2009, 09:08 -0200 schrieb Mauro Carvalho Chehab: 
> On Mon, 19 Jan 2009 08:53:19 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > On Monday 19 January 2009 00:36:35 CityK wrote:
> > > Hans Verkuil wrote:
> > > > On Sunday 18 January 2009 22:20:30 CityK wrote:
> > > >> The output of dmesg is interesting (two times tuner simple
> > > >> initiating):
> > > >
> > > > Shouldn't there be a tda9887 as well? It's what the card config says,
> > > > but I'm not sure whether that is correct.
> > > >
> > > >> Would you like to see the results of after enabling 12c_scan to see
> > > >> what is going on, or is this the behaviour you expected?
> > > >
> > > > It seems to be OK, although I find it a bit peculiar that the tuner
> > > > type is set twice. Or does that have to do with it being a hybrid
> > > > tuner, perhaps?
> > >
> > > The Philips TUV1236D NIM does indeed use a tda9887  (I know, because I
> > > was the one who discovered this some four years ago (pats self on
> > > head)).  But the module is not loading.  I can make it load, just as
> > > Hermann demonstrated to Mike in one of the recent messages for this
> > > thread.
> > 
> > I have no idea why the tda9887 isn't loading. 
> 
> Probably, it has something to do with the i2c gate control.

in my case on the md7134 cards it happens only after cold boot.
Analog of course doesn't work then.

To reload the saa7134 with "modprobe" then is also enough to get it
loaded and analog functional, likely what Mike meant.

On warm reboots it is present and functional. Some eeprom readout
corruption mostly on the first card occurs and I must force card=12.

The tda9887 is by default not visible on the FMD1216ME MK3 hybrid.

The init from Hartmut in tuner-core.c in set_tuner_type for analog.

	case TUNER_PHILIPS_FMD1216ME_MK3:
		buffer[0] = 0x0b;
		buffer[1] = 0xdc;
		buffer[2] = 0x9c;
		buffer[3] = 0x60;
		i2c_master_send(c, buffer, 4);
		mdelay(1);
		buffer[2] = 0x86;
		buffer[3] = 0x54;
		i2c_master_send(c, buffer, 4);
		if (!dvb_attach(simple_tuner_attach, &t->fe,
				t->i2c->adapter, t->i2c->addr, t->type))
			goto attach_failed;
		break;

from dmesg.

dmesg |grep "< c2"
saa7133[1]: i2c xfer: < c2 30 90 >
saa7134[3]: i2c xfer: < c2 >
saa7134[3]: i2c xfer: < c2 0b dc 9c 60 >
saa7134[3]: i2c xfer: < c2 0b dc 86 54 >

Exactly here, when the buffers are sent the second time the tda9887
becomes the first time visible on the bus. According to Hartmut the
modification of buffer[3] from 0x60 to 0x54 is that hidden switch,
IIRC. 

saa7134[3]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[3]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[3]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[3]: i2c xfer: < c2 9c 60 85 54 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7133[1]: i2c xfer: < c2 30 90 >
saa7134[3]: i2c xfer: < c2 9c 60 85 54 >

> > Note that Mauro merged my saa7134 changes, so these are now in the master 
> > repository.
> 
> Yes. We need to fix it asap, to avoid regressions. It is time to review also
> the other codes that are touching on i2c gates at _init2().

My other cards with tda8275a, tda8290, tda10046 and/or tda826x and
tda10086 still work and the FMD1216ME init broken is old. 

There is an old issue, maybe not reported yet, that after suspend to RAM
it seems the AGC control for DVB-T is lost, lots of artifacts. After
using analog TV or reload the saa7134 it is fixed.
Just to mention it.

Cheers,
Hermann

> Cheers,
> Mauro


