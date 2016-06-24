Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:50914 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbcFXSCn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 14:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <1466791224-18641-1-git-send-email-colin.king@canonical.com>
References: <1466791224-18641-1-git-send-email-colin.king@canonical.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Fri, 24 Jun 2016 14:02:19 -0400
Message-ID: <CAK3bHNVzfdJ7SPc2H=7vOgTmajpu3Ve=xuHKwqTWQhPg5AvEsg@mail.gmail.com>
Subject: Re: [PATCH] [media] netup_unidvb: trivial fix of spelling mistake
 "initizalize" -> "initialize"
To: Colin King <colin.king@canonical.com>
Cc: Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jiri Kosina <trivial@kernel.org>,
	linux-media <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Abylay Ospan <aospan@netup.ru>

2016-06-24 14:00 GMT-04:00 Colin King <colin.king@canonical.com>:
> From: Colin Ian King <colin.king@canonical.com>
>
> trivial fix to spelling mistake in dev_err message
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
> index d278d4e..c2ec4e2 100644
> --- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
> +++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
> @@ -975,7 +975,7 @@ wq_create_err:
>         kfree(ndev);
>  dev_alloc_err:
>         dev_err(&pci_dev->dev,
> -               "%s(): failed to initizalize device\n", __func__);
> +               "%s(): failed to initialize device\n", __func__);
>         return -EIO;
>  }
>
> --
> 2.8.1
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
