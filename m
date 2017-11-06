Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:45073 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932576AbdKFTV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 14:21:27 -0500
Received: by mail-qt0-f174.google.com with SMTP id p1so12381095qtg.2
        for <linux-media@vger.kernel.org>; Mon, 06 Nov 2017 11:21:26 -0800 (PST)
Message-ID: <1509996082.30233.51.camel@ndufresne.ca>
Subject: Re: [PATCH v2] media: s5p-mfc: Add support for V4L2_MEMORY_DMABUF
 type
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marian Mihailescu <mihailescu2m@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        JaeChul Lee <jcsing.lee@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Date: Mon, 06 Nov 2017 14:21:22 -0500
In-Reply-To: <decd38f5-d3c0-6a60-cdbb-20bb804be3a5@samsung.com>
References: <CGME20171103081132eucas1p2212e32d26e7921340336d78d0d92cb1b@eucas1p2.samsung.com>
         <20171103081124.30119-1-m.szyprowski@samsung.com>
         <1509716721.3607.6.camel@ndufresne.ca>
         <decd38f5-d3c0-6a60-cdbb-20bb804be3a5@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-IE3Lk9Un4IyxVXaTJGop"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-IE3Lk9Un4IyxVXaTJGop
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 06 novembre 2017 =C3=A0 10:28 +0100, Marek Szyprowski a =C3=A9crit=
 :
> Hi Nicolas,
>=20
> On 2017-11-03 14:45, Nicolas Dufresne wrote:
> > Le vendredi 03 novembre 2017 =C3=A0 09:11 +0100, Marek Szyprowski a =C3=
=A9crit :
> > > MFC driver supports only MMAP operation mode mainly due to the hardwa=
re
> > > restrictions of the addresses of the DMA buffers (MFC v5 hardware can
> > > access buffers only in 128MiB memory region starting from the base ad=
dress
> > > of its firmware). When IOMMU is available, this requirement is easily
> > > fulfilled even for the buffers located anywhere in the memory - typic=
ally
> > > by mapping them in the DMA address space as close as possible to the
> > > firmware. Later hardware revisions don't have this limitations at all=
.
> > >=20
> > > The second limitation of the MFC hardware related to the memory buffe=
rs
> > > is constant buffer address. Once the hardware has been initialized fo=
r
> > > operation on given buffer set, the addresses of the buffers cannot be
> > > changed.
> > >=20
> > > With the above assumptions, a limited support for USERPTR and DMABUF
> > > operation modes can be added. The main requirement is to have all buf=
fers
> > > known when starting hardware. This has been achieved by postponing
> > > hardware initialization once all the DMABUF or USERPTR buffers have b=
een
> > > queued for the first time. Once then, buffers cannot be modified to p=
oint
> > > to other memory area.
> >=20
> > I am concerned about enabling this support with existing userspace.
> > Userspace application will be left with some driver with this
> > limitation and other drivers without. I think it is harmful to enable
> > that feature without providing userspace the ability to know.
> >=20
> > This is specially conflicting with let's say UVC driver providing
> > buffers, since UVC driver implementing CREATE_BUFS ioctl. So even if
> > userspace start making an effort to maintain the same DMABuf for the
> > same buffer index, if a new buffer is created, we won't be able to use
> > it.
>=20
> Sorry, but I don't get this as an 'issue'. The typical use scenario is to
> configure buffer queue and start streaming. Basically ReqBufs, stream on =
and
> a sequence of bufq/bufdq. This is handled without any problem by MFC driv=
er
> with this patch. After releasing a queue with reqbufs(0), one can use
> different set of buffers.

In real life, you often have capture code decorelated from the encoder
code. At least, it's the case in GStreamer. The encoder have no
information about how many buffers were pre-allocated by let's say the
capture driver. As a side effect, we cannot make sure the importation
queue is of the same size (amount of buffer). Specially if you have UVC
driver that allow allocating more buffers at run-time. This is used in
real-life to compensate additional latency that get's added when a
pipeline topology is changed (at run-time). Only workaround I had in
mind, would be to always prepare the queue with the maximum (32), and
use this as a cache size, but for now, this is not how the deployed
userspace works unfortunately.

Your reqbuf(0) technique cause a break in the stream (probably a new
keyframe), as you are forced to STREAMOFF. This is often unwanted, and
it may create a time discontinuity in case the allocation took time.

>=20
> What is the point of changing the buffers during the streaming? IMHO it w=
as
> one of the biggest pathology of the V4L2 USERPTR API that the buffers=20
> were in
> fact 'created' on the first queue operation. By creating I mean creating =
all
> the kernel all needed structures and mappings between the real memory (us=
er
> ptr value) and the buffer index. The result of this was userspace, which=
=20
> don't
> use buffer indices and always queues buffers with index =3D 0, what means=
 that
> kernel has to reacquire direct access to each buffer every single frame.=
=20
> That
> is highly inefficient approach. DMABUF operation mode inherited this=20
> drawback.

This in fact is an implementation detail of the caching in the kernel
framework. There is nothing that prevent the framework to maintain a
validation cache that isn't bound to the queue size. DMABuf simply
makes the buffer identification easier and safer. I bet it is difficult
and it will stay like this, so it should at least be documented.

I am completely aware of the inefficiency of the GStreamer behaviour,
though it remains much faster in many case then copying raw frames
using the CPU. You can complain as much as you can about what this
userspace doing, but it as has been working better then nothing for
many users. It might not be like this forever, someone could optimize
this by signalling the missing information or with the 32 buffer hack I
just mention, but I don't see anyone standing up for that work atm,
which I have assumed to be good enough (for now). We see a lot more
overhead from other component when piling up with a wayland compositor,
a GL stack and more.

>=20
> When we have a pipeline for processing video data it should use N buffers=
 on
> both input and output of each element when DMAbuf is used. Once we=20
> allocate N
> buffers, using N dmabuf-imported buffers which maps 1-1 is trivial. Only=
=20
> this
> way you will have true zero-copy processing without any additional overhe=
ad.

Though, it is not a strict requirement. This is specific to V4L2 here,
other kernel framework provide rather more flexible API, which indeed
can have small period of inefficiency (during allocation and first
importation) but will stabilize later on if userspace implements enough
caching. Also, the cost of importation will vary a lot per driver.

My point here, is just that we need to know from userspace if there is
a strict limitation like this, because otherwise it may completely fall
apart instead of being slightly inefficient.

>=20
> > > This patch also removes unconditional USERPTR operation mode from enc=
oder
> > > video node, because it doesn't work with v5 MFC hardware without IOMM=
U
> > > being enabled.
> > >=20
> > > In case of MFC v5 a bidirectional queue flag has to be enabled as a
> > > workaround of the strange hardware behavior - MFC performs a few writ=
es
> > > to source data during the operation.
> >=20
> > Do you have more information about this ? It is quite terrible, since
> > if you enable buffer importation, the buffer might be multi-plex across
> > multiple encoder instance. That is another way this feature can be
> > harmful to existing userspace.
>=20
> I also don't like this behavior of the hardware. I will probably investig=
ate
> it further once I have some time. The other workaround would be to=20
> always use
> driver allocated buffers and simply copy input stream in case of USERPTR =
or
> DMABUF to avoid modifying source data. It would mean copying the compress=
ed
> stream, what should not hurt us that much.

Thanks for letting us know. So the writes are strictly for the decoder
? I was referring to the encoder in my comment. On Qualcomm Venus side,
the writes are done in a portion expose to user space (see data_offset
in mplane structures). As a side effect, importation is skipped, since
there is no upstream driver that will magically provide this padding
data.

>=20
> > > Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> > > [mszyprow: adapted to v4.14 code base, rewrote and extended commit me=
ssage,
> > >   added checks for changing buffer addresses, added bidirectional que=
ue
> > >   flags and comments]
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > > v2:
> > > - fixed copy/paste bug, which broke encoding support (thanks to Maria=
n
> > >    Mihailescu for reporting it)
> > > - added checks for changing buffers DMA addresses
> > > - added bidirectional queue flags
> > >=20
> > > v1:
> > > - inital version
> > > ---
> > >   drivers/media/platform/s5p-mfc/s5p_mfc.c     |  23 +++++-
> > >   drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 111 ++++++++++++++++=
+++--------
> > >   drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |  64 +++++++++++----
> > >   3 files changed, 147 insertions(+), 51 deletions(-)
> > >=20
> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media=
/platform/s5p-mfc/s5p_mfc.c
> > > index 1839a86cc2a5..f1ab8d198158 100644
> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> > > @@ -754,6 +754,7 @@ static int s5p_mfc_open(struct file *file)
> > >   	struct s5p_mfc_dev *dev =3D video_drvdata(file);
> > >   	struct s5p_mfc_ctx *ctx =3D NULL;
> > >   	struct vb2_queue *q;
> > > +	unsigned int io_modes;
> > >   	int ret =3D 0;
> > >  =20
> > >   	mfc_debug_enter();
> > > @@ -839,16 +840,25 @@ static int s5p_mfc_open(struct file *file)
> > >   		if (ret)
> > >   			goto err_init_hw;
> > >   	}
> > > +
> > > +	io_modes =3D VB2_MMAP;
> > > +	if (exynos_is_iommu_available(&dev->plat_dev->dev) || !IS_TWOPORT(d=
ev))
> > > +		io_modes |=3D VB2_USERPTR | VB2_DMABUF;
> > > +
> > >   	/* Init videobuf2 queue for CAPTURE */
> > >   	q =3D &ctx->vq_dst;
> > >   	q->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > > +	q->io_modes =3D io_modes;
> > > +	/*
> > > +	 * Destination buffers are always bidirectional, they use used as
> > > +	 * reference data, which require READ access
> > > +	 */
> > > +	q->bidirectional =3D true;
> > >   	q->drv_priv =3D &ctx->fh;
> > >   	q->lock =3D &dev->mfc_mutex;
> > >   	if (vdev =3D=3D dev->vfd_dec) {
> > > -		q->io_modes =3D VB2_MMAP;
> > >   		q->ops =3D get_dec_queue_ops();
> > >   	} else if (vdev =3D=3D dev->vfd_enc) {
> > > -		q->io_modes =3D VB2_MMAP | VB2_USERPTR;
> > >   		q->ops =3D get_enc_queue_ops();
> > >   	} else {
> > >   		ret =3D -ENOENT;
> > > @@ -869,13 +879,18 @@ static int s5p_mfc_open(struct file *file)
> > >   	/* Init videobuf2 queue for OUTPUT */
> > >   	q =3D &ctx->vq_src;
> > >   	q->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > > +	q->io_modes =3D io_modes;
> > > +	/*
> > > +	 * MFV v5 performs write operations on source data, so make queue
> > > +	 * bidirectional to avoid IOMMU protection fault.
> > > +	 */
> > > +	if (!IS_MFCV6_PLUS(dev))
> > > +		q->bidirectional =3D true;
> > >   	q->drv_priv =3D &ctx->fh;
> > >   	q->lock =3D &dev->mfc_mutex;
> > >   	if (vdev =3D=3D dev->vfd_dec) {
> > > -		q->io_modes =3D VB2_MMAP;
> > >   		q->ops =3D get_dec_queue_ops();
> > >   	} else if (vdev =3D=3D dev->vfd_enc) {
> > > -		q->io_modes =3D VB2_MMAP | VB2_USERPTR;
> > >   		q->ops =3D get_enc_queue_ops();
> > >   	} else {
> > >   		ret =3D -ENOENT;
> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/m=
edia/platform/s5p-mfc/s5p_mfc_dec.c
> > > index e3e5c442902a..26ee8315e2cf 100644
> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> > > @@ -551,14 +551,27 @@ static int reqbufs_capture(struct s5p_mfc_dev *=
dev, struct s5p_mfc_ctx *ctx,
> > >   			goto out;
> > >   		}
> > >  =20
> > > -		WARN_ON(ctx->dst_bufs_cnt !=3D ctx->total_dpb_count);
> > > -		ctx->capture_state =3D QUEUE_BUFS_MMAPED;
> > > +		if (reqbufs->memory =3D=3D V4L2_MEMORY_MMAP) {
> > > +			if (ctx->dst_bufs_cnt =3D=3D ctx->total_dpb_count) {
> > > +				ctx->capture_state =3D QUEUE_BUFS_MMAPED;
> > > +			} else {
> > > +				mfc_err("Not all buffers passed to buf_init\n");
> > > +				reqbufs->count =3D 0;
> > > +				ret =3D vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > > +				s5p_mfc_hw_call(dev->mfc_ops,
> > > +						release_codec_buffers, ctx);
> > > +				ret =3D -ENOMEM;
> > > +				goto out;
> > > +			}
> > > +		}
> > >  =20
> > >   		if (s5p_mfc_ctx_ready(ctx))
> > >   			set_work_bit_irqsave(ctx);
> > >   		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> > > -		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
> > > -					  0);
> > > +		if (reqbufs->memory =3D=3D V4L2_MEMORY_MMAP) {
> > > +			s5p_mfc_wait_for_done_ctx(ctx,
> > > +					 S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
> > > +		}
> > >   	} else {
> > >   		mfc_err("Buffers have already been requested\n");
> > >   		ret =3D -EINVAL;
> > > @@ -576,15 +589,19 @@ static int vidioc_reqbufs(struct file *file, vo=
id *priv,
> > >   {
> > >   	struct s5p_mfc_dev *dev =3D video_drvdata(file);
> > >   	struct s5p_mfc_ctx *ctx =3D fh_to_ctx(priv);
> > > -
> > > -	if (reqbufs->memory !=3D V4L2_MEMORY_MMAP) {
> > > -		mfc_debug(2, "Only V4L2_MEMORY_MMAP is supported\n");
> > > -		return -EINVAL;
> > > -	}
> > > +	int ret;
> > >  =20
> > >   	if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
> > > +					     reqbufs->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		return reqbufs_output(dev, ctx, reqbufs);
> > >   	} else if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE=
) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
> > > +					     reqbufs->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		return reqbufs_capture(dev, ctx, reqbufs);
> > >   	} else {
> > >   		mfc_err("Invalid type requested\n");
> > > @@ -600,16 +617,20 @@ static int vidioc_querybuf(struct file *file, v=
oid *priv,
> > >   	int ret;
> > >   	int i;
> > >  =20
> > > -	if (buf->memory !=3D V4L2_MEMORY_MMAP) {
> > > -		mfc_err("Only mmaped buffers can be used\n");
> > > -		return -EINVAL;
> > > -	}
> > >   	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
> > >   	if (ctx->state =3D=3D MFCINST_GOT_INST &&
> > >   			buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_src, buf->memory,
> > > +					     buf->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		ret =3D vb2_querybuf(&ctx->vq_src, buf);
> > >   	} else if (ctx->state =3D=3D MFCINST_RUNNING &&
> > >   			buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
> > > +					     buf->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		ret =3D vb2_querybuf(&ctx->vq_dst, buf);
> > >   		for (i =3D 0; i < buf->length; i++)
> > >   			buf->m.planes[i].m.mem_offset +=3D DST_QUEUE_OFF_BASE;
> > > @@ -940,10 +961,12 @@ static int s5p_mfc_queue_setup(struct vb2_queue=
 *vq,
> > >   		else
> > >   			alloc_devs[0] =3D ctx->dev->mem_dev[BANK_R_CTX];
> > >   		alloc_devs[1] =3D ctx->dev->mem_dev[BANK_L_CTX];
> > > +		memset(ctx->dst_bufs, 0, sizeof(ctx->dst_bufs));
> > >   	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> > >   		   ctx->state =3D=3D MFCINST_INIT) {
> > >   		psize[0] =3D ctx->dec_src_buf_size;
> > >   		alloc_devs[0] =3D ctx->dev->mem_dev[BANK_L_CTX];
> > > +		memset(ctx->src_bufs, 0, sizeof(ctx->src_bufs));
> > >   	} else {
> > >   		mfc_err("This video node is dedicated to decoding. Decoding not i=
nitialized\n");
> > >   		return -EINVAL;
> > > @@ -959,30 +982,35 @@ static int s5p_mfc_buf_init(struct vb2_buffer *=
vb)
> > >   	unsigned int i;
> > >  =20
> > >   	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > > +		dma_addr_t luma, chroma;
> > > +
> > >   		if (ctx->capture_state =3D=3D QUEUE_BUFS_MMAPED)
> > >   			return 0;
> > > -		for (i =3D 0; i < ctx->dst_fmt->num_planes; i++) {
> > > -			if (IS_ERR_OR_NULL(ERR_PTR(
> > > -					vb2_dma_contig_plane_dma_addr(vb, i)))) {
> > > -				mfc_err("Plane mem not allocated\n");
> > > -				return -EINVAL;
> > > -			}
> > > -		}
> > > -		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
> > > -			vb2_plane_size(vb, 1) < ctx->chroma_size) {
> > > -			mfc_err("Plane buffer (CAPTURE) is too small\n");
> > > +
> > > +		luma =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> > > +		chroma =3D vb2_dma_contig_plane_dma_addr(vb, 1);
> > > +		if (!luma || !chroma) {
> > > +			mfc_err("Plane mem not allocated\n");
> > >   			return -EINVAL;
> > >   		}
> > > +
> > >   		i =3D vb->index;
> > > +		if ((ctx->dst_bufs[i].cookie.raw.luma &&
> > > +		     ctx->dst_bufs[i].cookie.raw.luma !=3D luma) ||
> > > +		    (ctx->dst_bufs[i].cookie.raw.chroma &&
> > > +		     ctx->dst_bufs[i].cookie.raw.chroma !=3D chroma)) {
> > > +			mfc_err("Changing CAPTURE buffer address during straming is not p=
ossible\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > >   		ctx->dst_bufs[i].b =3D vbuf;
> > > -		ctx->dst_bufs[i].cookie.raw.luma =3D
> > > -					vb2_dma_contig_plane_dma_addr(vb, 0);
> > > -		ctx->dst_bufs[i].cookie.raw.chroma =3D
> > > -					vb2_dma_contig_plane_dma_addr(vb, 1);
> > > +		ctx->dst_bufs[i].cookie.raw.luma =3D luma;
> > > +		ctx->dst_bufs[i].cookie.raw.chroma =3D chroma;
> > >   		ctx->dst_bufs_cnt++;
> > >   	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > > -		if (IS_ERR_OR_NULL(ERR_PTR(
> > > -					vb2_dma_contig_plane_dma_addr(vb, 0)))) {
> > > +		dma_addr_t stream =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> > > +
> > > +		if (!stream) {
> > >   			mfc_err("Plane memory not allocated\n");
> > >   			return -EINVAL;
> > >   		}
> > > @@ -992,9 +1020,14 @@ static int s5p_mfc_buf_init(struct vb2_buffer *=
vb)
> > >   		}
> > >  =20
> > >   		i =3D vb->index;
> > > +		if (ctx->src_bufs[i].cookie.stream &&
> > > +		     ctx->src_bufs[i].cookie.stream !=3D stream) {
> > > +			mfc_err("Changing OUTPUT buffer address during straming is not po=
ssible\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > >   		ctx->src_bufs[i].b =3D vbuf;
> > > -		ctx->src_bufs[i].cookie.stream =3D
> > > -					vb2_dma_contig_plane_dma_addr(vb, 0);
> > > +		ctx->src_bufs[i].cookie.stream =3D stream;
> > >   		ctx->src_bufs_cnt++;
> > >   	} else {
> > >   		mfc_err("s5p_mfc_buf_init: unknown queue type\n");
> > > @@ -1071,6 +1104,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer=
 *vb)
> > >   	struct s5p_mfc_dev *dev =3D ctx->dev;
> > >   	unsigned long flags;
> > >   	struct s5p_mfc_buf *mfc_buf;
> > > +	int wait_flag =3D 0;
> > >  =20
> > >   	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > >   		mfc_buf =3D &ctx->src_bufs[vb->index];
> > > @@ -1088,12 +1122,25 @@ static void s5p_mfc_buf_queue(struct vb2_buff=
er *vb)
> > >   		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
> > >   		ctx->dst_queue_cnt++;
> > >   		spin_unlock_irqrestore(&dev->irqlock, flags);
> > > +		if ((vq->memory =3D=3D V4L2_MEMORY_USERPTR ||
> > > +			vq->memory =3D=3D V4L2_MEMORY_DMABUF) &&
> > > +			ctx->dst_queue_cnt =3D=3D ctx->total_dpb_count)
> > > +			ctx->capture_state =3D QUEUE_BUFS_MMAPED;
> > >   	} else {
> > >   		mfc_err("Unsupported buffer type (%d)\n", vq->type);
> > >   	}
> > > -	if (s5p_mfc_ctx_ready(ctx))
> > > +	if (s5p_mfc_ctx_ready(ctx)) {
> > >   		set_work_bit_irqsave(ctx);
> > > +		if ((vq->memory =3D=3D V4L2_MEMORY_USERPTR ||
> > > +			vq->memory =3D=3D V4L2_MEMORY_DMABUF) &&
> > > +			ctx->state =3D=3D MFCINST_HEAD_PARSED &&
> > > +			ctx->capture_state =3D=3D QUEUE_BUFS_MMAPED)
> > > +			wait_flag =3D 1;
> > > +	}
> > >   	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> > > +	if (wait_flag)
> > > +		s5p_mfc_wait_for_done_ctx(ctx,
> > > +				S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
> > >   }
> > >  =20
> > >   static struct vb2_ops s5p_mfc_dec_qops =3D {
> > > diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/m=
edia/platform/s5p-mfc/s5p_mfc_enc.c
> > > index 7b041e5ee4be..33fc3f3ef48a 100644
> > > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> > > @@ -1125,11 +1125,11 @@ static int vidioc_reqbufs(struct file *file, =
void *priv,
> > >   	struct s5p_mfc_ctx *ctx =3D fh_to_ctx(priv);
> > >   	int ret =3D 0;
> > >  =20
> > > -	/* if memory is not mmp or userptr return error */
> > > -	if ((reqbufs->memory !=3D V4L2_MEMORY_MMAP) &&
> > > -		(reqbufs->memory !=3D V4L2_MEMORY_USERPTR))
> > > -		return -EINVAL;
> > >   	if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
> > > +					     reqbufs->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		if (reqbufs->count =3D=3D 0) {
> > >   			mfc_debug(2, "Freeing buffers\n");
> > >   			ret =3D vb2_reqbufs(&ctx->vq_dst, reqbufs);
> > > @@ -1159,6 +1159,10 @@ static int vidioc_reqbufs(struct file *file, v=
oid *priv,
> > >   			return -ENOMEM;
> > >   		}
> > >   	} else if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)=
 {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
> > > +					     reqbufs->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		if (reqbufs->count =3D=3D 0) {
> > >   			mfc_debug(2, "Freeing buffers\n");
> > >   			ret =3D vb2_reqbufs(&ctx->vq_src, reqbufs);
> > > @@ -1190,6 +1194,8 @@ static int vidioc_reqbufs(struct file *file, vo=
id *priv,
> > >   			mfc_err("error in vb2_reqbufs() for E(S)\n");
> > >   			return ret;
> > >   		}
> > > +		if (reqbufs->memory !=3D V4L2_MEMORY_MMAP)
> > > +			ctx->src_bufs_cnt =3D reqbufs->count;
> > >   		ctx->output_state =3D QUEUE_BUFS_REQUESTED;
> > >   	} else {
> > >   		mfc_err("invalid buf type\n");
> > > @@ -1204,11 +1210,11 @@ static int vidioc_querybuf(struct file *file,=
 void *priv,
> > >   	struct s5p_mfc_ctx *ctx =3D fh_to_ctx(priv);
> > >   	int ret =3D 0;
> > >  =20
> > > -	/* if memory is not mmp or userptr return error */
> > > -	if ((buf->memory !=3D V4L2_MEMORY_MMAP) &&
> > > -		(buf->memory !=3D V4L2_MEMORY_USERPTR))
> > > -		return -EINVAL;
> > >   	if (buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
> > > +					     buf->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		if (ctx->state !=3D MFCINST_GOT_INST) {
> > >   			mfc_err("invalid context state: %d\n", ctx->state);
> > >   			return -EINVAL;
> > > @@ -1220,6 +1226,10 @@ static int vidioc_querybuf(struct file *file, =
void *priv,
> > >   		}
> > >   		buf->m.planes[0].m.mem_offset +=3D DST_QUEUE_OFF_BASE;
> > >   	} else if (buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > > +		ret =3D vb2_verify_memory_type(&ctx->vq_src, buf->memory,
> > > +					     buf->type);
> > > +		if (ret)
> > > +			return ret;
> > >   		ret =3D vb2_querybuf(&ctx->vq_src, buf);
> > >   		if (ret !=3D 0) {
> > >   			mfc_err("error in vb2_querybuf() for E(S)\n");
> > > @@ -1828,6 +1838,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue=
 *vq,
> > >   			*buf_count =3D MFC_MAX_BUFFERS;
> > >   		psize[0] =3D ctx->enc_dst_buf_size;
> > >   		alloc_devs[0] =3D ctx->dev->mem_dev[BANK_L_CTX];
> > > +		memset(ctx->dst_bufs, 0, sizeof(ctx->dst_bufs));
> > >   	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > >   		if (ctx->src_fmt)
> > >   			*plane_count =3D ctx->src_fmt->num_planes;
> > > @@ -1849,6 +1860,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue=
 *vq,
> > >   			alloc_devs[0] =3D ctx->dev->mem_dev[BANK_R_CTX];
> > >   			alloc_devs[1] =3D ctx->dev->mem_dev[BANK_R_CTX];
> > >   		}
> > > +		memset(ctx->src_bufs, 0, sizeof(ctx->src_bufs));
> > >   	} else {
> > >   		mfc_err("invalid queue type: %d\n", vq->type);
> > >   		return -EINVAL;
> > > @@ -1865,25 +1877,47 @@ static int s5p_mfc_buf_init(struct vb2_buffer=
 *vb)
> > >   	int ret;
> > >  =20
> > >   	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> > > +		dma_addr_t stream;
> > > +
> > >   		ret =3D check_vb_with_fmt(ctx->dst_fmt, vb);
> > >   		if (ret < 0)
> > >   			return ret;
> > > +
> > > +		stream =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> > >   		i =3D vb->index;
> > > +		if (ctx->dst_bufs[i].cookie.stream &&
> > > +		    ctx->src_bufs[i].cookie.stream !=3D stream) {
> > > +			mfc_err("Changing CAPTURE buffer address during straming is not p=
ossible\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > >   		ctx->dst_bufs[i].b =3D vbuf;
> > > -		ctx->dst_bufs[i].cookie.stream =3D
> > > -					vb2_dma_contig_plane_dma_addr(vb, 0);
> > > +		ctx->dst_bufs[i].cookie.stream =3D stream;
> > >   		ctx->dst_bufs_cnt++;
> > >   	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> > > +		dma_addr_t luma, chroma;
> > > +
> > >   		ret =3D check_vb_with_fmt(ctx->src_fmt, vb);
> > >   		if (ret < 0)
> > >   			return ret;
> > > +
> > > +		luma =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> > > +		chroma =3D vb2_dma_contig_plane_dma_addr(vb, 1);
> > > +
> > >   		i =3D vb->index;
> > > +		if ((ctx->src_bufs[i].cookie.raw.luma &&
> > > +		     ctx->src_bufs[i].cookie.raw.luma !=3D luma) ||
> > > +		    (ctx->src_bufs[i].cookie.raw.chroma &&
> > > +		     ctx->src_bufs[i].cookie.raw.chroma !=3D chroma)) {
> > > +			mfc_err("Changing OUTPUT buffer address during straming is not po=
ssible\n");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > >   		ctx->src_bufs[i].b =3D vbuf;
> > > -		ctx->src_bufs[i].cookie.raw.luma =3D
> > > -					vb2_dma_contig_plane_dma_addr(vb, 0);
> > > -		ctx->src_bufs[i].cookie.raw.chroma =3D
> > > -					vb2_dma_contig_plane_dma_addr(vb, 1);
> > > -		ctx->src_bufs_cnt++;
> > > +		ctx->src_bufs[i].cookie.raw.luma =3D luma;
> > > +		ctx->src_bufs[i].cookie.raw.chroma =3D chroma;
> > > +		if (vb->memory =3D=3D V4L2_MEMORY_MMAP)
> > > +			ctx->src_bufs_cnt++;
> > >   	} else {
> > >   		mfc_err("invalid queue type: %d\n", vq->type);
> > >   		return -EINVAL;
>=20
> Best regards
--=-IE3Lk9Un4IyxVXaTJGop
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWgC2MgAKCRBxUwItrAao
HKMEAKDP3oQ/EQGcmegf8vlS3tuj6nROEwCbBErYePXgp3EVxMBE1BEMBaIHn9Q=
=ipwD
-----END PGP SIGNATURE-----

--=-IE3Lk9Un4IyxVXaTJGop--
