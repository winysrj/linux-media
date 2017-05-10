Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58633 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbdEJOCi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 10:02:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 12/16] rcar-vin: allow switch between capturing modes when stalling
Date: Wed, 10 May 2017 17:02:37 +0300
Message-ID: <3477912.RTBmKcPLi1@avalon>
In-Reply-To: <20170314185957.25253-13-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-13-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:53 Niklas S=F6derlund wrote:
> If userspace can't feed the driver with buffers as fast as the driver=

> consumes them the driver will stop video capturing and wait for more
> buffers from userspace, the driver is stalled. Once it have been feed=

> one or more free buffers it will recover from the stall and resume
> capturing.
>=20
> Instead of of continue to capture using the same capture mode as befo=
re

s/of of continue/of continuing/

> the stall allow the driver to choose between single and continuous mo=
de
> base on free buffer availability. Do this by stopping capturing when =
the

s/base/based/

> driver becomes stalled and restart capturing once it continues. By do=
ing
> this the capture mode will be evaluated each time the driver is
> recovering from a stall.
>=20
> This behavior is needed to fix a bug where continuous capturing mode =
is
> used, userspace is about to stop the stream and is waiting for the la=
st
> buffers to be returned from the driver and is not queuing any new
> buffers. In this case the driver becomes stalled when there are only =
3
> buffers remaining streaming will never resume since the driver is
> waiting for userspace to feed it more buffers before it can continue
> streaming.  With this fix the driver will then switch to single captu=
re
> mode for the last 3 buffers and a deadlock is avoided. The issue can =
be
> demonstrated using yavta.
>=20
> $ yavta -f RGB565 -s 640x480 -n 4 --capture=3D10  /dev/video22
> Device /dev/video22 opened.
> Device `R_Car_VIN' on `platform:e6ef1000.video' (driver 'rcar_vin') s=
upports
> video, capture, without mplanes. Video format set: RGB565 (50424752)
> 640x480 (stride 1280) field interlaced buffer size 614400 Video forma=
t:
> RGB565 (50424752) 640x480 (stride 1280) field interlaced buffer size =
614400
> 4 buffers requested.
> length: 614400 offset: 0 timestamp type/source: mono/EoF
> Buffer 0/0 mapped at address 0xb6cc7000.
> length: 614400 offset: 614400 timestamp type/source: mono/EoF
> Buffer 1/0 mapped at address 0xb6c31000.
> length: 614400 offset: 1228800 timestamp type/source: mono/EoF
> Buffer 2/0 mapped at address 0xb6b9b000.
> length: 614400 offset: 1843200 timestamp type/source: mono/EoF
> Buffer 3/0 mapped at address 0xb6b05000.
> 0 (0) [-] interlaced 0 614400 B 38.240285 38.240303 12.421 fps ts mon=
o/EoF
> 1 (1) [-] interlaced 1 614400 B 38.282329 38.282346 23.785 fps ts mon=
o/EoF
> 2 (2) [-] interlaced 2 614400 B 38.322324 38.322338 25.003 fps ts mon=
o/EoF
> 3 (3) [-] interlaced 3 614400 B 38.362318 38.362333 25.004 fps ts mon=
o/EoF
> 4 (0) [-] interlaced 4 614400 B 38.402313 38.402328 25.003 fps ts mon=
o/EoF
> 5 (1) [-] interlaced 5 614400 B 38.442307 38.442321 25.004 fps ts mon=
o/EoF
> 6 (2) [-] interlaced 6 614400 B 38.482301 38.482316 25.004 fps ts mon=
o/EoF
> 7 (3) [-] interlaced 7 614400 B 38.522295 38.522312 25.004 fps ts mon=
o/EoF
> 8 (0) [-] interlaced 8 614400 B 38.562290 38.562306 25.003 fps ts mon=
o/EoF
> <blocks forever, waiting for the last buffer>
>=20
> This fix also allow the driver to switch to single capture mode if
> userspace don't feed it buffers fast enough. Or the other way around,=
 if

s/don't/doesn't/

> userspace suddenly feeds the driver buffers faster it can switch to
> continues capturing mode.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

I have a feeling that the streaming code is a bit fragile, but it doesn=
't seem=20
that this patch is making it worse, so we can rework it later.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 22 +++++++++++++++++---=
--
>  1 file changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> f7776592b9a13d41..bd1ccb70ae2bc47e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -428,6 +428,8 @@ static int rvin_capture_start(struct rvin_dev *vi=
n)
>=20
>  =09rvin_capture_on(vin);
>=20
> +=09vin->state =3D RUNNING;
> +
>  =09return 0;
>  }
>=20
> @@ -906,7 +908,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
>  =09struct rvin_dev *vin =3D data;
>  =09u32 int_status, vnms;
>  =09int slot;
> -=09unsigned int sequence, handled =3D 0;
> +=09unsigned int i, sequence, handled =3D 0;
>  =09unsigned long flags;
>=20
>  =09spin_lock_irqsave(&vin->qlock, flags);
> @@ -968,8 +970,20 @@ static irqreturn_t rvin_irq(int irq, void *data)=

>  =09=09 * the VnMBm registers.
>  =09=09 */
>  =09=09if (vin->continuous) {
> -=09=09=09rvin_capture_off(vin);
> +=09=09=09rvin_capture_stop(vin);
>  =09=09=09vin_dbg(vin, "IRQ %02d: hw not ready stop\n",=20
sequence);
> +
> +=09=09=09/* Maybe we can continue in single capture mode */
> +=09=09=09for (i =3D 0; i < HW_BUFFER_NUM; i++) {
> +=09=09=09=09if (vin->queue_buf[i]) {
> +=09=09=09=09=09list_add(to_buf_list(vin-
>queue_buf[i]),
> +=09=09=09=09=09=09 &vin->buf_list);
> +=09=09=09=09=09vin->queue_buf[i] =3D NULL;
> +=09=09=09=09}
> +=09=09=09}
> +
> +=09=09=09if (!list_empty(&vin->buf_list))
> +=09=09=09=09rvin_capture_start(vin);
>  =09=09}
>  =09} else {
>  =09=09/*
> @@ -1054,8 +1068,7 @@ static void rvin_buffer_queue(struct vb2_buffer=
 *vb)
>  =09 * capturing if HW is ready to continue.
>  =09 */
>  =09if (vin->state =3D=3D STALLED)
> -=09=09if (rvin_fill_hw(vin))
> -=09=09=09rvin_capture_on(vin);
> +=09=09rvin_capture_start(vin);
>=20
>  =09spin_unlock_irqrestore(&vin->qlock, flags);
>  }
> @@ -1072,7 +1085,6 @@ static int rvin_start_streaming(struct vb2_queu=
e *vq,
> unsigned int count)
>=20
>  =09spin_lock_irqsave(&vin->qlock, flags);
>=20
> -=09vin->state =3D RUNNING;
>  =09vin->sequence =3D 0;
>=20
>  =09ret =3D rvin_capture_start(vin);

--=20
Regards,

Laurent Pinchart
