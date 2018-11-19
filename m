Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:24114 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbeKSWZA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 17:25:00 -0500
Date: Mon, 19 Nov 2018 14:01:31 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv2 2/4] vivid: use per-queue mutexes instead of one global
 mutex.
Message-ID: <20181119120131.cy4vypcwjpmaumwe@paasikivi.fi.intel.com>
References: <20181119110903.24383-1-hverkuil@xs4all.nl>
 <20181119110903.24383-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119110903.24383-3-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 19, 2018 at 12:09:01PM +0100, Hans Verkuil wrote:
> This avoids having to unlock the queue lock in stop_streaming.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Reported-by: syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com
> ---
>  drivers/media/platform/vivid/vivid-core.c        | 15 ++++++++++-----
>  drivers/media/platform/vivid/vivid-core.h        |  5 +++++
>  drivers/media/platform/vivid/vivid-kthread-cap.c |  2 --
>  drivers/media/platform/vivid/vivid-kthread-out.c |  2 --
>  drivers/media/platform/vivid/vivid-sdr-cap.c     |  2 --
>  5 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 626e2b24a403..38389af97b16 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -1075,7 +1075,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
> -		q->lock = &dev->mutex;
> +		mutex_init(&dev->vb_vid_cap_q_lock);

Could you add the corresponding mutex_destroy()'s for these mutex_init()
calls?

> +		q->lock = &dev->vb_vid_cap_q_lock;
>  		q->dev = dev->v4l2_dev.dev;
>  		q->supports_requests = true;
>  
> @@ -1096,7 +1097,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
> -		q->lock = &dev->mutex;
> +		mutex_init(&dev->vb_vid_out_q_lock);
> +		q->lock = &dev->vb_vid_out_q_lock;
>  		q->dev = dev->v4l2_dev.dev;
>  		q->supports_requests = true;
>  
> @@ -1117,7 +1119,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
> -		q->lock = &dev->mutex;
> +		mutex_init(&dev->vb_vbi_cap_q_lock);
> +		q->lock = &dev->vb_vbi_cap_q_lock;
>  		q->dev = dev->v4l2_dev.dev;
>  		q->supports_requests = true;
>  
> @@ -1138,7 +1141,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
> -		q->lock = &dev->mutex;
> +		mutex_init(&dev->vb_vbi_out_q_lock);
> +		q->lock = &dev->vb_vbi_out_q_lock;
>  		q->dev = dev->v4l2_dev.dev;
>  		q->supports_requests = true;
>  
> @@ -1158,7 +1162,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 8;
> -		q->lock = &dev->mutex;
> +		mutex_init(&dev->vb_sdr_cap_q_lock);
> +		q->lock = &dev->vb_sdr_cap_q_lock;
>  		q->dev = dev->v4l2_dev.dev;
>  		q->supports_requests = true;
>  
> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
> index 1891254c8f0b..337ccb563f9b 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -385,8 +385,10 @@ struct vivid_dev {
>  	struct v4l2_rect		compose_cap;
>  	struct v4l2_rect		crop_bounds_cap;
>  	struct vb2_queue		vb_vid_cap_q;
> +	struct mutex			vb_vid_cap_q_lock;
>  	struct list_head		vid_cap_active;
>  	struct vb2_queue		vb_vbi_cap_q;
> +	struct mutex			vb_vbi_cap_q_lock;
>  	struct list_head		vbi_cap_active;
>  
>  	/* thread for generating video capture stream */
> @@ -413,8 +415,10 @@ struct vivid_dev {
>  	struct v4l2_rect		compose_out;
>  	struct v4l2_rect		compose_bounds_out;
>  	struct vb2_queue		vb_vid_out_q;
> +	struct mutex			vb_vid_out_q_lock;
>  	struct list_head		vid_out_active;
>  	struct vb2_queue		vb_vbi_out_q;
> +	struct mutex			vb_vbi_out_q_lock;
>  	struct list_head		vbi_out_active;
>  
>  	/* video loop precalculated rectangles */
> @@ -459,6 +463,7 @@ struct vivid_dev {
>  
>  	/* SDR capture */
>  	struct vb2_queue		vb_sdr_cap_q;
> +	struct mutex			vb_sdr_cap_q_lock;
>  	struct list_head		sdr_cap_active;
>  	u32				sdr_pixelformat; /* v4l2 format id */
>  	unsigned			sdr_buffersize;
> diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
> index eebfff2126be..d8bb59e9bcc7 100644
> --- a/drivers/media/platform/vivid/vivid-kthread-cap.c
> +++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
> @@ -927,8 +927,6 @@ void vivid_stop_generating_vid_cap(struct vivid_dev *dev, bool *pstreaming)
>  
>  	/* shutdown control thread */
>  	vivid_grab_controls(dev, false);
> -	mutex_unlock(&dev->mutex);
>  	kthread_stop(dev->kthread_vid_cap);
>  	dev->kthread_vid_cap = NULL;
> -	mutex_lock(&dev->mutex);
>  }
> diff --git a/drivers/media/platform/vivid/vivid-kthread-out.c b/drivers/media/platform/vivid/vivid-kthread-out.c
> index 5a14810eeb69..8b864cb0ed52 100644
> --- a/drivers/media/platform/vivid/vivid-kthread-out.c
> +++ b/drivers/media/platform/vivid/vivid-kthread-out.c
> @@ -298,8 +298,6 @@ void vivid_stop_generating_vid_out(struct vivid_dev *dev, bool *pstreaming)
>  
>  	/* shutdown control thread */
>  	vivid_grab_controls(dev, false);
> -	mutex_unlock(&dev->mutex);
>  	kthread_stop(dev->kthread_vid_out);
>  	dev->kthread_vid_out = NULL;
> -	mutex_lock(&dev->mutex);
>  }
> diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
> index dcdc80e272c2..5dfb598af742 100644
> --- a/drivers/media/platform/vivid/vivid-sdr-cap.c
> +++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
> @@ -305,10 +305,8 @@ static void sdr_cap_stop_streaming(struct vb2_queue *vq)
>  	}
>  
>  	/* shutdown control thread */
> -	mutex_unlock(&dev->mutex);
>  	kthread_stop(dev->kthread_sdr_cap);
>  	dev->kthread_sdr_cap = NULL;
> -	mutex_lock(&dev->mutex);
>  }
>  
>  static void sdr_cap_buf_request_complete(struct vb2_buffer *vb)
> -- 
> 2.19.1
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
