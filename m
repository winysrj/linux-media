Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61008 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaKYLY7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 06:24:59 -0500
From: Kamil Debski <k.debski@samsung.com>
To: "'Lad, Prabhakar'" <prabhakar.csengg@gmail.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'LMML' <linux-media@vger.kernel.org>
Cc: 'LKML' <linux-kernel@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Jeongtae Park' <jtp.park@samsung.com>
References: <1416309821-5426-1-git-send-email-prabhakar.csengg@gmail.com>
 <1416309821-5426-10-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1416309821-5426-10-git-send-email-prabhakar.csengg@gmail.com>
Subject: RE: [PATCH 09/12] media: s5p-mfc: use vb2_ops_wait_prepare/finish
 helper
Date: Tue, 25 Nov 2014 12:24:55 +0100
Message-id: <088f01d008a2$70d0f150$5272d3f0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please provide a commit description. No matter how obvious the commit
seems.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Lad, Prabhakar [mailto:prabhakar.csengg@gmail.com]
> Sent: Tuesday, November 18, 2014 12:24 PM
> To: Hans Verkuil; Mauro Carvalho Chehab; LMML
> Cc: LKML; Lad, Prabhakar; Kyungmin Park; Kamil Debski; Jeongtae Park
> Subject: [PATCH 09/12] media: s5p-mfc: use vb2_ops_wait_prepare/finish
> helper
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> Cc: Jeongtae Park <jtp.park@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c     |  1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 20 ++------------------
> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 20 ++------------------
>  3 files changed, 5 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 03204fd..52f65e9 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -810,6 +810,7 @@ static int s5p_mfc_open(struct file *file)
>  	q = &ctx->vq_dst;
>  	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>  	q->drv_priv = &ctx->fh;
> +	q->lock = &dev->mfc_mutex;
>  	if (vdev == dev->vfd_dec) {
>  		q->io_modes = VB2_MMAP;
>  		q->ops = get_dec_queue_ops();
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 74bcec8..78b3e0e 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -946,22 +946,6 @@ static int s5p_mfc_queue_setup(struct vb2_queue
> *vq,
>  	return 0;
>  }
> 
> -static void s5p_mfc_unlock(struct vb2_queue *q) -{
> -	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
> -	struct s5p_mfc_dev *dev = ctx->dev;
> -
> -	mutex_unlock(&dev->mfc_mutex);
> -}
> -
> -static void s5p_mfc_lock(struct vb2_queue *q) -{
> -	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
> -	struct s5p_mfc_dev *dev = ctx->dev;
> -
> -	mutex_lock(&dev->mfc_mutex);
> -}
> -
>  static int s5p_mfc_buf_init(struct vb2_buffer *vb)  {
>  	struct vb2_queue *vq = vb->vb2_queue;
> @@ -1109,8 +1093,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer
> *vb)
> 
>  static struct vb2_ops s5p_mfc_dec_qops = {
>  	.queue_setup		= s5p_mfc_queue_setup,
> -	.wait_prepare		= s5p_mfc_unlock,
> -	.wait_finish		= s5p_mfc_lock,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
>  	.buf_init		= s5p_mfc_buf_init,
>  	.start_streaming	= s5p_mfc_start_streaming,
>  	.stop_streaming		= s5p_mfc_stop_streaming,
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index e7240cb..ffa9c1d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -1869,22 +1869,6 @@ static int s5p_mfc_queue_setup(struct vb2_queue
> *vq,
>  	return 0;
>  }
> 
> -static void s5p_mfc_unlock(struct vb2_queue *q) -{
> -	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
> -	struct s5p_mfc_dev *dev = ctx->dev;
> -
> -	mutex_unlock(&dev->mfc_mutex);
> -}
> -
> -static void s5p_mfc_lock(struct vb2_queue *q) -{
> -	struct s5p_mfc_ctx *ctx = fh_to_ctx(q->drv_priv);
> -	struct s5p_mfc_dev *dev = ctx->dev;
> -
> -	mutex_lock(&dev->mfc_mutex);
> -}
> -
>  static int s5p_mfc_buf_init(struct vb2_buffer *vb)  {
>  	struct vb2_queue *vq = vb->vb2_queue;
> @@ -2054,8 +2038,8 @@ static void s5p_mfc_buf_queue(struct vb2_buffer
> *vb)
> 
>  static struct vb2_ops s5p_mfc_enc_qops = {
>  	.queue_setup		= s5p_mfc_queue_setup,
> -	.wait_prepare		= s5p_mfc_unlock,
> -	.wait_finish		= s5p_mfc_lock,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
>  	.buf_init		= s5p_mfc_buf_init,
>  	.buf_prepare		= s5p_mfc_buf_prepare,
>  	.start_streaming	= s5p_mfc_start_streaming,
> --
> 1.9.1

