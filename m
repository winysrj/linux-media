Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD4BC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 22:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD462147C
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 22:36:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="0/2WLEwh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfAGWg3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 17:36:29 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33996 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfAGWg3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 17:36:29 -0500
Received: by mail-qt1-f194.google.com with SMTP id r14so2395770qtp.1
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2019 14:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=KWarYeOHhDci32pf6SbBH0Zft+N8wAw4RaexM4mfl/g=;
        b=0/2WLEwhliMc+DfT4c454jUzqhR/HEdcIRAZAsLt2xnKDxhzq5hVT8jnjYBZ9MUf72
         K/3gZxxCnnM0h9HLm0mwSdo04cOBg5LxOVKpPn+UMV+cIuQxSePhYCg4eMLl3rAcAbB+
         rLk48vCtYo6r637zQ7XIdUy/wWyBhYwJg97g95Wzt8MOxTI6HWXC87k1edz2xgtjY9Wd
         sX8diQDMsPz/kRWGQcCVSmRelCZqm4p7ytcZjs/SVAqYOfeN4Ol14Giv41LaBxUS6GAw
         ggLAhd3hd40gYr/3ZigLWg49PzHvYkp+nIwZQiAA/+xhMYp3MsA5dA8NZDMMgVif/nXB
         kbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=KWarYeOHhDci32pf6SbBH0Zft+N8wAw4RaexM4mfl/g=;
        b=DVHvnyg5e3CMxKHmUjeNyJNBoaltQiAdB/Ha6UBwg292FY3lnRugHfEkP1CR9Ouxvf
         HcPb2YSRvMQYw/MX8jR46DJv4TmmBiZhBMCLMNtiI3ButdFGvU3gM3Lwz1stssFK6Dk4
         yrx26oFde3QQw6PQQ+n0zmTsS7vsYmHPGuoxJLWjuINY7nU6RK3VtOy9rlAx5sNzL+pu
         fsS3ZVfFJGLIChT9gwCqPeB6trldYVVr0xJDlNoYHAS1tBjUk10nJYq3jkVXKeLkavvm
         LBha8qP2RAzBD7Y+Gqtqhlsk0PF63aUj6BdpZMF0RF8rBoeUDNntAtLxfD0/KB6Pqjk2
         WyHQ==
X-Gm-Message-State: AA+aEWbpttIpLiwI+LCufAi9R58Y02zrz+3s6SO05HTfMt/uosaEjxLi
        PEc88BtYg2RqiNsHnBtoNli6dQ==
X-Google-Smtp-Source: ALg8bN4yr5yn0UNq+Sxo/sfOlUy50MWdYWhmUem2hB2J8Ppc9aUhvANYuXPnvOnpt2TDBAvFHE6bJg==
X-Received: by 2002:aed:3722:: with SMTP id i31mr63628323qtb.289.1546900586448;
        Mon, 07 Jan 2019 14:36:26 -0800 (PST)
Received: from tpx230-nicolas (modemcable154.55-37-24.static.videotron.ca. [24.37.55.154])
        by smtp.gmail.com with ESMTPSA id x41sm39828821qth.92.2019.01.07.14.36.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Jan 2019 14:36:25 -0800 (PST)
Message-ID: <4acdd5bd4af28f33ae60d4ac244292e71dd9780d.camel@ndufresne.ca>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Date:   Mon, 07 Jan 2019 17:36:23 -0500
In-Reply-To: <20181203114804.17078-1-p.zabel@pengutronix.de>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-TNRJSxGLFXHlpaboFJDN"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-TNRJSxGLFXHlpaboFJDN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 03 d=C3=A9cembre 2018 =C3=A0 12:48 +0100, Philipp Zabel a =C3=A9cr=
it :
> Add a single imx-media mem2mem video device that uses the IPU IC PP
> (image converter post processing) task for scaling and colorspace
> conversion.
> On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
>=20
> The hardware only supports writing to destination buffers up to
> 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> by rendering multiple tiles per frame.

While testing this driver, I found that the color conversion from YUYV
to BGR32 is broken. Our test showed that the output of the m2m driver
is in fact RGBX/8888, a format that does not yet exist in V4L2
interface but that is supported by the imx-drm driver. This was tested
with GStreamer (master of gst-plugins-good), though some changes to
gst-plugins-bad is needed to add the missing format to kmssink. Let me
know if you need this to produce or not.

# To demonstrate (with patched gst-plugins-bad https://paste.fedoraproject.=
org/paste/rs-CbEq7coL4XSKrnWpEDw)
gst-launch-1.0 videotestsrc ! video/x-raw,format=3DYUY2 ! v4l2convert ! vid=
eo/x-raw,format=3DxRGB ! kmssink

# Software fix for the color format produced
gst-launch-1.0 videotestsrc ! video/x-raw,format=3DYUY2 ! v4l2convert ! vid=
eo/x-raw,format=3DxRGB ! capssetter replace=3D0 caps=3D"video/x-raw,format=
=3DRGBx" ! kmssink -v

Also, BGR32 is deprecated and should not be used, this is mapped by=20
imx_media_enum_format() which I believe is already upstream. If that
is, this bug is just inherited from that helper.
>=20
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> [slongerbeam@gmail.com: use ipu_image_convert_adjust(), fix
>  device_run() error handling]
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
> Changes since v4:
>  - No functional changes.
>  - Dropped deprecated TODO comment. This driver has no interaction with
>    the IC task v4l2 subdevices.
>  - Dropped ipu-v3 patches, those are merged independently via imx-drm.
> ---
>  drivers/staging/media/imx/Kconfig             |   1 +
>  drivers/staging/media/imx/Makefile            |   1 +
>  drivers/staging/media/imx/imx-media-dev.c     |  10 +
>  drivers/staging/media/imx/imx-media-mem2mem.c | 873 ++++++++++++++++++
>  drivers/staging/media/imx/imx-media.h         |  10 +
>  5 files changed, 895 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c
>=20
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/im=
x/Kconfig
> index bfc17de56b17..07013cb3cb66 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -6,6 +6,7 @@ config VIDEO_IMX_MEDIA
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_FWNODE
> +	select V4L2_MEM2MEM_DEV
>  	---help---
>  	  Say yes here to enable support for video4linux media controller
>  	  driver for the i.MX5/6 SOC.
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/i=
mx/Makefile
> index 698a4210316e..f2e722d0fa19 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -6,6 +6,7 @@ imx-media-ic-objs :=3D imx-ic-common.o imx-ic-prp.o imx-i=
c-prpencvf.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) +=3D imx-media.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) +=3D imx-media-common.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) +=3D imx-media-capture.o
> +obj-$(CONFIG_VIDEO_IMX_MEDIA) +=3D imx-media-mem2mem.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) +=3D imx-media-vdic.o
>  obj-$(CONFIG_VIDEO_IMX_MEDIA) +=3D imx-media-ic.o
> =20
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/=
media/imx/imx-media-dev.c
> index 4b344a4a3706..0376b52cb784 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -318,6 +318,16 @@ static int imx_media_probe_complete(struct v4l2_asyn=
c_notifier *notifier)
>  		goto unlock;
> =20
>  	ret =3D v4l2_device_register_subdev_nodes(&imxmd->v4l2_dev);
> +	if (ret)
> +		goto unlock;
> +
> +	imxmd->m2m_vdev =3D imx_media_mem2mem_device_init(imxmd);
> +	if (IS_ERR(imxmd->m2m_vdev)) {
> +		ret =3D PTR_ERR(imxmd->m2m_vdev);
> +		goto unlock;
> +	}
> +
> +	ret =3D imx_media_mem2mem_device_register(imxmd->m2m_vdev);
>  unlock:
>  	mutex_unlock(&imxmd->mutex);
>  	if (ret)
> diff --git a/drivers/staging/media/imx/imx-media-mem2mem.c b/drivers/stag=
ing/media/imx/imx-media-mem2mem.c
> new file mode 100644
> index 000000000000..a2a4dca017ce
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-mem2mem.c
> @@ -0,0 +1,873 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * i.MX IPUv3 mem2mem Scaler/CSC driver
> + *
> + * Copyright (C) 2011 Pengutronix, Sascha Hauer
> + * Copyright (C) 2018 Pengutronix, Philipp Zabel
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/version.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <video/imx-ipu-v3.h>
> +#include <video/imx-ipu-image-convert.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "imx-media.h"
> +
> +#define fh_to_ctx(__fh)	container_of(__fh, struct mem2mem_ctx, fh)
> +
> +enum {
> +	V4L2_M2M_SRC =3D 0,
> +	V4L2_M2M_DST =3D 1,
> +};
> +
> +struct mem2mem_priv {
> +	struct imx_media_video_dev vdev;
> +
> +	struct v4l2_m2m_dev   *m2m_dev;
> +	struct device         *dev;
> +
> +	struct imx_media_dev  *md;
> +
> +	struct mutex          mutex;       /* mem2mem device mutex */
> +
> +	atomic_t              num_inst;
> +};
> +
> +#define to_mem2mem_priv(v) container_of(v, struct mem2mem_priv, vdev)
> +
> +/* Per-queue, driver-specific private data */
> +struct mem2mem_q_data {
> +	struct v4l2_pix_format	cur_fmt;
> +	struct v4l2_rect	rect;
> +};
> +
> +struct mem2mem_ctx {
> +	struct mem2mem_priv	*priv;
> +
> +	struct v4l2_fh		fh;
> +	struct mem2mem_q_data	q_data[2];
> +	int			error;
> +	struct ipu_image_convert_ctx *icc;
> +
> +	struct v4l2_ctrl_handler ctrl_hdlr;
> +	int rotate;
> +	bool hflip;
> +	bool vflip;
> +	enum ipu_rotate_mode	rot_mode;
> +};
> +
> +static struct mem2mem_q_data *get_q_data(struct mem2mem_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(type))
> +		return &ctx->q_data[V4L2_M2M_SRC];
> +	else
> +		return &ctx->q_data[V4L2_M2M_DST];
> +}
> +
> +/*
> + * mem2mem callbacks
> + */
> +
> +static void job_abort(void *_ctx)
> +{
> +	struct mem2mem_ctx *ctx =3D _ctx;
> +
> +	if (ctx->icc)
> +		ipu_image_convert_abort(ctx->icc);
> +}
> +
> +static void mem2mem_ic_complete(struct ipu_image_convert_run *run, void =
*_ctx)
> +{
> +	struct mem2mem_ctx *ctx =3D _ctx;
> +	struct mem2mem_priv *priv =3D ctx->priv;
> +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> +
> +	src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +	dst_buf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +
> +	dst_buf->vb2_buf.timestamp =3D src_buf->vb2_buf.timestamp;
> +	dst_buf->timecode =3D src_buf->timecode;
> +
> +	v4l2_m2m_buf_done(src_buf, run->status ? VB2_BUF_STATE_ERROR :
> +						 VB2_BUF_STATE_DONE);
> +	v4l2_m2m_buf_done(dst_buf, run->status ? VB2_BUF_STATE_ERROR :
> +						 VB2_BUF_STATE_DONE);
> +
> +	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
> +	kfree(run);
> +}
> +
> +static void device_run(void *_ctx)
> +{
> +	struct mem2mem_ctx *ctx =3D _ctx;
> +	struct mem2mem_priv *priv =3D ctx->priv;
> +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> +	struct ipu_image_convert_run *run;
> +	int ret;
> +
> +	src_buf =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +	dst_buf =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> +
> +	run =3D kzalloc(sizeof(*run), GFP_KERNEL);
> +	if (!run)
> +		goto err;
> +
> +	run->ctx =3D ctx->icc;
> +	run->in_phys =3D vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
> +	run->out_phys =3D vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
> +
> +	ret =3D ipu_image_convert_queue(run);
> +	if (ret < 0) {
> +		v4l2_err(ctx->priv->vdev.vfd->v4l2_dev,
> +			 "%s: failed to queue: %d\n", __func__, ret);
> +		goto err;
> +	}
> +
> +	return;
> +
> +err:
> +	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
> +}
> +
> +/*
> + * Video ioctls
> + */
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, "imx-media-mem2mem", sizeof(cap->driver) - 1);
> +	strncpy(cap->card, "imx-media-mem2mem", sizeof(cap->card) - 1);
> +	strncpy(cap->bus_info, "platform:imx-media-mem2mem",
> +		sizeof(cap->bus_info) - 1);
> +	cap->device_caps =3D V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int mem2mem_enum_fmt(struct file *file, void *fh,
> +			    struct v4l2_fmtdesc *f)
> +{
> +	u32 fourcc;
> +	int ret;
> +
> +	ret =3D imx_media_enum_format(&fourcc, f->index, CS_SEL_ANY);
> +	if (ret)
> +		return ret;
> +
> +	f->pixelformat =3D fourcc;
> +
> +	return 0;
> +}
> +
> +static int mem2mem_g_fmt(struct file *file, void *priv, struct v4l2_form=
at *f)
> +{
> +	struct mem2mem_ctx *ctx =3D fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data;
> +
> +	q_data =3D get_q_data(ctx, f->type);
> +
> +	f->fmt.pix =3D q_data->cur_fmt;
> +
> +	return 0;
> +}
> +
> +static int mem2mem_try_fmt(struct file *file, void *priv,
> +			   struct v4l2_format *f)
> +{
> +	struct mem2mem_ctx *ctx =3D fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data =3D get_q_data(ctx, f->type);
> +	struct ipu_image test_in, test_out;
> +
> +	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		struct mem2mem_q_data *q_data_in =3D
> +			get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +
> +		test_out.pix =3D f->fmt.pix;
> +		test_in.pix =3D q_data_in->cur_fmt;
> +	} else {
> +		struct mem2mem_q_data *q_data_out =3D
> +			get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +
> +		test_in.pix =3D f->fmt.pix;
> +		test_out.pix =3D q_data_out->cur_fmt;
> +	}
> +
> +	ipu_image_convert_adjust(&test_in, &test_out, ctx->rot_mode);
> +
> +	f->fmt.pix =3D (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) ?
> +		test_out.pix : test_in.pix;
> +
> +	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		f->fmt.pix.colorspace =3D q_data->cur_fmt.colorspace;
> +		f->fmt.pix.ycbcr_enc =3D q_data->cur_fmt.ycbcr_enc;
> +		f->fmt.pix.xfer_func =3D q_data->cur_fmt.xfer_func;
> +		f->fmt.pix.quantization =3D q_data->cur_fmt.quantization;
> +	} else if (f->fmt.pix.colorspace =3D=3D V4L2_COLORSPACE_DEFAULT) {
> +		f->fmt.pix.colorspace =3D V4L2_COLORSPACE_SRGB;
> +		f->fmt.pix.ycbcr_enc =3D V4L2_YCBCR_ENC_DEFAULT;
> +		f->fmt.pix.xfer_func =3D V4L2_XFER_FUNC_DEFAULT;
> +		f->fmt.pix.quantization =3D V4L2_QUANTIZATION_DEFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mem2mem_s_fmt(struct file *file, void *priv, struct v4l2_form=
at *f)
> +{
> +	struct mem2mem_q_data *q_data;
> +	struct mem2mem_ctx *ctx =3D fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	int ret;
> +
> +	vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(ctx->priv->vdev.vfd->v4l2_dev, "%s queue busy\n",
> +			 __func__);
> +		return -EBUSY;
> +	}
> +
> +	q_data =3D get_q_data(ctx, f->type);
> +
> +	ret =3D mem2mem_try_fmt(file, priv, f);
> +	if (ret < 0)
> +		return ret;
> +
> +	q_data->cur_fmt.width =3D f->fmt.pix.width;
> +	q_data->cur_fmt.height =3D f->fmt.pix.height;
> +	q_data->cur_fmt.pixelformat =3D f->fmt.pix.pixelformat;
> +	q_data->cur_fmt.field =3D f->fmt.pix.field;
> +	q_data->cur_fmt.bytesperline =3D f->fmt.pix.bytesperline;
> +	q_data->cur_fmt.sizeimage =3D f->fmt.pix.sizeimage;
> +
> +	/* Reset cropping/composing rectangle */
> +	q_data->rect.left =3D 0;
> +	q_data->rect.top =3D 0;
> +	q_data->rect.width =3D q_data->cur_fmt.width;
> +	q_data->rect.height =3D q_data->cur_fmt.height;
> +
> +	if (f->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		/* Set colorimetry on the output queue */
> +		q_data->cur_fmt.colorspace =3D f->fmt.pix.colorspace;
> +		q_data->cur_fmt.ycbcr_enc =3D f->fmt.pix.ycbcr_enc;
> +		q_data->cur_fmt.xfer_func =3D f->fmt.pix.xfer_func;
> +		q_data->cur_fmt.quantization =3D f->fmt.pix.quantization;
> +		/* Propagate colorimetry to the capture queue */
> +		q_data =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		q_data->cur_fmt.colorspace =3D f->fmt.pix.colorspace;
> +		q_data->cur_fmt.ycbcr_enc =3D f->fmt.pix.ycbcr_enc;
> +		q_data->cur_fmt.xfer_func =3D f->fmt.pix.xfer_func;
> +		q_data->cur_fmt.quantization =3D f->fmt.pix.quantization;
> +	}
> +
> +	/*
> +	 * TODO: Setting colorimetry on the capture queue is currently not
> +	 * supported by the V4L2 API
> +	 */
> +
> +	return 0;
> +}
> +
> +static int mem2mem_g_selection(struct file *file, void *priv,
> +			       struct v4l2_selection *s)
> +{
> +	struct mem2mem_ctx *ctx =3D fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		if (s->type !=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		q_data =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		q_data =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (s->target =3D=3D V4L2_SEL_TGT_CROP ||
> +	    s->target =3D=3D V4L2_SEL_TGT_COMPOSE) {
> +		s->r =3D q_data->rect;
> +	} else {
> +		s->r.left =3D 0;
> +		s->r.top =3D 0;
> +		s->r.width =3D q_data->cur_fmt.width;
> +		s->r.height =3D q_data->cur_fmt.height;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mem2mem_s_selection(struct file *file, void *priv,
> +			       struct v4l2_selection *s)
> +{
> +	struct mem2mem_ctx *ctx =3D fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		if (s->type !=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (s->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    s->type !=3D V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	q_data =3D get_q_data(ctx, s->type);
> +
> +	/* The input's frame width to the IC must be a multiple of 8 pixels
> +	 * When performing resizing the frame width must be multiple of burst
> +	 * size - 8 or 16 pixels as defined by CB#_BURST_16 parameter.
> +	 */
> +	if (s->flags & V4L2_SEL_FLAG_GE)
> +		s->r.width =3D round_up(s->r.width, 8);
> +	if (s->flags & V4L2_SEL_FLAG_LE)
> +		s->r.width =3D round_down(s->r.width, 8);
> +	s->r.width =3D clamp_t(unsigned int, s->r.width, 8,
> +			     round_down(q_data->cur_fmt.width, 8));
> +	s->r.height =3D clamp_t(unsigned int, s->r.height, 1,
> +			      q_data->cur_fmt.height);
> +	s->r.left =3D clamp_t(unsigned int, s->r.left, 0,
> +			    q_data->cur_fmt.width - s->r.width);
> +	s->r.top =3D clamp_t(unsigned int, s->r.top, 0,
> +			   q_data->cur_fmt.height - s->r.height);
> +
> +	/* V4L2_SEL_FLAG_KEEP_CONFIG is only valid for subdevices */
> +	q_data->rect =3D s->r;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops mem2mem_ioctl_ops =3D {
> +	.vidioc_querycap	=3D vidioc_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap =3D mem2mem_enum_fmt,
> +	.vidioc_g_fmt_vid_cap	=3D mem2mem_g_fmt,
> +	.vidioc_try_fmt_vid_cap	=3D mem2mem_try_fmt,
> +	.vidioc_s_fmt_vid_cap	=3D mem2mem_s_fmt,
> +
> +	.vidioc_enum_fmt_vid_out =3D mem2mem_enum_fmt,
> +	.vidioc_g_fmt_vid_out	=3D mem2mem_g_fmt,
> +	.vidioc_try_fmt_vid_out	=3D mem2mem_try_fmt,
> +	.vidioc_s_fmt_vid_out	=3D mem2mem_s_fmt,
> +
> +	.vidioc_g_selection	=3D mem2mem_g_selection,
> +	.vidioc_s_selection	=3D mem2mem_s_selection,
> +
> +	.vidioc_reqbufs		=3D v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	=3D v4l2_m2m_ioctl_querybuf,
> +
> +	.vidioc_qbuf		=3D v4l2_m2m_ioctl_qbuf,
> +	.vidioc_expbuf		=3D v4l2_m2m_ioctl_expbuf,
> +	.vidioc_dqbuf		=3D v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_create_bufs	=3D v4l2_m2m_ioctl_create_bufs,
> +
> +	.vidioc_streamon	=3D v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	=3D v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_subscribe_event =3D v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event =3D v4l2_event_unsubscribe,
> +};
> +
> +/*
> + * Queue operations
> + */
> +
> +static int mem2mem_queue_setup(struct vb2_queue *vq, unsigned int *nbuff=
ers,
> +			       unsigned int *nplanes, unsigned int sizes[],
> +			       struct device *alloc_devs[])
> +{
> +	struct mem2mem_ctx *ctx =3D vb2_get_drv_priv(vq);
> +	struct mem2mem_q_data *q_data;
> +	unsigned int count =3D *nbuffers;
> +	struct v4l2_pix_format *pix;
> +
> +	q_data =3D get_q_data(ctx, vq->type);
> +	pix =3D &q_data->cur_fmt;
> +
> +	*nplanes =3D 1;
> +	*nbuffers =3D count;
> +	sizes[0] =3D pix->sizeimage;
> +
> +	dev_dbg(ctx->priv->dev, "get %d buffer(s) of size %d each.\n",
> +		count, pix->sizeimage);
> +
> +	return 0;
> +}
> +
> +static int mem2mem_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct mem2mem_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> +	struct mem2mem_q_data *q_data;
> +	struct v4l2_pix_format *pix;
> +	unsigned int plane_size, payload;
> +
> +	dev_dbg(ctx->priv->dev, "type: %d\n", vb->vb2_queue->type);
> +
> +	q_data =3D get_q_data(ctx, vb->vb2_queue->type);
> +	pix =3D &q_data->cur_fmt;
> +	plane_size =3D pix->sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < plane_size) {
> +		dev_dbg(ctx->priv->dev,
> +			"%s data will not fit into plane (%lu < %lu)\n",
> +			__func__, vb2_plane_size(vb, 0), (long)plane_size);
> +		return -EINVAL;
> +	}
> +
> +	payload =3D pix->bytesperline * pix->height;
> +	if (pix->pixelformat =3D=3D V4L2_PIX_FMT_YUV420 ||
> +	    pix->pixelformat =3D=3D V4L2_PIX_FMT_YVU420 ||
> +	    pix->pixelformat =3D=3D V4L2_PIX_FMT_NV12)
> +		payload =3D payload * 3 / 2;
> +	else if (pix->pixelformat =3D=3D V4L2_PIX_FMT_YUV422P ||
> +		 pix->pixelformat =3D=3D V4L2_PIX_FMT_NV16)
> +		payload *=3D 2;
> +
> +	vb2_set_plane_payload(vb, 0, payload);
> +
> +	return 0;
> +}
> +
> +static void mem2mem_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mem2mem_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, to_vb2_v4l2_buffer(vb));
> +}
> +
> +static void ipu_image_from_q_data(struct ipu_image *im,
> +				  struct mem2mem_q_data *q_data)
> +{
> +	im->pix.width =3D q_data->cur_fmt.width;
> +	im->pix.height =3D q_data->cur_fmt.height;
> +	im->pix.bytesperline =3D q_data->cur_fmt.bytesperline;
> +	im->pix.pixelformat =3D q_data->cur_fmt.pixelformat;
> +	im->rect =3D q_data->rect;
> +}
> +
> +static int mem2mem_start_streaming(struct vb2_queue *q, unsigned int cou=
nt)
> +{
> +	const enum ipu_ic_task ic_task =3D IC_TASK_POST_PROCESSOR;
> +	struct mem2mem_ctx *ctx =3D vb2_get_drv_priv(q);
> +	struct mem2mem_priv *priv =3D ctx->priv;
> +	struct ipu_soc *ipu =3D priv->md->ipu[0];
> +	struct mem2mem_q_data *q_data;
> +	struct vb2_queue *other_q;
> +	struct ipu_image in, out;
> +
> +	other_q =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +				  (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) ?
> +				  V4L2_BUF_TYPE_VIDEO_OUTPUT :
> +				  V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	if (!vb2_is_streaming(other_q))
> +		return 0;
> +
> +	if (ctx->icc) {
> +		v4l2_warn(ctx->priv->vdev.vfd->v4l2_dev, "removing old ICC\n");
> +		ipu_image_convert_unprepare(ctx->icc);
> +	}
> +
> +	q_data =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	ipu_image_from_q_data(&in, q_data);
> +
> +	q_data =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	ipu_image_from_q_data(&out, q_data);
> +
> +	ctx->icc =3D ipu_image_convert_prepare(ipu, ic_task, &in, &out,
> +					     ctx->rot_mode,
> +					     mem2mem_ic_complete, ctx);
> +	if (IS_ERR(ctx->icc)) {
> +		struct vb2_v4l2_buffer *buf;
> +		int ret =3D PTR_ERR(ctx->icc);
> +
> +		ctx->icc =3D NULL;
> +		v4l2_err(ctx->priv->vdev.vfd->v4l2_dev, "%s: error %d\n",
> +			 __func__, ret);
> +		while ((buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +		while ((buf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mem2mem_stop_streaming(struct vb2_queue *q)
> +{
> +	struct mem2mem_ctx *ctx =3D vb2_get_drv_priv(q);
> +	struct vb2_v4l2_buffer *buf;
> +
> +	if (ctx->icc) {
> +		ipu_image_convert_unprepare(ctx->icc);
> +		ctx->icc =3D NULL;
> +	}
> +
> +	if (q->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		while ((buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +	} else {
> +		while ((buf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +	}
> +}
> +
> +static const struct vb2_ops mem2mem_qops =3D {
> +	.queue_setup	=3D mem2mem_queue_setup,
> +	.buf_prepare	=3D mem2mem_buf_prepare,
> +	.buf_queue	=3D mem2mem_buf_queue,
> +	.wait_prepare	=3D vb2_ops_wait_prepare,
> +	.wait_finish	=3D vb2_ops_wait_finish,
> +	.start_streaming =3D mem2mem_start_streaming,
> +	.stop_streaming =3D mem2mem_stop_streaming,
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct mem2mem_ctx *ctx =3D priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> +	src_vq->drv_priv =3D ctx;
> +	src_vq->buf_struct_size =3D sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops =3D &mem2mem_qops;
> +	src_vq->mem_ops =3D &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock =3D &ctx->priv->mutex;
> +	src_vq->dev =3D ctx->priv->dev;
> +
> +	ret =3D vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> +	dst_vq->drv_priv =3D ctx;
> +	dst_vq->buf_struct_size =3D sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops =3D &mem2mem_qops;
> +	dst_vq->mem_ops =3D &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock =3D &ctx->priv->mutex;
> +	dst_vq->dev =3D ctx->priv->dev;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static int mem2mem_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mem2mem_ctx *ctx =3D container_of(ctrl->handler,
> +					       struct mem2mem_ctx, ctrl_hdlr);
> +	enum ipu_rotate_mode rot_mode;
> +	int rotate;
> +	bool hflip, vflip;
> +	int ret =3D 0;
> +
> +	rotate =3D ctx->rotate;
> +	hflip =3D ctx->hflip;
> +	vflip =3D ctx->vflip;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		hflip =3D ctrl->val;
> +		break;
> +	case V4L2_CID_VFLIP:
> +		vflip =3D ctrl->val;
> +		break;
> +	case V4L2_CID_ROTATE:
> +		rotate =3D ctrl->val;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret =3D ipu_degrees_to_rot_mode(&rot_mode, rotate, hflip, vflip);
> +	if (ret)
> +		return ret;
> +
> +	if (rot_mode !=3D ctx->rot_mode) {
> +		struct vb2_queue *cap_q;
> +
> +		cap_q =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +					V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		if (vb2_is_streaming(cap_q))
> +			return -EBUSY;
> +
> +		ctx->rot_mode =3D rot_mode;
> +		ctx->rotate =3D rotate;
> +		ctx->hflip =3D hflip;
> +		ctx->vflip =3D vflip;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops mem2mem_ctrl_ops =3D {
> +	.s_ctrl =3D mem2mem_s_ctrl,
> +};
> +
> +static int mem2mem_init_controls(struct mem2mem_ctx *ctx)
> +{
> +	struct v4l2_ctrl_handler *hdlr =3D &ctx->ctrl_hdlr;
> +	int ret;
> +
> +	v4l2_ctrl_handler_init(hdlr, 3);
> +
> +	v4l2_ctrl_new_std(hdlr, &mem2mem_ctrl_ops, V4L2_CID_HFLIP,
> +			  0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdlr, &mem2mem_ctrl_ops, V4L2_CID_VFLIP,
> +			  0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdlr, &mem2mem_ctrl_ops, V4L2_CID_ROTATE,
> +			  0, 270, 90, 0);
> +
> +	if (hdlr->error) {
> +		ret =3D hdlr->error;
> +		goto out_free;
> +	}
> +
> +	v4l2_ctrl_handler_setup(hdlr);
> +	return 0;
> +
> +out_free:
> +	v4l2_ctrl_handler_free(hdlr);
> +	return ret;
> +}
> +
> +#define DEFAULT_WIDTH	720
> +#define DEFAULT_HEIGHT	576
> +static const struct mem2mem_q_data mem2mem_q_data_default =3D {
> +	.cur_fmt =3D {
> +		.width =3D DEFAULT_WIDTH,
> +		.height =3D DEFAULT_HEIGHT,
> +		.pixelformat =3D V4L2_PIX_FMT_YUV420,
> +		.field =3D V4L2_FIELD_NONE,
> +		.bytesperline =3D DEFAULT_WIDTH,
> +		.sizeimage =3D DEFAULT_WIDTH * DEFAULT_HEIGHT * 3 / 2,
> +		.colorspace =3D V4L2_COLORSPACE_SRGB,
> +	},
> +	.rect =3D {
> +		.width =3D DEFAULT_WIDTH,
> +		.height =3D DEFAULT_HEIGHT,
> +	},
> +};
> +
> +/*
> + * File operations
> + */
> +static int mem2mem_open(struct file *file)
> +{
> +	struct mem2mem_priv *priv =3D video_drvdata(file);
> +	struct mem2mem_ctx *ctx =3D NULL;
> +	int ret;
> +
> +	ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->rot_mode =3D IPU_ROTATE_NONE;
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data =3D &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	ctx->priv =3D priv;
> +
> +	ctx->fh.m2m_ctx =3D v4l2_m2m_ctx_init(priv->m2m_dev, ctx,
> +					    &queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret =3D PTR_ERR(ctx->fh.m2m_ctx);
> +		goto err_ctx;
> +	}
> +
> +	ret =3D mem2mem_init_controls(ctx);
> +	if (ret)
> +		goto err_ctrls;
> +
> +	ctx->fh.ctrl_handler =3D &ctx->ctrl_hdlr;
> +
> +	ctx->q_data[V4L2_M2M_SRC] =3D mem2mem_q_data_default;
> +	ctx->q_data[V4L2_M2M_DST] =3D mem2mem_q_data_default;
> +
> +	atomic_inc(&priv->num_inst);
> +
> +	dev_dbg(priv->dev, "Created instance %p, m2m_ctx: %p\n", ctx,
> +		ctx->fh.m2m_ctx);
> +
> +	return 0;
> +
> +err_ctrls:
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +err_ctx:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int mem2mem_release(struct file *file)
> +{
> +	struct mem2mem_priv *priv =3D video_drvdata(file);
> +	struct mem2mem_ctx *ctx =3D fh_to_ctx(file->private_data);
> +
> +	dev_dbg(priv->dev, "Releasing instance %p\n", ctx);
> +
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +
> +	atomic_dec(&priv->num_inst);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations mem2mem_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.open		=3D mem2mem_open,
> +	.release	=3D mem2mem_release,
> +	.poll		=3D v4l2_m2m_fop_poll,
> +	.unlocked_ioctl	=3D video_ioctl2,
> +	.mmap		=3D v4l2_m2m_fop_mmap,
> +};
> +
> +static struct v4l2_m2m_ops m2m_ops =3D {
> +	.device_run	=3D device_run,
> +	.job_abort	=3D job_abort,
> +};
> +
> +static const struct video_device mem2mem_videodev_template =3D {
> +	.name		=3D "ipu0_ic_pp mem2mem",
> +	.fops		=3D &mem2mem_fops,
> +	.ioctl_ops	=3D &mem2mem_ioctl_ops,
> +	.minor		=3D -1,
> +	.release	=3D video_device_release,
> +	.vfl_dir	=3D VFL_DIR_M2M,
> +	.tvnorms	=3D V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
> +	.device_caps	=3D V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
> +};
> +
> +int imx_media_mem2mem_device_register(struct imx_media_video_dev *vdev)
> +{
> +	struct mem2mem_priv *priv =3D to_mem2mem_priv(vdev);
> +	struct video_device *vfd =3D vdev->vfd;
> +	int ret;
> +
> +	vfd->v4l2_dev =3D &priv->md->v4l2_dev;
> +
> +	ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(vfd->v4l2_dev, "Failed to register video device\n");
> +		return ret;
> +	}
> +
> +	v4l2_info(vfd->v4l2_dev, "Registered %s as /dev/%s\n", vfd->name,
> +		  video_device_node_name(vfd));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_register);
> +
> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vde=
v)
> +{
> +	struct mem2mem_priv *priv =3D to_mem2mem_priv(vdev);
> +	struct video_device *vfd =3D priv->vdev.vfd;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	if (video_is_registered(vfd)) {
> +		video_unregister_device(vfd);
> +		media_entity_cleanup(&vfd->entity);
> +	}
> +
> +	mutex_unlock(&priv->mutex);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_unregister);
> +
> +struct imx_media_video_dev *
> +imx_media_mem2mem_device_init(struct imx_media_dev *md)
> +{
> +	struct mem2mem_priv *priv;
> +	struct video_device *vfd;
> +	int ret;
> +
> +	priv =3D devm_kzalloc(md->md.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return ERR_PTR(-ENOMEM);
> +
> +	priv->md =3D md;
> +	priv->dev =3D md->md.dev;
> +
> +	mutex_init(&priv->mutex);
> +	atomic_set(&priv->num_inst, 0);
> +
> +	vfd =3D video_device_alloc();
> +	if (!vfd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	*vfd =3D mem2mem_videodev_template;
> +	snprintf(vfd->name, sizeof(vfd->name), "ipu_ic_pp mem2mem");
> +	vfd->lock =3D &priv->mutex;
> +	priv->vdev.vfd =3D vfd;
> +
> +	INIT_LIST_HEAD(&priv->vdev.list);
> +
> +	video_set_drvdata(vfd, priv);
> +
> +	priv->m2m_dev =3D v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(priv->m2m_dev)) {
> +		ret =3D PTR_ERR(priv->m2m_dev);
> +		v4l2_err(&md->v4l2_dev, "Failed to init mem2mem device: %d\n",
> +			 ret);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return &priv->vdev;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_init);
> +
> +void imx_media_mem2mem_device_remove(struct imx_media_video_dev *vdev)
> +{
> +	struct mem2mem_priv *priv =3D to_mem2mem_priv(vdev);
> +
> +	v4l2_m2m_release(priv->m2m_dev);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_remove);
> +
> +MODULE_DESCRIPTION("i.MX IPUv3 mem2mem scaler/CSC driver");
> +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/medi=
a/imx/imx-media.h
> index bc7feb81937c..8d8f5ca6646d 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -149,6 +149,9 @@ struct imx_media_dev {
> =20
>  	/* for async subdev registration */
>  	struct v4l2_async_notifier notifier;
> +
> +	/* IC scaler/CSC mem2mem video device */
> +	struct imx_media_video_dev *m2m_vdev;
>  };
> =20
>  enum codespace_sel {
> @@ -262,6 +265,13 @@ void imx_media_capture_device_set_format(struct imx_=
media_video_dev *vdev,
>  					 struct v4l2_pix_format *pix);
>  void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
> =20
> +/* imx-media-mem2mem.c */
> +struct imx_media_video_dev *
> +imx_media_mem2mem_device_init(struct imx_media_dev *dev);
> +void imx_media_mem2mem_device_remove(struct imx_media_video_dev *vdev);
> +int imx_media_mem2mem_device_register(struct imx_media_video_dev *vdev);
> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vde=
v);
> +
>  /* subdev group ids */
>  #define IMX_MEDIA_GRP_ID_CSI2      BIT(8)
>  #define IMX_MEDIA_GRP_ID_CSI_BIT   9

--=-TNRJSxGLFXHlpaboFJDN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCXDPUZwAKCRBxUwItrAao
HIXGAJ9+p4NxGVCmtAcMMbR8pO/qDy/nCQCeLojB4WGiSLER8eNqYkh1yuMKmuY=
=frBZ
-----END PGP SIGNATURE-----

--=-TNRJSxGLFXHlpaboFJDN--

