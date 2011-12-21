Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54701 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1LUPYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 10:24:48 -0500
Received: by wibhm6 with SMTP id hm6so1991887wib.19
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 07:24:47 -0800 (PST)
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] Fixed detection of EMP202 audio chip. Some versions have an id of 0x83847650 instead of 0xffffffff.
Date: Wed, 21 Dec 2011 15:24:43 +0000
Message-ID: <3120440.01odmNlqNJ@kubuntu>
In-Reply-To: <4EF1E519.1010600@redhat.com>
References: <3535794.dt3qgLM7n9@kubuntu> <4EF1E519.1010600@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 Dec 2011 11:54:33 you wrote:
> On 20-12-2011 19:45, Gareth Williams wrote:
> > Signed-off-by: Gareth Williams <gareth@garethwilliams.me.uk>
> > 
> > Honestech Vidbox NW03 has a EMP202 audio chip with a different Vendor
> > ID.
> > 
> > Apparently, it is the same with the Gadmei ITV380:
> > http://linuxtv.org/wiki/index.php/Gadmei_USB_TVBox_UTV380
> > 
> > ---
> > 
> >  linux/drivers/media/video/em28xx/em28xx-core.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/linux/drivers/media/video/em28xx/em28xx-core.c
> > b/linux/drivers/media/video/em28xx/em28xx-core.c index 804a4ab..2982a06
> > 100644
> > --- a/linux/drivers/media/video/em28xx/em28xx-core.c
> > +++ b/linux/drivers/media/video/em28xx/em28xx-core.c
> > @@ -568,7 +568,7 @@ int em28xx_audio_setup(struct em28xx *dev)
> > 
> >  	em28xx_warn("AC97 features = 0x%04x\n", feat);
> >  	
> >  	/* Try to identify what audio processor we have */
> > 
> > -	if ((vid == 0xffffffff) && (feat == 0x6a90))
> > +	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))
> 
> Are you sure you don't have, instead a STAC9750? 0x83647650 is the code
> for this chip. Did you open your device to be sure it is really an em202?
> 
> Vendors are free to put whatever AC97 chip they want. Each of them have
> their own differences (different sample rate, different volume controls,
> etc).
> 
> While miss-identifying it may work for your usecase, it will fail for
> other usecases. The good news is that, in general, the datasheets for
> AC97 mixers are generally easy to find on Google. Most vendors release them
> publicly.
> 
> Regards,
> Mauro

I opened the box in order to check the chip.

I've opened it again now and can confirm that the chip has the following 
markings:-

eMPIA
TECHNOLOGY
EMP202
T10189
1110

I've read the EMP202 datasheet and also noticed that it should have 11111111 
for the vendor id which is what the driver was originally looking for.

According to the LinuxTV Wiki entry, the Gadmei ITV380 also has the same issue 
in that it also has an EMP202 inside and a vendor Id of the STAC9750.

Regards,

Gareth
