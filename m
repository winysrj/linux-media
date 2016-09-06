Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35026 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755536AbcIFK2E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 06:28:04 -0400
Received: by mail-lf0-f41.google.com with SMTP id l131so49143396lfl.2
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2016 03:28:03 -0700 (PDT)
Date: Tue, 6 Sep 2016 12:28:00 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Move subdev operations from HGO to common
 histogram code
Message-ID: <20160906102759.GG27014@bigcity.dyn.berto.se>
References: <1473088419-2800-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1473088419-2800-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your patch.

On 2016-09-05 18:13:39 +0300, Laurent Pinchart wrote:
> The code will be shared with the HGT entity, move it to the generic
> histogram implementation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drv.c   |   7 +-
>  drivers/media/platform/vsp1/vsp1_hgo.c   | 308 ++--------------------------
>  drivers/media/platform/vsp1/vsp1_hgo.h   |   7 +-
>  drivers/media/platform/vsp1/vsp1_histo.c | 334 +++++++++++++++++++++++++++++--
>  drivers/media/platform/vsp1/vsp1_histo.h |  25 ++-
>  5 files changed, 355 insertions(+), 326 deletions(-)
> 

<snip>

>  int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
> -			const char *name, size_t data_size, u32 format)
> +			enum vsp1_entity_type type, const char *name,
> +			const struct vsp1_entity_operations *ops,
> +			const unsigned int *formats, unsigned int num_formats,
> +			size_t data_size, u32 meta_format)
>  {
>  	int ret;
>  
> -	histo->vsp1 = vsp1;
> +	histo->formats = formats;
> +	histo->num_formats = num_formats;
>  	histo->data_size = data_size;
> -	histo->format = format;
> +	histo->meta_format = meta_format;
>  
>  	histo->pad.flags = MEDIA_PAD_FL_SINK;
>  	histo->video.vfl_dir = VFL_DIR_RX;
> @@ -268,7 +559,16 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
>  	INIT_LIST_HEAD(&histo->irqqueue);
>  	init_waitqueue_head(&histo->wait_queue);
>  
> -	/* Initialize the media entity... */
> +	/* Initialize the VSP entity... */
> +	histo->entity.ops = ops;
> +	histo->entity.type = type;
> +
> +	ret = vsp1_entity_init(vsp1, &histo->entity, name, 2, &histo_ops,
> +			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* ... and the media entity... */
>  	ret = media_entity_pads_init(&histo->video.entity, 1, &histo->pad);
>  	if (ret < 0)
>  		return ret;


You forgot to update the histo video device name to match the subdevice 
name here. Something like this makes vsp-tests work for me again.

@@ -577,7 +577,7 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
        histo->video.v4l2_dev = &vsp1->v4l2_dev;
        histo->video.fops = &histo_v4l2_fops;
        snprintf(histo->video.name, sizeof(histo->video.name),
-                "%s histo", name);
+                "%s histo", histo->entity.subdev.name);
        histo->video.vfl_type = VFL_TYPE_GRABBER;
        histo->video.release = video_device_release_empty;
        histo->video.ioctl_ops = &histo_v4l2_ioctl_ops;

Without this fix the names listed using media-ctl -p show:

- entity 1: hgo histo (1 pad, 1 link)

Instead as it did before:

- entity 1: fe928000.vsp1 hgo histo (1 pad, 1 link)

Other then that

Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> @@ -293,10 +593,10 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
>  	histo->queue.ops = &histo_video_queue_qops;
>  	histo->queue.mem_ops = &vb2_vmalloc_memops;
>  	histo->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	histo->queue.dev = histo->vsp1->dev;
> +	histo->queue.dev = vsp1->dev;
>  	ret = vb2_queue_init(&histo->queue);
>  	if (ret < 0) {
> -		dev_err(histo->vsp1->dev, "failed to initialize vb2 queue\n");
> +		dev_err(vsp1->dev, "failed to initialize vb2 queue\n");
>  		goto error;
>  	}
>  
> @@ -304,7 +604,7 @@ int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
>  	histo->video.queue = &histo->queue;
>  	ret = video_register_device(&histo->video, VFL_TYPE_GRABBER, -1);
>  	if (ret < 0) {
> -		dev_err(histo->vsp1->dev, "failed to register video device\n");
> +		dev_err(vsp1->dev, "failed to register video device\n");
>  		goto error;
>  	}
>  
> @@ -314,11 +614,3 @@ error:
>  	vsp1_histogram_cleanup(histo);
>  	return ret;
>  }
> -
> -void vsp1_histogram_cleanup(struct vsp1_histogram *histo)
> -{
> -	if (video_is_registered(&histo->video))
> -		video_unregister_device(&histo->video);
> -
> -	media_entity_cleanup(&histo->video.entity);
> -}

<snip>

-- 
Regards,
Niklas Söderlund
