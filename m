Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:14475 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751332AbdILO2r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 10:28:47 -0400
Date: Tue, 12 Sep 2017 16:27:55 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Srishti Sharma <srishtishar@gmail.com>
cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] Staging: media: atomisp: Merge
 assignment with return
In-Reply-To: <1505226307-5119-1-git-send-email-srishtishar@gmail.com>
Message-ID: <alpine.DEB.2.20.1709121627340.3149@hadrien>
References: <1505226307-5119-1-git-send-email-srishtishar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 12 Sep 2017, Srishti Sharma wrote:

> Merge the assignment and the return statements to return the value
> directly. Done using the following semantic patch by coccinelle.
>
> @@
> local idexpression ret;
> expression e;
> @@
>
> -ret =
> +return
>      e;
> -return ret;
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>


> ---
>  drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> index 11162f5..e6ddfbf 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> @@ -1168,13 +1168,9 @@ void hmm_bo_free_pages(struct hmm_buffer_object *bo)
>
>  int hmm_bo_page_allocated(struct hmm_buffer_object *bo)
>  {
> -	int ret;
> -
>  	check_bo_null_return(bo, 0);
>
> -	ret = bo->status & HMM_BO_PAGE_ALLOCED;
> -
> -	return ret;
> +	return bo->status & HMM_BO_PAGE_ALLOCED;
>  }
>
>  /*
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1505226307-5119-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
