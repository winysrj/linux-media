Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:41689 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbZA1D2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 22:28:47 -0500
Subject: Re: KWorld ATSC 115 all static
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: CityK <cityk@rogers.com>, Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <20090128002350.3a989a3c@caramujo.chehab.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	 <200901182241.10047.hverkuil@xs4all.nl> <4973BD03.4060702@rogers.com>
	 <200901190853.19327.hverkuil@xs4all.nl> <497CAB2F.7080700@rogers.com>
	 <Pine.LNX.4.58.0901251322320.17971@shell2.speakeasy.net>
	 <497CF735.9070004@rogers.com> <20090128002350.3a989a3c@caramujo.chehab.org>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 04:29:19 +0100
Message-Id: <1233113359.2711.12.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 28.01.2009, 00:23 -0200 schrieb Mauro Carvalho Chehab:
> On Sun, 25 Jan 2009 18:35:17 -0500
> CityK <cityk@rogers.com> wrote:
> 
> > hermann pitton wrote:
> > > Am Sonntag, den 25.01.2009, 13:49 -0800 schrieb Trent Piepho:
> > >   
> > >> On Sun, 25 Jan 2009, CityK wrote:
> > >>     
> > >>> Hans Verkuil wrote:
> > >>>
> > >>> this still begs Han's question: "how do you manage to make analog TV
> > >>> work if the tda9887 isn't found? That's rather peculiar." I don't have
> > >>> an answer for that. The tuner-simple module, however, seems to be able to drive/provide that functionality sufficiently enough. 
> > >>>
> > >> The tda9887 is a simple device with just three registers.  If they are set
> > >> to the right value when the driver loads, which wouldn't be unexpected,
> > >> then it isn't necessary to actually do anything to the chip.  If you had a
> > >> multistandard tuner (and had access to broadcasts in multiple standards!)
> > >> then I expect switching standards wouldn't work without the tda9887 driver.
> > >> Verifying both TV and radio tuning works is probably the most realistic way
> > >> to check.
> > >>     
> > >
> > > For radio you need a tda9887 and working i2c for what i can know.
> > >
> > > Also after a cold boot the tda988x is not in a usable state for any tv
> > > standard yet, it needs to be set by i2c first.
> > >
> > > But for NTSC, and only NTSC, one pin can be strapped, IIRC, and then it
> > > works without any i2c programming needed. Guess it is a tda9885 here.
> > >
> > >   
> > 
> > Looks like that this is the case, as described by Trent, that is
> > occurring. Herman, is there any difference between the tda9885 and
> > tda887, as I'm pretty sure this is the tda9887 package outlined on page
> > 52 of the tda9887 datasheet.
> > 
> > Alas, as being exposed to just NTSC broadcasts, not able to test on the
> > multistandard ;)
> > 
> > As for the FM radio, I know that some have mentioned the possibility for
> > that with this device, but I don't think anyone ever has succeeded (not
> > surprising given the i2c situation) and so the assumption was made,
> > rightly or wrongly, that it is not present. I would be amused if FM
> > radio support could be realised for the device.
> > 
> > >>>> saa7133[1]: i2c xfer: < c2 30 90 >
> > >>>> saa7134[3]: i2c xfer: < c2 >
> > >>>> saa7134[3]: i2c xfer: < c2 0b dc 9c 60 >
> > >>>> saa7134[3]: i2c xfer: < c2 0b dc 86 54 >
> > >>>>
> > >>>> Exactly here, when the buffers are sent the second time the tda9887
> > >>>> becomes the first time visible on the bus. According to Hartmut the
> > >>>> modification of buffer[3] from 0x60 to 0x54 is that hidden switch,
> > >>>> IIRC.
> > >>>>
> > >>>>         
> > >>> I believe Mauro is correct in regards to the tda9887 in that, within the
> > >>> Philips TUV1236D NIM, it is behind the Nxt2004's i2c gate.  After
> > >>> re-reading what Michael mentioned previously:
> > >>>       
> > >> Address 0xc2 is the PLL, not the NXT2004.  Why would the PLL control an I2C
> > >> gate on the nxt2004?  I think what I said before about a gpio line on the
> > >> PLL being used to hold the analog demod in reset when not in use is more
> > >> likely to be correct.
> 
> I've seen i2c switches on a few different places:
> 	on bridge driver gpio's;
> 	on demod's gpio's;
> 	on tda9887 gpio's;
> 	on tuner/PLL gpio's.
> 
> In the case of tuner/PLL gpio's, you'll see some i2c switch magic inside tuner-core, like this one:
>         case TUNER_PHILIPS_FMD1216ME_MK3:
>                 buffer[0] = 0x0b;
>                 buffer[1] = 0xdc;
>                 buffer[2] = 0x9c;
>                 buffer[3] = 0x60;
>                 i2c_master_send(c, buffer, 4);
>                 mdelay(1);
>                 buffer[2] = 0x86;
>                 buffer[3] = 0x54;
>                 i2c_master_send(c, buffer, 4);
> 
> I'm not sure what would be the better way to address all those kind of i2c
> switches. Maybe we should add a field at device struct specifying what i2c
> device contains the i2c bridge, in order to initialize it first.
> 

The first i2c bus master should be always first.
On PCI this will be the bridge and nothing else.

I hate to say it, but it was a PITA to argue against the "frontend"
stuff, which until today has no realistic concept for that and confuses
a lot on that side.

To see high tones on every smallest intention to do something better
about it, made it the most frustrating stuff I have seen so far.

Cheers,
Hermann


