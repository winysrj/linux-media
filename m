Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36989 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcAERhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 12:37:37 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so40324842wmf.0
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2016 09:37:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151213003201.GQ20997@ZenIV.linux.org.uk>
References: <20151213003201.GQ20997@ZenIV.linux.org.uk>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 5 Jan 2016 17:37:06 +0000
Message-ID: <CA+V-a8v-NC9oToS5KcaGwuATAxvOaXE3p=uT769uaKoebBVeBg@mail.gmail.com>
Subject: Re: [PATCH][davinci] ccdc_update_raw_params() frees the wrong thing
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 13, 2015 at 12:32 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         Passing a physical address to free_pages() is a bad idea.
> config_params->fault_pxl.fpc_table_addr is set to virt_to_phys()
> of __get_free_pages() return value; what we should pass to free_pages()
> is its phys_to_virt().  ccdc_close() does that properly, but
> ccdc_update_raw_params() doesn't.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
> index ffbefdf..6fba32b 100644
> --- a/drivers/media/platform/davinci/dm644x_ccdc.c
> +++ b/drivers/media/platform/davinci/dm644x_ccdc.c
> @@ -261,7 +261,7 @@ static int ccdc_update_raw_params(struct ccdc_config_params_raw *raw_params)
>          */
>         if (raw_params->fault_pxl.fp_num != config_params->fault_pxl.fp_num) {
>                 if (fpc_physaddr != NULL) {
> -                       free_pages((unsigned long)fpc_physaddr,
> +                       free_pages((unsigned long)fpc_virtaddr,
>                                    get_order
>                                    (config_params->fault_pxl.fp_num *
>                                    FP_NUM_BYTES));
