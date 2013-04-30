Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34649 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3D3IqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 04:46:21 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MM200CH07ZETR60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Apr 2013 09:46:19 +0100 (BST)
Message-id: <517F84DA.50503@samsung.com>
Date: Tue, 30 Apr 2013 10:46:18 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] s5c73m3: Fix off-by-one valid range checking for
 fie->index
References: <1367296936.5772.2.camel@phoenix>
In-reply-to: <1367296936.5772.2.camel@phoenix>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Axel,

Thanks for the fix.


On 30.04.2013 06:42, Axel Lin wrote:
> Current code uses fie->index as array subscript, thus the valid value range
> is 0 ... ARRAY_SIZE(s5c73m3_intervals) - 1.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>   drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index b353c50..cd365bb 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -956,7 +956,7 @@ static int s5c73m3_oif_enum_frame_interval(struct v4l2_subdev *sd,
>   
>   	if (fie->pad != OIF_SOURCE_PAD)
>   		return -EINVAL;
> -	if (fie->index > ARRAY_SIZE(s5c73m3_intervals))
> +	if (fie->index >= ARRAY_SIZE(s5c73m3_intervals))
>   		return -EINVAL;
>   
>   	mutex_lock(&state->lock);

