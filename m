Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:32835 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeEET7V (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 15:59:21 -0400
Received: by mail-qk0-f195.google.com with SMTP id c70so19188856qkg.0
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 12:59:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <078ce0be8945b9e2530f2e0ce84c8dcbb154edb6.1525526664.git.mchehab+samsung@kernel.org>
References: <078ce0be8945b9e2530f2e0ce84c8dcbb154edb6.1525526664.git.mchehab+samsung@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 5 May 2018 22:59:20 +0300
Message-ID: <CAHp75Ve03OJ197iFfwmC=LjogRu5bm4JUcBFptDTgQBreCXF8A@mail.gmail.com>
Subject: Re: [PATCH] media: pt1: use #ifdef CONFIG_PM_SLEEP instead of #if
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 5, 2018 at 4:24 PM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> As pointed by ktest:
>
>>> drivers/media//pci/pt1/pt1.c:1433:5: warning: "CONFIG_PM_SLEEP" is not defined, evaluates to 0 [-Wundef]
>     #if CONFIG_PM_SLEEP
>         ^~~~~~~~~~~~~~~
>

Why not to go further and drop this ugly #if(def) in favour of __maybe_unused?

> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/pci/pt1/pt1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
> index 3b7e08a4639a..55a89ea13f2a 100644
> --- a/drivers/media/pci/pt1/pt1.c
> +++ b/drivers/media/pci/pt1/pt1.c
> @@ -1443,7 +1443,7 @@ static struct pci_driver pt1_driver = {
>         .probe          = pt1_probe,
>         .remove         = pt1_remove,
>         .id_table       = pt1_id_table,
> -#if CONFIG_PM_SLEEP
> +#ifdef CONFIG_PM_SLEEP
>         .driver.pm      = &pt1_pm_ops,
>  #endif
>  };
> --
> 2.17.0
>



-- 
With Best Regards,
Andy Shevchenko
