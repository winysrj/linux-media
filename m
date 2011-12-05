Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44829 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1LEWmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 17:42:01 -0500
Date: Tue, 6 Dec 2011 00:41:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs3all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
Message-ID: <20111205224155.GB938@valkosipuli.localdomain>
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323115006-4385-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the RFC.

On Mon, Dec 05, 2011 at 08:56:46PM +0100, Sylwester Nawrocki wrote:
> The V4L2_CID_FLASH_HW_STROBE_MODE mode control is intended
> for devices that are source of an external flash strobe for flash
> devices. This part seems to be missing in current Flash control
> class, i.e. a means for configuring devices that are not camera
> flash drivers but involve a flash related functionality.
> 
> The V4L2_CID_FLASH_HW_STROBE_MODE control enables the user
> to determine the flash control behavior, for instance, at an image
> sensor device.
> 
> The control has effect only when V4L2_CID_FLASH_STROBE_SOURCE control
> is set to V4L2_FLASH_STROBE_SOURCE_EXTERNAL at a flash subdev, if
> a flash subdev is present in the system.
> 
> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
> ---
> 
> Hi Sakari,
> 
> My apologies for not bringing this earlier when you were designing
> the Flash control API.
> It seems like a use case were a sensor controller drives a strobe
> signal for a Flash and the sensor side requires some set up doesn't
> quite fit in the Flash Control API.
> 
> Or is there already a control allowing to set Flash strobe mode at
> the sensor to: OFF, ON (per each exposed frame), AUTO ?

The flash API defines the API for the flash, not for the sensor which might
be controlling the flash through the hardware strobe pin. I left that out
deliberately before I could see what kind of controls would be needed for
that.

If I understand you correctly, this control is intended to configure the
flash strobe per-frame? That may be somewhat hardware-dependent.

Some hardware is able to strobe the flash for the "next possible frame" or
for the first frame when the streaming is started. In either of the cases,
the frames before and after the one exposed with the flash typically are
ruined because the flash has exposed only a part of them. You typically want
to discard such frames.

The timing control of the flash strobe fully depends on the type of the
flash: LED flash typically remains on for the whole duration of the frame
exposure, whereas on xenon flash the full frame must be being exposed when
the flash is being fired.

Also different use cases may require different flash timing handling. [1]

Some sensors have a synchronised electrical shutter (or what was it called,
something like that anyway); that causes the exposure of all the lines of
the sensor to stop at the same time. This effectively eliminates the rolling
shutter effect. The user should know whether (s)he is using synchronised
shutter or rolling shutter since that affects the timing a lot.

How the control of the hardware strobe should look like to the user?

I don't think the flash handling can be fully expressed by a single control
--- except for end user applications. They very likely don't want to know
about all the flash timing related details.

Are you able tell more about your use case? How about the sensor providing
the hardware strobe signal?

[1] http://www.spinics.net/lists/linux-media/msg31363.html

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
