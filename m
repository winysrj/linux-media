Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3487 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZBNVEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 16:04:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Adam Baker <linux@baker-net.org.uk>
Subject: Re: Adding a control for Sensor Orientation
Date: Sat, 14 Feb 2009 22:04:33 +0100
Cc: linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu,
	Olivier Lorin <o.lorin@laposte.net>,
	Hans de Goede <hdegoede@redhat.com>
References: <200902142048.51863.linux@baker-net.org.uk>
In-Reply-To: <200902142048.51863.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142204.33805.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 21:48:51 Adam Baker wrote:
> Hi all,
>
> Hans Verkuil put forward a convincing argument that sensor orientation
> shouldn't be part of the buffer flags as then it would be unavailable to
> clients that use read() so it looks like implementing a read only control
> is the only appropriate option.
>
> It seems that Sensor Orientation is an attribute that many cameras may
> want to expose so it shouldn't be a private control. Olivier Lorin's
> example patch created a new CAMERA_PROPERTIES class. I'm not sure that a
> new class is really justified so would like to hear other views on where
> the control should live (and also if everyone is happy with Hans
> Verkuil's suggested name of SENSOR_ORIENTATION which I prefer to Olivier
> Lorin's SENSOR_UPSIDE_DOWN as we want to represent HFLIP and VFLIP as
> well as upside down (which as currently implemented means 180 degree
> rotation.))
>
> Assuming that it is considered inappropriate to add a new control as
> an "Old-style 'user' control" then it is also, I presume, necessary to
> extend gspca to support VIDIOC_G_EXT_CTRLS as at the moment it requires
> all control access to use VIDIOC_G_CTRL. Would doing this conflict with
> anything anyone else may be working on such as conversion to use
> v4l2_device.
>
> Thoughts please.

This is definitely a camera control, so I guess you need to add this new 
camera control and the g_ext_ctrls ioctl. It's a bit overkill, and I have 
lots of ideas on how to drastically improve control handling in drivers, 
but that's a few months in the future once all drivers are converted to 
v4l2_device. Hmm, if you are working in gspca anyway, are you interested in 
adding v4l2_device to it? It's trivial for that driver.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
