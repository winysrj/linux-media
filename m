Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43408 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab1DZTWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 15:22:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
Date: Tue, 26 Apr 2011 21:22:14 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	David Cohen <dacohen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com> <201104211129.40889.laurent.pinchart@ideasonboard.com> <BANLkTim=xa+e90Y8UF=SwjFDQ=K1sAKk-Q@mail.gmail.com>
In-Reply-To: <BANLkTim=xa+e90Y8UF=SwjFDQ=K1sAKk-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104262122.15126.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Tuesday 26 April 2011 17:39:41 Bastian Hecht wrote:
> 2011/4/21 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > On Tuesday 19 April 2011 09:31:05 Sakari Ailus wrote:
> >> Laurent Pinchart wrote:
> >> ...
> >> 
> >> > That's the ideal situation: sensors should not produce any data (or
> >> > rather any transition on the VS/HS signals) when they're supposed to
> >> > be stopped. Unfortunately that's not always easy, as some dumb
> >> > sensors (or sensor-like hardware) can't be stopped. The ISP driver
> >> > should be able to cope with that in a way that doesn't kill the
> >> > system completely.
> >> > 
> >> > I've noticed the same issue with a Caspa camera module and an
> >> > OMAP3503-based Gumstix. I'll try to come up with a good fix.
> >> 
> >> Hi Laurent, others,
> >> 
> >> Do you think the cause for this is that the system is jammed in handling
> >> HS_VS interrupts triggered for every HS?
> > 
> > That was my initial guess, yes.
> > 
> >> A quick fix for this could be just choosing either VS configuration when
> >> configuring the CCDC. Alternatively, HS_VS interrupts could be just
> >> disabled until omap3isp_configure_interface().
> >> 
> >> But as the sensor is sending images all the time, proper VS
> >> configuration would be needed, or the counting of lines in the CCDC
> >> (VD* interrupts) is affected as well. The VD0 interrupt, which is used
> >> to trigger an interrupt near the end of the frame, may be triggered one
> >> line too early on the first frame, or too late. But this is up to a
> >> configuration. I don't think it's a real issue to trigger it one line
> >> too early.
> >> 
> >> Anything else?
> 
> Hello Laurent,
> 
> > I've tried delaying the HS_VS interrupt enable to the CCDC configuration
> > function, after configuring the bridge (and thus the HS/VS interrupt
> > source selection). To my surprise it didn't fix the problem, I still get
> > tons of HS_VS interrupts (100000 in about 2.6 seconds) that kill the
> > system.
> > 
> > I'll need to hook a scope to the HS and VS signals.
> 
> have you worked on this problem? Today in my setup I took a longer cable and
> ran again into the hs/vs interrupt storm (it still works with a short
> cable).
> I can tackle this issue too, but to avoid double work I wanted to ask if you
> worked out something in the meantime.

In my case the issue was caused by a combination of two hardware design 
mistakes. The first one was to use a TXB0801 chip to translate the 3.3V sensor 
levels to the 1.8V OMAP levels. The TXB0801 4kΩ output impedance, combined 
with the OMAP3 100µA pull-ups on the HS and VS signals, produces a ~400mV 
voltage for low logic levels.

Then, the XCLKA signal is next to the VS signal on the cable connecting the 
camera module to the OMAP board. When XCLKA is turned on, cross-talk produces 
a 400mV peak-to-peak noise on the VS signal.

The combination of those two effects create a noisy VS signal that crosses the 
OMAP3 input level detection gap at high frequency, leading to an interrupt 
storm. The workaround is to disable the pull-ups on the HS and VS signals, the 
solution is to redesign the hardware to replace the level translators and 
reorganize signals on the camera module cable.

Is your situation any similar ?

-- 
Regards,

Laurent Pinchart
