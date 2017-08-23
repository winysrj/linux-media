Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56008 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753921AbdHWM3Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 08:29:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
Date: Wed, 23 Aug 2017 15:29:54 +0300
Message-ID: <2623469.qW6Q8oGARq@avalon>
In-Reply-To: <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com> <4fa22637-c58e-79e3-be22-575b0a4ff3f9@iki.fi> <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday, 23 August 2017 12:09:15 EEST Hans Verkuil wrote:
> On 08/04/17 20:25, Sakari Ailus wrote:
> > Niklas S=F6derlund wrote:
> >> On 2017-07-20 19:14:01 +0300, Sakari Ailus wrote:
> >>> On Wed, Jul 19, 2017 at 01:42:55PM +0200, Hans Verkuil wrote:
> >>>> On 18/07/17 21:03, Sakari Ailus wrote:
> >>>>> Hi folks,
> >>>>>=20
> >>>>> This RFC patchset achieves a number of things which I've put to the
> >>>>> same patchset for they need to be show together to demonstrate the =
use
> >>>>> cases.
> >>>>>=20
> >>>>> I don't really intend this to compete with Niklas's patchset but mu=
ch
> >>>>> of the problem area addressed by the two is the same.
> >>>>>=20
> >>>>> Comments would be welcome.
> >>>>>=20
> >>>>> - Add AS3645A LED flash class driver.
> >>>>>=20
> >>>>> - Add async notifiers (by Niklas).
> >>>>>=20
> >>>>> - V4L2 sub-device node registration is moved to take place at the s=
ame
> >>>>>   time with the registration of the sub-device itself. With this
> >>>>>   change, sub-device node registration behaviour is aligned with vi=
deo
> >>>>>   node registration.
> >>>>>=20
> >>>>> - The former is made possible by moving the bound() callback after
> >>>>>   sub-device registration.
> >>>>>=20
> >>>>> - As all the device node registration and link creation is done as =
the
> >>>>>   respective devices are probed, there is no longer dependency to t=
he
> >>>>>   notifier complete callback which as itself is seen problematic. T=
he
> >>>>>   complete callback still exists but there's no need to use it,
> >>>>>   pending changes in individual drivers.
> >>>>>  =20
> >>>>>   See:
> >>>>>   <URL:http://www.spinics.net/lists/linux-media/msg118323.html>
> >>>>>  =20
> >>>>>   As a result, if a part of the media device fails to initialise
> >>>>>   because it is e.g. physically broken, it will be possible to use
> >>>>>   what works.
> >>>>=20
> >>>> I've got major problems with this from a userspace point of view. In
> >>>> the vast majority of cases you just want to bail out if one or more
> >>>> subdevs fail.
> >>>
> >>> I admit it's easier for the user space if the device becomes available
> >>> only when all its component drivers have registered.
> >>>=20
> >>> Also remember that video nodes are registered in the file system right
> >>> on device probe time. It's only sub-device and media device node
> >>> registration that has taken place in the notifier's complete handler.
> >>=20
> >> Is this always the case? In the R-Car VIN driver I register the video
> >> devices using video_register_device() in the complete handler. Am I
> >> doing things wrong in that driver? I had a patch where I moved the
> >> video_register_device() call to probe time but it got shoot down in
> >> review and was dropped.
> >=20
> > I don't think the current implementation is wrong, it's just different
> > from other drivers; there's really no requirement regarding this AFAIU.
> > It's one of the things where no attention has been paid I presume.
>=20
> It actually is a requirement: when a device node appears applications can
> reasonably expect to have a fully functioning device. True for any device
> node.

Why not ? I'm not aware of any such kernel-wide requirement.=20

> You don't want to have to wait until some unspecified time before the full
> functionality is there.

We certainly should specify that time and give userspace a way to find out=
=20
what is usable and when.

> I try to pay attention to this when reviewing code, since not following t=
his
> rule basically introduces a race condition which is hard to test.
>=20
> > However doing anything that can fail earlier on would be nicer since
> > there's no reasonable way to signal an error from complete callback
> > either.
>=20
> Right.
>=20
> Adding support for cases where devices may not be present is very desirab=
le,
> but this should go through an RFC process first to hammer out all the
> details.
>=20
> Today we do not support this and we have to review code with that in mind.
>=20
> So the first async subnotifiers implementation should NOT support this
> (although it can of course be designed with this in mind).

I very much disagree. The first async subnotifiers implementation (and I st=
ill=20
believe we don't need subnotifiers, there's nothing "sub" in them) shall=20
support this. If it means we first have to hammer out the details of out it=
=20
will work, so be it.

> Once it is in we can start on an RFC on how to support partial pipelines.=
 I
> have a lot of questions about that that need to be answered first.
>=20
> One thing at a time. Trying to do everything at once never works.

Sure, so let's start with probe time device node registration, and then mov=
e=20
on to subnotifiers.

=2D-=20
Regards,

Laurent Pinchart
