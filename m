Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46454 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751530Ab2IVNZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 09:25:21 -0400
Date: Sat, 22 Sep 2012 16:25:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Jeong, Daniel" <Daniel.Jeong@ti.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	gshark <gshark.jeong@gmail.com>,
	"linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: led flash driver for lm3554/lm3556
Message-ID: <20120922132515.GE12025@valkosipuli.retiisi.org.uk>
References: <1347963452.13371.15.camel@smile>
 <505A74A6.2070805@gmail.com>
 <505B71D3.5090806@iki.fi>
 <505C3E82.6020805@gmail.com>
 <1348224915.13371.63.camel@smile>
 <20120921120600.GC12025@valkosipuli.retiisi.org.uk>
 <F0866C1C5ECEAF4CB380B619BD733BEA41F08E3C@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F0866C1C5ECEAF4CB380B619BD733BEA41F08E3C@DQHE02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel and others,

On Fri, Sep 21, 2012 at 03:29:18PM +0000, Jeong, Daniel wrote:
> Hi Andy and Sakari. 
> 
> >On Fri, Sep 21, 2012 at 01:55:15PM +0300, Andy Shevchenko wrote:
> >> On Fri, 2012-09-21 at 19:16 +0900, gshark wrote:
> >> 
> >> [cut previous stories]
> >> 
> >> > My development enviroments are Unbuntu and Android on Exynos and 
> >> > OMAP4 Processor.
> >> > There is a function "Assistive Light" in the Android mobile phone 
> >> > and it turns on/off the Torch regardless Camera. It is controlled by SW.
> >> > And the indicator function in LM3554/6 can be controlled by SW. One 
> >> > of our customers controls the indicator using SW.
> >> Fortunately our driver is dedicated for Android as well.
> >> 
> >> > I didn't know you did create the as3645a driver.
> >> > But TI has similar products such as LM3554, 3555, 3556, 3559.. I 
> >> > think we don't need to create drivers for each product.
> >> > Now I'm doing put these products into one driver file. (lm355x.c )
> >> Actually accordingly to the specs lm3554 and lm3555 is quite different 
> >> by hw configuration. It's better to keep them separate from my p.o.v.
> >
> >I agree with that. These chis are so simple it's easy to complicate the matter by trying to fit everything into the same driver. It'd be different if some of them would be just super or subsets of another chip.
> 
> Is it really quite different? 
>                        Input pins
>         --------------------------------------- 
>          SCL/SDA  STROBE   TORCH    HWEN    TX  
> ------------------------------------------------  
> LM3554       O       O       O       O       O  
> LM3555       O       O       O       O       X  
> LM3556       O       O       O       O       O  
> LM3559       O       O       O       O       O  
> 
>               Output pins
>           ---------------------   
>           LED(1) LED2  LEDI/NTC
> -------------------------------- 
> LM3554      O      O      O
> LM3555      O      X      X
> LM3556      O      X      X
> LM3559      O      O      O
> 
> 
>            Operation Mode(ENABLE) bits size
> -------------------------------- 
> LM3554      2bits
> LM3555      2bits
> LM3556      2bits
> LM3559      2bits
> 
>            Torch Current Control bits size
> -------------------------------- 
> LM3554      3bits
> LM3555      3bits
> LM3556      3bits
> LM3559      3bits
> 
>            Flash Current Control bits size
> -------------------------------- 
> LM3554      4bits
> LM3555      4bits
> LM3556      4bits
> LM3559      4bits
> 
> 
>            Indicator Current Control bits size
> -------------------------------- 
> LM3554      2bits
> LM3555      2bits
> LM3556      2bits
> LM3559      3bits
> 
> I'm sure that only register numbers are different and it can be handled in one driver.  

If it's only that, then why not, but often the details have so many
differences it's less work to just write a new driver instead of cluttering
up the old one. That applies IMHO to e.g. LM3554 and LM3555.

> >> > [cut previous stories]
> >> > I agree with you that we shouldn't have multiple drivers for the same hardware.
> >> > So I think the best way to avoid duplicated work is to change current lm355x file to like below.....
> >> > kernel
> >> > ../drivers/mfd/lm355x-core.c                //  control  i2c-accss etc..
> >> >           /media/video/lm355x-flash.c   //  control flash and torch.
> >> >           /leds/leds-lm355x.c                // control indicator 
> >> > and torch.
> >> It doesn't require to split them. If you want to provide led framework 
> >> for that chip we could do the generic glue driver. And I would like to 
> >> do it.
> >> 
> >> P.S. Any objections to go to the public mailing list with this 
> >> discussion? I mean linux-media@, for example.
> >
> >I'm all for that. What's the relevant list for the LED framework?
> 
> >  On Fri, 2012-09-21 at 15:06 +0300, Sakari Ailus wrote: 
> >> > P.S. Any objections to go to the public mailing list with this 
> >> > discussion? I mean linux-media@, for example.
> >> 
> >> I'm all for that. What's the relevant list for the LED framework?
> >linux-leds@vger.kernel.org, surprise, surprise!
> 
> These chips are not only for Camera but also for Audio amp etc. You guys
> are focusing Camera but Audio can use this chip, actually some
> manufacturer's audio module uses this indicator. IMO these LED driver

I can hardly see use for a LED flash controller in the ALSA API.

V4L2 flash API supports flash controllers, including those with torch
and indicator functionality. It's generic in the sense that it does not have
hard-wired connections to cameras for instance.

<URL:http://hverkuil.home.xs4all.nl/spec/media.html#flash-controls>

> chips have multi-function, Flash, Torch and Indicator. Up to now
> Flash(Strobe) function has been dedicated to Camera but Torch and
> Indicator functions are used by the others, Audio etc. I think it is
> relevant to LED framework and it should split into three part. And lm3555
> don't need to merged with lm355x since there is as3645a driver.

Nothing prevents using the V4L2 flash API outside the context of cameras,
it's fully generic in that sense in terms of type of hardware it's intended
for, including the above LM chips. You can just open the flash device node
and use it. No cameras involved.

However, I do reckon that the LED class is an established API used to
control LEDs elsewhere, and there's some overlap between the two APIs. For
instance, the flash strobe, timeout and precise current control is only
handled by the V4L2 flash API whereas it currently does not recognise RGB
LEDs, and quite possibly never will.

The V4L2 flash API is also not limited to LEDs.

I think Andy is on the right track in writing a generic LED driver using the
V4L2 flash API, so that LED devices implementing the V4L2 flash API would
readily get LED class support, too.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
