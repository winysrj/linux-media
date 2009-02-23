Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:33742 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbZBWAT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 19:19:58 -0500
Date: Sun, 22 Feb 2009 16:19:57 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans de Goede <hdegoede@redhat.com>
cc: kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
In-Reply-To: <49A1DF50.1080903@redhat.com>
Message-ID: <Pine.LNX.4.58.0902221603410.24268@shell2.speakeasy.net>
References: <200902180030.52729.linux@baker-net.org.uk>
 <200902211253.58061.hverkuil@xs4all.nl> <49A13466.5080605@redhat.com>
 <alpine.LNX.2.00.0902221225310.10870@banach.math.auburn.edu>
 <49A1A03A.8080303@redhat.com> <alpine.LNX.2.00.0902221334310.10870@banach.math.auburn.edu>
 <49A1CA5B.5000407@redhat.com> <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net>
 <49A1D7B2.5070601@redhat.com> <Pine.LNX.4.58.0902221504410.24268@shell2.speakeasy.net>
 <49A1DF50.1080903@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009, Hans de Goede wrote:
> Trent Piepho wrote:
> > On Sun, 22 Feb 2009, Hans de Goede wrote:
> >> Trent Piepho wrote:
> >>> On Sun, 22 Feb 2009, Hans de Goede wrote:
> >>>> Yes that is what we are talking about, the camera having a gravity switch
> >>>> (usually nothing as advanced as a gyroscope). Also the bits we are talking
> >>>> about are in a struct which communicates information one way, from the camera
> >>>> to userspace, so there is no way to clear the bits to make the camera do something.
> >>> First, I'd like to say I agree with most that the installed orientation of
> >>> the camera sensor really is a different concept than the current value of a
> >>> gravity sensor.  It's not necessary, and maybe not even desirable, to
> >>> handle them in the same way.
> >>>
> >>> I do not see the advantage of using reserved bits instead of controls.
> >>>
> >>> The are a limited number of reserved bits.  In some structures there are
> >>> only a few left.  They will run out.  Then what?  Packing non-standard
> >>> sensor attributes and camera sensor meta-data into a few reserved bits is
> >>> not a sustainable policy.
> >>>
> >>> Controls on the other card are not limited and won't run out.
> >>>
> >> Yes but these things are *not* controls, end of discussion. The control API is
> >> for controls, not to stuff all kind of cruft in.
> >
> > All kind of cruft belongs in the reserved bits of whatever field it can be
> > stuffed in?
>
> Not whatever field, these are input properties which happen to also be pretty
> binary so putting them in the input flags field makes plenty of sense.
>
> > What is the difference?  Why does it matter?  Performance?  Maintenance?
> > Is there something that's not possible?  I do not find "end of discussion"
> > to be a very convincing argument.
>
> Well they are not controls, that is the difference, the control interface is
> for controls (and only for controls, end of discussion if you ask me). These
> are not controls but properties, they do not have a default min and max value,

Camera pivot sensor ranges from 0 to 270.  How is that not a min and max?

> they have only one *unchanging* value, there  is nothing the application can

Camera sensors don't have an unchanging value.

And who says scan order can't change?  Suppose the camera returns raw bayer
format data top to bottom, but if you request yuv then an image processing
section needs to kick in and that returns the data bottom to top.

> control / change. It has been suggested to make them readonly, but that does
> not fix the ugliness. A proper written v4l2 application will enumerate all the
> controls, and then the user will see a grayed out control saying: "your cam is
> upside down" what is there to control ? will this be a grayed out slider? or a
> grayed out checkbox "your cam is upside down", or maybe a not grayed out
> dropdown: where the user can select: "my sensor is upside down", "I deny my
> sensor is upside down", "I don't care my sensor is upside down", "WTF is this
> doing in my webcam control panel?", "nwod edispu si rosnes yM"

Why is there a read-only flag for controls if the concept is so mind
blowing to users?  Have there been complaints about it?

> Do you know I have an idea, lets get rid of the S2 API for DVB and put all that
> in controls too. Oh, and think like standards for video formats, surely that
> can be a control too, and ... and, ...

Good point.  The S2 API is much more like the control interface than the
previous API.  Enumerated attributes which can be set one at a time or in
groups.  More can be added.  There is some meta data about them.  The old
API used the a limited number of fixed structs, a few reserved bits, no
meta-data, and a query/set everything at once API.

I think the camera meta-data and camera sensor API should look more like
S2.
