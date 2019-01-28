Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC4EC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA5020880
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 09:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfA1Jci (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:32:38 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41076 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbfA1Jci (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 04:32:38 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id o3HNglhvHBDyIo3HQgnMLf; Mon, 28 Jan 2019 10:32:36 +0100
Subject: Re: [PATCH 3/3] media: vicodec: Register another node for stateless
 decoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190126134759.97680-1-dafna3@gmail.com>
 <20190126134759.97680-4-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0a370aea-7cba-4577-538e-1166b3279307@xs4all.nl>
Date:   Mon, 28 Jan 2019 10:32:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190126134759.97680-4-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfD2kFnxpI5npMCY3pZYNexIHQP9fGwGETYijuIeeZAcXOEd2O7WC2CDFTtjR+BMnC5xs07RcDTkJR6NMCBwxrBL7I0zl13Sx14OvDsZHoySdtiuWBuqJ
 RdTAIhph+wjPQuQKZ1T1MsuVvNqZ9rKF6Rn/f/JSJ4hFcMuLRMh2BgiRfZPtZMDLar1eWf4uKxGYrSBJUjwPcayUE5drASLvwPXvpb8vo6mSognK/8nmgzIS
 +jssGphSSCm/82c587kJAA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/26/19 2:47 PM, Dafna Hirschfeld wrote:
> Add stateless decoder instance field to the dev struct and
> register another node for the statelsess decoder.
> The stateless API for the node will be implemented in further patches.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 56 +++++++++++++++++--
>  1 file changed, 51 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 25831d992681..7c2ad7d5f356 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -104,6 +104,7 @@ struct vicodec_dev {
>  	struct v4l2_device	v4l2_dev;
>  	struct vicodec_dev_instance enc_instance;
>  	struct vicodec_dev_instance dec_instance;
> +	struct vicodec_dev_instance stateless_dec_instance;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_device	mdev;
>  #endif
> @@ -114,6 +115,7 @@ struct vicodec_ctx {
>  	struct v4l2_fh		fh;
>  	struct vicodec_dev	*dev;
>  	bool			is_enc;
> +	bool			is_stateless_dec;

I'd just call this 'is_stateless', since the same will be needed for the
future stateless encoder.

>  	spinlock_t		*lock;
>  
>  	struct v4l2_ctrl_handler hdl;
> @@ -314,6 +316,9 @@ static void device_run(void *priv)
>  
>  	if (ctx->is_enc)
>  		v4l2_m2m_job_finish(dev->enc_instance.m2m_dev, ctx->fh.m2m_ctx);
> +	else if (ctx->is_stateless_dec)
> +		v4l2_m2m_job_finish(dev->stateless_dec_instance.m2m_dev,
> +				    ctx->fh.m2m_ctx);
>  	else
>  		v4l2_m2m_job_finish(dev->dec_instance.m2m_dev, ctx->fh.m2m_ctx);
>  }
> @@ -1444,8 +1449,13 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &vicodec_qops;
>  	src_vq->mem_ops = &vb2_vmalloc_memops;
>  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	src_vq->lock = ctx->is_enc ? &ctx->dev->enc_instance.mutex :
> -		&ctx->dev->dec_instance.mutex;
> +	if (ctx->is_enc)
> +		src_vq->lock = &ctx->dev->enc_instance.mutex;
> +	else if (ctx->is_stateless_dec)
> +		src_vq->lock = &ctx->dev->stateless_dec_instance.mutex;
> +	else
> +		src_vq->lock = &ctx->dev->dec_instance.mutex;
> +	src_vq->supports_requests = ctx->is_stateless_dec ? true : false;
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
>  		return ret;
> @@ -1543,6 +1553,8 @@ static int vicodec_open(struct file *file)
>  
>  	if (vfd == &dev->enc_instance.vfd)
>  		ctx->is_enc = true;
> +	else if (vfd == &dev->stateless_dec_instance.vfd)
> +		ctx->is_stateless_dec = true;
>  
>  	v4l2_fh_init(&ctx->fh, video_devdata(file));
>  	file->private_data = &ctx->fh;
> @@ -1553,6 +1565,7 @@ static int vicodec_open(struct file *file)
>  			  1, 16, 1, 10);
>  	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_i_frame, NULL);
>  	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_p_frame, NULL);
> +	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_stateless_state, NULL);

This should only be added if this is the stateless decoder.

>  	if (hdl->error) {
>  		rc = hdl->error;
>  		v4l2_ctrl_handler_free(hdl);
> @@ -1592,6 +1605,10 @@ static int vicodec_open(struct file *file)
>  		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->enc_instance.m2m_dev,
>  						    ctx, &queue_init);
>  		ctx->lock = &dev->enc_instance.lock;
> +	} else if (ctx->is_stateless_dec) {
> +		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateless_dec_instance.m2m_dev,
> +						    ctx, &queue_init);
> +		ctx->lock = &dev->stateless_dec_instance.lock;
>  	} else {
>  		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->dec_instance.m2m_dev,
>  						    ctx, &queue_init);
> @@ -1697,6 +1714,7 @@ static int vicodec_probe(struct platform_device *pdev)
>  
>  	spin_lock_init(&dev->enc_instance.lock);
>  	spin_lock_init(&dev->dec_instance.lock);
> +	spin_lock_init(&dev->stateless_dec_instance.lock);
>  
>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
> @@ -1711,6 +1729,7 @@ static int vicodec_probe(struct platform_device *pdev)
>  
>  	mutex_init(&dev->enc_instance.mutex);
>  	mutex_init(&dev->dec_instance.mutex);
> +	mutex_init(&dev->stateless_dec_instance.mutex);

Why not init the mutex and the spinlock in register_instance()?

The same for v4l2_m2m_ctx_init().

Regards,

	Hans

>  
>  	platform_set_drvdata(pdev, dev);
>  
> @@ -1728,14 +1747,25 @@ static int vicodec_probe(struct platform_device *pdev)
>  		goto err_enc_m2m;
>  	}
>  
> +	dev->stateless_dec_instance.m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(dev->stateless_dec_instance.m2m_dev)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init vicodec stateless dec device\n");
> +		ret = PTR_ERR(dev->stateless_dec_instance.m2m_dev);
> +		goto err_dec_m2m;
> +	}
> +
>  	if (register_instance(dev, &dev->enc_instance,
>  			      "videdev-enc", true))
> -		goto err_dec_m2m;
> +		goto err_sdec_m2m;
>  
>  	if (register_instance(dev, &dev->dec_instance,
>  			      "videdev-statefull-dec", false))
>  		goto unreg_enc;
>  
> +	if (register_instance(dev, &dev->stateless_dec_instance,
> +			      "videdev-stateless-dec", false))
> +		goto unreg_dec;
> +
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	ret = v4l2_m2m_register_media_controller(dev->enc_instance.m2m_dev,
>  						 &dev->enc_instance.vfd,
> @@ -1753,24 +1783,38 @@ static int vicodec_probe(struct platform_device *pdev)
>  		goto unreg_m2m_enc_mc;
>  	}
>  
> +	ret = v4l2_m2m_register_media_controller(dev->stateless_dec_instance.m2m_dev,
> +						 &dev->stateless_dec_instance.vfd,
> +						 MEDIA_ENT_F_PROC_VIDEO_DECODER);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for stateless dec\n");
> +		goto unreg_m2m_dec_mc;
> +	}
> +
>  	ret = media_device_register(&dev->mdev);
>  	if (ret) {
>  		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
> -		goto unreg_m2m_dec_mc;
> +		goto unreg_m2m_sdec_mc;
>  	}
>  #endif
>  	return 0;
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
> +unreg_m2m_sdec_mc:
> +	v4l2_m2m_unregister_media_controller(dev->stateless_dec_instance.m2m_dev);
>  unreg_m2m_dec_mc:
>  	v4l2_m2m_unregister_media_controller(dev->dec_instance.m2m_dev);
>  unreg_m2m_enc_mc:
>  	v4l2_m2m_unregister_media_controller(dev->enc_instance.m2m_dev);
>  unreg_m2m:
> -	video_unregister_device(&dev->dec_instance.vfd);
> +	video_unregister_device(&dev->stateless_dec_instance.vfd);
>  #endif
> +unreg_dec:
> +	video_unregister_device(&dev->dec_instance.vfd);
>  unreg_enc:
>  	video_unregister_device(&dev->enc_instance.vfd);
> +err_sdec_m2m:
> +	v4l2_m2m_release(dev->stateless_dec_instance.m2m_dev);
>  err_dec_m2m:
>  	v4l2_m2m_release(dev->dec_instance.m2m_dev);
>  err_enc_m2m:
> @@ -1791,6 +1835,7 @@ static int vicodec_remove(struct platform_device *pdev)
>  	media_device_unregister(&dev->mdev);
>  	v4l2_m2m_unregister_media_controller(dev->enc_instance.m2m_dev);
>  	v4l2_m2m_unregister_media_controller(dev->dec_instance.m2m_dev);
> +	v4l2_m2m_unregister_media_controller(dev->stateless_dec_instance.m2m_dev);
>  	media_device_cleanup(&dev->mdev);
>  #endif
>  
> @@ -1798,6 +1843,7 @@ static int vicodec_remove(struct platform_device *pdev)
>  	v4l2_m2m_release(dev->dec_instance.m2m_dev);
>  	video_unregister_device(&dev->enc_instance.vfd);
>  	video_unregister_device(&dev->dec_instance.vfd);
> +	video_unregister_device(&dev->stateless_dec_instance.vfd);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	return 0;
> 

