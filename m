Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37671 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935621Ab3DHNVC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 09:21:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKX00DU4U8NR290@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Apr 2013 14:21:01 +0100 (BST)
Message-id: <5162C43A.80702@samsung.com>
Date: Mon, 08 Apr 2013 15:20:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix s5c73m3-core.c compiler warning
References: <201304081110.34877.hverkuil@xs4all.nl>
In-reply-to: <201304081110.34877.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2013 11:10 AM, Hans Verkuil wrote:
> Fix for this compiler warning:
> 
>   CC [M]  drivers/media/i2c/s5c73m3/s5c73m3-core.o
> drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_load_fw’:
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:360:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat]
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks Hans, I somehow overlooked this in the daily build logs.
Kamil will include this patch in his pull request.

> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index 5dbb65e..b353c50 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -357,7 +357,7 @@ static int s5c73m3_load_fw(struct v4l2_subdev *sd)
>  		return -EINVAL;
>  	}
>  
> -	v4l2_info(sd, "Loading firmware (%s, %d B)\n", fw_name, fw->size);
> +	v4l2_info(sd, "Loading firmware (%s, %zu B)\n", fw_name, fw->size);
>  
>  	ret = s5c73m3_spi_write(state, fw->data, fw->size, 64);

Regards,
Sylwester
