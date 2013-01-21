Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2362 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3AUVkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 16:40:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-15?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: V4L2 spec / core questions
Date: Mon, 21 Jan 2013 22:39:58 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <50FC5E87.2080902@googlemail.com> <201301210959.49780.hverkuil@xs4all.nl> <50FDB251.6030501@googlemail.com>
In-Reply-To: <50FDB251.6030501@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301212239.58876.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 21 2013 22:25:37 Frank Schäfer wrote:
> Hi Hans,
> 
> Am 21.01.2013 09:59, schrieb Hans Verkuil:
> > On Sun January 20 2013 22:15:51 Frank Schäfer wrote:
> >> Hi Hans,
> >>
> >> I noticed that there's code in the v4l2 core that enables/disables
> >> ioctls and checks some of the parameters depending on the device type.
> >> While reading the code an comparing it to the V4L2 API document, some
> >> more questions came up:
> >>
> >> 1) Video devices with VBI functionality:
> >> The spec says: "To address the problems of finding related video and VBI
> >> devices VBI capturing and output is also available as device function
> >> under /dev/video".
> >> Is that still valid ?
> > No, that's not valid. It really was never valid: most drivers didn't implement
> > this, and those that did likely didn't work. During one of the media summits
> > we decided not to allow this. Allowing VBI functionality in video node has a
> > number of problems:
> >
> > 1) it's confusing: why have a vbi node at all if you can do it with a video
> > node as well? 
> 
> Yeah, although I think the problem described in the spec document is real.
> No idea how good applications are in finding the correct VBI device
> belonging to a specific video device node...
> 
> Hmm... yeah... why have separate device nodes at all ? We could provide
> the same functionality with a single device node (e.g. /dev/multimediaX).
> I assume separation into radio / video / vbi device nodes gears towards
> typical feature sets of applications.
> Probably something to think about for V4L3... ;)

This is an ongoing issue for many years. Laurent and Sakari are working
on a library that apps can call that tries to find these related devices.
For drivers that implement the media controller API the MC device can be
used to obtain this information.

> > In fact, applications always use the vbi node for vbi data.
> >
> > 2) it breaks down when you want to read() the data: read() can handle only
> > one 'format' at a time. So if you want to read both video and vbi at the same
> > time then you need to nodes.
> 
> Ouch, yes !
> Ok, so the traditional read() concept is probably the _real_ reason for
> having separate device nodes...
> 
> > 3) it makes drivers quite complex: separating this functionality in distinct
> > nodes makes life much easier.
> 
> It looks like the v4l2 core has been improved a lot and now does most of
> the work for the driver, so it's probably not that complex anymore.
> 
> >> What about VBI "configuration" (e.g.
> >> VIDIOC_G/S/TRY_FMT for VBI formats) ?
> >> Looking into the v4l2 core code, it seems that the VBI buffer types
> >> (field "type" in struct v4l2_format) are only accepted, if the device is
> >> a VBI device.
> > That's correct. I've added these checks because drivers often didn't test
> > that themselves. It's also much easier to test in the v4l2 core than
> > repeating the same test in every driver.
> >
> >> 2) VIDIOC_G/S/TRY_FMT and VBI devices:
> >> The sepc says: "VBI devices must implement both the VIDIOC_G_FMT and
> >> VIDIOC_S_FMT ioctl, even if VIDIOC_S_FMT ignores all requests and always
> >> returns default parameters as VIDIOC_G_FMT does. VIDIOC_TRY_FMT is
> >> optional." What's the reason for this ? Is it still valid ?
> > This is still valid (in fact, v4l2-compliance requires the presence of
> > TRY_FMT as well as I don't think there is a good reason not to implement
> > it). The reason for this is that this simplifies applications: no need to
> > test for the presence of S_FMT.
> >
> >> 3) VIDIOC_S_TUNER: field "type" in struct v4l2_tuner
> >> Are radio tuners accessable through video devices (and the other way
> >> around) ?
> > Not anymore. This used to be possible, although because it was never
> > properly tested most drivers probably didn't implement that correctly.
> >
> > The radio API has always been a bit messy and we have been slowly cleaning
> > it up.
> 
> Yeah, I think the most confusing things are input/output/routing
> (G/S_INPUT, G/S_AUDIO).
> 
> >
> >> Has this field to be set by the application ?
> > No, it is filled in by the core based on the device node used. This follows
> > the spec which does not require apps to set the type.
> >
> >> If yes: driver overwrites
> >> the value or returns with an error if the type doesn't match the tuner
> >> at the requested index ?
> >> I wonder if it would make sense to check the tuner type inside the v4l
> >> core (like the fmt/buffer type check for G/S_PARM).
> >>
> >> 4) VIDIOC_DBG_G_CHIP_IDENT:
> >> Is it part of CONFIG_VIDEO_ADV_DEBUG just like VIDIOC_DBG_G/S_REGISTER ?
> > No. It just returns some chip info, it doesn't access the hardware, so there
> > is no need to put it under ADV_DEBUG.
> 
> Ok. I just noticed that in most drivers it's inside the #ifdef
> CONFIG_VIDEO_ADV_DEBUG.

That's unnecessarily strict.

> It also has been renamed from VIDIOC_G_CHIP_IDENT to
> VIDIOC_DBG_G_CHIP_IDENT which somehow suggests that it's an advanced
> debug feature.

It's a debug feature, but not an 'advanced' debug feature :-)

> 
> >
> >> In determine_valid_ioctls(), it is placed outside the #ifdef
> >> CONFIG_VIDEO_ADV_DEBUG section.
> >> The spec says "Identify the chips on a TV card" but isn't it suitable
> >> for all device types (radio/video/vbi) ?
> > That's correct. A patch is welcome :-)
> 
> To be sure that I understood you correctly:
>  VIDIOC_DBG_G_CHIP_IDENT is suitable for all device types ?
> Then no patch is needed but the spec document has to be fixed.

Correct.

> 
> >> determine_valid_ioctls() in
> >> v4l2-dev.c enables it for all devices.
> >>
> >> 5) The buffer ioctls (VIDIOC_REQBUFS, VIDIOC_CREATE_BUFS,
> >> VIDIOC_PREPARE_BUF, VIDIOC_QUERYBUF, VIDIOC_QBUF, VIDIOC_DQBUF) are not
> >> applicable to radio devices, right ?
> > That's correct.
> >
> >> In function determine_valid_ioctls() in v4l2-dev.c they are enabled for
> >> all device types.
> > A patch fixing this is welcome!
> 
> Coming soon.
> 
> >
> >> 6) VIDIOC_G/S_AUDIO: Shouldn't it be disabled in
> >> determine_valid_ioctls() for VBI devices ?
> > No. VBI devices still allow this. Strictly speaking it isn't useful for vbi
> > devices, but allowing G/S_INPUT but not G/S_AUDIO feels inconsistent to me.
> >
> > While it isn't useful, it doesn't hurt either.
> >
> >> Btw: function determine_valid_ioctls() in v4l2-dev.c is a good summary
> >> that explains which ioctls are suitable for which device types
> >> (radio/video/vbi).
> >> Converting its content into a table would be a great
> >> extension/clarifaction of the V4L2 API spec document !
> > We played around with the idea of 'profiles' where for each type of device
> > you have a table listing what can and cannot be done. The problem is time...
> >
> > If you are interesting in pursuing this, then I am happy to help with advice
> > and pointers (v4l2-compliance is also a great source of information).
> 
> I could create a simple html table with X = device type, Y = ioctl.

That would be a good start!

> 
> >
> >> Thanks for your patience !
> > My pleasure!
> >
> > Regards,
> >
> > 	Hans
> 
> One last question:
> I'm looking for a possibility to disable all ioctls when the device is
> unplugged.
> I think this is a common problem/task of all drivers for hotpluggable
> devices, because the disconnect callbacks can't unregister the device
> until it get's closed by the application.
> What's the best way to do this ? v4l2_disable_ioctl() has no effect
> after video_register_device() is called...

Call video_unregister_device() on disconnect. After that any file operation
call will be handled by the core and do the right thing on disconnect.

See also the section 'video_device cleanup' in the v4l2-framework.txt file.

Regards,

	Hans
