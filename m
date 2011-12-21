Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42771 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1LUV5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 16:57:49 -0500
Received: by wgbdr13 with SMTP id dr13so14902202wgb.1
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 13:57:47 -0800 (PST)
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] Fixed detection of EMP202 audio chip. Some versions have an id of 0x83847650 instead of 0xffffffff.
Date: Wed, 21 Dec 2011 21:57:44 +0000
Message-ID: <2763398.KLPLWmmhlV@kubuntu>
In-Reply-To: <3120440.01odmNlqNJ@kubuntu>
References: <3535794.dt3qgLM7n9@kubuntu> <4EF1E519.1010600@redhat.com> <3120440.01odmNlqNJ@kubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 Dec 2011 15:24:43 you wrote:
> On Wednesday 21 Dec 2011 11:54:33 you wrote:
> > On 20-12-2011 19:45, Gareth Williams wrote:
> > > Signed-off-by: Gareth Williams <gareth@garethwilliams.me.uk>
> > > 
> > > Honestech Vidbox NW03 has a EMP202 audio chip with a different
> > > Vendor
> > > ID.
> > > 
> > > Apparently, it is the same with the Gadmei ITV380:
> > > http://linuxtv.org/wiki/index.php/Gadmei_USB_TVBox_UTV380
> > > 
> > > ---
> > > 
> > >  linux/drivers/media/video/em28xx/em28xx-core.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/linux/drivers/media/video/em28xx/em28xx-core.c
> > > b/linux/drivers/media/video/em28xx/em28xx-core.c index
> > > 804a4ab..2982a06
> > > 100644
> > > --- a/linux/drivers/media/video/em28xx/em28xx-core.c
> > > +++ b/linux/drivers/media/video/em28xx/em28xx-core.c
> > > @@ -568,7 +568,7 @@ int em28xx_audio_setup(struct em28xx *dev)
> > > 
> > >  	em28xx_warn("AC97 features = 0x%04x\n", feat);
> > >  	
> > >  	/* Try to identify what audio processor we have */
> > > 
> > > -	if ((vid == 0xffffffff) && (feat == 0x6a90))
> > > +	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat ==
> > > 0x6a90))
> > 
> > Are you sure you don't have, instead a STAC9750? 0x83647650 is the code
> > for this chip. Did you open your device to be sure it is really an
> > em202?
> > 
> > Vendors are free to put whatever AC97 chip they want. Each of them have
> > their own differences (different sample rate, different volume controls,
> > etc).
> > 
> > While miss-identifying it may work for your usecase, it will fail for
> > other usecases. The good news is that, in general, the datasheets for
> > AC97 mixers are generally easy to find on Google. Most vendors release
> > them publicly.
> > 
> > Regards,
> > Mauro
> 
> I opened the box in order to check the chip.
> 
> I've opened it again now and can confirm that the chip has the following
> markings:-
> 
> eMPIA
> TECHNOLOGY
> EMP202
> T10189
> 1110
> 
> I've read the EMP202 datasheet and also noticed that it should have 11111111
> for the vendor id which is what the driver was originally looking for.
> 
> According to the LinuxTV Wiki entry, the Gadmei ITV380 also has the same
> issue in that it also has an EMP202 inside and a vendor Id of the STAC9750.
> 
> Regards,
> 
> Gareth

Appologies for double-posting!

I've looked through the datasheets for both devices and the STAC9750 returns a 
0x6990 when reading the RESET register (0x00) whereas the EMP202 returns 
0x6a90.  The driver checks for 0x6a90 in order to decide whether the audio 
chip is an EMP202 therefore there should be no issues with the identical 
Vendor IDs.

Regards,

Gareth
