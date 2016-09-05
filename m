Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45102 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933056AbcIEPnb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 11:43:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com
Subject: Re: [PATCH 2/2] v4l: vsp1: Add HGT support
Date: Mon, 05 Sep 2016 18:43:58 +0300
Message-ID: <4112113.lBOXq3Iuhk@avalon>
In-Reply-To: <20160902134714.12224-3-niklas.soderlund+renesas@ragnatech.se>
References: <20160902134714.12224-1-niklas.soderlund+renesas@ragnatech.se> <20160902134714.12224-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Friday 02 Sep 2016 15:47:14 Niklas S=F6derlund wrote:
> The HGT is a Histogram Generator Two-Dimensions. It computes a weight=
ed
> frequency histograms for hue and saturation areas over a configurable=

> region of the image with optional subsampling.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>
> ---
>  drivers/media/platform/vsp1/Makefile      |   2 +-
>  drivers/media/platform/vsp1/vsp1.h        |   3 +
>  drivers/media/platform/vsp1/vsp1_drv.c    |  32 +-
>  drivers/media/platform/vsp1/vsp1_entity.c |  33 +-
>  drivers/media/platform/vsp1/vsp1_entity.h |   1 +
>  drivers/media/platform/vsp1/vsp1_hgt.c    | 495 ++++++++++++++++++++=
+++++++
>  drivers/media/platform/vsp1/vsp1_hgt.h    |  51 +++
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +
>  drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
>  drivers/media/platform/vsp1/vsp1_regs.h   |   9 +
>  drivers/media/platform/vsp1/vsp1_video.c  |  10 +-
>  11 files changed, 638 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c
> b/drivers/media/platform/vsp1/vsp1_hgt.c new file mode 100644
> index 0000000..c43373d
> --- /dev/null
> +++ b/drivers/media/platform/vsp1/vsp1_hgt.c
> @@ -0,0 +1,495 @@
> +/*
> + * vsp1_hgt.c  --  R-Car VSP1 Histogram Generator 2D
> + *
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + *
> + * Contact: Niklas S=F6derlund (niklas.soderlund@ragnatech.se)
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; either version 2 of the License, or=

> + * (at your option) any later version.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/gfp.h>
> +
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-vmalloc.h>
> +
> +#include "vsp1.h"
> +#include "vsp1_dl.h"
> +#include "vsp1_hgt.h"
> +
> +#define HGT_MIN_SIZE=09=09=09=094U
> +#define HGT_MAX_SIZE=09=09=09=098192U
> +#define HGT_DATA_SIZE=09=09=09=09((2 + 6 + 6 * 32) * 4)
> +
> +/* -----------------------------------------------------------------=
-------
> + * Device Access
> + */
> +
> +static inline u32 vsp1_hgt_read(struct vsp1_hgt *hgt, u32 reg)
> +{
> +=09return vsp1_read(hgt->entity.vsp1, reg);
> +}
> +
> +static inline void vsp1_hgt_write(struct vsp1_hgt *hgt, struct vsp1_=
dl_list
> *dl,
> +=09=09=09=09  u32 reg, u32 data)
> +{
> +=09vsp1_dl_list_write(dl, reg, data);
> +}
> +
> +/* -----------------------------------------------------------------=
-------
> + * Frame End Handler
> + */
> +
> +void vsp1_hgt_frame_end(struct vsp1_entity *entity)
> +{
> +=09struct vsp1_hgt *hgt =3D to_hgt(&entity->subdev);
> +=09struct vsp1_histogram_buffer *buf;
> +=09unsigned int m, n;
> +=09u32 *data;
> +
> +=09buf =3D vsp1_histogram_buffer_get(&hgt->histo);
> +=09if (!buf)
> +=09=09return;
> +
> +=09data =3D buf->addr;
> +
> +=09*data++ =3D vsp1_hgt_read(hgt, VI6_HGT_MAXMIN);
> +=09*data++ =3D vsp1_hgt_read(hgt, VI6_HGT_SUM);
> +
> +=09for (n =3D 0; n < 6; n++)

Nitpicking, the driver uses pre-increment in for loops (++n), not post-=

increment. This used to be a best-practice rule in C++, where pre-incre=
ment=20
can be faster for non-native types (see http://antonym.org/2008/05/stl-=
iterators-and-performance.html for instance). I'm not sure if that's st=
ill=20
relevant, but I've taken the habit of using the pre-increment operator =
in for=20
loops, and that's what the rest of this driver does. This comment appli=
es to=20
all other locations in this file.

> +=09=09*data++ =3D vsp1_hgt_read(hgt, VI6_HGT_HUE_AREA(n));

As commented on patch 1/2, I don't think this is needed. Userspace has=20=

configured the hue areas, it should already have access to this informa=
tion.=20
Note that if you wanted to keep this code you would need to synchronize=
 it=20
with the .s_ctrl() handler to avoid race conditions. That's not trivial=
, and=20
in my opinion not needed.

> +=09for (m =3D 0; m < 6; m++)
> +=09=09for (n =3D 0; n < 32; n++)
> +=09=09=09*data++ =3D vsp1_hgt_read(hgt, VI6_HGT_HISTO(m, n));
> +
> +=09vsp1_histogram_buffer_complete(&hgt->histo, buf, HGT_DATA_SIZE);
> +}
> +
> +/* -----------------------------------------------------------------=
-------
> + * Controls
> + */
> +
> +#define V4L2_CID_VSP1_HGT_HUE_AREAS=09(V4L2_CID_USER_BASE | 0x1001)
> +
> +static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct vsp1_hgt *hgt =3D container_of(ctrl->handler, struct vsp1_=
hgt,
> +=09=09=09=09=09    ctrls.handler);
> +=09int m, n;

m and n take positive values only, you can make them unsigned int.=20
Additionally, I would use i and j here, as m and n have a specific hard=
ware=20
meaning.

> +=09bool ok;
> +
> +=09/*
> +=09 * Make sure values meet one of two possible HW constrains
> +=09 * 0L <=3D 0U <=3D 1L <=3D 1U <=3D 2L <=3D 2U <=3D 3L <=3D 3U <=3D=
 4L <=3D 4U <=3D 5L <=3D=20
5U
> +=09 * 0U <=3D 1L <=3D 1U <=3D 2L <=3D 2U <=3D 3L <=3D 3U <=3D 4L <=3D=
 4U <=3D 5L <=3D 5U <=3D=20
0L

Wouldn't it be better to test for 0U <=3D 1L <=3D 1U <=3D 2L <=3D 2U <=3D=
 3L <=3D 3U <=3D 4L=20
<=3D 4U <=3D 5L <=3D 5U unconditionally, and then for (OL <=3D OU || 5U=
 <=3D OL) ? You=20
could possibly fold the test and fix loops in a single operation then.

> +=09 */
> +=09for (m =3D 0; m <=3D 1; m++) {
> +=09=09ok =3D true;
> +=09=09for (n =3D 0; n < HGT_NUM_HUE_AREAS - 1; n++) {
> +=09=09=09if (ctrl->p_new.p_u8[(m + n + 0) % HGT_NUM_HUE_AREAS]
> >

m + n + 0 is always < HGT_NUM_HUE_AREAS so you can remove the %=20
HGT_NUM_HUE_AREAS here.

You could also shorten a few lines if you declared

=09const u8 *value =3D ctrl->p_new.p_u8;

at the beginning of the function.

> +=09=09=09    ctrl->p_new.p_u8[(m + n + 1) % HGT_NUM_HUE_AREAS])
> +=09=09=09=09ok =3D false;
> +=09=09}
> +=09=09if (ok)
> +=09=09=09break;
> +=09}
> +
> +=09/* Values do not match HW, adjust to a valid setting */

You can spell out HW as hardware :-)

s/a valid setting/valid settings./

> +=09if (!ok) {
> +=09=09for (n =3D 0; n < HGT_NUM_HUE_AREAS - 1; n++) {
> +=09=09=09if (ctrl->p_new.p_u8[n] > ctrl->p_new.p_u8[n+1])
> +=09=09=09=09ctrl->p_new.p_u8[n] =3D ctrl->p_new.p_u8[n+1];
> +=09=09}
> +=09}
> +
> +=09for (n =3D 0; n < HGT_NUM_HUE_AREAS; n++)
> +=09=09hgt->hue_area[n] =3D ctrl->p_new.p_u8[n];

With hue_area declared as u8 unsigned of unsigned int (assuming it make=
s=20
sense, please see below) you could use a memcpy.

> +
> +=09return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops hgt_hue_areas_ctrl_ops =3D {
> +=09.s_ctrl =3D hgt_hue_areas_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config hgt_hue_areas =3D {
> +=09.ops =3D &hgt_hue_areas_ctrl_ops,
> +=09.id =3D V4L2_CID_VSP1_HGT_HUE_AREAS,
> +=09.name =3D "Boundary Values for Hue Area",
> +=09.type =3D V4L2_CTRL_TYPE_U8,
> +=09.min =3D 0,
> +=09.max =3D 255,
> +=09.def =3D 0,
> +=09.step =3D 1,
> +=09.dims =3D { 12 },
> +};
> +
> +
> +/* -----------------------------------------------------------------=
-------
> + * V4L2 Subdevice Operations
> + */

[snip]

> +static const struct v4l2_subdev_ops hgt_ops =3D {
> +=09.pad    =3D &hgt_pad_ops,
> +};

Except for the list of formats that differ between the two entityes, th=
e=20
subdev operations are identical for the HGO and HGT. I've sent you a pa=
tch=20
that moves the implementation from vsp1_hgo.c to vsp1_histo.c, could yo=
u=20
rebase this patch on top of it (and test the result) ?

> +/* -----------------------------------------------------------------=
-------
> + * VSP1 Entity Operations
> + */
> +
> +static void hgt_configure(struct vsp1_entity *entity,
> +=09=09=09  struct vsp1_pipeline *pipe,
> +=09=09=09  struct vsp1_dl_list *dl, bool full)
> +{
> +=09struct vsp1_hgt *hgt =3D to_hgt(&entity->subdev);
> +=09struct v4l2_rect *compose;
> +=09struct v4l2_rect *crop;
> +=09unsigned int hratio;
> +=09unsigned int vratio;
> +=09uint8_t lower, upper;

Within the kernel you can use u8 instead of uint8_t.

Could you please declare the two variables on separate lines ?

> +=09int i;

i only takes positive values, you can make it unsigned int.

> +
> +=09if (!full)
> +=09=09return;
> +
> +=09crop =3D vsp1_entity_get_pad_selection(entity, entity->config,
> +=09=09=09=09=09     HGT_PAD_SINK, V4L2_SEL_TGT_CROP);
> +=09compose =3D vsp1_entity_get_pad_selection(entity, entity->config,=

> +=09=09=09=09=09=09HGT_PAD_SINK,
> +=09=09=09=09=09=09V4L2_SEL_TGT_COMPOSE);
> +
> +=09vsp1_hgt_write(hgt, dl, VI6_HGT_REGRST, VI6_HGT_REGRST_RCLEA);
> +
> +=09vsp1_hgt_write(hgt, dl, VI6_HGT_OFFSET,
> +=09=09       (crop->left << VI6_HGT_OFFSET_HOFFSET_SHIFT) |
> +=09=09       (crop->top << VI6_HGT_OFFSET_VOFFSET_SHIFT));
> +=09vsp1_hgt_write(hgt, dl, VI6_HGT_SIZE,
> +=09=09       (crop->width << VI6_HGT_SIZE_HSIZE_SHIFT) |
> +=09=09       (crop->height << VI6_HGT_SIZE_VSIZE_SHIFT));
> +
> +=09mutex_lock(hgt->ctrls.handler.lock);
> +=09for (i =3D 0; i < 6; i++) {
> +=09=09lower =3D hgt->hue_area[i*2 + 0];
> +=09=09upper =3D hgt->hue_area[i*2 + 1];
> +=09=09vsp1_hgt_write(hgt, dl, VI6_HGT_HUE_AREA(i),
> +=09=09=09       (lower << VI6_HGT_HUE_AREA_LOWER_SHIFT) |
> +=09=09=09       (upper << VI6_HGT_HUE_AREA_UPPER_SHIFT));
> +=09}
> +=09mutex_unlock(hgt->ctrls.handler.lock);
> +
> +=09hratio =3D crop->width * 2 / compose->width / 3;
> +=09vratio =3D crop->height * 2 / compose->height / 3;
> +=09vsp1_hgt_write(hgt, dl, VI6_HGT_MODE,
> +=09=09       (hratio << VI6_HGT_MODE_HRATIO_SHIFT) |
> +=09=09       (vratio << VI6_HGT_MODE_VRATIO_SHIFT));
> +}
> +
> +static void hgt_destroy(struct vsp1_entity *entity)
> +{
> +=09struct vsp1_hgt *hgt =3D to_hgt(&entity->subdev);
> +
> +=09vsp1_histogram_cleanup(&hgt->histo);
> +}
> +
> +static const struct vsp1_entity_operations hgt_entity_ops =3D {
> +=09.configure =3D hgt_configure,
> +=09.destroy =3D hgt_destroy,
> +};
> +
> +/* -----------------------------------------------------------------=
-------
> + * Initialization and Cleanup
> + */
> +
> +struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1)
> +{
> +=09struct vsp1_hgt *hgt;
> +=09int i, ret;

i takes positive a values only, you can declare it as an unsigned int.

> +
> +=09hgt =3D devm_kzalloc(vsp1->dev, sizeof(*hgt), GFP_KERNEL);
> +=09if (hgt =3D=3D NULL)
> +=09=09return ERR_PTR(-ENOMEM);
> +
> +=09hgt->entity.ops =3D &hgt_entity_ops;
> +=09hgt->entity.type =3D VSP1_ENTITY_HGT;
> +
> +=09ret =3D vsp1_entity_init(vsp1, &hgt->entity, "hgt", 2, &hgt_ops,
> +=09=09=09       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
> +=09if (ret < 0)
> +=09=09return ERR_PTR(ret);
> +
> +=09/* Initialize the control handler. */
> +=09for (i =3D 0; i < HGT_NUM_HUE_AREAS; i++)
> +=09=09hgt->hue_area[i] =3D hgt_hue_areas.def;

The right way to do this is to call v4l2_ctrl_handler_setup() at the en=
d of=20
the function. I need to fix a few locations in the driver where the val=
ues are=20
initialized manually.

> +=09v4l2_ctrl_handler_init(&hgt->ctrls.handler, 12);

s/12/1/

> +=09hgt->ctrls.hue_areas =3D v4l2_ctrl_new_custom(&hgt->ctrls.handler=
,
> +=09=09=09=09=09=09    &hgt_hue_areas, NULL);
> +=09hgt->entity.subdev.ctrl_handler =3D &hgt->ctrls.handler;
> +
> +=09/* Initialize the video device and queue for statistics data. */
> +=09ret =3D vsp1_histogram_init(vsp1, &hgt->histo, hgt->entity.subdev=
.name,
> +=09=09=09=09  HGT_DATA_SIZE, V4L2_META_FMT_VSP1_HGT);
> +=09if (ret < 0) {
> +=09=09vsp1_entity_destroy(&hgt->entity);
> +=09=09return ERR_PTR(ret);
> +=09}
> +
> +=09return hgt;
> +}
> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.h
> b/drivers/media/platform/vsp1/vsp1_hgt.h new file mode 100644
> index 0000000..a2f1eae
> --- /dev/null
> +++ b/drivers/media/platform/vsp1/vsp1_hgt.h
> @@ -0,0 +1,51 @@
> +/*
> + * vsp1_hgt.h  --  R-Car VSP1 Histogram Generator 2D
> + *
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + *
> + * Contact: Niklas S=F6derlund (niklas.soderlund@ragnatech.se)
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License as published=
 by
> + * the Free Software Foundation; either version 2 of the License, or=

> + * (at your option) any later version.
> + */
> +#ifndef __VSP1_HGT_H__
> +#define __VSP1_HGT_H__
> +
> +#include <media/media-entity.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "vsp1_entity.h"
> +#include "vsp1_histo.h"
> +
> +struct vsp1_device;
> +
> +#define HGT_PAD_SINK=09=09=09=090
> +#define HGT_PAD_SOURCE=09=09=09=091
> +
> +#define HGT_NUM_HUE_AREAS=09=09=0912

Technically speaking there are 6 areas. I would thus define HGT_NUM_HUE=
_AREAS=20
as equal to 6, and either use HGT_NUM_HUE_AREAS * 2 or modify the code =
to=20
process the lower and upper boundaries separately.

> +struct vsp1_hgt {
> +=09struct vsp1_entity entity;
> +=09struct vsp1_histogram histo;
> +
> +=09struct {
> +=09=09struct v4l2_ctrl_handler handler;
> +=09=09struct v4l2_ctrl *hue_areas;

You don't need to store the hue_areas control in the vsp1_hgt structure=
, the=20
value is only used in vsp1_hgt_create() where it can be stored in a loc=
al=20
variable. You can thus get rid of the ctrls structure and just add a st=
ruct=20
v4l2_ctrl_handler ctrls field.

> +=09} ctrls;
> +
> +=09unsigned int hue_area[HGT_NUM_HUE_AREAS];

Shouldn't this be called hue_areas ?

Using u8 would save a bit of memory, but possibly at the expense of the=
 .text=20
size. Could you check that ?

> +};
> +
> +

A single blank line will do.

> +static inline struct vsp1_hgt *to_hgt(struct v4l2_subdev *subdev)
> +{
> +=09return container_of(subdev, struct vsp1_hgt, entity.subdev);
> +}
> +
> +struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1);
> +void vsp1_hgt_frame_end(struct vsp1_entity *hgt);
> +
> +#endif /* __VSP1_HGT_H__ */

[snip]

--=20
Regards,

Laurent Pinchart

