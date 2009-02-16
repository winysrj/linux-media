Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:33984 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZBPDzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 22:55:22 -0500
Date: Sun, 15 Feb 2009 19:55:20 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: kilgota@banach.math.auburn.edu
cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <alpine.LNX.2.00.0902151844340.1496@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.58.0902151926410.24268@shell2.speakeasy.net>
References: <200902142048.51863.linux@baker-net.org.uk>
 <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu> <4997DB74.6000108@redhat.com>
 <200902151019.35555.hverkuil@xs4all.nl> <4997E05F.9080509@redhat.com>
 <Pine.LNX.4.58.0902150445490.24268@shell2.speakeasy.net> <49981C9F.7000305@redhat.com>
 <Pine.LNX.4.58.0902151506220.24268@shell2.speakeasy.net>
 <alpine.LNX.2.00.0902151844340.1496@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Feb 2009 kilgota@banach.math.auburn.edu wrote:
> On Sun, 15 Feb 2009, Trent Piepho wrote:
> > On Sun, 15 Feb 2009, Hans de Goede wrote:
> >>>>> I think we should also be able to detect 90 and 270 degree rotations. Or at
> >>>>> the very least prepare for it. It's a safe bet to assume that webcams will
> >>>>> arrive that can detect portrait vs landscape orientation.
> >>>> Handling those (esp on the fly) will be rather hard as width and height then
> >>>> get swapped. So lets worry about those when we need to. We will need an
> >>>> additional flag for those cases anyways.
> >>>
> >>> Why would you need to worry about width and height getting swapped?
> >>> Meta-data about the frame would indicate it's now in portrait mode vs
> >>> landscape mode, but the dimentions would be unchanged.
> >>
> >> Yes, unless ofcourse you want to display a proper picture and not one on its
> >> side, when the camera is rotated 90 degrees, so somewere you need to rotate the
> >> picture 90 degrees, and the lower down in the stack you do that, the bigger the
> >> chance you do not need to duplicate the rotation code in every single app.
> >> however the app will mostlikely become unhappy when you start out pushing
> >> frames whith a changed width / height.
> >
> > It seems that image rotation, like format conversion, is something that is
> > best done in userspace.  It could be done in hardware with opengl or faster
> > software using MMX or SSE based code that can't be used in the kernel.
>
> 1. Everyone seems to agree that the kernel module itself is not going to
> do things like rotate or flip data even if a given supported device
> always needs that done.
>
> However, this decision has a consequence:
>
> 2. Therefore, the module must send the information about what is needed
> out of the module, to whatever place is going to deal with it. Information
> which is known to the module but unknown anywere else must be transmitted
> somehow.
>
> Now there is a further consequence:
>
> 3. In view of (1) and (2) there has to be a way agreed upon for the module
> to pass the relevant information onward.
>
> It is precisely on item 3 that we are stuck right now. There is an
> immediate need, not a theoretical need but an immediate need. However,
> there is no agreed-upon method or convention for communication.

There are already controls being added for HFLIP, VFLIP, and rotation, so
that's certainly one way.  They're being added as writable controls for
someone's hardware that can do these image manipulations.  But it seems
like a different driver could just as easily provide them as read-only
controls to inform software that it has a non-standard image layout.

It sounds like per frame rotation metadata would be useful for cameras that
have an orientation sensor.

> problems are not so very related at all. As I understand, it is visualized
> that a camera could be put on a pivot, with control mechanism which would
> permit various rotations and then the question becomes how to support a
> camera and to make the stream come out "right" no matter which way the

I think we already have controls for camera motors, i.e. pan, tilt, and
rotation.  That's totally different.
