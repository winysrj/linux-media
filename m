Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43751 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbeK3SjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 13:39:11 -0500
Date: Fri, 30 Nov 2018 08:30:47 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>
Cc: linux-sunxi@googlegroups.com, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 2/2] media: cedrus: Add H264 decoding
 support
Message-ID: <20181130073047.auafqe3rzdqfs32d@flea>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com>
 <2826880.kP3DS59ZBy@jernej-laptop>
 <20181127155028.5ukw3g6zjbnvarbp@flea>
 <6005903.5qHflpuMbl@jernej-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cc6r7wwwz2glmnhj"
Content-Disposition: inline
In-Reply-To: <6005903.5qHflpuMbl@jernej-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cc6r7wwwz2glmnhj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2018 at 05:30:00PM +0100, Jernej =C5=A0krabec wrote:
> > > > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > > > +				   struct cedrus_run *run,
> > > > +				   const u8 *ref_list, u8 num_ref,
> > > > +				   enum cedrus_h264_sram_off sram)
> > > > +{
> > > > +	const struct v4l2_ctrl_h264_decode_param *decode =3D
> > > > run->h264.decode_param; +	struct vb2_queue *cap_q =3D
> > > > &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > > +	u32 sram_array[CEDRUS_MAX_REF_IDX / sizeof(u32)];
> > > > +	unsigned int size, i;
> > > > +
> > > > +	memset(sram_array, 0, sizeof(sram_array));
> > > > +
> > > > +	for (i =3D 0; i < num_ref; i +=3D 4) {
> > > > +		unsigned int j;
> > > > +
> > > > +		for (j =3D 0; j < 4; j++) {
> > >=20
> > > I don't think you have to complicate with two loops here.
> > > cedrus_h264_write_sram() takes void* and it aligns to 4 anyway. So as=
 long
> > > input buffer is multiple of 4 (u8[CEDRUS_MAX_REF_IDX] qualifies for t=
hat),
> > > you can use single for loop with "u8 sram_array[CEDRUS_MAX_REF_IDX]".
> > > This should make code much more readable.
> >=20
> > This wasn't really about the alignment, but in order to get the
> > offsets in the u32 and the array more easily.
> >=20
> > Breaking out the loop will make that computation less easy on the eye,
> > so I guess it's very subjective.
> >=20
>=20
> For some strange reason, code below fixes decoding issue from one of my t=
est=20
> samples. This is what I actually meant with 1 loop approach:

Do you have that test sample somewhere accessible?

> static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> 				   struct cedrus_run *run,
> 				   const u8 *ref_list, u8 num_ref,
> 				   enum cedrus_h264_sram_off sram)
> {
> 	const struct v4l2_ctrl_h264_decode_param *decode =3D run->h264.decode_pa=
ram;
> 	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> 	struct cedrus_dev *dev =3D ctx->dev;
> 	u8 sram_array[CEDRUS_MAX_REF_IDX];
> 	unsigned int i;
>=20
> 	memset(sram_array, 0, sizeof(sram_array));
> 	num_ref =3D min(num_ref, (u8)CEDRUS_MAX_REF_IDX);
>=20
> 	for (i =3D 0; i < num_ref; i++) {
> 		const struct v4l2_h264_dpb_entry *dpb;
> 		const struct cedrus_buffer *cedrus_buf;
> 		const struct vb2_v4l2_buffer *ref_buf;
> 		unsigned int position;
> 		int buf_idx;
> 		u8 dpb_idx;
>=20
> 		dpb_idx =3D ref_list[i];
> 		dpb =3D &decode->dpb[dpb_idx];
>=20
> 		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> 			continue;
>=20
> 		buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> 		if (buf_idx < 0)
> 			continue;
>=20
> 		ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> 		cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> 		position =3D cedrus_buf->codec.h264.position;
>=20
> 		sram_array[i] |=3D position << 1;
> 		if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
> 			sram_array[i] |=3D BIT(0);
> 	}
>=20
> 	cedrus_h264_write_sram(dev, sram, &sram_array, num_ref);
> }
>=20
> IMO this code is easier to read.

INdeed, thanks!

> > > > +			const struct v4l2_h264_dpb_entry *dpb;
> > > > +			const struct cedrus_buffer *cedrus_buf;
> > > > +			const struct vb2_v4l2_buffer *ref_buf;
> > > > +			unsigned int position;
> > > > +			int buf_idx;
> > > > +			u8 ref_idx =3D i + j;
> > > > +			u8 dpb_idx;
> > > > +
> > > > +			if (ref_idx >=3D num_ref)
> > > > +				break;
> > > > +
> > > > +			dpb_idx =3D ref_list[ref_idx];
> > > > +			dpb =3D &decode->dpb[dpb_idx];
> > > > +
> > > > +			if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > > > +				continue;
> > > > +
> > > > +			buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> > > > +			if (buf_idx < 0)
> > > > +				continue;
> > > > +
> > > > +			ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > > > +			cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > > > +			position =3D cedrus_buf->codec.h264.position;
> > > > +
> > > > +			sram_array[i] |=3D position << (j * 8 + 1);
> > > > +			if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
> > >=20
> > > You newer set above flag to buffer so this will be always false.
> >=20
> > As far as I know, the field is supposed to be set by the userspace.
>=20
> How? I thought that only flags at queueing buffers can be set and there i=
s no=20
> bottom/top flag.

https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#c.v4l2_buff=
er

"Indicates the field order of the image in the buffer, see
v4l2_field. This field is not used when the buffer contains VBI
data. Drivers must set it when type refers to a capture stream,
applications when it refers to an output stream."

My understanding is that the application should set it, since we'll
use the output stream's buffer here. But I might very well be wrong
about it :/

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--cc6r7wwwz2glmnhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXADnJwAKCRDj7w1vZxhR
xTuYAQCEtGfmiUuTm93fk/hrPJWU/f/FFB088sTduq+8++H61wEA5anWdMhWub1M
AWZzg6ZguMdHkZkIT/ArhF3hHekzrwM=
=oxTm
-----END PGP SIGNATURE-----

--cc6r7wwwz2glmnhj--
