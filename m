Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:54213 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934689AbaDJHqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 03:46:18 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so2645290eek.39
        for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 00:46:17 -0700 (PDT)
Date: Thu, 10 Apr 2014 09:46:15 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Jiri Kosina <trivial@kernel.org>, linux-doc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] dma-buf: update exp_name when using dma_buf_export()
Message-ID: <20140410074615.GM9262@phenom.ffwll.local>
References: <1397086206-5898-1-git-send-email-javier.martinez@collabora.co.uk>
 <1397086206-5898-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397086206-5898-2-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 10, 2014 at 01:30:06AM +0200, Javier Martinez Canillas wrote:
> commit c0b00a5 ("dma-buf: update debugfs output") modified the
> default exporter name to be the KBUILD_MODNAME pre-processor
> macro instead of __FILE__ but the documentation was not updated.
> 
> Also the "Supporting existing mmap interfaces in exporters" section
> title seems wrong since talks about the interface used by importers.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  Documentation/dma-buf-sharing.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 505e711..7d61cef 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -66,7 +66,7 @@ The dma_buf buffer sharing API usage contains the following steps:
>  
>     Exporting modules which do not wish to provide any specific name may use the
>     helper define 'dma_buf_export()', with the same arguments as above, but
> -   without the last argument; a __FILE__ pre-processor directive will be
> +   without the last argument; a KBUILD_MODNAME pre-processor directive will be
>     inserted in place of 'exp_name' instead.
>  
>  2. Userspace gets a handle to pass around to potential buffer-users
> @@ -352,7 +352,7 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
>  
>     No special interfaces, userspace simply calls mmap on the dma-buf fd.
>  
> -2. Supporting existing mmap interfaces in exporters
> +2. Supporting existing mmap interfaces in importers
>  
>     Similar to the motivation for kernel cpu access it is again important that
>     the userspace code of a given importing subsystem can use the same interfaces
> -- 
> 1.9.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
