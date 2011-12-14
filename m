Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40125 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab1LNVvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 16:51:52 -0500
Date: Wed, 14 Dec 2011 23:51:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
Message-ID: <20111214215145.GA3677@valkosipuli.localdomain>
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com>
 <20111205224155.GB938@valkosipuli.localdomain>
 <4EE364C7.1090805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE364C7.1090805@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, Dec 10, 2011 at 02:55:19PM +0100, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 12/05/2011 11:41 PM, Sakari Ailus wrote:
> > On Mon, Dec 05, 2011 at 08:56:46PM +0100, Sylwester Nawrocki wrote:
> >> The V4L2_CID_FLASH_HW_STROBE_MODE mode control is intended
> >> for devices that are source of an external flash strobe for flash
> >> devices. This part seems to be missing in current Flash control
> >> class, i.e. a means for configuring devices that are not camera
> >> flash drivers but involve a flash related functionality.
> >>
> >> The V4L2_CID_FLASH_HW_STROBE_MODE control enables the user
> >> to determine the flash control behavior, for instance, at an image
> >> sensor device.
> >>
> >> The control has effect only when V4L2_CID_FLASH_STROBE_SOURCE control
> >> is set to V4L2_FLASH_STROBE_SOURCE_EXTERNAL at a flash subdev, if
> >> a flash subdev is present in the system.
> >>
> >> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
> >> ---
> >>
> >> Hi Sakari,
> >>
> >> My apologies for not bringing this earlier when you were designing
> >> the Flash control API.
> >> It seems like a use case were a sensor controller drives a strobe
> >> signal for a Flash and the sensor side requires some set up doesn't
> >> quite fit in the Flash Control API.
> >>
> >> Or is there already a control allowing to set Flash strobe mode at
> >> the sensor to: OFF, ON (per each exposed frame), AUTO ?
> 
> Thank you for the in-depth opinion (and sorry for the delayed response).

You're welcome! Thanks for bringing up the topic! :-)

> > The flash API defines the API for the flash, not for the sensor which might
> > be controlling the flash through the hardware strobe pin. I left that out
> > deliberately before I could see what kind of controls would be needed for
> > that.
> > 
> > If I understand you correctly, this control is intended to configure the
> > flash strobe per-frame? That may be somewhat hardware-dependent.
> 
> Yes, per captured frame. Actually the controls I proposed were meant to select
> specific flash strobe algorithm. What refinements could be relevant for those
> algorithms may be a different question. Something like the proposed controls
> is really almost all that is offered by many of hardware we use.



> > Some hardware is able to strobe the flash for the "next possible frame" or
> > for the first frame when the streaming is started. In either of the cases,
> > the frames before and after the one exposed with the flash typically are
> > ruined because the flash has exposed only a part of them. You typically want
> > to discard such frames.
> 
> Is this the case for Xenon flash as well, or LED only ?

Both xenon and LED.

> I think the fact that we're using video capture like interface for still capture
> adds complexity in such cases.

It also adds flexibility. You can expose one frame with xenon flash w/o
stopping streaming.

> > flash: LED flash typically remains on for the whole duration of the frame
> > exposure, whereas on xenon flash the full frame must be being exposed when
> > the flash is being fired.
> 
> Indeed, I should have separated the LED and Xenon case in the first place.
> 
> Do you think we could start with separate menu controls for LED and Xenon
> flash strobe, e.g.
> 
> V4L2_FLASH_LED_STROBE_MODE,
> V4L2_FLASH_XENON_STROBE_MODE
> 
> and then think of what controls would be needed for each particular mode
> under these menus ?

Do we need to separate them? I don't think they're very different, with the
possible exception of intensity control. For xenon flashes the intensity is
at least sometimes controlled by the strobe pulse length.

Still, flash strobe start timing and length control are the same.

> > Also different use cases may require different flash timing handling. [1]
> 
> I think we need to be able to specify flash strobe delay relative to exposure
> start in absolute time and relative to exposure time units.

I agree. I actually just sent a few patches which could be relevant to this,
you're cc'd (patches 1 and 2):

<URL:http://www.mail-archive.com/linux-media@vger.kernel.org/msg39798.html>

What units your sensor uses naturally?

> > Some sensors have a synchronised electrical shutter (or what was it called,
> > something like that anyway); that causes the exposure of all the lines of
> 
> I guess you mean two-curtain type shutter, like the one described here:
> 
> http://camerapedia.wikia.com/wiki/Focal_plane_shutter
> http://www.photozone.de/hi-speed-flash-sync

No, but I wasn't actually aware of that. :)

This is what I meant:

<URL:http://forums.dpreview.com/forums/read.asp?forum=1037&message=37167063>

> > the sensor to stop at the same time. This effectively eliminates the rolling
> > shutter effect. The user should know whether (s)he is using synchronised
> > shutter or rolling shutter since that affects the timing a lot.
> > 
> > How the control of the hardware strobe should look like to the user?
> > 
> > I don't think the flash handling can be fully expressed by a single control
> > --- except for end user applications. They very likely don't want to know
> > about all the flash timing related details.
> 
> Agreed.
> 
> > 
> > Are you able tell more about your use case? How about the sensor providing
> > the hardware strobe signal?
> 
> As a light source a high intensity white LED is used. The LED current control
> circuit is directly controlled by a sensor, let's say for simplicity through
> one pin.

Can there be use for more? That said, I like simple things. ;)

> Now all the magic happens in the sensor firmware and the user can only select
> flash programs, e.g. always on/off or auto. I've seen the front curtain and
> rear curtain modes used here and there. As you may know these are used in
> "slow sync" flash case, where the sensor is fired at the beginning or at the
> end of long exposure period.

Right. I think I'll need to refresh my memory on the flash usage.

> For example S5K6AA sensor provides following options in REG_TC_FLS_Mode
> register for LED flash strobe:
> 
> 0: TC_FLASH_DISABLE,
> 1: TC_FLASH_CONT_ENABLE,  // Always on
> 2: TC_FLASH_PULSE_ENABLE, // Use burst pulse on every capture
> 3: TC_FLASH_PULSE_AUTO    // Sensor controls the Flash status (burst mode)
> 
> For option 3 there is also a register:
> 
> REG_TC_FLS_Threshold - Set flash activation threshold in normalized
>                        brightness units
> 
> For Xenon flash
> 
> REG_TC_FLS_XenonMode (Set Xenon flash mode):
> 
> 0: TC_XENON_DISABLE,
> 1: TC_XENON_ONE_STROBE, // Use one strobe
> 2: TC_XENON_PRE_FLASH   // Use n strobes for pre-flash and another one, full
> 
> REG_TC_FLS_XenonPreFlashCnt - Number of Xenon pre-flash strobes
> 
> 
> And this sensor has also register to trigger still (single- or multi-frame)
> capture (REG_TC_GP_EnableCapture), i.e. switch from low resolution/high frame
> rate operation to higher resolution image capture.

Some of that functionality might fit better behind private ioctls instead.
We'll first need to see what looks more or less generic. I'll get back to
the topic in the near future.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
