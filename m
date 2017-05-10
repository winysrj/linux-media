Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58512 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdEJN3c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 09:29:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 10/16] rcar-vin: move functions which acts on hardware
Date: Wed, 10 May 2017 16:29:31 +0300
Message-ID: <2287556.jBiR5uoPLP@avalon>
In-Reply-To: <20170314185957.25253-11-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se> <20170314185957.25253-11-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Tuesday 14 Mar 2017 19:59:51 Niklas S=F6derlund wrote:
> This only moves whole structs, defines and functions around, no code =
is
> changed inside any function. The reason for moving this code around i=
s
> to prepare for refactoring and fixing of a start/stop stream bug with=
out
> having to use forward declarations.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
> drivers/media/platform/rcar-vin/rcar-dma.c | 181 ++++++++++++--------=
-----
> 1 file changed, 90 insertions(+), 91 deletions(-)
>=20
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c
> b/drivers/media/platform/rcar-vin/rcar-dma.c index
> c37f7a2993fb5565..c10d75aa7e71d665 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -119,6 +119,15 @@
>  #define VNDMR2_FTEV=09=09(1 << 17)
>  #define VNDMR2_VLV(n)=09=09((n & 0xf) << 12)
>=20
> +struct rvin_buffer {
> +=09struct vb2_v4l2_buffer vb;
> +=09struct list_head list;
> +};
> +
> +#define to_buf_list(vb2_buffer) (&container_of(vb2_buffer, \
> +=09=09=09=09=09       struct rvin_buffer, \
> +=09=09=09=09=09       vb)->list)
> +
>  static void rvin_write(struct rvin_dev *vin, u32 value, u32 offset)
>  {
>  =09iowrite32(value, vin->base + offset);
> @@ -269,48 +278,6 @@ static int rvin_setup(struct rvin_dev *vin)
>  =09return 0;
>  }
>=20
> -static void rvin_capture_on(struct rvin_dev *vin)
> -{
> -=09vin_dbg(vin, "Capture on in %s mode\n",
> -=09=09vin->continuous ? "continuous" : "single");
> -
> -=09if (vin->continuous)
> -=09=09/* Continuous Frame Capture Mode */
> -=09=09rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
> -=09else
> -=09=09/* Single Frame Capture Mode */
> -=09=09rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
> -}
> -
> -static void rvin_capture_off(struct rvin_dev *vin)
> -{
> -=09/* Set continuous & single transfer off */
> -=09rvin_write(vin, 0, VNFC_REG);
> -}
> -
> -static int rvin_capture_start(struct rvin_dev *vin)
> -{
> -=09int ret;
> -
> -=09rvin_crop_scale_comp(vin);
> -
> -=09ret =3D rvin_setup(vin);
> -=09if (ret)
> -=09=09return ret;
> -
> -=09rvin_capture_on(vin);
> -
> -=09return 0;
> -}
> -
> -static void rvin_capture_stop(struct rvin_dev *vin)
> -{
> -=09rvin_capture_off(vin);
> -
> -=09/* Disable module */
> -=09rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
> -}
> -
>  static void rvin_disable_interrupts(struct rvin_dev *vin)
>  {
>  =09rvin_write(vin, 0, VNIE_REG);
> @@ -377,6 +344,87 @@ static void rvin_set_slot_addr(struct rvin_dev *=
vin,
> int slot, dma_addr_t addr) rvin_write(vin, offset, VNMB_REG(slot));
>  }
>=20
> +static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
> +{
> +=09struct rvin_buffer *buf;
> +=09struct vb2_v4l2_buffer *vbuf;
> +=09dma_addr_t phys_addr_top;
> +
> +=09if (vin->queue_buf[slot] !=3D NULL)
> +=09=09return true;
> +
> +=09if (list_empty(&vin->buf_list))
> +=09=09return false;
> +
> +=09vin_dbg(vin, "Filling HW slot: %d\n", slot);
> +
> +=09/* Keep track of buffer we give to HW */
> +=09buf =3D list_entry(vin->buf_list.next, struct rvin_buffer, list);=

> +=09vbuf =3D &buf->vb;
> +=09list_del_init(to_buf_list(vbuf));
> +=09vin->queue_buf[slot] =3D vbuf;
> +
> +=09/* Setup DMA */
> +=09phys_addr_top =3D vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0=
);
> +=09rvin_set_slot_addr(vin, slot, phys_addr_top);
> +
> +=09return true;
> +}
> +
> +static bool rvin_fill_hw(struct rvin_dev *vin)
> +{
> +=09int slot, limit;
> +
> +=09limit =3D vin->continuous ? HW_BUFFER_NUM : 1;
> +
> +=09for (slot =3D 0; slot < limit; slot++)
> +=09=09if (!rvin_fill_hw_slot(vin, slot))
> +=09=09=09return false;
> +=09return true;
> +}
> +
> +static void rvin_capture_on(struct rvin_dev *vin)
> +{
> +=09vin_dbg(vin, "Capture on in %s mode\n",
> +=09=09vin->continuous ? "continuous" : "single");
> +
> +=09if (vin->continuous)
> +=09=09/* Continuous Frame Capture Mode */
> +=09=09rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
> +=09else
> +=09=09/* Single Frame Capture Mode */
> +=09=09rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
> +}
> +
> +static void rvin_capture_off(struct rvin_dev *vin)
> +{
> +=09/* Set continuous & single transfer off */
> +=09rvin_write(vin, 0, VNFC_REG);
> +}
> +
> +static int rvin_capture_start(struct rvin_dev *vin)
> +{
> +=09int ret;
> +
> +=09rvin_crop_scale_comp(vin);
> +
> +=09ret =3D rvin_setup(vin);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09rvin_capture_on(vin);
> +
> +=09return 0;
> +}
> +
> +static void rvin_capture_stop(struct rvin_dev *vin)
> +{
> +=09rvin_capture_off(vin);
> +
> +=09/* Disable module */
> +=09rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
> +}
> +
>  /*
> ---------------------------------------------------------------------=
------
> -- * Crop and Scaling Gen2
>   */
> @@ -839,55 +887,6 @@ void rvin_scale_try(struct rvin_dev *vin, struct=

> v4l2_pix_format *pix, #define RVIN_TIMEOUT_MS 100
>  #define RVIN_RETRIES 10
>=20
> -struct rvin_buffer {
> -=09struct vb2_v4l2_buffer vb;
> -=09struct list_head list;
> -};
> -
> -#define to_buf_list(vb2_buffer) (&container_of(vb2_buffer, \
> -=09=09=09=09=09       struct rvin_buffer, \
> -=09=09=09=09=09       vb)->list)
> -
> -/* Moves a buffer from the queue to the HW slots */

You're loosing this comment. With this fixed (or not, if there's a good=
=20
reason),

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> -static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
> -{
> -=09struct rvin_buffer *buf;
> -=09struct vb2_v4l2_buffer *vbuf;
> -=09dma_addr_t phys_addr_top;
> -
> -=09if (vin->queue_buf[slot] !=3D NULL)
> -=09=09return true;
> -
> -=09if (list_empty(&vin->buf_list))
> -=09=09return false;
> -
> -=09vin_dbg(vin, "Filling HW slot: %d\n", slot);
> -
> -=09/* Keep track of buffer we give to HW */
> -=09buf =3D list_entry(vin->buf_list.next, struct rvin_buffer, list);=

> -=09vbuf =3D &buf->vb;
> -=09list_del_init(to_buf_list(vbuf));
> -=09vin->queue_buf[slot] =3D vbuf;
> -
> -=09/* Setup DMA */
> -=09phys_addr_top =3D vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0=
);
> -=09rvin_set_slot_addr(vin, slot, phys_addr_top);
> -
> -=09return true;
> -}
> -
> -static bool rvin_fill_hw(struct rvin_dev *vin)
> -{
> -=09int slot, limit;
> -
> -=09limit =3D vin->continuous ? HW_BUFFER_NUM : 1;
> -
> -=09for (slot =3D 0; slot < limit; slot++)
> -=09=09if (!rvin_fill_hw_slot(vin, slot))
> -=09=09=09return false;
> -=09return true;
> -}
> -
>  static irqreturn_t rvin_irq(int irq, void *data)
>  {
>  =09struct rvin_dev *vin =3D data;

--=20
Regards,

Laurent Pinchart
