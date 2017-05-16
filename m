Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41404 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751342AbdEPXE4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 19:04:56 -0400
Date: Wed, 17 May 2017 02:04:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Sensor sub-device - what are the mandatory ops?
Message-ID: <20170516230449.GR3227@valkosipuli.retiisi.org.uk>
References: <CAAoAYcPtX4hrCYrMNuucEpm37asKZkspMmRE_siJHY+u5ge11A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoAYcPtX4hrCYrMNuucEpm37asKZkspMmRE_siJHY+u5ge11A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Thu, May 11, 2017 at 04:51:27PM +0100, Dave Stevenson wrote:
> Hi All.
> 
> As previously discussed, I'm working on a V4L2 driver for the
> CSI-2/CCP2 receiver on BCM283x, as used on Raspberry Pi.
> It's a relatively simple hardware block that writes received data into
> SDRAM, and only accepts connection from one "sensor" sub device, so no
> need to involve the media controller API. (The peripheral can do
> cropping and format conversion between the CSI-2 Bayer formats too,
> but I'm ignoring those for now, and even so they don't really need
> media controller).

If the sensor exposes multiple sub-devices or you have e.g. a more complex
TV tuner with internal data routing such as some of the ADVxxxx chips, you
won't be able to support them in this model.

On the other hand, using Media controller brings some extra complexity and
requires generally a lot more decision making and configuration from the
user space as well. (This is something that needs to be more or less
resolved over time but how long it'll take I can't say.)

Just FYI.

> I was previously advised by Hans to take am437x as a base, and that
> seems to have worked pretty well when combined with some of the ti-vpe
> driver too. It's up and running, although with some rough edges. I'm
> hoping to sort an RFC in a week or so.
> 
> My main issue is determining what calls are mandatory to be supported
> by the sensor sub-device drivers that attach to the CSI-2 receiver.
> I'm either taking the wrong approach, or there seem to be missing ops
> in the drivers I'm trying to use. The set of devices I have available
> are Omnivision OV5647, Toshiba TC358743 HDMI to CSI2 bridge, and
> ADV7282-M analogue video to CSI-2 decoder.
> 
> The TC358743 driver doesn't support:
> - enum_mbus_code to report the supported formats
> (MEDIA_BUS_FMT_RGB888_1X24 and MEDIA_BUS_FMT_UYVY8_1X16)

Without knowing any details on the chip nor its driver, if it supports the
two, it'd be reasonable that it also provided such enumeration of mbus
codes.

> - s_power. The docs [1] say the device must be powered up before
> calling v4l2_subdev_video_ops->s_stream, but is s_power optional so
> ENOIOCTLCMD is not to be considered a failure?

Correct.

> - enum_frame_size
> and doesn't set the state->mbus_fmt_code until after
> v4l2_async_register_subdev. A connected subdevice calling get_fmt
> during the notifier.complete callback gets a code of 0.
> 
> The OV5647 driver doesn't support:
> - set_fmt or get_fmt. I can't see any code that returns the 640x480
> sensor resolution that is listed in the commit text.

get_fmt is essential. Without that link validation can't work. If the driver
doesn't support setting the format, the get_fmt callback can be used for
set_fmt as well.

> - g_mbus_config, so no information on the number of CSI-2 lanes in use
> beyond that in DT. Do we just assume all lines specified in DT are in
> use in this situation? In which case should the driver be checking
> that the configured number of lanes matches the register set it will
> request over I2C, as a mismatch will result in it not working?

The assumption is that all lanes are in use. g_mbus_config is from SoC
camera and, well, frankly should not look like how it looks now. It's used
by a couple of drivers and needs to be replaced by more generic and
informative means to let the receiver know the frame structure the
transmitter is about to start sending.

> - enum_frame_size
> 
> ADV7180/7282-M
> - enum_frame_size
> 
> I've listed enum_frame_size as that is what TI VPE driver uses in
> cal_try_fmt_vid_cap. It seems more sensible to pass the request in to
> set_fmt with which = V4L2_SUBDEV_FORMAT_TRY, so is this actually an
> issue with the TI driver doing the wrong thing? (FORMAT_TRY seems to
> work reasonably).

There must be a gap somewhere --- enum_frame_size provides a list of
supported frame sizes by the hardware. That shouldn't be dependent on the
device configuration. Nor it can --- the context provided has no clue about
it.

I think this was mostly added to mirror the original sub-device API in
kernel: its sole purpose was to implement VIDIOC_ENUM_FRAMESIZES.

> 
> Those are the issues I've hit on those 3 drivers. Is there a defintive
> list of what must be supported by drivers, and any checklist for
> drivers during review?

I'm afraid there isn't. There tend to be many different kinds of devices and
they need a little bit different parts of the APIs. And as a result the
interoperability of reciver - sensor pairs has not been quite up to what one
could have expected. Still, that has significantly improved over recent
years, e.g. due to conversion of SoC camera drivers to sub-device drivers.

> 
> I have patches for the TC358743 and OV5647 which I can post to the
> list if it is agreed that the above are issues rather than me doing
> the wrong thing.
> 
> 
> Follow-up question on g_mbus_format. The V4L2_MBUS_CSI2_x_LANE defines
> appear to have been specfied though they should be used as a bitmask,
> but based on existing drivers (mainly TC358743) only one is allowed to
> be set to denote the actual number of lanes used. Is that the correct
> interpretation? If so I guess we need error checking on the flags
> passed in.

How do you choose? Is the number of lanes set by the user or does it come
from device configuration?

There are patches here but they're hardly ready for merging any time soon:

<URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=shortlog;h=refs/heads/vc>

> 
> 
> One last question. Putting a user's hat on, what is the expected
> mapping of vidioc_s_input to s_routing?

S_INPUT is about physical input connectors. s_routing() video op as it
stands now is awful, I hope no-one uses it. :-) (Well, perhaps PCI cards.
Then you can know which components you have on a given card. This certainly
does not apply to DT based systems.)

> Looking at my use case, the CSI-2 receiver driver is the code that
> creates /dev/videoN, but it otherwise is just a proxy for the sensor
> device. It therefore makes the user's life easy if calls such as
> input, EDID, dv_timings, and std functions are just passed straight
> through to the sensor, so the user can ignore the subdev API.
> For input there appears to be no way to produce an implementation of
> vidioc_enum_input. Looking at the ADV7282-M (uses ADV7180 driver), I
> can't see any way of reading out the valid input numbers as would be
> needed for enum_input.

I guess you hit the original assumption there --- the caller, which is
another driver, would need to know the arguments for s_routing() which are
hardware specific.

> vidioc_g_input can be done by the CSI-2 receiver driver
> assuming/setting to input 0 during probe, and then caching the last
> set value, but that feels a little nasty. Have I missed something
> there?

I wonder if people working with similar devices have something to say.

AFAICT more complex devices use MC based drivers and different inputs mostly
mean different data routing --- which means it is covered by Media
controller already.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
