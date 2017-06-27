Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36581 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbdF0PLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 11:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <1498492189.3710.4.camel@ndufresne.ca>
References: <1498488673-27900-1-git-send-email-jacob-chen@iotwrt.com> <1498492189.3710.4.camel@ndufresne.ca>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Tue, 27 Jun 2017 23:11:30 +0800
Message-ID: <CAFLEztT4z81P8c5pce0zZtaJc+UDsAdXWGp8Rvmq5VL+TsWNNg@mail.gmail.com>
Subject: Re: [PATCH 1/5] [media] rockchip/rga: v4l2 m2m support
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>, linux-media@vger.kernel.org,
        mchehab@kernel.org, hans.verkuil@cisco.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas.

2017-06-26 23:49 GMT+08:00 Nicolas Dufresne <nicolas@ndufresne.ca>:
>
> Le lundi 26 juin 2017 =C3=A0 22:51 +0800, Jacob Chen a =C3=A9crit :
> > Rockchip RGA is a separate 2D raster graphic acceleration unit. It
> > accelerates 2D graphics operations, such as point/line drawing, image
> > scaling, rotation, BitBLT, alpha blending and image blur/sharpness.
> >
> > The drvier is mostly based on s5p-g2d v4l2 m2m driver.
> > And supports various operations from the rendering pipeline.
> >  - copy
> >  - fast solid color fill
> >  - rotation
> >  - flip
> >  - alpha blending
> >
> > The code in rga-hw.c is used to configure regs accroding to
> > operations.
> >
> > The code in rga-buf.c is used to create private mmu table for RGA.
> > The tables is stored in a list, and be removed when buffer is
> > cleanup.
> >
> > Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> > ---
> >  drivers/media/platform/Kconfig                |  11 +
> >  drivers/media/platform/Makefile               |   2 +
> >  drivers/media/platform/rockchip-rga/Makefile  |   3 +
> >  drivers/media/platform/rockchip-rga/rga-buf.c | 176 +++++
> >  drivers/media/platform/rockchip-rga/rga-hw.c  | 456 ++++++++++++
> >  drivers/media/platform/rockchip-rga/rga-hw.h  | 434 ++++++++++++
> >  drivers/media/platform/rockchip-rga/rga.c     | 979
> > ++++++++++++++++++++++++++
> >  drivers/media/platform/rockchip-rga/rga.h     | 133 ++++
> >  8 files changed, 2194 insertions(+)
> >  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
> >
> > diff --git a/drivers/media/platform/Kconfig
> > b/drivers/media/platform/Kconfig
> > index c9106e1..8199bcf 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -411,6 +411,17 @@ config VIDEO_RENESAS_VSP1
> >         To compile this driver as a module, choose M here: the
> > module
> >         will be called vsp1.
> >
> > +config VIDEO_ROCKCHIP_RGA
> > +     tristate "Rockchip Raster 2d Grapphic Acceleration Unit"
> > +     depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> > +     depends on ARCH_ROCKCHIP || COMPILE_TEST
> > +     select VIDEOBUF2_DMA_SG
> > +     select V4L2_MEM2MEM_DEV
> > +     default n
> > +     ---help---
> > +       This is a v4l2 driver for Rockchip SOC RGA2
> > +       2d graphics accelerator.
> > +
> >  config VIDEO_TI_VPE
> >       tristate "TI VPE (Video Processing Engine) driver"
> >       depends on VIDEO_DEV && VIDEO_V4L2
> > diff --git a/drivers/media/platform/Makefile
> > b/drivers/media/platform/Makefile
> > index 349ddf6..3bf096f 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -54,6 +54,8 @@ obj-$(CONFIG_VIDEO_RENESAS_FDP1)    +=3D
> > rcar_fdp1.o
> >  obj-$(CONFIG_VIDEO_RENESAS_JPU)      +=3D rcar_jpu.o
> >  obj-$(CONFIG_VIDEO_RENESAS_VSP1)     +=3D vsp1/
> >
> > +obj-$(CONFIG_VIDEO_ROCKCHIP_RGA)     +=3D rockchip-rga/
> > +
> >  obj-y        +=3D omap/
> >
> >  obj-$(CONFIG_VIDEO_AM437X_VPFE)              +=3D am437x/
> > diff --git a/drivers/media/platform/rockchip-rga/Makefile
> > b/drivers/media/platform/rockchip-rga/Makefile
> > new file mode 100644
> > index 0000000..92fe254
> > --- /dev/null
> > +++ b/drivers/media/platform/rockchip-rga/Makefile
> > @@ -0,0 +1,3 @@
> > +rockchip-rga-objs :=3D rga.o rga-hw.o rga-buf.o
> > +
> > +obj-$(CONFIG_VIDEO_ROCKCHIP_RGA) +=3D rockchip-rga.o
> > diff --git a/drivers/media/platform/rockchip-rga/rga-buf.c
> > b/drivers/media/platform/rockchip-rga/rga-buf.c
> > new file mode 100644
> > index 0000000..8582092
> > --- /dev/null
> > +++ b/drivers/media/platform/rockchip-rga/rga-buf.c
> > @@ -0,0 +1,176 @@
> > +/*
> > + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> > + * Author: Jacob Chen <jacob-chen@iotwrt.com>
> > + *
> > + * This software is licensed under the terms of the GNU General
> > Public
> > + * License version 2, as published by the Free Software Foundation,
> > and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/pm_runtime.h>
> > +
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-dma-sg.h>
> > +#include <media/videobuf2-v4l2.h>
> > +
> > +#include "rga-hw.h"
> > +#include "rga.h"
> > +
> > +static int
> > +rga_queue_setup(struct vb2_queue *vq,
> > +                unsigned int *nbuffers, unsigned int *nplanes,
> > +                unsigned int sizes[], struct device *alloc_devs[])
> > +{
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +     struct rga_frame *f =3D rga_get_frame(ctx, vq->type);
> > +
> > +     if (IS_ERR(f))
> > +             return PTR_ERR(f);
> > +
> > +     sizes[0] =3D f->size;
> > +     *nplanes =3D 1;
> > +
> > +     if (*nbuffers =3D=3D 0)
> > +             *nbuffers =3D 1;
> > +
> > +     return 0;
> > +}
> > +
> > +static int rga_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +     struct rga_frame *f =3D rga_get_frame(ctx, vb->vb2_queue-
> > >type);
> > +
> > +     if (IS_ERR(f))
> > +             return PTR_ERR(f);
> > +
> > +     vb2_set_plane_payload(vb, 0, f->size);
> > +
> > +     return 0;
> > +}
> > +
> > +static void rga_buf_queue(struct vb2_buffer *vb)
> > +{
> > +     struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +     v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> > +}
> > +
> > +static int rga_buf_init(struct vb2_buffer *vb)
> > +{
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +     struct sg_table *sgt;
> > +     struct scatterlist *sgl;
> > +     unsigned int *pages;
> > +     struct rga_buf *buf;
> > +     unsigned int address, len, i, p;
> > +     unsigned int mapped_size =3D 0;
> > +
> > +     /* Create local MMU table for RGA */
> > +     sgt =3D vb2_plane_cookie(vb, 0);
> > +
> > +     /*
> > +      * Alloc (2^3 * 4K) =3D 32K byte for storing pages, those
> > space could
> > +      * cover 32K * 4K =3D 128M ram address.
> > +      */
> > +     pages =3D (unsigned int *)__get_free_pages(GFP_KERNEL |
> > __GFP_ZERO, 3);
> > +
> > +     for_each_sg(sgt->sgl, sgl, sgt->nents, i) {
> > +             len =3D sg_dma_len(sgl) >> PAGE_SHIFT;
> > +             address =3D sg_phys(sgl);
> > +
> > +             for (p =3D 0; p < len; p++) {
> > +                     dma_addr_t phys =3D address + (p <<
> > PAGE_SHIFT);
> > +                     pages[mapped_size + p] =3D phys;
> > +             }
> > +
> > +             mapped_size +=3D len;
> > +     }
> > +
> > +     /* sync local MMU table for RGA */
> > +     dma_sync_single_for_device(rga->dev, virt_to_phys(pages),
> > +                                8 * PAGE_SIZE,
> > DMA_BIDIRECTIONAL);
> > +
> > +     /* Store the buffer to the RGA private buffers list */
> > +     buf =3D kmalloc(sizeof(struct rga_buf), GFP_KERNEL);
> > +     buf->index =3D vb->index;
> > +     buf->type =3D vb->type;
> > +     buf->mmu_pages =3D pages;
> > +
> > +     list_add_tail(&buf->entry, &ctx->buffers_list);
> > +
> > +     return 0;
> > +}
> > +
> > +static void rga_buf_cleanup(struct vb2_buffer *vb)
> > +{
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +     struct rga_buf *buf, *tmp;
> > +
> > +     /* Release the RGA private buffers */
> > +     list_for_each_entry_safe(buf, tmp, &ctx->buffers_list,
> > entry) {
> > +             if (buf->index =3D=3D vb->index && buf->type =3D=3D vb-
> > >type) {
> > +                     free_pages((unsigned long)buf->mmu_pages,
> > 3);
> > +                     list_del(&buf->entry);
> > +                     kfree(buf);
> > +             }
> > +     }
> > +}
> > +
> > +static void rga_buf_stop_streaming(struct vb2_queue *q)
> > +{
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(q);
> > +     struct vb2_v4l2_buffer *vbuf;
> > +
> > +     for (;;) {
> > +             if (V4L2_TYPE_IS_OUTPUT(q->type))
> > +                     vbuf =3D v4l2_m2m_src_buf_remove(ctx-
> > >fh.m2m_ctx);
> > +             else
> > +                     vbuf =3D v4l2_m2m_dst_buf_remove(ctx-
> > >fh.m2m_ctx);
> > +             if (vbuf =3D=3D NULL)
> > +                     return;
> > +             v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> > +     }
> > +}
> > +
> > +const struct vb2_ops rga_qops =3D {
> > +     .queue_setup =3D rga_queue_setup,
> > +     .buf_prepare =3D rga_buf_prepare,
> > +     .buf_queue =3D rga_buf_queue,
> > +     .buf_init =3D rga_buf_init,
> > +     .buf_cleanup =3D rga_buf_cleanup,
> > +     .stop_streaming =3D rga_buf_stop_streaming,
> > +};
> > +
> > +void *rga_buf_find_page(struct vb2_buffer *vb)
> > +{
> > +     struct rga_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +     struct rga_buf *buf;
> > +
> > +     list_for_each_entry(buf, &ctx->buffers_list, entry) {
> > +             if (buf->index =3D=3D vb->index && buf->type =3D=3D vb-
> > >type) {
> > +                     return buf->mmu_pages;
> > +             }
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> > +void rga_buf_clean(struct rga_ctx *ctx)
> > +{
> > +     struct rga_buf *buf, *tmp;
> > +
> > +     list_for_each_entry_safe(buf, tmp, &ctx->buffers_list,
> > entry) {
> > +             free_pages((unsigned long)buf->mmu_pages, 3);
> > +             list_del(&buf->entry);
> > +             kfree(buf);
> > +     }
> > +}
> > diff --git a/drivers/media/platform/rockchip-rga/rga-hw.c
> > b/drivers/media/platform/rockchip-rga/rga-hw.c
> > new file mode 100644
> > index 0000000..5c20fc8
> > --- /dev/null
> > +++ b/drivers/media/platform/rockchip-rga/rga-hw.c
> > @@ -0,0 +1,456 @@
> > +/*
> > + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> > + * Author: Jacob Chen <jacob-chen@iotwrt.com>
> > + *
> > + * This software is licensed under the terms of the GNU General
> > Public
> > + * License version 2, as published by the Free Software Foundation,
> > and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/pm_runtime.h>
> > +
> > +#include "rga-hw.h"
> > +#include "rga.h"
> > +
> > +enum e_rga_start_pos {
> > +     LT =3D 0,
> > +     LB =3D 1,
> > +     RT =3D 2,
> > +     RB =3D 3,
> > +};
> > +
> > +struct rga_addr_offset {
> > +     unsigned int y_off;
> > +     unsigned int u_off;
> > +     unsigned int v_off;
> > +};
> > +
> > +struct rga_corners_addr_offset {
> > +     struct rga_addr_offset left_top;
> > +     struct rga_addr_offset right_top;
> > +     struct rga_addr_offset left_bottom;
> > +     struct rga_addr_offset right_bottom;
> > +};
> > +
> > +static unsigned int rga_get_scaling(unsigned int src, unsigned int
> > dst)
> > +{
> > +     /*
> > +      * The rga hw scaling factor is a normalized inverse of the
> > scaling factor.
> > +      * For example: When source width is 100 and destination
> > width is 200
> > +      * (scaling of 2x), then the hw factor is NC * 100 / 200.
> > +      * The normalization factor (NC) is 2^16 =3D 0x10000.
> > +      */
> > +
> > +     return (src > dst) ? ((dst << 16) / src) : ((src << 16) /
> > dst);
> > +}
> > +
> > +static struct rga_corners_addr_offset
> > +rga_get_addr_offset(struct rga_frame *frm, unsigned int x, unsigned
> > int y,
> > +                    unsigned int w, unsigned int h)
> > +{
> > +     struct rga_corners_addr_offset offsets;
> > +     struct rga_addr_offset *lt, *lb, *rt, *rb;
> > +     unsigned int x_div =3D 0,
> > +                  y_div =3D 0, uv_stride =3D 0, pixel_width =3D 0,
> > uv_factor =3D 0;
> > +
> > +     lt =3D &offsets.left_top;
> > +     lb =3D &offsets.left_bottom;
> > +     rt =3D &offsets.right_top;
> > +     rb =3D &offsets.right_bottom;
> > +
> > +     x_div =3D frm->fmt->x_div;
> > +     y_div =3D frm->fmt->y_div;
> > +     uv_factor =3D frm->fmt->uv_factor;
> > +     uv_stride =3D frm->stride / x_div;
> > +     pixel_width =3D frm->stride / frm->width;
> > +
> > +     lt->y_off =3D y * frm->stride + x * pixel_width;
> > +     lt->u_off =3D
> > +         frm->width * frm->height + (y / y_div) * uv_stride + x /
> > x_div;
> > +     lt->v_off =3D lt->u_off + frm->width * frm->height /
> > uv_factor;
> > +
> > +     lb->y_off =3D lt->y_off + (h - 1) * frm->stride;
> > +     lb->u_off =3D lt->u_off + (h / y_div - 1) * uv_stride;
> > +     lb->v_off =3D lt->v_off + (h / y_div - 1) * uv_stride;
> > +
> > +     rt->y_off =3D lt->y_off + (w - 1) * pixel_width;
> > +     rt->u_off =3D lt->u_off + w / x_div - 1;
> > +     rt->v_off =3D lt->v_off + w / x_div - 1;
> > +
> > +     rb->y_off =3D lb->y_off + (w - 1) * pixel_width;
> > +     rb->u_off =3D lb->u_off + w / x_div - 1;
> > +     rb->v_off =3D lb->v_off + w / x_div - 1;
> > +
> > +     return offsets;
> > +}
> > +
> > +static struct rga_addr_offset *rga_lookup_draw_pos(struct
> > +        rga_corners_addr_offset
> > +        *offsets, u32 rotate_mode,
> > +        u32 mirr_mode)
> > +{
> > +     static enum e_rga_start_pos rot_mir_point_matrix[4][4] =3D {
> > +             {
> > +                     LT, RT, LB, RB,
> > +             },
> > +             {
> > +                     RT, LT, RB, LB,
> > +             },
> > +             {
> > +                     RB, LB, RT, LT,
> > +             },
> > +             {
> > +                     LB, RB, LT, RT,
> > +             },
> > +     };
> > +
> > +     if (offsets =3D=3D NULL)
> > +             return NULL;
> > +
> > +     switch (rot_mir_point_matrix[rotate_mode][mirr_mode]) {
> > +     case LT:
> > +             return &offsets->left_top;
> > +     case LB:
> > +             return &offsets->left_bottom;
> > +     case RT:
> > +             return &offsets->right_top;
> > +     case RB:
> > +             return &offsets->right_bottom;
> > +     };
> > +
> > +     return NULL;
> > +}
> > +
> > +static void rga_cmd_set_src_addr(struct rga_ctx *ctx, void
> > *mmu_pages)
> > +{
> > +     u32 *dest =3D ctx->cmdbuf_virt;
> > +     unsigned int reg;
> > +
> > +     reg =3D RGA_MMU_SRC_BASE - RGA_MODE_BASE_REG;
> > +     dest[reg >> 2] =3D virt_to_phys(mmu_pages) >> 4;
> > +
> > +     reg =3D RGA_MMU_CTRL1 - RGA_MODE_BASE_REG;
> > +     dest[reg >> 2] |=3D 0x7;
> > +}
> > +
> > +static void rga_cmd_set_src1_addr(struct rga_ctx *ctx, void
> > *mmu_pages)
> > +{
> > +     u32 *dest =3D ctx->cmdbuf_virt;
> > +     unsigned int reg;
> > +
> > +     reg =3D RGA_MMU_SRC1_BASE - RGA_MODE_BASE_REG;
> > +     dest[reg >> 2] =3D virt_to_phys(mmu_pages) >> 4;
> > +
> > +     reg =3D RGA_MMU_CTRL1 - RGA_MODE_BASE_REG;
> > +     dest[reg >> 2] |=3D 0x7 << 4;
> > +}
> > +
> > +static void rga_cmd_set_dst_addr(struct rga_ctx *ctx, void
> > *mmu_pages)
> > +{
> > +     u32 *dest =3D ctx->cmdbuf_virt;
> > +     unsigned int reg;
> > +
> > +     reg =3D RGA_MMU_DST_BASE - RGA_MODE_BASE_REG;
> > +     dest[reg >> 2] =3D virt_to_phys(mmu_pages) >> 4;
> > +
> > +     reg =3D RGA_MMU_CTRL1 - RGA_MODE_BASE_REG;
> > +     dest[reg >> 2] |=3D 0x7 << 8;
> > +}
> > +
> > +static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
> > +{
> > +     u32 *dest =3D ctx->cmdbuf_virt;
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +     unsigned int scale_dst_w, scale_dst_h;
> > +     unsigned int src_h, src_w, src_x, src_y, dst_h, dst_w,
> > dst_x, dst_y;
> > +     union rga_src_info src_info;
> > +     union rga_dst_info dst_info;
> > +     union rga_src_x_factor x_factor;
> > +     union rga_src_y_factor y_factor;
> > +     union rga_src_vir_info src_vir_info;
> > +     union rga_src_act_info src_act_info;
> > +     union rga_dst_vir_info dst_vir_info;
> > +     union rga_dst_act_info dst_act_info;
> > +
> > +     struct rga_addr_offset *dst_offset;
> > +     struct rga_corners_addr_offset offsets;
> > +     struct rga_corners_addr_offset src_offsets;
> > +
> > +     src_h =3D ctx->in.crop.height;
> > +     src_w =3D ctx->in.crop.width;
> > +     src_x =3D ctx->in.crop.left;
> > +     src_y =3D ctx->in.crop.top;
> > +     dst_h =3D ctx->out.crop.height;
> > +     dst_w =3D ctx->out.crop.width;
> > +     dst_x =3D ctx->out.crop.left;
> > +     dst_y =3D ctx->out.crop.top;
> > +
> > +     src_info.val =3D dest[(RGA_SRC_INFO - RGA_MODE_BASE_REG) >>
> > 2];
> > +     dst_info.val =3D dest[(RGA_DST_INFO - RGA_MODE_BASE_REG) >>
> > 2];
> > +     x_factor.val =3D dest[(RGA_SRC_X_FACTOR - RGA_MODE_BASE_REG)
> > >> 2];
> > +     y_factor.val =3D dest[(RGA_SRC_Y_FACTOR - RGA_MODE_BASE_REG)
> > >> 2];
> > +     src_vir_info.val =3D dest[(RGA_SRC_VIR_INFO -
> > RGA_MODE_BASE_REG) >> 2];
> > +     src_act_info.val =3D dest[(RGA_SRC_ACT_INFO -
> > RGA_MODE_BASE_REG) >> 2];
> > +     dst_vir_info.val =3D dest[(RGA_DST_VIR_INFO -
> > RGA_MODE_BASE_REG) >> 2];
> > +     dst_act_info.val =3D dest[(RGA_DST_ACT_INFO -
> > RGA_MODE_BASE_REG) >> 2];
> > +
> > +     src_info.data.format =3D ctx->in.fmt->hw_format;
> > +     src_info.data.swap =3D ctx->in.fmt->color_swap;
> > +     dst_info.data.format =3D ctx->out.fmt->hw_format;
> > +     dst_info.data.swap =3D ctx->out.fmt->color_swap;
> > +
> > +     if (ctx->in.fmt->hw_format >=3D RGA_COLOR_FMT_YUV422SP) {
> > +             if (ctx->out.fmt->hw_format <
> > RGA_COLOR_FMT_YUV422SP)
> > +                     src_info.data.csc_mode =3D
> > RGA_SRC_CSC_MODE_BT601_R0;
> > +     }
> > +     if (ctx->out.fmt->hw_format >=3D RGA_COLOR_FMT_YUV422SP)
> > +             dst_info.data.csc_mode =3D RGA_DST_CSC_MODE_BT601_R0;
> > +
> > +     if (ctx->op =3D=3D OP_SOLID_FILL) {
> > +
> > +             /*
> > +              * Configure the target color to foreground color.
> > +              */
> > +             dest[(RGA_SRC_FG_COLOR - RGA_MODE_BASE_REG) >> 2] =3D
> > +                 ctx->fill_color;
> > +             dst_vir_info.data.vir_stride =3D ctx->out.stride >> 2;
> > +             dst_act_info.data.act_height =3D dst_h - 1;
> > +             dst_act_info.data.act_width =3D dst_w - 1;
> > +
> > +             offsets =3D
> > +                 rga_get_addr_offset(&ctx->out, dst_x, dst_y,
> > dst_w, dst_h);
> > +             dst_offset =3D &offsets.left_top;
> > +
> > +             goto write_dst;
> > +     }
> > +
> > +     if (ctx->vflip) {
> > +             src_info.data.mir_mode |=3D RGA_SRC_MIRR_MODE_X;
> > +     }
> > +
> > +     if (ctx->hflip) {
> > +             src_info.data.mir_mode |=3D RGA_SRC_MIRR_MODE_Y;
> > +     }
> > +
> > +     switch (ctx->rotate) {
> > +     case 90:
> > +             src_info.data.rot_mode =3D RGA_SRC_ROT_MODE_90_DEGREE;
> > +             break;
> > +     case 180:
> > +             src_info.data.rot_mode =3D
> > RGA_SRC_ROT_MODE_180_DEGREE;
> > +             break;
> > +     case 270:
> > +             src_info.data.rot_mode =3D
> > RGA_SRC_ROT_MODE_270_DEGREE;
> > +             break;
> > +     default:
> > +             src_info.data.rot_mode =3D RGA_SRC_ROT_MODE_0_DEGREE;
> > +             break;
> > +     }
> > +
> > +     /*
> > +      * Cacluate the up/down scaling mode/factor.
> > +      *
> > +      * RGA used to scale the picture first, and then rotate
> > second,
> > +      * so we need to swap the w/h when rotate degree is 90/270.
> > +      */
> > +     if (src_info.data.rot_mode =3D=3D RGA_SRC_ROT_MODE_90_DEGREE
> > +         || src_info.data.rot_mode =3D=3D
> > RGA_SRC_ROT_MODE_270_DEGREE) {
> > +             if (rga->version.major =3D=3D 0 || rga->version.minor =3D=
=3D
> > 0) {
> > +                     if (dst_w =3D=3D src_h)
> > +                             src_h -=3D 8;
> > +                     if (abs(src_w - dst_h) < 16)
> > +                             src_w -=3D 16;
> > +             }
> > +
> > +             scale_dst_h =3D dst_w;
> > +             scale_dst_w =3D dst_h;
> > +     } else {
> > +             scale_dst_w =3D dst_w;
> > +             scale_dst_h =3D dst_h;
> > +     }
> > +
> > +     if (src_w =3D=3D scale_dst_w) {
> > +             src_info.data.hscl_mode =3D RGA_SRC_HSCL_MODE_NO;
> > +             x_factor.val =3D 0;
> > +     } else if (src_w > scale_dst_w) {
> > +             src_info.data.hscl_mode =3D RGA_SRC_HSCL_MODE_DOWN;
> > +             x_factor.data.down_scale_factor =3D
> > +                 rga_get_scaling(src_w, scale_dst_w) + 1;
> > +     } else {
> > +             src_info.data.hscl_mode =3D RGA_SRC_HSCL_MODE_UP;
> > +             x_factor.data.up_scale_factor =3D
> > +                 rga_get_scaling(src_w - 1, scale_dst_w - 1);
> > +     }
> > +
> > +     if (src_h =3D=3D scale_dst_h) {
> > +             src_info.data.vscl_mode =3D RGA_SRC_VSCL_MODE_NO;
> > +             y_factor.val =3D 0;
> > +     } else if (src_h > scale_dst_h) {
> > +             src_info.data.vscl_mode =3D RGA_SRC_VSCL_MODE_DOWN;
> > +             y_factor.data.down_scale_factor =3D
> > +                 rga_get_scaling(src_h, scale_dst_h) + 1;
> > +     } else {
> > +             src_info.data.vscl_mode =3D RGA_SRC_VSCL_MODE_UP;
> > +             y_factor.data.up_scale_factor =3D
> > +                 rga_get_scaling(src_h - 1, scale_dst_h - 1);
> > +     }
> > +
> > +     /*
> > +      * Cacluate the framebuffer virtual strides and active size,
> > +      * note that the step of vir_stride / vir_width is 4 byte
> > words
> > +      */
> > +     src_vir_info.data.vir_stride =3D ctx->in.stride >> 2;
> > +     src_vir_info.data.vir_width =3D ctx->in.stride >> 2;
> > +
> > +     src_act_info.data.act_height =3D src_h - 1;
> > +     src_act_info.data.act_width =3D src_w - 1;
> > +
> > +     dst_vir_info.data.vir_stride =3D ctx->out.stride >> 2;
> > +     dst_act_info.data.act_height =3D dst_h - 1;
> > +     dst_act_info.data.act_width =3D dst_w - 1;
> > +
> > +     /*
> > +      * Cacluate the source framebuffer base address with offset
> > pixel.
> > +      */
> > +     src_offsets =3D rga_get_addr_offset(&ctx->in, src_x, src_y,
> > src_w, src_h);
> > +
> > +     /*
> > +      * Configure the dest framebuffer base address with pixel
> > offset.
> > +      */
> > +     offsets =3D rga_get_addr_offset(&ctx->out, dst_x, dst_y,
> > dst_w, dst_h);
> > +     dst_offset =3D rga_lookup_draw_pos(&offsets,
> > src_info.data.rot_mode,
> > +                                      src_info.data.mir_mode);
> > +
> > +     dest[(RGA_SRC_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =3D
> > +         src_offsets.left_top.y_off;
> > +     dest[(RGA_SRC_CB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =3D
> > +         src_offsets.left_top.u_off;
> > +     dest[(RGA_SRC_CR_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =3D
> > +         src_offsets.left_top.v_off;
> > +
> > +     dest[(RGA_SRC_X_FACTOR - RGA_MODE_BASE_REG) >> 2] =3D
> > x_factor.val;
> > +     dest[(RGA_SRC_Y_FACTOR - RGA_MODE_BASE_REG) >> 2] =3D
> > y_factor.val;
> > +     dest[(RGA_SRC_VIR_INFO - RGA_MODE_BASE_REG) >> 2] =3D
> > src_vir_info.val;
> > +     dest[(RGA_SRC_ACT_INFO - RGA_MODE_BASE_REG) >> 2] =3D
> > src_act_info.val;
> > +
> > +     dest[(RGA_SRC_INFO - RGA_MODE_BASE_REG) >> 2] =3D
> > src_info.val;
> > +
> > +write_dst:
> > +     dest[(RGA_DST_Y_RGB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =3D
> > +         dst_offset->y_off;
> > +     dest[(RGA_DST_CB_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =3D
> > +         dst_offset->u_off;
> > +     dest[(RGA_DST_CR_BASE_ADDR - RGA_MODE_BASE_REG) >> 2] =3D
> > +         dst_offset->v_off;
> > +
> > +     dest[(RGA_DST_VIR_INFO - RGA_MODE_BASE_REG) >> 2] =3D
> > dst_vir_info.val;
> > +     dest[(RGA_DST_ACT_INFO - RGA_MODE_BASE_REG) >> 2] =3D
> > dst_act_info.val;
> > +
> > +     dest[(RGA_DST_INFO - RGA_MODE_BASE_REG) >> 2] =3D
> > dst_info.val;
> > +}
> > +
> > +static void rga_cmd_set_mode(struct rga_ctx *ctx)
> > +{
> > +     u32 *dest =3D ctx->cmdbuf_virt;
> > +     union rga_mode_ctrl mode;
> > +
> > +     mode.val =3D 0;
> > +
> > +     switch (ctx->op) {
> > +     case OP_ALPHA_BLEND:
> > +     case OP_COPY:
> > +             mode.data.gradient_sat =3D 1;
> > +             mode.data.render =3D RGA_MODE_RENDER_BITBLT;
> > +             mode.data.bitblt =3D RGA_MODE_BITBLT_MODE_SRC_TO_DST;
> > +             break;
> > +     case OP_SOLID_FILL:
> > +             mode.data.gradient_sat =3D 1;
> > +             mode.data.render =3D RGA_MODE_RENDER_RECTANGLE_FILL;
> > +             mode.data.cf_rop4_pat =3D RGA_MODE_CF_ROP4_SOLID;
> > +             mode.data.bitblt =3D RGA_MODE_BITBLT_MODE_SRC_TO_DST;
> > +
> > +             break;
> > +     }
> > +
> > +     dest[(RGA_MODE_CTRL - RGA_MODE_BASE_REG) >> 2] =3D mode.val;
> > +}
> > +
> > +static void rga_cmd_set_alpha_blend(struct rga_ctx *ctx)
> > +{
> > +     u32 *dest =3D ctx->cmdbuf_virt;
> > +     union rga_alpha_ctrl0 alpha_ctrl0;
> > +     union rga_alpha_ctrl1 alpha_ctrl1;
> > +
> > +     /* just expose reg to userspace */
> > +     alpha_ctrl0.val =3D ctx->alpha0;
> > +     alpha_ctrl1.val =3D ctx->alpha1;
> > +
> > +     dest[(RGA_ALPHA_CTRL0 - RGA_MODE_BASE_REG) >> 2] =3D
> > alpha_ctrl0.val;
> > +     dest[(RGA_ALPHA_CTRL1 - RGA_MODE_BASE_REG) >> 2] =3D
> > alpha_ctrl1.val;
> > +}
> > +
> > +void rga_cmd_set(struct rga_ctx *ctx, void *src_mmu_pages, void
> > *dst_mmu_pages)
> > +{
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +
> > +     memset(ctx->cmdbuf_virt, 0, RGA_CMDBUF_SIZE * 4);
> > +
> > +     if (ctx->op !=3D OP_SOLID_FILL) {
> > +             rga_cmd_set_src_addr(ctx, src_mmu_pages);
> > +     }
> > +     rga_cmd_set_dst_addr(ctx, dst_mmu_pages);
> > +     rga_cmd_set_mode(ctx);
> > +
> > +     if (ctx->op =3D=3D OP_ALPHA_BLEND) {
> > +             /*
> > +              * Due to hardware bug,
> > +              * src1 mmu also should be configured when use alpha
> > blending.
> > +              */
> > +             rga_cmd_set_src1_addr(ctx, src_mmu_pages);
> > +             rga_cmd_set_alpha_blend(ctx);
> > +     }
> > +
> > +     rga_cmd_set_trans_info(ctx);
> > +
> > +     rga_write(rga, RGA_CMD_BASE, ctx->cmdbuf_phy);
> > +}
> > +
> > +void rga_write(struct rockchip_rga *rga, u32 reg, u32 value)
> > +{
> > +     writel(value, rga->regs + reg);
> > +}
> > +
> > +u32 rga_read(struct rockchip_rga *rga, u32 reg)
> > +{
> > +     return readl(rga->regs + reg);
> > +}
> > +
> > +void rga_mod(struct rockchip_rga *rga, u32 reg, u32 val, u32 mask)
> > +{
> > +     u32 temp =3D rga_read(rga, reg) & ~(mask);
> > +
> > +     temp |=3D val & mask;
> > +     rga_write(rga, reg, temp);
> > +}
> > +
> > +void rga_start(struct rockchip_rga *rga)
> > +{
> > +     struct rga_ctx *ctx =3D rga->curr;
> > +
> > +     /* sync CMD buf for RGA */
> > +     dma_sync_single_for_device(rga->dev, ctx->cmdbuf_phy,
> > +                                PAGE_SIZE, DMA_BIDIRECTIONAL);
> > +
> > +     rga_write(rga, RGA_SYS_CTRL, 0x00);
> > +
> > +     rga_write(rga, RGA_SYS_CTRL, 0x22);
> > +
> > +     rga_write(rga, RGA_INT, 0x600);
> > +
> > +     rga_write(rga, RGA_CMD_CTRL, 0x1);
> > +}
> > diff --git a/drivers/media/platform/rockchip-rga/rga-hw.h
> > b/drivers/media/platform/rockchip-rga/rga-hw.h
> > new file mode 100644
> > index 0000000..783ea64e
> > --- /dev/null
> > +++ b/drivers/media/platform/rockchip-rga/rga-hw.h
> > @@ -0,0 +1,434 @@
> > +/*
> > + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> > + * Author: Jacob Chen <jacob-chen@iotwrt.com>
> > + *
> > + * This software is licensed under the terms of the GNU General
> > Public
> > + * License version 2, as published by the Free Software Foundation,
> > and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#ifndef __RGA_HW_H__
> > +#define __RGA_HW_H__
> > +
> > +#define RGA_CMDBUF_SIZE 0x20
> > +
> > +/* Hardware limits */
> > +#define MAX_WIDTH 8192
> > +#define MAX_HEIGHT 8192
> > +
> > +#define MIN_WIDTH 34
> > +#define MIN_HEIGHT 34
> > +
> > +#define DEFAULT_WIDTH 100
> > +#define DEFAULT_HEIGHT 100
> > +
> > +#define RGA_TIMEOUT 500
> > +
> > +/* Registers adress */
> > +#define RGA_SYS_CTRL 0x0000
> > +#define RGA_CMD_CTRL 0x0004
> > +#define RGA_CMD_BASE 0x0008
> > +#define RGA_INT 0x0010
> > +#define RGA_MMU_CTRL0 0x0014
> > +#define RGA_VERSION_INFO 0x0028
> > +
> > +#define RGA_MODE_BASE_REG 0x0100
> > +#define RGA_MODE_MAX_REG 0x017C
> > +
> > +#define RGA_MODE_CTRL 0x0100
> > +#define RGA_SRC_INFO 0x0104
> > +#define RGA_SRC_Y_RGB_BASE_ADDR 0x0108
> > +#define RGA_SRC_CB_BASE_ADDR 0x010c
> > +#define RGA_SRC_CR_BASE_ADDR 0x0110
> > +#define RGA_SRC1_RGB_BASE_ADDR 0x0114
> > +#define RGA_SRC_VIR_INFO 0x0118
> > +#define RGA_SRC_ACT_INFO 0x011c
> > +#define RGA_SRC_X_FACTOR 0x0120
> > +#define RGA_SRC_Y_FACTOR 0x0124
> > +#define RGA_SRC_BG_COLOR 0x0128
> > +#define RGA_SRC_FG_COLOR 0x012c
> > +#define RGA_SRC_TR_COLOR0 0x0130
> > +#define RGA_SRC_TR_COLOR1 0x0134
> > +
> > +#define RGA_DST_INFO 0x0138
> > +#define RGA_DST_Y_RGB_BASE_ADDR 0x013c
> > +#define RGA_DST_CB_BASE_ADDR 0x0140
> > +#define RGA_DST_CR_BASE_ADDR 0x0144
> > +#define RGA_DST_VIR_INFO 0x0148
> > +#define RGA_DST_ACT_INFO 0x014c
> > +
> > +#define RGA_ALPHA_CTRL0 0x0150
> > +#define RGA_ALPHA_CTRL1 0x0154
> > +#define RGA_FADING_CTRL 0x0158
> > +#define RGA_PAT_CON 0x015c
> > +#define RGA_ROP_CON0 0x0160
> > +#define RGA_ROP_CON1 0x0164
> > +#define RGA_MASK_BASE 0x0168
> > +
> > +#define RGA_MMU_CTRL1 0x016C
> > +#define RGA_MMU_SRC_BASE 0x0170
> > +#define RGA_MMU_SRC1_BASE 0x0174
> > +#define RGA_MMU_DST_BASE 0x0178
> > +
> > +/* Registers value */
> > +#define RGA_MODE_RENDER_BITBLT 0
> > +#define RGA_MODE_RENDER_COLOR_PALETTE 1
> > +#define RGA_MODE_RENDER_RECTANGLE_FILL 2
> > +#define RGA_MODE_RENDER_UPDATE_PALETTE_LUT_RAM 3
> > +
> > +#define RGA_MODE_BITBLT_MODE_SRC_TO_DST 0
> > +#define RGA_MODE_BITBLT_MODE_SRC_SRC1_TO_DST 1
> > +
> > +#define RGA_MODE_CF_ROP4_SOLID 0
> > +#define RGA_MODE_CF_ROP4_PATTERN 1
> > +
> > +#define RGA_COLOR_FMT_ABGR8888 0
> > +#define RGA_COLOR_FMT_XBGR8888 1
> > +#define RGA_COLOR_FMT_BGR888 2
> > +#define RGA_COLOR_FMT_BGR565 4
> > +#define RGA_COLOR_FMT_ABGR1555 5
> > +#define RGA_COLOR_FMT_ABGR4444 6
> > +#define RGA_COLOR_FMT_YUV422SP 8
> > +#define RGA_COLOR_FMT_YUV422P 9
> > +#define RGA_COLOR_FMT_YUV420SP 10
> > +#define RGA_COLOR_FMT_YUV420P 11
> > +/* SRC_COLOR Palette */
> > +#define RGA_COLOR_FMT_CP_1BPP 12
> > +#define RGA_COLOR_FMT_CP_2BPP 13
> > +#define RGA_COLOR_FMT_CP_4BPP 14
> > +#define RGA_COLOR_FMT_CP_8BPP 15
> > +#define RGA_COLOR_FMT_MASK 15
> > +
> > +#define RGA_COLOR_NONE_SWAP 0
> > +#define RGA_COLOR_RB_SWAP 1
> > +#define RGA_COLOR_ALPHA_SWAP 2
> > +#define RGA_COLOR_UV_SWAP 4
> > +
> > +#define RGA_SRC_CSC_MODE_BYPASS 0
> > +#define RGA_SRC_CSC_MODE_BT601_R0 1
> > +#define RGA_SRC_CSC_MODE_BT601_R1 2
> > +#define RGA_SRC_CSC_MODE_BT709_R0 3
> > +#define RGA_SRC_CSC_MODE_BT709_R1 4
> > +
> > +#define RGA_SRC_ROT_MODE_0_DEGREE 0
> > +#define RGA_SRC_ROT_MODE_90_DEGREE 1
> > +#define RGA_SRC_ROT_MODE_180_DEGREE 2
> > +#define RGA_SRC_ROT_MODE_270_DEGREE 3
> > +
> > +#define RGA_SRC_MIRR_MODE_NO 0
> > +#define RGA_SRC_MIRR_MODE_X 1
> > +#define RGA_SRC_MIRR_MODE_Y 2
> > +#define RGA_SRC_MIRR_MODE_X_Y 3
> > +
> > +#define RGA_SRC_HSCL_MODE_NO 0
> > +#define RGA_SRC_HSCL_MODE_DOWN 1
> > +#define RGA_SRC_HSCL_MODE_UP 2
> > +
> > +#define RGA_SRC_VSCL_MODE_NO 0
> > +#define RGA_SRC_VSCL_MODE_DOWN 1
> > +#define RGA_SRC_VSCL_MODE_UP 2
> > +
> > +#define RGA_SRC_TRANS_ENABLE_R 1
> > +#define RGA_SRC_TRANS_ENABLE_G 2
> > +#define RGA_SRC_TRANS_ENABLE_B 4
> > +#define RGA_SRC_TRANS_ENABLE_A 8
> > +
> > +#define RGA_SRC_BIC_COE_SELEC_CATROM 0
> > +#define RGA_SRC_BIC_COE_SELEC_MITCHELL 1
> > +#define RGA_SRC_BIC_COE_SELEC_HERMITE 2
> > +#define RGA_SRC_BIC_COE_SELEC_BSPLINE 3
> > +
> > +#define RGA_DST_DITHER_MODE_888_TO_666 0
> > +#define RGA_DST_DITHER_MODE_888_TO_565 1
> > +#define RGA_DST_DITHER_MODE_888_TO_555 2
> > +#define RGA_DST_DITHER_MODE_888_TO_444 3
> > +
> > +#define RGA_DST_CSC_MODE_BYPASS 0
> > +#define RGA_DST_CSC_MODE_BT601_R0 1
> > +#define RGA_DST_CSC_MODE_BT601_R1 2
> > +#define RGA_DST_CSC_MODE_BT709_R0 3
> > +
> > +#define RGA_ALPHA_ROP_MODE_2 0
> > +#define RGA_ALPHA_ROP_MODE_3 1
> > +#define RGA_ALPHA_ROP_MODE_4 2
> > +
> > +#define RGA_ALPHA_SELECT_ALPHA 1
> > +#define RGA_ALPHA_SELECT_ROP 2
> > +
> > +#define RGA_ALPHA_NORMAL 0
> > +#define RGA_ALPHA_REVERSE 1
> > +
> > +#define RGA_ALPHA_BLEND_GLOBAL 0
> > +#define RGA_ALPHA_BLEND_PIXEL 1
> > +#define RGA_ALPHA_BLEND_MULTIPLY 2
> > +
> > +#define RGA_ALPHA_CAL_CUT 0
> > +#define RGA_ALPHA_CAL_NORMAL 1
> > +
> > +#define RGA_ALPHA_FACTOR_ZERO 0
> > +#define RGA_ALPHA_FACTOR_MAX 1
> > +#define RGA_ALPHA_FACTOR_NORMAL 2
> > +#define RGA_ALPHA_FACTOR_REVERSE 3
> > +#define RGA_ALPHA_FACTOR_OTHER 4
> > +
> > +#define RGA_ALPHA_COLOR_PIXEL 0
> > +#define RGA_ALPHA_COLOR_MULTIPLY_CAL 1
> > +
> > +/* Registers union */
> > +union rga_mode_ctrl {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:2] */
> > +             unsigned int render:3;
> > +             /* [3:6] */
> > +             unsigned int bitblt:1;
> > +             unsigned int cf_rop4_pat:1;
> > +             unsigned int alpha_zero_key:1;
> > +             unsigned int gradient_sat:1;
> > +             /* [7:31] */
> > +             unsigned int reserved:25;
> > +     } data;
> > +};
> > +
> > +union rga_src_info {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:3] */
> > +             unsigned int format:4;
> > +             /* [4:7] */
> > +             unsigned int swap:3;
> > +             unsigned int cp_endian:1;
> > +             /* [8:17] */
> > +             unsigned int csc_mode:2;
> > +             unsigned int rot_mode:2;
> > +             unsigned int mir_mode:2;
> > +             unsigned int hscl_mode:2;
> > +             unsigned int vscl_mode:2;
> > +             /* [18:22] */
> > +             unsigned int trans_mode:1;
> > +             unsigned int trans_enable:4;
> > +             /* [23:25] */
> > +             unsigned int dither_up_en:1;
> > +             unsigned int bic_coe_sel:2;
> > +             /* [26:31] */
> > +             unsigned int reserved:6;
> > +     } data;
> > +};
> > +
> > +union rga_src_vir_info {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int vir_width:15;
> > +             unsigned int reserved:1;
> > +             /* [16:25] */
> > +             unsigned int vir_stride:10;
> > +             /* [26:31] */
> > +             unsigned int reserved1:6;
> > +     } data;
> > +};
> > +
> > +union rga_src_act_info {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int act_width:13;
> > +             unsigned int reserved:3;
> > +             /* [16:31] */
> > +             unsigned int act_height:13;
> > +             unsigned int reserved1:3;
> > +     } data;
> > +};
> > +
> > +union rga_src_x_factor {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int down_scale_factor:16;
> > +             /* [16:31] */
> > +             unsigned int up_scale_factor:16;
> > +     } data;
> > +};
> > +
> > +union rga_src_y_factor {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int down_scale_factor:16;
> > +             /* [16:31] */
> > +             unsigned int up_scale_factor:16;
> > +     } data;
> > +};
> > +
> > +/* Alpha / Red / Green / Blue */
> > +union rga_src_cp_gr_color {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int gradient_x:16;
> > +             /* [16:31] */
> > +             unsigned int gradient_y:16;
> > +     } data;
> > +};
> > +
> > +union rga_src_transparency_color0 {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:7] */
> > +             unsigned int trans_rmin:8;
> > +             /* [8:15] */
> > +             unsigned int trans_gmin:8;
> > +             /* [16:23] */
> > +             unsigned int trans_bmin:8;
> > +             /* [24:31] */
> > +             unsigned int trans_amin:8;
> > +     } data;
> > +};
> > +
> > +union rga_src_transparency_color1 {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:7] */
> > +             unsigned int trans_rmax:8;
> > +             /* [8:15] */
> > +             unsigned int trans_gmax:8;
> > +             /* [16:23] */
> > +             unsigned int trans_bmax:8;
> > +             /* [24:31] */
> > +             unsigned int trans_amax:8;
> > +     } data;
> > +};
> > +
> > +union rga_dst_info {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:3] */
> > +             unsigned int format:4;
> > +             /* [4:6] */
> > +             unsigned int swap:3;
> > +             /* [7:9] */
> > +             unsigned int src1_format:3;
> > +             /* [10:11] */
> > +             unsigned int src1_swap:2;
> > +             /* [12:15] */
> > +             unsigned int dither_up_en:1;
> > +             unsigned int dither_down_en:1;
> > +             unsigned int dither_down_mode:2;
> > +             /* [16:18] */
> > +             unsigned int csc_mode:2;
> > +             unsigned int csc_clip:1;
> > +             /* [19:31] */
> > +             unsigned int reserved:13;
> > +     } data;
> > +};
> > +
> > +union rga_dst_vir_info {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int vir_stride:15;
> > +             unsigned int reserved:1;
> > +             /* [16:31] */
> > +             unsigned int src1_vir_stride:15;
> > +             unsigned int reserved1:1;
> > +     } data;
> > +};
> > +
> > +union rga_dst_act_info {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:15] */
> > +             unsigned int act_width:12;
> > +             unsigned int reserved:4;
> > +             /* [16:31] */
> > +             unsigned int act_height:12;
> > +             unsigned int reserved1:4;
> > +     } data;
> > +};
> > +
> > +union rga_alpha_ctrl0 {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:3] */
> > +             unsigned int rop_en:1;
> > +             unsigned int rop_select:1;
> > +             unsigned int rop_mode:2;
> > +             /* [4:11] */
> > +             unsigned int src_fading_val:8;
> > +             /* [12:20] */
> > +             unsigned int dst_fading_val:8;
> > +             unsigned int mask_endian:1;
> > +             /* [21:31] */
> > +             unsigned int reserved:11;
> > +     } data;
> > +};
> > +
> > +union rga_alpha_ctrl1 {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:1] */
> > +             unsigned int dst_color_m0:1;
> > +             unsigned int src_color_m0:1;
> > +             /* [2:7] */
> > +             unsigned int dst_factor_m0:3;
> > +             unsigned int src_factor_m0:3;
> > +             /* [8:9] */
> > +             unsigned int dst_alpha_cal_m0:1;
> > +             unsigned int src_alpha_cal_m0:1;
> > +             /* [10:13] */
> > +             unsigned int dst_blend_m0:2;
> > +             unsigned int src_blend_m0:2;
> > +             /* [14:15] */
> > +             unsigned int dst_alpha_m0:1;
> > +             unsigned int src_alpha_m0:1;
> > +             /* [16:21] */
> > +             unsigned int dst_factor_m1:3;
> > +             unsigned int src_factor_m1:3;
> > +             /* [22:23] */
> > +             unsigned int dst_alpha_cal_m1:1;
> > +             unsigned int src_alpha_cal_m1:1;
> > +             /* [24:27] */
> > +             unsigned int dst_blend_m1:2;
> > +             unsigned int src_blend_m1:2;
> > +             /* [28:29] */
> > +             unsigned int dst_alpha_m1:1;
> > +             unsigned int src_alpha_m1:1;
> > +             /* [30:31] */
> > +             unsigned int reserved:2;
> > +     } data;
> > +};
> > +
> > +union rga_fading_ctrl {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:7] */
> > +             unsigned int fading_offset_r:8;
> > +             /* [8:15] */
> > +             unsigned int fading_offset_g:8;
> > +             /* [16:23] */
> > +             unsigned int fading_offset_b:8;
> > +             /* [24:31] */
> > +             unsigned int fading_en:1;
> > +             unsigned int reserved:7;
> > +     } data;
> > +};
> > +
> > +union rga_pat_con {
> > +     unsigned int val;
> > +     struct {
> > +             /* [0:7] */
> > +             unsigned int width:8;
> > +             /* [8:15] */
> > +             unsigned int height:8;
> > +             /* [16:23] */
> > +             unsigned int offset_x:8;
> > +             /* [24:31] */
> > +             unsigned int offset_y:8;
> > +     } data;
> > +};
> > +
> > +#endif
> > diff --git a/drivers/media/platform/rockchip-rga/rga.c
> > b/drivers/media/platform/rockchip-rga/rga.c
> > new file mode 100644
> > index 0000000..7292007
> > --- /dev/null
> > +++ b/drivers/media/platform/rockchip-rga/rga.c
> > @@ -0,0 +1,979 @@
> > +/*
> > + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> > + * Author: Jacob Chen <jacob-chen@iotwrt.com>
> > + *
> > + * This software is licensed under the terms of the GNU General
> > Public
> > + * License version 2, as published by the Free Software Foundation,
> > and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/delay.h>
> > +#include <linux/fs.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/reset.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/timer.h>
> > +
> > +#include <linux/platform_device.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-mem2mem.h>
> > +#include <media/videobuf2-dma-sg.h>
> > +#include <media/videobuf2-v4l2.h>
> > +
> > +#include "rga-hw.h"
> > +#include "rga.h"
> > +
> > +static void job_abort(void *prv)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +
> > +     if (rga->curr =3D=3D NULL)  /* No job currently running */
> > +             return;
> > +
> > +     wait_event_timeout(rga->irq_queue,
> > +                        rga->curr =3D=3D NULL,
> > msecs_to_jiffies(RGA_TIMEOUT));
> > +}
> > +
> > +static void device_run(void *prv)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +     struct vb2_buffer *src, *dst;
> > +     unsigned long flags;
> > +
> > +     spin_lock_irqsave(&rga->ctrl_lock, flags);
> > +
> > +     rga->curr =3D ctx;
> > +
> > +     src =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> > +     dst =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> > +
> > +     rga_cmd_set(ctx, rga_buf_find_page(src),
> > rga_buf_find_page(dst));
> > +
> > +     rga_start(rga);
> > +
> > +     spin_unlock_irqrestore(&rga->ctrl_lock, flags);
> > +}
> > +
> > +static irqreturn_t rga_isr(int irq, void *prv)
> > +{
> > +     struct rockchip_rga *rga =3D prv;
> > +     int intr;
> > +
> > +     intr =3D rga_read(rga, RGA_INT) & 0xf;
> > +
> > +     rga_mod(rga, RGA_INT, intr << 4, 0xf << 4);
> > +
> > +     if (intr & 0x04) {
> > +             struct vb2_v4l2_buffer *src, *dst;
> > +             struct rga_ctx *ctx =3D rga->curr;
> > +
> > +             BUG_ON(ctx =3D=3D NULL);
> > +
> > +             rga->curr =3D NULL;
> > +
> > +             src =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +             dst =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +
> > +             BUG_ON(src =3D=3D NULL);
> > +             BUG_ON(dst =3D=3D NULL);
> > +
> > +             dst->timecode =3D src->timecode;
> > +             dst->vb2_buf.timestamp =3D src->vb2_buf.timestamp;
> > +             dst->flags &=3D ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > +             dst->flags |=3D src->flags &
> > V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> > +
> > +             v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
> > +             v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
> > +             v4l2_m2m_job_finish(rga->m2m_dev, ctx->fh.m2m_ctx);
> > +
> > +             wake_up(&rga->irq_queue);
> > +     }
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static struct v4l2_m2m_ops rga_m2m_ops =3D {
> > +     .device_run =3D device_run,
> > +     .job_abort =3D job_abort,
> > +};
> > +
> > +static int
> > +queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue
> > *dst_vq)
> > +{
> > +     struct rga_ctx *ctx =3D priv;
> > +     int ret;
> > +
> > +     src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > +     src_vq->io_modes =3D VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> > +     src_vq->drv_priv =3D ctx;
> > +     src_vq->ops =3D &rga_qops;
> > +     src_vq->mem_ops =3D &vb2_dma_sg_memops;
> > +     src_vq->buf_struct_size =3D sizeof(struct v4l2_m2m_buffer);
> > +     src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +     src_vq->lock =3D &ctx->rga->mutex;
> > +     src_vq->dev =3D ctx->rga->v4l2_dev.dev;
> > +
> > +     ret =3D vb2_queue_init(src_vq);
> > +     if (ret)
> > +             return ret;
> > +
> > +     dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +     dst_vq->io_modes =3D VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> > +     dst_vq->drv_priv =3D ctx;
> > +     dst_vq->ops =3D &rga_qops;
> > +     dst_vq->mem_ops =3D &vb2_dma_sg_memops;
> > +     dst_vq->buf_struct_size =3D sizeof(struct v4l2_m2m_buffer);
> > +     dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +     dst_vq->lock =3D &ctx->rga->mutex;
> > +     dst_vq->dev =3D ctx->rga->v4l2_dev.dev;
> > +
> > +     return vb2_queue_init(dst_vq);
> > +}
> > +
> > +static int rga_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +     struct rga_ctx *ctx =3D container_of(ctrl->handler, struct
> > rga_ctx,
> > +                                        ctrl_handler);
> > +     unsigned long flags;
> > +
> > +     spin_lock_irqsave(&ctx->rga->ctrl_lock, flags);
> > +     switch (ctrl->id) {
> > +     case V4L2_CID_RGA_OP:
> > +             ctx->op =3D ctrl->val;
> > +             break;
> > +     case V4L2_CID_HFLIP:
> > +             ctx->hflip =3D ctrl->val;
> > +             break;
> > +     case V4L2_CID_VFLIP:
> > +             ctx->vflip =3D ctrl->val;
> > +             break;
> > +     case V4L2_CID_ROTATE:
> > +             ctx->rotate =3D ctrl->val;
> > +             break;
> > +     case V4L2_CID_BG_COLOR:
> > +             ctx->fill_color =3D ctrl->val;
> > +             break;
> > +     case V4L2_CID_RGA_ALHPA_REG0:
> > +             ctx->alpha0 =3D ctrl->val;
> > +             break;
> > +     case V4L2_CID_RGA_ALHPA_REG1:
> > +             ctx->alpha1 =3D ctrl->val;
> > +             break;
> > +     }
> > +     spin_unlock_irqrestore(&ctx->rga->ctrl_lock, flags);
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops rga_ctrl_ops =3D {
> > +     .s_ctrl =3D rga_s_ctrl,
> > +};
> > +
> > +static const struct v4l2_ctrl_config op_control =3D {
> > +     .ops =3D &rga_ctrl_ops,
> > +     .id =3D V4L2_CID_RGA_OP,
> > +     .name =3D "Transform operation",
> > +     .type =3D V4L2_CTRL_TYPE_INTEGER,
> > +     .min =3D 0x0,
> > +     .max =3D 0xf,
> > +     .step =3D 1,
> > +     .def =3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config alpha0_control =3D {
> > +     .ops =3D &rga_ctrl_ops,
> > +     .id =3D V4L2_CID_RGA_ALHPA_REG0,
> > +     .name =3D "Exposed alpha blending register 0",
> > +     .type =3D V4L2_CTRL_TYPE_INTEGER,
> > +     .min =3D 0x0,
> > +     .max =3D 0xffffffff,
> > +     .step =3D 1,
> > +     .def =3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config alpha1_control =3D {
> > +     .ops =3D &rga_ctrl_ops,
> > +     .id =3D V4L2_CID_RGA_ALHPA_REG1,
> > +     .name =3D "Exposed alpha blending register 1",
> > +     .type =3D V4L2_CTRL_TYPE_INTEGER,
> > +     .min =3D 0x0,
> > +     .max =3D 0xffffffff,
> > +     .step =3D 1,
> > +     .def =3D 0,
> > +};
> > +
> > +static int rga_setup_ctrls(struct rga_ctx *ctx)
> > +{
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +
> > +     v4l2_ctrl_handler_init(&ctx->ctrl_handler, 7);
> > +
> > +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
> > +                       V4L2_CID_HFLIP, 0, 1, 1, 0);
> > +
> > +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
> > +                       V4L2_CID_VFLIP, 0, 1, 1, 0);
> > +
> > +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
> > +                       V4L2_CID_ROTATE, 0, 270, 90, 0);
> > +
> > +     v4l2_ctrl_new_std(&ctx->ctrl_handler, &rga_ctrl_ops,
> > +                       V4L2_CID_BG_COLOR, 0, 0xffffffff, 1, 0);
> > +
> > +     v4l2_ctrl_new_custom(&ctx->ctrl_handler, &op_control, NULL);
> > +     v4l2_ctrl_new_custom(&ctx->ctrl_handler, &alpha0_control,
> > NULL);
> > +     v4l2_ctrl_new_custom(&ctx->ctrl_handler, &alpha1_control,
> > NULL);
> > +
> > +     if (ctx->ctrl_handler.error) {
> > +             int err =3D ctx->ctrl_handler.error;
> > +             v4l2_err(&rga->v4l2_dev, "%s failed\n", __func__);
> > +             v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +             return err;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +struct rga_fmt formats[] =3D {
> > +     {
> > +             .name =3D "ARGB_8888",
> > +             .fourcc =3D V4L2_PIX_FMT_ARGB32,
> > +             .color_swap =3D RGA_COLOR_RB_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_ABGR8888,
> > +             .depth =3D 32,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "XRGB_8888",
> > +             .fourcc =3D V4L2_PIX_FMT_XRGB32,
> > +             .color_swap =3D RGA_COLOR_RB_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_XBGR8888,
> > +             .depth =3D 32,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "BGRA_8888",
> > +             .fourcc =3D V4L2_PIX_FMT_ABGR32,
> > +             .color_swap =3D RGA_COLOR_ALPHA_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_ABGR8888,
> > +             .depth =3D 32,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "BGRX_8888",
> > +             .fourcc =3D V4L2_PIX_FMT_XBGR32,
> > +             .color_swap =3D RGA_COLOR_ALPHA_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_XBGR8888,
> > +             .depth =3D 32,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "RGB_888",
> > +             .fourcc =3D V4L2_PIX_FMT_RGB24,
> > +             .color_swap =3D RGA_COLOR_RB_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_BGR888,
> > +             .depth =3D 24,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "ARGB_444",
> > +             .fourcc =3D V4L2_PIX_FMT_ARGB444,
> > +             .color_swap =3D RGA_COLOR_RB_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_ABGR4444,
> > +             .depth =3D 16,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "ARGB_1555",
> > +             .fourcc =3D V4L2_PIX_FMT_ARGB555,
> > +             .color_swap =3D RGA_COLOR_RB_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_ABGR1555,
> > +             .depth =3D 16,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "RGB_565",
> > +             .fourcc =3D V4L2_PIX_FMT_RGB565,
> > +             .color_swap =3D RGA_COLOR_RB_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_BGR565,
> > +             .depth =3D 16,
> > +             .uv_factor =3D 1,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "NV_21",
> > +             .fourcc =3D V4L2_PIX_FMT_NV21,
> > +             .color_swap =3D RGA_COLOR_UV_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_YUV420SP,
> > +             .depth =3D 12,
> > +             .uv_factor =3D 4,
> > +             .y_div =3D 2,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "NV_61",
> > +             .fourcc =3D V4L2_PIX_FMT_NV61,
> > +             .color_swap =3D RGA_COLOR_UV_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_YUV422SP,
> > +             .depth =3D 16,
> > +             .uv_factor =3D 2,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "NV_12",
> > +             .fourcc =3D V4L2_PIX_FMT_NV12,
> > +             .color_swap =3D RGA_COLOR_NONE_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_YUV420SP,
> > +             .depth =3D 12,
> > +             .uv_factor =3D 4,
> > +             .y_div =3D 2,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "NV_16",
> > +             .fourcc =3D V4L2_PIX_FMT_NV16,
> > +             .color_swap =3D RGA_COLOR_NONE_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_YUV422SP,
> > +             .depth =3D 16,
> > +             .uv_factor =3D 2,
> > +             .y_div =3D 1,
> > +             .x_div =3D 1,
> > +     },
> > +     {
> > +             .name =3D "YUV_420",
> > +             .fourcc =3D V4L2_PIX_FMT_YUV420,
> > +             .color_swap =3D RGA_COLOR_NONE_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_YUV420P,
> > +             .depth =3D 12,
> > +             .uv_factor =3D 4,
> > +             .y_div =3D 2,
> > +             .x_div =3D 2,
> > +     },
> > +     {
> > +             .name =3D "YUV_422",
> > +             .fourcc =3D V4L2_PIX_FMT_YUV422P,
> > +             .color_swap =3D RGA_COLOR_NONE_SWAP,
> > +             .hw_format =3D RGA_COLOR_FMT_YUV422P,
> > +             .depth =3D 16,
> > +             .uv_factor =3D 2,
> > +             .y_div =3D 1,
> > +             .x_div =3D 2,
> > +     },
> > +};
> > +
> > +#define NUM_FORMATS ARRAY_SIZE(formats)
> > +
> > +struct rga_fmt *rga_fmt_find(struct v4l2_format *f)
> > +{
> > +     unsigned int i;
> > +     for (i =3D 0; i < NUM_FORMATS; i++) {
> > +             if (formats[i].fourcc =3D=3D f->fmt.pix.pixelformat)
> > +                     return &formats[i];
> > +     }
> > +     return NULL;
> > +}
> > +
> > +static struct rga_frame def_frame =3D {
> > +     .width =3D DEFAULT_WIDTH,
> > +     .height =3D DEFAULT_HEIGHT,
> > +     .crop.left =3D 0,
> > +     .crop.top =3D 0,
> > +     .crop.width =3D DEFAULT_WIDTH,
> > +     .crop.height =3D DEFAULT_HEIGHT,
> > +     .fmt =3D &formats[0],
> > +};
> > +
> > +struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum
> > v4l2_buf_type type)
> > +{
> > +     switch (type) {
> > +     case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > +             return &ctx->in;
> > +     case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> > +             return &ctx->out;
> > +     default:
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +}
> > +
> > +static int rga_open(struct file *file)
> > +{
> > +     struct rockchip_rga *rga =3D video_drvdata(file);
> > +     struct rga_ctx *ctx =3D NULL;
> > +     int ret =3D 0;
> > +
> > +     ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +     if (!ctx)
> > +             return -ENOMEM;
> > +     ctx->rga =3D rga;
> > +     /* Set default formats */
> > +     ctx->in =3D def_frame;
> > +     ctx->out =3D def_frame;
> > +
> > +     if (mutex_lock_interruptible(&rga->mutex)) {
> > +             kfree(ctx);
> > +             return -ERESTARTSYS;
> > +     }
> > +     ctx->fh.m2m_ctx =3D v4l2_m2m_ctx_init(rga->m2m_dev, ctx,
> > &queue_init);
> > +     if (IS_ERR(ctx->fh.m2m_ctx)) {
> > +             ret =3D PTR_ERR(ctx->fh.m2m_ctx);
> > +             mutex_unlock(&rga->mutex);
> > +             kfree(ctx);
> > +             return ret;
> > +     }
> > +     v4l2_fh_init(&ctx->fh, video_devdata(file));
> > +     file->private_data =3D &ctx->fh;
> > +     v4l2_fh_add(&ctx->fh);
> > +
> > +     rga_setup_ctrls(ctx);
> > +
> > +     /* Write the default values to the ctx struct */
> > +     v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> > +
> > +     ctx->fh.ctrl_handler =3D &ctx->ctrl_handler;
> > +     mutex_unlock(&rga->mutex);
> > +
> > +     /* Create CMD buffer */
> > +     ctx->cmdbuf_virt =3D dma_alloc_attrs(rga->dev,
> > RGA_CMDBUF_SIZE,
> > +                                        &ctx->cmdbuf_phy,
> > GFP_KERNEL,
> > +                                        DMA_ATTR_WRITE_COMBINE);
> > +
> > +     /* Init RGA private buffer list */
> > +     INIT_LIST_HEAD(&ctx->buffers_list);
> > +
> > +     pm_runtime_get_sync(rga->dev);
> > +
> > +     v4l2_info(&rga->v4l2_dev, "instance opened\n");
> > +     return 0;
> > +}
> > +
> > +static int rga_release(struct file *file)
> > +{
> > +     struct rockchip_rga *rga =3D video_drvdata(file);
> > +     struct rga_ctx *ctx =3D
> > +         container_of(file->private_data, struct rga_ctx, fh);
> > +
> > +     pm_runtime_put(rga->dev);
> > +     v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> > +     if (!list_empty(&ctx->buffers_list)) {
> > +             v4l2_info(&rga->v4l2_dev, "close with unreleased
> > buffers\n");
> > +             rga_buf_clean(ctx);
> > +     }
> > +     v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> > +     v4l2_fh_del(&ctx->fh);
> > +     v4l2_fh_exit(&ctx->fh);
> > +     kfree(ctx);
> > +     v4l2_info(&rga->v4l2_dev, "instance closed\n");
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations rga_fops =3D {
> > +     .owner =3D THIS_MODULE,
> > +     .open =3D rga_open,
> > +     .release =3D rga_release,
> > +     .poll =3D v4l2_m2m_fop_poll,
> > +     .unlocked_ioctl =3D video_ioctl2,
> > +     .mmap =3D v4l2_m2m_fop_mmap,
> > +};
> > +
> > +static int
> > +vidioc_querycap(struct file *file, void *priv, struct
> > v4l2_capability *cap)
> > +{
> > +     strncpy(cap->driver, RGA_NAME, sizeof(cap->driver) - 1);
> > +     strncpy(cap->card, RGA_NAME, sizeof(cap->card) - 1);
> > +     cap->bus_info[0] =3D 0;
> > +     cap->device_caps =3D V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> > +     cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > +     return 0;
> > +}
> > +
> > +static int vidioc_enum_fmt(struct file *file, void *prv, struct
> > v4l2_fmtdesc *f)
> > +{
> > +     struct rga_fmt *fmt;
> > +     if (f->index >=3D NUM_FORMATS)
> > +             return -EINVAL;
> > +     fmt =3D &formats[f->index];
> > +     f->pixelformat =3D fmt->fourcc;
> > +     strncpy(f->description, fmt->name, sizeof(f->description) -
> > 1);
> > +     return 0;
> > +}
> > +
> > +static int vidioc_g_fmt(struct file *file, void *prv, struct
> > v4l2_format *f)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct vb2_queue *vq;
> > +     struct rga_frame *frm;
> > +
> > +     vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +     if (!vq)
> > +             return -EINVAL;
> > +     frm =3D rga_get_frame(ctx, f->type);
> > +     if (IS_ERR(frm))
> > +             return PTR_ERR(frm);
> > +
> > +     f->fmt.pix.width =3D frm->width;
> > +     f->fmt.pix.height =3D frm->height;
> > +     f->fmt.pix.field =3D V4L2_FIELD_NONE;
> > +     f->fmt.pix.pixelformat =3D frm->fmt->fourcc;
> > +     f->fmt.pix.bytesperline =3D frm->stride;
> > +     f->fmt.pix.sizeimage =3D frm->size;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vidioc_try_fmt(struct file *file, void *prv, struct
> > v4l2_format *f)
> > +{
> > +     struct rga_fmt *fmt;
> > +     enum v4l2_field *field;
> > +
> > +     fmt =3D rga_fmt_find(f);
> > +     if (!fmt)
> > +             return -EINVAL;
> > +
> > +     field =3D &f->fmt.pix.field;
> > +     if (*field =3D=3D V4L2_FIELD_ANY)
> > +             *field =3D V4L2_FIELD_NONE;
> > +     else if (*field !=3D V4L2_FIELD_NONE)
> > +             return -EINVAL;
> > +
> > +     if (f->fmt.pix.width > MAX_WIDTH)
> > +             f->fmt.pix.width =3D MAX_WIDTH;
> > +     if (f->fmt.pix.height > MAX_HEIGHT)
> > +             f->fmt.pix.height =3D MAX_HEIGHT;
> > +
> > +     if (f->fmt.pix.width < MIN_WIDTH)
> > +             f->fmt.pix.width =3D MIN_WIDTH;
> > +     if (f->fmt.pix.height < MIN_HEIGHT)
> > +             f->fmt.pix.height =3D MIN_HEIGHT;
> > +
> > +     if (fmt->hw_format >=3D RGA_COLOR_FMT_YUV422SP)
> > +             f->fmt.pix.bytesperline =3D f->fmt.pix.width;
> > +     else
> > +             f->fmt.pix.bytesperline =3D (f->fmt.pix.width * fmt-
> > >depth) >> 3;
> > +
> > +     f->fmt.pix.sizeimage =3D
> > +         f->fmt.pix.height * (f->fmt.pix.width * fmt->depth) >>
> > 3;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vidioc_s_fmt(struct file *file, void *prv, struct
> > v4l2_format *f)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +     struct vb2_queue *vq;
> > +     struct rga_frame *frm;
> > +     struct rga_fmt *fmt;
> > +     int ret =3D 0;
> > +
> > +     /* Adjust all values accordingly to the hardware
> > capabilities
> > +      * and chosen format. */
> > +     ret =3D vidioc_try_fmt(file, prv, f);
> > +     if (ret)
> > +             return ret;
> > +     vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +     if (vb2_is_busy(vq)) {
> > +             v4l2_err(&rga->v4l2_dev, "queue (%d) bust\n", f-
> > >type);
> > +             return -EBUSY;
> > +     }
> > +     frm =3D rga_get_frame(ctx, f->type);
> > +     if (IS_ERR(frm))
> > +             return PTR_ERR(frm);
> > +     fmt =3D rga_fmt_find(f);
> > +     if (!fmt)
> > +             return -EINVAL;
> > +     frm->width =3D f->fmt.pix.width;
> > +     frm->height =3D f->fmt.pix.height;
> > +     frm->size =3D f->fmt.pix.sizeimage;
> > +     frm->fmt =3D fmt;
> > +     frm->stride =3D f->fmt.pix.bytesperline;
> > +
> > +     /* Reset crop settings */
> > +     frm->crop.left =3D 0;
> > +     frm->crop.top =3D 0;
> > +     frm->crop.width =3D frm->width;
> > +     frm->crop.height =3D frm->height;
> > +     return 0;
> > +}
> > +
> > +static int
> > +vidioc_cropcap(struct file *file, void *priv, struct v4l2_cropcap
> > *cr)
> > +{
> > +     struct rga_ctx *ctx =3D priv;
> > +     struct rga_frame *f;
> > +
> > +     f =3D rga_get_frame(ctx, cr->type);
> > +     if (IS_ERR(f))
> > +             return PTR_ERR(f);
> > +
> > +     cr->bounds.left =3D 0;
> > +     cr->bounds.top =3D 0;
> > +     cr->bounds.width =3D f->width;
> > +     cr->bounds.height =3D f->height;
> > +     cr->defrect =3D cr->bounds;
> > +     return 0;
> > +}
> > +
> > +static int vidioc_g_crop(struct file *file, void *prv, struct
> > v4l2_crop *cr)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct rga_frame *f;
> > +
> > +     f =3D rga_get_frame(ctx, cr->type);
> > +     if (IS_ERR(f))
> > +             return PTR_ERR(f);
> > +
> > +     cr->c =3D f->crop;
> > +
> > +     return 0;
> > +}
> > +
> > +static int
> > +vidioc_try_crop(struct file *file, void *prv, const struct v4l2_crop
> > *cr)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct rockchip_rga *rga =3D ctx->rga;
> > +     struct rga_frame *f;
> > +
> > +     f =3D rga_get_frame(ctx, cr->type);
> > +     if (IS_ERR(f))
> > +             return PTR_ERR(f);
> > +
> > +     if (cr->c.top < 0 || cr->c.left < 0) {
> > +             v4l2_err(&rga->v4l2_dev,
> > +                      "doesn't support negative values for top &
> > left. \n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (cr->c.left + cr->c.width > f->width ||
> > +         cr->c.top + cr->c.height > f->height ||
> > +         cr->c.width < MIN_WIDTH || cr->c.height < MIN_HEIGHT) {
> > +             v4l2_err(&rga->v4l2_dev, "unsupport crop value.
> > \n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int
> > +vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop
> > *cr)
> > +{
> > +     struct rga_ctx *ctx =3D prv;
> > +     struct rga_frame *f;
> > +     int ret;
> > +
> > +     ret =3D vidioc_try_crop(file, prv, cr);
> > +     if (ret)
> > +             return ret;
> > +     f =3D rga_get_frame(ctx, cr->type);
> > +     if (IS_ERR(f))
> > +             return PTR_ERR(f);
> > +
> > +     f->crop =3D cr->c;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_ioctl_ops rga_ioctl_ops =3D {
> > +     .vidioc_querycap =3D vidioc_querycap,
> > +
> > +     .vidioc_enum_fmt_vid_cap =3D vidioc_enum_fmt,
> > +     .vidioc_g_fmt_vid_cap =3D vidioc_g_fmt,
> > +     .vidioc_try_fmt_vid_cap =3D vidioc_try_fmt,
> > +     .vidioc_s_fmt_vid_cap =3D vidioc_s_fmt,
> > +
> > +     .vidioc_enum_fmt_vid_out =3D vidioc_enum_fmt,
> > +     .vidioc_g_fmt_vid_out =3D vidioc_g_fmt,
> > +     .vidioc_try_fmt_vid_out =3D vidioc_try_fmt,
> > +     .vidioc_s_fmt_vid_out =3D vidioc_s_fmt,
> > +
> > +     .vidioc_reqbufs =3D v4l2_m2m_ioctl_reqbufs,
> > +     .vidioc_querybuf =3D v4l2_m2m_ioctl_querybuf,
> > +     .vidioc_qbuf =3D v4l2_m2m_ioctl_qbuf,
> > +     .vidioc_dqbuf =3D v4l2_m2m_ioctl_dqbuf,
> > +     .vidioc_prepare_buf =3D v4l2_m2m_ioctl_prepare_buf,
> > +     .vidioc_create_bufs =3D v4l2_m2m_ioctl_create_bufs,
> > +     .vidioc_expbuf =3D v4l2_m2m_ioctl_expbuf,
> > +
> > +     .vidioc_streamon =3D v4l2_m2m_ioctl_streamon,
> > +     .vidioc_streamoff =3D v4l2_m2m_ioctl_streamoff,
> > +
> > +     .vidioc_g_crop =3D vidioc_g_crop,
> > +     .vidioc_s_crop =3D vidioc_s_crop,
> > +     .vidioc_cropcap =3D vidioc_cropcap,
> > +};
> > +
> > +static struct video_device rga_videodev =3D {
> > +     .name =3D "rockchip-rga",
> > +     .fops =3D &rga_fops,
> > +     .ioctl_ops =3D &rga_ioctl_ops,
> > +     .minor =3D -1,
> > +     .release =3D video_device_release,
> > +     .vfl_dir =3D VFL_DIR_M2M,
> > +};
> > +
> > +static int rga_enable_clocks(struct rockchip_rga *rga)
> > +{
> > +     int ret;
> > +
> > +     ret =3D clk_prepare_enable(rga->sclk);
> > +     if (ret) {
> > +             dev_err(rga->dev, "Cannot enable rga sclk: %d\n",
> > ret);
> > +             return ret;
> > +     }
> > +
> > +     ret =3D clk_prepare_enable(rga->aclk);
> > +     if (ret) {
> > +             dev_err(rga->dev, "Cannot enable rga aclk: %d\n",
> > ret);
> > +             goto err_disable_sclk;
> > +     }
> > +
> > +     ret =3D clk_prepare_enable(rga->hclk);
> > +     if (ret) {
> > +             dev_err(rga->dev, "Cannot enable rga hclk: %d\n",
> > ret);
> > +             goto err_disable_aclk;
> > +     }
> > +
> > +     return 0;
> > +
> > +err_disable_sclk:
> > +     clk_disable_unprepare(rga->sclk);
> > +err_disable_aclk:
> > +     clk_disable_unprepare(rga->aclk);
> > +
> > +     return ret;
> > +}
> > +
> > +static int rga_parse_dt(struct rockchip_rga *rga)
> > +{
> > +     struct reset_control *core_rst, *axi_rst, *ahb_rst;
> > +
> > +     core_rst =3D devm_reset_control_get(rga->dev, "core");
> > +     if (IS_ERR(core_rst)) {
> > +             dev_err(rga->dev, "failed to get core reset
> > controller\n");
> > +             return PTR_ERR(core_rst);
> > +     }
> > +
> > +     axi_rst =3D devm_reset_control_get(rga->dev, "axi");
> > +     if (IS_ERR(axi_rst)) {
> > +             dev_err(rga->dev, "failed to get axi reset
> > controller\n");
> > +             return PTR_ERR(axi_rst);
> > +     }
> > +
> > +     ahb_rst =3D devm_reset_control_get(rga->dev, "ahb");
> > +     if (IS_ERR(ahb_rst)) {
> > +             dev_err(rga->dev, "failed to get ahb reset
> > controller\n");
> > +             return PTR_ERR(ahb_rst);
> > +     }
> > +
> > +     reset_control_assert(core_rst);
> > +     udelay(1);
> > +     reset_control_deassert(core_rst);
> > +
> > +     reset_control_assert(axi_rst);
> > +     udelay(1);
> > +     reset_control_deassert(axi_rst);
> > +
> > +     reset_control_assert(ahb_rst);
> > +     udelay(1);
> > +     reset_control_deassert(ahb_rst);
> > +
> > +     rga->sclk =3D devm_clk_get(rga->dev, "sclk");
> > +     if (IS_ERR(rga->sclk)) {
> > +             dev_err(rga->dev, "failed to get sclk clock\n");
> > +             return PTR_ERR(rga->sclk);
> > +     }
> > +
> > +     rga->aclk =3D devm_clk_get(rga->dev, "aclk");
> > +     if (IS_ERR(rga->aclk)) {
> > +             dev_err(rga->dev, "failed to get aclk clock\n");
> > +             return PTR_ERR(rga->aclk);
> > +     }
> > +
> > +     rga->hclk =3D devm_clk_get(rga->dev, "hclk");
> > +     if (IS_ERR(rga->hclk)) {
> > +             dev_err(rga->dev, "failed to get hclk clock\n");
> > +             return PTR_ERR(rga->hclk);
> > +     }
> > +
> > +     return rga_enable_clocks(rga);
> > +}
> > +
> > +static int rga_probe(struct platform_device *pdev)
> > +{
> > +     struct rockchip_rga *rga;
> > +     struct video_device *vfd;
> > +     struct resource *res;
> > +     int ret =3D 0;
> > +     int irq;
> > +
> > +     if (!pdev->dev.of_node)
> > +             return -ENODEV;
> > +
> > +     rga =3D devm_kzalloc(&pdev->dev, sizeof(*rga), GFP_KERNEL);
> > +     if (!rga)
> > +             return -ENOMEM;
> > +
> > +     rga->dev =3D &pdev->dev;
> > +     spin_lock_init(&rga->ctrl_lock);
> > +     mutex_init(&rga->mutex);
> > +
> > +     init_waitqueue_head(&rga->irq_queue);
> > +
> > +     ret =3D rga_parse_dt(rga);
> > +     if (ret) {
> > +             dev_err(&pdev->dev, "Unable to parse OF data\n");
> > +     }
> > +
> > +     pm_runtime_enable(rga->dev);
> > +
> > +     res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +
> > +     rga->regs =3D devm_ioremap_resource(rga->dev, res);
> > +     if (IS_ERR(rga->regs)) {
> > +             ret =3D PTR_ERR(rga->regs);
> > +             goto err_put_clk;
> > +     }
> > +
> > +     irq =3D platform_get_irq(pdev, 0);
> > +     if (irq < 0) {
> > +             dev_err(rga->dev, "failed to get irq\n");
> > +             ret =3D irq;
> > +             goto err_put_clk;
> > +     }
> > +
> > +     ret =3D devm_request_irq(rga->dev, irq, rga_isr, 0,
> > +                            dev_name(rga->dev), rga);
> > +     if (ret < 0) {
> > +             dev_err(rga->dev, "failed to request irq\n");
> > +             goto err_put_clk;
> > +     }
> > +
> > +     pm_runtime_get_sync(rga->dev);
> > +
> > +     rga->version.major =3D (rga_read(rga, RGA_VERSION_INFO) >> 24)
> > & 0xFF;
> > +     rga->version.minor =3D (rga_read(rga, RGA_VERSION_INFO) >> 20)
> > & 0x0F;
> > +
> > +     pm_runtime_put(rga->dev);
> > +
> > +     ret =3D v4l2_device_register(&pdev->dev, &rga->v4l2_dev);
> > +     if (ret)
> > +             goto err_put_clk;
> > +     vfd =3D video_device_alloc();
> > +     if (!vfd) {
> > +             v4l2_err(&rga->v4l2_dev, "Failed to allocate video
> > device\n");
> > +             ret =3D -ENOMEM;
> > +             goto unreg_v4l2_dev;
> > +     }
> > +     *vfd =3D rga_videodev;
> > +     vfd->lock =3D &rga->mutex;
> > +     vfd->v4l2_dev =3D &rga->v4l2_dev;
> > +     ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +     if (ret) {
> > +             v4l2_err(&rga->v4l2_dev, "Failed to register video
> > device\n");
> > +             goto rel_vdev;
> > +     }
> > +
> > +     video_set_drvdata(vfd, rga);
> > +     snprintf(vfd->name, sizeof(vfd->name), "%s",
> > rga_videodev.name);
> > +     rga->vfd =3D vfd;
> > +     v4l2_info(&rga->v4l2_dev, "device registered as
> > /dev/video%d\n",
> > +               vfd->num);
> > +     platform_set_drvdata(pdev, rga);
> > +     rga->m2m_dev =3D v4l2_m2m_init(&rga_m2m_ops);
> > +     if (IS_ERR(rga->m2m_dev)) {
> > +             v4l2_err(&rga->v4l2_dev, "Failed to init mem2mem
> > device\n");
> > +             ret =3D PTR_ERR(rga->m2m_dev);
> > +             goto unreg_video_dev;
> > +     }
> > +
> > +     def_frame.stride =3D (def_frame.width * def_frame.fmt->depth)
> > >> 3;
> > +
> > +     return 0;
> > +
> > +unreg_video_dev:
> > +     video_unregister_device(rga->vfd);
> > +rel_vdev:
> > +     video_device_release(vfd);
> > +unreg_v4l2_dev:
> > +     v4l2_device_unregister(&rga->v4l2_dev);
> > +err_put_clk:
> > +     pm_runtime_disable(rga->dev);
> > +
> > +     return ret;
> > +}
> > +
> > +static int rga_remove(struct platform_device *pdev)
> > +{
> > +     struct rockchip_rga *rga =3D platform_get_drvdata(pdev);
> > +
> > +     v4l2_info(&rga->v4l2_dev, "Removing \n");
> > +     v4l2_m2m_release(rga->m2m_dev);
> > +     video_unregister_device(rga->vfd);
> > +     v4l2_device_unregister(&rga->v4l2_dev);
> > +
> > +     pm_runtime_disable(rga->dev);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct of_device_id rockchip_rga_match[] =3D {
> > +     {
> > +             .compatible =3D "rockchip,rk3288-rga",
> > +     },
> > +     {
> > +             .compatible =3D "rockchip,rk3228-rga",
> > +     },
> > +     {
> > +             .compatible =3D "rockchip,rk3328-rga",
> > +     },
> > +     {
> > +             .compatible =3D "rockchip,rk3399-rga",
> > +     },
> > +     {},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(of, rockchip_rga_match);
> > +
> > +static struct platform_driver rga_pdrv =3D {
> > +     .probe =3D rga_probe,
> > +     .remove =3D rga_remove,
> > +     .driver =3D {
> > +             .name =3D "rockchip-rga",
> > +             .of_match_table =3D rockchip_rga_match,
> > +     },
> > +};
> > +
> > +module_platform_driver(rga_pdrv);
> > +
> > +MODULE_AUTHOR("Jacob Chen <jacob-chen@iotwrt.com>");
> > +MODULE_DESCRIPTION("Rockchip Raster 2d Grapphic Acceleration Unit");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/media/platform/rockchip-rga/rga.h
> > b/drivers/media/platform/rockchip-rga/rga.h
> > new file mode 100644
> > index 0000000..272c4d82
> > --- /dev/null
> > +++ b/drivers/media/platform/rockchip-rga/rga.h
> > @@ -0,0 +1,133 @@
> > +/*
> > + * Copyright (C) Fuzhou Rockchip Electronics Co.Ltd
> > + * Author: Jacob Chen <jacob-chen@iotwrt.com>
> > + *
> > + * This software is licensed under the terms of the GNU General
> > Public
> > + * License version 2, as published by the Free Software Foundation,
> > and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#ifndef __RGA_H__
> > +#define __RGA_H__
> > +
> > +#include <linux/platform_device.h>
> > +#include <media/videobuf2-v4l2.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +
> > +#define RGA_NAME "rockchip-rga"
> > +
> > +struct rga_fmt {
> > +     char *name;
> > +     u32 fourcc;
> > +     int depth;
> > +     u8 uv_factor;
> > +     u8 y_div;
> > +     u8 x_div;
> > +     u8 color_swap;
> > +     u8 hw_format;
> > +};
> > +
> > +struct rga_frame {
> > +     /* Original dimensions */
> > +     u32 width;
> > +     u32 height;
> > +
> > +     /* Crop */
> > +     struct v4l2_rect crop;
> > +
> > +     /* Image format */
> > +     struct rga_fmt *fmt;
> > +
> > +     /* Variables that can calculated once and reused */
> > +     u32 stride;
> > +     u32 size;
> > +};
> > +
> > +struct rockchip_rga_version {
> > +     u32 major;
> > +     u32 minor;
> > +};
> > +
> > +struct rga_buf {
> > +     u32 index;
> > +     u32 type;
> > +     void *mmu_pages;
> > +     struct list_head entry;
> > +};
> > +
> > +struct rga_ctx {
> > +     struct v4l2_fh fh;
> > +     struct rockchip_rga *rga;
> > +     struct rga_frame in;
> > +     struct rga_frame out;
> > +     struct v4l2_ctrl_handler ctrl_handler;
> > +
> > +     /* Control values */
> > +     u32 op;
> > +     u32 hflip;
> > +     u32 vflip;
> > +     u32 rotate;
> > +     u32 fill_color;
> > +     u32 alpha0;
> > +     u32 alpha1;
> > +
> > +     /* CMD Buffers for RGA reading */
> > +     dma_addr_t cmdbuf_phy;
> > +     void *cmdbuf_virt;
> > +
> > +     /* Buffers queued for RGA */
> > +     struct list_head buffers_list;
> > +};
> > +
> > +struct rockchip_rga {
> > +     struct v4l2_device v4l2_dev;
> > +     struct v4l2_m2m_dev *m2m_dev;
> > +     struct video_device *vfd;
> > +
> > +     struct device *dev;
> > +     struct regmap *grf;
> > +     void __iomem *regs;
> > +     struct clk *sclk;
> > +     struct clk *aclk;
> > +     struct clk *hclk;
> > +     struct rockchip_rga_version version;
> > +
> > +     struct mutex mutex;
> > +     spinlock_t ctrl_lock;
> > +
> > +     wait_queue_head_t irq_queue;
> > +
> > +     struct rga_ctx *curr;
> > +};
> > +
> > +/* Controls */
> > +
> > +#define V4L2_CID_RGA_OP (V4L2_CID_USER_BASE | 0x1001)
>
> Could be nice to generalize. We could setup a control and fill the
> values base on porter duff operations, then drivers can implement a
> subset. Right now, there is no generic way for userspace to know if a
> driver is just doing copies with some transformations, or if it can
> actually do alpha blending hence used for composting streams. Note that
> I haven't looked at all possibilities, Freescale IMX.6 seems to have a
> similar driver, which has been wrapped in GStreamer with this proposed
> elements:
>
> https://bugzilla.gnome.org/show_bug.cgi?id=3D772766
>

Yeah, i also want it use a generic api.
"porter duff operations" looks good, i will look at it.

> > +#define V4L2_CID_RGA_ALHPA_REG0 (V4L2_CID_USER_BASE | 0x1002)
> > +#define V4L2_CID_RGA_ALHPA_REG1 (V4L2_CID_USER_BASE | 0x1003)
>
> It's not obvious why there is two CID, and how this differ from
> existing V4L2_CID_ALPHA (the global alpha control).

They are used to calculate factors for below formulas.

    dst alpha =3D Factor1 * src alpha + Factor2 * dst alpha
    dst color =3D Factor3 * src color + Factor4 * dst color

I have no idea how to generalize it, and there is no upstream
application need it,
so i just simply exposed the reg.

> > +
> > +/* Operation values */
> > +#define OP_COPY 0
> > +#define OP_SOLID_FILL 1
> > +#define OP_ALPHA_BLEND 2
> > +
> > +struct rga_frame *rga_get_frame(struct rga_ctx *ctx, enum
> > v4l2_buf_type type);
> > +
> > +/* RGA Buffers Manage Part */
> > +extern const struct vb2_ops rga_qops;
> > +void *rga_buf_find_page(struct vb2_buffer *vb);
> > +void rga_buf_clean(struct rga_ctx *ctx);
> > +
> > +/* RGA Hardware Part */
> > +void rga_write(struct rockchip_rga *rga, u32 reg, u32 value);
> > +u32 rga_read(struct rockchip_rga *rga, u32 reg);
> > +void rga_mod(struct rockchip_rga *rga, u32 reg, u32 val, u32 mask);
> > +void rga_start(struct rockchip_rga *rga);
> > +void rga_cmd_set(struct rga_ctx *ctx, void *src_mmu_pages, void
> > *dst_mmu_pages);
> > +
> > +#endif
