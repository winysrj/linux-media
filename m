Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:60564 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbbFELgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 07:36:51 -0400
Message-ID: <557189C8.7040203@xs4all.nl>
Date: Fri, 05 Jun 2015 13:36:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxx <maxx@spaceboyz.net>
Subject: Re: [PATCH] radio-bcm2048: Fix region selection
References: <1431725571-7417-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1431725571-7417-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2015 11:32 PM, Pali Rohár wrote:
> From: maxx <maxx@spaceboyz.net>
> 
> This actually fixes region selection for BCM2048 FM receiver. To select
> the japanese FM-band an additional bit in FM_CTRL register needs to be
> set. This might not sound so important but it enables at least me to
> listen to some 'very interesting' radio transmission below normal
> FM-band.
> 
> Patch writen by maxx@spaceboyz.net
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Cc: maxx@spaceboyz.net

Looks good to me. If someone can repost with correct names and SoBs, then I'll
apply.

Regards,

	Hans

> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index aeb6c3c..1482d4b 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -739,7 +739,20 @@ static int bcm2048_set_region(struct bcm2048_device *bdev, u8 region)
>  		return -EINVAL;
>  
>  	mutex_lock(&bdev->mutex);
> +
>  	bdev->region_info = region_configs[region];
> +
> +	bdev->cache_fm_ctrl &= ~BCM2048_BAND_SELECT;
> +	if (region > 2) {
> +		bdev->cache_fm_ctrl |= BCM2048_BAND_SELECT;
> +		err = bcm2048_send_command(bdev, BCM2048_I2C_FM_CTRL,
> +					bdev->cache_fm_ctrl);
> +		if (err) {
> +			mutex_unlock(&bdev->mutex);
> +			goto done;
> +		}
> +	}
> +
>  	mutex_unlock(&bdev->mutex);
>  
>  	if (bdev->frequency < region_configs[region].bottom_frequency ||
> 

