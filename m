Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1386BC43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9388214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 14:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfCMOiw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:38:52 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:48721 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfCMOiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 10:38:52 -0400
Received: from [IPv6:2001:420:44c1:2579:e8a7:494:d652:7065] ([IPv6:2001:420:44c1:2579:e8a7:494:d652:7065])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 451qhlK7O4HFn451thPl6H; Wed, 13 Mar 2019 15:38:50 +0100
Subject: Re: [PATCH v5 21/23] media: vicodec: Register another node for
 stateless decoder
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-22-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e24bfdaf-2b81-328c-45f3-ae86caf25a86@xs4all.nl>
Date:   Wed, 13 Mar 2019 15:38:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190306211343.15302-22-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCUWq1bcOoe3Bv/gtOP2Eie3ldCkxKqfueIWCiAzalSK5bQJOVpJzxikBu678IUaozpv5cIE2PMhuGFYPG1cwHCg7AvafQmo3NY7231UP9NfUxgrk2Gg
 Novbscu+oDy8oHj1xEAHH7rfX6YRLZsiy0qDNQkTkPre5i0Gs0oPSRMqsR3J6PTmrgmdJ7UP2ETQgplUoWEH61YFqQUvAwN00VDMKrEb7W0ChWyL9z54N1ym
 y0SO6ElKNd7wntAF82swJZ+sPjkNo0EEhGW3hVONjGeXOhOpKbPoIi0YQ2QB/B5ZS2+aTI6bwSJo3Kt34oDI2Zi2f2eHWbMI7CsLh8IeTqTLJTRj+xl4F+fT
 v+CCePaN
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/6/19 10:13 PM, Dafna Hirschfeld wrote:
> Add stateless decoder instance field to the dev struct and
> register another node for the statelsess decoder.
> The stateless API for the node will be implemented in further patches.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/vicodec-core.c | 46 +++++++++++++++++--
>  1 file changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 6c9a41838d31..7733b22247b6 100644
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
> @@ -373,6 +375,9 @@ static void device_run(void *priv)
>  
>  	if (ctx->is_enc)
>  		v4l2_m2m_job_finish(dev->stateful_enc.m2m_dev, ctx->fh.m2m_ctx);
> +	else if (ctx->is_stateless)
> +		v4l2_m2m_job_finish(dev->stateless_dec.m2m_dev,
> +				    ctx->fh.m2m_ctx);
>  	else
>  		v4l2_m2m_job_finish(dev->stateful_dec.m2m_dev, ctx->fh.m2m_ctx);
>  }
> @@ -1494,8 +1499,14 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
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
> +	src_vq->supports_requests = ctx->is_stateless;
> +	src_vq->requires_requests = ctx->is_stateless;
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)
>  		return ret;
> @@ -1564,6 +1575,8 @@ static int vicodec_open(struct file *file)
>  
>  	if (vfd == &dev->stateful_enc.vfd)
>  		ctx->is_enc = true;
> +	else if (vfd == &dev->stateless_dec.vfd)
> +		ctx->is_stateless = true;
>  
>  	v4l2_fh_init(&ctx->fh, video_devdata(file));
>  	file->private_data = &ctx->fh;
> @@ -1576,6 +1589,8 @@ static int vicodec_open(struct file *file)
>  			  1, 31, 1, 20);
>  	v4l2_ctrl_new_std(hdl, &vicodec_ctrl_ops, V4L2_CID_FWHT_P_FRAME_QP,
>  			  1, 31, 1, 20);
> +	if (ctx->is_stateless)
> +		v4l2_ctrl_new_custom(hdl, &vicodec_ctrl_stateless_state, NULL);
>  	if (hdl->error) {
>  		rc = hdl->error;
>  		v4l2_ctrl_handler_free(hdl);
> @@ -1615,6 +1630,10 @@ static int vicodec_open(struct file *file)
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
> @@ -1751,6 +1770,10 @@ static int vicodec_probe(struct platform_device *pdev)
>  			      "stateful-decoder", false))
>  		goto unreg_sf_enc;
>  
> +	if (register_instance(dev, &dev->stateless_dec,
> +			      "videdev-stateless-dec", false))

Typo: this should be "stateless-decoder".

I'll make this change when I prepare the pull request.

Regards,

	Hans

> +		goto unreg_sf_dec;
> +
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	ret = v4l2_m2m_register_media_controller(dev->stateful_enc.m2m_dev,
>  						 &dev->stateful_enc.vfd,
> @@ -1768,23 +1791,36 @@ static int vicodec_probe(struct platform_device *pdev)
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
> @@ -1804,6 +1840,7 @@ static int vicodec_remove(struct platform_device *pdev)
>  	media_device_unregister(&dev->mdev);
>  	v4l2_m2m_unregister_media_controller(dev->stateful_enc.m2m_dev);
>  	v4l2_m2m_unregister_media_controller(dev->stateful_dec.m2m_dev);
> +	v4l2_m2m_unregister_media_controller(dev->stateless_dec.m2m_dev);
>  	media_device_cleanup(&dev->mdev);
>  #endif
>  
> @@ -1811,6 +1848,7 @@ static int vicodec_remove(struct platform_device *pdev)
>  	v4l2_m2m_release(dev->stateful_dec.m2m_dev);
>  	video_unregister_device(&dev->stateful_enc.vfd);
>  	video_unregister_device(&dev->stateful_dec.vfd);
> +	video_unregister_device(&dev->stateless_dec.vfd);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  
>  	return 0;
> 

