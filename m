Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4204 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZBOJT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 04:19:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Adding a control for Sensor Orientation
Date: Sun, 15 Feb 2009 10:19:35 +0100
Cc: kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
References: <200902142048.51863.linux@baker-net.org.uk> <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu> <4997DB74.6000108@redhat.com>
In-Reply-To: <4997DB74.6000108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151019.35555.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 February 2009 10:08:04 Hans de Goede wrote:
> kilgota@banach.math.auburn.edu wrote:
> > On Sat, 14 Feb 2009, Hans Verkuil wrote:
> >> On Saturday 14 February 2009 22:55:39 Hans de Goede wrote:
> >>> Adam Baker wrote:
> >>>> Hi all,
> >>>>
> >>>> Hans Verkuil put forward a convincing argument that sensor
> >>>> orientation shouldn't be part of the buffer flags as then it would
> >>>> be unavailable to clients that use read()
> >>>
> >>> Yes and this is a bogus argument, clients using read also do not get
> >>> things like timestamps, and vital information like which field is in
> >>> the read buffer when dealing with interleaved sources. read() is a
> >>> simple interface for simple applications. Given that the only user of
> >>> these flags will likely be libv4l I *strongly* object to having this
> >>> info in some control, it is not a control, it is a per frame (on some
> >>> cams) information about how to interpret that frame, the buffer flags
> >>> is a very
> >>> logical place, *the* logical place even for this!
> >>>
> >>> The fact that there is no way to transport metadata about a frame
> >>> like flags, but also timestamp and field! Is a problem with the read
> >>> interface
> >>> in general, iow read() is broken wrt to this. If people care add some
> >>> ioctl or something which users of read() can use to get the buffer
> >>> metadata from the last read() buffer, stuffing buffer metadata in a
> >>> control (barf), because of read() brokenness is a very *bad* idea,
> >>> and won't work in general due to synchronization problems.
> >>>
> >>> Doing this as a control will be a pain to implement both at the
> >>> driver level, see the discussion this is causing, and in libv4l. For
> >>> libv4l this
> >>> will basicly mean polling the control. And hello polling is lame and
> >>> something from the 1980-ies.
> >>>
> >>> Please just make this a buffer flag.
> >>
> >> OK, make it a buffer flag. I've got to agree that it makes more sense
> >> to do
> >> it that way.
> >>
> >> Regards,
> >>
> >>     Hans
> >>
> >> --
> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >
> > Let me take a moment to remind everyone what the problem is that
> > brought this discussion up. Adam Baker and I are working on a driver
> > for a certain camera. Or, better stated, for a set of various cameras,
> > which all have the same USB Vendor:Product number. Various cameras
> > which all have this ID have different capabilities and need different
> > treatment of the frame data.
> >
> > The most particular problem is that some of the cameras require byte
> > reversal of the frame data string, which would rotate the image 180
> > degrees around its center. Others of these cameras require reversal of
> > the horizontal lines in the image (vertical 180 degree rotation of the
> > image across a horizontal axis).
> >
> > The point is, one can not tell from the Vendor:Product number which of
> > these actions is required. However, one *is* able to tell immediately
> > after the camera is initialized, which of these actions is required.
> > Namely, one reads and parses the response to the first USB command sent
> > to the camera.
> >
> > So, for us (Adam and me) the question is simply to know how everyone
> > will agree that the information about the image orientation can be sent
> > from the module to V4L. When this issue is resolved, we can finish
> > writing the sq905 camera driver. From this rather narrow point of view,
> > the issue is not which method ought to be adopted. Rather, the issue is
> > that no method has been adopted. It is rather difficult to write module
> > code which will obey a non-existent standard.
>
> Ack, but the problem later was extended by the fact that it turns out
> some cams have a rotation detection (gravity direction) switch, which
> means you can flip the cam on its socket while streaming, and then the
> cam will tell you its rotation has changed, that makes this a per frame
> property rather then a static property of the cam. Which lead to this
> discussion, but we (the 2 Hans 's) agree now that using the flags field
> in the buffer struct is the best way forward. So there is a standard now,
> simply add 2 buffer flags to videodev2.h, one for content is h-flipped
> and one for content is v-flipped and you are done.
>
> Regards,
>
> Hans

I think we should also be able to detect 90 and 270 degree rotations. Or at 
the very least prepare for it. It's a safe bet to assume that webcams will 
arrive that can detect portrait vs landscape orientation.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
