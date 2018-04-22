Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:41462 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbeDVSMw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 14:12:52 -0400
MIME-Version: 1.0
In-Reply-To: <0896a07690a7379eb37a603cfe87382455afcb71.1524245455.git.mchehab@s-opensource.com>
References: <cover.1524245455.git.mchehab@s-opensource.com> <0896a07690a7379eb37a603cfe87382455afcb71.1524245455.git.mchehab@s-opensource.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 22 Apr 2018 21:12:51 +0300
Message-ID: <CAHp75VfWrcqQS=hfOWixv5juDiVkuLQswwk+CiNZdNhf9HYYVA@mail.gmail.com>
Subject: Re: [PATCH 2/7] media: meye: allow building it with COMPILE_TEST on non-x86
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mattia Dongili <malattia@linux.it>,
        Platform Driver <platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 8:42 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> This driver depends on sony-laptop driver, but this is available
> only for x86. So, add a stub function, in order to allow building
> it on non-x86 too.

> --- a/include/linux/sony-laptop.h
> +++ b/include/linux/sony-laptop.h
> @@ -28,7 +28,11 @@
>  #define SONY_PIC_COMMAND_GETCAMERAROMVERSION   18      /* obsolete */
>  #define SONY_PIC_COMMAND_GETCAMERAREVISION     19      /* obsolete */
>
> +#ifdef CONFIG_SONY_LAPTOP

IS_ENABLED(), IS_BUILTIN() ?

>  int sony_pic_camera_command(int command, u8 value);
> +#else
> +static inline int sony_pic_camera_command(int command, u8 value) { return 0; };
> +#endif
>
>  #endif /* __KERNEL__ */



-- 
With Best Regards,
Andy Shevchenko
