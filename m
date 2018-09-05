Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:47484 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbeIEVBN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Sep 2018 17:01:13 -0400
Message-ID: <b7b3cb2320978d45acb34475d15abd7bf03da367.camel@paulk.fr>
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
From: Paul Kocialkowski <contact@paulk.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
Date: Wed, 05 Sep 2018 18:29:42 +0200
In-Reply-To: <5faf5eed-eb2c-f804-93e3-5a42f6204d99@xs4all.nl>
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
         <20180828073424.30247-5-paul.kocialkowski@bootlin.com>
         <5faf5eed-eb2c-f804-93e3-5a42f6204d99@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-RSdpLt7hGIrIBwLQFCLz"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-RSdpLt7hGIrIBwLQFCLz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi and thanks for the review!

Le lundi 03 septembre 2018 =C3=A0 11:11 +0200, Hans Verkuil a =C3=A9crit :
> On 08/28/2018 09:34 AM, Paul Kocialkowski wrote:
> > +static int cedrus_request_validate(struct media_request *req)
> > +{
> > +	struct media_request_object *obj, *obj_safe;
> > +	struct v4l2_ctrl_handler *parent_hdl, *hdl;
> > +	struct cedrus_ctx *ctx =3D NULL;
> > +	struct v4l2_ctrl *ctrl_test;
> > +	unsigned int i;
> > +
> > +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
>=20
> You don't need to use the _safe variant during validation.

Okay, I'll use the regular one then.

> > +		struct vb2_buffer *vb;
> > +
> > +		if (vb2_request_object_is_buffer(obj)) {
> > +			vb =3D container_of(obj, struct vb2_buffer, req_obj);
> > +			ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +			break;
> > +		}
> > +	}
>=20
> Interesting question: what happens if more than one buffer is queued in t=
he
> request? This is allowed by the request API and in that case the associat=
ed
> controls in the request apply to all queued buffers.
>=20
> Would this make sense at all for this driver? If not, then you need to
> check here if there is more than one buffer in the request and document i=
n
> the spec that this is not allowed.

Well, our driver was written with the (unformal) assumption that we
only deal with a pair of one output and one capture buffer. So I will
add a check for this at request validation time and document it in the
spec. Should that be part of the MPEG-2 PIXFMT documentation (and
duplicated for future formats we add support for)?

> If it does make sense, then you need to test this.
>=20
> Again, this can be corrected in a follow-up patch, unless there will be a
> v9 anyway.

[...]

> > +static int cedrus_probe(struct platform_device *pdev)
> > +{
> > +	struct cedrus_dev *dev;
> > +	struct video_device *vfd;
> > +	int ret;
> > +
> > +	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > +	if (!dev)
> > +		return -ENOMEM;
> > +
> > +	dev->dev =3D &pdev->dev;
> > +	dev->pdev =3D pdev;
> > +
> > +	ret =3D cedrus_hw_probe(dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to probe hardware\n");
> > +		return ret;
> > +	}
> > +
> > +	dev->dec_ops[CEDRUS_CODEC_MPEG2] =3D &cedrus_dec_ops_mpeg2;
> > +
> > +	mutex_init(&dev->dev_mutex);
> > +	spin_lock_init(&dev->irq_lock);
> > +
> > +	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to register V4L2 device\n");
> > +		return ret;
> > +	}
> > +
> > +	dev->vfd =3D cedrus_video_device;
> > +	vfd =3D &dev->vfd;
> > +	vfd->lock =3D &dev->dev_mutex;
> > +	vfd->v4l2_dev =3D &dev->v4l2_dev;
> > +
> > +	ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > +	if (ret) {
> > +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> > +		goto err_v4l2;
> > +	}
> > +
> > +	snprintf(vfd->name, sizeof(vfd->name), "%s", cedrus_video_device.name=
);
> > +	video_set_drvdata(vfd, dev);
> > +
> > +	v4l2_info(&dev->v4l2_dev,
> > +		  "Device registered as /dev/video%d\n", vfd->num);
> > +
> > +	dev->m2m_dev =3D v4l2_m2m_init(&cedrus_m2m_ops);
>=20
> This ^^^ initialization...
>=20
> > +	if (IS_ERR(dev->m2m_dev)) {
> > +		v4l2_err(&dev->v4l2_dev,
> > +			 "Failed to initialize V4L2 M2M device\n");
> > +		ret =3D PTR_ERR(dev->m2m_dev);
> > +
> > +		goto err_video;
> > +	}
> > +
> > +	dev->mdev.dev =3D &pdev->dev;
> > +	strlcpy(dev->mdev.model, CEDRUS_NAME, sizeof(dev->mdev.model));
> > +
> > +	media_device_init(&dev->mdev);
> > +	dev->mdev.ops =3D &cedrus_m2m_media_ops;
> > +	dev->v4l2_dev.mdev =3D &dev->mdev;
>=20
> ...and this ^^^ initialization should be done before you start registerin=
g devices.
>=20
> > +
> > +	ret =3D v4l2_m2m_register_media_controller(dev->m2m_dev,
> > +			vfd, MEDIA_ENT_F_PROC_VIDEO_DECODER);
> > +	if (ret) {
> > +		v4l2_err(&dev->v4l2_dev,
> > +			 "Failed to initialize V4L2 M2M media controller\n");
> > +		goto err_m2m;
> > +	}
>=20
> ^^^ this one too.
>=20
> If you don't do that, then you are registering partially initialized devi=
ces,
> which is never a good idea.
>=20
> Just move the video_register_device() call to here, just before the
> media_device_register().
>=20
> This is worthy of a v9, since this can cause real problems.

Thanks for pointing this out, will fix in the next revision.

[...]

> > +static const u8 intra_quantization_matrix_default[64] =3D {
> > +	8,  16, 16, 19, 16, 19, 22, 22,
> > +	22, 22, 22, 22, 26, 24, 26, 27,
> > +	27, 27, 26, 26, 26, 26, 27, 27,
> > +	27, 29, 29, 29, 34, 34, 34, 29,
> > +	29, 29, 27, 27, 29, 29, 32, 32,
> > +	34, 34, 37, 38, 37, 35, 35, 34,
> > +	35, 38, 38, 40, 40, 40, 48, 48,
> > +	46, 46, 56, 56, 58, 69, 69, 83
> > +};
> > +
> > +static const u8 non_intra_quantization_matrix_default[64] =3D {
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16,
> > +	16, 16, 16, 16, 16, 16, 16, 16
> > +};
>=20
> Just curious: where do these defaults come from? Might be worth a comment
> in the code.

These are the default quantization coefficients originating from the
MPEG-2 spec. I'll add a comment to make that clear.

[...]

> > +static int cedrus_querycap(struct file *file, void *priv,
> > +			   struct v4l2_capability *cap)
> > +{
> > +	strncpy(cap->driver, CEDRUS_NAME, sizeof(cap->driver) - 1);
> > +	strncpy(cap->card, CEDRUS_NAME, sizeof(cap->card) - 1);
>=20
> Please use strlcpy instead.

Will do.

[...]

> > +static int cedrus_queue_setup(struct vb2_queue *vq, unsigned int *nbuf=
s,
> > +			      unsigned int *nplanes, unsigned int sizes[],
> > +			      struct device *alloc_devs[])
> > +{
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	struct v4l2_pix_format_mplane *mplane_fmt;
> > +	struct cedrus_format *fmt;
> > +	unsigned int i;
> > +
> > +	switch (vq->type) {
> > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > +		mplane_fmt =3D &ctx->src_fmt;
> > +		fmt =3D cedrus_find_format(mplane_fmt->pixelformat,
> > +					 CEDRUS_DECODE_SRC,
> > +					 dev->capabilities);
> > +		break;
> > +
> > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > +		mplane_fmt =3D &ctx->dst_fmt;
> > +		fmt =3D cedrus_find_format(mplane_fmt->pixelformat,
> > +					 CEDRUS_DECODE_DST,
> > +					 dev->capabilities);
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!fmt)
> > +		return -EINVAL;
> > +
> > +	if (fmt->num_buffers =3D=3D 1) {
> > +		sizes[0] =3D 0;
> > +
> > +		for (i =3D 0; i < fmt->num_planes; i++)
> > +			sizes[0] +=3D mplane_fmt->plane_fmt[i].sizeimage;
> > +	} else if (fmt->num_buffers =3D=3D fmt->num_planes) {
> > +		for (i =3D 0; i < fmt->num_planes; i++)
> > +			sizes[i] =3D mplane_fmt->plane_fmt[i].sizeimage;
> > +	} else {
> > +		return -EINVAL;
> > +	}
> > +
> > +	*nplanes =3D fmt->num_buffers;
>=20
> This code does not take VIDIOC_CREATE_BUFFERS into account.
>=20
> If it is called from that ioctl, then *nplanes is non-zero and you need
> to check if *nplanes equals fmt->num_buffers and that sizes[n] is >=3D
> the required size of the format. If so, then return 0, otherwise return
> -EINVAL.

Thanks for spotting this, I'll fix it as you suggested in the next
revision.

> Doesn't v4l2-compliance fail on that? Or is that test skipped because thi=
s
> is a decoder for which streaming is not supported (yet)?

Apparently, v4l2-compliance doesn't fail since I'm getting:
test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK

Cheers,

Paul

> > +
> > +	return 0;
> > +}
> > +
> > +static void cedrus_queue_cleanup(struct vb2_queue *vq, u32 state)
> > +{
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +	struct vb2_v4l2_buffer *vbuf;
> > +	unsigned long flags;
> > +
> > +	for (;;) {
> > +		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +		if (V4L2_TYPE_IS_OUTPUT(vq->type))
> > +			vbuf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +		else
> > +			vbuf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > +
> > +		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > +
> > +		if (!vbuf)
> > +			return;
> > +
> > +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> > +					   &ctx->hdl);
> > +		v4l2_m2m_buf_done(vbuf, state);
> > +	}
> > +}
> > +
> > +static int cedrus_buf_init(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +
> > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		ctx->dst_bufs[vb->index] =3D vb;
> > +
> > +	return 0;
> > +}
> > +
> > +static void cedrus_buf_cleanup(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +
> > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		ctx->dst_bufs[vb->index] =3D NULL;
> > +}
> > +
> > +static int cedrus_buf_prepare(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +	struct v4l2_pix_format_mplane *fmt;
> > +	unsigned int buffer_size =3D 0;
> > +	unsigned int format_size =3D 0;
> > +	unsigned int i;
> > +
> > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > +		fmt =3D &ctx->src_fmt;
> > +	else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > +		fmt =3D &ctx->dst_fmt;
> > +	else
> > +		return -EINVAL;
> > +
> > +	for (i =3D 0; i < vb->num_planes; i++)
> > +		buffer_size +=3D vb2_plane_size(vb, i);
> > +
> > +	for (i =3D 0; i < fmt->num_planes; i++)
> > +		format_size +=3D fmt->plane_fmt[i].sizeimage;
> > +
> > +	if (buffer_size < format_size)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int cedrus_start_streaming(struct vb2_queue *vq, unsigned int c=
ount)
> > +{
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	int ret =3D 0;
> > +
> > +	switch (ctx->src_fmt.pixelformat) {
> > +	case V4L2_PIX_FMT_MPEG2_SLICE:
> > +		ctx->current_codec =3D CEDRUS_CODEC_MPEG2;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
> > +	    dev->dec_ops[ctx->current_codec]->start)
> > +		ret =3D dev->dec_ops[ctx->current_codec]->start(ctx);
> > +
> > +	if (ret)
> > +		cedrus_queue_cleanup(vq, VB2_BUF_STATE_QUEUED);
> > +
> > +	return ret;
> > +}
> > +
> > +static void cedrus_stop_streaming(struct vb2_queue *vq)
> > +{
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +
> > +	if (V4L2_TYPE_IS_OUTPUT(vq->type) &&
> > +	    dev->dec_ops[ctx->current_codec]->stop)
> > +		dev->dec_ops[ctx->current_codec]->stop(ctx);
> > +
> > +	cedrus_queue_cleanup(vq, VB2_BUF_STATE_ERROR);
> > +}
> > +
> > +static void cedrus_buf_queue(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> > +}
> > +
> > +static void cedrus_buf_request_complete(struct vb2_buffer *vb)
> > +{
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
> > +}
> > +
> > +static struct vb2_ops cedrus_qops =3D {
> > +	.queue_setup		=3D cedrus_queue_setup,
> > +	.buf_prepare		=3D cedrus_buf_prepare,
> > +	.buf_init		=3D cedrus_buf_init,
> > +	.buf_cleanup		=3D cedrus_buf_cleanup,
> > +	.buf_queue		=3D cedrus_buf_queue,
> > +	.buf_request_complete	=3D cedrus_buf_request_complete,
> > +	.start_streaming	=3D cedrus_start_streaming,
> > +	.stop_streaming		=3D cedrus_stop_streaming,
> > +	.wait_prepare		=3D vb2_ops_wait_prepare,
> > +	.wait_finish		=3D vb2_ops_wait_finish,
> > +};
> > +
> > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +		      struct vb2_queue *dst_vq)
> > +{
> > +	struct cedrus_ctx *ctx =3D priv;
> > +	int ret;
> > +
> > +	src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +	src_vq->drv_priv =3D ctx;
> > +	src_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > +	src_vq->min_buffers_needed =3D 1;
> > +	src_vq->ops =3D &cedrus_qops;
> > +	src_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +	src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	src_vq->lock =3D &ctx->dev->dev_mutex;
> > +	src_vq->dev =3D ctx->dev->dev;
> > +	src_vq->supports_requests =3D true;
> > +
> > +	ret =3D vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +	dst_vq->drv_priv =3D ctx;
> > +	dst_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > +	dst_vq->min_buffers_needed =3D 1;
> > +	dst_vq->ops =3D &cedrus_qops;
> > +	dst_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +	dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	dst_vq->lock =3D &ctx->dev->dev_mutex;
> > +	dst_vq->dev =3D ctx->dev->dev;
> > +
> > +	return vb2_queue_init(dst_vq);
> > +}
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.h b/driver=
s/staging/media/sunxi/cedrus/cedrus_video.h
> > new file mode 100644
> > index 000000000000..ead1143fdfdc
> > --- /dev/null
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
> > @@ -0,0 +1,32 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Cedrus VPU driver
> > + *
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2018 Bootlin
> > + *
> > + * Based on the vim2m driver, that is:
> > + *
> > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > + * Pawel Osciak, <pawel@osciak.com>
> > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > + */
> > +
> > +#ifndef _CEDRUS_VIDEO_H_
> > +#define _CEDRUS_VIDEO_H_
> > +
> > +struct cedrus_format {
> > +	u32		pixelformat;
> > +	u32		directions;
> > +	unsigned int	num_planes;
> > +	unsigned int	num_buffers;
> > +	unsigned int	capabilities;
> > +};
> > +
> > +extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
> > +
> > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > +		      struct vb2_queue *dst_vq);
> > +
> > +#endif
> >=20
>=20
> Regards,
>=20
> 	Hans
--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-RSdpLt7hGIrIBwLQFCLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluQBHYACgkQhP3B6o/u
lQyfVg//a+R9Ud/Vr+8UHcqXUNdThiUlZbFuNCQ3VBR0vRHkPtXSBADiFiYSuH8j
VsFE9gg4nzQb+X7Gs0xYLKkepPPvlwnJ1lhXEtWxap2bnq9f7fI5LV7Cle8GGOpH
cL3fD+9bWI1FetgMRtyf1+ZkfKZl2EvMNr1Bt0eRwBxpfKNibSYAJcDa9SF7+MlQ
vwuSEyVRATx4JW4vpMWT6k2aUcR+6ObBYxOMJhGg40YuwuH6m+fGlysOT6Tfx+Oo
xRz5CXUJ4pcfN8MlyGikXY1RF8u1XxCIZ0Ob4vpopek1+o690Mviqt0fRtCHDbcj
9k8afjdyiSzdX6kVL+6gGjLNTpqK/N07KuUj1ngAdpmrEty9QioQf6lCZCmufCOJ
AWMd80f7mHsr3l9CuCMkHLM2KMoXewdvrF2FaTZ0wXr7DcfiHaYWKb+1qJEiku1M
J14guzHiadjPxFJ7H7tnr0LBLJjvq+pPm51gInxd5qxPPEvbVGHHBPJlQu28m5li
5FyAs8w5zJq5o3eP2jYieOmdhjAk81fu6S5tsgvUi9caNJzN2HVmkYJTS92a6ki/
b6FoFUWut0GVcJes8HWckiFYKfgXzwUk2qJxlPSqsgh1VCXobzfsj7OI0LoWwFDh
mk8GLhmqPc49DSGv7cKqKfPDSPxmx5mWpqIu48NVbvxri5OSoQ8=
=oKtt
-----END PGP SIGNATURE-----

--=-RSdpLt7hGIrIBwLQFCLz--
