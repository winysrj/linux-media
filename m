Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:54188 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765304AbZFLV1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 17:27:38 -0400
Date: Fri, 12 Jun 2009 16:27:39 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@radix.net>
cc: Roger <rogerx@sdf.lonestar.org>,
	Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
In-Reply-To: <1244841123.3264.55.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
References: <1244446830.3797.6.camel@localhost2.local>
 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>  <4A311A64.4080008@kernellabs.com>
  <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>  <1244759335.9812.2.camel@localhost2.local>
  <Pine.LNX.4.64.0906121531100.6470@cnc.isely.net> <1244841123.3264.55.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Well now I feel like an idiot.  Thanks for pointing that out in my own 
code :-)

Still digging through this.

  -Mike


On Fri, 12 Jun 2009, Andy Walls wrote:

> On Fri, 2009-06-12 at 15:33 -0500, Mike Isely wrote:
> > I am unable to reproduce the s5h1411 error here.
> > 
> > However my HVR-1950 loads the s5h1409 module - NOT s5h1411.ko; I wonder 
> > if Hauppauge has changed chips on newer devices and so you're running a 
> > different tuner module.
> 
> The digital demodulator driver to use is hardcoded in pvrusb2-devattr.c:
> 
> static const struct pvr2_dvb_props pvr2_750xx_dvb_props = {
>         .frontend_attach = pvr2_s5h1409_attach,
>         .tuner_attach    = pvr2_tda18271_8295_attach,
> };
> 
> static const struct pvr2_dvb_props pvr2_751xx_dvb_props = {
>         .frontend_attach = pvr2_s5h1411_attach,
>         .tuner_attach    = pvr2_tda18271_8295_attach,
> };
> ...
> static const struct pvr2_device_desc pvr2_device_750xx = {
>                 .description = "WinTV HVR-1950 Model Category 750xx",
> ...
>                 .dvb_props = &pvr2_750xx_dvb_props,
> #endif
> };
> ...
> static const struct pvr2_device_desc pvr2_device_751xx = {
>                 .description = "WinTV HVR-1950 Model Category 751xx",
> ...
>                 .dvb_props = &pvr2_751xx_dvb_props,
> #endif
> };
> 
> 
> >   That would explain the different behavior.  
> > Unfortunately it also means it will be very difficult for me to track 
> > the problem down here since I don't have that device variant.
> 
> If you have more than 1 HVR-1950, maybe one is a 751xx variant.
> 
> When I ran into I2C errors often, it was because of PCI bus errors
> screwing up the bit banging.  Obviously, that's not the case here.
> 
> -Andy
> 
> >   -Mike
> 
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
