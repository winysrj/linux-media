Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32261 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2HAJTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 05:19:36 -0400
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8200E56KLOAR70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 10:20:12 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8200G5SKKLSD50@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 01 Aug 2012 10:19:34 +0100 (BST)
Message-id: <5018F4A5.2000200@samsung.com>
Date: Wed, 01 Aug 2012 11:19:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.6] Fix mem2mem_testdev querycap regression
References: <201208010932.33074.hverkuil@xs4all.nl>
In-reply-to: <201208010932.33074.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/01/2012 09:32 AM, Hans Verkuil wrote:
> Trival but important patch.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
> index 7efe9ad..0b91a5c 100644
> --- a/drivers/media/video/mem2mem_testdev.c
> +++ b/drivers/media/video/mem2mem_testdev.c
> @@ -431,7 +431,7 @@ static int vidioc_querycap(struct file *file, void *priv,
>  	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
>  	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
>  	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->bus_info));
> -	cap->capabilities = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  	return 0;
>  }

Oops, my bad. Thanks for fixing this Hans!

Regards,
Sylwester
