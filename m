Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A802C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 17:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22DAA213A2
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544032514;
	bh=w5xZndrWRCV6l+DPdTY9y772dodn4NjwmzQ805J04Eo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=hMe8J1Wyu84el+LKm226WaBaH7owp9z5wo7W8u4Fvby+p4zfzRVvROuk6yRJbp3s2
	 yIo2HR5dKZz5pL0wS6PNFFGn6ch1p4ECDOggWwMe5Qvc+tr2I3Toz0pO+hsNE+0EHo
	 pQU4HWQ/0rJBBE+MTKmN+tbg66FHLHwV/tiKcIsk=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22DAA213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbeLERzN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 12:55:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:37114 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbeLERzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 12:55:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ly4uw19fvVwBbiOognAT7YhfV4AcIAvUCG6OOl2xnL4=; b=HAUV48diHPWawggLUzAgeXAVUm
        uY5ZfOlfjsbEoGv8aeZpEshrgJuZa+HxLJuJGtyZfWhanGw9Ma5YFfhCOQnTpre1YCLwr/DAnliY7
        C13QewqNvhrE2SQGwsOgyee0qlqzyxZv1dhSbMiMQQ/Glow2vfXLo2MnDSvETVgJOGw5q3iZtOk1/
        etiIsyNLm02CC0dDE/35d5ABW4JLZVu4A/jmARJjS4iG5J7h6O1a7a34SraqnzkfZmd+8uU5XJ7d7
        KeujN560kImTbA5PAagZr9zr8ltpehsZycyH4hXSmU/86PKhyXWE9eZp5dnEkuvpVmrYwoRUZ2u6/
        /CG23JVQ==;
Received: from 201.86.173.17.dynamic.adsl.gvt.net.br ([201.86.173.17] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gUbOB-0002hz-6n; Wed, 05 Dec 2018 17:55:11 +0000
Date:   Wed, 5 Dec 2018 15:55:07 -0200
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 1/1] media: Add a Kconfig option for the Request API
Message-ID: <20181205155507.1bae41ed@coco.lan>
In-Reply-To: <20181205172354.32372-1-sakari.ailus@linux.intel.com>
References: <20181205172354.32372-1-sakari.ailus@linux.intel.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed,  5 Dec 2018 19:23:54 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> The Request API is now merged to the kernel but the confidence on the
> stability of that API is not great, especially regarding the interaction
> with V4L2.
> 
> Add a Kconfig option for the API, with a scary-looking warning.
> 
> The patch itself disables request creation as well as does not advertise
> them as buffer flags. The driver requiring requests (cedrus) now depends
> on the Kconfig option as well.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Looks good to me. I'll apply it.

> ---
> since v1:
> 
> - Write out the #ifdef's in request creation
> 
> - The option's functionality was reversed in request creation, fixed that
> 
>  drivers/media/Kconfig                           | 13 +++++++++++++
>  drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 ++
>  drivers/media/media-device.c                    |  4 ++++
>  drivers/staging/media/sunxi/cedrus/Kconfig      |  1 +
>  4 files changed, 20 insertions(+)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 8add62a18293..102eb35fcf3f 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -110,6 +110,19 @@ config MEDIA_CONTROLLER_DVB
>  
>  	  This is currently experimental.
>  
> +config MEDIA_CONTROLLER_REQUEST_API
> +	bool "Enable Media controller Request API (EXPERIMENTAL)"
> +	depends on MEDIA_CONTROLLER && STAGING_MEDIA
> +	default n
> +	---help---
> +	  DO NOT ENABLE THIS OPTION UNLESS YOU KNOW WHAT YOU'RE DOING.
> +
> +	  This option enables the Request API for the Media controller and V4L2
> +	  interfaces. It is currently needed by a few stateless codec drivers.
> +
> +	  There is currently no intention to provide API or ABI stability for
> +	  this new API as of yet.
> +
>  #
>  # Video4Linux support
>  #	Only enables if one of the V4L2 types (ATV, webcam, radio) is selected
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 1244c246d0c4..83c3c0c49e56 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -630,8 +630,10 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
>  		*caps |= V4L2_BUF_CAP_SUPPORTS_USERPTR;
>  	if (q->io_modes & VB2_DMABUF)
>  		*caps |= V4L2_BUF_CAP_SUPPORTS_DMABUF;
> +#ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
>  	if (q->supports_requests)
>  		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
> +#endif
>  }
>  
>  int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index bed24372e61f..b8ec88612df7 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -381,10 +381,14 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  static long media_device_request_alloc(struct media_device *mdev,
>  				       int *alloc_fd)
>  {
> +#ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
>  	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
>  		return -ENOTTY;
>  
>  	return media_request_alloc(mdev, alloc_fd);
> +#else
> +	return -ENOTTY;
> +#endif
>  }
>  
>  static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
> diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
> index a7a34e89c42d..3252efa422f9 100644
> --- a/drivers/staging/media/sunxi/cedrus/Kconfig
> +++ b/drivers/staging/media/sunxi/cedrus/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_SUNXI_CEDRUS
>  	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
>  	depends on HAS_DMA
>  	depends on OF
> +	depends on MEDIA_CONTROLLER_REQUEST_API
>  	select SUNXI_SRAM
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_MEM2MEM_DEV



Thanks,
Mauro
