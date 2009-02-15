Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:42166 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZBOXKR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 18:10:17 -0500
Date: Sun, 15 Feb 2009 15:09:54 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>, kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <49981C9F.7000305@redhat.com>
Message-ID: <Pine.LNX.4.58.0902151506220.24268@shell2.speakeasy.net>
References: <200902142048.51863.linux@baker-net.org.uk>
 <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu> <4997DB74.6000108@redhat.com>
 <200902151019.35555.hverkuil@xs4all.nl> <4997E05F.9080509@redhat.com>
 <Pine.LNX.4.58.0902150445490.24268@shell2.speakeasy.net> <49981C9F.7000305@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Feb 2009, Hans de Goede wrote:
> Trent Piepho wrote:
> > On Sun, 15 Feb 2009, Hans de Goede wrote:
> >> Hans Verkuil wrote:
> >>> On Sunday 15 February 2009 10:08:04 Hans de Goede wrote:
> >>>> kilgota@banach.math.auburn.edu wrote:
> >>>>> On Sat, 14 Feb 2009, Hans Verkuil wrote:
> >>>>>> On Saturday 14 February 2009 22:55:39 Hans de Goede wrote:
> >>>>>>> Adam Baker wrote:
> >>>>>> OK, make it a buffer flag. I've got to agree that it makes more sense
> >>>>>> to do
> >>>>>> it that way.
> >>>>>>
> >>>>> The most particular problem is that some of the cameras require byte
> >>>>> reversal of the frame data string, which would rotate the image 180
> >>>>> degrees around its center. Others of these cameras require reversal of
> >>>>> the horizontal lines in the image (vertical 180 degree rotation of the
> >>>>> image across a horizontal axis).
> >>>>>
> >>>>> The point is, one can not tell from the Vendor:Product number which of
> >>>>> these actions is required. However, one *is* able to tell immediately
> >>>>> after the camera is initialized, which of these actions is required.
> >>>>> Namely, one reads and parses the response to the first USB command sent
> >>>>> to the camera.
> >
> >>>> Ack, but the problem later was extended by the fact that it turns out
> >>>> some cams have a rotation detection (gravity direction) switch, which
> >>>> means you can flip the cam on its socket while streaming, and then the
> >>>> cam will tell you its rotation has changed, that makes this a per frame
> >>>> property rather then a static property of the cam. Which lead to this
> >>>> discussion, but we (the 2 Hans 's) agree now that using the flags field
> >>>> in the buffer struct is the best way forward. So there is a standard now,
> >>>> simply add 2 buffer flags to videodev2.h, one for content is h-flipped
> >>>> and one for content is v-flipped and you are done.
> >>> I think we should also be able to detect 90 and 270 degree rotations. Or at
> >>> the very least prepare for it. It's a safe bet to assume that webcams will
> >>> arrive that can detect portrait vs landscape orientation.
> >> Handling those (esp on the fly) will be rather hard as width and height then
> >> get swapped. So lets worry about those when we need to. We will need an
> >> additional flag for those cases anyways.
> >
> > Why would you need to worry about width and height getting swapped?
> > Meta-data about the frame would indicate it's now in portrait mode vs
> > landscape mode, but the dimentions would be unchanged.
>
> Yes, unless ofcourse you want to display a proper picture and not one on its
> side, when the camera is rotated 90 degrees, so somewere you need to rotate the
> picture 90 degrees, and the lower down in the stack you do that, the bigger the
> chance you do not need to duplicate the rotation code in every single app.
> however the app will mostlikely become unhappy when you start out pushing
> frames whith a changed width / height.

It seems that image rotation, like format conversion, is something that is
best done in userspace.  It could be done in hardware with opengl or faster
software using MMX or SSE based code that can't be used in the kernel.
