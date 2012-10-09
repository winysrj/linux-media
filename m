Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61806 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2JIGKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 02:10:42 -0400
Received: by mail-ia0-f174.google.com with SMTP id y32so564177iag.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 23:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_dS4oPpEnTG2uJ-5dGgcU9Ebxk-TEggOU5Z94iY3qBpg@mail.gmail.com>
References: <CAPgLHd_dS4oPpEnTG2uJ-5dGgcU9Ebxk-TEggOU5Z94iY3qBpg@mail.gmail.com>
Date: Tue, 9 Oct 2012 14:10:42 +0800
Message-ID: <CAHG8p1DTBbthbZHrGabx9Wh=OtC10qsrV0aRAqakQiRPx00HTQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: adv7183: use module_i2c_driver to simplify the code
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@infradead.org, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/10/8 Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use the module_i2c_driver() macro to make the code smaller
> and a bit simpler.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>

> ---
>  drivers/media/i2c/adv7183.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
> index e1d4c89..10c3c1d 100644
> --- a/drivers/media/i2c/adv7183.c
> +++ b/drivers/media/i2c/adv7183.c
> @@ -681,18 +681,7 @@ static struct i2c_driver adv7183_driver = {
>         .id_table       = adv7183_id,
>  };
>
> -static __init int adv7183_init(void)
> -{
> -       return i2c_add_driver(&adv7183_driver);
> -}
> -
> -static __exit void adv7183_exit(void)
> -{
> -       i2c_del_driver(&adv7183_driver);
> -}
> -
> -module_init(adv7183_init);
> -module_exit(adv7183_exit);
> +module_i2c_driver(adv7183_driver);
>
>  MODULE_DESCRIPTION("Analog Devices ADV7183 video decoder driver");
>  MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
>
