Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1459 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZDTVAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 17:00:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera to v4l2-subdev conversion
Date: Mon, 20 Apr 2009 22:58:13 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.0904071122511.5155@axis700.grange> <200904202117.13348.hverkuil@xs4all.nl> <Pine.LNX.4.64.0904202142330.4403@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904202142330.4403@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904202258.14084.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 20 April 2009 22:19:23 Guennadi Liakhovetski wrote:
> Hi Hans,
>
> On Mon, 20 Apr 2009, Hans Verkuil wrote:
> > On Thursday 16 April 2009 21:20:38 Guennadi Liakhovetski wrote:
> > > Hi Hans,
> > >
> > > I have so far partially converted a couple of example setups, namely
> > > the i.MX31-based pcm037/pcm970 and PXA270-based pcm027/pcm990 boards.
> > >
> > > Partially means, that I use v4l2_i2c_new_subdev() to register new
> > > cameras and v4l2_device_register() to register hosts, I use some core
> > > and video operations, but there are still quite a few extra bonds
> > > that tie camera drivers and soc-camera core, that have to be broken.
> > > The current diff is at
> > > http://download.open-technology.de/testing/20090416-4.gitdiff,
> > > although, you, probably, don't want to look at it:-)
> > >
> > > A couple of minor general remarks first:
> > >
> > > Shouldn't v4l2_device_call_until_err() return an error if the call is
> > > unimplemented?
> >
> > It's my opinion that in general if no subdev needs to handle a
> > particular call, then that's OK. I'm assuming that if it is wrong, then
> > the device won't work anyway.
>
> In fact, what I actually need is to call a specific method, if it is
> implemented, from one specific subdevice, and get its error code - not
> from all and not until the first error. I am currently abusing your
> grp_id for this, but it might eventually be better to add such a wrapper.

That's actually what grp_id is intended for (or one of the intended uses at 
least). The alternative method is to keep a pointer to the v4l2_subdev and 
use that directly through v4l2_subdev_call(). The third method is to create 
your own macro based on __v4l2_device_call_until_err. There is nothing 
special about it.

> > > There's no counterpart to v4l2_i2c_new_subdev() in the API, so one is
> > > supposed to call i2c_unregister_device() directly?
> >
> > You don't need to call that. It's done automatically when the i2c
> > adapter is deleted. It might be that in the future this will have to be
> > called, but if so then it will go through v4l2_device_unregister.
>
> Adapter might never be deleted - remember, this is just a generic CPU i2c
> controller.

Ah yes. Good point. I have to think about this. It should probably be done 
through v4l2_device_unregister().

> > > We'll have to extend v4l2_subdev_video_ops with [gs]_crop.
> >
> > No problem. Just add it.
> >
> > > Now I'm thinking about how best to break those remaining ties in
> > > soc-camera. The remaining bindings that have to be torn are in
> > > struct soc_camera_device. Mostly these are:
> > >
> > > 1. current geometry and geometry limits - as seen on the canera host
> > > - camera client interface. I think, these are common to all video
> > > devices, so, maybe we could put them meaningfully in a struct
> > > video_data, accessible for both v4l2 subdevices and devices - one per
> > > subdevice?
> >
> > See notes under 3.
> >
> > > 2. current exposure and gain. There are of course other video
> > > parameters similar to these, like gamma, saturation, hue... Actually,
> > > these are only needed in the sensor driver, the only reason why I
> > > keep them globally available it to reply to V4L2_CID_GAIN and
> > > V4L2_CID_EXPOSURE G_CTRL requests. So, if I pass these down to the
> > > sensor drivers just like all other control requests, they can be
> > > removed from soc_camera_device.
> >
> > Agreed.
> >
> > > 3. format negotiation. This is a pretty important part of the
> > > soc-camera framework. Currently, sensor drivers provide a list of
> > > supported pixel formats, based on it camera host drivers build
> > > translation tables and calculate user pixel formats. I'd like to
> > > preserve this functionality in some form. I think, we could make an
> > > optional common data block, which, if available, can be used also for
> > > the format negotiation and conversion. If it is not available, I
> > > could just pass format requests one-to-one down to sensor drivers.
> > >
> > > Maybe a more universal approach would be to just keep "synthetic"
> > > formats in each camera host driver. Then, on any format request first
> > > just request it from the sensor trying to pass it one-to-one to the
> > > user. If this doesn't work, look through the possible conversion
> > > table, if the requested format is found among output formats, try to
> > > request all input formats, that can be converted to it, one by one
> > > from the sensor. Hm...
> >
> > Both 1 and 3 touch on the basic reason for creating the framework: one
> > can build on it to move common driver code into framework. But the
> > order in which I prefer to do this is to first move everything over to
> > the framework first, before starting on refactoring drivers. The reason
> > is that that way to have a really good overview of what everyone is
> > doing.
> >
> > My question is: is it possible without too much effort to fix 1 and 3
> > without modifying the framework?
>
> You mean "to implement 1 and 3 without modifying the v4l2-(sub)dev
> framework"? 

Correct.

> (1) wouldn't be too difficult, but (3) would require quite a 
> bit of re-design and re-work of all three levels of soc-camera: core,
> client and host drivers. Same holds for (4) below. (3) can be implemented
> with some kind of enumeration similar to what v4l2 is currently doing in
> the user API. We could do the following:
>
> 1. clients keep their formats internally in some arbitrary indexed list
>
> 2. on initialisation the core enumerates those formats using .enum_fmt
> from struct v4l2_subdev_video_ops and queries the host if it can handle
> each of those formats and which ones it can produce out of them for the
> user
>
> 3. the core then creates a list of user formats with fourcc codes and
> indices of respective client formats
>
> 4. when the user enumerates formats the core scans the list created in
> (3) above and returns all user formats from it eliminating duplicates
>
> 5. when the user selects a specific format the core passes the request
> down to the host driver and that one can select which of possibly
> multiple options to use to provide this format to the user
>
> 6. the host driver then uses the fourcc from the selected entry to
> configure the client using .s_fmt
>
> This is in principle the same as what we are currently doing in
> soc-camera only making format lists unaccessible for clients. Also, while
> writing this email it occurred to me that we're currently eliminating
> format duplicates too early, but that's a pretty unrelated change.

I'll have to think some more about this on Friday or Saturday.

> > It will be suboptimal, I know, but it will
> > also be faster. The alternative is to move support for this into the
> > core framework, but that will mean a lot more work because then I want
> > to do it right the first time, which means going through all the
> > existing drivers, see how they do it, see how the framework can assist
> > with that, and then come up with a good solution.
>
> The above will require no modifications to the framework except for one
> thing - can we have a bus-field (currently called "depth" in struct
> soc_camera_data_format) in struct v4l2_fmtdesc?

That's a public API and can't be changed without very good reasons. In 
principle the fourcc code implies the depth. So it's not needed in 
v4l2_fmtdesc. I suspect that what you try to use it for is better done in a 
different manner. Can you describe how it is used?

> > > 4. bus parameter negotiation. Also an important thing. Should do the
> > > same: if available - use it, if not - use platform-provided defaults.
> >
> > This is something for which I probably need to make changes. I think it
> > is reasonable to add something like a s_bus_param call for this.
> >
> > An alternative is to use platform_data in board_info. This will mean an
> > extra argument to the new_subdev functions. And since this is only
> > available for 2.6.26 and up it is not as general.
>
> No, platform data is not a good option. For example, some clients only
> support some fixed bus flags - fixed signal polarities etc. For that you
> don't need platform data. Unless the platform has put an inverter on
> those lines... (which soc-camera can handle too:-)) Currently we have two
> calls for this: .query_bus_param() and .set_bus_param(). Having queried
> bus parameters supported by the client, the host builds an intersection
> with own bus parameters, and if a working configuration exists (at least
> one common polarity for all signals, one common bus width...) then it's
> used to configure the client.

Not sure why using platform_data would be a problem (I'm not saying we need 
it, I just don't follow your reasoning). As I see it each v4l2 i2c driver 
can have its own configuration parameters that are defined in a 
media/driver.h header. If there is nothing special to be set, then no 
platform_data is needed, otherwise you can fill in a struct and pass that 
through platform_data. It's a bit of a misnomer: client_data would be a 
better name as this has really nothing to do with a platform. Something 
that confused me for the longest time...

The advantage of using platform_data is that it can contain whatever a v4l2 
i2c driver needs.

Note that for now I have no problem with it if you add a s_bus_param 
(s_bus_config?) ops. TI will need something like that as well in fact.

> > > I think, I just finalise this partial conversion and we commit it,
> > > because if I keep it locally for too long, I'll be getting multiple
> > > merge conflicts, because this conversion also touches platform
> > > code... Then, when the first step is in the tree we can work on
> > > breaking the remaining bonds.
> >
> > Agreed. Do it step by step, that makes it much easier to work with.
>
> Ok, I'll try to post a patch tomorrow...

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
