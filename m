Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1736 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaDDJSe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 05:18:34 -0400
Message-ID: <533E78C7.6020607@xs4all.nl>
Date: Fri, 04 Apr 2014 11:17:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
CC: LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v2 1/2] media: davinci: vpif capture: upgrade the driver
 with v4l offerings
References: <1396588656-6660-1-git-send-email-prabhakar.csengg@gmail.com> <1396588656-6660-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1396588656-6660-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Some review comments below. I'm going through the code quite carefully since
this very nice cleanup is a good opportunity to check for correct behavior in
this driver.

On 04/04/2014 07:17 AM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch upgrades the vpif display driver with
> v4l helpers, this patch does the following,
> 
> 1: initialize the vb2 queue and context at the time of probe
> and removes context at remove() callback.
> 2: uses vb2_ioctl_*() helpers.
> 3: uses vb2_fop_*() helpers.
> 4: uses SIMPLE_DEV_PM_OPS.
> 5: uses vb2_ioctl_*() helpers.
> 6: vidioc_g/s_priority is now handled by v4l core.
> 7: removed driver specific fh and now using one provided by v4l.
> 8: fixes checkpatch warnings.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c |  931 +++++++------------------
>  drivers/media/platform/davinci/vpif_capture.h |   32 +-
>  2 files changed, 234 insertions(+), 729 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 8dea0b8..e4046f5 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2009 Texas Instruments Inc
> + * Copyright (C) 2014 Lad, Prabhakar <prabhakar.csengg@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -37,6 +38,8 @@ MODULE_VERSION(VPIF_CAPTURE_VERSION);
>  #define vpif_dbg(level, debug, fmt, arg...)	\
>  		v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
>  
> +#define VPIF_DRIVER_NAME	"vpif_capture"
> +
>  static int debug = 1;
>  static u32 ch0_numbuffers = 3;
>  static u32 ch1_numbuffers = 3;
> @@ -65,11 +68,25 @@ static struct vpif_config_params config_params = {
>  	.channel_bufsize[1] = 720 * 576 * 2,
>  };
>  
> +static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] = { {1, 1} };
> +
>  /* global variables */
>  static struct vpif_device vpif_obj = { {NULL} };
>  static struct device *vpif_dev;
>  static void vpif_calculate_offsets(struct channel_obj *ch);
>  static void vpif_config_addr(struct channel_obj *ch, int muxmode);
> +static int vpif_check_format(struct channel_obj *ch,
> +			     struct v4l2_pix_format *pixfmt, int update);
> +
> +/*
> + * Is set to 1 in case of SDTV formats, 2 in case of HDTV formats.
> + */
> +static int ycmux_mode;
> +
> +static inline struct vpif_cap_buffer *to_vpif_buffer(struct vb2_buffer *vb)
> +{
> +	return container_of(vb, struct vpif_cap_buffer, vb);
> +}
>  
>  /**
>   * buffer_prepare :  callback function for buffer prepare
> @@ -81,10 +98,8 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode);
>   */
>  static int vpif_buffer_prepare(struct vb2_buffer *vb)
>  {
> -	/* Get the file handle object and channel object */
> -	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
>  	struct vb2_queue *q = vb->vb2_queue;
> -	struct channel_obj *ch = fh->channel;
> +	struct channel_obj *ch = vb2_get_drv_priv(q);
>  	struct common_obj *common;
>  	unsigned long addr;
>  
> @@ -100,7 +115,7 @@ static int vpif_buffer_prepare(struct vb2_buffer *vb)
>  			goto exit;
>  		addr = vb2_dma_contig_plane_dma_addr(vb, 0);
>  
> -		if (q->streaming) {
> +		if (vb2_is_streaming(q)) {
>  			if (!IS_ALIGNED((addr + common->ytop_off), 8) ||
>  				!IS_ALIGNED((addr + common->ybtm_off), 8) ||
>  				!IS_ALIGNED((addr + common->ctop_off), 8) ||

Why would you do this check only when streaming? Usually apps queued all
buffers before calling S_STREAMON, so vb2_is_streaming(q) will still be
false.

The problem is that vpif_calculate_offsets() is called in start_streaming,
but it should be called earlier in queue_setup. After queue_setup is called
the application is no longer allowed to change the format, so that's a good
place to do it. And then you can drop the vb2_is_streaming() check here
since the offsets will always be valid.

Also the 'if (vb->state != VB2_BUF_STATE_ACTIVE && vb->state != VB2_BUF_STATE_PREPARED)'
can be droppedd. It will never be called in an invalid state.

This check:

	 if (vb2_plane_vaddr(vb, 0) &&
                vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
                        goto exit;

can also be improved: drop the vb2_plane_vaddr(vb, 0) since the payload check
should be done unconditionally. The 'goto exit' should be replaced with a
proper vpif_dbg since the message printed in the 'exit' is for the alignment
check.

> @@ -131,9 +146,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
>  				unsigned int *nbuffers, unsigned int *nplanes,
>  				unsigned int sizes[], void *alloc_ctxs[])
>  {
> -	/* Get the file handle object and channel object */
> -	struct vpif_fh *fh = vb2_get_drv_priv(vq);
> -	struct channel_obj *ch = fh->channel;
> +	struct channel_obj *ch = vb2_get_drv_priv(vq);
>  	struct common_obj *common;
>  	unsigned long size;
>  
> @@ -141,8 +154,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
>  
>  	vpif_dbg(2, debug, "vpif_buffer_setup\n");
>  
> -	/* If memory type is not mmap, return */
> -	if (V4L2_MEMORY_MMAP == common->memory) {
> +	if (vq->memory == V4L2_MEMORY_MMAP) {
>  		/* Calculate the size of the buffer */
>  		size = config_params.channel_bufsize[ch->channel_id];
>  		/*

A few general questions regarding queue_setup (not specific to this patch):

Why do we use 'config_params.channel_bufsize[ch->channel_id]' as the buffer size
in the MMAP case instead of common->fmt.fmt.pix.sizeimage? Why do we have the
ch[01]_bufsize module options? How and when is video_limit configured? Why do we
have ch[01]_numbuffers module options?

Since you added support for create_buffers the code in queue_setup needs to
change a bit as well:

        if (*nbuffers < config_params.min_numbuffers)
                *nbuffers = config_params.min_numbuffers;

becomes:

        if (vq->num_buffers + *nbuffers < config_params.min_numbuffers)
                *nbuffers = config_params.min_numbuffers - vq->num_buffers;

And when setting the size it should be:

	size = fmt ? fmt->fmt.pix.sizeimage : common->fmt.fmt.pix.sizeimage;

> @@ -183,11 +195,8 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
>   */
>  static void vpif_buffer_queue(struct vb2_buffer *vb)
>  {
> -	/* Get the file handle object and channel object */
> -	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
> -	struct channel_obj *ch = fh->channel;
> -	struct vpif_cap_buffer *buf = container_of(vb,
> -				struct vpif_cap_buffer, vb);
> +	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
>  	struct common_obj *common;
>  	unsigned long flags;
>  
> @@ -210,11 +219,8 @@ static void vpif_buffer_queue(struct vb2_buffer *vb)
>   */
>  static void vpif_buf_cleanup(struct vb2_buffer *vb)
>  {
> -	/* Get the file handle object and channel object */
> -	struct vpif_fh *fh = vb2_get_drv_priv(vb->vb2_queue);
> -	struct vpif_cap_buffer *buf = container_of(vb,
> -					struct vpif_cap_buffer, vb);
> -	struct channel_obj *ch = fh->channel;
> +	struct channel_obj *ch = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vpif_cap_buffer *buf = to_vpif_buffer(vb);
>  	struct common_obj *common;
>  	unsigned long flags;
>  

buf_cleanup is *never* called if the buffer is in the active state, so you
can drop the whole function.

> @@ -227,65 +233,26 @@ static void vpif_buf_cleanup(struct vb2_buffer *vb)
>  
>  }
>  
> -static void vpif_wait_prepare(struct vb2_queue *vq)
> -{
> -	struct vpif_fh *fh = vb2_get_drv_priv(vq);
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common;
> -
> -	common = &ch->common[VPIF_VIDEO_INDEX];
> -	mutex_unlock(&common->lock);
> -}
> -
> -static void vpif_wait_finish(struct vb2_queue *vq)
> -{
> -	struct vpif_fh *fh = vb2_get_drv_priv(vq);
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common;
> -
> -	common = &ch->common[VPIF_VIDEO_INDEX];
> -	mutex_lock(&common->lock);
> -}
> -
> -static int vpif_buffer_init(struct vb2_buffer *vb)
> -{
> -	struct vpif_cap_buffer *buf = container_of(vb,
> -					struct vpif_cap_buffer, vb);
> -
> -	INIT_LIST_HEAD(&buf->list);
> -
> -	return 0;
> -}
> -
> -static u8 channel_first_int[VPIF_NUMBER_OF_OBJECTS][2] =
> -	{ {1, 1} };
> -
>  static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
> -	struct vpif_capture_config *vpif_config_data =
> -					vpif_dev->platform_data;
> -	struct vpif_fh *fh = vb2_get_drv_priv(vq);
> -	struct channel_obj *ch = fh->channel;
> +	struct vpif_capture_config *vpif_config_data;
> +	struct channel_obj *ch = vb2_get_drv_priv(vq);
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
>  	struct vpif_params *vpif = &ch->vpifparams;
> -	unsigned long addr = 0;
> -	unsigned long flags;
> +	struct vpif_cap_buffer *buf, *tmp;
> +	unsigned long addr, flags;
>  	int ret;
>  
>  	spin_lock_irqsave(&common->irqlock, flags);
>  
> -	/* Get the next frame from the buffer queue */
> -	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
> -				    struct vpif_cap_buffer, list);
> -	/* Remove buffer from the buffer queue */
> -	list_del(&common->cur_frm->list);
> -	spin_unlock_irqrestore(&common->irqlock, flags);
> -	/* Mark state of the current frame to active */
> -	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
> -	/* Initialize field_id and started member */
> +	/* Initialize field_id */
>  	ch->field_id = 0;
> -	common->started = 1;
> -	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
> +
> +	ret = vpif_check_format(ch, &common->fmt.fmt.pix, 0);
> +	if (ret) {
> +		ret = -EINVAL;
> +		goto err;
> +	}

Why do a check_format here? Since that is already checked by try/s_fmt you
should never get a wrong format here in start_streaming().

>  
>  	/* Calculate the offset for Y and C data in the buffer */
>  	vpif_calculate_offsets(ch);

The same is true for the field checks that are done after the call to
vpif_calculate_offsets.

The way it should work is that s_std and s_dv_timings reset the current format
to something that is valid for the new standard/timings. So field can never be
wrong. See e.g. how the v4l2-pci-skeleton.c example source does it.

> @@ -296,30 +263,50 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	    (!vpif->std_info.frm_fmt &&
>  	     (common->fmt.fmt.pix.field == V4L2_FIELD_NONE))) {
>  		vpif_dbg(1, debug, "conflict in field format and std format\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err;
>  	}
>  
> +	vpif_config_data = vpif_dev->platform_data;
>  	/* configure 1 or 2 channel mode */
>  	if (vpif_config_data->setup_input_channel_mode) {
>  		ret = vpif_config_data->
>  			setup_input_channel_mode(vpif->std_info.ycmux_mode);
>  		if (ret < 0) {
>  			vpif_dbg(1, debug, "can't set vpif channel mode\n");
> -			return ret;
> +			ret = -EINVAL;
> +			goto err;
>  		}
>  	}
>  
> +	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
> +
> +	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
> +		vpif_dbg(1, debug, "stream on failed in subdev\n");
> +		goto err;
> +	}
> +
>  	/* Call vpif_set_params function to set the parameters and addresses */
>  	ret = vpif_set_video_params(vpif, ch->channel_id);
> -
>  	if (ret < 0) {
>  		vpif_dbg(1, debug, "can't set video params\n");
> -		return ret;
> +		ret = -EINVAL;
> +		goto err;
>  	}
> -
> -	common->started = ret;
> +	ycmux_mode = ret;
>  	vpif_config_addr(ch, ret);
>  
> +	/* Get the next frame from the buffer queue */
> +	common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
> +				    struct vpif_cap_buffer, list);
> +	/* Remove buffer from the buffer queue */
> +	list_del(&common->cur_frm->list);
> +	spin_unlock_irqrestore(&common->irqlock, flags);
> +	/* Mark state of the current frame to active */
> +	common->cur_frm->vb.state = VB2_BUF_STATE_ACTIVE;
> +
> +	addr = vb2_dma_contig_plane_dma_addr(&common->cur_frm->vb, 0);
> +
>  	common->set_addr(addr + common->ytop_off,
>  			 addr + common->ybtm_off,
>  			 addr + common->ctop_off,
> @@ -330,31 +317,35 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	 * VPIF register
>  	 */
>  	channel_first_int[VPIF_VIDEO_INDEX][ch->channel_id] = 1;
> -	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)) {
> +	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
>  		channel0_intr_assert();
>  		channel0_intr_enable(1);
>  		enable_channel0(1);
>  	}
> -	if ((VPIF_CHANNEL1_VIDEO == ch->channel_id) ||
> -	    (common->started == 2)) {
> +	if (VPIF_CHANNEL1_VIDEO == ch->channel_id || ycmux_mode == 2) {
>  		channel1_intr_assert();
>  		channel1_intr_enable(1);
>  		enable_channel1(1);
>  	}
>  
>  	return 0;
> +
> +err:
> +	list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
> +		list_del(&buf->list);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
> +	}
> +
> +	return ret;
>  }
>  
>  /* abort streaming and wait for last buffer */
>  static int vpif_stop_streaming(struct vb2_queue *vq)
>  {
> -	struct vpif_fh *fh = vb2_get_drv_priv(vq);
> -	struct channel_obj *ch = fh->channel;
> +	struct channel_obj *ch = vb2_get_drv_priv(vq);
>  	struct common_obj *common;
>  	unsigned long flags;
> -
> -	if (!vb2_is_streaming(vq))
> -		return 0;
> +	int ret;
>  
>  	common = &ch->common[VPIF_VIDEO_INDEX];
>  
> @@ -363,12 +354,17 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
>  		enable_channel0(0);
>  		channel0_intr_enable(0);
>  	}
> -	if ((VPIF_CHANNEL1_VIDEO == ch->channel_id) ||
> -		(2 == common->started)) {
> +	if (VPIF_CHANNEL1_VIDEO == ch->channel_id || ycmux_mode == 2) {
>  		enable_channel1(0);
>  		channel1_intr_enable(0);
>  	}
> -	common->started = 0;
> +
> +	ycmux_mode = 0;
> +
> +	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
> +
> +	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		vpif_dbg(1, debug, "stream off failed in subdev\n");
>  
>  	/* release all active buffers */
>  	spin_lock_irqsave(&common->irqlock, flags);
> @@ -396,9 +392,8 @@ static int vpif_stop_streaming(struct vb2_queue *vq)
>  
>  static struct vb2_ops video_qops = {
>  	.queue_setup		= vpif_buffer_queue_setup,
> -	.wait_prepare		= vpif_wait_prepare,
> -	.wait_finish		= vpif_wait_finish,
> -	.buf_init		= vpif_buffer_init,
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
>  	.buf_prepare		= vpif_buffer_prepare,
>  	.start_streaming	= vpif_start_streaming,
>  	.stop_streaming		= vpif_stop_streaming,
> @@ -417,8 +412,7 @@ static struct vb2_ops video_qops = {
>  static void vpif_process_buffer_complete(struct common_obj *common)
>  {
>  	v4l2_get_timestamp(&common->cur_frm->vb.v4l2_buf.timestamp);
> -	vb2_buffer_done(&common->cur_frm->vb,
> -					    VB2_BUF_STATE_DONE);
> +	vb2_buffer_done(&common->cur_frm->vb, VB2_BUF_STATE_DONE);

common->cur_frm->vb.v4l2_buf.field should also be set.

This should have been caught by v4l2-compliance -s!

>  	/* Make curFrm pointing to nextFrm */
>  	common->cur_frm = common->next_frm;
>  }
> @@ -433,7 +427,7 @@ static void vpif_process_buffer_complete(struct common_obj *common)
>   */
>  static void vpif_schedule_next_buffer(struct common_obj *common)
>  {
> -	unsigned long addr = 0;
> +	unsigned long addr;
>  
>  	spin_lock(&common->irqlock);
>  	common->next_frm = list_entry(common->dma_queue.next,
> @@ -479,7 +473,7 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
>  	for (i = 0; i < VPIF_NUMBER_OF_OBJECTS; i++) {
>  		common = &ch->common[i];
>  		/* skip If streaming is not started in this channel */
> -		if (0 == common->started)
> +		if (!vb2_is_streaming(&common->buffer_queue))
>  			continue;

This check can be dropped. If you get here, you are always streaming.

>  
>  		/* Check the field format */
> @@ -683,10 +677,6 @@ static void vpif_config_format(struct channel_obj *ch)
>  	vpif_dbg(2, debug, "vpif_config_format\n");
>  
>  	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;

In general I strongly recommend against using FIELD_ANY internally. It's
cleaner to only use proper field values that are valid for the current format.

Only in check_fmt would you check for FIELD_ANY and replace it with whatever
is appropriate for the current format. The reason is that while the app my
specify FIELD_ANY, the driver should never return it anywhere. To keep that
from happening and to keep everything sane it is best in my experience to
just make sure it is never used in internal data structures.

> -	if (config_params.numbuffers[ch->channel_id] == 0)
> -		common->memory = V4L2_MEMORY_USERPTR;
> -	else
> -		common->memory = V4L2_MEMORY_MMAP;
>  
>  	common->fmt.fmt.pix.sizeimage
>  	    = config_params.channel_bufsize[ch->channel_id];
> @@ -837,415 +827,6 @@ static void vpif_config_addr(struct channel_obj *ch, int muxmode)
>  }
>  
>  /**
> - * vpif_mmap : It is used to map kernel space buffers into user spaces
> - * @filep: file pointer
> - * @vma: ptr to vm_area_struct
> - */
> -static int vpif_mmap(struct file *filep, struct vm_area_struct *vma)
> -{
> -	/* Get the channel object and file handle object */
> -	struct vpif_fh *fh = filep->private_data;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common = &(ch->common[VPIF_VIDEO_INDEX]);
> -	int ret;
> -
> -	vpif_dbg(2, debug, "vpif_mmap\n");
> -
> -	if (mutex_lock_interruptible(&common->lock))
> -		return -ERESTARTSYS;
> -	ret = vb2_mmap(&common->buffer_queue, vma);
> -	mutex_unlock(&common->lock);
> -	return ret;
> -}
> -
> -/**
> - * vpif_poll: It is used for select/poll system call
> - * @filep: file pointer
> - * @wait: poll table to wait
> - */
> -static unsigned int vpif_poll(struct file *filep, poll_table * wait)
> -{
> -	struct vpif_fh *fh = filep->private_data;
> -	struct channel_obj *channel = fh->channel;
> -	struct common_obj *common = &(channel->common[VPIF_VIDEO_INDEX]);
> -	unsigned int res = 0;
> -
> -	vpif_dbg(2, debug, "vpif_poll\n");
> -
> -	if (common->started) {
> -		mutex_lock(&common->lock);
> -		res = vb2_poll(&common->buffer_queue, filep, wait);
> -		mutex_unlock(&common->lock);
> -	}
> -	return res;
> -}
> -
> -/**
> - * vpif_open : vpif open handler
> - * @filep: file ptr
> - *
> - * It creates object of file handle structure and stores it in private_data
> - * member of filepointer
> - */
> -static int vpif_open(struct file *filep)
> -{
> -	struct video_device *vdev = video_devdata(filep);
> -	struct common_obj *common;
> -	struct video_obj *vid_ch;
> -	struct channel_obj *ch;
> -	struct vpif_fh *fh;
> -
> -	vpif_dbg(2, debug, "vpif_open\n");
> -
> -	ch = video_get_drvdata(vdev);
> -
> -	vid_ch = &ch->video;
> -	common = &ch->common[VPIF_VIDEO_INDEX];
> -
> -	/* Allocate memory for the file handle object */
> -	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
> -	if (NULL == fh) {
> -		vpif_err("unable to allocate memory for file handle object\n");
> -		return -ENOMEM;
> -	}
> -
> -	if (mutex_lock_interruptible(&common->lock)) {
> -		kfree(fh);
> -		return -ERESTARTSYS;
> -	}
> -	/* store pointer to fh in private_data member of filep */
> -	filep->private_data = fh;
> -	fh->channel = ch;
> -	fh->initialized = 0;
> -	/* If decoder is not initialized. initialize it */
> -	if (!ch->initialized) {
> -		fh->initialized = 1;
> -		ch->initialized = 1;
> -		memset(&(ch->vpifparams), 0, sizeof(struct vpif_params));
> -	}
> -	/* Increment channel usrs counter */
> -	ch->usrs++;
> -	/* Set io_allowed member to false */
> -	fh->io_allowed[VPIF_VIDEO_INDEX] = 0;
> -	/* Initialize priority of this instance to default priority */
> -	fh->prio = V4L2_PRIORITY_UNSET;
> -	v4l2_prio_open(&ch->prio, &fh->prio);
> -	mutex_unlock(&common->lock);
> -	return 0;
> -}
> -
> -/**
> - * vpif_release : function to clean up file close
> - * @filep: file pointer
> - *
> - * This function deletes buffer queue, frees the buffers and the vpif file
> - * handle
> - */
> -static int vpif_release(struct file *filep)
> -{
> -	struct vpif_fh *fh = filep->private_data;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common;
> -
> -	vpif_dbg(2, debug, "vpif_release\n");
> -
> -	common = &ch->common[VPIF_VIDEO_INDEX];
> -
> -	mutex_lock(&common->lock);
> -	/* if this instance is doing IO */
> -	if (fh->io_allowed[VPIF_VIDEO_INDEX]) {
> -		/* Reset io_usrs member of channel object */
> -		common->io_usrs = 0;
> -		/* Free buffers allocated */
> -		vb2_queue_release(&common->buffer_queue);
> -		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
> -	}
> -
> -	/* Decrement channel usrs counter */
> -	ch->usrs--;
> -
> -	/* Close the priority */
> -	v4l2_prio_close(&ch->prio, fh->prio);
> -
> -	if (fh->initialized)
> -		ch->initialized = 0;
> -
> -	mutex_unlock(&common->lock);
> -	filep->private_data = NULL;
> -	kfree(fh);
> -	return 0;
> -}
> -
> -/**
> - * vpif_reqbufs() - request buffer handler
> - * @file: file ptr
> - * @priv: file handle
> - * @reqbuf: request buffer structure ptr
> - */
> -static int vpif_reqbufs(struct file *file, void *priv,
> -			struct v4l2_requestbuffers *reqbuf)
> -{
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common;
> -	u8 index = 0;
> -	struct vb2_queue *q;
> -	int ret;
> -
> -	vpif_dbg(2, debug, "vpif_reqbufs\n");
> -
> -	/**
> -	 * This file handle has not initialized the channel,
> -	 * It is not allowed to do settings
> -	 */
> -	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id)
> -	    || (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
> -		if (!fh->initialized) {
> -			vpif_dbg(1, debug, "Channel Busy\n");
> -			return -EBUSY;
> -		}
> -	}
> -
> -	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != reqbuf->type || !vpif_dev)
> -		return -EINVAL;
> -
> -	index = VPIF_VIDEO_INDEX;
> -
> -	common = &ch->common[index];
> -
> -	if (0 != common->io_usrs)
> -		return -EBUSY;
> -
> -	/* Initialize videobuf2 queue as per the buffer type */
> -	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
> -	if (IS_ERR(common->alloc_ctx)) {
> -		vpif_err("Failed to get the context\n");
> -		return PTR_ERR(common->alloc_ctx);
> -	}
> -	q = &common->buffer_queue;
> -	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	q->io_modes = VB2_MMAP | VB2_USERPTR;
> -	q->drv_priv = fh;
> -	q->ops = &video_qops;
> -	q->mem_ops = &vb2_dma_contig_memops;
> -	q->buf_struct_size = sizeof(struct vpif_cap_buffer);
> -	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> -	q->min_buffers_needed = 1;
> -
> -	ret = vb2_queue_init(q);
> -	if (ret) {
> -		vpif_err("vpif_capture: vb2_queue_init() failed\n");
> -		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
> -		return ret;
> -	}
> -	/* Set io allowed member of file handle to TRUE */
> -	fh->io_allowed[index] = 1;
> -	/* Increment io usrs member of channel object to 1 */
> -	common->io_usrs = 1;
> -	/* Store type of memory requested in channel object */
> -	common->memory = reqbuf->memory;
> -	INIT_LIST_HEAD(&common->dma_queue);
> -
> -	/* Allocate buffers */
> -	return vb2_reqbufs(&common->buffer_queue, reqbuf);
> -}
> -
> -/**
> - * vpif_querybuf() - query buffer handler
> - * @file: file ptr
> - * @priv: file handle
> - * @buf: v4l2 buffer structure ptr
> - */
> -static int vpif_querybuf(struct file *file, void *priv,
> -				struct v4l2_buffer *buf)
> -{
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -
> -	vpif_dbg(2, debug, "vpif_querybuf\n");
> -
> -	if (common->fmt.type != buf->type)
> -		return -EINVAL;
> -
> -	if (common->memory != V4L2_MEMORY_MMAP) {
> -		vpif_dbg(1, debug, "Invalid memory\n");
> -		return -EINVAL;
> -	}
> -
> -	return vb2_querybuf(&common->buffer_queue, buf);
> -}
> -
> -/**
> - * vpif_qbuf() - query buffer handler
> - * @file: file ptr
> - * @priv: file handle
> - * @buf: v4l2 buffer structure ptr
> - */
> -static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -	struct v4l2_buffer tbuf = *buf;
> -
> -	vpif_dbg(2, debug, "vpif_qbuf\n");
> -
> -	if (common->fmt.type != tbuf.type) {
> -		vpif_err("invalid buffer type\n");
> -		return -EINVAL;
> -	}
> -
> -	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
> -		vpif_err("fh io not allowed\n");
> -		return -EACCES;
> -	}
> -
> -	return vb2_qbuf(&common->buffer_queue, buf);
> -}
> -
> -/**
> - * vpif_dqbuf() - query buffer handler
> - * @file: file ptr
> - * @priv: file handle
> - * @buf: v4l2 buffer structure ptr
> - */
> -static int vpif_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> -{
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -
> -	vpif_dbg(2, debug, "vpif_dqbuf\n");
> -
> -	return vb2_dqbuf(&common->buffer_queue, buf,
> -			 (file->f_flags & O_NONBLOCK));
> -}
> -
> -/**
> - * vpif_streamon() - streamon handler
> - * @file: file ptr
> - * @priv: file handle
> - * @buftype: v4l2 buffer type
> - */
> -static int vpif_streamon(struct file *file, void *priv,
> -				enum v4l2_buf_type buftype)
> -{
> -
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -	struct channel_obj *oth_ch = vpif_obj.dev[!ch->channel_id];
> -	struct vpif_params *vpif;
> -	int ret = 0;
> -
> -	vpif_dbg(2, debug, "vpif_streamon\n");
> -
> -	vpif = &ch->vpifparams;
> -
> -	if (buftype != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		vpif_dbg(1, debug, "buffer type not supported\n");
> -		return -EINVAL;
> -	}
> -
> -	/* If file handle is not allowed IO, return error */
> -	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
> -		vpif_dbg(1, debug, "io not allowed\n");
> -		return -EACCES;
> -	}
> -
> -	/* If Streaming is already started, return error */
> -	if (common->started) {
> -		vpif_dbg(1, debug, "channel->started\n");
> -		return -EBUSY;
> -	}
> -
> -	if ((ch->channel_id == VPIF_CHANNEL0_VIDEO &&
> -	    oth_ch->common[VPIF_VIDEO_INDEX].started &&
> -	    vpif->std_info.ycmux_mode == 0) ||
> -	   ((ch->channel_id == VPIF_CHANNEL1_VIDEO) &&
> -	    (2 == oth_ch->common[VPIF_VIDEO_INDEX].started))) {
> -		vpif_dbg(1, debug, "other channel is being used\n");
> -		return -EBUSY;
> -	}
> -
> -	ret = vpif_check_format(ch, &common->fmt.fmt.pix, 0);
> -	if (ret)
> -		return ret;
> -
> -	/* Enable streamon on the sub device */
> -	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
> -
> -	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
> -		vpif_dbg(1, debug, "stream on failed in subdev\n");
> -		return ret;
> -	}
> -
> -	/* Call vb2_streamon to start streaming in videobuf2 */
> -	ret = vb2_streamon(&common->buffer_queue, buftype);
> -	if (ret) {
> -		vpif_dbg(1, debug, "vb2_streamon\n");
> -		return ret;
> -	}
> -
> -	return ret;
> -}
> -
> -/**
> - * vpif_streamoff() - streamoff handler
> - * @file: file ptr
> - * @priv: file handle
> - * @buftype: v4l2 buffer type
> - */
> -static int vpif_streamoff(struct file *file, void *priv,
> -				enum v4l2_buf_type buftype)
> -{
> -
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -	int ret;
> -
> -	vpif_dbg(2, debug, "vpif_streamoff\n");
> -
> -	if (buftype != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> -		vpif_dbg(1, debug, "buffer type not supported\n");
> -		return -EINVAL;
> -	}
> -
> -	/* If io is allowed for this file handle, return error */
> -	if (!fh->io_allowed[VPIF_VIDEO_INDEX]) {
> -		vpif_dbg(1, debug, "io not allowed\n");
> -		return -EACCES;
> -	}
> -
> -	/* If streaming is not started, return error */
> -	if (!common->started) {
> -		vpif_dbg(1, debug, "channel->started\n");
> -		return -EINVAL;
> -	}
> -
> -	/* disable channel */
> -	if (VPIF_CHANNEL0_VIDEO == ch->channel_id) {
> -		enable_channel0(0);
> -		channel0_intr_enable(0);
> -	} else {
> -		enable_channel1(0);
> -		channel1_intr_enable(0);
> -	}
> -
> -	common->started = 0;
> -
> -	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
> -
> -	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
> -		vpif_dbg(1, debug, "stream off failed in subdev\n");
> -
> -	return vb2_streamoff(&common->buffer_queue, buftype);
> -}
> -
> -/**
>   * vpif_input_to_subdev() - Maps input to sub device
>   * @vpif_cfg - global config ptr
>   * @chan_cfg - channel config ptr
> @@ -1348,9 +929,9 @@ static int vpif_set_input(
>   */
>  static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -	int ret = 0;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
> +	int ret;
>  
>  	vpif_dbg(2, debug, "vpif_querystd\n");
>  
> @@ -1375,8 +956,8 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
>   */
>  static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  
>  	vpif_dbg(2, debug, "vpif_g_std\n");
>  
> @@ -1392,31 +973,15 @@ static int vpif_g_std(struct file *file, void *priv, v4l2_std_id *std)
>   */
>  static int vpif_s_std(struct file *file, void *priv, v4l2_std_id std_id)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -	int ret = 0;
> +	int ret;
>  
>  	vpif_dbg(2, debug, "vpif_s_std\n");
>  
> -	if (common->started) {
> -		vpif_err("streaming in progress\n");
> +	if (vb2_is_streaming(&common->buffer_queue))

This should be vb2_is_busy(). is_streaming is true when streaming is in progress,
is_busy is true once reqbufs()/create_buffers() is called since that's the moment
the format becomes locked and can no longer be changed.

>  		return -EBUSY;
> -	}
> -
> -	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
> -	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
> -		if (!fh->initialized) {
> -			vpif_dbg(1, debug, "Channel Busy\n");
> -			return -EBUSY;
> -		}
> -	}
> -
> -	ret = v4l2_prio_check(&ch->prio, fh->prio);
> -	if (0 != ret)
> -		return ret;
> -
> -	fh->initialized = 1;
>  
>  	/* Call encoder subdevice function to set the standard */
>  	ch->video.stdid = std_id;
> @@ -1452,8 +1017,8 @@ static int vpif_enum_input(struct file *file, void *priv,
>  
>  	struct vpif_capture_config *config = vpif_dev->platform_data;
>  	struct vpif_capture_chan_config *chan_cfg;
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  
>  	chan_cfg = &config->chan_config[ch->channel_id];
>  
> @@ -1475,8 +1040,8 @@ static int vpif_enum_input(struct file *file, void *priv,
>   */
>  static int vpif_g_input(struct file *file, void *priv, unsigned int *index)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  
>  	*index = ch->input_idx;
>  	return 0;
> @@ -1492,34 +1057,18 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
>  {
>  	struct vpif_capture_config *config = vpif_dev->platform_data;
>  	struct vpif_capture_chan_config *chan_cfg;
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
> -	int ret;
> +
> +	if (vb2_is_streaming(&common->buffer_queue))

vb2_is_busy()

> +		return -EBUSY;
>  
>  	chan_cfg = &config->chan_config[ch->channel_id];
>  
>  	if (index >= chan_cfg->input_count)
>  		return -EINVAL;
>  
> -	if (common->started) {
> -		vpif_err("Streaming in progress\n");
> -		return -EBUSY;
> -	}
> -
> -	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
> -	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
> -		if (!fh->initialized) {
> -			vpif_dbg(1, debug, "Channel Busy\n");
> -			return -EBUSY;
> -		}
> -	}
> -
> -	ret = v4l2_prio_check(&ch->prio, fh->prio);
> -	if (0 != ret)
> -		return ret;
> -
> -	fh->initialized = 1;
>  	return vpif_set_input(config, ch, index);
>  }
>  
> @@ -1532,8 +1081,8 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
>  static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
>  					struct v4l2_fmtdesc *fmt)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  
>  	if (fmt->index != 0) {
>  		vpif_dbg(1, debug, "Invalid format index\n");
> @@ -1562,8 +1111,8 @@ static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
>  static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *fmt)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
>  
>  	return vpif_check_format(ch, pixfmt, 1);
> @@ -1579,8 +1128,8 @@ static int vpif_try_fmt_vid_cap(struct file *file, void *priv,
>  static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *fmt)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
>  
>  	/* Check the validity of the buffer type */
> @@ -1601,8 +1150,8 @@ static int vpif_g_fmt_vid_cap(struct file *file, void *priv,
>  static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *fmt)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
>  	struct v4l2_pix_format *pixfmt;
>  	int ret = 0;
> @@ -1610,31 +1159,17 @@ static int vpif_s_fmt_vid_cap(struct file *file, void *priv,
>  	vpif_dbg(2, debug, "%s\n", __func__);
>  
>  	/* If streaming is started, return error */
> -	if (common->started) {
> +	if (vb2_is_streaming(&common->buffer_queue)) {

vb2_is_busy()

>  		vpif_dbg(1, debug, "Streaming is started\n");
>  		return -EBUSY;
>  	}
>  
> -	if ((VPIF_CHANNEL0_VIDEO == ch->channel_id) ||
> -	    (VPIF_CHANNEL1_VIDEO == ch->channel_id)) {
> -		if (!fh->initialized) {
> -			vpif_dbg(1, debug, "Channel Busy\n");
> -			return -EBUSY;
> -		}
> -	}
> -
> -	ret = v4l2_prio_check(&ch->prio, fh->prio);
> -	if (0 != ret)
> -		return ret;
> -
> -	fh->initialized = 1;
> -
>  	pixfmt = &fmt->fmt.pix;
>  	/* Check for valid field format */
>  	ret = vpif_check_format(ch, pixfmt, 0);

Once check_format is no longer called from start_streaming the check_format code
can be moved to vpif_try_fmt_vid_cap and vpif_s_fmt_vid_cap can call
vpif_try_fmt_vid_cap directly instead of check_formats.

> -
>  	if (ret)
>  		return ret;
> +
>  	/* store the format in the channel object */
>  	common->fmt = *fmt;
>  	return 0;
> @@ -1653,7 +1188,7 @@ static int vpif_querycap(struct file *file, void  *priv,
>  
>  	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;

You can add V4L2_CAP_READWRITE here if you add VB2_READ to q->io_modes and
add .read = vb2_fop_read to vpif_fops.

>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> -	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
> +	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
>  	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>  		 dev_name(vpif_dev));
>  	strlcpy(cap->card, config->card_name, sizeof(cap->card));
> @@ -1662,37 +1197,6 @@ static int vpif_querycap(struct file *file, void  *priv,
>  }
>  
>  /**
> - * vpif_g_priority() - get priority handler
> - * @file: file ptr
> - * @priv: file handle
> - * @prio: ptr to v4l2_priority structure
> - */
> -static int vpif_g_priority(struct file *file, void *priv,
> -			   enum v4l2_priority *prio)
> -{
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -
> -	*prio = v4l2_prio_max(&ch->prio);
> -
> -	return 0;
> -}
> -
> -/**
> - * vpif_s_priority() - set priority handler
> - * @file: file ptr
> - * @priv: file handle
> - * @prio: ptr to v4l2_priority structure
> - */
> -static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
> -{
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> -
> -	return v4l2_prio_change(&ch->prio, &fh->prio, p);
> -}
> -
> -/**
>   * vpif_cropcap() - cropcap handler
>   * @file: file ptr
>   * @priv: file handle
> @@ -1701,8 +1205,8 @@ static int vpif_s_priority(struct file *file, void *priv, enum v4l2_priority p)
>  static int vpif_cropcap(struct file *file, void *priv,
>  			struct v4l2_cropcap *crop)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
>  
>  	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != crop->type)

I would drop cropcap. First of all this driver doesn't support cropping,
so there is no need for cropcap, secondly it doesn't set pixelaspect
which is wrong anyway.

> @@ -1726,8 +1230,8 @@ static int
>  vpif_enum_dv_timings(struct file *file, void *priv,
>  		     struct v4l2_enum_dv_timings *timings)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	int ret;
>  

A general note for all dv_timings and std ioctls: if the current input or output
does not support the std or dv_timings ioctls, then -ENODATA should be returned.

So trying to call VIDIOC_G_DV_TIMINGS for an input that only supports SDTV or
calling G_STD for an input that only supports HDTV should result in -ENODATA.

Special care should be taken with ENUMSTD: that's handled by the v4l2 core and it
uses the videodev->tvnorms field. So that field should be updated whenever you
change inputs. See v4l2-pci-skeleton.c which actually implements that.

>  	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
> @@ -1746,8 +1250,8 @@ static int
>  vpif_query_dv_timings(struct file *file, void *priv,
>  		      struct v4l2_dv_timings *timings)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	int ret;
>  
>  	ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
> @@ -1765,8 +1269,8 @@ vpif_query_dv_timings(struct file *file, void *priv,
>  static int vpif_s_dv_timings(struct file *file, void *priv,
>  		struct v4l2_dv_timings *timings)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct vpif_params *vpifparams = &ch->vpifparams;
>  	struct vpif_channel_config_params *std_info = &vpifparams->std_info;
>  	struct video_obj *vid_ch = &ch->video;
> @@ -1853,8 +1357,8 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
>  static int vpif_g_dv_timings(struct file *file, void *priv,
>  		struct v4l2_dv_timings *timings)
>  {
> -	struct vpif_fh *fh = priv;
> -	struct channel_obj *ch = fh->channel;
> +	struct video_device *vdev = video_devdata(file);
> +	struct channel_obj *ch = video_get_drvdata(vdev);
>  	struct video_obj *vid_ch = &ch->video;
>  
>  	*timings = vid_ch->dv_timings;
> @@ -1879,49 +1383,46 @@ static int vpif_log_status(struct file *filep, void *priv)
>  
>  /* vpif capture ioctl operations */
>  static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
> -	.vidioc_querycap        	= vpif_querycap,
> -	.vidioc_g_priority		= vpif_g_priority,
> -	.vidioc_s_priority		= vpif_s_priority,
> +	.vidioc_querycap		= vpif_querycap,
>  	.vidioc_enum_fmt_vid_cap	= vpif_enum_fmt_vid_cap,
> -	.vidioc_g_fmt_vid_cap  		= vpif_g_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap		= vpif_g_fmt_vid_cap,
>  	.vidioc_s_fmt_vid_cap		= vpif_s_fmt_vid_cap,
>  	.vidioc_try_fmt_vid_cap		= vpif_try_fmt_vid_cap,
> +
>  	.vidioc_enum_input		= vpif_enum_input,
>  	.vidioc_s_input			= vpif_s_input,
>  	.vidioc_g_input			= vpif_g_input,
> -	.vidioc_reqbufs         	= vpif_reqbufs,
> -	.vidioc_querybuf        	= vpif_querybuf,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,

Add .vidioc_expbuf = vb2_ioctl_expbuf

That allows apps to export dmabuf buffers from this driver.

> +
>  	.vidioc_querystd		= vpif_querystd,
> -	.vidioc_s_std           	= vpif_s_std,
> +	.vidioc_s_std			= vpif_s_std,
>  	.vidioc_g_std			= vpif_g_std,
> -	.vidioc_qbuf            	= vpif_qbuf,
> -	.vidioc_dqbuf           	= vpif_dqbuf,
> -	.vidioc_streamon        	= vpif_streamon,
> -	.vidioc_streamoff       	= vpif_streamoff,
> -	.vidioc_cropcap         	= vpif_cropcap,
> -	.vidioc_enum_dv_timings         = vpif_enum_dv_timings,
> -	.vidioc_query_dv_timings        = vpif_query_dv_timings,
> -	.vidioc_s_dv_timings            = vpif_s_dv_timings,
> -	.vidioc_g_dv_timings            = vpif_g_dv_timings,
> +
> +	.vidioc_cropcap			= vpif_cropcap,
> +
> +	.vidioc_enum_dv_timings		= vpif_enum_dv_timings,
> +	.vidioc_query_dv_timings	= vpif_query_dv_timings,
> +	.vidioc_s_dv_timings		= vpif_s_dv_timings,
> +	.vidioc_g_dv_timings		= vpif_g_dv_timings,
> +
>  	.vidioc_log_status		= vpif_log_status,
>  };
>  
>  /* vpif file operations */
>  static struct v4l2_file_operations vpif_fops = {
> -	.owner = THIS_MODULE,
> -	.open = vpif_open,
> -	.release = vpif_release,
> -	.unlocked_ioctl = video_ioctl2,
> -	.mmap = vpif_mmap,
> -	.poll = vpif_poll
> -};
> -
> -/* vpif video template */
> -static struct video_device vpif_video_template = {
> -	.name		= "vpif",
> -	.fops		= &vpif_fops,
> -	.minor		= -1,
> -	.ioctl_ops	= &vpif_ioctl_ops,
> +	.owner		= THIS_MODULE,
> +	.open		= v4l2_fh_open,
> +	.release	= vb2_fop_release,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= vb2_fop_mmap,
> +	.poll		= vb2_fop_poll
>  };
>  
>  /**
> @@ -1999,7 +1500,9 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
>  static int vpif_probe_complete(void)
>  {
>  	struct common_obj *common;
> +	struct video_device *vdev;
>  	struct channel_obj *ch;
> +	struct vb2_queue *q;
>  	int i, j, err, k;
>  
>  	for (j = 0; j < VPIF_CAPTURE_MAX_DEVICES; j++) {
> @@ -2009,16 +1512,55 @@ static int vpif_probe_complete(void)
>  		spin_lock_init(&common->irqlock);
>  		mutex_init(&common->lock);
>  		ch->video_dev->lock = &common->lock;
> -		/* Initialize prio member of channel object */
> -		v4l2_prio_init(&ch->prio);
> -		video_set_drvdata(ch->video_dev, ch);
>  
>  		/* select input 0 */
>  		err = vpif_set_input(vpif_obj.config, ch, 0);
>  		if (err)
>  			goto probe_out;
>  
> -		err = video_register_device(ch->video_dev,
> +		/* Initialize vb2 queue */
> +		q = &common->buffer_queue;
> +		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		q->io_modes = VB2_MMAP | VB2_USERPTR;

Add VB2_DMABUF as well to get automatic DMABUF support.

> +		q->drv_priv = ch;
> +		q->ops = &video_qops;
> +		q->mem_ops = &vb2_dma_contig_memops;
> +		q->buf_struct_size = sizeof(struct vpif_cap_buffer);
> +		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +		q->min_buffers_needed = 3;

This is a bit too high. min_buffers_needed is the minimum number of buffers
required before you can start the DMA engine. Which for this device is either
1 or 2. I can't remember when the davinci DMA engine reads the pointer for
the next buffer to DMA: does that happen when the DMA engine is at the end
of the current frame or is that at the start of the current frame? In the
first case min_buffers_needed should be 1 so the DMA engine will start as
quickly as possible. In the second case it should be 2 since otherwise it
would most likely have to repeat the first frame.

> +		q->lock = &common->lock;
> +		q->gfp_flags = GFP_DMA32;

Does this make sense for a davinci? It doesn't support 64 bit DMA, so I
would just drop this.

> +
> +		err = vb2_queue_init(q);
> +		if (err) {
> +			vpif_err("vpif_display: vb2_queue_init() failed\n");
> +			vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
> +			goto probe_out;
> +		}
> +
> +		common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
> +		if (IS_ERR(common->alloc_ctx)) {
> +			vpif_err("Failed to get the context\n");
> +			err = PTR_ERR(common->alloc_ctx);
> +			goto probe_out;
> +		}
> +
> +		INIT_LIST_HEAD(&common->dma_queue);
> +
> +		/* Initialize the video_device structure */
> +		vdev = ch->video_dev;
> +		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
> +		vdev->release = video_device_release;
> +		vdev->fops = &vpif_fops;
> +		vdev->ioctl_ops = &vpif_ioctl_ops;
> +		vdev->lock = &common->lock;
> +		vdev->queue = q;
> +		vdev->v4l2_dev = &vpif_obj.v4l2_dev;
> +		vdev->vfl_dir = VFL_DIR_RX;
> +		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
> +		video_set_drvdata(vdev, ch);
> +
> +		err = video_register_device(vdev,
>  					    VFL_TYPE_GRABBER, (j ? 1 : 0));
>  		if (err)
>  			goto probe_out;
> @@ -2031,6 +1573,8 @@ probe_out:
>  	for (k = 0; k < j; k++) {
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[k];
> +		common = &ch->common[k];
> +		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>  		/* Unregister video device */
>  		video_unregister_device(ch->video_dev);
>  	}
> @@ -2085,7 +1629,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>  
>  	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
>  		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
> -					IRQF_SHARED, "VPIF_Capture",
> +					IRQF_SHARED, VPIF_DRIVER_NAME,
>  					(void *)(&vpif_obj.dev[res_idx]->
>  					channel_id));
>  		if (err) {
> @@ -2109,13 +1653,6 @@ static __init int vpif_probe(struct platform_device *pdev)
>  			goto vpif_unregister;
>  		}
>  
> -		/* Initialize field of video device */
> -		*vfd = vpif_video_template;
> -		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
> -		vfd->release = video_device_release;
> -		snprintf(vfd->name, sizeof(vfd->name),
> -			 "VPIF_Capture_DRIVER_V%s",
> -			 VPIF_CAPTURE_VERSION);
>  		/* Set video_dev to the video device */
>  		ch->video_dev = vfd;
>  	}
> @@ -2209,6 +1746,7 @@ vpif_unregister:
>   */
>  static int vpif_remove(struct platform_device *device)
>  {
> +	struct common_obj *common;
>  	struct channel_obj *ch;
>  	int i;
>  
> @@ -2219,6 +1757,8 @@ static int vpif_remove(struct platform_device *device)
>  	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
> +		common = &ch->common[i];
> +		vb2_dma_contig_cleanup_ctx(common->alloc_ctx);
>  		/* Unregister video device */
>  		video_unregister_device(ch->video_dev);
>  		kfree(vpif_obj.dev[i]);
> @@ -2226,13 +1766,12 @@ static int vpif_remove(struct platform_device *device)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  /**
>   * vpif_suspend: vpif device suspend
>   */
>  static int vpif_suspend(struct device *dev)
>  {
> -
>  	struct common_obj *common;
>  	struct channel_obj *ch;
>  	int i;
> @@ -2241,18 +1780,19 @@ static int vpif_suspend(struct device *dev)
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
>  		common = &ch->common[VPIF_VIDEO_INDEX];
> +
> +		if (!vb2_is_streaming(&common->buffer_queue))
> +			continue;
> +
>  		mutex_lock(&common->lock);
> -		if (ch->usrs && common->io_usrs) {
> -			/* Disable channel */
> -			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> -				enable_channel0(0);
> -				channel0_intr_enable(0);
> -			}
> -			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
> -			    common->started == 2) {
> -				enable_channel1(0);
> -				channel1_intr_enable(0);
> -			}
> +		/* Disable channel */
> +		if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> +			enable_channel0(0);
> +			channel0_intr_enable(0);
> +		}
> +		if (ch->channel_id == VPIF_CHANNEL1_VIDEO || ycmux_mode == 2) {
> +			enable_channel1(0);
> +			channel1_intr_enable(0);
>  		}
>  		mutex_unlock(&common->lock);
>  	}
> @@ -2273,18 +1813,19 @@ static int vpif_resume(struct device *dev)
>  		/* Get the pointer to the channel object */
>  		ch = vpif_obj.dev[i];
>  		common = &ch->common[VPIF_VIDEO_INDEX];
> +
> +		if (!vb2_is_streaming(&common->buffer_queue))
> +			continue;
> +
>  		mutex_lock(&common->lock);
> -		if (ch->usrs && common->io_usrs) {
> -			/* Disable channel */
> -			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> -				enable_channel0(1);
> -				channel0_intr_enable(1);
> -			}
> -			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
> -			    common->started == 2) {
> -				enable_channel1(1);
> -				channel1_intr_enable(1);
> -			}
> +		/* Enable channel */
> +		if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
> +			enable_channel0(1);
> +			channel0_intr_enable(1);
> +		}
> +		if (ch->channel_id == VPIF_CHANNEL1_VIDEO || ycmux_mode == 2) {
> +			enable_channel1(1);
> +			channel1_intr_enable(1);
>  		}
>  		mutex_unlock(&common->lock);
>  	}
> @@ -2292,21 +1833,15 @@ static int vpif_resume(struct device *dev)
>  	return 0;
>  }
>  
> -static const struct dev_pm_ops vpif_dev_pm_ops = {
> -	.suspend = vpif_suspend,
> -	.resume = vpif_resume,
> -};
> -
> -#define vpif_pm_ops (&vpif_dev_pm_ops)
> -#else
> -#define vpif_pm_ops NULL
>  #endif
>  
> +static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
> +
>  static __refdata struct platform_driver vpif_driver = {
>  	.driver	= {
> -		.name	= "vpif_capture",
> +		.name	= VPIF_DRIVER_NAME,
>  		.owner	= THIS_MODULE,
> -		.pm	= vpif_pm_ops,
> +		.pm	= &vpif_pm_ops,
>  	},
>  	.probe = vpif_probe,
>  	.remove = vpif_remove,
> diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
> index 5a29d9a..8af3b33 100644
> --- a/drivers/media/platform/davinci/vpif_capture.h
> +++ b/drivers/media/platform/davinci/vpif_capture.h
> @@ -19,8 +19,6 @@
>  #ifndef VPIF_CAPTURE_H
>  #define VPIF_CAPTURE_H
>  
> -#ifdef __KERNEL__
> -
>  /* Header files */
>  #include <media/videobuf2-dma-contig.h>
>  #include <media/v4l2-device.h>
> @@ -63,11 +61,6 @@ struct common_obj {
>  	struct vpif_cap_buffer *cur_frm;
>  	/* Pointer pointing to current v4l2_buffer */
>  	struct vpif_cap_buffer *next_frm;
> -	/*
> -	 * This field keeps track of type of buffer exchange mechanism
> -	 * user has selected
> -	 */
> -	enum v4l2_memory memory;
>  	/* Used to store pixel format */
>  	struct v4l2_format fmt;
>  	/* Buffer queue used in video-buf */
> @@ -80,12 +73,8 @@ struct common_obj {
>  	spinlock_t irqlock;
>  	/* lock used to access this structure */
>  	struct mutex lock;
> -	/* number of users performing IO */
> -	u32 io_usrs;
> -	/* Indicates whether streaming started */
> -	u8 started;
>  	/* Function pointer to set the addresses */
> -	void (*set_addr) (unsigned long, unsigned long, unsigned long,
> +	void (*set_addr)(unsigned long, unsigned long, unsigned long,
>  			  unsigned long);
>  	/* offset where Y top starts from the starting of the buffer */
>  	u32 ytop_off;
> @@ -104,14 +93,8 @@ struct common_obj {
>  struct channel_obj {
>  	/* Identifies video device for this channel */
>  	struct video_device *video_dev;
> -	/* Used to keep track of state of the priority */
> -	struct v4l2_prio_state prio;
> -	/* number of open instances of the channel */
> -	int usrs;
>  	/* Indicates id of the field which is being displayed */
>  	u32 field_id;
> -	/* flag to indicate whether decoder is initialized */
> -	u8 initialized;
>  	/* Identifies channel */
>  	enum vpif_channel_id channel_id;
>  	/* Current input */
> @@ -126,18 +109,6 @@ struct channel_obj {
>  	struct video_obj video;
>  };
>  
> -/* File handle structure */
> -struct vpif_fh {
> -	/* pointer to channel object for opened device */
> -	struct channel_obj *channel;
> -	/* Indicates whether this file handle is doing IO */
> -	u8 io_allowed[VPIF_NUMBER_OF_OBJECTS];
> -	/* Used to keep track priority of this instance */
> -	enum v4l2_priority prio;
> -	/* Used to indicate channel is initialize or not */
> -	u8 initialized;
> -};
> -
>  struct vpif_device {
>  	struct v4l2_device v4l2_dev;
>  	struct channel_obj *dev[VPIF_CAPTURE_NUM_CHANNELS];
> @@ -157,5 +128,4 @@ struct vpif_config_params {
>  	u8 max_device_type;
>  };
>  
> -#endif				/* End of __KERNEL__ */
>  #endif				/* VPIF_CAPTURE_H */
> 

Note that I'm not yet reviewing the vpif_display code. It's very similar to this
one, so many of my comments apply there as well.

Some of my comments are really about bugs/weirdness in the existing code. So
those should probably be fixed in separate patches.

Also, I would really appreciate it if you add the v4l2-compliance -s output when
you post the next patch series. I'd like to see that.

Regards,

	Hans
