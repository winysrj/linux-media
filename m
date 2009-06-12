Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:35099 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbZFLWmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 18:42:54 -0400
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
From: hermann pitton <hermann-pitton@arcor.de>
To: Mike Isely <isely@isely.net>
Cc: Andy Walls <awalls@radix.net>, Roger <rogerx@sdf.lonestar.org>,
	Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
References: <1244446830.3797.6.camel@localhost2.local>
	 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
	 <4A311A64.4080008@kernellabs.com>
	 <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>
	 <1244759335.9812.2.camel@localhost2.local>
	 <Pine.LNX.4.64.0906121531100.6470@cnc.isely.net>
	 <1244841123.3264.55.camel@palomino.walls.org>
	 <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:39:30 +0200
Message-Id: <1244846370.3803.44.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 12.06.2009, 16:27 -0500 schrieb Mike Isely:
> Well now I feel like an idiot.  Thanks for pointing that out in my own 
> code :-)
> 
> Still digging through this.
> 
>   -Mike

despite of that and to feed the weasel.

We'll have to look through different drivers, if we can make more use of
potential present device information in the eeproms.

There are always OEMs not following for example the Philips eeprom
layout in all details, most visible on different primary analog/hybrid
tuner type enumeration, and I don't even claim to know the latter in all
details,

and it needs more work on it,

but we have a lot of congruence for details in the 16 bytes including
0x40 and up from it across most manufacturers, including Hauppauge.

According to Hartmut, unfortunately not active currently, even different
LNA types, more and more devices with such do appear, are encoded in the
eeprom, if the OEM follows the plan. I don't know where yet, but might
be worth some time to try to find it out.

I had some hopes that this would also be known for the Hauppauge
eeproms, but seems not.

The most undiscovered configurations seem to be such ones about antenna
inputs and their switching. Again according to Hartmut, and he did not
know exactly what is going on here, some for us and him at this point
unknown checksums are used to derive even that information :(

For what I can see, and I might be of course still wrong, we can also
not determine plain digital tuner types, digital demodulator types of
any kind and the type of possibly present second and third tuners, but
at least their addresses, regularly shared by multiple chips, become
often visible. (some OEMs have only 0xff still for all that)

Cheers,
Hermann

> 
On Fri, 12 Jun 2009, Andy Walls wrote:
> 
> > On Fri, 2009-06-12 at 15:33 -0500, Mike Isely wrote:
> > > I am unable to reproduce the s5h1411 error here.
> > > 
> > > However my HVR-1950 loads the s5h1409 module - NOT s5h1411.ko; I wonder 
> > > if Hauppauge has changed chips on newer devices and so you're running a 
> > > different tuner module.
> > 
> > The digital demodulator driver to use is hardcoded in pvrusb2-devattr.c:
> > 
> > static const struct pvr2_dvb_props pvr2_750xx_dvb_props = {
> >         .frontend_attach = pvr2_s5h1409_attach,
> >         .tuner_attach    = pvr2_tda18271_8295_attach,
> > };
> > 
> > static const struct pvr2_dvb_props pvr2_751xx_dvb_props = {
> >         .frontend_attach = pvr2_s5h1411_attach,
> >         .tuner_attach    = pvr2_tda18271_8295_attach,
> > };
> > ...
> > static const struct pvr2_device_desc pvr2_device_750xx = {
> >                 .description = "WinTV HVR-1950 Model Category 750xx",
> > ...
> >                 .dvb_props = &pvr2_750xx_dvb_props,
> > #endif
> > };
> > ...
> > static const struct pvr2_device_desc pvr2_device_751xx = {
> >                 .description = "WinTV HVR-1950 Model Category 751xx",
> > ...
> >                 .dvb_props = &pvr2_751xx_dvb_props,
> > #endif
> > };
> > 
> > 
> > >   That would explain the different behavior.  
> > > Unfortunately it also means it will be very difficult for me to track 
> > > the problem down here since I don't have that device variant.
> > 
> > If you have more than 1 HVR-1950, maybe one is a 751xx variant.
> > 
> > When I ran into I2C errors often, it was because of PCI bus errors
> > screwing up the bit banging.  Obviously, that's not the case here.
> > 
> > -Andy
> > 
> > >   -Mike
> > 
> > 
> > 
> 

