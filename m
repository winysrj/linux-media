Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58022 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388793AbeHGOpY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 10:45:24 -0400
Message-ID: <5b8f8406620166903db35832489e0f2d314b4191.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v6 4/8] media: platform: Add Cedrus VPU
 decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Tue, 07 Aug 2018 14:31:03 +0200
In-Reply-To: <2251357.uoA9bQP17p@jernej-laptop>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
         <1688687.Q0yMyAUrqh@jernej-laptop> <2251357.uoA9bQP17p@jernej-laptop>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-aWIeaR52ncm/ASAbyqb9"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-aWIeaR52ncm/ASAbyqb9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-07-27 at 16:58 +0200, Jernej =C5=A0krabec wrote:
> Dne petek, 27. julij 2018 ob 16:03:41 CEST je Jernej =C5=A0krabec napisal=
(a):
> > Hi!
> >=20
> > Dne sreda, 25. julij 2018 ob 12:02:52 CEST je Paul Kocialkowski napisal=
(a):
> > > This introduces the Cedrus VPU driver that supports the VPU found in
> > > Allwinner SoCs, also known as Video Engine. It is implemented through
> > > a v4l2 m2m decoder device and a media device (used for media requests=
).
> > > So far, it only supports MPEG2 decoding.
> > >=20
> > > Since this VPU is stateless, synchronization with media requests is
> > > required in order to ensure consistency between frame headers that
> > > contain metadata about the frame to process and the raw slice data th=
at
> > > is used to generate the frame.
> > >=20
> > > This driver was made possible thanks to the long-standing effort
> > > carried out by the linux-sunxi community in the interest of reverse
> > > engineering, documenting and implementing support for Allwinner VPU.
> > >=20
> > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > > ---
> >=20
> > <snip>
> >=20
> > > +void cedrus_dst_format_set(struct cedrus_dev *dev,
> > > +			   struct v4l2_pix_format_mplane *fmt)
> > > +{
> > > +	unsigned int width =3D fmt->width;
> > > +	unsigned int height =3D fmt->height;
> > > +	u32 chroma_size;
> > > +	u32 reg;
> > > +
> > > +	switch (fmt->pixelformat) {
> > > +	case V4L2_PIX_FMT_NV12:
> > > +		chroma_size =3D ALIGN(width, 32) * ALIGN(height / 2, 32);
> >=20
> > After some testing, it turns out that right aligment for untiled format=
 is
> > 16.
> > > +
> > > +		reg =3D VE_PRIMARY_OUT_FMT_NV12 |
> > > +		      VE_SECONDARY_SPECIAL_OUT_FMT_NV12;
> > > +		cedrus_write(dev, VE_PRIMARY_OUT_FMT, reg);
> > > +
> > > +		reg =3D VE_CHROMA_BUF_LEN_SDRT(chroma_size / 2) |
> > > +		      VE_SECONDARY_OUT_FMT_SPECIAL;
> > > +		cedrus_write(dev, VE_CHROMA_BUF_LEN, reg);
> > > +
> > > +		reg =3D chroma_size / 2;
> > > +		cedrus_write(dev, VE_PRIMARY_CHROMA_BUF_LEN, reg);
> > > +
> > > +		reg =3D VE_PRIMARY_FB_LINE_STRIDE_LUMA(ALIGN(width, 32)) |
> >=20
> > ^ that one should be aligned to 16
> >=20
> > > +		      VE_PRIMARY_FB_LINE_STRIDE_CHROMA(ALIGN(width / 2, 16));
>=20
> It seems that CHROMA has to be aligned to 8 ^

I think the issue here is that the divider should be applied after the
alignment, not before, such as: ALIGN(width, 16) / 2, which also
provides a 8-aligned value.

Feel free to let me know if that causes any particular issue!

> That, with previosly comments, completely solves issues for one of my sam=
ple=20
> video. However, there are still sample videos with issues. Those are most=
ly=20
> rendered green with slight impressions of right image. Maybe LUMA issue?

Can you check whether these videos are interlaced? I think those don't
do very well with our driver at this point.

Cheers and thanks for the useful work and feedback!

Paul

> Best regards,
> Jernej
>=20
> > > +		cedrus_write(dev, VE_PRIMARY_FB_LINE_STRIDE, reg);
> > > +
> > > +		break;
> > > +	case V4L2_PIX_FMT_MB32_NV12:
> > > +	default:
> > > +		reg =3D VE_PRIMARY_OUT_FMT_MB32_NV12;
> > > +		cedrus_write(dev, VE_PRIMARY_OUT_FMT, reg);
> > > +
> > > +		reg =3D VE_SECONDARY_OUT_FMT_MB32_NV12;
> > > +		cedrus_write(dev, VE_CHROMA_BUF_LEN, reg);
> > > +
> > > +		break;
> > > +	}
> > > +}
> >=20
> > <snip>
> >=20
> > > +static void cedrus_prepare_plane_format(struct cedrus_format *fmt,
> > > +					struct v4l2_format *f,
> > > +					unsigned int i)
> > > +{
> > > +	struct v4l2_plane_pix_format *plane_fmt =3D &f->fmt.pix_mp.plane_fm=
t[i];
> > > +	unsigned int width =3D f->fmt.pix_mp.width;
> > > +	unsigned int height =3D f->fmt.pix_mp.height;
> > > +	unsigned int sizeimage =3D plane_fmt->sizeimage;
> > > +	unsigned int bytesperline =3D plane_fmt->bytesperline;
> > > +
> > > +	switch (fmt->pixelformat) {
> > > +	case V4L2_PIX_FMT_MPEG2_SLICE:
> > > +		/* Zero bytes per line. */
> > > +		bytesperline =3D 0;
> > > +		break;
> > > +
> > > +	case V4L2_PIX_FMT_MB32_NV12:
> > > +		/* 32-aligned stride. */
> > > +		bytesperline =3D ALIGN(width, 32);
> > > +
> > > +		/* 32-aligned (luma) height. */
> > > +		height =3D ALIGN(height, 32);
> > > +
> > > +		if (i =3D=3D 0)
> > > +			/* 32-aligned luma size. */
> > > +			sizeimage =3D bytesperline * height;
> > > +		else if (i =3D=3D 1)
> > > +			/* 32-aligned chroma size with 2x2 sub-sampling. */
> > > +			sizeimage =3D bytesperline * ALIGN(height / 2, 32);
> > > +
> > > +		break;
> > > +
> > > +	case V4L2_PIX_FMT_NV12:
> > > +		/* 32-aligned stride. */
> > > +		bytesperline =3D ALIGN(width, 32);
> >=20
> > ^ and that one should be aligned to 16 too.
> >=20
> > This partially fixes some MPEG2 videos I have tested with Kodi. I think
> > there are other aligment issues, but I have to find them first.
> >=20
> > Best regards,
> > Jernej
> >=20
> > > +
> > > +		if (i =3D=3D 0)
> > > +			/* Regular luma size. */
> > > +			sizeimage =3D bytesperline * height;
> > > +		else if (i =3D=3D 1)
> > > +			/* Regular chroma size with 2x2 sub-sampling. */
> > > +			sizeimage =3D bytesperline * height / 2;
> > > +
> > > +		break;
> > > +	}
> > > +
> > > +	f->fmt.pix_mp.width =3D width;
> > > +	f->fmt.pix_mp.height =3D height;
> > > +
> > > +	plane_fmt->bytesperline =3D bytesperline;
> > > +	plane_fmt->sizeimage =3D sizeimage;
> > > +}
> > > +
> > > +static void cedrus_prepare_format(struct cedrus_format *fmt,
> > > +				  struct v4l2_format *f)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	f->fmt.pix_mp.field =3D V4L2_FIELD_NONE;
> > > +	f->fmt.pix_mp.num_planes =3D fmt->num_planes;
> > > +
> > > +	for (i =3D 0; i < fmt->num_planes; i++)
> > > +		cedrus_prepare_plane_format(fmt, f, i);
> > > +}
> > > +
> > > +static int cedrus_querycap(struct file *file, void *priv,
> > > +			   struct v4l2_capability *cap)
> > > +{
> > > +	strncpy(cap->driver, CEDRUS_NAME, sizeof(cap->driver) - 1);
> > > +	strncpy(cap->card, CEDRUS_NAME, sizeof(cap->card) - 1);
> > > +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> > > +		 "platform:%s", CEDRUS_NAME);
> > > +
> > > +	cap->device_caps =3D V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING=
;
> > > +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_enum_fmt(struct file *file, struct v4l2_fmtdesc *f=
,
> > > +			   u32 direction)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	unsigned int capabilities =3D dev->capabilities;
> > > +	struct cedrus_format *fmt;
> > > +	unsigned int i, index;
> > > +
> > > +	/* Index among formats that match the requested direction. */
> > > +	index =3D 0;
> > > +
> > > +	for (i =3D 0; i < CEDRUS_FORMATS_COUNT; i++) {
> > > +		fmt =3D &cedrus_formats[i];
> > > +
> > > +		if (fmt->capabilities && (fmt->capabilities & capabilities) !=3D
> > > +		    fmt->capabilities)
> > > +			continue;
> > > +
> > > +		if (!(cedrus_formats[i].directions & direction))
> > > +			continue;
> > > +
> > > +		if (index =3D=3D f->index)
> > > +			break;
> > > +
> > > +		index++;
> > > +	}
> > > +
> > > +	/* Matched format. */
> > > +	if (i < CEDRUS_FORMATS_COUNT) {
> > > +		f->pixelformat =3D cedrus_formats[i].pixelformat;
> > > +
> > > +		return 0;
> > > +	}
> > > +
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static int cedrus_enum_fmt_vid_cap(struct file *file, void *priv,
> > > +				   struct v4l2_fmtdesc *f)
> > > +{
> > > +	return cedrus_enum_fmt(file, f, CEDRUS_DECODE_DST);
> > > +}
> > > +
> > > +static int cedrus_enum_fmt_vid_out(struct file *file, void *priv,
> > > +				   struct v4l2_fmtdesc *f)
> > > +{
> > > +	return cedrus_enum_fmt(file, f, CEDRUS_DECODE_SRC);
> > > +}
> > > +
> > > +static int cedrus_g_fmt_vid_cap(struct file *file, void *priv,
> > > +				struct v4l2_format *f)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +
> > > +	if (f->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > > +		return -EINVAL;
> > > +
> > > +	f->fmt.pix_mp =3D ctx->dst_fmt;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_g_fmt_vid_out(struct file *file, void *priv,
> > > +				struct v4l2_format *f)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +
> > > +	if (f->type !=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > > +		return -EINVAL;
> > > +
> > > +	f->fmt.pix_mp =3D ctx->src_fmt;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_try_fmt_vid_cap(struct file *file, void *priv,
> > > +				  struct v4l2_format *f)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	struct cedrus_format *fmt;
> > > +
> > > +	fmt =3D cedrus_find_format(f->fmt.pix_mp.pixelformat, CEDRUS_DECODE=
_DST,
> > > +				 dev->capabilities);
> > > +	if (!fmt)
> > > +		return -EINVAL;
> > > +
> > > +	cedrus_prepare_format(fmt, f);
> > > +
> > > +	/* Limit to hardware min/max. */
> > > +	f->fmt.pix_mp.width =3D clamp(f->fmt.pix_mp.width, CEDRUS_MIN_WIDTH=
,
> > > +				    CEDRUS_MAX_WIDTH);
> > > +	f->fmt.pix_mp.height =3D clamp(f->fmt.pix_mp.height, CEDRUS_MIN_HEI=
GHT,
> > > +				     CEDRUS_MAX_HEIGHT);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_try_fmt_vid_out(struct file *file, void *priv,
> > > +				  struct v4l2_format *f)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	struct cedrus_format *fmt;
> > > +	struct v4l2_plane_pix_format *plane_fmt;
> > > +	unsigned int i;
> > > +
> > > +	fmt =3D cedrus_find_format(f->fmt.pix_mp.pixelformat, CEDRUS_DECODE=
_SRC,
> > > +				 dev->capabilities);
> > > +	if (!fmt)
> > > +		return -EINVAL;
> > > +
> > > +	cedrus_prepare_format(fmt, f);
> > > +
> > > +	for (i =3D 0; i < f->fmt.pix_mp.num_planes; i++) {
> > > +		plane_fmt =3D &f->fmt.pix_mp.plane_fmt[i];
> > > +
> > > +		/* Source image size has to be given by userspace. */
> > > +		if (plane_fmt->sizeimage =3D=3D 0)
> > > +			return -EINVAL;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
> > > +				struct v4l2_format *f)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	int ret;
> > > +
> > > +	ret =3D cedrus_try_fmt_vid_cap(file, priv, f);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ctx->dst_fmt =3D f->fmt.pix_mp;
> > > +
> > > +	cedrus_dst_format_set(dev, &ctx->dst_fmt);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
> > > +				struct v4l2_format *f)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D cedrus_file2ctx(file);
> > > +	int ret;
> > > +
> > > +	ret =3D cedrus_try_fmt_vid_out(file, priv, f);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ctx->src_fmt =3D f->fmt.pix_mp;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +const struct v4l2_ioctl_ops cedrus_ioctl_ops =3D {
> > > +	.vidioc_querycap		=3D cedrus_querycap,
> > > +
> > > +	.vidioc_enum_fmt_vid_cap_mplane	=3D cedrus_enum_fmt_vid_cap,
> > > +	.vidioc_g_fmt_vid_cap_mplane	=3D cedrus_g_fmt_vid_cap,
> > > +	.vidioc_try_fmt_vid_cap_mplane	=3D cedrus_try_fmt_vid_cap,
> > > +	.vidioc_s_fmt_vid_cap_mplane	=3D cedrus_s_fmt_vid_cap,
> > > +
> > > +	.vidioc_enum_fmt_vid_out_mplane =3D cedrus_enum_fmt_vid_out,
> > > +	.vidioc_g_fmt_vid_out_mplane	=3D cedrus_g_fmt_vid_out,
> > > +	.vidioc_try_fmt_vid_out_mplane	=3D cedrus_try_fmt_vid_out,
> > > +	.vidioc_s_fmt_vid_out_mplane	=3D cedrus_s_fmt_vid_out,
> > > +
> > > +	.vidioc_reqbufs			=3D v4l2_m2m_ioctl_reqbufs,
> > > +	.vidioc_querybuf		=3D v4l2_m2m_ioctl_querybuf,
> > > +	.vidioc_qbuf			=3D v4l2_m2m_ioctl_qbuf,
> > > +	.vidioc_dqbuf			=3D v4l2_m2m_ioctl_dqbuf,
> > > +	.vidioc_prepare_buf		=3D v4l2_m2m_ioctl_prepare_buf,
> > > +	.vidioc_create_bufs		=3D v4l2_m2m_ioctl_create_bufs,
> > > +	.vidioc_expbuf			=3D v4l2_m2m_ioctl_expbuf,
> > > +
> > > +	.vidioc_streamon		=3D v4l2_m2m_ioctl_streamon,
> > > +	.vidioc_streamoff		=3D v4l2_m2m_ioctl_streamoff,
> > > +
> > > +	.vidioc_subscribe_event		=3D v4l2_ctrl_subscribe_event,
> > > +	.vidioc_unsubscribe_event	=3D v4l2_event_unsubscribe,
> > > +};
> > > +
> > > +static int cedrus_queue_setup(struct vb2_queue *vq, unsigned int *nb=
ufs,
> > > +			      unsigned int *nplanes, unsigned int sizes[],
> > > +			      struct device *alloc_devs[])
> > > +{
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	struct v4l2_pix_format_mplane *mplane_fmt;
> > > +	struct cedrus_format *fmt;
> > > +	unsigned int i;
> > > +
> > > +	switch (vq->type) {
> > > +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> > > +		mplane_fmt =3D &ctx->src_fmt;
> > > +		fmt =3D cedrus_find_format(mplane_fmt->pixelformat,
> > > +					 CEDRUS_DECODE_SRC,
> > > +					 dev->capabilities);
> > > +		break;
> > > +
> > > +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> > > +		mplane_fmt =3D &ctx->dst_fmt;
> > > +		fmt =3D cedrus_find_format(mplane_fmt->pixelformat,
> > > +					 CEDRUS_DECODE_DST,
> > > +					 dev->capabilities);
> > > +		break;
> > > +
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (!fmt)
> > > +		return -EINVAL;
> > > +
> > > +	if (fmt->num_buffers =3D=3D 1) {
> > > +		sizes[0] =3D 0;
> > > +
> > > +		for (i =3D 0; i < fmt->num_planes; i++)
> > > +			sizes[0] +=3D mplane_fmt->plane_fmt[i].sizeimage;
> > > +	} else if (fmt->num_buffers =3D=3D fmt->num_planes) {
> > > +		for (i =3D 0; i < fmt->num_planes; i++)
> > > +			sizes[i] =3D mplane_fmt->plane_fmt[i].sizeimage;
> > > +	} else {
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	*nplanes =3D fmt->num_buffers;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_buf_init(struct vb2_buffer *vb)
> > > +{
> > > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > > +
> > > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > > +		ctx->dst_bufs[vb->index] =3D vb;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void cedrus_buf_cleanup(struct vb2_buffer *vb)
> > > +{
> > > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > > +
> > > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > > +		ctx->dst_bufs[vb->index] =3D NULL;
> > > +}
> > > +
> > > +static int cedrus_buf_prepare(struct vb2_buffer *vb)
> > > +{
> > > +	struct vb2_queue *vq =3D vb->vb2_queue;
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vq);
> > > +	struct v4l2_pix_format_mplane *fmt;
> > > +	unsigned int buffer_size =3D 0;
> > > +	unsigned int format_size =3D 0;
> > > +	unsigned int i;
> > > +
> > > +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> > > +		fmt =3D &ctx->src_fmt;
> > > +	else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> > > +		fmt =3D &ctx->dst_fmt;
> > > +	else
> > > +		return -EINVAL;
> > > +
> > > +	for (i =3D 0; i < vb->num_planes; i++)
> > > +		buffer_size +=3D vb2_plane_size(vb, i);
> > > +
> > > +	for (i =3D 0; i < fmt->num_planes; i++)
> > > +		format_size +=3D fmt->plane_fmt[i].sizeimage;
> > > +
> > > +	if (buffer_size < format_size)
> > > +		return -EINVAL;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int cedrus_start_streaming(struct vb2_queue *q, unsigned int
> > > count)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	int ret =3D 0;
> > > +
> > > +	switch (ctx->src_fmt.pixelformat) {
> > > +	case V4L2_PIX_FMT_MPEG2_SLICE:
> > > +		ctx->current_codec =3D CEDRUS_CODEC_MPEG2;
> > > +		break;
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
> > > +	    dev->dec_ops[ctx->current_codec]->start)
> > > +		ret =3D dev->dec_ops[ctx->current_codec]->start(ctx);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static void cedrus_stop_streaming(struct vb2_queue *q)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > +	struct vb2_v4l2_buffer *vbuf;
> > > +	unsigned long flags;
> > > +
> > > +	flush_scheduled_work();
> > > +
> > > +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
> > > +	    dev->dec_ops[ctx->current_codec]->stop)
> > > +		dev->dec_ops[ctx->current_codec]->stop(ctx);
> > > +
> > > +	for (;;) {
> > > +		spin_lock_irqsave(&ctx->dev->irq_lock, flags);
> > > +
> > > +		if (V4L2_TYPE_IS_OUTPUT(q->type))
> > > +			vbuf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > > +		else
> > > +			vbuf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> > > +
> > > +		spin_unlock_irqrestore(&ctx->dev->irq_lock, flags);
> > > +
> > > +		if (!vbuf)
> > > +			return;
> > > +
> > > +		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
> > > +					   &ctx->hdl);
> > > +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> > > +	}
> > > +}
> > > +
> > > +static void cedrus_buf_queue(struct vb2_buffer *vb)
> > > +{
> > > +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > > +
> > > +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> > > +}
> > > +
> > > +static void cedrus_buf_request_complete(struct vb2_buffer *vb)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > > +
> > > +	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
> > > +}
> > > +
> > > +static struct vb2_ops cedrus_qops =3D {
> > > +	.queue_setup		=3D cedrus_queue_setup,
> > > +	.buf_prepare		=3D cedrus_buf_prepare,
> > > +	.buf_init		=3D cedrus_buf_init,
> > > +	.buf_cleanup		=3D cedrus_buf_cleanup,
> > > +	.buf_queue		=3D cedrus_buf_queue,
> > > +	.buf_request_complete	=3D cedrus_buf_request_complete,
> > > +	.start_streaming	=3D cedrus_start_streaming,
> > > +	.stop_streaming		=3D cedrus_stop_streaming,
> > > +	.wait_prepare		=3D vb2_ops_wait_prepare,
> > > +	.wait_finish		=3D vb2_ops_wait_finish,
> > > +};
> > > +
> > > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > > +		      struct vb2_queue *dst_vq)
> > > +{
> > > +	struct cedrus_ctx *ctx =3D priv;
> > > +	int ret;
> > > +
> > > +	src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > > +	src_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > > +	src_vq->drv_priv =3D ctx;
> > > +	src_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > > +	src_vq->allow_zero_bytesused =3D 1;
> > > +	src_vq->min_buffers_needed =3D 1;
> > > +	src_vq->ops =3D &cedrus_qops;
> > > +	src_vq->mem_ops =3D &vb2_dma_contig_memops;
> > > +	src_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > > +	src_vq->lock =3D &ctx->dev->dev_mutex;
> > > +	src_vq->dev =3D ctx->dev->dev;
> > > +
> > > +	ret =3D vb2_queue_init(src_vq);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > > +	dst_vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> > > +	dst_vq->drv_priv =3D ctx;
> > > +	dst_vq->buf_struct_size =3D sizeof(struct cedrus_buffer);
> > > +	dst_vq->allow_zero_bytesused =3D 1;
> > > +	dst_vq->min_buffers_needed =3D 1;
> > > +	dst_vq->ops =3D &cedrus_qops;
> > > +	dst_vq->mem_ops =3D &vb2_dma_contig_memops;
> > > +	dst_vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> > > +	dst_vq->lock =3D &ctx->dev->dev_mutex;
> > > +	dst_vq->dev =3D ctx->dev->dev;
> > > +
> > > +	return vb2_queue_init(dst_vq);
> > > +}
> > > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.h
> > > b/drivers/staging/media/sunxi/cedrus/cedrus_video.h new file mode 100=
644
> > > index 000000000000..56afcc8c02ba
> > > --- /dev/null
> > > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.h
> > > @@ -0,0 +1,31 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +/*
> > > + * Sunxi-Cedrus VPU driver
> > > + *
> > > + * Copyright (C) 2018 Paul Kocialkowski <paul.kocialkowski@bootlin.c=
om>
> > > + * Copyright (C) 2016 Florent Revest <florent.revest@free-electrons.=
com>
> > > + *
> > > + * Based on the vim2m driver, that is:
> > > + *
> > > + * Copyright (c) 2009-2010 Samsung Electronics Co., Ltd.
> > > + * Pawel Osciak, <pawel@osciak.com>
> > > + * Marek Szyprowski, <m.szyprowski@samsung.com>
> > > + */
> > > +
> > > +#ifndef _CEDRUS_VIDEO_H_
> > > +#define _CEDRUS_VIDEO_H_
> > > +
> > > +struct cedrus_format {
> > > +	u32		pixelformat;
> > > +	u32		directions;
> > > +	unsigned int	num_planes;
> > > +	unsigned int	num_buffers;
> > > +	unsigned int	capabilities;
> > > +};
> > > +
> > > +extern const struct v4l2_ioctl_ops cedrus_ioctl_ops;
> > > +
> > > +int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
> > > +		      struct vb2_queue *dst_vq);
> > > +
> > > +#endif
>=20
>=20
>=20
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-aWIeaR52ncm/ASAbyqb9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltpkQcACgkQ3cLmz3+f
v9HVYgf+LjMm2v0Za1Rl2t5p1AznqkwwKqXziCepYpBILqdXKlakMVFce7yQf2ip
HsEsvPBvmwTnLovYAtPuqV1jTy5izqtfK572+z3tzCZfVIsjiuijdH+JwYTHRj7d
twjzXCMdGh+3IT/BCNi1ot78BtIINEdvYZtq/BhnaPDquGXyqNqs0/C1rl9/vKqs
6ahMdWhPZDYPBaI2Rf0jYQX+3lNCkbKnmu0yAjDRSIWuosm9b8o0yWUOfdqEupFE
2nFBf/epRbI2H9U3Drl8q9dMOB/HwEuIVR9LiIiomMOMJVt6qH26J9TH8XmRD2Qi
tMovjDghp51oMqnXKor36OmoDy/dJQ==
=QQCx
-----END PGP SIGNATURE-----

--=-aWIeaR52ncm/ASAbyqb9--
