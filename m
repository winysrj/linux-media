Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753275AbdLNQtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 11:49:23 -0500
Date: Thu, 14 Dec 2017 14:49:11 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Daniel Mack <daniel@zonque.org>
Cc: Todor Tomov <todor.tomov@linaro.org>,
        "laurent.pinchart" <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: camss: camera controls missing on vfe interfaces
Message-ID: <20171214144911.5f36ccd3@vento.lan>
In-Reply-To: <b2ee60be-508f-bc16-5632-1bd0e694b6cc@zonque.org>
References: <79ac06f5-0c68-14d9-673c-7781881f81b8@zonque.org>
        <bc991d7c-e204-334a-1135-d10757405e08@zonque.org>
        <9ac5306d-c048-5d04-4ea9-2d5d08165350@linaro.org>
        <b2ee60be-508f-bc16-5632-1bd0e694b6cc@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 20 Nov 2017 11:59:59 +0100
Daniel Mack <daniel@zonque.org> escreveu:

> Hi Todor,
>=20
> Thanks for following up!
>=20
> On Monday, November 20, 2017 09:32 AM, Todor Tomov wrote:
> > On 15.11.2017 21:31, Daniel Mack wrote: =20
> >> Todor et all,
> >>
> >> Any hint on how to tackle this?
> >>
> >> I can contribute patches, but I'd like to understand what the idea is.
> >>
> >>
> >> Thanks,
> >> Daniel
> >>
> >>
> >> On Thursday, October 26, 2017 06:11 PM, Daniel Mack wrote: =20
> >>> Hi Todor,
> >>>
> >>> When using the camss driver trough one of its /dev/videoX device node=
s,
> >>> applications are currently unable to see the video controls the camera
> >>> sensor exposes.
> >>>
> >>> Same goes for other ioctls such as VIDIOC_ENUM_FMT, so the only valid
> >>> resolution setting for applications to use is the one that was
> >>> previously set through the media controller layer. Applications usual=
ly
> >>> query the available formats and then pick one using the standard V4L2
> >>> APIs, and many can't easily be forced to use a specific one.
> >>>
> >>> If I'm getting this right, could you explain what's the rationale her=
e?
> >>> Is that simply a missing feature or was that approach chosen on purpo=
se?
> >>> =20
> >=20
> > It is not a missing feature, it is more of a missing userspace implemen=
tation.
> > When working with a media oriented device driver, the userspace has to
> > config the media pipeline too and if controls are exposed by the subdev=
 nodes,
> > the userspace has to configure them on the subdev nodes.
> >=20
> > As there weren't a lot of media oriented drivers there is no generic
> > implementation/support for this in the userspace (at least I'm not awar=
e of
> > any). There have been discussions about adding such functionality in li=
bv4l
> > so that applications which do not support media configuration can still
> > use these drivers. I'm not sure if decision for this was taken or not or
> > is it just that there was noone to actually do the work. Probably Laure=
nt,
> > Mauro or Hans know more about what were the plans for this. =20
>=20
> Hmm, that's not good.
>=20
> Considering the use-case in our application, the pipeline is set up once
> and considered more or less static, and then applications such as the
> Chrome browsers make use of the high-level VFE interface. If there are
> no controls exposed on that interface, they are not available to the
> application. Patching all userspace applications is an uphill battle
> that can't be won I'm afraid.
>=20
> Is there any good reason not to expose the sensor controls on the VFE? I
> guess it would be easy to do, right?

Sorry for a late answer. I'm usually very busy on 4Q, but this year, it
was atypical.

A little historic is needed in order to answer this question.
Up to very recently, V4L2 drivers that are media-controller centric,=20
e. g. whose sub-devices are controlled directly by subdev devnodes,
were used only on specialized hardware, with special V4L2 applications
designed for them. In other words, it was designed to be used by generic
applications (although we always wanted a solution for it), and this
was never a real problem so far.

However, with the advent of cheap SoC hardware with complex media
processors on it, the scenario changed recently, and we need some
discussions upstream about the best way to solve it.

The original idea, back when the media controller was introduced,
were to add support at libv4l. But this never happened, and it turns
to be a way more complex than originally foreseen.

As you're pointing, on such scenarios, one alternative is to expose subdev
controls also to the /dev/video devnode that is controlling the pipeline
streaming. However, depending on the pipeline, this may not be possible,
as the same control could be implemented on more than on block inside
the pipeline. When such case happens, the proper solution is to pinpoint
what sub-device will handle the control via the subdev API.

However, on several scenarios (like, for instance, a RPi3 with
a single camera sensor), the pipeline is simple enough to either
avoid such conflicts, or to have an obvious subdevice that would
be handling such control.

=46rom my PoV, on cases like RPi3, the best is to just implement control
propagation inside the pipelines. However, other media core developers
think otherwise.

If you can provide us a broader view about what are the issues that
you're facing, what's your use case scenario and what are the pipelines,
this could be valuable for us to improve our discussions about the
best way to solve it.

Please notice, however, that this is not the best time for taking
such discussions, as several core developers will be taking
vacations those days.

Thanks,
Mauro
