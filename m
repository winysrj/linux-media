Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4120 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZBGRy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Feb 2009 12:54:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: libv4l and HFLIP / VFLIP again
Date: Sat, 7 Feb 2009 18:54:29 +0100
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Olivier Lorin <o.lorin@laposte.net>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	kilgota@banach.math.auburn.edu,
	"Jean-Francois Moine" <moinejf@free.fr>
References: <200902071715.24282.linux@baker-net.org.uk>
In-Reply-To: <200902071715.24282.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071854.29637.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 February 2009 18:15:24 Adam Baker wrote:
> Hi All,
>
> Now that the SQ-905 driver has been accepted into the gspca tree it is
> time to consider how best to address passing the sensor orientation from
> the driver to libv4l.
>
> For this camera the approach taken so far of knowing what orientation is
> needed based on the USB ID won't work as there are variants of the camera
> with different sensor orientation but the same ID. The driver can detect
> this based on some initialisation messages but needs to tell libv4l.
>
> For SQ-905 the orientation will remain fixed but we know there exist
> cameras that provide some form of tilt switch to detect orientation so
> the adopted solution should be able to cope with those too.
>
> Olivier Lorin has proposed a solution to this problem that involves using
> 2 new bits in v4l2_buffer->flags and has offered a patch for libv4l to
> add support for the 180 degree rotation case.
>
> Does anyone have a suggestion for a better way to address this problem?
> If not I'll prepare a patch to add the flags to include/linux/videodev2.h
> and one to set them in sq905.c.

Well, since you ask :-)

I think doing this in the v4l2_buffer flags is not quite the right place. 
Basically a high-level property (sensor orientation) is reported in a very 
low-level flags field.

Personally I would prefer to see a SENSOR_ORIENTATION (or something similar) 
read-only control that libv4l could read X seconds or so when capturing. 
Besides, using v4l2_buffer will not work if you use the read() interface. 
And as an end-user I am actually interested in seeing what the orientation 
is.

Regards,

	Hans

> After that I'll work on expanding Olivier Lorin's patch to
> 1) Ignore the flag from the driver for cameras listed in v4lconvert_flags
> (otherwise as the kernel driver doesn't currently set the flag for those
> cameras the change would be incompatible with current kernels for those
> cameras).
> 2) support independent setting of HFLIP  and VFLIP (some SQ-905 cameras
> need only VFLIP).
>
> And finally add the flags in the kernel drivers for the cameras listed in
> v4lconvert_flags so that eventually (once we are confident no-one running
> 2.6.29 will want a new libv4l) that functionality can be removed from
> libv4l.
>
> What is the preferred version of libv4l to prepare patches against? Is it
> http://linuxtv.org/hg/~hgoede/v4l-dvb
>
> Adam Baker
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
