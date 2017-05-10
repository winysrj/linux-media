Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58592 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdEJNjn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:39:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 13/16] rcar-vin: refactor and fold in function after stall handling rework
Date: Wed, 10 May 2017 16:39:42 +0300
Message-ID: <1661133.rgc9DWuKkP@avalon>
In-Reply-To: <20170314185957.25253-14-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-14-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:54 Niklas S=F6derlund wrote:
> With the driver stopping and starting the stream each time the driver=
 is
> stalled rvin_capture_off() can be folded in to the only caller.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> bd1ccb70ae2bc47e..c5fa176ac9d8cc4a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -396,12 +396,6 @@ static void rvin_capture_on(struct rvin_dev *vin=
)
>  =09=09rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
>  }
>=20
> -static void rvin_capture_off(struct rvin_dev *vin)
> -{
> -=09/* Set continuous & single transfer off */
> -=09rvin_write(vin, 0, VNFC_REG);
> -}
> -
>  static int rvin_capture_start(struct rvin_dev *vin)
>  {
>  =09struct rvin_buffer *buf, *node;
> @@ -435,7 +429,8 @@ static int rvin_capture_start(struct rvin_dev *vi=
n)
>=20
>  static void rvin_capture_stop(struct rvin_dev *vin)
>  {
> -=09rvin_capture_off(vin);
> +=09/* Set continuous & single transfer off */
> +=09rvin_write(vin, 0, VNFC_REG);
>=20
>  =09/* Disable module */
>  =09rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);

--=20
Regards,

Laurent Pinchart
