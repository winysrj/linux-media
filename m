Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3192 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3AUI74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 03:59:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-15?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: V4L2 spec / core questions
Date: Mon, 21 Jan 2013 09:59:49 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <50FC5E87.2080902@googlemail.com>
In-Reply-To: <50FC5E87.2080902@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301210959.49780.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 20 2013 22:15:51 Frank Schäfer wrote:
> Hi Hans,
> 
> I noticed that there's code in the v4l2 core that enables/disables
> ioctls and checks some of the parameters depending on the device type.
> While reading the code an comparing it to the V4L2 API document, some
> more questions came up:
> 
> 1) Video devices with VBI functionality:
> The spec says: "To address the problems of finding related video and VBI
> devices VBI capturing and output is also available as device function
> under /dev/video".
> Is that still valid ?

No, that's not valid. It really was never valid: most drivers didn't implement
this, and those that did likely didn't work. During one of the media summits
we decided not to allow this. Allowing VBI functionality in video node has a
number of problems:

1) it's confusing: why have a vbi node at all if you can do it with a video
node as well? In fact, applications always use the vbi node for vbi data.

2) it breaks down when you want to read() the data: read() can handle only
one 'format' at a time. So if you want to read both video and vbi at the same
time then you need to nodes.

3) it makes drivers quite complex: separating this functionality in distinct
nodes makes life much easier.

> What about VBI "configuration" (e.g.
> VIDIOC_G/S/TRY_FMT for VBI formats) ?
> Looking into the v4l2 core code, it seems that the VBI buffer types
> (field "type" in struct v4l2_format) are only accepted, if the device is
> a VBI device.

That's correct. I've added these checks because drivers often didn't test
that themselves. It's also much easier to test in the v4l2 core than
repeating the same test in every driver.

> 
> 2) VIDIOC_G/S/TRY_FMT and VBI devices:
> The sepc says: "VBI devices must implement both the VIDIOC_G_FMT and
> VIDIOC_S_FMT ioctl, even if VIDIOC_S_FMT ignores all requests and always
> returns default parameters as VIDIOC_G_FMT does. VIDIOC_TRY_FMT is
> optional." What's the reason for this ? Is it still valid ?

This is still valid (in fact, v4l2-compliance requires the presence of
TRY_FMT as well as I don't think there is a good reason not to implement
it). The reason for this is that this simplifies applications: no need to
test for the presence of S_FMT.

> 
> 3) VIDIOC_S_TUNER: field "type" in struct v4l2_tuner
> Are radio tuners accessable through video devices (and the other way
> around) ?

Not anymore. This used to be possible, although because it was never
properly tested most drivers probably didn't implement that correctly.

The radio API has always been a bit messy and we have been slowly cleaning
it up.

> Has this field to be set by the application ?

No, it is filled in by the core based on the device node used. This follows
the spec which does not require apps to set the type.

> If yes: driver overwrites
> the value or returns with an error if the type doesn't match the tuner
> at the requested index ?
> I wonder if it would make sense to check the tuner type inside the v4l
> core (like the fmt/buffer type check for G/S_PARM).
> 
> 4) VIDIOC_DBG_G_CHIP_IDENT:
> Is it part of CONFIG_VIDEO_ADV_DEBUG just like VIDIOC_DBG_G/S_REGISTER ?

No. It just returns some chip info, it doesn't access the hardware, so there
is no need to put it under ADV_DEBUG.

> In determine_valid_ioctls(), it is placed outside the #ifdef
> CONFIG_VIDEO_ADV_DEBUG section.
> The spec says "Identify the chips on a TV card" but isn't it suitable
> for all device types (radio/video/vbi) ?

That's correct. A patch is welcome :-)

> determine_valid_ioctls() in
> v4l2-dev.c enables it for all devices.
> 
> 5) The buffer ioctls (VIDIOC_REQBUFS, VIDIOC_CREATE_BUFS,
> VIDIOC_PREPARE_BUF, VIDIOC_QUERYBUF, VIDIOC_QBUF, VIDIOC_DQBUF) are not
> applicable to radio devices, right ?

That's correct.

> In function determine_valid_ioctls() in v4l2-dev.c they are enabled for
> all device types.

A patch fixing this is welcome!

> 6) VIDIOC_G/S_AUDIO: Shouldn't it be disabled in
> determine_valid_ioctls() for VBI devices ?

No. VBI devices still allow this. Strictly speaking it isn't useful for vbi
devices, but allowing G/S_INPUT but not G/S_AUDIO feels inconsistent to me.

While it isn't useful, it doesn't hurt either.

> Btw: function determine_valid_ioctls() in v4l2-dev.c is a good summary
> that explains which ioctls are suitable for which device types
> (radio/video/vbi).
> Converting its content into a table would be a great
> extension/clarifaction of the V4L2 API spec document !

We played around with the idea of 'profiles' where for each type of device
you have a table listing what can and cannot be done. The problem is time...

If you are interesting in pursuing this, then I am happy to help with advice
and pointers (v4l2-compliance is also a great source of information).

> Thanks for your patience !

My pleasure!

Regards,

	Hans
