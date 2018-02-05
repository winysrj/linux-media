Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36899 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752260AbeBEM1j (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 07:27:39 -0500
Date: Mon, 5 Feb 2018 10:27:32 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MEDIA_IOC_G_TOPOLOGY and pad indices
Message-ID: <20180205102732.617c3007@vento.lan>
In-Reply-To: <2768029.GcpMBOxS6Y@avalon>
References: <336b3d54-6c59-d6eb-8fd8-e0a9677c7f5f@xs4all.nl>
        <2979437.fEFkWIelBg@avalon>
        <7773f8ac-32b8-4199-4b4c-05657dd0bb37@xs4all.nl>
        <2768029.GcpMBOxS6Y@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 04 Feb 2018 15:20:55 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Hans,
>=20
> On Sunday, 4 February 2018 15:16:26 EET Hans Verkuil wrote:
> > On 02/04/2018 02:13 PM, Laurent Pinchart wrote: =20
> > > On Sunday, 4 February 2018 15:06:42 EET Hans Verkuil wrote: =20
> > >> Hi Mauro,
> > >>=20
> > >> I'm working on adding proper compliance tests for the MC but I think
> > >> something is missing in the G_TOPOLOGY ioctl w.r.t. pads.
> > >>=20
> > >> In several v4l-subdev ioctls you need to pass the pad. There the pad=
 is
> > >> an index for the corresponding entity. I.e. an entity has 3 pads, so=
 the
> > >> pad argument is [0-2].
> > >>=20
> > >> The G_TOPOLOGY ioctl returns a pad ID, which is > 0x01000000. I can'=
t use
> > >> that in the v4l-subdev ioctls, so how do I translate that to a pad i=
ndex
> > >> in my application?
> > >>=20
> > >> It seems to be a missing feature in the API. I assume this informati=
on is
> > >> available in the core, so then I would add a field to struct media_v=
2_pad
> > >> with the pad index for the entity.
> > >>=20
> > >> Next time we add new public API features I want to see compliance te=
sts
> > >> before accepting it. It's much too easy to overlook something, eithe=
r in
> > >> the design or in a driver or in the documentation, so this is really,
> > >> really needed IMHO. =20
> > >=20
> > > I agree with you, and would even like to go one step beyond by requir=
ing
> > > an implementation in a real use case, not just in a compliance or test
> > > tool.

We could require an open source real application and some hardware to
allow us to test new APIs before allowing adding them, but I suspect that
this will just stall the development, as, on most companies, one development
team work on writing a new Kernel feature. Once done, a separate team
starts to implement userspace tools. On embedded world, this doesn't even
envolve writing any open source apps.

> > > On the topic of the G_TOPOLOGY API, it's pretty clear it was merged t=
oo
> > > hastily. We could try to fix it, but given all the issues we haven't
> > > solved yet, I believe a new version of the API would be better. =20
> >=20
> > It's actually not too bad as an API speaking as an end-user. It's simpl=
e and
> > efficient. But this pad issue is a real problem. =20
>=20
> We have other issues such as connector support

The thing with connector is unrelated with the API that reports entities.
=46rom API PoV, a connector is just a new entity type.=20

The discussions around it were purely related about how to deal with the
case where a single physical connector carries multiple signals on it,=20
but require different settings, depending on how this is physically wired.

This is a very common problem with S-Video connectors
(MEDIA_ENT_F_CONN_SVIDEO), as lots of boards are shipped with a cable to=20
allow using a S-Video input for composite video.

At proprietary software that comes with those boards, it identifies a
single S-Video connector as if they were two different physical connectors
(e. g. it looks at the final connector after the cabling).

In other words S-Video input physical connectors at the board can be used
on two different scenarios:

1) using S-Video/S-Video cable, using 4 pins, 2 for chrominance, 2 for
   luminance. The end connector is a S-Video plug.

2) using a S-Video to composite video cable, using just 2 pins of the
   board input connector. The end connector is RCA composite plug.

There are even some scenarios (very common on Hauppauge devices) where
a single multiple pin proprietary connector has multiple physical
connectors at their ends for both Audio and Video. Among them, there
is a separate S-Video plug and a separate Composite RCA plug.
On such cables, the Composite connector is usually physically wired
to the S-Video Y signal, just like if it had a S-Video to composite
cable.

Depending if the physical connector is connected using a S-Video/S-Video
or a S-Video/Composite cable, the settings at the driver should be
different (not only enabling input pins but also changing some demod
parameters in order to provide enhanced quality for S-Video).

So, while physically there is just one connector at the board, logically,=20
there are two different V4L2 device/subdev settings, depending on the type
of cable/signals connected to it.

Any way, such discussion is completely orthogonal to G_TOPOLOGY.
No matter what API we use, we should have a way to allow userspace
to select between "S-Video" and "composite" on devices that provide
S-Video physical connectors.

As discussed, the main alternatives are:

1) Have one pad for Y signal and one pad for C signal.

If both are linked to a S-Video connector, it is in S-Video mode.
If just Y signal is linked, it is in composite mode.

2) Have one pad for S-Video, one pad for Composite.

If composite pad is linked to a S-Video connector, it is composite;
if s-video pad is linked to a S-Video connector, it is S-Video.

We didn't reach a consensus if either (1) or (2) would be the better
alternative. The main reason for not reaching a consensus is how
to map it to DT. So, it was decided to not expose connectors:

	93125094c07d ("[media] media.h: postpone connectors entities")

Once we reach an agreement, all we need is to revert the above
patch and adjust the drivers that use MEDIA_ENT_F_CONN_SVIDEO to
do the right thing. That won't affect the ioctl.

> and entities function vs. types that we have never solved.

Huh? This was solved. The legacy API was per type, while G_TOPOLOGY is=20
per function.

What we don't have yet is a case where a single entity provide multiple
functions. Nobody ever submitted any patchset covering such scenario.=20

What it was agreed is that, if we ever have have such kind of entities,
the other functions would be exposed via the properties API.

> The G_TOPOLOGY ioctl moves in the right direction=20
> but has clearly been merged too early. It might be possible to fix it, I=
=20
> haven't checked yet, but I really don't want to see this mistake being=20
> repeated in the future.

Thanks,
Mauro
