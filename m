Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53001 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1G2KOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:14:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] mt9p031: Aptina (Micron) MT9P031 5MP sensor driver
Date: Fri, 29 Jul 2011 12:14:39 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	shotty317@gmail.com
References: <CACKLOr1veNZ_6E3V_m1Tf+mxxUAKiRKDbboW-fMbRGUrLns_XA@mail.gmail.com> <201107271951.37601.laurent.pinchart@ideasonboard.com> <CACKLOr1iDXcftKqw14i4K6aoxWaR7iHSv0VHbSFEJcar1L62ug@mail.gmail.com>
In-Reply-To: <CACKLOr1iDXcftKqw14i4K6aoxWaR7iHSv0VHbSFEJcar1L62ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107291214.40779.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 29 July 2011 11:10:48 javier Martin wrote:
> Hi Laurent,
> I've been reviewing and testing your patch as promised.
> 
> On 27 July 2011 19:51, Laurent Pinchart
> 
> <laurent.pinchart@ideasonboard.com> wrote:
> >> > +static int mt9p031_pll_enable(struct mt9p031 *mt9p031)
> >> > +{
> >> > +   struct i2c_client *client = v4l2_get_subdevdata(&mt9p031->subdev);
> >> > +   int ret;
> >> > +
> >> > +   ret = mt9p031_write(client, MT9P031_PLL_CONTROL,
> >> > +                       MT9P031_PLL_CONTROL_PWRON);
> >> > +   if (ret < 0)
> >> > +           return ret;
> >> > +
> >> > +   ret = mt9p031_write(client, MT9P031_PLL_CONFIG_1,
> >> > +                       (mt9p031->m << 8) | (mt9p031->n - 1));
> >> > +   if (ret < 0)
> >> > +           return ret;
> >> > +
> >> > +   ret = mt9p031_write(client, MT9P031_PLL_CONFIG_2, mt9p031->p1 -
> >> > 1); +   if (ret < 0)
> >> > +           return ret;
> >> > +
> >> > +   mdelay(1);
> >> 
> >> mdelay() is a busyloop. Either msleep(), if the timing isn't critical,
> >> and if it is, then usleep_range().
> > 
> > Timing isn't critical, but that's a stream-on delay, so I'll use
> > usleep_range().
> > 
> >> > +   ret = mt9p031_write(client, MT9P031_PLL_CONTROL,
> >> > +                       MT9P031_PLL_CONTROL_PWRON |
> >> > +                       MT9P031_PLL_CONTROL_USEPLL);
> >> > +   mdelay(1);
> > 
> > Javier, is this second mdelay() needed ?
> 
> No, sorry, I included it because I was having problems with PLLs and
> wanted to be very cautious. You can safely remove it. It is not
> specified in the datasheet and I've just tested it myself.

OK, I'll remove it and resubmit.

> Apart from the minor issues mentioned by Sakari, I think dynamic
> calculation of PLL dividers should be postponed for a next version
> thus not delaying this one to enter mainline.

I agree (unless I find time to work on this before v3.2 :-)).

> However I'm having problems for testing your version with linux-3.0
> and my old test "yavta + mplayer":
> 
> On my PC:
> nc -l 3000 | ./mplayer - -demuxer rawvideo -rawvideo
> w=320:h=240:format=ba81:size=76800 -vf ba81 -vo x11
> 
> On my Beagleboard:
> ./media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
> 
> ./media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP
> CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
> Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
> Format set: SGRBG12 370x243

You're trying to configure the sensor for 320x240. The sensor native size is 
2592x1944. Maximum horizontal and vertical skipping values are 7 and 8 
respectively according to the datasheet. The smallest achieavable resolution 
(without cropping) is thus 370x243. That's why the driver returns 370x243.

> Setting up format SGRBG12 370x243 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG12 370x243
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
> Format set: SGRBG8 320x240
> Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
> Format set: SGRBG8 320x240

You then need to set the same format on the CCDC input and output. The CCDC 
will restrict this further to 368x243, which is the format you will need to 
give to yavta.

> ./yavta --stdout -f SGRBG8 -s 320x240 -n 4 --capture=100 --skip 3 -F
> `./media-ctl -e "OMAP3 ISP CCDC output"` | nc 192.168.0.42 3000
> Device /dev/video2 opened: OMAP3 ISP CCDC output (media).
> Video format set: width: 320 height: 240 buffer size: 76800
> Video format: GRBG (47425247) 320x240
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x40082000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x400a8000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x4016a000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x402be000.
> Unable to start streaming: 32.
> 
> What are you using for testing?

media-ctl and yavta.

> By the way, this is my last day in the office till August the 14th.
> 
> Furthermore, I've got no intention to be the maintainer of the driver,
> since probably the main contributor to the patch was Guennadi.
> However, as we'll be using this driver for a project that will last
> for a year, count on me for testing, reviewing patches, etc... Because
> out interest on this patch going into mainline is high.

OK. I'll try to maintain the driver then, and I'll contact you if I need 
testers/reviewers :-)

-- 
Regards,

Laurent Pinchart
