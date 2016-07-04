Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42633 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007AbcGDLjd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 07:39:33 -0400
Subject: Re: [PATCH v2 10/15] [media] lirc_dev: remove CONFIG_COMPAT
 precompiler check
To: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
 <1467360098-12539-11-git-send-email-andi.shyti@samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f7360a3e-1785-6940-00fc-4d05ac2e9ffe@xs4all.nl>
Date: Mon, 4 Jul 2016 13:39:25 +0200
MIME-Version: 1.0
In-Reply-To: <1467360098-12539-11-git-send-email-andi.shyti@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/01/2016 10:01 AM, Andi Shyti wrote:
> There is no need to check in precompilation whether the ioctl is
> compat or unlocked, depending on the configuration it will be
> called the correct one.
> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/lirc_dev.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index d98a9f1..16cca46 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -150,9 +150,7 @@ static const struct file_operations lirc_dev_fops = {
>  	.write		= lirc_dev_fop_write,
>  	.poll		= lirc_dev_fop_poll,
>  	.unlocked_ioctl	= lirc_dev_fop_ioctl,
> -#ifdef CONFIG_COMPAT
>  	.compat_ioctl	= lirc_dev_fop_ioctl,
> -#endif

I'd say this compat_ioctl can be dropped completely since there is nothing to do.

Regards,

	Hans

>  	.open		= lirc_dev_fop_open,
>  	.release	= lirc_dev_fop_close,
>  	.llseek		= noop_llseek,
> 
