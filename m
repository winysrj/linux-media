Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932248AbeFFJIT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 05:08:19 -0400
Date: Wed, 6 Jun 2018 11:07:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Rosenberg <drosen@google.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, kernel-team@android.com,
        Divya Ponnusamy <pdivya@codeaurora.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH resend] drivers: dma-buf: Change %p to %pK in debug
 messages
Message-ID: <20180606090753.GA27744@kroah.com>
References: <20180605234041.246060-1-drosen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605234041.246060-1-drosen@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 05, 2018 at 04:40:41PM -0700, Daniel Rosenberg wrote:
> The format specifier %p can leak kernel addresses
> while not valuing the kptr_restrict system settings.
> Use %pK instead of %p, which also evaluates whether
> kptr_restrict is set.
> 
> Signed-off-by: Divya Ponnusamy <pdivya@codeaurora.org>
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>  drivers/dma-buf/sync_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma-buf/sync_debug.c b/drivers/dma-buf/sync_debug.c
> index c4c8ecb24aa9..d8d340542a79 100644
> --- a/drivers/dma-buf/sync_debug.c
> +++ b/drivers/dma-buf/sync_debug.c
> @@ -133,7 +133,7 @@ static void sync_print_sync_file(struct seq_file *s,
>  	char buf[128];
>  	int i;
>  
> -	seq_printf(s, "[%p] %s: %s\n", sync_file,
> +	seq_printf(s, "[%pK] %s: %s\n", sync_file,

This is a root-only file, right?  So it's not that bad of a problem.
Also, by default, all %p pointers are now hashed so what really is
leaking here?

And finally, why even print out a pointer at all?  Why not just stick
with the name and not worry about the pointer?

thanks,

greg k-h
