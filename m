Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61121 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751166AbdIHOKk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 10:10:40 -0400
Date: Fri, 8 Sep 2017 16:10:09 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Srishti Sharma <srishtishar@gmail.com>
cc: gregkh@linuxfoundation.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] Staging: media: omap4iss: Use WARN_ON()
 instead of BUG_ON().
In-Reply-To: <1504879698-5855-1-git-send-email-srishtishar@gmail.com>
Message-ID: <alpine.DEB.2.20.1709081609440.3165@hadrien>
References: <1504879698-5855-1-git-send-email-srishtishar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 8 Sep 2017, Srishti Sharma wrote:

> Use WARN_ON() instead of BUG_ON() to avoid crashing the kernel.
>
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/media/omap4iss/iss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index c26c99fd..b1036ba 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -893,7 +893,7 @@ void omap4iss_put(struct iss_device *iss)
>  		return;
>
>  	mutex_lock(&iss->iss_mutex);
> -	BUG_ON(iss->ref_count == 0);
> +	WARN_ON(iss->ref_count == 0);
>  	if (--iss->ref_count == 0) {

Won't this then infinite loop?

julia

>  		iss_disable_interrupts(iss);
>  		/* Reset the ISS if an entity has failed to stop. This is the
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/1504879698-5855-1-git-send-email-srishtishar%40gmail.com.
> For more options, visit https://groups.google.com/d/optout.
>
