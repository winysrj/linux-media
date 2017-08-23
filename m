Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56097 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbdHWNc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 09:32:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
Date: Wed, 23 Aug 2017 16:32:59 +0300
Message-ID: <2527773.X8ITGxLV3s@avalon>
In-Reply-To: <20170823125909.GA12099@bigcity.dyn.berto.se>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com> <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl> <20170823125909.GA12099@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wednesday, 23 August 2017 15:59:10 EEST Niklas S=F6derlund wrote:
> On 2017-08-23 11:09:15 +0200, Hans Verkuil wrote:
> > On 08/04/17 20:25, Sakari Ailus wrote:
> >> Niklas S=F6derlund wrote:
> >>> On 2017-07-20 19:14:01 +0300, Sakari Ailus wrote:
> >>>> On Wed, Jul 19, 2017 at 01:42:55PM +0200, Hans Verkuil wrote:
> >>>>> On 18/07/17 21:03, Sakari Ailus wrote:
> >>>>>> Hi folks,
> >>>>>>=20
> >>>>>> This RFC patchset achieves a number of things which I've put to the
> >>>>>> same patchset for they need to be show together to demonstrate the
> >>>>>> use cases.
> >>>>>>=20
> >>>>>> I don't really intend this to compete with Niklas's patchset but
> >>>>>> much of the problem area addressed by the two is the same.
> >>>>>>=20
> >>>>>> Comments would be welcome.
> >>>>>>=20
> >>>>>> - Add AS3645A LED flash class driver.
> >>>>>>=20
> >>>>>> - Add async notifiers (by Niklas).
> >>>>>>=20
> >>>>>> - V4L2 sub-device node registration is moved to take place at the
> >>>>>>   same time with the registration of the sub-device itself. With
> >>>>>>   this change, sub-device node registration behaviour is aligned
> >>>>>>   with video node registration.
> >>>>>>=20
> >>>>>> - The former is made possible by moving the bound() callback after
> >>>>>>   sub-device registration.
> >>>>>>=20
> >>>>>> - As all the device node registration and link creation is done as
> >>>>>>   the respective devices are probed, there is no longer dependency
> >>>>>>   to the notifier complete callback which as itself is seen
> >>>>>>   problematic. The complete callback still exists but there's no
> >>>>>>   need to use it, pending changes in individual drivers.
> >>>>>>  =20
> >>>>>>   See:
> >>>>>>   <URL:http://www.spinics.net/lists/linux-media/msg118323.html>
> >>>>>>  =20
> >>>>>>   As a result, if a part of the media device fails to initialise
> >>>>>>   because it is e.g. physically broken, it will be possible to use
> >>>>>>   what works.
> >>>>>=20
> >>>>> I've got major problems with this from a userspace point of view. In
> >>>>> the vast majority of cases you just want to bail out if one or more
> >>>>> subdevs fail.
> >>>>
> >>>> I admit it's easier for the user space if the device becomes availab=
le
> >>>> only when all its component drivers have registered.
> >>>>=20
> >>>> Also remember that video nodes are registered in the file system rig=
ht
> >>>> on device probe time. It's only sub-device and media device node
> >>>> registration that has taken place in the notifier's complete handler.
> >>>=20
> >>> Is this always the case? In the R-Car VIN driver I register the video
> >>> devices using video_register_device() in the complete handler. Am I
> >>> doing things wrong in that driver? I had a patch where I moved the
> >>> video_register_device() call to probe time but it got shoot down in
> >>> review and was dropped.
> >>=20
> >> I don't think the current implementation is wrong, it's just different
> >> from other drivers; there's really no requirement regarding this AFAIU.
> >> It's one of the things where no attention has been paid I presume.
> >=20
> > It actually is a requirement: when a device node appears applications c=
an
> > reasonably expect to have a fully functioning device. True for any devi=
ce
> > node. You don't want to have to wait until some unspecified time before
> > the full functionality is there.
> >=20
> > I try to pay attention to this when reviewing code, since not following
> > this rule basically introduces a race condition which is hard to test.
>=20
> In the latest version of the R-Car VIN series I have now moved the video
> device registration to happen at probe time... So I think it would be a
> good time to clarify what and what is not the intended way of where this
> can happen. I'm not keen on reworking that series for each time it's
> posted to where the video device is registered :-) I can see both good
> and bad things with both solutions.

I agree, let's get to the bottom of this issue.

> If the video device is registered in the complete callback it do make it
> easier to spot some race conditions (my VIN series got review comments
> where I missed this almost instantly).

I'm not sure I agree with that. It removes several potential race condition=
s,=20
but I don't see how it makes it easier to spot any of them.

> It is also clear to user-space when a device is ready to be used. At the
> same time as Sakari points out this prevents partially complete graphs wh=
ich
> might contain a valid pipeline to be able to function, which of these two
> behaviors is the most opportune I assume differs with use-cases and which
> one is best from a framework point of view I don't know.

=46or drivers that support pipelines with multiple sources I don't think th=
ere's=20
any disagreement. We need to support partial pipelines, and thus need to=20
register video nodes at probe time. The case that we're debating here is vd=
ev-
centric drivers that expose a single video node and no subdev-node, and hav=
e a=20
single source. Is there a general agreement on this ?

> But I do know that if a video device is registered from the complete
> callback it's reasonable that it should be unregistered if the unbind
> callback is called, right?

I don't see any other way it could work in that case, do I'd say yes.

> Else the same situation as registering it at probe time is reached if a
> subdevice is ever unbound and the driver needs to handle the corner cases=
 of
> both situations. And this use-case is today broken in v4l2! If a video
> device is registered in the complete callback, unregistered in the unbind
> callback and later re-registered in the complete callback once the subdev=
ice
> is re-bound everything blows up with
>=20
>   kobject (eb3be918): tried to init an initialized object, something is
> seriously wrong.

That's because reusing a struct device is wrong. In this case the video_dev=
ice=20
structure needs to be allocated dynamically at .complete() time, and=20
unregistered at .unbind() time. It will then be freed from its .release()=20
handler when the last reference will disappear, which could be way after th=
e=20
subdev is unbound or even rebound. In the latter case two struct video_devi=
ce=20
will coexist for some time.

> But yes if the video device is registered at probe time there are more
> races and object life-time issues for the driver to handle, but these
> needs to be considered anyhow if the unbind/re-bind scenario is to be
> fixed, right?

I believe so.

> So maybe it don't really matter where the video device is registered and
> both methods should be allowed and documented (so all drivers returns same
> -ENOSUBDEVBOUNDYET etc) and leave it up to each driver to handle this for
> how it perceives it primary use-case to be?

I have no strong opinion on whether the decision should be left to driver=20
authors, but I believe we should have at least the option of registering vi=
deo=20
device nodes a probe time.

> And instead we should talk about how to fix the bind/unbind issues as this
> is where IMHO where the real problem is.

That I agree with. There's so many object lifetime management issues in V4L=
2=20
that it's hard not to run into one of them during development (as proved ag=
ain=20
but this mail thread :-)). For me this is the number one priority. I'm work=
ing=20
on it with Sakari this afternoon.

> >> However doing anything that can fail earlier on would be nicer since
> >> there's no reasonable way to signal an error from complete callback
> >> either.
> >=20
> > Right.
> >=20
> > Adding support for cases where devices may not be present is very
> > desirable, but this should go through an RFC process first to hammer out
> > all the details.
> >=20
> > Today we do not support this and we have to review code with that in mi=
nd.
> >=20
> > So the first async subnotifiers implementation should NOT support this
> > (although it can of course be designed with this in mind). Once it is in
> > we can start on an RFC on how to support partial pipelines. I have a lot
> > of questions about that that need to be answered first.
> >=20
> > One thing at a time. Trying to do everything at once never works.

=2D-=20
Regards,

Laurent Pinchart
