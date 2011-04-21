Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58403 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1DUJ3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:29:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
Date: Thu, 21 Apr 2011 11:29:39 +0200
Cc: David Cohen <dacohen@gmail.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com> <201104181623.56866.laurent.pinchart@ideasonboard.com> <4DAD3A39.1030500@maxwell.research.nokia.com>
In-Reply-To: <4DAD3A39.1030500@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211129.40889.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Tuesday 19 April 2011 09:31:05 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> ...
> 
> > That's the ideal situation: sensors should not produce any data (or
> > rather any transition on the VS/HS signals) when they're supposed to be
> > stopped. Unfortunately that's not always easy, as some dumb sensors (or
> > sensor-like hardware) can't be stopped. The ISP driver should be able to
> > cope with that in a way that doesn't kill the system completely.
> > 
> > I've noticed the same issue with a Caspa camera module and an
> > OMAP3503-based Gumstix. I'll try to come up with a good fix.
> 
> Hi Laurent, others,
> 
> Do you think the cause for this is that the system is jammed in handling
> HS_VS interrupts triggered for every HS?

That was my initial guess, yes.

> A quick fix for this could be just choosing either VS configuration when
> configuring the CCDC. Alternatively, HS_VS interrupts could be just
> disabled until omap3isp_configure_interface().
> 
> But as the sensor is sending images all the time, proper VS configuration
> would be needed, or the counting of lines in the CCDC (VD* interrupts) is
> affected as well. The VD0 interrupt, which is used to trigger an interrupt
> near the end of the frame, may be triggered one line too early on the first
> frame, or too late. But this is up to a configuration. I don't think it's a
> real issue to trigger it one line too early.
> 
> Anything else?

I've tried delaying the HS_VS interrupt enable to the CCDC configuration 
function, after configuring the bridge (and thus the HS/VS interrupt source 
selection). To my surprise it didn't fix the problem, I still get tons of 
HS_VS interrupts (100000 in about 2.6 seconds) that kill the system.

I'll need to hook a scope to the HS and VS signals.

-- 
Regards,

Laurent Pinchart
