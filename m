Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3177 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZG2PIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jul 2009 11:08:40 -0400
Message-ID: <cb2af7c6ef118cb5fe1fab2720ec7973.squirrel@webmail.xs4all.nl>
In-Reply-To: <20090729114211.065ed01f@pedra.chehab.org>
References: <20090718173758.GA32708@localhost.localdomain>
    <20090729000753.GA24496@localhost.localdomain>
    <20090729015730.34ab86c6@pedra.chehab.org>
    <200907290809.32089.hverkuil@xs4all.nl>
    <20090729094009.6dc01728@pedra.chehab.org>
    <7aa4c771a5b1cf3117cf9faf027cc05c.squirrel@webmail.xs4all.nl>
    <20090729114211.065ed01f@pedra.chehab.org>
Date: Wed, 29 Jul 2009 17:08:31 +0200
Subject: Re: [PATCH] em28xx: enable usb audio for plextor px-tv100u
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Em Wed, 29 Jul 2009 15:14:22 +0200
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
>
>>
>> > Em Wed, 29 Jul 2009 08:09:31 +0200
>> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>> >
>> >> On Wednesday 29 July 2009 06:57:30 Mauro Carvalho Chehab wrote:

<snip>

>> >> > Hans,
>> >> >
>> >> > we need to fix the returned error value for v4l2_device_call_all().
>> I
>> >> > know that this is an old issue that weren't changed by v4l
>> dev/subdev
>> >> > conversion, but now it is easier for us to fix. The idea here is to
>> be
>> >> > sure that, if a sub-driver with a proper handling for a function
>> >> returns
>> >> > an error value, this would be returned by v4l2_device_call_all().
>> >> Maybe
>> >> > we'll need to adjust some things at the sub-drivers.
>> >>
>> >> Use v4l2_device_call_until_err instead of v4l2_device_call_all. That
>> >> macro
>> >> checks for errors returned from the subdevs.
>> >
>> > It doesn't work as expected. If I use it for queryctl, for example, it
>> > returns
>> > an empty set of controls. If I use it for g_ctrl, it returns:
>> >
>> > error 22 getting ctrl Brightness
>> > error 22 getting ctrl Contrast
>> > error 22 getting ctrl Saturation
>> > error 22 getting ctrl Hue
>> > error 22 getting ctrl Volume
>> > error 22 getting ctrl Balance
>> > error 22 getting ctrl Bass
>> > error 22 getting ctrl Treble
>> > error 22 getting ctrl Mute
>> > error 22 getting ctrl Loudness
>> >
>> > The issue here is we need something that discards errors for
>> > non-implemented
>> > controls.
>> >
>> > As the sub-drivers are returning -EINVAL for non-implemented controls
>> (and
>> > probably other stuff that aren't implemented there), the function will
>> not
>> > work
>> > for some ioctls.
>> >
>> > The proper fix seems to elect an error condition to be returned by
>> driver
>> > when
>> > a function is not implemented, and such errors to be discarded by the
>> > macro.
>> >
>> > It seems that the proper error code for such case is this one:
>> >
>> > #define ENOSYS          38      /* Function not implemented */
>>
>> You are right, this macro doesn't work for these control functions. It
>> it
>> is possible to implement a define like ENOSYS, but I prefer to work on
>> generic control processing code that is embedded in the v4l2 framework.
>> It
>> looks like I'll finally have time to work on that this weekend.
>
>
> I did some tests here: if we replace -EINVAL with -ENOIOCTLCMD, we can
> properly
> make v4l2_device_call_until_err() to work, fixing the lack of a proper
> error
> report at the drivers. This error code seems also appropriate for this
> case.

This is not sufficient: v4l2_device_call_until_err is not really suitable
for this. This would be better:

#define __v4l2_device_call_subdevs_ctrls(v4l2_dev, cond, o, f, args...) \
({                                                                      \
        struct v4l2_subdev *sd;                                         \
        long err = 0;                                                   \
                                                                        \
        list_for_each_entry(sd, &(v4l2_dev)->subdevs, list) {           \
                if ((cond) && sd->ops->o && sd->ops->o->f)              \
                        err = sd->ops->o->f(sd , ##args);               \
                if (err && err != -ENOIOCTLCMD)                         \
                        break;                                          \
        }                                                               \
        (err == -ENOIOCTLCMD) ? -EINVAL : err;                          \
})

This way -EINVAL is returned if the control isn't handled anywhere.

>
> This means several trivial patches on each v4l device driver, just
> replacing
> the error codes for 3 ioctl handlers (s_ctrl, g_ctrl, queryctrl).
>
> I'll try to write such patches for v4l devices, since I want to get rid of
> this
> bug on 2.6.31, at least on em28xx driver. If I have more time, I'll fix
> other
> bridge drivers as well.

Keep in mind that changing this for one i2c driver will mean that you have
to check its behavior on all v4l2 drivers that use that i2c driver.

>> Currently the control handling code in our v4l drivers is, to be blunt,
>> a
>> pile of crap. And it is ideal to move this into the v4l2 framework since
>> 90% of this is common code.
>
> Hmm, except for a few places that still implement this at the old way,
> most of
> the common code is already at v4l2 core. So, I'm not sure what you're
> referring.

Just to name a few:

1) Range checking of the control values.
2) Generic handling of QUERYCTRL/QUERYMENU including standard support for
the V4L2_CTRL_FLAG_NEXT_CTRL.
3) Generic handling of the VIDIOC_G/S/TRY_EXT_CTRLS ioctls so all drivers
can handle them.
4) Controls that are handled in subdevs should be automatically detected
by the core so that they are enumerated correctly.

There really is no support for this in the core, except for some utility
functions in v4l2-common.c.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

