Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:47218 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab0AIXcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2010 18:32:20 -0500
Subject: Re: IR device at I2C address 0x7a
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Daro <ghost-rider@aster.pl>, LMML <linux-media@vger.kernel.org>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <20100109171457.77439f12@hyperion.delvare>
References: <4B324EF0.7090606@aster.pl>
	 <20100106153909.6bce3183@hyperion.delvare> <4B44CF62.5060405@aster.pl>
	 <20100106194059.061636d3@hyperion.delvare> <4B44E026.3060906@aster.pl>
	 <20100106212140.11b02d0f@hyperion.delvare> <4B4871C4.10401@aster.pl>
	 <20100109171457.77439f12@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 10 Jan 2010 00:18:46 +0100
Message-Id: <1263079126.3870.65.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 09.01.2010, 17:14 +0100 schrieb Jean Delvare:
> On Sat, 09 Jan 2010 13:08:36 +0100, Daro wrote:
> > W dniu 06.01.2010 21:21, Jean Delvare pisze:
> > > On Wed, 06 Jan 2010 18:58:58 +0100, Daro wrote:
> > >> It is not the error message itself that bothers me but the fact that IR
> > >> remote control device is not detected and I cannot use it (I checked it
> > >> on Windows and it's working). After finding this thread I thought it
> > >> could have had something to do with this error mesage.
> > >> Is there something that can be done to get my IR remote control working?
> > > You could try loading the saa7134 driver with option card=146 and see
> > > if it helps.
> >
> > It works!
> > 
> > [   15.477875] input: saa7134 IR (ASUSTeK P7131 Analo as 
> > /devices/pci0000:00/0000:00:1e.0/0000:05:00.0/input/input8
> > 
> > Thank you very much fo your help.
> 
> Then I would suggest the following patch:
> 
> * * * * *
> 
> From: Jean Delvare <khali@linux-fr.org>
> Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> 
> Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> Analog (card=146). However, by the time we find out, some
> card-specific initialization is missed. In particular, the fact that
> the IR is GPIO-based. Set it when we change the card type.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Tested-by: Daro <ghost-rider@aster.pl>

just to note it, the ASUS TV-FM 7135 with USB remote is different to the
Asus My Cinema P7134 Analog only, not only for the remote, but also for
inputs, but they have the same PCI subsystem.

> ---
>  linux/drivers/media/video/saa7134/saa7134-cards.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-12-11 09:47:47.000000000 +0100
> +++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c	2010-01-09 16:23:17.000000000 +0100
> @@ -7257,6 +7257,7 @@ int saa7134_board_init2(struct saa7134_d
>  		       printk(KERN_INFO "%s: P7131 analog only, using "
>  						       "entry of %s\n",
>  		       dev->name, saa7134_boards[dev->board].name);
> +			dev->has_remote = SAA7134_REMOTE_GPIO;
>  	       }
>  	       break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
> 
> 
> * * * * *

Must have been broken at that time, IIRC.

Only moving saa7134_input_init1(dev) to static int saa7134_hwinit2
in saa7134-core.c did help, AFAIK, but I might be wrong.

> > I have another question regarding this driver:
> > 
> > [   21.340316] saa7133[0]: dsp access error
> > [   21.340320] saa7133[0]: dsp access error
> > 
> > Do those messages imply something wrong? Can they have something do do 
> > with the fact I cannot get the sound out of tvtime application directly 
> > and have to use "arecord | aplay" workaround which causes undesirable delay?
> 
> Yes, the message is certainly related to your sound problem. Maybe
> support for your card is incomplete. But I can't help with this, sorry.

That is nice ice to slide on, but from all others with that card
previously not reported so far.

Anyway, it should have also analog audio out, the two pins in the middle
of the white 4pin connector on the PCB are ground. To know that can
avoid troubles using older CD-ROM audio cables and get only one of the
stereo channels.

Cheers,
Hermann




Hermann


