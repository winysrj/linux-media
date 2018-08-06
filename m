Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47046 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732383AbeHGA6t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 20:58:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: uvc_debugfs: remove unnecessary NULL check before debugfs_remove_recursive
Date: Tue, 07 Aug 2018 01:48:15 +0300
Message-ID: <1774555.GGbckhaAKE@avalon>
In-Reply-To: <20171112081859.GA19079@embeddedor.com>
References: <20171112081859.GA19079@embeddedor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

Thank you for the patch.

On Sunday, 12 November 2017 10:18:59 EEST Gustavo A. R. Silva wrote:
> NULL check before freeing functions like debugfs_remove_recursive
> is not needed.

"functions like debugfs_remove_recursive" seems a bit vague to me. I'd prefer 
being more precise here, and say that "debugfs_remove_recursive() accepts a 
NULL parameter and returns immediately, there's no need for a NULL check in 
the caller.".

> 
> This issue was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/media/usb/uvc/uvc_debugfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_debugfs.c
> b/drivers/media/usb/uvc/uvc_debugfs.c index 368f8f8..6995aeb 100644
> --- a/drivers/media/usb/uvc/uvc_debugfs.c
> +++ b/drivers/media/usb/uvc/uvc_debugfs.c
> @@ -128,6 +128,5 @@ void uvc_debugfs_init(void)
> 
>  void uvc_debugfs_cleanup(void)
>  {
> -	if (uvc_debugfs_root_dir != NULL)
> -		debugfs_remove_recursive(uvc_debugfs_root_dir);
> +	debugfs_remove_recursive(uvc_debugfs_root_dir);
>  }

There's another occurrence in uvc_debugfs_cleanup_stream(). I'll address it as 
well in this patch. With that change and the commit message update,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

-- 
Regards,

Laurent Pinchart
