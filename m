Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11363 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752129AbeCCUsi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:48:38 -0500
Date: Sat, 3 Mar 2018 21:48:36 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Arushi Singhal <arushisinghal19971997@gmail.com>
cc: alan@linux.intel.com, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH] staging: media: Remove unnecessary
 semicolon
In-Reply-To: <20180303192629.GA5198@seema-Inspiron-15-3567>
Message-ID: <alpine.DEB.2.20.1803032148230.9544@hadrien>
References: <20180303192629.GA5198@seema-Inspiron-15-3567>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 4 Mar 2018, Arushi Singhal wrote:

> Remove unnecessary semicolon found using semicolon.cocci Coccinelle
> script.
>
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>


> ---
>  .../media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c        | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
> index 5faa89a..7562bea 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/frame/src/frame.c
> @@ -196,7 +196,7 @@ enum ia_css_err ia_css_frame_map(struct ia_css_frame **frame,
>  						  attribute, context);
>  		if (me->data == mmgr_NULL)
>  			err = IA_CSS_ERR_INVALID_ARGUMENTS;
> -	};
> +	}
>
>  	if (err != IA_CSS_SUCCESS) {
>  		sh_css_free(me);
> --
> 2.7.4
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20180303192629.GA5198%40seema-Inspiron-15-3567.
> For more options, visit https://groups.google.com/d/optout.
>
