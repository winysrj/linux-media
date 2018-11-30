Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45832 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725749AbeLAFGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 00:06:51 -0500
From: Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To: linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com
Cc: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 2/2] media: cedrus: Add H264 decoding support
Date: Fri, 30 Nov 2018 18:56:41 +0100
Message-ID: <2869850.yJDP4l804T@jernej-laptop>
In-Reply-To: <20181130073047.auafqe3rzdqfs32d@flea>
References: <20181115145650.9827-1-maxime.ripard@bootlin.com> <6005903.5qHflpuMbl@jernej-laptop> <20181130073047.auafqe3rzdqfs32d@flea>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne petek, 30. november 2018 ob 08:30:47 CET je Maxime Ripard napisal(a):
> On Tue, Nov 27, 2018 at 05:30:00PM +0100, Jernej =C5=A0krabec wrote:
> > > > > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > > > > +				   struct cedrus_run *run,
> > > > > +				   const u8 *ref_list, u8 num_ref,
> > > > > +				   enum cedrus_h264_sram_off sram)
> > > > > +{
> > > > > +	const struct v4l2_ctrl_h264_decode_param *decode =3D
> > > > > run->h264.decode_param; +	struct vb2_queue *cap_q =3D
> > > > > &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > > > > +	struct cedrus_dev *dev =3D ctx->dev;
> > > > > +	u32 sram_array[CEDRUS_MAX_REF_IDX / sizeof(u32)];
> > > > > +	unsigned int size, i;
> > > > > +
> > > > > +	memset(sram_array, 0, sizeof(sram_array));
> > > > > +
> > > > > +	for (i =3D 0; i < num_ref; i +=3D 4) {
> > > > > +		unsigned int j;
> > > > > +
> > > > > +		for (j =3D 0; j < 4; j++) {
> > > >=20
> > > > I don't think you have to complicate with two loops here.
> > > > cedrus_h264_write_sram() takes void* and it aligns to 4 anyway. So =
as
> > > > long
> > > > input buffer is multiple of 4 (u8[CEDRUS_MAX_REF_IDX] qualifies for
> > > > that),
> > > > you can use single for loop with "u8 sram_array[CEDRUS_MAX_REF_IDX]=
".
> > > > This should make code much more readable.
> > >=20
> > > This wasn't really about the alignment, but in order to get the
> > > offsets in the u32 and the array more easily.
> > >=20
> > > Breaking out the loop will make that computation less easy on the eye,
> > > so I guess it's very subjective.
> >=20
> > For some strange reason, code below fixes decoding issue from one of my
> > test
> > samples. This is what I actually meant with 1 loop approach:
> Do you have that test sample somewhere accessible?

yes, it's here:
http://jernej.libreelec.tv/videos/h264/Star%20Wars%20Episode%20VII%20-%20Th=
e%20Force%20Awakens%20-%20Teaser%20Trailer%202.mp4

It needs also prediction weight tables (your early patch for that should wo=
rk=20
ok) and scaling list (code I sent you in one of the previous comments shoul=
d=20
work).

=46or me, if this sample worked without issue, every other non-interlaced s=
ample=20
worked too.

>=20
> > static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> >=20
> > 				   struct cedrus_run *run,
> > 				   const u8 *ref_list, u8 num_ref,
> > 				   enum cedrus_h264_sram_off sram)
> >=20
> > {
> >=20
> > 	const struct v4l2_ctrl_h264_decode_param *decode =3D
> > 	run->h264.decode_param;
> > 	struct vb2_queue *cap_q =3D &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > 	struct cedrus_dev *dev =3D ctx->dev;
> > 	u8 sram_array[CEDRUS_MAX_REF_IDX];
> > 	unsigned int i;
> > =09
> > 	memset(sram_array, 0, sizeof(sram_array));
> > 	num_ref =3D min(num_ref, (u8)CEDRUS_MAX_REF_IDX);
> > =09
> > 	for (i =3D 0; i < num_ref; i++) {
> > =09
> > 		const struct v4l2_h264_dpb_entry *dpb;
> > 		const struct cedrus_buffer *cedrus_buf;
> > 		const struct vb2_v4l2_buffer *ref_buf;
> > 		unsigned int position;
> > 		int buf_idx;
> > 		u8 dpb_idx;
> > 	=09
> > 		dpb_idx =3D ref_list[i];
> > 		dpb =3D &decode->dpb[dpb_idx];
> > 	=09
> > 		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > 	=09
> > 			continue;
> > 	=09
> > 		buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> > 		if (buf_idx < 0)
> > 	=09
> > 			continue;
> > 	=09
> > 		ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > 		cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > 		position =3D cedrus_buf->codec.h264.position;
> > 	=09
> > 		sram_array[i] |=3D position << 1;
> > 		if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
> > 	=09
> > 			sram_array[i] |=3D BIT(0);
> > =09
> > 	}
> > =09
> > 	cedrus_h264_write_sram(dev, sram, &sram_array, num_ref);
> >=20
> > }
> >=20
> > IMO this code is easier to read.
>=20
> INdeed, thanks!
>=20
> > > > > +			const struct v4l2_h264_dpb_entry *dpb;
> > > > > +			const struct cedrus_buffer *cedrus_buf;
> > > > > +			const struct vb2_v4l2_buffer *ref_buf;
> > > > > +			unsigned int position;
> > > > > +			int buf_idx;
> > > > > +			u8 ref_idx =3D i + j;
> > > > > +			u8 dpb_idx;
> > > > > +
> > > > > +			if (ref_idx >=3D num_ref)
> > > > > +				break;
> > > > > +
> > > > > +			dpb_idx =3D ref_list[ref_idx];
> > > > > +			dpb =3D &decode->dpb[dpb_idx];
> > > > > +
> > > > > +			if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > > > > +				continue;
> > > > > +
> > > > > +			buf_idx =3D vb2_find_tag(cap_q, dpb->tag, 0);
> > > > > +			if (buf_idx < 0)
> > > > > +				continue;
> > > > > +
> > > > > +			ref_buf =3D to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > > > > +			cedrus_buf =3D vb2_v4l2_to_cedrus_buffer(ref_buf);
> > > > > +			position =3D cedrus_buf->codec.h264.position;
> > > > > +
> > > > > +			sram_array[i] |=3D position << (j * 8 + 1);
> > > > > +			if (ref_buf->field =3D=3D V4L2_FIELD_BOTTOM)
> > > >=20
> > > > You newer set above flag to buffer so this will be always false.
> > >=20
> > > As far as I know, the field is supposed to be set by the userspace.
> >=20
> > How? I thought that only flags at queueing buffers can be set and there=
 is
> > no bottom/top flag.
>=20
> https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/buffer.html#c.v4l2_bu=
ffe
> r
>=20
> "Indicates the field order of the image in the buffer, see
> v4l2_field. This field is not used when the buffer contains VBI
> data. Drivers must set it when type refers to a capture stream,
> applications when it refers to an output stream."
>=20
> My understanding is that the application should set it, since we'll
> use the output stream's buffer here. But I might very well be wrong
> about it :/

I'll take a look, thanks.

Best regards,
Jernej
