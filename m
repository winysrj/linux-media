Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75172C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 08:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4973420863
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 08:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfBKIbu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:31:50 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:36081 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbfBKIbu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 03:31:50 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t70CgrDIfRO5Zt70Gg2mR7; Mon, 11 Feb 2019 09:31:48 +0100
Subject: Re: [PATCH 6/9] media: vicodec: Register another node for stateless
 decoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190209135427.20630-1-dafna3@gmail.com>
 <20190209135427.20630-7-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <33df3192-d088-70e3-329f-2be45b273e26@xs4all.nl>
Date:   Mon, 11 Feb 2019 09:31:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190209135427.20630-7-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAmfacy3b+2+mdQmkigDMaYEwLfJ5NEJEPAylGt2eSWF/9OPNNJHUNOPLyPjKztLSrgjNyt8VGQCmhu3FPc9j3/Xj7JZj0o/4PovPXB6OZjzRXXUZl98
 s1d12J7XzI6m/gAdEwbv+3N5r7+kgWHX+lL3Y7L7yAAAs3p3Wcwv1CSEzktfACsWFVDuVCwkogYfnFw5JQ3PPe8t0xQod8jGSAPjIE4daMSzwbM1gNHjev5L
 yLBY0K47nuKTwMJdGb1kBg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/9/19 2:54 PM, Dafna Hirschfeld wrote:
> Add stateless decoder instance field to the dev struct and
> register another node for the statelsess decoder.
> The stateless API for the node will be implemented in further patches.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 45 +++++++++++++++++--
>  1 file changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 95276c09cb9a..324ce566478e 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -104,6 +104,7 @@ struct vicodec_dev {
>  	struct v4l2_device	v4l2_dev;
>  	struct vicodec_dev_instance stateful_enc;
>  	struct vicodec_dev_instance stateful_dec;
> +	struct vicodec_dev_instance stateless_dec;
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	struct media_device	mdev;
>  #endif
> @@ -114,6 +115,7 @@ struct vicodec_ctx {
>  	struct v4l2_fh		fh;
>  	struct vicodec_dev	*dev;
>  	bool			is_enc;
> +	bool			is_stateless;
>  	spinlock_t		*lock;
>  
>  	struct v4l2_ctrl_handler hdl;
> @@ -317,6 +319,9 @@ static void device_run(void *priv)
>  
>  	if (ctx->is_enc)
>  		v4l2_m2m_job_finish(dev->stateful_enc.m2m_dev, ctx->fh.m2m_ctx);
> +	else if (ctx->is_stateless)
> +		v4l2_m2m_job_finish(dev->stateless_dec.m2m_dev,
> +				    ctx->fh.m2m_ctx);
>  	else
>  		v4l2_m2m_job_finish(dev->stateful_dec.m2m_dev, ctx->fh.m2m_ctx);
>  }
> @@ -1461,8 +1466,13 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->ops = &vicodec_qops;
>  	src_vq->mem_ops = &vb2_vmalloc_memops;
>  	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	src_vq->lock = ctx->is_enc ? &ctx->dev->stateful_enc.mutex :
> -		&ctx->dev->stateful_dec.mutex;
> +	if (ctx->is_enc)
> +		src_vq->lock = &ctx->dev->stateful_enc.mutex;
> +	else if (ctx->is_stateless)
> +		src_vq->lock = &ctx->dev->stateless_dec.mutex;
> +	else
> +		src_vq->lock = &ctx->dev->stateful_dec.mutex;
> +	src_vq->supports_requests = ctx->is_stateless ? true : false;
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
>  		return ret;
> @@ -1560,6 +1570,8 @@ static int vicodec_open(struct file *file)
>  
>  	if (vfd == &dev->stateful_enc.vfd)
>  		ctx->is_enc = true;
> +	else if (vfd == &dev->stateless_dec.vfd)
> +		ctx->is_stateless = true;
>  
>  	v4l2_fh_init(&ctx->fh, video_devdata(file));
>  	file->private_data = &ctx->fh;
> @@ -1570,6 +1582,8 @@ static int vicodec_open(struct file *file)
>  			  1, 16, 1, 10);
>  	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_i_frame, NULL);
>  	v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_p_frame, NULL);
> +	if (ctx->is_stateless)
> +		v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_stateless_state, NULL);
>  	if (hdl->error) {
>  		rc = hdl->error;
>  		v4l2_ctrl_handler_free(hdl);
> @@ -1609,6 +1623,10 @@ static int vicodec_open(struct file *file)
>  		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateful_enc.m2m_dev,
>  						    ctx, &queue_init);
>  		ctx->lock = &dev->stateful_enc.lock;
> +	} else if (ctx->is_stateless) {
> +		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateless_dec.m2m_dev,
> +						    ctx, &queue_init);
> +		ctx->lock = &dev->stateless_dec.lock;
>  	} else {
>  		ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->stateful_dec.m2m_dev,
>  						    ctx, &queue_init);
> @@ -1744,6 +1762,10 @@ static int vicodec_probe(struct platform_device *pdev)
>  			      "videdev-statefull-dec", false))
>  		goto unreg_sf_enc;
>  
> +	if (register_instance(dev, &dev->stateless_dec,
> +			      "videdev-stateless-dec", false))

This becomes: "stateless-decoder"

Regards,

	Hans

> +		goto unreg_sf_dec;
> +
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	ret = v4l2_m2m_register_media_controller(dev->stateful_enc.m2m_dev,
>  						 &dev->stateful_enc.vfd,
> @@ -1761,23 +1783,36 @@ static int vicodec_probe(struct platform_device *pdev)
>  		goto unreg_m2m_sf_enc_mc;
>  	}
>  
> +	ret = v4l2_m2m_register_media_controller(dev->stateless_dec.m2m_dev,
> +						 &dev->stateless_dec.vfd,
> +						 MEDIA_ENT_F_PROC_VIDEO_DECODER);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller for stateless dec\n");
> +		goto unreg_m2m_sf_dec_mc;
> +	}
> +
>  	ret = media_device_register(&dev->mdev);
>  	if (ret) {
>  		v4l2_err(&dev->v4l2_dev, "Failed to register mem2mem media device\n");
> -		goto unreg_m2m_sf_dec_mc;
> +		goto unreg_m2m_sl_dec_mc;
>  	}
>  #endif
>  	return 0;
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER
> +unreg_m2m_sl_dec_mc:
> +	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
>  unreg_m2m_sf_dec_mc:
>  	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
>  unreg_m2m_sf_enc_mc:
>  	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
>  unreg_m2m:
> +	video_unregister_device(&dev->stateless_dec.vfd);
> +	v4l2_m2m_release(dev->stateless_dec.m2m_dev);
> +#endif
> +unreg_sf_dec:
>  	video_unregister_device(&dev->stateful_dec.vfd);
>  	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
> -#endif
>  unreg_sf_enc:
>  	video_unregister_device(&dev->stateful_enc.vfd);
>  	v4l2_m2m_release(dev->stateful_enc.m2m_dev);
> @@ -1797,6 +1832,7 @@ static int vicodec_remove(struct platform_device *pdev)
>  	media_device_unregister(&dev->mdev);
>  	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
>  	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
> +	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
>  	media_device_cleanup(&dev->mdev);
>  #endif
>  
> @@ -1804,6 +1840,7 @@ static int vicodec_remove(struct platform_device *pdev)
>  	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
>  	video_unregister_device(&dev->stateful_enc.vfd);
>  	video_unregister_device(&dev->stateful_dec.vfd);
> +	video_unregister_device(&dev->stateless_dec.vfd);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	return 0;
> 

