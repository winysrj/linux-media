Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54515 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbbD3GVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 02:21:25 -0400
Message-ID: <5541C9DA.5070202@xs4all.nl>
Date: Thu, 30 Apr 2015 08:21:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 13/13] vivid-radio-rx: Don't go past buffer
References: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com> <c3004eee94a40cdfaf51b50dad464c25bc974e54.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <c3004eee94a40cdfaf51b50dad464c25bc974e54.1430262315.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/29/2015 01:06 AM, Mauro Carvalho Chehab wrote:
> drivers/media/platform/vivid/vivid-radio-rx.c:198 vivid_radio_rx_s_hw_freq_seek() error: buffer overflow 'vivid_radio_bands' 3 <= 3
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
> index c7651a506668..f99092ca8f5c 100644
> --- a/drivers/media/platform/vivid/vivid-radio-rx.c
> +++ b/drivers/media/platform/vivid/vivid-radio-rx.c
> @@ -195,6 +195,8 @@ int vivid_radio_rx_s_hw_freq_seek(struct file *file, void *fh, const struct v4l2
>  			if (dev->radio_rx_freq >= vivid_radio_bands[band].rangelow &&
>  			    dev->radio_rx_freq <= vivid_radio_bands[band].rangehigh)
>  				break;
> +		if (band == TOT_BANDS)
> +			return -EINVAL;
>  		low = vivid_radio_bands[band].rangelow;
>  		high = vivid_radio_bands[band].rangehigh;
>  	}
> 

