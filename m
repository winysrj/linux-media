Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E41C43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 21:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8FA520859
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 21:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJqjNFqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbfAQVeS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 16:34:18 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:50573 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbfAQVeO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 16:34:14 -0500
Received: by mail-it1-f196.google.com with SMTP id z7so3832692iti.0;
        Thu, 17 Jan 2019 13:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6XlMQnsmipuOWFEG5WKARSYvuFl738Xdz3bdY/k8Dv4=;
        b=WJqjNFqVlzjf/MoalaCd8zpsD/AtVoM+KyjpxPAYgazU4KVZvZRplah9JEV+Heikao
         Nzn02x33+HcCH37aNWVr3DuwniezpaQJYzewKGJgKfY7GRHnta8RndAGAJlhkSE/DWaw
         CLD4Tx6z7N5g2jRiDYkFQO0olcZoWcqyTj48SpIM6B0mtdUTcVnuKldrQl35lwigrY+P
         /Ddpd+MEZZfOJZpVgBwjQkpIC8URCtvW7LIqozQH01d7G3bSrFzsOpcrFCk1Nxlb4vm/
         eD7asE4fw765Ajb7EXdJ2ykOzJLwTd6wUMAvgkATl/1kog0kt43vsZcdlCfheobQ0cA4
         Gj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6XlMQnsmipuOWFEG5WKARSYvuFl738Xdz3bdY/k8Dv4=;
        b=W9w3d++15B+7HLZ1bCFxhZPnYThy5lWjqrO+iDUcif4jkl52W46Se03VkvZQMHHEvq
         hHPuPXqupFrszWTjOJ0Xok2czqJStW523EkfKngtMGmXtMtD0sOsruL6GISSyVyjsDpX
         ZCDKSGajEl8+E49a1foC9BB8i/Cg0ioEe5myxE2o2uzuIH974AHQUy2fj1NdIscvk+M+
         q9y1AB3qndcGGSHMandyPj0LHPrgcV91iTp508J8vuXbn/cR4LyNkF6ybMxPZ/SZYXnY
         5MzWBqI1yEIKTjI2+PMtBmDRRXFCDWQZLo2Lw/8zRNmr+M+VjvIiN71KSwTvWVSJ4DFF
         Dxag==
X-Gm-Message-State: AJcUukf4Rugg70U5R6JByBVer2zg3BmeUsxTyi0F0JS7jozxKIwhilGB
        AH0zMBk8psOCfQdxtoAR4IehBWxpvNNdRVKZgxc=
X-Google-Smtp-Source: ALg8bN4PMm2b8wYkDAp2gxBjXmSLtsPVwzRLyZ5XRBsX3adoQmtazZP3LPbOeQdHKt+Vmspht1xNE3MshUUrfSyS93o=
X-Received: by 2002:a02:1dc8:: with SMTP id 191mr9260593jaj.55.1547760852255;
 Thu, 17 Jan 2019 13:34:12 -0800 (PST)
MIME-Version: 1.0
References: <20190115001945.4806-1-lucmaga@gmail.com> <fc1e3da8-84f9-3a53-32c6-c2dd41c548f0@collabora.com>
In-Reply-To: <fc1e3da8-84f9-3a53-32c6-c2dd41c548f0@collabora.com>
From:   =?UTF-8?Q?Lucas_Magalh=C3=A3es?= <lucmaga@gmail.com>
Date:   Thu, 17 Jan 2019 19:34:00 -0200
Message-ID: <CAK0xOaHY3T99AVJqGLXKwhL=3U7rZD7dwbiFibxdF603mDv6mA@mail.gmail.com>
Subject: Re: [PATCH v2] media: vimc: Add vimc-streamer for stream control
To:     Helen Koike <helen.koike@collabora.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, lkcamp@lists.libreplanetbr.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Helen,

Thanks for the review. Just answer the question you made.
On Tue, Jan 15, 2019 at 2:45 PM Helen Koike <helen.koike@collabora.com> wro=
te:
>
> Hi Lucas,
>
> Thank you for this patch, please see my comments below.
>
> On 1/14/19 10:19 PM, Lucas A. M. Magalhaes wrote:
> > Add a linear pipeline logic for the stream control. It's created by
> > walking backwards on the entity graph. When the stream starts it will
> > simply loop through the pipeline calling the respective process_frame
> > function of each entity.
> >
> > Fixes: f2fe89061d797 ("vimc: Virtual Media Controller core, capture
> > and sensor")
> > Cc: stable@vger.kernel.org # for v4.20
> > Signed-off-by: Lucas A. M. Magalh=C3=A3es <lucmaga@gmail.com>
> > ---
> >
> > The actual approach for streaming frames on vimc uses a recursive
> > logic[1]. This algorithm may cause problems as the stack usage
> > increases a with the topology. For the actual topology almost 1Kb of
> > stack is used if compiled with KASAN on a 64bit architecture. However
> > the topology is fixed and hard-coded on vimc-core[2]. So it's a
> > controlled situation if used as is.
> >
> > [1]
> > The stream starts on vim-sensor's thread
> > https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc=
/vimc-sensor.c#n204
> > It proceeds calling successively vimc_propagate_frame
> > https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc=
/vimc-common.c#n210
> > Then processes_frame on the next entity
> > https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc=
/vimc-scaler.c#n349
> > https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc=
/vimc-debayer.c#n483
> > This goes until the loop ends on a vimc-capture device
> > https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc=
/vimc-capture.c#n358
> >
> > [2]https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/v=
imc/vimc-core.c#n80
> >
> >  drivers/media/platform/vimc/Makefile        |   3 +-
> >  drivers/media/platform/vimc/vimc-capture.c  |  18 +-
> >  drivers/media/platform/vimc/vimc-common.c   |  35 ----
> >  drivers/media/platform/vimc/vimc-common.h   |  15 +-
> >  drivers/media/platform/vimc/vimc-debayer.c  |  26 +--
> >  drivers/media/platform/vimc/vimc-scaler.c   |  28 +--
> >  drivers/media/platform/vimc/vimc-sensor.c   |  56 ++----
> >  drivers/media/platform/vimc/vimc-streamer.c | 197 ++++++++++++++++++++
> >  drivers/media/platform/vimc/vimc-streamer.h |  38 ++++
> >  9 files changed, 269 insertions(+), 147 deletions(-)
> >  create mode 100644 drivers/media/platform/vimc/vimc-streamer.c
> >  create mode 100644 drivers/media/platform/vimc/vimc-streamer.h
> >
> > diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platf=
orm/vimc/Makefile
> > index 4b2e3de7856e..c4fc8e7d365a 100644
> > --- a/drivers/media/platform/vimc/Makefile
> > +++ b/drivers/media/platform/vimc/Makefile
> > @@ -5,6 +5,7 @@ vimc_common-objs :=3D vimc-common.o
> >  vimc_debayer-objs :=3D vimc-debayer.o
> >  vimc_scaler-objs :=3D vimc-scaler.o
> >  vimc_sensor-objs :=3D vimc-sensor.o
> > +vimc_streamer-objs :=3D vimc-streamer.o
> >
> >  obj-$(CONFIG_VIDEO_VIMC) +=3D vimc.o vimc_capture.o vimc_common.o vimc=
-debayer.o \
> > -                             vimc_scaler.o vimc_sensor.o
> > +                         vimc_scaler.o vimc_sensor.o vimc_streamer.o
> > diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media=
/platform/vimc/vimc-capture.c
> > index 3f7e9ed56633..80d7515ec420 100644
> > --- a/drivers/media/platform/vimc/vimc-capture.c
> > +++ b/drivers/media/platform/vimc/vimc-capture.c
> > @@ -24,6 +24,7 @@
> >  #include <media/videobuf2-vmalloc.h>
> >
> >  #include "vimc-common.h"
> > +#include "vimc-streamer.h"
> >
> >  #define VIMC_CAP_DRV_NAME "vimc-capture"
> >
> > @@ -44,7 +45,7 @@ struct vimc_cap_device {
> >       spinlock_t qlock;
> >       struct mutex lock;
> >       u32 sequence;
> > -     struct media_pipeline pipe;
> > +     struct vimc_stream stream;
> >  };
> >
> >  static const struct v4l2_pix_format fmt_default =3D {
> > @@ -248,14 +249,13 @@ static int vimc_cap_start_streaming(struct vb2_qu=
eue *vq, unsigned int count)
> >       vcap->sequence =3D 0;
> >
> >       /* Start the media pipeline */
> > -     ret =3D media_pipeline_start(entity, &vcap->pipe);
> > +     ret =3D media_pipeline_start(entity, &vcap->stream.pipe);
> >       if (ret) {
> >               vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> >               return ret;
> >       }
> >
> > -     /* Enable streaming from the pipe */
> > -     ret =3D vimc_pipeline_s_stream(&vcap->vdev.entity, 1);
> > +     ret =3D vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
> >       if (ret) {
> >               media_pipeline_stop(entity);
> >               vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> > @@ -273,8 +273,7 @@ static void vimc_cap_stop_streaming(struct vb2_queu=
e *vq)
> >  {
> >       struct vimc_cap_device *vcap =3D vb2_get_drv_priv(vq);
> >
> > -     /* Disable streaming from the pipe */
> > -     vimc_pipeline_s_stream(&vcap->vdev.entity, 0);
> > +     vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 0);
> >
> >       /* Stop the media pipeline */
> >       media_pipeline_stop(&vcap->vdev.entity);
> > @@ -355,8 +354,8 @@ static void vimc_cap_comp_unbind(struct device *com=
p, struct device *master,
> >       kfree(vcap);
> >  }
> >
> > -static void vimc_cap_process_frame(struct vimc_ent_device *ved,
> > -                                struct media_pad *sink, const void *fr=
ame)
> > +static void *vimc_cap_process_frame(struct vimc_ent_device *ved,
> > +                                 const void *frame)
> >  {
> >       struct vimc_cap_device *vcap =3D container_of(ved, struct vimc_ca=
p_device,
> >                                                   ved);
> > @@ -370,7 +369,7 @@ static void vimc_cap_process_frame(struct vimc_ent_=
device *ved,
> >                                           typeof(*vimc_buf), list);
> >       if (!vimc_buf) {
> >               spin_unlock(&vcap->qlock);
> > -             return;
> > +             return ERR_PTR(-EAGAIN);
> >       }
> >
> >       /* Remove this entry from the list */
> > @@ -391,6 +390,7 @@ static void vimc_cap_process_frame(struct vimc_ent_=
device *ved,
> >       vb2_set_plane_payload(&vimc_buf->vb2.vb2_buf, 0,
> >                             vcap->format.sizeimage);
> >       vb2_buffer_done(&vimc_buf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
> > +     return NULL;
> >  }
> >
> >  static int vimc_cap_comp_bind(struct device *comp, struct device *mast=
er,
> > diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/=
platform/vimc/vimc-common.c
> > index 867e24dbd6b5..c1a74bb2df58 100644
> > --- a/drivers/media/platform/vimc/vimc-common.c
> > +++ b/drivers/media/platform/vimc/vimc-common.c
> > @@ -207,41 +207,6 @@ const struct vimc_pix_map *vimc_pix_map_by_pixelfo=
rmat(u32 pixelformat)
> >  }
> >  EXPORT_SYMBOL_GPL(vimc_pix_map_by_pixelformat);
> >
> > -int vimc_propagate_frame(struct media_pad *src, const void *frame)
> > -{
> > -     struct media_link *link;
> > -
> > -     if (!(src->flags & MEDIA_PAD_FL_SOURCE))
> > -             return -EINVAL;
> > -
> > -     /* Send this frame to all sink pads that are direct linked */
> > -     list_for_each_entry(link, &src->entity->links, list) {
> > -             if (link->source =3D=3D src &&
> > -                 (link->flags & MEDIA_LNK_FL_ENABLED)) {
> > -                     struct vimc_ent_device *ved =3D NULL;
> > -                     struct media_entity *entity =3D link->sink->entit=
y;
> > -
> > -                     if (is_media_entity_v4l2_subdev(entity)) {
> > -                             struct v4l2_subdev *sd =3D
> > -                                     container_of(entity, struct v4l2_=
subdev,
> > -                                                  entity);
> > -                             ved =3D v4l2_get_subdevdata(sd);
> > -                     } else if (is_media_entity_v4l2_video_device(enti=
ty)) {
> > -                             struct video_device *vdev =3D
> > -                                     container_of(entity,
> > -                                                  struct video_device,
> > -                                                  entity);
> > -                             ved =3D video_get_drvdata(vdev);
> > -                     }
> > -                     if (ved && ved->process_frame)
> > -                             ved->process_frame(ved, link->sink, frame=
);
> > -             }
> > -     }
> > -
> > -     return 0;
> > -}
> > -EXPORT_SYMBOL_GPL(vimc_propagate_frame);
> > -
> >  /* Helper function to allocate and initialize pads */
> >  struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pa=
ds_flag)
> >  {
> > diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/=
platform/vimc/vimc-common.h
> > index 2e9981b18166..6ed969d9efbb 100644
> > --- a/drivers/media/platform/vimc/vimc-common.h
> > +++ b/drivers/media/platform/vimc/vimc-common.h
> > @@ -113,23 +113,12 @@ struct vimc_pix_map {
> >  struct vimc_ent_device {
> >       struct media_entity *ent;
> >       struct media_pad *pads;
> > -     void (*process_frame)(struct vimc_ent_device *ved,
> > -                           struct media_pad *sink, const void *frame);
> > +     void * (*process_frame)(struct vimc_ent_device *ved,
> > +                             const void *frame);
> >       void (*vdev_get_format)(struct vimc_ent_device *ved,
> >                             struct v4l2_pix_format *fmt);
> >  };
> >
> > -/**
> > - * vimc_propagate_frame - propagate a frame through the topology
> > - *
> > - * @src:     the source pad where the frame is being originated
> > - * @frame:   the frame to be propagated
> > - *
> > - * This function will call the process_frame callback from the vimc_en=
t_device
> > - * struct of the nodes directly connected to the @src pad
> > - */
> > -int vimc_propagate_frame(struct media_pad *src, const void *frame);
> > -
> >  /**
> >   * vimc_pads_init - initialize pads
> >   *
> > diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media=
/platform/vimc/vimc-debayer.c
> > index 77887f66f323..7d77c63b99d2 100644
> > --- a/drivers/media/platform/vimc/vimc-debayer.c
> > +++ b/drivers/media/platform/vimc/vimc-debayer.c
> > @@ -321,7 +321,6 @@ static void vimc_deb_set_rgb_mbus_fmt_rgb888_1x24(s=
truct vimc_deb_device *vdeb,
> >  static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >       struct vimc_deb_device *vdeb =3D v4l2_get_subdevdata(sd);
> > -     int ret;
> >
> >       if (enable) {
> >               const struct vimc_pix_map *vpix;
> > @@ -351,22 +350,10 @@ static int vimc_deb_s_stream(struct v4l2_subdev *=
sd, int enable)
> >               if (!vdeb->src_frame)
> >                       return -ENOMEM;
> >
> > -             /* Turn the stream on in the subdevices directly connecte=
d */
> > -             ret =3D vimc_pipeline_s_stream(&vdeb->sd.entity, 1);
> > -             if (ret) {
> > -                     vfree(vdeb->src_frame);
> > -                     vdeb->src_frame =3D NULL;
> > -                     return ret;
> > -             }
> >       } else {
> >               if (!vdeb->src_frame)
> >                       return 0;
> >
> > -             /* Disable streaming from the pipe */
> > -             ret =3D vimc_pipeline_s_stream(&vdeb->sd.entity, 0);
> > -             if (ret)
> > -                     return ret;
> > -
> >               vfree(vdeb->src_frame);
> >               vdeb->src_frame =3D NULL;
> >       }
> > @@ -480,9 +467,8 @@ static void vimc_deb_calc_rgb_sink(struct vimc_deb_=
device *vdeb,
> >       }
> >  }
> >
> > -static void vimc_deb_process_frame(struct vimc_ent_device *ved,
> > -                                struct media_pad *sink,
> > -                                const void *sink_frame)
> > +static void *vimc_deb_process_frame(struct vimc_ent_device *ved,
> > +                                 const void *sink_frame)
> >  {
> >       struct vimc_deb_device *vdeb =3D container_of(ved, struct vimc_de=
b_device,
> >                                                   ved);
> > @@ -491,7 +477,7 @@ static void vimc_deb_process_frame(struct vimc_ent_=
device *ved,
> >
> >       /* If the stream in this node is not active, just return */
> >       if (!vdeb->src_frame)
> > -             return;
> > +             return ERR_PTR(-EINVAL);
> >
> >       for (i =3D 0; i < vdeb->sink_fmt.height; i++)
> >               for (j =3D 0; j < vdeb->sink_fmt.width; j++) {
> > @@ -499,12 +485,8 @@ static void vimc_deb_process_frame(struct vimc_ent=
_device *ved,
> >                       vdeb->set_rgb_src(vdeb, i, j, rgb);
> >               }
> >
> > -     /* Propagate the frame through all source pads */
> > -     for (i =3D 1; i < vdeb->sd.entity.num_pads; i++) {
> > -             struct media_pad *pad =3D &vdeb->sd.entity.pads[i];
> > +     return vdeb->src_frame;
> >
> > -             vimc_propagate_frame(pad, vdeb->src_frame);
> > -     }
> >  }
> >
> >  static void vimc_deb_comp_unbind(struct device *comp, struct device *m=
aster,
> > diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/=
platform/vimc/vimc-scaler.c
> > index b0952ee86296..39b2a73dfcc1 100644
> > --- a/drivers/media/platform/vimc/vimc-scaler.c
> > +++ b/drivers/media/platform/vimc/vimc-scaler.c
> > @@ -217,7 +217,6 @@ static const struct v4l2_subdev_pad_ops vimc_sca_pa=
d_ops =3D {
> >  static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >       struct vimc_sca_device *vsca =3D v4l2_get_subdevdata(sd);
> > -     int ret;
> >
> >       if (enable) {
> >               const struct vimc_pix_map *vpix;
> > @@ -245,22 +244,10 @@ static int vimc_sca_s_stream(struct v4l2_subdev *=
sd, int enable)
> >               if (!vsca->src_frame)
> >                       return -ENOMEM;
> >
> > -             /* Turn the stream on in the subdevices directly connecte=
d */
> > -             ret =3D vimc_pipeline_s_stream(&vsca->sd.entity, 1);
> > -             if (ret) {
> > -                     vfree(vsca->src_frame);
> > -                     vsca->src_frame =3D NULL;
> > -                     return ret;
> > -             }
> >       } else {
> >               if (!vsca->src_frame)
> >                       return 0;
> >
> > -             /* Disable streaming from the pipe */
> > -             ret =3D vimc_pipeline_s_stream(&vsca->sd.entity, 0);
> > -             if (ret)
> > -                     return ret;
> > -
> >               vfree(vsca->src_frame);
> >               vsca->src_frame =3D NULL;
> >       }
> > @@ -346,26 +333,19 @@ static void vimc_sca_fill_src_frame(const struct =
vimc_sca_device *const vsca,
> >                       vimc_sca_scale_pix(vsca, i, j, sink_frame);
> >  }
> >
> > -static void vimc_sca_process_frame(struct vimc_ent_device *ved,
> > -                                struct media_pad *sink,
> > -                                const void *sink_frame)
> > +static void *vimc_sca_process_frame(struct vimc_ent_device *ved,
> > +                                 const void *sink_frame)
> >  {
> >       struct vimc_sca_device *vsca =3D container_of(ved, struct vimc_sc=
a_device,
> >                                                   ved);
> > -     unsigned int i;
> >
> >       /* If the stream in this node is not active, just return */
> >       if (!vsca->src_frame)
> > -             return;
> > +             return ERR_PTR(-EINVAL);
> >
> >       vimc_sca_fill_src_frame(vsca, sink_frame);
> >
> > -     /* Propagate the frame through all source pads */
> > -     for (i =3D 1; i < vsca->sd.entity.num_pads; i++) {
> > -             struct media_pad *pad =3D &vsca->sd.entity.pads[i];
> > -
> > -             vimc_propagate_frame(pad, vsca->src_frame);
> > -     }
> > +     return vsca->src_frame;
> >  };
> >
> >  static void vimc_sca_comp_unbind(struct device *comp, struct device *m=
aster,
> > diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/=
platform/vimc/vimc-sensor.c
> > index 32ca9c6172b1..93961a1e694f 100644
> > --- a/drivers/media/platform/vimc/vimc-sensor.c
> > +++ b/drivers/media/platform/vimc/vimc-sensor.c
> > @@ -16,8 +16,6 @@
> >   */
> >
> >  #include <linux/component.h>
> > -#include <linux/freezer.h>
> > -#include <linux/kthread.h>
> >  #include <linux/module.h>
> >  #include <linux/mod_devicetable.h>
> >  #include <linux/platform_device.h>
> > @@ -201,38 +199,27 @@ static const struct v4l2_subdev_pad_ops vimc_sen_=
pad_ops =3D {
> >       .set_fmt                =3D vimc_sen_set_fmt,
> >  };
> >
> > -static int vimc_sen_tpg_thread(void *data)
> > +static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
> > +                                 const void *sink_frame)
> >  {
> > -     struct vimc_sen_device *vsen =3D data;
> > -     unsigned int i;
> > -
> > -     set_freezable();
> > -     set_current_state(TASK_UNINTERRUPTIBLE);
> > -
> > -     for (;;) {
> > -             try_to_freeze();
> > -             if (kthread_should_stop())
> > -                     break;
> > -
> > -             tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
> > +     struct vimc_sen_device *vsen =3D container_of(ved, struct vimc_se=
n_device,
> > +                                                 ved);
> > +     const struct vimc_pix_map *vpix;
> > +     unsigned int frame_size;
> >
> > -             /* Send the frame to all source pads */
> > -             for (i =3D 0; i < vsen->sd.entity.num_pads; i++)
> > -                     vimc_propagate_frame(&vsen->sd.entity.pads[i],
> > -                                          vsen->frame);
> > +     /* Calculate the frame size */
> > +     vpix =3D vimc_pix_map_by_code(vsen->mbus_format.code);
> > +     frame_size =3D vsen->mbus_format.width * vpix->bpp *
> > +                  vsen->mbus_format.height;
> >
> > -             /* 60 frames per second */
> > -             schedule_timeout(HZ/60);
> > -     }
> > -
> > -     return 0;
> > +     tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
> > +     return vsen->frame;
> >  }
> >
> >  static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >       struct vimc_sen_device *vsen =3D
> >                               container_of(sd, struct vimc_sen_device, =
sd);
> > -     int ret;
> >
> >       if (enable) {
> >               const struct vimc_pix_map *vpix;
> > @@ -258,26 +245,8 @@ static int vimc_sen_s_stream(struct v4l2_subdev *s=
d, int enable)
> >               /* configure the test pattern generator */
> >               vimc_sen_tpg_s_format(vsen);
> >
> > -             /* Initialize the image generator thread */
> > -             vsen->kthread_sen =3D kthread_run(vimc_sen_tpg_thread, vs=
en,
> > -                                     "%s-sen", vsen->sd.v4l2_dev->name=
);
> > -             if (IS_ERR(vsen->kthread_sen)) {
> > -                     dev_err(vsen->dev, "%s: kernel_thread() failed\n"=
,
> > -                             vsen->sd.name);
> > -                     vfree(vsen->frame);
> > -                     vsen->frame =3D NULL;
> > -                     return PTR_ERR(vsen->kthread_sen);
> > -             }
> >       } else {
> > -             if (!vsen->kthread_sen)
> > -                     return 0;
> > -
> > -             /* Stop image generator */
> > -             ret =3D kthread_stop(vsen->kthread_sen);
> > -             if (ret)
> > -                     return ret;
> >
> > -             vsen->kthread_sen =3D NULL;
> >               vfree(vsen->frame);
> >               vsen->frame =3D NULL;
> >               return 0;
> > @@ -413,6 +382,7 @@ static int vimc_sen_comp_bind(struct device *comp, =
struct device *master,
> >       if (ret)
> >               goto err_free_hdl;
> >
> > +     vsen->ved.process_frame =3D vimc_sen_process_frame;
> >       dev_set_drvdata(comp, &vsen->ved);
> >       vsen->dev =3D comp;
> >
> > diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/medi=
a/platform/vimc/vimc-streamer.c
> > new file mode 100644
> > index 000000000000..5d3b607014e0
> > --- /dev/null
> > +++ b/drivers/media/platform/vimc/vimc-streamer.c
> > @@ -0,0 +1,197 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * vimc-streamer.c Virtual Media Controller Driver
> > + *
> > + * Copyright (C) 2018 Lucas A. M. Magalh=C3=A3es <lucmaga@gmail.com>
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/freezer.h>
> > +#include <linux/kthread.h>
> > +
> > +#include "vimc-streamer.h"
> > +
> > +/**
> > + * vimc_get_source_entity - get the entity connected with the first si=
nk pad
> > + *
> > + * @ent:     reference media_entity
> > + *
> > + * Helper function that returns the media entity containing the source=
 pad
> > + * linked with the first sink pad from the given media entity pad list=
.
> > + */
> > +static struct media_entity *vimc_get_source_entity(struct media_entity=
 *ent)
> > +{
> > +     struct media_pad *pad;
> > +     int i;
> > +
> > +     for (i =3D 0; i < ent->num_pads; i++) {
> > +             if (ent->pads[i].flags & MEDIA_PAD_FL_SOURCE)
> > +                     continue;
> > +             pad =3D media_entity_remote_pad(&ent->pads[i]);
> > +             return pad ? pad->entity : NULL;
> > +     }
> > +     return NULL;
> > +}
> > +
> > +/*
> > + * vimc_streamer_pipeline_terminate - Disable stream in all ved in str=
eam
> > + *
> > + * @stream: the pointer to the stream structure with the pipeline to b=
e
> > + *       disabled.
> > + *
> > + * Calls s_stream to disable the stream in each entity of the pipeline
> > + *
> > + */
> > +static void vimc_streamer_pipeline_terminate(struct vimc_stream *strea=
m)
> > +{
> > +     struct media_entity *entity;
> > +     struct v4l2_subdev *sd;
> > +
> > +     do {
> > +             stream->pipe_size--;
> > +             entity =3D stream->ved_pipeline[stream->pipe_size]->ent;
> > +             entity =3D vimc_get_source_entity(entity);
> > +             stream->ved_pipeline[stream->pipe_size] =3D NULL;
> > +             /*
> > +              *  This may occur only if the streamer was not correctly
> > +              *  initialized.
> > +              */
> > +             if (!entity)
> > +                     continue;
>
> You shouldn't need this check, please see below.
>
> > +
> > +             if (!is_media_entity_v4l2_subdev(entity))
> > +                     continue;
> > +
> > +             sd =3D media_entity_to_v4l2_subdev(entity);
> > +             v4l2_subdev_call(sd, video, s_stream, 0);
> > +     } while (stream->pipe_size);
> > +}
> > +
> > +/*
> > + * vimc_streamer_pipeline_init - initializes the stream structure
> > + *
> > + * @stream: the pointer to the stream structure to be initialized
> > + * @ved:    the pointer to the vimc entity initializing the stream
> > + *
> > + * Initializes the stream structure. Walks through the entity graph to
> > + * construct the pipeline used later on the streamer thread.
> > + * Calls s_stream to enable stream in all entities of the pipeline.
> > + */
> > +static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
> > +                             struct vimc_ent_device *ved)
> > +{
> > +     struct vimc_ent_device *source_ved;
> > +     struct media_entity *entity;
> > +     struct video_device *vdev;
> > +     struct v4l2_subdev *sd;
> > +     int ret =3D -EINVAL;
> > +
> > +     stream->pipe_size =3D 0;
> > +     stream->ved_pipeline[stream->pipe_size++] =3D ved;
> > +
> > +     while (stream->pipe_size < VIMC_STREAMER_PIPELINE_MAX_SIZE) {
>
> Should be "<=3D" no? Otherwise pipe_size won't never reach the max value.
> If it is equal, then it will get out of the loop and it's an error.

No. The array is defined as
struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
change to <=3D will cause it to overflow. I could change it to:
struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE+1];
if you think it's easier to understand.

> > +             if (!stream->ved_pipeline[stream->pipe_size-1])
> > +                     return 0;
>
> You can check if it is NULL before assigning it (please see below), so
> you won't need this check here.
>
> > +             entity =3D stream->ved_pipeline[stream->pipe_size-1]->ent=
;
> > +             entity =3D vimc_get_source_entity(entity);
> > +             if (!entity)
> > +                     return 0;
>
> This is already kind of doing the above check for you in the previous
> iteration.
>
> > +             if (is_media_entity_v4l2_subdev(entity)) {
> > +                     sd =3D media_entity_to_v4l2_subdev(entity);
> > +                     ret =3D v4l2_subdev_call(sd, video, s_stream, 1);
> > +                     if (ret && ret !=3D -ENOIOCTLCMD)
> > +                             break;
> > +                     source_ved =3D v4l2_get_subdevdata(sd);
> > +             } else {
> > +                     vdev =3D container_of(entity,
> > +                                         struct video_device,
> > +                                         entity);
> > +                     source_ved =3D video_get_drvdata(vdev);
> > +             }
> > +
>
> source_ved should never be NULL, otherwise its is a bug in one of the
> submodules.
>
> I think you could the following check (in case we don't trust the
> submodules):
>                 if (!source_ved)
>                         break;
>
> before incrementing the pipe_size.
>
> which means that stream->ved_pipeline[] from [0] to
> [stream->pipe_size-1] will never be NULL. And you won't need the check
> you did in vimc_streamer_pipeline_terminate() and you won't need the "if
> (!stream->ved_pipeline[stream->pipe_size-1])" either.
>
> Regards,
> Helen
>
> > +             stream->ved_pipeline[stream->pipe_size++] =3D source_ved;
> > +     }
> > +
> > +     /*
> > +      * If an error occurs during initialization or the pipeline gets =
longer
> > +      * than VIMC_STREAMER_PIPELINE_MAX_SIZE the stream is disabled an=
d
> > +      * returns the error code.
> > +      */
> > +     vimc_streamer_pipeline_terminate(stream);
> > +     return ret;
> > +}
> > +
> > +static int vimc_streamer_thread(void *data)
> > +{
> > +     struct vimc_stream *stream =3D data;
> > +     int i;
> > +
> > +     set_freezable();
> > +     set_current_state(TASK_UNINTERRUPTIBLE);
> > +
> > +     for (;;) {
> > +             try_to_freeze();
> > +             if (kthread_should_stop())
> > +                     break;
> > +
> > +             for (i =3D stream->pipe_size - 1; i >=3D 0; i--) {
> > +                     stream->frame =3D stream->ved_pipeline[i]->proces=
s_frame(
> > +                                     stream->ved_pipeline[i],
> > +                                     stream->frame);
> > +                     if (!stream->frame)
> > +                             break;
> > +                     if (IS_ERR(stream->frame))
> > +                             break;
> > +             }
> > +             //wait for 60hz
> > +             schedule_timeout(HZ / 60);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +int vimc_streamer_s_stream(struct vimc_stream *stream,
> > +                        struct vimc_ent_device *ved,
> > +                        int enable)
> > +{
> > +     int ret;
> > +
> > +     if (!stream || !ved)
> > +             return -EINVAL;
> > +
> > +     if (enable) {
> > +             if (stream->kthread)
> > +                     return 0;
> > +
> > +             ret =3D vimc_streamer_pipeline_init(stream, ved);
> > +             if (ret)
> > +                     return ret;
> > +
> > +             stream->kthread =3D kthread_run(vimc_streamer_thread, str=
eam,
> > +                                           "vimc-streamer thread");
> > +
> > +             if (IS_ERR(stream->kthread))
> > +                     return PTR_ERR(stream->kthread);
> > +
> > +     } else {
> > +             if (!stream->kthread)
> > +                     return 0;
> > +
> > +             ret =3D kthread_stop(stream->kthread);
> > +             if (ret)
> > +                     return ret;
> > +
> > +             stream->kthread =3D NULL;
> > +
> > +             vimc_streamer_pipeline_terminate(stream);
> > +     }
> > +
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vimc_streamer_s_stream);
> > +
> > +MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Streamer");
> > +MODULE_AUTHOR("Lucas A. M. Magalh=C3=A3es <lucmaga@gmail.com>");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/medi=
a/platform/vimc/vimc-streamer.h
> > new file mode 100644
> > index 000000000000..752af2e2d5a2
> > --- /dev/null
> > +++ b/drivers/media/platform/vimc/vimc-streamer.h
> > @@ -0,0 +1,38 @@
> > +/* SPDX-License-Identifier: GPL-2.0+ */
> > +/*
> > + * vimc-streamer.h Virtual Media Controller Driver
> > + *
> > + * Copyright (C) 2018 Lucas A. M. Magalh=C3=A3es <lucmaga@gmail.com>
> > + *
> > + */
> > +
> > +#ifndef _VIMC_STREAMER_H_
> > +#define _VIMC_STREAMER_H_
> > +
> > +#include <media/media-device.h>
> > +
> > +#include "vimc-common.h"
> > +
> > +#define VIMC_STREAMER_PIPELINE_MAX_SIZE 16
> > +
> > +struct vimc_stream {
> > +     struct media_pipeline pipe;
> > +     struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_S=
IZE];
> > +     unsigned int pipe_size;
> > +     u8 *frame;
> > +     struct task_struct *kthread;
> > +};
> > +
> > +/**
> > + * vimc_streamer_s_streamer - start/stop the stream
> > + *
> > + * @stream:  the pointer to the stream to start or stop
> > + * @ved:     The last entity of the streamer pipeline
> > + * @enable:  any non-zero number start the stream, zero stop
> > + *
> > + */
> > +int vimc_streamer_s_stream(struct vimc_stream *stream,
> > +                        struct vimc_ent_device *ved,
> > +                        int enable);
> > +
> > +#endif  //_VIMC_STREAMER_H_
> >

I got the other explanation about the checks. I will soon send the next
version.

Thanks,
Lucas A. M. Magalh=C3=A3es
