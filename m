Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1913 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933961Ab3CZIWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:22:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH -next] [media] go7007: remove unused including <linux/version.h>
Date: Tue, 26 Mar 2013 09:21:38 +0100
Cc: hans.verkuil@cisco.com, mchehab@redhat.com,
	gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
References: <CAPgLHd99aV5rzjpOVUvWMK9PNJtxeqfmezv9XSzMU4rXVdg85g@mail.gmail.com>
In-Reply-To: <CAPgLHd99aV5rzjpOVUvWMK9PNJtxeqfmezv9XSzMU4rXVdg85g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303260921.38133.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 26 2013 06:45:51 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <linux/version.h> that don't need it.

The include is already removed.

Regards,

	Hans

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/staging/media/go7007/go7007-v4l2.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
> index 24ba50e..50eb69a 100644
> --- a/drivers/staging/media/go7007/go7007-v4l2.c
> +++ b/drivers/staging/media/go7007/go7007-v4l2.c
> @@ -17,7 +17,6 @@
>  
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/version.h>
>  #include <linux/delay.h>
>  #include <linux/sched.h>
>  #include <linux/spinlock.h>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
