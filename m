Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC68C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCFF2084C
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 12:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BCFF2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbeLEM0L (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:26:11 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:44768 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbeLEM0L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 07:26:11 -0500
Received: from [IPv6:2001:420:44c1:2579:69e7:fb8a:bb15:8970] ([IPv6:2001:420:44c1:2579:69e7:fb8a:bb15:8970])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UWFdgMmj0UylNUWFggwbxf; Wed, 05 Dec 2018 13:26:09 +0100
Subject: Re: [PATCH 1/1] media: Add a Kconfig option for the Request API
To:     Sakari Ailus <sakari.ailus@linux.intel.com>, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <20181205122400.32384-1-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9226e44a-37a3-f312-05cf-631ee9b5e820@xs4all.nl>
Date:   Wed, 5 Dec 2018 13:26:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181205122400.32384-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfA24E9ibxYkgr6UfIqSPy2sV8HmQlAiLCQbNA/U1eU2X9TYBZeFZoJnvqB57VMbE0ubCrmLH7PzenZQbASalNs3GhQYMQZ9Aspf7pD+uhW4gu/+TtJyG
 K2zdBGDiVPsrkimQY1ZGYBtd/TVL1jmjxVSsUJxUYufSihYQ8bhG95a7+2oabyK6RW3E7q+diWrL9eRs0V8sAL+afKevPyHUdqeqc8ux58TjTIWSOQjGW8Az
 gkvVAEbp6EzIIErDkAmJLMSYgtPIuydeAdxPclThDRoaIEw7QZgE400nsoy/hqyL1eKV8agbQLbsJeKPgDQFt9ffLIxF+fAXx1k0cl2+Q0ZULAx83VEcholw
 zkUMUaCrRYT8V/zIPvRgOGXJ843LmhbR6PKONhYl8DqSkZjPgAhfhYf72NVmi7ZySNAo50/Q
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/05/18 13:24, Sakari Ailus wrote:
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

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

> ---
> I hope this covers now everything... I was thinking how to make the option
> name itself more worrisome but I couldn't come up with a better language
> that would be compact enough. The "(EXPERIMENTAL)" notion is a bit too
> worn to be effective. :-I
> 
> The patch can and should be reverted once we're entirely happy and
> confident with the API.
> 
>  drivers/media/Kconfig                           | 13 +++++++++++++
>  drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 ++
>  drivers/media/media-device.c                    |  2 ++
>  drivers/staging/media/sunxi/cedrus/Kconfig      |  1 +
>  4 files changed, 18 insertions(+)
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
> index bed24372e61f..2ef114ce38d0 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -381,7 +381,9 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  static long media_device_request_alloc(struct media_device *mdev,
>  				       int *alloc_fd)
>  {
> +#ifndef CONFIG_MEDIA_CONTROLLER_REQUEST_API
>  	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
> +#endif
>  		return -ENOTTY;
>  
>  	return media_request_alloc(mdev, alloc_fd);
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
> 

