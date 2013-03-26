Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3266 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933961Ab3CZIWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 04:22:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH -next] [media] tw9906: remove unused including <linux/version.h>
Date: Tue, 26 Mar 2013 09:22:20 +0100
Cc: mchehab@redhat.com, hans.verkuil@cisco.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
References: <CAPgLHd-1FxJWLBQaOsiXajaSXAhogydG3QS-Fqi1P5kxBQMPrw@mail.gmail.com>
In-Reply-To: <CAPgLHd-1FxJWLBQaOsiXajaSXAhogydG3QS-Fqi1P5kxBQMPrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303260922.20685.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 26 2013 06:51:54 Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <linux/version.h> that don't need it.

The include has already been removed.

Regards,

	Hans

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/i2c/tw9906.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tw9906.c b/drivers/media/i2c/tw9906.c
> index 2263a91..d94325b 100644
> --- a/drivers/media/i2c/tw9906.c
> +++ b/drivers/media/i2c/tw9906.c
> @@ -17,7 +17,6 @@
>  
>  #include <linux/module.h>
>  #include <linux/init.h>
> -#include <linux/version.h>
>  #include <linux/i2c.h>
>  #include <linux/videodev2.h>
>  #include <linux/ioctl.h>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
