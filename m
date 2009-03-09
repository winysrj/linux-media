Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38145 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZCIVXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 17:23:46 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Alexey Klimov <klimov.linux@gmail.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
CC: "Curran, Dominic" <dcurran@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Date: Mon, 9 Mar 2009 16:23:32 -0500
Subject: RE: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
Message-ID: <A24693684029E5489D1D202277BE89442E40F864@dlee02.ent.ti.com>
In-Reply-To: <1236440513.1863.33.camel@tux.localhost>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> -----Original Message-----
> From: Alexey Klimov [mailto:klimov.linux@gmail.com]
> Sent: Saturday, March 07, 2009 9:42 AM
> To: DongSoo(Nathaniel) Kim
> Cc: Curran, Dominic; Aguirre Rodriguez, Sergio Alberto; linux-
> media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus; Tuukka.O
> Toivonen; Hiroshi DOYU; MiaoStanley; Nagalla, Hari; Hiremath, Vaibhav;
> Lakhani, Amish; Menon, Nishanth
> Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
> 
> Hello, all
> 
> On Fri, 2009-03-06 at 10:54 +0900, DongSoo(Nathaniel) Kim wrote:
> > Hi Alexey,
> >
> > On Fri, Mar 6, 2009 at 7:05 AM, Alexey Klimov <klimov.linux@gmail.com>
> wrote:
> > > Hello, all
> > >
> > > On Thu, Mar 5, 2009 at 7:42 PM, Curran, Dominic <dcurran@ti.com>
> wrote:
> > >>
> > >> Hi Kim
> > >>
> > >>> -----Original Message-----
> > >>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> > >>> owner@vger.kernel.org] On Behalf Of DongSoo(Nathaniel) Kim
> > >>> Sent: Wednesday, March 04, 2009 8:58 PM
> > >>> To: Aguirre Rodriguez, Sergio Alberto
> > >>> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari
> Ailus;
> > >>> Tuukka.O Toivonen; Hiroshi DOYU; MiaoStanley; Nagalla, Hari;
> Hiremath,
> > >>> Vaibhav; Lakhani, Amish; Menon, Nishanth
> > >>> Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
> > >>>
> > >>> Hi Sergio,
> > >>>
> > >>>
> > >>>
> > >>> On Wed, Mar 4, 2009 at 5:44 AM, Aguirre Rodriguez, Sergio Alberto
> > >>> <saaguirre@ti.com> wrote:
> > >>> > +               /* turn on analog power */
> > >>> > +               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> > >>> > +                               VAUX_2_8_V,
> TWL4030_VAUX2_DEDICATED);
> > >>> > +               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> > >>> > +                               VAUX_DEV_GRP_P1,
> TWL4030_VAUX2_DEV_GRP);
> > >>> > +
> > >>> > +               /* out of standby */
> > >>> > +               gpio_set_value(MT9P012_STANDBY_GPIO, 0);
> > >>> > +               udelay(1000);
> > >>>
> > >>> It seems better using msleep rather than udelay for 1000us much.
> Just
> > >>> to be safe :)
> > >>> How about you?
> > >>>
> > >>
> > >> Why is msleep safer than udelay ?
> > >
> > > I have small guess that he is wondering why you are using big delays
> > > with help of udelay(). (It's may be obvious but as we know udelay uses
> > > cpu loops to make delay and msleep calls to scheduler) So, msleep is
> > > more flexible and "softer" but if you need precise time or you can't
> > > sleep in code you need udelay. Sometimes using udelay is reasonably
> > > required.
> >
> > I totally agree with you.
> > But besides the "udelay and mdelay accuracy" issue, Sergio's power up
> > timing for  MT9P012 seems to delay too much. (not for lens
> > controller.)
> > I also have experience using MT9P012 sensor with other ISP, but in
> > case of mine it took 600 to 800 ms for whole power up sequence.
> > But if that delay depends on SDP board and Sergio had no options
> > without making delay for that much, then it explains everything.
> > So I'm saying if there was no other option than making long delay to
> > bring up MT9P012 sensor properly, if I were Sergio I should rather use
> > mdelay than udelay.
> 
> I agree with you. mdelay is really safer that udelay.

Sorry for not participating much in this thread, I have been busy fixing other comments.

This delay setting was set before I ever touched this drivers by other omap3 Linux camera ex-team member here in TI. I suspect they were set to the minimum working level in SDP already, but I haven't honestly tried to move them. I guess it's a good time to do so. :)

I'll fix some other things first, and put this on my plate to check before reposting next version of drivers.

I really appreciate your feedback on this.

Regards,
Sergio

> 
> >From file include/linux/delay.h:
> 
>  * Using udelay() for intervals greater than a few milliseconds can
>  * risk overflow for high loops_per_jiffy (high bogomips) machines. The
>  * mdelay() provides a wrapper to prevent this.  For delays greater
>  * than MAX_UDELAY_MS milliseconds, the wrapper is used.  Architecture
>  * specific values can be defined in asm-???/delay.h as an override.
> 
> So, let's Sergio check and decide what he needed! :)
> 
> > Cheers,
> >
> > Nate
> 
> --
> Best regards, Klimov Alexey
> 

