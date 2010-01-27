Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:59881 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0A0JiX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 04:38:23 -0500
Date: Wed, 27 Jan 2010 10:38:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Roman <muzungu@gmx.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Daro <ghost-rider@aster.pl>, LMML <linux-media@vger.kernel.org>
Subject: Re: IR device at I2C address 0x7a
Message-ID: <20100127103818.73d31620@hyperion.delvare>
In-Reply-To: <1263160505.3313.22.camel@pc07.localdom.local>
References: <4B324EF0.7090606@aster.pl>
	<20100106153909.6bce3183@hyperion.delvare>
	<4B44CF62.5060405@aster.pl>
	<20100106194059.061636d3@hyperion.delvare>
	<4B44E026.3060906@aster.pl>
	<20100106212140.11b02d0f@hyperion.delvare>
	<4B4871C4.10401@aster.pl>
	<20100109171457.77439f12@hyperion.delvare>
	<1263079126.3870.65.camel@pc07.localdom.local>
	<20100110095116.110c21ae@hyperion.delvare>
	<1263160505.3313.22.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

Sorry for the late answer.

On Sun, 10 Jan 2010 22:55:05 +0100, hermann pitton wrote:
> Am Sonntag, den 10.01.2010, 09:51 +0100 schrieb Jean Delvare:
> > On Sun, 10 Jan 2010 00:18:46 +0100, hermann pitton wrote:
> > > Am Samstag, den 09.01.2010, 17:14 +0100 schrieb Jean Delvare:
> > > > Then I would suggest the following patch:
> > > > 
> > > > * * * * *
> > > > 
> > > > From: Jean Delvare <khali@linux-fr.org>
> > > > Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> > > > 
> > > > Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> > > > Analog (card=146). However, by the time we find out, some
> > > > card-specific initialization is missed. In particular, the fact that
> > > > the IR is GPIO-based. Set it when we change the card type.
> > > > 
> > > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > > Tested-by: Daro <ghost-rider@aster.pl>
> > > 
> > > just to note it, the ASUS TV-FM 7135 with USB remote is different to the
> > > Asus My Cinema P7134 Analog only, not only for the remote, but also for
> > > inputs, but they have the same PCI subsystem.
> > > 
> > > > ---
> > > >  linux/drivers/media/video/saa7134/saa7134-cards.c |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > --- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-12-11 09:47:47.000000000 +0100
> > > > +++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-09 16:23:17.000000000 +0100
> > > > @@ -7257,6 +7257,7 @@ int saa7134_board_init2(struct saa7134_d
> > > >  		       printk(KERN_INFO "%s: P7131 analog only, using "
> > > >  						       "entry of %s\n",
> > > >  		       dev->name, saa7134_boards[dev->board].name);
> > > > +			dev->has_remote = SAA7134_REMOTE_GPIO;
> > > >  	       }
> > > >  	       break;
> > > >  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> > > > 
> > > > 
> > > > * * * * *
> > > 
> > > Must have been broken at that time, IIRC.
> > 
> > What must have been broken, and when? You are confusing.
> 
> Sorry, I missed that thread until now.
> The above patch was tried previously by Roman.
> 
> For the record, here is a link.
> http://www.spinics.net/lists/vfl/msg38869.html

Thanks for the pointer, this was very helpful. I had missed the fact
that the call to saa7134_input_init1() was before the card number
change. So indeed my patch was insufficient.

Roman's strategy to move saa7134_input_init1() to the late init section
seems good to me. Honestly, I can't think of a good reason to init the
remote control early. I doubt that anything else depends on that.

I'll send an updated patch shortly.

-- 
Jean Delvare
