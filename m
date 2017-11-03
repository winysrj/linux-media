Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:52831 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755859AbdKCNpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 09:45:25 -0400
Received: by mail-qk0-f195.google.com with SMTP id b15so3225278qkg.9
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 06:45:25 -0700 (PDT)
Message-ID: <1509716721.3607.6.camel@ndufresne.ca>
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
Date: Fri, 03 Nov 2017 09:45:21 -0400
In-Reply-To: <20171103081124.30119-1-m.szyprowski@samsung.com>
References: <CGME20171103081132eucas1p2212e32d26e7921340336d78d0d92cb1b@eucas1p2.samsung.com>
         <20171103081124.30119-1-m.szyprowski@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-z2naqodeNr1aEMPgJNEf"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-z2naqodeNr1aEMPgJNEf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 03 novembre 2017 =C3=A0 09:11 +0100, Marek Szyprowski a =C3=A9c=
rit :
> MFC driver supports only MMAP operation mode mainly due to the hardware
> restrictions of the addresses of the DMA buffers (MFC v5 hardware can
> access buffers only in 128MiB memory region starting from the base addres=
s
> of its firmware). When IOMMU is available, this requirement is easily
> fulfilled even for the buffers located anywhere in the memory - typically
> by mapping them in the DMA address space as close as possible to the
> firmware. Later hardware revisions don't have this limitations at all.
>=20
> The second limitation of the MFC hardware related to the memory buffers
> is constant buffer address. Once the hardware has been initialized for
> operation on given buffer set, the addresses of the buffers cannot be
> changed.
>=20
> With the above assumptions, a limited support for USERPTR and DMABUF
> operation modes can be added. The main requirement is to have all buffers
> known when starting hardware. This has been achieved by postponing
> hardware initialization once all the DMABUF or USERPTR buffers have been
> queued for the first time. Once then, buffers cannot be modified to point
> to other memory area.

I am concerned about enabling this support with existing userspace.
Userspace application will be left with some driver with this
limitation and other drivers without. I think it is harmful to enable
that feature without providing userspace the ability to know.

This is specially conflicting with let's say UVC driver providing
buffers, since UVC driver implementing CREATE_BUFS ioctl. So even if
userspace start making an effort to maintain the same DMABuf for the
same buffer index, if a new buffer is created, we won't be able to use
it.

>=20
> This patch also removes unconditional USERPTR operation mode from encoder
> video node, because it doesn't work with v5 MFC hardware without IOMMU
> being enabled.
>=20
> In case of MFC v5 a bidirectional queue flag has to be enabled as a
> workaround of the strange hardware behavior - MFC performs a few writes
> to source data during the operation.

Do you have more information about this ? It is quite terrible, since
if you enable buffer importation, the buffer might be multi-plex across
multiple encoder instance. That is another way this feature can be
harmful to existing userspace.

>=20
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> [mszyprow: adapted to v4.14 code base, rewrote and extended commit messag=
e,
>  added checks for changing buffer addresses, added bidirectional queue
>  flags and comments]
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> v2:
> - fixed copy/paste bug, which broke encoding support (thanks to Marian
>   Mihailescu for reporting it)
> - added checks for changing buffers DMA addresses
> - added bidirectional queue flags
>=20
> v1:
> - inital version
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c     |  23 +++++-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 111 +++++++++++++++++++--=
------
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |  64 +++++++++++----
>  3 files changed, 147 insertions(+), 51 deletions(-)
>=20
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/pla=
tform/s5p-mfc/s5p_mfc.c
> index 1839a86cc2a5..f1ab8d198158 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -754,6 +754,7 @@ static int s5p_mfc_open(struct file *file)
>  	struct s5p_mfc_dev *dev =3D video_drvdata(file);
>  	struct s5p_mfc_ctx *ctx =3D NULL;
>  	struct vb2_queue *q;
> +	unsigned int io_modes;
>  	int ret =3D 0;
> =20
>  	mfc_debug_enter();
> @@ -839,16 +840,25 @@ static int s5p_mfc_open(struct file *file)
>  		if (ret)
>  			goto err_init_hw;
>  	}
> +
> +	io_modes =3D VB2_MMAP;
> +	if (exynos_is_iommu_available(&dev->plat_dev->dev) || !IS_TWOPORT(dev))
> +		io_modes |=3D VB2_USERPTR | VB2_DMABUF;
> +
>  	/* Init videobuf2 queue for CAPTURE */
>  	q =3D &ctx->vq_dst;
>  	q->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	q->io_modes =3D io_modes;
> +	/*
> +	 * Destination buffers are always bidirectional, they use used as
> +	 * reference data, which require READ access
> +	 */
> +	q->bidirectional =3D true;
>  	q->drv_priv =3D &ctx->fh;
>  	q->lock =3D &dev->mfc_mutex;
>  	if (vdev =3D=3D dev->vfd_dec) {
> -		q->io_modes =3D VB2_MMAP;
>  		q->ops =3D get_dec_queue_ops();
>  	} else if (vdev =3D=3D dev->vfd_enc) {
> -		q->io_modes =3D VB2_MMAP | VB2_USERPTR;
>  		q->ops =3D get_enc_queue_ops();
>  	} else {
>  		ret =3D -ENOENT;
> @@ -869,13 +879,18 @@ static int s5p_mfc_open(struct file *file)
>  	/* Init videobuf2 queue for OUTPUT */
>  	q =3D &ctx->vq_src;
>  	q->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	q->io_modes =3D io_modes;
> +	/*
> +	 * MFV v5 performs write operations on source data, so make queue
> +	 * bidirectional to avoid IOMMU protection fault.
> +	 */
> +	if (!IS_MFCV6_PLUS(dev))
> +		q->bidirectional =3D true;
>  	q->drv_priv =3D &ctx->fh;
>  	q->lock =3D &dev->mfc_mutex;
>  	if (vdev =3D=3D dev->vfd_dec) {
> -		q->io_modes =3D VB2_MMAP;
>  		q->ops =3D get_dec_queue_ops();
>  	} else if (vdev =3D=3D dev->vfd_enc) {
> -		q->io_modes =3D VB2_MMAP | VB2_USERPTR;
>  		q->ops =3D get_enc_queue_ops();
>  	} else {
>  		ret =3D -ENOENT;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media=
/platform/s5p-mfc/s5p_mfc_dec.c
> index e3e5c442902a..26ee8315e2cf 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -551,14 +551,27 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev,=
 struct s5p_mfc_ctx *ctx,
>  			goto out;
>  		}
> =20
> -		WARN_ON(ctx->dst_bufs_cnt !=3D ctx->total_dpb_count);
> -		ctx->capture_state =3D QUEUE_BUFS_MMAPED;
> +		if (reqbufs->memory =3D=3D V4L2_MEMORY_MMAP) {
> +			if (ctx->dst_bufs_cnt =3D=3D ctx->total_dpb_count) {
> +				ctx->capture_state =3D QUEUE_BUFS_MMAPED;
> +			} else {
> +				mfc_err("Not all buffers passed to buf_init\n");
> +				reqbufs->count =3D 0;
> +				ret =3D vb2_reqbufs(&ctx->vq_dst, reqbufs);
> +				s5p_mfc_hw_call(dev->mfc_ops,
> +						release_codec_buffers, ctx);
> +				ret =3D -ENOMEM;
> +				goto out;
> +			}
> +		}
> =20
>  		if (s5p_mfc_ctx_ready(ctx))
>  			set_work_bit_irqsave(ctx);
>  		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> -		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_INIT_BUFFERS_RET,
> -					  0);
> +		if (reqbufs->memory =3D=3D V4L2_MEMORY_MMAP) {
> +			s5p_mfc_wait_for_done_ctx(ctx,
> +					 S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
> +		}
>  	} else {
>  		mfc_err("Buffers have already been requested\n");
>  		ret =3D -EINVAL;
> @@ -576,15 +589,19 @@ static int vidioc_reqbufs(struct file *file, void *=
priv,
>  {
>  	struct s5p_mfc_dev *dev =3D video_drvdata(file);
>  	struct s5p_mfc_ctx *ctx =3D fh_to_ctx(priv);
> -
> -	if (reqbufs->memory !=3D V4L2_MEMORY_MMAP) {
> -		mfc_debug(2, "Only V4L2_MEMORY_MMAP is supported\n");
> -		return -EINVAL;
> -	}
> +	int ret;
> =20
>  	if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
> +					     reqbufs->type);
> +		if (ret)
> +			return ret;
>  		return reqbufs_output(dev, ctx, reqbufs);
>  	} else if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
> +					     reqbufs->type);
> +		if (ret)
> +			return ret;
>  		return reqbufs_capture(dev, ctx, reqbufs);
>  	} else {
>  		mfc_err("Invalid type requested\n");
> @@ -600,16 +617,20 @@ static int vidioc_querybuf(struct file *file, void =
*priv,
>  	int ret;
>  	int i;
> =20
> -	if (buf->memory !=3D V4L2_MEMORY_MMAP) {
> -		mfc_err("Only mmaped buffers can be used\n");
> -		return -EINVAL;
> -	}
>  	mfc_debug(2, "State: %d, buf->type: %d\n", ctx->state, buf->type);
>  	if (ctx->state =3D=3D MFCINST_GOT_INST &&
>  			buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_src, buf->memory,
> +					     buf->type);
> +		if (ret)
> +			return ret;
>  		ret =3D vb2_querybuf(&ctx->vq_src, buf);
>  	} else if (ctx->state =3D=3D MFCINST_RUNNING &&
>  			buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
> +					     buf->type);
> +		if (ret)
> +			return ret;
>  		ret =3D vb2_querybuf(&ctx->vq_dst, buf);
>  		for (i =3D 0; i < buf->length; i++)
>  			buf->m.planes[i].m.mem_offset +=3D DST_QUEUE_OFF_BASE;
> @@ -940,10 +961,12 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq=
,
>  		else
>  			alloc_devs[0] =3D ctx->dev->mem_dev[BANK_R_CTX];
>  		alloc_devs[1] =3D ctx->dev->mem_dev[BANK_L_CTX];
> +		memset(ctx->dst_bufs, 0, sizeof(ctx->dst_bufs));
>  	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
>  		   ctx->state =3D=3D MFCINST_INIT) {
>  		psize[0] =3D ctx->dec_src_buf_size;
>  		alloc_devs[0] =3D ctx->dev->mem_dev[BANK_L_CTX];
> +		memset(ctx->src_bufs, 0, sizeof(ctx->src_bufs));
>  	} else {
>  		mfc_err("This video node is dedicated to decoding. Decoding not initia=
lized\n");
>  		return -EINVAL;
> @@ -959,30 +982,35 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  	unsigned int i;
> =20
>  	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		dma_addr_t luma, chroma;
> +
>  		if (ctx->capture_state =3D=3D QUEUE_BUFS_MMAPED)
>  			return 0;
> -		for (i =3D 0; i < ctx->dst_fmt->num_planes; i++) {
> -			if (IS_ERR_OR_NULL(ERR_PTR(
> -					vb2_dma_contig_plane_dma_addr(vb, i)))) {
> -				mfc_err("Plane mem not allocated\n");
> -				return -EINVAL;
> -			}
> -		}
> -		if (vb2_plane_size(vb, 0) < ctx->luma_size ||
> -			vb2_plane_size(vb, 1) < ctx->chroma_size) {
> -			mfc_err("Plane buffer (CAPTURE) is too small\n");
> +
> +		luma =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> +		chroma =3D vb2_dma_contig_plane_dma_addr(vb, 1);
> +		if (!luma || !chroma) {
> +			mfc_err("Plane mem not allocated\n");
>  			return -EINVAL;
>  		}
> +
>  		i =3D vb->index;
> +		if ((ctx->dst_bufs[i].cookie.raw.luma &&
> +		     ctx->dst_bufs[i].cookie.raw.luma !=3D luma) ||
> +		    (ctx->dst_bufs[i].cookie.raw.chroma &&
> +		     ctx->dst_bufs[i].cookie.raw.chroma !=3D chroma)) {
> +			mfc_err("Changing CAPTURE buffer address during straming is not possi=
ble\n");
> +			return -EINVAL;
> +		}
> +
>  		ctx->dst_bufs[i].b =3D vbuf;
> -		ctx->dst_bufs[i].cookie.raw.luma =3D
> -					vb2_dma_contig_plane_dma_addr(vb, 0);
> -		ctx->dst_bufs[i].cookie.raw.chroma =3D
> -					vb2_dma_contig_plane_dma_addr(vb, 1);
> +		ctx->dst_bufs[i].cookie.raw.luma =3D luma;
> +		ctx->dst_bufs[i].cookie.raw.chroma =3D chroma;
>  		ctx->dst_bufs_cnt++;
>  	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> -		if (IS_ERR_OR_NULL(ERR_PTR(
> -					vb2_dma_contig_plane_dma_addr(vb, 0)))) {
> +		dma_addr_t stream =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +		if (!stream) {
>  			mfc_err("Plane memory not allocated\n");
>  			return -EINVAL;
>  		}
> @@ -992,9 +1020,14 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb)
>  		}
> =20
>  		i =3D vb->index;
> +		if (ctx->src_bufs[i].cookie.stream &&
> +		     ctx->src_bufs[i].cookie.stream !=3D stream) {
> +			mfc_err("Changing OUTPUT buffer address during straming is not possib=
le\n");
> +			return -EINVAL;
> +		}
> +
>  		ctx->src_bufs[i].b =3D vbuf;
> -		ctx->src_bufs[i].cookie.stream =3D
> -					vb2_dma_contig_plane_dma_addr(vb, 0);
> +		ctx->src_bufs[i].cookie.stream =3D stream;
>  		ctx->src_bufs_cnt++;
>  	} else {
>  		mfc_err("s5p_mfc_buf_init: unknown queue type\n");
> @@ -1071,6 +1104,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb=
)
>  	struct s5p_mfc_dev *dev =3D ctx->dev;
>  	unsigned long flags;
>  	struct s5p_mfc_buf *mfc_buf;
> +	int wait_flag =3D 0;
> =20
>  	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		mfc_buf =3D &ctx->src_bufs[vb->index];
> @@ -1088,12 +1122,25 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *=
vb)
>  		list_add_tail(&mfc_buf->list, &ctx->dst_queue);
>  		ctx->dst_queue_cnt++;
>  		spin_unlock_irqrestore(&dev->irqlock, flags);
> +		if ((vq->memory =3D=3D V4L2_MEMORY_USERPTR ||
> +			vq->memory =3D=3D V4L2_MEMORY_DMABUF) &&
> +			ctx->dst_queue_cnt =3D=3D ctx->total_dpb_count)
> +			ctx->capture_state =3D QUEUE_BUFS_MMAPED;
>  	} else {
>  		mfc_err("Unsupported buffer type (%d)\n", vq->type);
>  	}
> -	if (s5p_mfc_ctx_ready(ctx))
> +	if (s5p_mfc_ctx_ready(ctx)) {
>  		set_work_bit_irqsave(ctx);
> +		if ((vq->memory =3D=3D V4L2_MEMORY_USERPTR ||
> +			vq->memory =3D=3D V4L2_MEMORY_DMABUF) &&
> +			ctx->state =3D=3D MFCINST_HEAD_PARSED &&
> +			ctx->capture_state =3D=3D QUEUE_BUFS_MMAPED)
> +			wait_flag =3D 1;
> +	}
>  	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
> +	if (wait_flag)
> +		s5p_mfc_wait_for_done_ctx(ctx,
> +				S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
>  }
> =20
>  static struct vb2_ops s5p_mfc_dec_qops =3D {
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media=
/platform/s5p-mfc/s5p_mfc_enc.c
> index 7b041e5ee4be..33fc3f3ef48a 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1125,11 +1125,11 @@ static int vidioc_reqbufs(struct file *file, void=
 *priv,
>  	struct s5p_mfc_ctx *ctx =3D fh_to_ctx(priv);
>  	int ret =3D 0;
> =20
> -	/* if memory is not mmp or userptr return error */
> -	if ((reqbufs->memory !=3D V4L2_MEMORY_MMAP) &&
> -		(reqbufs->memory !=3D V4L2_MEMORY_USERPTR))
> -		return -EINVAL;
>  	if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, reqbufs->memory,
> +					     reqbufs->type);
> +		if (ret)
> +			return ret;
>  		if (reqbufs->count =3D=3D 0) {
>  			mfc_debug(2, "Freeing buffers\n");
>  			ret =3D vb2_reqbufs(&ctx->vq_dst, reqbufs);
> @@ -1159,6 +1159,10 @@ static int vidioc_reqbufs(struct file *file, void =
*priv,
>  			return -ENOMEM;
>  		}
>  	} else if (reqbufs->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_src, reqbufs->memory,
> +					     reqbufs->type);
> +		if (ret)
> +			return ret;
>  		if (reqbufs->count =3D=3D 0) {
>  			mfc_debug(2, "Freeing buffers\n");
>  			ret =3D vb2_reqbufs(&ctx->vq_src, reqbufs);
> @@ -1190,6 +1194,8 @@ static int vidioc_reqbufs(struct file *file, void *=
priv,
>  			mfc_err("error in vb2_reqbufs() for E(S)\n");
>  			return ret;
>  		}
> +		if (reqbufs->memory !=3D V4L2_MEMORY_MMAP)
> +			ctx->src_bufs_cnt =3D reqbufs->count;
>  		ctx->output_state =3D QUEUE_BUFS_REQUESTED;
>  	} else {
>  		mfc_err("invalid buf type\n");
> @@ -1204,11 +1210,11 @@ static int vidioc_querybuf(struct file *file, voi=
d *priv,
>  	struct s5p_mfc_ctx *ctx =3D fh_to_ctx(priv);
>  	int ret =3D 0;
> =20
> -	/* if memory is not mmp or userptr return error */
> -	if ((buf->memory !=3D V4L2_MEMORY_MMAP) &&
> -		(buf->memory !=3D V4L2_MEMORY_USERPTR))
> -		return -EINVAL;
>  	if (buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_dst, buf->memory,
> +					     buf->type);
> +		if (ret)
> +			return ret;
>  		if (ctx->state !=3D MFCINST_GOT_INST) {
>  			mfc_err("invalid context state: %d\n", ctx->state);
>  			return -EINVAL;
> @@ -1220,6 +1226,10 @@ static int vidioc_querybuf(struct file *file, void=
 *priv,
>  		}
>  		buf->m.planes[0].m.mem_offset +=3D DST_QUEUE_OFF_BASE;
>  	} else if (buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		ret =3D vb2_verify_memory_type(&ctx->vq_src, buf->memory,
> +					     buf->type);
> +		if (ret)
> +			return ret;
>  		ret =3D vb2_querybuf(&ctx->vq_src, buf);
>  		if (ret !=3D 0) {
>  			mfc_err("error in vb2_querybuf() for E(S)\n");
> @@ -1828,6 +1838,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq=
,
>  			*buf_count =3D MFC_MAX_BUFFERS;
>  		psize[0] =3D ctx->enc_dst_buf_size;
>  		alloc_devs[0] =3D ctx->dev->mem_dev[BANK_L_CTX];
> +		memset(ctx->dst_bufs, 0, sizeof(ctx->dst_bufs));
>  	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		if (ctx->src_fmt)
>  			*plane_count =3D ctx->src_fmt->num_planes;
> @@ -1849,6 +1860,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq=
,
>  			alloc_devs[0] =3D ctx->dev->mem_dev[BANK_R_CTX];
>  			alloc_devs[1] =3D ctx->dev->mem_dev[BANK_R_CTX];
>  		}
> +		memset(ctx->src_bufs, 0, sizeof(ctx->src_bufs));
>  	} else {
>  		mfc_err("invalid queue type: %d\n", vq->type);
>  		return -EINVAL;
> @@ -1865,25 +1877,47 @@ static int s5p_mfc_buf_init(struct vb2_buffer *vb=
)
>  	int ret;
> =20
>  	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		dma_addr_t stream;
> +
>  		ret =3D check_vb_with_fmt(ctx->dst_fmt, vb);
>  		if (ret < 0)
>  			return ret;
> +
> +		stream =3D vb2_dma_contig_plane_dma_addr(vb, 0);
>  		i =3D vb->index;
> +		if (ctx->dst_bufs[i].cookie.stream &&
> +		    ctx->src_bufs[i].cookie.stream !=3D stream) {
> +			mfc_err("Changing CAPTURE buffer address during straming is not possi=
ble\n");
> +			return -EINVAL;
> +		}
> +
>  		ctx->dst_bufs[i].b =3D vbuf;
> -		ctx->dst_bufs[i].cookie.stream =3D
> -					vb2_dma_contig_plane_dma_addr(vb, 0);
> +		ctx->dst_bufs[i].cookie.stream =3D stream;
>  		ctx->dst_bufs_cnt++;
>  	} else if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		dma_addr_t luma, chroma;
> +
>  		ret =3D check_vb_with_fmt(ctx->src_fmt, vb);
>  		if (ret < 0)
>  			return ret;
> +
> +		luma =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> +		chroma =3D vb2_dma_contig_plane_dma_addr(vb, 1);
> +
>  		i =3D vb->index;
> +		if ((ctx->src_bufs[i].cookie.raw.luma &&
> +		     ctx->src_bufs[i].cookie.raw.luma !=3D luma) ||
> +		    (ctx->src_bufs[i].cookie.raw.chroma &&
> +		     ctx->src_bufs[i].cookie.raw.chroma !=3D chroma)) {
> +			mfc_err("Changing OUTPUT buffer address during straming is not possib=
le\n");
> +			return -EINVAL;
> +		}
> +
>  		ctx->src_bufs[i].b =3D vbuf;
> -		ctx->src_bufs[i].cookie.raw.luma =3D
> -					vb2_dma_contig_plane_dma_addr(vb, 0);
> -		ctx->src_bufs[i].cookie.raw.chroma =3D
> -					vb2_dma_contig_plane_dma_addr(vb, 1);
> -		ctx->src_bufs_cnt++;
> +		ctx->src_bufs[i].cookie.raw.luma =3D luma;
> +		ctx->src_bufs[i].cookie.raw.chroma =3D chroma;
> +		if (vb->memory =3D=3D V4L2_MEMORY_MMAP)
> +			ctx->src_bufs_cnt++;
>  	} else {
>  		mfc_err("invalid queue type: %d\n", vq->type);
>  		return -EINVAL;
--=-z2naqodeNr1aEMPgJNEf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWfxy8QAKCRBxUwItrAao
HE6WAJ9DzmcDVO3kqvDA28TxF9nz2OfAmQCcCdIS+aDY4lfqYnTiCpjiUVwYpaU=
=JDNC
-----END PGP SIGNATURE-----

--=-z2naqodeNr1aEMPgJNEf--
