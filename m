Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51138 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765721AbcIOMV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 08:21:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        linux-renesas-soc@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH] [media] MAINTAINERS: Add entry for the Renesas VIN driver
Date: Thu, 15 Sep 2016 15:22:38 +0300
Message-ID: <64105078.kTzLmvx2p0@avalon>
In-Reply-To: <20160915121836.23637-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160915121836.23637-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Thursday 15 Sep 2016 14:18:36 Niklas S=F6derlund wrote:
> The driver is maintained and supported, document it as such.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a12cd60..a4b5283 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7523,6 +7523,15 @@
> F:=09Documentation/devicetree/bindings/media/renesas,fcp.txt
> F:=09drivers/media/platform/rcar-fcp.c
>  F:=09include/media/rcar-fcp.h
>=20
> +MEDIA DRIVERS FOR RENESAS - VIN
> +M:=09Niklas S=F6derlund <niklas.soderlund@ragnatech.se>
> +L:=09linux-media@vger.kernel.org
> +L:=09linux-renesas-soc@vger.kernel.org
> +T:=09git git://linuxtv.org/media_tree.git
> +S:=09Supported
> +F:=09Documentation/devicetree/bindings/media/rcar_vin.txt
> +F:=09drivers/media/platform/rcar-vin/
> +
>  MEDIA DRIVERS FOR RENESAS - VSP1
>  M:=09Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:=09linux-media@vger.kernel.org

--=20
Regards,

Laurent Pinchart

