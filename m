Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47052 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2GJPuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 11:50:11 -0400
Received: by ghrr11 with SMTP id r11so129255ghr.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 08:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341902726-22580-1-git-send-email-devendra.aaru@gmail.com>
References: <1341902726-22580-1-git-send-email-devendra.aaru@gmail.com>
Date: Tue, 10 Jul 2012 12:50:10 -0300
Message-ID: <CALF0-+XFR7ri3gK6ojvbaG8Kf7z9rXqPHyArbyzOCu3ZehBs2A@mail.gmail.com>
Subject: Re: [PATCH 5/6] staging/media/solo6x10: use module_pci_driver macro
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>,
	ismael.luceno@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devendra,

Thanks for the patch.

On Tue, Jul 10, 2012 at 3:45 AM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> the driver duplicates the module_pci_driver code,
> how?
>         module_pci_driver is used for those drivers whose
>         init and exit paths does only register and unregister
>         to pci API and nothing else.
>
> so use the module_pci_driver macro instead
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/media/solo6x10/core.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
> index d2fd842..3ee9b12 100644
> --- a/drivers/staging/media/solo6x10/core.c
> +++ b/drivers/staging/media/solo6x10/core.c
> @@ -318,15 +318,4 @@ static struct pci_driver solo_pci_driver = {
>         .remove = solo_pci_remove,
>  };
>
> -static int __init solo_module_init(void)
> -{
> -       return pci_register_driver(&solo_pci_driver);
> -}
> -
> -static void __exit solo_module_exit(void)
> -{
> -       pci_unregister_driver(&solo_pci_driver);
> -}
> -
> -module_init(solo_module_init);
> -module_exit(solo_module_exit);
> +module_pci_driver(solo_pci_driver);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Since this driver belongs to staging/media you should not send this to
staging but to linux-media mailing list.
Also, the maintainer is Mauro, so it's not necessary to add Greg in Cc.

Also, I'm Ccing Ismael Luceno who seems to be currently working for bluecherry.
Ismael: Is it possible for you to test and/or ack this patch?

Thanks,
Ezequiel.
