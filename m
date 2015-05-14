Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35751 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584AbbENRBA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 13:01:00 -0400
Date: Thu, 14 May 2015 14:00:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [RFC PATCH 2/6] [media] lirc: LIRC_[SG]ET_SEND_MODE should
 return -ENOSYS
Message-ID: <20150514140055.7f718d43@recife.lan>
In-Reply-To: <f0607fde6ec1ad120f62a80c53b1d44c4d5f4d81.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
	<f0607fde6ec1ad120f62a80c53b1d44c4d5f4d81.1426801061.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Mar 2015 21:50:13 +0000
Sean Young <sean@mess.org> escreveu:

> If the device cannot transmit then -ENOSYS should be returned. Also clarify
> that the ioctl should return modes, not features. The values happen to be
> identical.

Makes sense to me. Yet, applying it (without patch 1) causes compilation to
break.

I would put this at the top of the series, as this actually seems to be
a bug fix that it could eventually make sense to backport.

So, better to keep this patch independent.

> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/ir-lirc-codec.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 98893a8..17fd956 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -207,12 +207,19 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
>  
>  	/* legacy support */
>  	case LIRC_GET_SEND_MODE:
> -		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
> +		if (!(dev->lirc->features & LIRC_CAN_SEND_MASK))
> +			return -ENOSYS;
> +
> +		val = LIRC_MODE_PULSE;
>  		break;
>  
>  	case LIRC_SET_SEND_MODE:
> -		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
> +		if (!(dev->lirc->features & LIRC_CAN_SEND_MASK))
> +			return -ENOSYS;
> +
> +		if (val != LIRC_MODE_PULSE)
>  			return -EINVAL;
> +
>  		return 0;
>  
>  	/* TX settings */
