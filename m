Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:17088
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750767AbeBGWaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 17:30:03 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH 6/8] v4l: xilinx: dma: Add multi-planar support
Date: Wed, 7 Feb 2018 14:29:36 -0800
Message-ID: <1518042578-22771-7-git-send-email-satishna@xilinx.com>
In-Reply-To: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
References: <1518042578-22771-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current v4l driver supports single plane formats. This patch
will add support to handle multi-planar formats. Updated driver
capabilities to multi-planar, where it can handle both single and
multi-planar formats

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c  | 343 +++++++++++++++++++++++-=
----
 drivers/media/platform/xilinx/xilinx-dma.h  |   2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c |  22 +-
 3 files changed, 309 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/pla=
tform/xilinx/xilinx-dma.c
index cb20ada..656a87e 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -63,6 +63,7 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)
        struct v4l2_subdev_format fmt;
        struct v4l2_subdev *subdev;
        int ret;
+       int width, height;

        subdev =3D xvip_dma_remote_subdev(&dma->pad, &fmt.pad);
        if (subdev =3D=3D NULL)
@@ -73,9 +74,18 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)
        if (ret < 0)
                return ret =3D=3D -ENOIOCTLCMD ? -EINVAL : ret;

-       if (dma->fmtinfo->code !=3D fmt.format.code ||
-           dma->format.height !=3D fmt.format.height ||
-           dma->format.width !=3D fmt.format.width)
+       if (dma->fmtinfo->code !=3D fmt.format.code)
+               return -EINVAL;
+
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
+               width =3D dma->format.fmt.pix_mp.width;
+               height =3D dma->format.fmt.pix_mp.height;
+       } else {
+               width =3D dma->format.fmt.pix.width;
+               height =3D dma->format.fmt.pix.height;
+       }
+
+       if (width !=3D fmt.format.width || height !=3D fmt.format.height)
                return -EINVAL;

        return 0;
@@ -302,6 +312,8 @@ static void xvip_dma_complete(void *param)
 {
        struct xvip_dma_buffer *buf =3D param;
        struct xvip_dma *dma =3D buf->dma;
+       u8 num_planes, i;
+       int sizeimage;

        spin_lock(&dma->queued_lock);
        list_del(&buf->queue);
@@ -310,7 +322,28 @@ static void xvip_dma_complete(void *param)
        buf->buf.field =3D V4L2_FIELD_NONE;
        buf->buf.sequence =3D dma->sequence++;
        buf->buf.vb2_buf.timestamp =3D ktime_get_ns();
-       vb2_set_plane_payload(&buf->buf.vb2_buf, 0, dma->format.sizeimage);
+
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
+               /* Handling contiguous data with mplanes */
+               if (dma->fmtinfo->buffers =3D=3D 1) {
+                       sizeimage =3D
+                               dma->format.fmt.pix_mp.plane_fmt[0].sizeima=
ge;
+                       vb2_set_plane_payload(&buf->buf.vb2_buf, 0, sizeima=
ge);
+               } else {
+                       /* Handling non-contiguous data with mplanes */
+                       num_planes =3D dma->format.fmt.pix_mp.num_planes;
+                       for (i =3D 0; i < num_planes; i++) {
+                               sizeimage =3D
+                                dma->format.fmt.pix_mp.plane_fmt[i].sizeim=
age;
+                               vb2_set_plane_payload(&buf->buf.vb2_buf, i,
+                                                     sizeimage);
+                       }
+               }
+       } else {
+               sizeimage =3D dma->format.fmt.pix.sizeimage;
+               vb2_set_plane_payload(&buf->buf.vb2_buf, 0, sizeimage);
+       }
+
        vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 }

@@ -320,13 +353,48 @@ xvip_dma_queue_setup(struct vb2_queue *vq,
                     unsigned int sizes[], struct device *alloc_devs[])
 {
        struct xvip_dma *dma =3D vb2_get_drv_priv(vq);
+       u8 i;
+       int sizeimage;
+
+       /* Multi planar case: Make sure the image size is large enough */
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
+               if (*nplanes) {
+                       if (*nplanes !=3D dma->format.fmt.pix_mp.num_planes=
)
+                       return -EINVAL;
+
+                       for (i =3D 0; i < *nplanes; i++) {
+                            sizeimage =3D
+                             dma->format.fmt.pix_mp.plane_fmt[i].sizeimage=
;
+                       if (sizes[i] < sizeimage)
+                               return -EINVAL;
+                       }
+               } else {
+                       /* Handling contiguous data with mplanes */
+                       if (dma->fmtinfo->buffers =3D=3D 1) {
+                           *nplanes =3D 1;
+                           sizes[0] =3D
+                             dma->format.fmt.pix_mp.plane_fmt[0].sizeimage=
;
+                           return 0;
+                       } else {
+                           /* Handling non-contiguous data with mplanes */
+                           *nplanes =3D dma->format.fmt.pix_mp.num_planes;
+                           for (i =3D 0; i < *nplanes; i++) {
+                                sizeimage =3D
+                                 dma->format.fmt.pix_mp.plane_fmt[i].sizei=
mage;
+                                sizes[i] =3D sizeimage;
+                           }
+                       }
+               }
+               return 0;
+       }

-       /* Make sure the image size is large enough. */
-       if (*nplanes)
-               return sizes[0] < dma->format.sizeimage ? -EINVAL : 0;
+       /* Single planar case: Make sure the image size is large enough */
+       sizeimage =3D dma->format.fmt.pix.sizeimage;
+       if (*nplanes =3D=3D 1)
+               return sizes[0] < sizeimage ? -EINVAL : 0;

        *nplanes =3D 1;
-       sizes[0] =3D dma->format.sizeimage;
+       sizes[0] =3D sizeimage;

        return 0;
 }
@@ -348,10 +416,11 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *=
vb)
        struct xvip_dma *dma =3D vb2_get_drv_priv(vb->vb2_queue);
        struct xvip_dma_buffer *buf =3D to_xvip_dma_buffer(vbuf);
        struct dma_async_tx_descriptor *desc;
+       u32 flags, luma_size;
        dma_addr_t addr =3D vb2_dma_contig_plane_dma_addr(vb, 0);
-       u32 flags;

-       if (dma->queue.type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+       if (dma->queue.type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+           dma->queue.type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
                flags =3D DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
                dma->xt.dir =3D DMA_DEV_TO_MEM;
                dma->xt.src_sgl =3D false;
@@ -365,10 +434,50 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *=
vb)
                dma->xt.src_start =3D addr;
        }

-       dma->xt.frame_size =3D 1;
-       dma->sgl[0].size =3D dma->format.width * dma->fmtinfo->bpp;
-       dma->sgl[0].icg =3D dma->format.bytesperline - dma->sgl[0].size;
-       dma->xt.numf =3D dma->format.height;
+       /*
+        * DMA IP supports only 2 planes, so one datachunk is sufficient
+        * to get start address of 2nd plane
+        */
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
+               struct v4l2_pix_format_mplane *pix_mp;
+
+               pix_mp =3D &dma->format.fmt.pix_mp;
+               dma->xt.frame_size =3D dma->fmtinfo->num_planes;
+               dma->sgl[0].size =3D pix_mp->width * dma->fmtinfo->bpl_fact=
or;
+               dma->sgl[0].icg =3D pix_mp->plane_fmt[0].bytesperline -
+                                                       dma->sgl[0].size;
+               dma->xt.numf =3D pix_mp->height;
+
+               /*
+                * dst_icg is the number of bytes to jump after last luma a=
ddr
+                * and before first chroma addr
+                */
+
+               /* Handling contiguous data with mplanes */
+               if (dma->fmtinfo->buffers =3D=3D 1) {
+                   dma->sgl[0].dst_icg =3D 0;
+               } else {
+                   /* Handling non-contiguous data with mplanes */
+                   if (vb->num_planes =3D=3D 2) {
+                       dma_addr_t chroma_addr =3D
+                                       vb2_dma_contig_plane_dma_addr(vb, 1=
);
+                       luma_size =3D pix_mp->plane_fmt[0].bytesperline *
+                                                               dma->xt.num=
f;
+                       if (chroma_addr > addr)
+                           dma->sgl[0].dst_icg =3D
+                               chroma_addr - addr - luma_size;
+                   }
+               }
+       } else {
+               struct v4l2_pix_format *pix;
+
+               pix =3D &dma->format.fmt.pix;
+               dma->xt.frame_size =3D dma->fmtinfo->num_planes;
+               dma->sgl[0].size =3D pix->width * dma->fmtinfo->bpl_factor;
+               dma->sgl[0].icg =3D pix->bytesperline - dma->sgl[0].size;
+               dma->xt.numf =3D pix->height;
+               dma->sgl[0].dst_icg =3D dma->sgl[0].size;
+       }

        desc =3D dmaengine_prep_interleaved_dma(dma->dma, &dma->xt, flags);
        if (!desc) {
@@ -496,10 +605,21 @@ xvip_dma_querycap(struct file *file, void *fh, struct=
 v4l2_capability *cap)
        cap->capabilities =3D V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
                          | dma->xdev->v4l2_caps;

-       if (dma->queue.type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
-               cap->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STRE=
AMING;
-       else
-               cap->device_caps =3D V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREA=
MING;
+       cap->device_caps =3D V4L2_CAP_STREAMING;
+       switch (dma->queue.type) {
+       case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+               cap->device_caps |=3D V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+               break;
+       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+               cap->device_caps |=3D V4L2_CAP_VIDEO_CAPTURE;
+               break;
+       case V4L2_CAP_VIDEO_OUTPUT_MPLANE:
+               cap->device_caps |=3D V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+               break;
+       case V4L2_CAP_VIDEO_OUTPUT:
+               cap->device_caps |=3D V4L2_CAP_VIDEO_OUTPUT;
+               break;
+       }

        strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
        strlcpy(cap->card, dma->video.name, sizeof(cap->card));
@@ -523,7 +643,11 @@ xvip_dma_enum_format(struct file *file, void *fh, stru=
ct v4l2_fmtdesc *f)
        if (f->index > 0)
                return -EINVAL;

-       f->pixelformat =3D dma->format.pixelformat;
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
+               f->pixelformat =3D dma->format.fmt.pix_mp.pixelformat;
+       else
+               f->pixelformat =3D dma->format.fmt.pix.pixelformat;
+
        strlcpy(f->description, dma->fmtinfo->description,
                sizeof(f->description));

@@ -536,13 +660,17 @@ xvip_dma_get_format(struct file *file, void *fh, stru=
ct v4l2_format *format)
        struct v4l2_fh *vfh =3D file->private_data;
        struct xvip_dma *dma =3D to_xvip_dma(vfh->vdev);

-       format->fmt.pix =3D dma->format;
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
+               format->fmt.pix_mp =3D dma->format.fmt.pix_mp;
+       else
+               format->fmt.pix =3D dma->format.fmt.pix;

        return 0;
 }

 static void
-__xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
+__xvip_dma_try_format(struct xvip_dma *dma,
+                     struct v4l2_format *format,
                      const struct xvip_video_format **fmtinfo)
 {
        const struct xvip_video_format *info;
@@ -553,40 +681,93 @@ __xvip_dma_try_format(struct xvip_dma *dma, struct v4=
l2_pix_format *pix,
        unsigned int width;
        unsigned int align;
        unsigned int bpl;
+       unsigned int i, hsub, vsub, plane_width, plane_height;

        /* Retrieve format information and select the default format if the
         * requested format isn't supported.
         */
-       info =3D xvip_get_format_by_fourcc(pix->pixelformat);
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
+               info =3D xvip_get_format_by_fourcc(
+                                       format->fmt.pix_mp.pixelformat);
+       else
+               info =3D xvip_get_format_by_fourcc(
+                                       format->fmt.pix.pixelformat);
+
        if (IS_ERR(info))
                info =3D xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);

-       pix->pixelformat =3D info->fourcc;
-       pix->field =3D V4L2_FIELD_NONE;
-
        /* The transfer alignment requirements are expressed in bytes. Comp=
ute
         * the minimum and maximum values, clamp the requested width and co=
nvert
         * it back to pixels.
         */
-       align =3D lcm(dma->align, info->bpp);
+       align =3D lcm(dma->align, info->bpl_factor);
        min_width =3D roundup(XVIP_DMA_MIN_WIDTH, align);
        max_width =3D rounddown(XVIP_DMA_MAX_WIDTH, align);
-       width =3D rounddown(pix->width * info->bpp, align);

-       pix->width =3D clamp(width, min_width, max_width) / info->bpp;
-       pix->height =3D clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
-                           XVIP_DMA_MAX_HEIGHT);
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type)) {
+               struct v4l2_pix_format_mplane *pix_mp;
+
+               pix_mp =3D &format->fmt.pix_mp;
+               pix_mp->field =3D V4L2_FIELD_NONE;
+               width =3D rounddown(pix_mp->width * info->bpl_factor, align=
);
+               pix_mp->width =3D clamp(width, min_width, max_width) /
+                                                       info->bpl_factor;
+               pix_mp->height =3D clamp(pix_mp->height, XVIP_DMA_MIN_HEIGH=
T,
+                                      XVIP_DMA_MAX_HEIGHT);
+
+               /*
+                * Clamp the requested bytes per line value. If the maximum
+                * bytes per line value is zero, the module doesn't support
+                * user configurable line sizes. Override the requested val=
ue
+                * with the minimum in that case.
+                */
+
+               /* Handling contiguous data with mplanes */
+               if (info->buffers =3D=3D 1) {
+                       min_bpl =3D pix_mp->width * info->bpl_factor;
+                       max_bpl =3D rounddown(XVIP_DMA_MAX_WIDTH, dma->alig=
n);
+                       bpl =3D rounddown(pix_mp->plane_fmt[0].bytesperline=
,
+                                       dma->align);
+                       pix_mp->plane_fmt[0].bytesperline =3D clamp(bpl, mi=
n_bpl,
+                                                                 max_bpl);
+                       pix_mp->plane_fmt[0].sizeimage =3D
+                             (pix_mp->width * pix_mp->height * info->bpp) =
>> 3;
+               } else {
+                       /* Handling non-contiguous data with mplanes */
+                       hsub =3D info->hsub;
+                       vsub =3D info->vsub;
+                       for (i =3D 0; i < info->num_planes; i++) {
+                               plane_width =3D pix_mp->width / (i ? hsub :=
 1);
+                               plane_height =3D pix_mp->height / (i ? vsub=
 : 1);
+                               min_bpl =3D plane_width * info->bpl_factor;
+                               max_bpl =3D rounddown(XVIP_DMA_MAX_WIDTH,
+                                                   dma->align);
+                               bpl =3D pix_mp->plane_fmt[i].bytesperline;
+                               bpl =3D rounddown(bpl, dma->align);
+                               pix_mp->plane_fmt[i].bytesperline =3D
+                                               clamp(bpl, min_bpl, max_bpl=
);
+                               pix_mp->plane_fmt[i].sizeimage =3D
+                                       pix_mp->plane_fmt[i].bytesperline *
+                                                               plane_heigh=
t;
+                       }
+               }
+       } else {
+               struct v4l2_pix_format *pix;

-       /* Clamp the requested bytes per line value. If the maximum bytes p=
er
-        * line value is zero, the module doesn't support user configurable=
 line
-        * sizes. Override the requested value with the minimum in that cas=
e.
-        */
-       min_bpl =3D pix->width * info->bpp;
-       max_bpl =3D rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
-       bpl =3D rounddown(pix->bytesperline, dma->align);
+               pix =3D &format->fmt.pix;
+               pix->field =3D V4L2_FIELD_NONE;
+
+               width =3D rounddown(pix->width * info->bpp, align);
+               pix->width =3D clamp(width, min_width, max_width) / info->b=
pp;
+               pix->height =3D clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
+                                   XVIP_DMA_MAX_HEIGHT);

-       pix->bytesperline =3D clamp(bpl, min_bpl, max_bpl);
-       pix->sizeimage =3D pix->bytesperline * pix->height;
+               min_bpl =3D pix->width * info->bpl_factor;
+               max_bpl =3D rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
+               bpl =3D rounddown(pix->bytesperline, dma->align);
+               pix->bytesperline =3D clamp(bpl, min_bpl, max_bpl);
+               pix->sizeimage =3D (pix->width * pix->height * info->bpp) >=
> 3;
+       }

        if (fmtinfo)
                *fmtinfo =3D info;
@@ -598,7 +779,7 @@ xvip_dma_try_format(struct file *file, void *fh, struct=
 v4l2_format *format)
        struct v4l2_fh *vfh =3D file->private_data;
        struct xvip_dma *dma =3D to_xvip_dma(vfh->vdev);

-       __xvip_dma_try_format(dma, &format->fmt.pix, NULL);
+       __xvip_dma_try_format(dma, format, NULL);
        return 0;
 }

@@ -609,12 +790,16 @@ xvip_dma_set_format(struct file *file, void *fh, stru=
ct v4l2_format *format)
        struct xvip_dma *dma =3D to_xvip_dma(vfh->vdev);
        const struct xvip_video_format *info;

-       __xvip_dma_try_format(dma, &format->fmt.pix, &info);
+       __xvip_dma_try_format(dma, format, &info);

        if (vb2_is_busy(&dma->queue))
                return -EBUSY;

-       dma->format =3D format->fmt.pix;
+       if (V4L2_TYPE_IS_MULTIPLANAR(dma->format.type))
+               dma->format.fmt.pix_mp =3D format->fmt.pix_mp;
+       else
+               dma->format.fmt.pix =3D format->fmt.pix;
+
        dma->fmtinfo =3D info;

        return 0;
@@ -623,11 +808,15 @@ xvip_dma_set_format(struct file *file, void *fh, stru=
ct v4l2_format *format)
 static const struct v4l2_ioctl_ops xvip_dma_ioctl_ops =3D {
        .vidioc_querycap                =3D xvip_dma_querycap,
        .vidioc_enum_fmt_vid_cap        =3D xvip_dma_enum_format,
+       .vidioc_enum_fmt_vid_cap_mplane =3D xvip_dma_enum_format,
        .vidioc_g_fmt_vid_cap           =3D xvip_dma_get_format,
+       .vidioc_g_fmt_vid_cap_mplane    =3D xvip_dma_get_format,
        .vidioc_g_fmt_vid_out           =3D xvip_dma_get_format,
        .vidioc_s_fmt_vid_cap           =3D xvip_dma_set_format,
+       .vidioc_s_fmt_vid_cap_mplane    =3D xvip_dma_set_format,
        .vidioc_s_fmt_vid_out           =3D xvip_dma_set_format,
        .vidioc_try_fmt_vid_cap         =3D xvip_dma_try_format,
+       .vidioc_try_fmt_vid_cap_mplane  =3D xvip_dma_try_format,
        .vidioc_try_fmt_vid_out         =3D xvip_dma_try_format,
        .vidioc_reqbufs                 =3D vb2_ioctl_reqbufs,
        .vidioc_querybuf                =3D vb2_ioctl_querybuf,
@@ -661,6 +850,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, s=
truct xvip_dma *dma,
 {
        char name[16];
        int ret;
+       u32 i, hsub, vsub, width, height;

        dma->xdev =3D xdev;
        dma->port =3D port;
@@ -670,17 +860,55 @@ int xvip_dma_init(struct xvip_composite_device *xdev,=
 struct xvip_dma *dma,
        spin_lock_init(&dma->queued_lock);

        dma->fmtinfo =3D xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
-       dma->format.pixelformat =3D dma->fmtinfo->fourcc;
-       dma->format.colorspace =3D V4L2_COLORSPACE_SRGB;
-       dma->format.field =3D V4L2_FIELD_NONE;
-       dma->format.width =3D XVIP_DMA_DEF_WIDTH;
-       dma->format.height =3D XVIP_DMA_DEF_HEIGHT;
-       dma->format.bytesperline =3D dma->format.width * dma->fmtinfo->bpp;
-       dma->format.sizeimage =3D dma->format.bytesperline * dma->format.he=
ight;
+       dma->format.type =3D type;
+
+       if (V4L2_TYPE_IS_MULTIPLANAR(type)) {
+               struct v4l2_pix_format_mplane *pix_mp;
+
+               pix_mp =3D &dma->format.fmt.pix_mp;
+               pix_mp->pixelformat =3D dma->fmtinfo->fourcc;
+               pix_mp->colorspace =3D V4L2_COLORSPACE_SRGB;
+               pix_mp->field =3D V4L2_FIELD_NONE;
+               pix_mp->width =3D XVIP_DMA_DEF_WIDTH;
+
+               /* Handling contiguous data with mplanes */
+               if (dma->fmtinfo->buffers =3D=3D 1) {
+                   pix_mp->plane_fmt[0].bytesperline =3D
+                     pix_mp->width * dma->fmtinfo->bpl_factor;
+                   pix_mp->plane_fmt[0].sizeimage =3D
+                     (pix_mp->width * pix_mp->height * dma->fmtinfo->bpp) =
>> 3;
+               } else {
+                   /* Handling non-contiguous data with mplanes */
+                   hsub =3D dma->fmtinfo->hsub;
+                   vsub =3D dma->fmtinfo->vsub;
+                   for (i =3D 0; i < dma->fmtinfo->num_planes; i++) {
+                               width  =3D pix_mp->width / (i ? hsub : 1);
+                               height =3D pix_mp->height / (i ? vsub : 1);
+                               pix_mp->plane_fmt[i].bytesperline =3D width=
 *
+                                               dma->fmtinfo->bpl_factor;
+                               pix_mp->plane_fmt[i].sizeimage =3D width * =
height;
+                   }
+               }
+       } else {
+               struct v4l2_pix_format *pix;
+
+               pix =3D &dma->format.fmt.pix;
+               pix->pixelformat =3D dma->fmtinfo->fourcc;
+               pix->colorspace =3D V4L2_COLORSPACE_SRGB;
+               pix->field =3D V4L2_FIELD_NONE;
+               pix->width =3D XVIP_DMA_DEF_WIDTH;
+               pix->height =3D XVIP_DMA_DEF_HEIGHT;
+               pix->bytesperline =3D pix->width * dma->fmtinfo->bpl_factor=
;
+               pix->sizeimage =3D
+                       (pix->width * pix->height * dma->fmtinfo->bpp) >> 3=
;
+       }

        /* Initialize the media entity... */
-       dma->pad.flags =3D type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE
-                      ? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+       if (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+           type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+               dma->pad.flags =3D MEDIA_PAD_FL_SINK;
+       else
+               dma->pad.flags =3D MEDIA_PAD_FL_SOURCE;

        ret =3D media_entity_pads_init(&dma->video.entity, 1, &dma->pad);
        if (ret < 0)
@@ -692,11 +920,18 @@ int xvip_dma_init(struct xvip_composite_device *xdev,=
 struct xvip_dma *dma,
        dma->video.queue =3D &dma->queue;
        snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
                 xdev->dev->of_node->name,
-                type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "inpu=
t",
+                (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+                type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+                                       ? "output" : "input",
                 port);
+
        dma->video.vfl_type =3D VFL_TYPE_GRABBER;
-       dma->video.vfl_dir =3D type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE
-                          ? VFL_DIR_RX : VFL_DIR_TX;
+       if (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+           type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+               dma->video.vfl_dir =3D VFL_DIR_RX;
+       else
+               dma->video.vfl_dir =3D VFL_DIR_TX;
+
        dma->video.release =3D video_device_release_empty;
        dma->video.ioctl_ops =3D &xvip_dma_ioctl_ops;
        dma->video.lock =3D &dma->lock;
diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/pla=
tform/xilinx/xilinx-dma.h
index e95d136..b352bef 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.h
+++ b/drivers/media/platform/xilinx/xilinx-dma.h
@@ -83,7 +83,7 @@ struct xvip_dma {
        unsigned int port;

        struct mutex lock;
-       struct v4l2_pix_format format;
+       struct v4l2_format format;
        const struct xvip_video_format *fmtinfo;

        struct vb2_queue queue;
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/pl=
atform/xilinx/xilinx-vipp.c
index 6bb28cd..50ad16d 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -30,6 +30,15 @@
 #define XVIPP_DMA_S2MM                         0
 #define XVIPP_DMA_MM2S                         1

+/*
+ * This is for backward compatiblity for existing applications,
+ * and planned to be deprecated
+ */
+static bool xvip_is_mplane =3D true;
+MODULE_PARM_DESC(is_mplane,
+                "v4l2 device capability to handle multi planar formats");
+module_param_named(is_mplane, xvip_is_mplane, bool, 0444);
+
 /**
  * struct xvip_graph_entity - Entity in the video graph
  * @list: list entry in a graph entities list
@@ -434,7 +443,8 @@ static int xvip_graph_dma_init_one(struct xvip_composit=
e_device *xdev,
                return ret;

        if (strcmp(direction, "input") =3D=3D 0)
-               type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+               type =3D xvip_is_mplane ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLAN=
E :
+                                               V4L2_BUF_TYPE_VIDEO_CAPTURE=
;
        else if (strcmp(direction, "output") =3D=3D 0)
                type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT;
        else
@@ -454,8 +464,14 @@ static int xvip_graph_dma_init_one(struct xvip_composi=
te_device *xdev,

        list_add_tail(&dma->list, &xdev->dmas);

-       xdev->v4l2_caps |=3D type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE
-                        ? V4L2_CAP_VIDEO_CAPTURE : V4L2_CAP_VIDEO_OUTPUT;
+       if (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+               xdev->v4l2_caps |=3D V4L2_CAP_VIDEO_CAPTURE_MPLANE;
+       else if (type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               xdev->v4l2_caps |=3D V4L2_CAP_VIDEO_CAPTURE;
+       else if (type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)
+               xdev->v4l2_caps |=3D V4L2_CAP_VIDEO_OUTPUT;
+       else if (type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+               xdev->v4l2_caps |=3D V4L2_CAP_VIDEO_OUTPUT_MPLANE;

        return 0;
 }
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
