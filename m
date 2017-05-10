Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58530 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753024AbdEJNcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:32:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 11/16] rcar-vin: select capture mode based on free buffers
Date: Wed, 10 May 2017 16:32:02 +0300
Message-ID: <1612875.YPaiTLNXp7@avalon>
In-Reply-To: <20170314185957.25253-12-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-12-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:52 Niklas S=F6derlund wrote:
> Instead of selecting single or continuous capture mode based on how m=
any
> buffers userspace intends to give us select capture mode based on num=
ber
> of free buffers we can allocate to hardware when the stream is starte=
d.
>=20
> This change is a prerequisite to enable the driver to switch from
> continuous to single capture mode (or the other way around) when the
> driver is stalled by userspace not feeding it buffers as fast as it
> consumes it.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 31 ++++++++++++--------=
-------
>  1 file changed, 15 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> c10d75aa7e71d665..f7776592b9a13d41 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -404,7 +404,21 @@ static void rvin_capture_off(struct rvin_dev *vi=
n)
>=20
>  static int rvin_capture_start(struct rvin_dev *vin)
>  {
> -=09int ret;
> +=09struct rvin_buffer *buf, *node;
> +=09int bufs, ret;
> +
> +=09/* Count number of free buffers */
> +=09bufs =3D 0;
> +=09list_for_each_entry_safe(buf, node, &vin->buf_list, list)
> +=09=09bufs++;
> +
> +=09/* Continuous capture requires more buffers then there are HW slo=
ts */
> +=09vin->continuous =3D bufs > HW_BUFFER_NUM;
> +
> +=09if (!rvin_fill_hw(vin)) {
> +=09=09vin_err(vin, "HW not ready to start, not enough buffers=20
available\n");
> +=09=09return -EINVAL;
> +=09}
>=20
>  =09rvin_crop_scale_comp(vin);
>=20
> @@ -1061,22 +1075,7 @@ static int rvin_start_streaming(struct vb2_que=
ue *vq,
> unsigned int count) vin->state =3D RUNNING;
>  =09vin->sequence =3D 0;
>=20
> -=09/* Continuous capture requires more buffers then there are HW slo=
ts */
> -=09vin->continuous =3D count > HW_BUFFER_NUM;
> -
> -=09/*
> -=09 * This should never happen but if we don't have enough
> -=09 * buffers for HW bail out
> -=09 */
> -=09if (!rvin_fill_hw(vin)) {
> -=09=09vin_err(vin, "HW not ready to start, not enough buffers=20
available\n");
> -=09=09ret =3D -EINVAL;
> -=09=09goto out;
> -=09}
> -
>  =09ret =3D rvin_capture_start(vin);
> -out:
> -=09/* Return all buffers if something went wrong */
>  =09if (ret) {
>  =09=09return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
>  =09=09v4l2_subdev_call(sd, video, s_stream, 0);

--=20
Regards,

Laurent Pinchart
