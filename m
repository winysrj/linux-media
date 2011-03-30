Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60359 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab1C3IzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 04:55:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
Date: Wed, 30 Mar 2011 10:55:42 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Cohen David Abraham <david.cohen@nokia.com>
References: <4D90854C.2000802@maxwell.research.nokia.com> <201103290849.48799.hverkuil@xs4all.nl> <4D91A7D7.5060909@maxwell.research.nokia.com>
In-Reply-To: <4D91A7D7.5060909@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103301055.42521.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Tuesday 29 March 2011 11:35:19 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Monday, March 28, 2011 14:55:40 Sakari Ailus wrote:

[snip]

> >> 	V4L2_CID_FLASH_TIMEOUT (integer; LED)
> >> 
> >> The flash controller provides timeout functionality to shut down the led
> >> in case the host fails to do that. For hardware strobe, this is the
> >> maximum amount of time the flash should stay on, and the purpose of the
> >> setting is to prevent the LED from catching fire.
> >> 
> >> For software strobe, the setting may be used to limit the length of the
> >> strobe in case a driver does not implement it itself. The granularity of
> >> the timeout in [1, 2, 3] is very coarse. However, the length of a
> >> driver-implemented LED strobe shutoff is very dependent on host.
> >> Possibly V4L2_CID_FLASH_DURATION should be added, and
> >> V4L2_CID_FLASH_TIMEOUT would be read-only so that the user would be able
> >> to obtain the actual hardware implemented safety timeout.
> >> 
> >> Likely a standard unit such as ms or µs should be used.
> > 
> > It seems to me that this control should always be read-only. A setting
> > like this is very much hardware specific and you don't want an attacker
> > changing the timeout to the max value that might cause a LED catching
> > fire.
> 
> I'm not sure about that.
> 
> The driver already must take care of protecting the hardware in my
> opinion. Besides, at least one control is required to select the
> duration for the flash if there's no hardware synchronisation.
> 
> What about this:
> 
> 	V4L2_CID_FLASH_TIMEOUT
> 
> Hardware timeout, read-only. Programmed to the maximum value allowed by
> the hardware for the external strobe, greater or equal to
> V4L2_CID_FLASH_DURATION for software strobe.
> 
> 	V4L2_CID_FLASH_DURATION
> 
> Software implemented timeout when V4L2_CID_FLASH_STROBE_MODE ==
> V4L2_FLASH_STROBE_MODE_SOFTWARE.

Why would we need two controls here ? My understanding is that the maximum 
strobe duration length can be limited by

- the flash controller itself
- platform-specific constraints to avoid over-heating the flash

The platform-specific constraints come from board code, and the flash driver 
needs to ensure that the flash is never strobed for a duration longer than the 
limit. This requires implementing a software timer if the hardware has no 
timeout control, and programming the hardware with the correct timeout value 
otherwise. The limit can be queried with QUERYCTRL on the duration control.

> I have to say I'm not entirely sure the duration control is required.
> The timeout could be writable for software strobe in the case drivers do
> not implement software timeout. The granularity isn't _that_ much
> anyway. Also, a timeout fault should be produced whenever the duration
> would expire.
> 
> Perhaps it would be best to just leave that out for now.
> 
> >> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
> >> 
> >> enum v4l2_flash_led_mode {
> >> 
> >> 	V4L2_FLASH_LED_MODE_FLASH = 1,
> >> 	V4L2_FLASH_LED_MODE_TORCH,

"torch" mode can also be used for video, should we rename TORCH to something 
more generic ? Maybe a "manual" mode ?

> >> 
> >> };
> > 
> > Would a LED_MODE_NONE make sense as well to turn off the flash
> > completely?
> 
> It would essentially be the same as choosing software strobe and disabling
> strobe. A separate mode for this still could be good to make it explicit.

-- 
Regards,

Laurent Pinchart
