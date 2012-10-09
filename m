Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60907 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2JIGJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 02:09:45 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1270296iea.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 23:09:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_EYFLSz-ZabR6W6kjz3MS9x9w20CfduxHk8hE3H9pazg@mail.gmail.com>
References: <CAPgLHd_EYFLSz-ZabR6W6kjz3MS9x9w20CfduxHk8hE3H9pazg@mail.gmail.com>
Date: Tue, 9 Oct 2012 14:09:44 +0800
Message-ID: <CAHG8p1DF+NJQOfq4ujexBkcz9-HnHf-5ta+=nadRBHUR=C+UzQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: vs6624: use module_i2c_driver to simplify the code
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
>  drivers/media/i2c/vs6624.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
> index 42ae9dc..f434a19 100644
> --- a/drivers/media/i2c/vs6624.c
> +++ b/drivers/media/i2c/vs6624.c
> @@ -910,18 +910,7 @@ static struct i2c_driver vs6624_driver = {
>         .id_table       = vs6624_id,
>  };
>
> -static __init int vs6624_init(void)
> -{
> -       return i2c_add_driver(&vs6624_driver);
> -}
> -
> -static __exit void vs6624_exit(void)
> -{
> -       i2c_del_driver(&vs6624_driver);
> -}
> -
> -module_init(vs6624_init);
> -module_exit(vs6624_exit);
> +module_i2c_driver(vs6624_driver);
>
>  MODULE_DESCRIPTION("VS6624 sensor driver");
>  MODULE_AUTHOR("Scott Jiang <Scott.Jiang.Linux@gmail.com>");
