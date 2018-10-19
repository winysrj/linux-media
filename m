Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59410 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbeJSTld (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 15:41:33 -0400
Message-ID: <16ce7d348d553a91d8e52976c434952b4db0192c.camel@collabora.com>
Subject: Re: [PATCH 2/2] vicodec: Implement spec-compliant stop command
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Date: Fri, 19 Oct 2018 07:35:47 -0400
In-Reply-To: <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
References: <20181018160841.17674-1-ezequiel@collabora.com>
         <20181018160841.17674-3-ezequiel@collabora.com>
         <b75076e1-075b-50eb-96ff-f7115168d2bd@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-zGXHtA32c2DMAyO28DUM"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-zGXHtA32c2DMAyO28DUM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 19 octobre 2018 =C3=A0 09:28 +0200, Hans Verkuil a =C3=A9crit :
> On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
> > Set up a statically-allocated, dummy buffer to
> > be used as flush buffer, which signals
> > a encoding (or decoding) stop.
> >=20
> > When the flush buffer is queued to the OUTPUT queue,
> > the driver will send an V4L2_EVENT_EOS event, and
> > mark the CAPTURE buffer with V4L2_BUF_FLAG_LAST.
>=20
> I'm confused. What is the current driver doing wrong? It is already
> setting the LAST flag AFAIK. I don't see why a dummy buffer is
> needed.

I'm not sure of this patch either. It seems to trigger the legacy
"empty payload" buffer case. Driver should mark the last buffer, and
then following poll should return EPIPE. Maybe it's the later that
isn't respected ?

>=20
> Regards,
>=20
> 	Hans
>=20
> >=20
> > With this change, it's possible to run a pipeline to completion:
> >=20
> > gst-launch-1.0 videotestsrc num-buffers=3D10 ! v4l2fwhtenc !
> > v4l2fwhtdec ! fakevideosink
> >=20
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> >  drivers/media/platform/vicodec/vicodec-core.c | 80 ++++++++++-----
> > ----
> >  1 file changed, 44 insertions(+), 36 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/vicodec/vicodec-core.c
> > b/drivers/media/platform/vicodec/vicodec-core.c
> > index a2c487b4b80d..4ed4dae10e30 100644
> > --- a/drivers/media/platform/vicodec/vicodec-core.c
> > +++ b/drivers/media/platform/vicodec/vicodec-core.c
> > @@ -113,7 +113,7 @@ struct vicodec_ctx {
> >  	struct v4l2_ctrl_handler hdl;
> > =20
> >  	struct vb2_v4l2_buffer *last_src_buf;
> > -	struct vb2_v4l2_buffer *last_dst_buf;
> > +	struct vb2_v4l2_buffer  flush_buf;
> > =20
> >  	/* Source and destination queue data */
> >  	struct vicodec_q_data   q_data[2];
> > @@ -220,6 +220,7 @@ static void device_run(void *priv)
> >  	struct vicodec_dev *dev =3D ctx->dev;
> >  	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> >  	struct vicodec_q_data *q_out;
> > +	bool flushing;
> >  	u32 state;
> > =20
> >  	src_buf =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> > @@ -227,26 +228,36 @@ static void device_run(void *priv)
> >  	q_out =3D get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > =20
> >  	state =3D VB2_BUF_STATE_DONE;
> > -	if (device_process(ctx, src_buf, dst_buf))
> > +
> > +	flushing =3D (src_buf =3D=3D &ctx->flush_buf);
> > +	if (!flushing && device_process(ctx, src_buf, dst_buf))
> >  		state =3D VB2_BUF_STATE_ERROR;
> > -	ctx->last_dst_buf =3D dst_buf;
> > =20
> >  	spin_lock(ctx->lock);
> > -	if (!ctx->comp_has_next_frame && src_buf =3D=3D ctx->last_src_buf)
> > {
> > +	if (!flushing) {
> > +		if (!ctx->comp_has_next_frame && src_buf =3D=3D ctx-
> > >last_src_buf) {
> > +			dst_buf->flags |=3D V4L2_BUF_FLAG_LAST;
> > +			v4l2_event_queue_fh(&ctx->fh, &eos_event);
> > +		}
> > +
> > +		if (ctx->is_enc) {
> > +			src_buf->sequence =3D q_out->sequence++;
> > +			src_buf =3D v4l2_m2m_src_buf_remove(ctx-
> > >fh.m2m_ctx);
> > +			v4l2_m2m_buf_done(src_buf, state);
> > +		} else if (vb2_get_plane_payload(&src_buf->vb2_buf, 0)
> > +				=3D=3D ctx->cur_buf_offset) {
> > +			src_buf->sequence =3D q_out->sequence++;
> > +			src_buf =3D v4l2_m2m_src_buf_remove(ctx-
> > >fh.m2m_ctx);
> > +			v4l2_m2m_buf_done(src_buf, state);
> > +			ctx->cur_buf_offset =3D 0;
> > +			ctx->comp_has_next_frame =3D false;
> > +		}
> > +	} else {
> > +		src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > +		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
> >  		dst_buf->flags |=3D V4L2_BUF_FLAG_LAST;
> >  		v4l2_event_queue_fh(&ctx->fh, &eos_event);
> >  	}
> > -	if (ctx->is_enc) {
> > -		src_buf->sequence =3D q_out->sequence++;
> > -		src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > -		v4l2_m2m_buf_done(src_buf, state);
> > -	} else if (vb2_get_plane_payload(&src_buf->vb2_buf, 0) =3D=3D ctx-
> > >cur_buf_offset) {
> > -		src_buf->sequence =3D q_out->sequence++;
> > -		src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> > -		v4l2_m2m_buf_done(src_buf, state);
> > -		ctx->cur_buf_offset =3D 0;
> > -		ctx->comp_has_next_frame =3D false;
> > -	}
> >  	v4l2_m2m_buf_done(dst_buf, state);
> >  	ctx->comp_size =3D 0;
> >  	ctx->comp_magic_cnt =3D 0;
> > @@ -293,6 +304,8 @@ static int job_ready(void *priv)
> >  	src_buf =3D v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> >  	if (!src_buf)
> >  		return 0;
> > +	if (src_buf =3D=3D &ctx->flush_buf)
> > +		return 1;
> >  	p_out =3D vb2_plane_vaddr(&src_buf->vb2_buf, 0);
> >  	sz =3D vb2_get_plane_payload(&src_buf->vb2_buf, 0);
> >  	p =3D p_out + ctx->cur_buf_offset;
> > @@ -770,21 +783,6 @@ static int vidioc_s_fmt_vid_out(struct file
> > *file, void *priv,
> >  	return ret;
> >  }
> > =20
> > -static void vicodec_mark_last_buf(struct vicodec_ctx *ctx)
> > -{
> > -	static const struct v4l2_event eos_event =3D {
> > -		.type =3D V4L2_EVENT_EOS
> > -	};
> > -
> > -	spin_lock(ctx->lock);
> > -	ctx->last_src_buf =3D v4l2_m2m_last_src_buf(ctx->fh.m2m_ctx);
> > -	if (!ctx->last_src_buf && ctx->last_dst_buf) {
> > -		ctx->last_dst_buf->flags |=3D V4L2_BUF_FLAG_LAST;
> > -		v4l2_event_queue_fh(&ctx->fh, &eos_event);
> > -	}
> > -	spin_unlock(ctx->lock);
> > -}
> > -
> >  static int vicodec_try_encoder_cmd(struct file *file, void *fh,
> >  				struct v4l2_encoder_cmd *ec)
> >  {
> > @@ -806,8 +804,8 @@ static int vicodec_encoder_cmd(struct file
> > *file, void *fh,
> >  	ret =3D vicodec_try_encoder_cmd(file, fh, ec);
> >  	if (ret < 0)
> >  		return ret;
> > -
> > -	vicodec_mark_last_buf(ctx);
> > +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, &ctx->flush_buf);
> > +	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
> >  	return 0;
> >  }
> > =20
> > @@ -835,8 +833,8 @@ static int vicodec_decoder_cmd(struct file
> > *file, void *fh,
> >  	ret =3D vicodec_try_decoder_cmd(file, fh, dc);
> >  	if (ret < 0)
> >  		return ret;
> > -
> > -	vicodec_mark_last_buf(ctx);
> > +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, &ctx->flush_buf);
> > +	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
> >  	return 0;
> >  }
> > =20
> > @@ -991,7 +989,7 @@ static void vicodec_return_bufs(struct
> > vb2_queue *q, u32 state)
> >  			vbuf =3D v4l2_m2m_src_buf_remove(ctx-
> > >fh.m2m_ctx);
> >  		else
> >  			vbuf =3D v4l2_m2m_dst_buf_remove(ctx-
> > >fh.m2m_ctx);
> > -		if (vbuf =3D=3D NULL)
> > +		if (!vbuf || vbuf =3D=3D &ctx->flush_buf)
> >  			return;
> >  		spin_lock(ctx->lock);
> >  		v4l2_m2m_buf_done(vbuf, state);
> > @@ -1031,7 +1029,6 @@ static int vicodec_start_streaming(struct
> > vb2_queue *q,
> >  	state->ref_frame.cb =3D state->ref_frame.luma + size;
> >  	state->ref_frame.cr =3D state->ref_frame.cb + size / chroma_div;
> >  	ctx->last_src_buf =3D NULL;
> > -	ctx->last_dst_buf =3D NULL;
> >  	state->gop_cnt =3D 0;
> >  	ctx->cur_buf_offset =3D 0;
> >  	ctx->comp_size =3D 0;
> > @@ -1158,6 +1155,7 @@ static int vicodec_open(struct file *file)
> >  	struct vicodec_dev *dev =3D video_drvdata(file);
> >  	struct vicodec_ctx *ctx =3D NULL;
> >  	struct v4l2_ctrl_handler *hdl;
> > +	struct vb2_queue *vq;
> >  	unsigned int size;
> >  	int rc =3D 0;
> > =20
> > @@ -1234,6 +1232,16 @@ static int vicodec_open(struct file *file)
> > =20
> >  	v4l2_fh_add(&ctx->fh);
> > =20
> > +	/* Setup a dummy flush buffer, used to signal
> > +	 * encoding/decoding stop operation. When this buffer
> > +	 * is queued to the OUTPUT queue, the driver will send
> > +	 * V4L2_EVENT_EOS and send the last buffer to userspace.
> > +	 */
> > +	vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, multiplanar ?
> > +			     V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
> > +			     V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +	ctx->flush_buf.vb2_buf.vb2_queue =3D vq;
> > +
> >  open_unlock:
> >  	mutex_unlock(vfd->lock);
> >  	return rc;
> >=20
>=20
>=20

--=-zGXHtA32c2DMAyO28DUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW8nBkwAKCRBxUwItrAao
HDUOAJ9WE+uDZ4+hovUvllV55cSjfjo51wCeLK6jBr9R+k4GMEe8PAcXNKvytc4=
=qqwz
-----END PGP SIGNATURE-----

--=-zGXHtA32c2DMAyO28DUM--
