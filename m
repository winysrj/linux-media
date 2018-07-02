Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40246 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbeGBMYj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 08:24:39 -0400
Date: Mon, 2 Jul 2018 09:24:34 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [RFC] Make entity to interface links immutable
Message-ID: <20180702092434.45122d73@coco.lan>
In-Reply-To: <99caf821-16f9-baa9-4e97-36d91e25d1ac@xs4all.nl>
References: <354b01c0-6825-4302-a1f4-d120cf8c34e3@xs4all.nl>
        <20180702064116.401a244e@coco.lan>
        <99caf821-16f9-baa9-4e97-36d91e25d1ac@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 2 Jul 2018 12:38:23 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/07/18 11:41, Mauro Carvalho Chehab wrote:
> > Em Mon, 2 Jul 2018 10:18:37 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >  =20
> >> While working on v4l2-compliance I noticed that entity to interface li=
nks
> >> have just the MEDIA_LNK_FL_ENABLED flag set.
> >>
> >> Shouldn't we also set the MEDIA_LNK_FL_IMMUTABLE? After all, you canno=
t change
> >> an entity-interface link. It feels inconsistent not to have this flag.=
 =20
> >=20
> > It could make sense for non-hybrid devices, but this may not be true
> > for hybrid ones. See below.
> >  =20
> >> I also propose that media_create_intf_link() drops the last flags argu=
ment:
> >> it can set the link flags directly since they are always the same anyw=
ay. =20
> >=20
> > When we came with this design, the idea is that an interface can be=20
> > disabled/enabled at runtime, if the entity it links can't be used,
> > because the hardware is busy doing something else.=20
> >=20
> > That could happen with hybrid devices, where the analog part could
> > be consuming resources that would be needed for the digital part.
> >=20
> > Disabling the link at runtime has an advantage that it makes easier
> > to check - as open() syscalls could just use it to return -EBUSY,
> > instead of doing a complete graph analysis. Also, applications can
> > test it directly, in order to have a hint if a device is ready for
> > usage.
> >=20
> > That was one of the approaches we considered at the design, but I
> > don't remember if Shuah's patch series actually used it or not,
> > as I don't look at her pending patches for a long time. I suspect
> > she took a different approach.
> >=20
> > Anyway, before touching it, I'd like to see her patches merged,
> > and do some tests with real case scenarios before changing it. =20
>=20
> Hmm, this also highlights another deficiency in the spec. Currently
> the description of IMMUTABLE says:
>=20
> "The link enabled state can=E2=80=99t be modified at runtime. An immutabl=
e link
>  is always enabled."
>=20
> But in the plan above the link can change, but only the driver can
> enable/disable the link. It makes no sense AFAICS for userspace to
> enable/disable an interface link.
>=20
> If I am right that it makes no sense for userspace to disable an interface
> link, then we should update the spec to clarify that this is not allowed
> (in fact, it is not possible today anyway). And we should also clarify
> that the driver can disable an interface link and what that means.
>=20
> If userspace CAN in some circumstances disable an interface link, then
> we need to add something like a READ_ONLY flag to signal whether or not
> userspace can change an interface link. If it is READ_ONLY, then only the
> driver can change that.

Yes, this makes sense.

>=20
> That said, given that today there are no drivers that disable an interface
> link, I still think that we should mark them all as IMMUTABLE. That flag
> can be removed when we actually let drivers change this.

Ok, let's do this, but without touching at the media_create_intf_link(),
as we need first to apply Shuah's patch, and see how we'll handle,
before start stripping code that will probably be needed.

>=20
> It would be consistent with the current usage of interface links.
>=20
> Regards,
>=20
> 	Hans



Thanks,
Mauro
