Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:46923 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZCGPlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 10:41:16 -0500
Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
From: Alexey Klimov <klimov.linux@gmail.com>
To: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
Cc: "Curran, Dominic" <dcurran@ti.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
In-Reply-To: <5e9665e10903051754i6eea2709l5178083097807242@mail.gmail.com>
References: <5e9665e10903041858j7d2177abjfa1193532553059c@mail.gmail.com>
	 <96DA7A230D3B2F42BA3EF203A7A1B3B5012EAC2043@dlee07.ent.ti.com>
	 <208cbae30903051405p7588b3a9pb17338ec99dc749a@mail.gmail.com>
	 <5e9665e10903051754i6eea2709l5178083097807242@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 07 Mar 2009 18:41:53 +0300
Message-Id: <1236440513.1863.33.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

On Fri, 2009-03-06 at 10:54 +0900, DongSoo(Nathaniel) Kim wrote:
> Hi Alexey,
> 
> On Fri, Mar 6, 2009 at 7:05 AM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> > Hello, all
> >
> > On Thu, Mar 5, 2009 at 7:42 PM, Curran, Dominic <dcurran@ti.com> wrote:
> >>
> >> Hi Kim
> >>
> >>> -----Original Message-----
> >>> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> >>> owner@vger.kernel.org] On Behalf Of DongSoo(Nathaniel) Kim
> >>> Sent: Wednesday, March 04, 2009 8:58 PM
> >>> To: Aguirre Rodriguez, Sergio Alberto
> >>> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
> >>> Tuukka.O Toivonen; Hiroshi DOYU; MiaoStanley; Nagalla, Hari; Hiremath,
> >>> Vaibhav; Lakhani, Amish; Menon, Nishanth
> >>> Subject: Re: [PATCH 4/5] OMAP3430SDP: Add support for Camera Kit v3
> >>>
> >>> Hi Sergio,
> >>>
> >>>
> >>>
> >>> On Wed, Mar 4, 2009 at 5:44 AM, Aguirre Rodriguez, Sergio Alberto
> >>> <saaguirre@ti.com> wrote:
> >>> > +               /* turn on analog power */
> >>> > +               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> >>> > +                               VAUX_2_8_V, TWL4030_VAUX2_DEDICATED);
> >>> > +               twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
> >>> > +                               VAUX_DEV_GRP_P1, TWL4030_VAUX2_DEV_GRP);
> >>> > +
> >>> > +               /* out of standby */
> >>> > +               gpio_set_value(MT9P012_STANDBY_GPIO, 0);
> >>> > +               udelay(1000);
> >>>
> >>> It seems better using msleep rather than udelay for 1000us much. Just
> >>> to be safe :)
> >>> How about you?
> >>>
> >>
> >> Why is msleep safer than udelay ?
> >
> > I have small guess that he is wondering why you are using big delays
> > with help of udelay(). (It's may be obvious but as we know udelay uses
> > cpu loops to make delay and msleep calls to scheduler) So, msleep is
> > more flexible and "softer" but if you need precise time or you can't
> > sleep in code you need udelay. Sometimes using udelay is reasonably
> > required.
> 
> I totally agree with you.
> But besides the "udelay and mdelay accuracy" issue, Sergio's power up
> timing for  MT9P012 seems to delay too much. (not for lens
> controller.)
> I also have experience using MT9P012 sensor with other ISP, but in
> case of mine it took 600 to 800 ms for whole power up sequence.
> But if that delay depends on SDP board and Sergio had no options
> without making delay for that much, then it explains everything.
> So I'm saying if there was no other option than making long delay to
> bring up MT9P012 sensor properly, if I were Sergio I should rather use
> mdelay than udelay.

I agree with you. mdelay is really safer that udelay. 

>From file include/linux/delay.h:

 * Using udelay() for intervals greater than a few milliseconds can
 * risk overflow for high loops_per_jiffy (high bogomips) machines. The
 * mdelay() provides a wrapper to prevent this.  For delays greater
 * than MAX_UDELAY_MS milliseconds, the wrapper is used.  Architecture
 * specific values can be defined in asm-???/delay.h as an override.

So, let's Sergio check and decide what he needed! :)

> Cheers,
> 
> Nate

-- 
Best regards, Klimov Alexey

