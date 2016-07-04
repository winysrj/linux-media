Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:52450 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbcGDLnB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 07:43:01 -0400
Subject: Re: [PATCH v2 12/15] [media] lirc_dev: fix error return value
To: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
 <1467360098-12539-13-git-send-email-andi.shyti@samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b461006-eb08-74f7-84bf-7cce70998366@xs4all.nl>
Date: Mon, 4 Jul 2016 13:42:55 +0200
MIME-Version: 1.0
In-Reply-To: <1467360098-12539-13-git-send-email-andi.shyti@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2016 10:01 AM, Andi Shyti wrote:
> If ioctl is called, it cannot be a case of invalid system call
> number (ENOSYS), that is an operation not permitted (EPERM).
> Replace ENOSYS with EPERM.

I'd say it is ENOTTY, i.e. this hardware does not support this ioctl.

Regards,

	Hans

> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/lirc_dev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 689e369..99d1f98 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -587,7 +587,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		break;
>  	case LIRC_GET_REC_MODE:
>  		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
> -			result = -ENOSYS;
> +			result = -EPERM;
>  			break;
>  		}
>  
> @@ -597,7 +597,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		break;
>  	case LIRC_SET_REC_MODE:
>  		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
> -			result = -ENOSYS;
> +			result = -EPERM;
>  			break;
>  		}
>  
> @@ -615,7 +615,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	case LIRC_GET_MIN_TIMEOUT:
>  		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
>  		    ir->d.min_timeout == 0) {
> -			result = -ENOSYS;
> +			result = -EPERM;
>  			break;
>  		}
>  
> @@ -624,7 +624,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	case LIRC_GET_MAX_TIMEOUT:
>  		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
>  		    ir->d.max_timeout == 0) {
> -			result = -ENOSYS;
> +			result = -EPERM;
>  			break;
>  		}
>  
> 
