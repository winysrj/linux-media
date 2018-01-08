Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45731 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754169AbeAHR5Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 12:57:24 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 21/28] rcar-vin: add group allocator functions
Date: Mon, 08 Jan 2018 19:57:53 +0200
Message-ID: <1681465.QYWytPgN3R@avalon>
In-Reply-To: <20180108172447.GD23075@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <2338267.IAVXeh1rRr@avalon> <20180108172447.GD23075@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Monday, 8 January 2018 19:24:47 EET Niklas S=F6derlund wrote:
> On 2017-12-08 22:12:56 +0200, Laurent Pinchart wrote:
> > On Friday, 8 December 2017 03:08:35 EET Niklas S=F6derlund wrote:
> >> In media controller mode all VIN instances needs to be part of the same
> >> media graph. There is also a need to each VIN instance to know and in
> >> some cases be able to communicate with other VIN instances.
> >>=20
> >> Add an allocator framework where the first VIN instance to be probed
> >> creates a shared data structure and creates a media device.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/rcar-core.c | 179 +++++++++++++++++++=
++-
> >>  drivers/media/platform/rcar-vin/rcar-vin.h  |  38 ++++++
> >>  2 files changed, 215 insertions(+), 2 deletions(-)
> >>=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> >> b/drivers/media/platform/rcar-vin/rcar-core.c index
> >> 45de4079fd835759..a6713fd61dd87a88 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-core.c

[snip]

> >> +static struct rvin_group *__rvin_group_allocate(struct rvin_dev *vin)
> >> +{
> >> +	struct rvin_group *group;
> >> +
> >> +	if (rvin_group_data) {
> >> +		group =3D rvin_group_data;
> >> +		kref_get(&group->refcount);
> >> +		vin_dbg(vin, "%s: get group=3D%p\n", __func__, group);
> >> +		return group;
> >> +	}
> >> +
> >> +	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> >> +	if (!group)
> >> +		return NULL;
> >> +
> >> +	kref_init(&group->refcount);
> >> +	rvin_group_data =3D group;
> >=20
> > Ouch. While I agree with the global mutex, a single global group variab=
le
> > reminds me of the days when per-device data was happily stored in global
> > variables because, you know, we will never have more than one instance =
of
> > that device, right ? (Or, sometimes, because the driver author didn't
> > know what an instance was.)
> >=20
> > Ideally we'd want a linked list of groups, and this function would eith=
er
> > retrieve the group that the VIN instance is part of, or allocate a new
> > one.
>=20
> I agree that removing the global group variable would be for the better,
> and I was hoping to be able to use the device allocator API for this
> once it's ready. However for now on all supported hardware (I know of)
> there would only be one group for the whole system.
>=20
> - On H3 and M3-W CSI20 is connected to all VINs.
> - On V3M there is only one CSI40 and it is connected to all VINs.
>=20
> Is this satisfactory for you or do you believe it would be better to
> complete the device allocator first. Or implement parts of the ideas
> from that API locally to this driver? If I understand things correctly
> there are still obstacles blocking that API which are not trivial. And
> even if they are cleared it have no DT support AFIK so functionality to
> iterate over all nodes in a graph would be needed which in itself is no
> trivial task.

I don't think we need to wait for the API to be finalized. My dislike for=20
global variables pushes me to ask for a local implementation based on a=20
linked-list, but that would be a bit overkill given that all platforms will=
=20
have a single group. I'm OK with your current implementation, but please ad=
d a=20
=46IXME comment that explains that the single global pointer should really =
be a=20
linked list, and that it should eventually be replaced by usage of a global=
=20
device allocator API.

> >> +	vin_dbg(vin, "%s: alloc group=3D%p\n", __func__, group);
> >=20
> > Do you still need those two debug statements (and all of the other ones
> > below) ?
>=20
> Wops, no they can be dropped.
>=20
> >> +	return group;
> >> +}
> >> +
> >> +static int rvin_group_add_vin(struct rvin_dev *vin)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret =3D rvin_group_read_id(vin, vin->dev->of_node);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >> +	mutex_lock(&vin->group->lock);
> >> +
> >> +	if (vin->group->vin[ret]) {
> >> +		mutex_unlock(&vin->group->lock);
> >> +		vin_err(vin, "VIN number %d already occupied\n", ret);
> >> +		return -EINVAL;
> >=20
> > Can this happen ?
>=20
> Sure, the values are read from DT so if the renesas,id property have the
> same value for more then one node. This is a incorrect DT of course but
> better to handle and warn for such a case I think?

Good point. How about phrasing the error as "Duplicate renesas,id %u" or ev=
en=20
"Duplicate renesas,id property value %u" ? That would more clearly point to=
 a=20
DT error.

> >> +	}
> >> +
> >> +	vin->group->vin[ret] =3D vin;
> >> +
> >> +	mutex_unlock(&vin->group->lock);
> >> +
> >> +	vin_dbg(vin, "I'm VIN number %d", ret);
> >> +
> >> +	return 0;
> >> +}

[snip]

=2D-=20
Regards,

Laurent Pinchart
