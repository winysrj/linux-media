Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58483 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbdEJNZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:25:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 08/16] rcar-vin: use pad information when verifying media bus format
Date: Wed, 10 May 2017 16:25:34 +0300
Message-ID: <1760650.1pXjjvRq0D@avalon>
In-Reply-To: <20170314185957.25253-9-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-9-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:49 Niklas S=F6derlund wrote:
> Use information about pad index when enumerating mbus codes.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index
> d7aba15f6761259b..c4d4f112da0c9d45 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -53,6 +53,7 @@ static bool rvin_mbus_supported(struct rvin_graph_e=
ntity
> *entity) };
>=20
>  =09code.index =3D 0;
> +=09code.pad =3D entity->source_pad;
>  =09while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {=

>  =09=09code.index++;
>  =09=09switch (code.code) {

--=20
Regards,

Laurent Pinchart
