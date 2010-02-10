Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:51383 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0BJRBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 12:01:42 -0500
Date: Wed, 10 Feb 2010 18:01:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135
 variants
Message-ID: <20100210180140.2649d4e3@hyperion.delvare>
In-Reply-To: <4B687851.3050706@redhat.com>
References: <20100127120211.2d022375@hyperion.delvare>
	<4B630179.3080006@redhat.com>
	<1264812461.16350.90.camel@localhost>
	<20100130115632.03da7e1b@hyperion.delvare>
	<4B687851.3050706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, 02 Feb 2010 17:09:05 -0200, Mauro Carvalho Chehab wrote:
> > From: Jean Delvare <khali@linux-fr.org>
> > Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> > 
> > Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> > Analog (card=146). However, by the time we find out, some
> > card-specific initialization is missed. In particular, the fact that
> > the IR is GPIO-based. Set it when we change the card type, and run
> > saa7134_input_init1().
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Daro <ghost-rider@aster.pl>
> > Cc: Roman Kellner <muzungu@gmx.net>
> > ---
> >  linux/drivers/media/video/saa7134/saa7134-cards.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-30 10:56:50.000000000 +0100
> > +++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-30 11:52:18.000000000 +0100
> > @@ -7299,6 +7299,11 @@ int saa7134_board_init2(struct saa7134_d
> >  		       printk(KERN_INFO "%s: P7131 analog only, using "
> >  						       "entry of %s\n",
> >  		       dev->name, saa7134_boards[dev->board].name);
> > +
> > +			/* IR init has already happened for other cards, so
> > +			 * we have to catch up. */
> > +			dev->has_remote = SAA7134_REMOTE_GPIO;
> > +			saa7134_input_init1(dev);
> >  	       }
> >  	       break;
> >  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> 
> This version of your patch makes sense to me. 
> 
> This logic will only apply for board SAA7134_BOARD_ASUSTeK_P7131_ANALOG, 
> so, provided that someone with this board test it, I'm OK with it.
> 
> Had Roman or Daro already test it?

Not yet, but Daro just volunteered to do so... let's give him/her some
time to proceed.

-- 
Jean Delvare
