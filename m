Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48749 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcGRNab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 09:30:31 -0400
Message-ID: <1468848623.9179.18.camel@ndufresne.ca>
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Date: Mon, 18 Jul 2016 09:30:23 -0400
In-Reply-To: <ee857812-cf05-b714-eb6e-b696767a0067@xs4all.nl>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
	 <ee857812-cf05-b714-eb6e-b696767a0067@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xLXN/fxq6hkPXkBwNW0g"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-xLXN/fxq6hkPXkBwNW0g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 18 juillet 2016 =C3=A0 10:34 +0200, Hans Verkuil a =C3=A9crit=C2=
=A0:
> On 07/15/2016 06:26 PM, Javier Martinez Canillas wrote:
> > The buffer planes' dma-buf are currently mapped when buffers are queued
> > from userspace but it's more appropriate to do the mapping when buffers
> > are queued in the driver since that's when the actual DMA operation are
> > going to happen.
>=20
> Does this solve anything? Once the DMA has started the behavior is the sa=
me
> as before (QBUF maps the dmabuf), only while the DMA engine hasn't starte=
d
> yet are the QBUF calls just accepted and the mapping takes place when the
> DMA is kickstarted. This makes QBUF behave inconsistently.

The expected behaviour would have been to ensure that DMABuf mapping
only happen when the driver need the buffer (as late as possible). As
you describes it, the goal is not met.

>=20
> You don't describe here WHY this change is needed.

It should have been explained (just like this patch should have been
marked as RFC). The is numerous reason why you don't want to spend
userspace time mapping a buffers.

First the context, mapping a DMA-Buf is a costy operation. With the
venu of DMA-Buf fences, (in implicit mode) this operation becomes even
more expensive in term of time you block userspace. By mapping in QBUF,
you do block the userspace process for a certain duration.

By delaying the mapping later, the time spent mapping is now in the
driver thread, without blocking the userspace. This allow running with
much lower latency, as the userspace can (if already available) fetch
the following buffer and put it in the queue without further delays. As
the buffers are available earlier, the streaming can be started sooner
and no time is lost.

Another reason, which was not part of our discussion, is that if you
have a display at lower framerate, it would allow appropriate frame
skipping to be implemented. Mapping all the frames, even the one that
won't be displayed would be inefficient.

So basically, what we are saying, is that the currently implemented
mechanism is a was of userspace time, reduce the benefit of using
fences and increase latency.
=C2=A0
>=20
> I'm not sure I agree with the TODO, and even if I did, I'm not sure I agr=
ee
> with this solution. Since queuing the buffer to the driver is not the sam=
e
> as 'just before the DMA', since there may be many buffers queued up in th=
e
> driver and you don't know in vb2 when the buffer is at the 'just before t=
he DMA'
> stage.

Unfortunate, but it's just software ;-P An idea would be to introduce
some new state for preparing a buffers, so the driver don't endup
waiting at an unfortunate moment. Again, this is all only needed if we
can provide the same level of buffer validation we had at QBUF. As we
don't expose to userspace the information needed to validate if a DMA-
Buf is compatible, we started (not yet merged) implementing fallback at
QBuf. Failing asynchronously would leave userspace with absolutely no
way to handle the case of incompatible DMA-Buf.

Regards,
Nicolas

p.s. I'll be away for the rest of the summer, see you in September.

>=20
> Regards,
>=20
> 	Hans
>=20
> >=20
> > Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >=20
> > ---
> >=20
> > Hello,
> >=20
> > A side effect of this change is that if the dmabuf map fails for some
> > reasons (i.e: a driver using the DMA contig memory allocator but CMA
> > not being enabled), the fail will no longer happen on VIDIOC_QBUF but
> > later (i.e: in VIDIOC_STREAMON).
> >=20
> > I don't know if that's an issue though but I think is worth mentioning.
> >=20
> > Best regards,
> > Javier
> >=20
> > =C2=A0drivers/media/v4l2-core/videobuf2-core.c | 88 +++++++++++++++++++=
+------------
> > =C2=A01 file changed, 54 insertions(+), 34 deletions(-)
> >=20
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v=
4l2-core/videobuf2-core.c
> > index ca8ffeb56d72..3fdf882bf279 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -186,7 +186,7 @@ module_param(debug, int, 0644);
> > =C2=A0})
> > =C2=A0
> > =C2=A0static void __vb2_queue_cancel(struct vb2_queue *q);
> > -static void __enqueue_in_driver(struct vb2_buffer *vb);
> > +static int __enqueue_in_driver(struct vb2_buffer *vb);
> > =C2=A0
> > =C2=A0/**
> > =C2=A0 * __vb2_buf_mem_alloc() - allocate video memory for the given bu=
ffer
> > @@ -1271,20 +1271,6 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, =
const void *pb)
> > =C2=A0		vb->planes[plane].mem_priv =3D mem_priv;
> > =C2=A0	}
> > =C2=A0
> > -	/* TODO: This pins the buffer(s) with=C2=A0=C2=A0dma_buf_map_attachme=
nt()).. but
> > -	=C2=A0* really we want to do this just before the DMA, not while queu=
eing
> > -	=C2=A0* the buffer(s)..
> > -	=C2=A0*/
> > -	for (plane =3D 0; plane < vb->num_planes; ++plane) {
> > -		ret =3D call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
> > -		if (ret) {
> > -			dprintk(1, "failed to map dmabuf for plane %d\n",
> > -				plane);
> > -			goto err;
> > -		}
> > -		vb->planes[plane].dbuf_mapped =3D 1;
> > -	}
> > -
> > =C2=A0	/*
> > =C2=A0	=C2=A0* Now that everything is in order, copy relevant informati=
on
> > =C2=A0	=C2=A0* provided by userspace.
> > @@ -1296,51 +1282,79 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb,=
 const void *pb)
> > =C2=A0		vb->planes[plane].data_offset =3D planes[plane].data_offset;
> > =C2=A0	}
> > =C2=A0
> > -	if (reacquired) {
> > -		/*
> > -		=C2=A0* Call driver-specific initialization on the newly acquired bu=
ffer,
> > -		=C2=A0* if provided.
> > -		=C2=A0*/
> > -		ret =3D call_vb_qop(vb, buf_init, vb);
> > +	return 0;
> > +err:
> > +	/* In case of errors, release planes that were already acquired */
> > +	__vb2_buf_dmabuf_put(vb);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * __buf_map_dmabuf() - map dmabuf for buffer planes
> > + */
> > +static int __buf_map_dmabuf(struct vb2_buffer *vb)
> > +{
> > +	int ret;
> > +	unsigned int plane;
> > +
> > +	for (plane =3D 0; plane < vb->num_planes; ++plane) {
> > +		ret =3D call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
> > =C2=A0		if (ret) {
> > -			dprintk(1, "buffer initialization failed\n");
> > -			goto err;
> > +			dprintk(1, "failed to map dmabuf for plane %d\n",
> > +				plane);
> > +			return ret;
> > =C2=A0		}
> > +		vb->planes[plane].dbuf_mapped =3D 1;
> > +	}
> > +
> > +	/*
> > +	=C2=A0* Call driver-specific initialization on the newly
> > +	=C2=A0* acquired buffer, if provided.
> > +	=C2=A0*/
> > +	ret =3D call_vb_qop(vb, buf_init, vb);
> > +	if (ret) {
> > +		dprintk(1, "buffer initialization failed\n");
> > +		return ret;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	ret =3D call_vb_qop(vb, buf_prepare, vb);
> > =C2=A0	if (ret) {
> > =C2=A0		dprintk(1, "buffer preparation failed\n");
> > =C2=A0		call_void_vb_qop(vb, buf_cleanup, vb);
> > -		goto err;
> > +		return ret;
> > =C2=A0	}
> > =C2=A0
> > =C2=A0	return 0;
> > -err:
> > -	/* In case of errors, release planes that were already acquired */
> > -	__vb2_buf_dmabuf_put(vb);
> > -
> > -	return ret;
> > =C2=A0}
> > =C2=A0
> > =C2=A0/**
> > =C2=A0 * __enqueue_in_driver() - enqueue a vb2_buffer in driver for pro=
cessing
> > =C2=A0 */
> > -static void __enqueue_in_driver(struct vb2_buffer *vb)
> > +static int __enqueue_in_driver(struct vb2_buffer *vb)
> > =C2=A0{
> > =C2=A0	struct vb2_queue *q =3D vb->vb2_queue;
> > =C2=A0	unsigned int plane;
> > +	int ret;
> > =C2=A0
> > =C2=A0	vb->state =3D VB2_BUF_STATE_ACTIVE;
> > =C2=A0	atomic_inc(&q->owned_by_drv_count);
> > =C2=A0
> > =C2=A0	trace_vb2_buf_queue(q, vb);
> > =C2=A0
> > +	if (q->memory =3D=3D VB2_MEMORY_DMABUF) {
> > +		ret =3D __buf_map_dmabuf(vb);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > =C2=A0	/* sync buffers */
> > =C2=A0	for (plane =3D 0; plane < vb->num_planes; ++plane)
> > =C2=A0		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
> > =C2=A0
> > =C2=A0	call_void_vb_qop(vb, buf_queue, vb);
> > +
> > +	return 0;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> > @@ -1438,8 +1452,11 @@ static int vb2_start_streaming(struct vb2_queue =
*q)
> > =C2=A0	=C2=A0* If any buffers were queued before streamon,
> > =C2=A0	=C2=A0* we can now pass them to driver for processing.
> > =C2=A0	=C2=A0*/
> > -	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > -		__enqueue_in_driver(vb);
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry) {
> > +		ret =3D __enqueue_in_driver(vb);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > =C2=A0
> > =C2=A0	/* Tell the driver to start streaming */
> > =C2=A0	q->start_streaming_called =3D 1;
> > @@ -1540,8 +1557,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned =
int index, void *pb)
> > =C2=A0	=C2=A0* If already streaming, give the buffer to driver for proc=
essing.
> > =C2=A0	=C2=A0* If not, the buffer will be given to driver on next strea=
mon.
> > =C2=A0	=C2=A0*/
> > -	if (q->start_streaming_called)
> > -		__enqueue_in_driver(vb);
> > +	if (q->start_streaming_called) {
> > +		ret =3D __enqueue_in_driver(vb);
> > +		if (ret)
> > +			return ret;
> > +	}
> > =C2=A0
> > =C2=A0	/* Fill buffer information for the userspace */
> > =C2=A0	if (pb)
> >=20
--=-xLXN/fxq6hkPXkBwNW0g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAleM2fAACgkQcVMCLawGqBzyTgCfeqKs+mUlo9UjBLiT1Xx8nH5f
ls4An0ZBPpSbzbHJXPqbJpND0gg+tpiH
=ksqR
-----END PGP SIGNATURE-----

--=-xLXN/fxq6hkPXkBwNW0g--

