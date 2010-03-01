Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45158 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0CAHyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 02:54:52 -0500
Received: by pwj8 with SMTP id 8so1438586pwj.19
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2010 23:54:51 -0800 (PST)
Message-ID: <4B8B72C7.1060806@gmail.com>
Date: Mon, 01 Mar 2010 15:54:47 +0800
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>,
	Huang Shijie <zyziii@telegent.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] tlg2300: cleanups when power management is not configured
References: <4B8A7B83.8060203@freemail.hu>
In-Reply-To: <4B8A7B83.8060203@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function poseidon_fe_release is redundent in fact, I will remove it 
in future.

But now I still acked this patch. thanks a lot.

Acked-by: Huang Shijie <shijie8@gmail.com>
> From: Márton Németh<nm127@freemail.hu>
>
> When power management is not configured (CONFIG_PM) then some code is no longer
> necessary.
>
> This patch will remove the following compiler warnings:
>   * pd-dvb.c: In function 'poseidon_fe_release':
>   * pd-dvb.c:101: warning: unused variable 'pd'
>   * pd-video.c:14: warning: 'pm_video_suspend' declared 'static' but never defined
>   * pd-video.c:15: warning: 'pm_video_resume' declared 'static' but never defined
>
> Signed-off-by: Márton Németh<nm127@freemail.hu>
> ---
> diff -r 37581bb7e6f1 linux/drivers/media/video/tlg2300/pd-dvb.c
> --- a/linux/drivers/media/video/tlg2300/pd-dvb.c	Wed Feb 24 22:48:50 2010 -0300
> +++ b/linux/drivers/media/video/tlg2300/pd-dvb.c	Sun Feb 28 15:13:05 2010 +0100
> @@ -96,15 +96,17 @@
>   	return ret;
>   }
>
> +#ifdef CONFIG_PM
>   static void poseidon_fe_release(struct dvb_frontend *fe)
>   {
>   	struct poseidon *pd = fe->demodulator_priv;
>
> -#ifdef CONFIG_PM
>   	pd->pm_suspend = NULL;
>   	pd->pm_resume  = NULL;
> +}
> +#else
> +#define poseidon_fe_release NULL
>   #endif
> -}
>
>   static s32 poseidon_fe_sleep(struct dvb_frontend *fe)
>   {
> diff -r 37581bb7e6f1 linux/drivers/media/video/tlg2300/pd-video.c
> --- a/linux/drivers/media/video/tlg2300/pd-video.c	Wed Feb 24 22:48:50 2010 -0300
> +++ b/linux/drivers/media/video/tlg2300/pd-video.c	Sun Feb 28 15:13:05 2010 +0100
> @@ -11,8 +11,10 @@
>   #include "pd-common.h"
>   #include "vendorcmds.h"
>
> +#ifdef CONFIG_PM
>   static int pm_video_suspend(struct poseidon *pd);
>   static int pm_video_resume(struct poseidon *pd);
> +#endif
>   static void iso_bubble_handler(struct work_struct *w);
>
>   int usb_transfer_mode;
>
>    

