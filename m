Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34751 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754758AbdCXSOT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:14:19 -0400
Date: Fri, 24 Mar 2017 18:06:28 +0000
From: Sean Young <sean@mess.org>
To: Chetan Sethi <cpsethi369@gmail.com>
Cc: jarod@wilsonet.com, mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: coding style fix use octal instead
 of symbolic permission
Message-ID: <20170324180627.GA14834@gofer.mess.org>
References: <1486881582-21101-1-git-send-email-cpsethi369@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486881582-21101-1-git-send-email-cpsethi369@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 12, 2017 at 03:39:42PM +0900, Chetan Sethi wrote:
> This is a patch to the lirc_sir.c file that fixes coding style warning
> found by checkpatch.pl
> 
> Signed-off-by: Chetan Sethi <cpsethi369@gmail.com>

Another patch was merged which already fixed this, I'm sorry.

Sean

> ---
>  drivers/staging/media/lirc/lirc_sir.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
> index c75ae43..426753e 100644
> --- a/drivers/staging/media/lirc/lirc_sir.c
> +++ b/drivers/staging/media/lirc/lirc_sir.c
> @@ -826,14 +826,14 @@ MODULE_AUTHOR("Milan Pikula");
>  #endif
>  MODULE_LICENSE("GPL");
>  
> -module_param(io, int, S_IRUGO);
> +module_param(io, int, 0444);
>  MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
>  
> -module_param(irq, int, S_IRUGO);
> +module_param(irq, int, 0444);
>  MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
>  
> -module_param(threshold, int, S_IRUGO);
> +module_param(threshold, int, 0444);
>  MODULE_PARM_DESC(threshold, "space detection threshold (3)");
>  
> -module_param(debug, bool, S_IRUGO | S_IWUSR);
> +module_param(debug, bool, 0644);
>  MODULE_PARM_DESC(debug, "Enable debugging messages");
> -- 
> 2.7.4
