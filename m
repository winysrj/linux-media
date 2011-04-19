Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:25597 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1DSH2c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 03:28:32 -0400
Message-ID: <4DAD3A39.1030500@maxwell.research.nokia.com>
Date: Tue, 19 Apr 2011 10:31:05 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: David Cohen <dacohen@gmail.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3 ISP deadlocks on my new arm
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com> <BANLkTi==Yeniz_Mm4rD2qnGSR5kBE_XCcg@mail.gmail.com> <BANLkTikLJQitB6ojQ3NaXnJ9op4GGx+YGA@mail.gmail.com> <201104181623.56866.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104181623.56866.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
...
> That's the ideal situation: sensors should not produce any data (or rather any 
> transition on the VS/HS signals) when they're supposed to be stopped. 
> Unfortunately that's not always easy, as some dumb sensors (or sensor-like 
> hardware) can't be stopped. The ISP driver should be able to cope with that in 
> a way that doesn't kill the system completely.
> 
> I've noticed the same issue with a Caspa camera module and an OMAP3503-based 
> Gumstix. I'll try to come up with a good fix.

Hi Laurent, others,

Do you think the cause for this is that the system is jammed in handling
HS_VS interrupts triggered for every HS?

A quick fix for this could be just choosing either VS configuration when
configuring the CCDC. Alternatively, HS_VS interrupts could be just
disabled until omap3isp_configure_interface().

But as the sensor is sending images all the time, proper VS
configuration would be needed, or the counting of lines in the CCDC (VD*
interrupts) is affected as well. The VD0 interrupt, which is used to
trigger an interrupt near the end of the frame, may be triggered one
line too early on the first frame, or too late. But this is up to a
configuration. I don't think it's a real issue to trigger it one line
too early.

Anything else?

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
