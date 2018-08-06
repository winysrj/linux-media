Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:56505 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731008AbeHFP71 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 11:59:27 -0400
Message-ID: <dba0f9496b393c76f355398018b14ae06b2b18c9.camel@bootlin.com>
Subject: Re: [PATCH v6 4/8] media: platform: Add Cedrus VPU decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
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
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Mon, 06 Aug 2018 15:50:11 +0200
In-Reply-To: <b45a8a89-1313-7a08-206d-b93017724754@xs4all.nl>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
         <b45a8a89-1313-7a08-206d-b93017724754@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NhzGKRQQLbTuM6yxjJGc"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-NhzGKRQQLbTuM6yxjJGc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans and thanks for the review!

On Sat, 2018-08-04 at 14:18 +0200, Hans Verkuil wrote:
> Hi Paul,
>=20
> See below for my review comments. Mostly small fry, the main issue I foun=
d is
> that there is no support for VIDIOC_DECODER_CMD. That's the proper way of
> stopping a decoder. Don't rely on the deprecated allow_zero_bytesused fie=
ld.

Mhh, it looks like this was kept around by negligence, but we do expect
that streamoff stops the decoder, not a zero bytesused field.

Is it still required to implement the V4L2_DEC_CMD_STOP
VIDIOC_DECODER_CMD in that case? I read in the doc that this ioctl
should be optional.

[...]

> > +static int cedrus_request_validate(struct media_request *req)
> > +{
> > +	struct media_request_object *obj, *obj_safe;
> > +	struct v4l2_ctrl_handler *parent_hdl, *hdl;
> > +	struct cedrus_ctx *ctx =3D NULL;
> > +	struct v4l2_ctrl *ctrl_test;
> > +	unsigned int i;
> > +
> > +	list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> > +		struct vb2_buffer *vb;
> > +
> > +		if (vb2_request_object_is_buffer(obj)) {
> > +			vb =3D container_of(obj, struct vb2_buffer, req_obj);
> > +			ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!ctx)
> > +		return -EINVAL;
>=20
> Return -ENOENT, just as vb2_request_validate does.

Thanks, will fix this and the following errors in the next revision.
> > +
> > +	parent_hdl =3D &ctx->hdl;
> > +
> > +	hdl =3D v4l2_ctrl_request_hdl_find(req, parent_hdl);
> > +	if (!hdl) {
> > +		v4l2_err(&ctx->dev->v4l2_dev, "Missing codec control(s)\n");
> > +		return -EINVAL;
>=20
> Ditto, return -ENOENT.
>=20
> > +	}
> > +
> > +	for (i =3D 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> > +		if (cedrus_controls[i].codec !=3D ctx->current_codec ||
> > +		    !cedrus_controls[i].required)
> > +			continue;
> > +
> > +		ctrl_test =3D v4l2_ctrl_request_hdl_ctrl_find(hdl,
> > +			cedrus_controls[i].id);
> > +		if (!ctrl_test) {
> > +			v4l2_err(&ctx->dev->v4l2_dev,
> > +				 "Missing required codec control\n");
> > +			return -EINVAL;
>=20
> Ditto.
>=20
> The documentation of MEDIA_REQUEST_IOC_QUEUE says this for ENOENT:
>=20
> ENOENT
>     The request did not contain any buffers. All requests are required
>     to have at least one buffer. This can also be returned if required
>     controls are missing.
>=20
> So ENOENT is the correct error code when checking for required controls.

Thanks for the explanation!

[...]

> > +static int cedrus_release(struct file *file)
> > +{
> > +	struct cedrus_dev *dev =3D video_drvdata(file);
> > +	struct cedrus_ctx *ctx =3D container_of(file->private_data,
> > +					      struct cedrus_ctx, fh);
> > +
> > +	mutex_lock(&dev->dev_mutex);
> > +
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> > +
> > +	v4l2_ctrl_handler_free(&ctx->hdl);
> > +	kfree(ctx->ctrls);
> > +
> > +	v4l2_fh_exit(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
>=20
> Why call this twice?

Woops, looks like a mistake.

[...]

> > +void cedrus_device_run(void *priv)
> > +{
> > +	struct cedrus_ctx *ctx =3D priv;
> > +	struct cedrus_dev *dev =3D ctx->dev;
> > +	struct cedrus_run run =3D { 0 };
> > +	struct media_request *src_req;
> > +	unsigned long flags;
> > +
> > +	run.src =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> > +	run.dst =3D v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> > +
> > +	/* Apply request(s) controls if needed. */
> > +	src_req =3D run.src->vb2_buf.req_obj.req;
> > +
> > +	if (src_req)
> > +		v4l2_ctrl_request_setup(src_req, &ctx->hdl);
> > +
> > +	ctx->job_abort =3D 0;
> > +
> > +	spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > +
> > +	switch (ctx->src_fmt.pixelformat) {
> > +	case V4L2_PIX_FMT_MPEG2_SLICE:
> > +		run.mpeg2.slice_params =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);
> > +		run.mpeg2.quantization =3D cedrus_find_control_data(ctx,
> > +			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);
> > +		break;
> > +
> > +	default:
> > +		ctx->job_abort =3D 1;
>=20
> Add break; here.

Good catch, will do.

[...]

> > +static int cedrus_querycap(struct file *file, void *priv,
> > +			   struct v4l2_capability *cap)
> > +{
> > +	strncpy(cap->driver, CEDRUS_NAME, sizeof(cap->driver) - 1);
> > +	strncpy(cap->card, CEDRUS_NAME, sizeof(cap->card) - 1);
> > +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> > +		 "platform:%s", CEDRUS_NAME);
> > +
> > +	cap->device_caps =3D V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> > +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>=20
> Set device_caps in struct video_device and drop these two lines here.
> The v4l2 core will take care of setting device_caps and capabilities.

Nice, will do!

> > +static int cedrus_start_streaming(struct vb2_queue *q, unsigned int co=
unt)
> > +{
> > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
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
> > +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
> > +	    dev->dec_ops[ctx->current_codec]->start)
> > +		ret =3D dev->dec_ops[ctx->current_codec]->start(ctx);
> > +
> > +	return ret;
>=20
> If start_streaming returns an error, then all queued buffers need to
> be returned to vb2 with state VB2_BUF_STATE_QUEUED.

Okay, so I suppose I will take the code from streamoff, make it common
and pass it the target buf state.

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
> > +	src_vq->allow_zero_bytesused =3D 1;
>=20
> Don't use this, it's deprecated. Implement VIDIOC_DECODER_CMD instead.

Looks like we can just get rid of it at this point, it's not used by
userspace to indicate that there is no data left to send.

> > +	src_vq->min_buffers_needed =3D 1;
> > +	src_vq->ops =3D &cedrus_qops;
> > +	src_vq->mem_ops =3D &vb2_dma_contig_memops;
> > +	src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > +	src_vq->lock =3D &ctx->dev->dev_mutex;
> > +	src_vq->dev =3D ctx->dev->dev;
> > +
> > +	ret =3D vb2_queue_init(src_vq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +	dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > +	dst_vq->drv_priv =3D ctx;
> > +	dst_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > +	dst_vq->allow_zero_bytesused =3D 1;
>=20
> Ditto. It's pointless for the capture side anyway.
>=20
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
> > index 000000000000..56afcc8c02ba
> > --- /dev/null
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Sunxi-Cedrus VPU driver
> > + *
> > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.com=
>
> > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.co=
m>
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

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-NhzGKRQQLbTuM6yxjJGc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltoUhMACgkQ3cLmz3+f
v9FJQAgAltMKB5V9ep9P0FXdGJEOI64t9GTvGfxRrk2/Nl2y27H6V28RAS67VUz+
E0Bf6a8DfUvKPGrHKRASuirza+8ihAj8wcNOm1x7Wu2YzaYxbWjMxLo8ddcDQMUs
i/c4HWW2r5o87d+F2DUkFxfn2ZTGBkX0756g1LC7N2BeWguQJJywgMUG1mCKavM1
Z7wLbQB7SjcPBjgsH8M6tdCoaCkdDjUcOY58XM6n3rGFqeGH3gyugVeC82Tnhum8
Jrv1/jNxqBDB6vDy8JMV32Jw8JLJeMmS/rTV1TRGBEJCW8S9pfll9SNH0CpUVaF2
KdLdr6ALCnEZIbBMM2cyP2kPmzgD6g==
=N7mn
-----END PGP SIGNATURE-----

--=-NhzGKRQQLbTuM6yxjJGc--
