Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56220 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934541AbcIFS1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 14:27:37 -0400
Message-ID: <1473186448.2668.6.camel@ndufresne.ca>
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
Date: Tue, 06 Sep 2016 14:27:28 -0400
In-Reply-To: <ee857812-cf05-b714-eb6e-b696767a0067@xs4all.nl>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
         <ee857812-cf05-b714-eb6e-b696767a0067@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-ti6WaohGrCTgiWOLCdhz"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ti6WaohGrCTgiWOLCdhz
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

The reflection (yes it's just a reflection) is that userspace won't
have to wait for the map before it can go back on retrieving and
submitting the next buffer. I think this could help userspace ability
to fill in the queue on time, without having to introduce threads to
protect against long kernel operations. Basically, it may improve
parallelism between userspace and kernel.

>=20
> You don't describe here WHY this change is needed.
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
> > A side effect of this change is that if the dmabuf map fails for
> > some
> > reasons (i.e: a driver using the DMA contig memory allocator but
> > CMA
> > not being enabled), the fail will no longer happen on VIDIOC_QBUF
> > but
> > later (i.e: in VIDIOC_STREAMON).
> >=20
> > I don't know if that's an issue though but I think is worth
> > mentioning.
> >=20
> > Best regards,
> > Javier
> >=20
> > =C2=A0drivers/media/v4l2-core/videobuf2-core.c | 88
> > ++++++++++++++++++++------------
> > =C2=A01 file changed, 54 insertions(+), 34 deletions(-)
> >=20
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c
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
> > =C2=A0 * __vb2_buf_mem_alloc() - allocate video memory for the given
> > buffer
> > @@ -1271,20 +1271,6 @@ static int __qbuf_dmabuf(struct vb2_buffer
> > *vb, const void *pb)
> > =C2=A0		vb->planes[plane].mem_priv =3D mem_priv;
> > =C2=A0	}
> > =C2=A0
> > -	/* TODO: This pins the buffer(s)
> > with=C2=A0=C2=A0dma_buf_map_attachment()).. but
> > -	=C2=A0* really we want to do this just before the DMA, not
> > while queueing
> > -	=C2=A0* the buffer(s)..
> > -	=C2=A0*/
> > -	for (plane =3D 0; plane < vb->num_planes; ++plane) {
> > -		ret =3D call_memop(vb, map_dmabuf, vb-
> > >planes[plane].mem_priv);
> > -		if (ret) {
> > -			dprintk(1, "failed to map dmabuf for plane
> > %d\n",
> > -				plane);
> > -			goto err;
> > -		}
> > -		vb->planes[plane].dbuf_mapped =3D 1;
> > -	}
> > -
> > =C2=A0	/*
> > =C2=A0	=C2=A0* Now that everything is in order, copy relevant
> > information
> > =C2=A0	=C2=A0* provided by userspace.
> > @@ -1296,51 +1282,79 @@ static int __qbuf_dmabuf(struct vb2_buffer
> > *vb, const void *pb)
> > =C2=A0		vb->planes[plane].data_offset =3D
> > planes[plane].data_offset;
> > =C2=A0	}
> > =C2=A0
> > -	if (reacquired) {
> > -		/*
> > -		=C2=A0* Call driver-specific initialization on the
> > newly acquired buffer,
> > -		=C2=A0* if provided.
> > -		=C2=A0*/
> > -		ret =3D call_vb_qop(vb, buf_init, vb);
> > +	return 0;
> > +err:
> > +	/* In case of errors, release planes that were already
> > acquired */
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
> > +		ret =3D call_memop(vb, map_dmabuf, vb-
> > >planes[plane].mem_priv);
> > =C2=A0		if (ret) {
> > -			dprintk(1, "buffer initialization
> > failed\n");
> > -			goto err;
> > +			dprintk(1, "failed to map dmabuf for plane
> > %d\n",
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
> > -	/* In case of errors, release planes that were already
> > acquired */
> > -	__vb2_buf_dmabuf_put(vb);
> > -
> > -	return ret;
> > =C2=A0}
> > =C2=A0
> > =C2=A0/**
> > =C2=A0 * __enqueue_in_driver() - enqueue a vb2_buffer in driver for
> > processing
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
> > =C2=A0		call_void_memop(vb, prepare, vb-
> > >planes[plane].mem_priv);
> > =C2=A0
> > =C2=A0	call_void_vb_qop(vb, buf_queue, vb);
> > +
> > +	return 0;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> > @@ -1438,8 +1452,11 @@ static int vb2_start_streaming(struct
> > vb2_queue *q)
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
> > @@ -1540,8 +1557,11 @@ int vb2_core_qbuf(struct vb2_queue *q,
> > unsigned int index, void *pb)
> > =C2=A0	=C2=A0* If already streaming, give the buffer to driver for
> > processing.
> > =C2=A0	=C2=A0* If not, the buffer will be given to driver on next
> > streamon.
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-info.h=
tml
--=-ti6WaohGrCTgiWOLCdhz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlfPCpIACgkQcVMCLawGqBwbUQCgwbKWUdn0ZrbJr4rRD0PbR+yx
8ZMAoNwWkphHjIg2FrkQVZHVLkKyaan/
=hA1t
-----END PGP SIGNATURE-----

--=-ti6WaohGrCTgiWOLCdhz--

