Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-p2.oit.umn.edu ([134.84.196.202]:59368 "EHLO
        mta-p2.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbeJ3F0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 01:26:52 -0400
MIME-Version: 1.0
References: <1538668833-18372-1-git-send-email-wang6495@umn.edu>
In-Reply-To: <1538668833-18372-1-git-send-email-wang6495@umn.edu>
From: Wenwen Wang <wang6495@umn.edu>
Date: Mon, 29 Oct 2018 15:35:54 -0500
Message-ID: <CAAa=b7c6uYQARV80wxWHysHG0otD+8ZQfmq0Q2FMumUKi7BuRg@mail.gmail.com>
Subject: Re: [PATCH] media: davinci_vpfe: fix a NULL pointer dereference bug
To: Wenwen Wang <wang6495@umn.edu>
Cc: Kangjie Lu <kjlu@umn.edu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING - ATOMISP DRIVER" <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Can anyone please confirm this bug and apply the patch? Thanks!

Wenwen

On Thu, Oct 4, 2018 at 11:00 AM Wenwen Wang <wang6495@umn.edu> wrote:
>
> In vpfe_isif_init(), there is a while loop to get the ISIF base address and
> linearization table0 and table1 address. In the loop body, the function
> platform_get_resource() is called to get the resource. If
> platform_get_resource() returns NULL, the loop is terminated and the
> execution goes to 'fail_nobase_res'. Suppose the loop is terminated at the
> first iteration because platform_get_resource() returns NULL and the
> execution goes to 'fail_nobase_res'. Given that there is another while loop
> at 'fail_nobase_res' and i equals to 0, one iteration of the second while
> loop will be executed. However, the second while loop does not check the
> return value of platform_get_resource(). This can cause a NULL pointer
> dereference bug if the return value is a NULL pointer.
>
> This patch avoids the above issue by adding a check in the second while
> loop after the call to platform_get_resource().
>
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/staging/media/davinci_vpfe/dm365_isif.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> index 745e33f..b0425a6 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> @@ -2080,7 +2080,8 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
>
>         while (i >= 0) {
>                 res = platform_get_resource(pdev, IORESOURCE_MEM, i);
> -               release_mem_region(res->start, res_len);
> +               if (res)
> +                       release_mem_region(res->start, res_len);
>                 i--;
>         }
>         return status;
> --
> 2.7.4
>
