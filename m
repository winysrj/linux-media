Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42711 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdBAMbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 07:31:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCHv2] v4l: of: check for unique lanes in data-lanes and clock-lanes
Date: Wed, 01 Feb 2017 14:31:52 +0200
Message-ID: <8556874.pyO1Q5jdsX@avalon>
In-Reply-To: <20170131120831.11283-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170131120831.11283-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

By the way, you can use

git format-patch -v2

to automatically add "v2" to the subject line.

On Tuesday 31 Jan 2017 13:08:31 Niklas S=F6derlund wrote:
> All lanes in data-lanes and clock-lanes properties should be unique. =
Add
> a check for this in v4l2_of_parse_csi_bus() and print a warning if
> duplicated lanes are found.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>=20
> Changes since v1:
>=20
> - Do not return -EINVAL if a duplicate is found. Sakari pointed out
>   there are drivers where the number of lanes matter but not the actu=
al
>   lane numbers. Updated commit message to highlight that only a warni=
ng
>   is printed.
> - Switched to a bitmask to track lanes used instead of a nested loop,=

>   thanks Laurent for the suggestion.
>=20
>=20
>  drivers/media/v4l2-core/v4l2-of.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-of.c
> b/drivers/media/v4l2-core/v4l2-of.c index
> 93b33681776ca427..4f59f442dd0a64c9 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -26,7 +26,7 @@ static int v4l2_of_parse_csi_bus(const struct devic=
e_node
> *node, struct v4l2_of_bus_mipi_csi2 *bus =3D &endpoint->bus.mipi_csi2=
;
>  =09struct property *prop;
>  =09bool have_clk_lane =3D false;
> -=09unsigned int flags =3D 0;
> +=09unsigned int flags =3D 0, lanes_used =3D 0;
>  =09u32 v;
>=20
>  =09prop =3D of_find_property(node, "data-lanes", NULL);
> @@ -38,6 +38,12 @@ static int v4l2_of_parse_csi_bus(const struct devi=
ce_node
> *node, lane =3D of_prop_next_u32(prop, lane, &v);
>  =09=09=09if (!lane)
>  =09=09=09=09break;
> +
> +=09=09=09if (lanes_used & BIT(v))
> +=09=09=09=09pr_warn("%s: duplicated lane %u in data-
lanes\n",
> +=09=09=09=09=09node->full_name, v);
> +=09=09=09lanes_used |=3D BIT(v);
> +
>  =09=09=09bus->data_lanes[i] =3D v;
>  =09=09}
>  =09=09bus->num_data_lanes =3D i;
> @@ -63,6 +69,11 @@ static int v4l2_of_parse_csi_bus(const struct devi=
ce_node
> *node, }
>=20
>  =09if (!of_property_read_u32(node, "clock-lanes", &v)) {
> +=09=09if (lanes_used & BIT(v))
> +=09=09=09pr_warn("%s: duplicated lane %u in clock-lanes\n",
> +=09=09=09=09node->full_name, v);
> +=09=09lanes_used |=3D BIT(v);
> +
>  =09=09bus->clock_lane =3D v;
>  =09=09have_clk_lane =3D true;
>  =09}

--=20
Regards,

Laurent Pinchart

