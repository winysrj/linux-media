Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47278 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751536AbdA1Q0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jan 2017 11:26:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: of: check for unique lanes in data-lanes and clock-lanes
Date: Sat, 28 Jan 2017 18:26:24 +0200
Message-ID: <1773458.Cvt8mFyy2S@avalon>
In-Reply-To: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday 26 Jan 2017 14:12:59 Niklas S=F6derlund wrote:
> All lines in data-lanes and clock-lanes properties must be unique.
> Instead of drivers checking for this add it to the generic parser.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/v4l2-core/v4l2-of.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-of.c
> b/drivers/media/v4l2-core/v4l2-of.c index 93b33681776c..1042db6bb996 =
100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -32,12 +32,19 @@ static int v4l2_of_parse_csi_bus(const struct
> device_node *node, prop =3D of_find_property(node, "data-lanes", NULL=
);
>  =09if (prop) {
>  =09=09const __be32 *lane =3D NULL;
> -=09=09unsigned int i;
> +=09=09unsigned int i, n;
>=20
>  =09=09for (i =3D 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
>  =09=09=09lane =3D of_prop_next_u32(prop, lane, &v);
>  =09=09=09if (!lane)
>  =09=09=09=09break;
> +=09=09=09for (n =3D 0; n < i; n++) {
> +=09=09=09=09if (bus->data_lanes[n] =3D=3D v) {
> +=09=09=09=09=09pr_warn("%s: duplicated lane %u in=20
data-lanes\n",
> +=09=09=09=09=09=09node->full_name, v);
> +=09=09=09=09=09return -EINVAL;
> +=09=09=09=09}

If you used a bitmask to store the already used lanes you could avoid t=
he=20
nested loops.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +=09=09=09}
>  =09=09=09bus->data_lanes[i] =3D v;
>  =09=09}
>  =09=09bus->num_data_lanes =3D i;
> @@ -63,6 +70,15 @@ static int v4l2_of_parse_csi_bus(const struct devi=
ce_node
> *node, }
>=20
>  =09if (!of_property_read_u32(node, "clock-lanes", &v)) {
> +=09=09unsigned int n;
> +
> +=09=09for (n =3D 0; n < bus->num_data_lanes; n++) {
> +=09=09=09if (bus->data_lanes[n] =3D=3D v) {
> +=09=09=09=09pr_warn("%s: duplicated lane %u in clock-
lanes\n",
> +=09=09=09=09=09node->full_name, v);
> +=09=09=09=09return -EINVAL;
> +=09=09=09}
> +=09=09}
>  =09=09bus->clock_lane =3D v;
>  =09=09have_clk_lane =3D true;
>  =09}

--=20
Regards,

Laurent Pinchart

