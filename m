Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:37392 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415Ab0A0WuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 17:50:04 -0500
Subject: Re: IR device at I2C address 0x7a
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Roman <muzungu@gmx.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daro <ghost-rider@aster.pl>, LMML <linux-media@vger.kernel.org>
In-Reply-To: <20100127103818.73d31620@hyperion.delvare>
References: <4B324EF0.7090606@aster.pl>
	 <20100106153909.6bce3183@hyperion.delvare> <4B44CF62.5060405@aster.pl>
	 <20100106194059.061636d3@hyperion.delvare> <4B44E026.3060906@aster.pl>
	 <20100106212140.11b02d0f@hyperion.delvare> <4B4871C4.10401@aster.pl>
	 <20100109171457.77439f12@hyperion.delvare>
	 <1263079126.3870.65.camel@pc07.localdom.local>
	 <20100110095116.110c21ae@hyperion.delvare>
	 <1263160505.3313.22.camel@pc07.localdom.local>
	 <20100127103818.73d31620@hyperion.delvare>
Content-Type: text/plain
Date: Wed, 27 Jan 2010 23:49:11 +0100
Message-Id: <1264632551.5026.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Am Mittwoch, den 27.01.2010, 10:38 +0100 schrieb Jean Delvare:
> Hi Hermann,
> 
> Sorry for the late answer.
> 
> On Sun, 10 Jan 2010 22:55:05 +0100, hermann pitton wrote:
> > Am Sonntag, den 10.01.2010, 09:51 +0100 schrieb Jean Delvare:
> > > On Sun, 10 Jan 2010 00:18:46 +0100, hermann pitton wrote:
> > > > Am Samstag, den 09.01.2010, 17:14 +0100 schrieb Jean Delvare:
> > > > > Then I would suggest the following patch:
> > > > > 
> > > > > * * * * *
> > > > > 
> > > > > From: Jean Delvare <khali@linux-fr.org>
> > > > > Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> > > > > 
> > > > > Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> > > > > Analog (card=146). However, by the time we find out, some
> > > > > card-specific initialization is missed. In particular, the fact that
> > > > > the IR is GPIO-based. Set it when we change the card type.
> > > > > 
> > > > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > > > Tested-by: Daro <ghost-rider@aster.pl>
> > > > 
> > > > just to note it, the ASUS TV-FM 7135 with USB remote is different to the
> > > > Asus My Cinema P7134 Analog only, not only for the remote, but also for
> > > > inputs, but they have the same PCI subsystem.
> > > > 
> > > > > ---
> > > > >  linux/drivers/media/video/saa7134/saa7134-cards.c |    1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > > 
> > > > > --- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-12-11 09:47:47.000000000 +0100
> > > > > +++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-09 16:23:17.000000000 +0100
> > > > > @@ -7257,6 +7257,7 @@ int saa7134_board_init2(struct saa7134_d
> > > > >  		       printk(KERN_INFO "%s: P7131 analog only, using "
> > > > >  						       "entry of %s\n",
> > > > >  		       dev->name, saa7134_boards[dev->board].name);
> > > > > +			dev->has_remote = SAA7134_REMOTE_GPIO;
> > > > >  	       }
> > > > >  	       break;
> > > > >  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> > > > > 
> > > > > 
> > > > > * * * * *
> > > > 
> > > > Must have been broken at that time, IIRC.
> > > 
> > > What must have been broken, and when? You are confusing.
> > 
> > Sorry, I missed that thread until now.
> > The above patch was tried previously by Roman.
> > 
> > For the record, here is a link.
> > http://www.spinics.net/lists/vfl/msg38869.html
> 
> Thanks for the pointer, this was very helpful. I had missed the fact
> that the call to saa7134_input_init1() was before the card number
> change. So indeed my patch was insufficient.
> 
> Roman's strategy to move saa7134_input_init1() to the late init section
> seems good to me. Honestly, I can't think of a good reason to init the
> remote control early. I doubt that anything else depends on that.
> 
> I'll send an updated patch shortly.

thanks for your time looking closer into it.

Unfortunately I did not have any during the last two months.

If we pass all the testing, your here announced and later following
patch should be the best possible solution, as it stands now.

To give some historical notes, Gerd did try to avoid eeprom detection on
the saa7134 driver, likely hoping to see better PCI subsystem use by the
manufacturers, since bttv was already very complex and difficult to
maintain with all the specific detection stuff and workarounds.

However, Hartmut Hackmann and me had to discover, that we still see the
same disease with some saa713x OEMs, the same PCI subsystem for very
different cards ...

Hence we started with some eeprom detection, known now for having caused
trouble already through all the ever ongoing changing init procedures we
always have and very bad for transparent maintenance.

For all, and for Asus specifically, this is still a unique case on the
saa713x driver, IIRC. The rest is fine on Asus.

To print something for that card like "for IR you have to set the
card=number" should be also still enough.

To remind, we run into those problems, because OEMs don't follow the
rules of the chip manufacturer, excluding others by will on their m$
drivers, when initially buying greater amounts of chips.

So we always run only after the tsunamis and it is not worth it, to give
those breaking rules previously, some kind of moral instance to get
their devices better detected on GNU/Linux later.

Anyway, let's try.

Cheers,
Hermann








