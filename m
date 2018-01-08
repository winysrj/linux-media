Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45682 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbeAHRrc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 12:47:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 07/28] rcar-vin: change name of video device
Date: Mon, 08 Jan 2018 19:48:00 +0200
Message-ID: <7925345.J8ceDaPLNZ@avalon>
In-Reply-To: <20180108164205.GC23075@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se> <5666028.A5BLSl6sJg@avalon> <20180108164205.GC23075@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Monday, 8 January 2018 18:42:05 EET Niklas S=F6derlund wrote:
> On 2018-01-08 18:35:23 +0200, Laurent Pinchart wrote:
> > On Wednesday, 20 December 2017 17:20:55 EET Niklas S=F6derlund wrote:
> >> On 2017-12-14 17:50:24 +0200, Laurent Pinchart wrote:
> >>> On Thursday, 14 December 2017 16:25:00 EET Sakari Ailus wrote:
> >>>> On Fri, Dec 08, 2017 at 10:17:36AM +0200, Laurent Pinchart wrote:
> >>>>> On Friday, 8 December 2017 03:08:21 EET Niklas S=F6derlund wrote:
> >>>>>> The rcar-vin driver needs to be part of a media controller to
> >>>>>> support Gen3. Give each VIN instance a unique name so it can be
> >>>>>> referenced from userspace.
> >>>>>>=20
> >>>>>> Signed-off-by: Niklas S=F6derlund
> >>>>>> <niklas.soderlund+renesas@ragnatech.se>
> >>>>>> Reviewed-by: Kieran Bingham
> >>>>>> <kieran.bingham+renesas@ideasonboard.com>
> >>>>>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>>> ---
> >>>>>>=20
> >>>>>>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
> >>>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>>>=20
> >>>>>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >>>>>> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> >>>>>> 59ec6d3d119590aa..19de99133f048960 100644
> >>>>>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >>>>>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >>>>>> @@ -876,7 +876,8 @@ int rvin_v4l2_register(struct rvin_dev *vin)
> >>>>>>  	vdev->fops =3D &rvin_fops;
> >>>>>>  	vdev->v4l2_dev =3D &vin->v4l2_dev;
> >>>>>>  	vdev->queue =3D &vin->queue;
> >>>>>> -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> >>>>>> +	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
> >>>>>> +		 dev_name(vin->dev));
> >>>>>=20
> >>>>> Do we need the module name here ? How about calling them "%s
> >>>>> output", dev_name(vin->dev) to emphasize the fact that this is a vi=
deo
> >>>>> node and not a VIN subdev ? This is what the omap3isp and vsp1 driv=
ers
> >>>>> do.
> >>>>>=20
> >>>>> We're suffering a bit from the fact that V4L2 has never standardized
> >>>>> a naming scheme for the devices. It wouldn't be fair to ask you to =
fix
> >>>>> that as a prerequisite to get the VIN driver merged, but we clearly
> >>>>> have to work on that at some point.
> >>>>=20
> >>>> Agreed, this needs to be stable and I think aligning to what omap3isp
> >>>> or vsp1 do would be a good fix here.
> >>>=20
> >>> Even omap3isp and vsp1 are not fully aligned, so I think we need to
> >>> design a naming policy and document it.
> >>=20
> >> I agree that align this is a good idea. And for this reason I chosen to
> >> update this patch as such:
> >>=20
> >> "%s output", dev_name(vin->dev)
> >=20
> > Wouldn't it be easier for userspace to use
> >=20
> > 	"VIN%u output", index
> >=20
> > where index is the VIN index as specified in DT ?
>=20
> I would be OK whit this, but do this agree with the idea above that we
> should try to align this name across drivers?

Do you mean does this align with the naming policy that we haven't document=
ed,=20
or even designed, yet ? :-)

If you want to start designing that policy, here are a few ideas (that may =
or=20
may not reflect general consensus).

=46irst of all, a few general considerations about the entity name. Entity =
names=20
shall be unique within the context of a media graph. There have been=20
discussions in the past to move to a single media graph that would span the=
=20
whole system but no concrete proposal has been submitted. Names thus don't=
=20
have to be unique system-wide at the moment but this constraint should stil=
l=20
be kept in mind. One option would be to simply prepend all entity names wit=
h=20
the name of the media device (as defined today) if we later move to a singl=
e=20
media graph.

Another important point is that entity names should be consumable by both=20
machines and humans (at least by developers). They should thus describe the=
=20
entity to some extend. A case could be made to make them parsable by machin=
es=20
(for instance using the "input" or "output" suffix to infer both the nature=
 of=20
the entity and its direction) but I don't think that's a good idea. A more=
=20
formal description of the entity through structured properties would be a=20
better API in my opinion.

It could be argued that an "input" or "output" suffix would duplicate=20
information conveyed through those structured properties. While I can't den=
y=20
that, the need to have unique names readable by developers is met by adding=
=20
such suffixes.

Another point to consider is the prefix. Using the device name (as in=20
dev_name(dev)) is an option but makes reading the media graph by humans mor=
e=20
difficult. Using a more ad-hoc naming scheme (that would then be driver-
specific to some extend, as is "VIN%u", index for the VIN driver) would cre=
ate=20
names that are easier to read and interpret, and that would also vary less=
=20
between SoCs of the same family.

I believe there's a balance to consider between readability and avoidance o=
f=20
duplicated information. One could argue that using "VIN" in the name would=
=20
duplicate information conveyed at the media device level: only the VIN has=
=20
video nodes, so there's need to make that explicit. Similarly the "OMAP3 IS=
P"=20
prefix in the OMAP3 ISP media graph could be argued to be redundant, and is=
 to=20
some extend.

If I had to redesign the OMAP3 ISP entity naming scheme today I would consi=
der=20
dropping the "OMAP3 ISP" prefix. All of the ISP entities have a name of the=
ir=20
own (CCP2, CSI2, CCDC, preview, resizer) that is unique already. The media=
=20
device reports the device name through the info model field as "TI OMAP3 IS=
P"=20
so I could argue that the prefix is not needed.

However, the graph can also contain external entities (mostly camera sensor=
s=20
in this case). Keeping the "OMAP3 ISP" prefix for all ISP entities would ma=
ke=20
it clear what the entities belong to, and would also help avoiding duplicat=
e=20
names. In the R-Car case we face a similar situation, as the graph contains=
,=20
in addition to external camera sensors and video decoders, CSI-2 receivers=
=20
that are in the SoC but not part of the VIN as such.

One possible way to solve this would be to report an entity hierarchy, or a=
t=20
least make it possible to group entities in named groups. The name of the=20
group wouldn't need to be duplicated as a prefix in every entity.

> >> I hope this is a step in the correct direction. If not please let me
> >> know as soon as possible so I can minimize the trouble for the other
> >> developers doing stuff on-top of this series and there test scripts :-)

=2D-=20
Regards,

Laurent Pinchart
