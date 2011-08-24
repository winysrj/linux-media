Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1HXTIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 15:08:54 -0400
Date: Wed, 24 Aug 2011 21:08:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: vb2: change plane sizes array to unsigned int[]
In-Reply-To: <1314179682-8557-1-git-send-email-m.szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.64.1108242108010.14818@axis700.grange>
References: <1314179682-8557-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 24 Aug 2011, Marek Szyprowski wrote:

> Plane sizes array was declared as unsigned long[], while unsigned int is
> more than enough for storing size of the video buffer. This patch reduces
> the size of the array by definiting it as unsigned int[].
> 
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

https://patchwork.kernel.org/patch/1037612/

:-)

> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/atmel-isi.c              |    2 +-
>  drivers/media/video/marvell-ccic/mcam-core.c |    2 +-
>  drivers/media/video/mem2mem_testdev.c        |    2 +-
>  drivers/media/video/mx3_camera.c             |    2 +-
>  drivers/media/video/pwc/pwc-if.c             |    2 +-
>  drivers/media/video/s5p-fimc/fimc-capture.c  |    2 +-
>  drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    2 +-
>  drivers/media/video/s5p-tv/mixer_video.c     |    2 +-
>  drivers/media/video/sh_mobile_ceu_camera.c   |    2 +-
>  drivers/media/video/vivi.c                   |    2 +-
>  include/media/videobuf2-core.h               |    4 ++--
>  13 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> index 7b89f00..5a4b2d7 100644
> --- a/drivers/media/video/atmel-isi.c
> +++ b/drivers/media/video/atmel-isi.c
> @@ -249,7 +249,7 @@ static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
>  	Videobuf operations
>     ------------------------------------------------------------------*/
>  static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> -				unsigned int *nplanes, unsigned long sizes[],
> +				unsigned int *nplanes, unsigned int sizes[],
>  				void *alloc_ctxs[])
>  {
>  	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
> index 83c1451..744cf37 100644
> --- a/drivers/media/video/marvell-ccic/mcam-core.c
> +++ b/drivers/media/video/marvell-ccic/mcam-core.c
> @@ -884,7 +884,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
>   */
>  
>  static int mcam_vb_queue_setup(struct vb2_queue *vq, unsigned int *nbufs,
> -		unsigned int *num_planes, unsigned long sizes[],
> +		unsigned int *num_planes, unsigned int sizes[],
>  		void *alloc_ctxs[])
>  {
>  	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
> index 166bf93..0d0c0d5 100644
> --- a/drivers/media/video/mem2mem_testdev.c
> +++ b/drivers/media/video/mem2mem_testdev.c
> @@ -739,7 +739,7 @@ static const struct v4l2_ioctl_ops m2mtest_ioctl_ops = {
>   */
>  
>  static int m2mtest_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> -				unsigned int *nplanes, unsigned long sizes[],
> +				unsigned int *nplanes, unsigned int sizes[],
>  				void *alloc_ctxs[])
>  {
>  	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vq);
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index c045b47..9ae7785 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -191,7 +191,7 @@ static void mx3_cam_dma_done(void *arg)
>   */
>  static int mx3_videobuf_setup(struct vb2_queue *vq,
>  			unsigned int *count, unsigned int *num_planes,
> -			unsigned long sizes[], void *alloc_ctxs[])
> +			unsigned int sizes[], void *alloc_ctxs[])
>  {
>  	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
> index 51ca358..a7e4f56 100644
> --- a/drivers/media/video/pwc/pwc-if.c
> +++ b/drivers/media/video/pwc/pwc-if.c
> @@ -745,7 +745,7 @@ static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
>  /* Videobuf2 operations */
>  
>  static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> -				unsigned int *nplanes, unsigned long sizes[],
> +				unsigned int *nplanes, unsigned int sizes[],
>  				void *alloc_ctxs[])
>  {
>  	struct pwc_device *pdev = vb2_get_drv_priv(vq);
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> index 0d730e5..e6afe5f 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -265,7 +265,7 @@ static unsigned int get_plane_size(struct fimc_frame *fr, unsigned int plane)
>  }
>  
>  static int queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
> -		       unsigned int *num_planes, unsigned long sizes[],
> +		       unsigned int *num_planes, unsigned int sizes[],
>  		       void *allocators[])
>  {
>  	struct fimc_ctx *ctx = vq->drv_priv;
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index aa55066..36d127f 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -692,7 +692,7 @@ static void fimc_job_abort(void *priv)
>  }
>  
>  static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
> -			    unsigned int *num_planes, unsigned long sizes[],
> +			    unsigned int *num_planes, unsigned int sizes[],
>  			    void *allocators[])
>  {
>  	struct fimc_ctx *ctx = vb2_get_drv_priv(vq);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> index b2c5052..dbc94b8 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> @@ -745,7 +745,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
>  };
>  
>  static int s5p_mfc_queue_setup(struct vb2_queue *vq, unsigned int *buf_count,
> -			       unsigned int *plane_count, unsigned long psize[],
> +			       unsigned int *plane_count, unsigned int psize[],
>  			       void *allocators[])
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index fee094a..019a9e7 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -1514,7 +1514,7 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
>  
>  static int s5p_mfc_queue_setup(struct vb2_queue *vq,
>  		       unsigned int *buf_count, unsigned int *plane_count,
> -		       unsigned long psize[], void *allocators[])
> +		       unsigned int psize[], void *allocators[])
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
>  
> diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
> index 43ac22f..8bea0f3 100644
> --- a/drivers/media/video/s5p-tv/mixer_video.c
> +++ b/drivers/media/video/s5p-tv/mixer_video.c
> @@ -728,7 +728,7 @@ static const struct v4l2_file_operations mxr_fops = {
>  };
>  
>  static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> -	unsigned int *nplanes, unsigned long sizes[],
> +	unsigned int *nplanes, unsigned int sizes[],
>  	void *alloc_ctxs[])
>  {
>  	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index e540898..f4f95ab 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -218,7 +218,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
>   */
>  static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
>  			unsigned int *count, unsigned int *num_planes,
> -			unsigned long sizes[], void *alloc_ctxs[])
> +			unsigned int sizes[], void *alloc_ctxs[])
>  {
>  	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index a848bd2..26eda47 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -651,7 +651,7 @@ static void vivi_stop_generating(struct vivi_dev *dev)
>  	Videobuf operations
>     ------------------------------------------------------------------*/
>  static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> -				unsigned int *nplanes, unsigned long sizes[],
> +				unsigned int *nplanes, unsigned int sizes[],
>  				void *alloc_ctxs[])
>  {
>  	struct vivi_dev *dev = vb2_get_drv_priv(vq);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 984f2ba..5287e90 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -208,7 +208,7 @@ struct vb2_buffer {
>   */
>  struct vb2_ops {
>  	int (*queue_setup)(struct vb2_queue *q, unsigned int *num_buffers,
> -			   unsigned int *num_planes, unsigned long sizes[],
> +			   unsigned int *num_planes, unsigned int sizes[],
>  			   void *alloc_ctxs[]);
>  
>  	void (*wait_prepare)(struct vb2_queue *q);
> @@ -273,7 +273,7 @@ struct vb2_queue {
>  	wait_queue_head_t		done_wq;
>  
>  	void				*alloc_ctx[VIDEO_MAX_PLANES];
> -	unsigned long			plane_sizes[VIDEO_MAX_PLANES];
> +	unsigned int			plane_sizes[VIDEO_MAX_PLANES];
>  
>  	unsigned int			streaming:1;
>  
> -- 
> 1.7.1.569.g6f426
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
