Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63473 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1D0Ksx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 06:48:53 -0400
Received: by qyk7 with SMTP id 7so1678250qyk.19
        for <linux-media@vger.kernel.org>; Wed, 27 Apr 2011 03:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104262122.15126.laurent.pinchart@ideasonboard.com>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com>
	<201104211129.40889.laurent.pinchart@ideasonboard.com>
	<BANLkTim=xa+e90Y8UF=SwjFDQ=K1sAKk-Q@mail.gmail.com>
	<201104262122.15126.laurent.pinchart@ideasonboard.com>
Date: Wed, 27 Apr 2011 12:48:51 +0200
Message-ID: <BANLkTim9gwZUx+Y-ji72_Jv6mmCUiEDc-Q@mail.gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	David Cohen <dacohen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/4/26 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Tuesday 26 April 2011 17:39:41 Bastian Hecht wrote:
>> 2011/4/21 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Tuesday 19 April 2011 09:31:05 Sakari Ailus wrote:
>> >> Laurent Pinchart wrote:
>> >> ...
>> >>
>> >> > That's the ideal situation: sensors should not produce any data (or
>> >> > rather any transition on the VS/HS signals) when they're supposed to
>> >> > be stopped. Unfortunately that's not always easy, as some dumb
>> >> > sensors (or sensor-like hardware) can't be stopped. The ISP driver
>> >> > should be able to cope with that in a way that doesn't kill the
>> >> > system completely.
>> >> >
>> >> > I've noticed the same issue with a Caspa camera module and an
>> >> > OMAP3503-based Gumstix. I'll try to come up with a good fix.
>> >>
>> >> Hi Laurent, others,
>> >>
>> >> Do you think the cause for this is that the system is jammed in handling
>> >> HS_VS interrupts triggered for every HS?
>> >
>> > That was my initial guess, yes.
>> >
>> >> A quick fix for this could be just choosing either VS configuration when
>> >> configuring the CCDC. Alternatively, HS_VS interrupts could be just
>> >> disabled until omap3isp_configure_interface().
>> >>
>> >> But as the sensor is sending images all the time, proper VS
>> >> configuration would be needed, or the counting of lines in the CCDC
>> >> (VD* interrupts) is affected as well. The VD0 interrupt, which is used
>> >> to trigger an interrupt near the end of the frame, may be triggered one
>> >> line too early on the first frame, or too late. But this is up to a
>> >> configuration. I don't think it's a real issue to trigger it one line
>> >> too early.
>> >>
>> >> Anything else?
>>
>> Hello Laurent,
>>
>> > I've tried delaying the HS_VS interrupt enable to the CCDC configuration
>> > function, after configuring the bridge (and thus the HS/VS interrupt
>> > source selection). To my surprise it didn't fix the problem, I still get
>> > tons of HS_VS interrupts (100000 in about 2.6 seconds) that kill the
>> > system.
>> >
>> > I'll need to hook a scope to the HS and VS signals.
>>
>> have you worked on this problem? Today in my setup I took a longer cable and
>> ran again into the hs/vs interrupt storm (it still works with a short
>> cable).
>> I can tackle this issue too, but to avoid double work I wanted to ask if you
>> worked out something in the meantime.


> In my case the issue was caused by a combination of two hardware design
> mistakes. The first one was to use a TXB0801 chip to translate the 3.3V sensor
> levels to the 1.8V OMAP levels. The TXB0801 4kΩ output impedance, combined
> with the OMAP3 100µA pull-ups on the HS and VS signals, produces a ~400mV
> voltage for low logic levels.
>
> Then, the XCLKA signal is next to the VS signal on the cable connecting the
> camera module to the OMAP board. When XCLKA is turned on, cross-talk produces
> a 400mV peak-to-peak noise on the VS signal.
>
> The combination of those two effects create a noisy VS signal that crosses the
> OMAP3 input level detection gap at high frequency, leading to an interrupt
> storm. The workaround is to disable the pull-ups on the HS and VS signals, the
> solution is to redesign the hardware to replace the level translators and
> reorganize signals on the camera module cable.

Hi Laurent,

> Is your situation any similar ?

The long data line (~35cm now at 24MHz) certainly can have an impact
but I haven't measured any crosstalk so far. But I'm on another trail
now. I found out that on my board the interrupt line is shared with
 24:          0        INTC  omap-iommu.0

Is the following scenario possible?

1. The omap-iommu isr is registered
2. The isp gets set up (it enables interrupts and disables them again
at the end of the probe function)
3. Later I activate the xclk from within my driver
  3a. isp_set_xclk() gets the lock omap3isp_get(isp) and so
enable_interrupts() is called
  3b. The new xclk on my chip makes my hardware create a hs/vs int
(either crosstalk, another hardware bug like yours, or simply my chip
sends a spurious interrupt for any reason)
  3c.  isp_set_xclk() puts the lock omap3isp_put(isp) and so
disable_interrupts() is called

Can there exist a race condition between the omap3isp raising the
interrupt pin before 3c or after 3c?

If after 3c the omap-iommu isr loops forever as the omap3isp int flag
is never cleared.

I keep debbuging and trying to find further clues.

Best regards,

Bastian


> --
> Regards,
>
> Laurent Pinchart
>
