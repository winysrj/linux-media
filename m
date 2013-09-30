Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1429 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3I3Hvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 03:51:54 -0400
Message-ID: <52492D91.1030806@xs4all.nl>
Date: Mon, 30 Sep 2013 09:51:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: linux-media <linux-media@vger.kernel.org>,
	ismael.luceno@corp.bluecherry.net
Subject: Re: [PATCH] SOLO6x10: don't do DMA from stack in solo_dma_vin_region().
References: <m37gemb51b.fsf@t19.piap.pl>
In-Reply-To: <m37gemb51b.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ismael,

Can you Ack these four patches?

Regards,

	Hans

On 09/12/2013 02:25 PM, Krzysztof Hałasa wrote:
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> 
> diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/staging/media/solo6x10/solo6x10-disp.c
> index 32d9953..884512e 100644
> --- a/drivers/staging/media/solo6x10/solo6x10-disp.c
> +++ b/drivers/staging/media/solo6x10/solo6x10-disp.c
> @@ -176,18 +176,26 @@ static void solo_vout_config(struct solo_dev *solo_dev)
>  static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
>  			       u16 val, int reg_size)
>  {
> -	u16 buf[64];
> -	int i;
> -	int ret = 0;
> +	u16 *buf;
> +	const int n = 64, size = n * sizeof(*buf);
> +	int i, ret = 0;
> +
> +	if (!(buf = kmalloc(size, GFP_KERNEL)))
> +		return -ENOMEM;
>  
> -	for (i = 0; i < sizeof(buf) >> 1; i++)
> +	for (i = 0; i < n; i++)
>  		buf[i] = cpu_to_le16(val);
>  
> -	for (i = 0; i < reg_size; i += sizeof(buf))
> -		ret |= solo_p2m_dma(solo_dev, 1, buf,
> -				    SOLO_MOTION_EXT_ADDR(solo_dev) + off + i,
> -				    sizeof(buf), 0, 0);
> +	for (i = 0; i < reg_size; i += size) {
> +		ret = solo_p2m_dma(solo_dev, 1, buf,
> +				   SOLO_MOTION_EXT_ADDR(solo_dev) + off + i,
> +				   size, 0, 0);
> +
> +		if (ret)
> +			break;
> +	}
>  
> +	kfree(buf);
>  	return ret;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

