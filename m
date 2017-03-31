Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34988 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933008AbdCaQMu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 12:12:50 -0400
Received: by mail-wm0-f66.google.com with SMTP id z133so484988wmb.2
        for <linux-media@vger.kernel.org>; Fri, 31 Mar 2017 09:12:48 -0700 (PDT)
Date: Fri, 31 Mar 2017 18:12:46 +0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] dma-buf: fence debugging
Message-ID: <20170331161246.GA2252@joana>
References: <E1cttMI-00068z-3X@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1cttMI-00068z-3X@rmk-PC.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

2017-03-31 Russell King <rmk+kernel@arm.linux.org.uk>:

> Add debugfs output to report shared and exclusive fences on a dma_buf
> object.  This produces output such as:
> 
> Dma-buf Objects:
> size    flags   mode    count   exp_name
> 08294400        00000000        00000005        00000005        drm
>         Exclusive fence: etnaviv 134000.gpu signalled
>         Attached Devices:
>         gpu-subsystem
> Total 1 devices attached
> 
> 
> Total 1 objects, 8294400 bytes
> 
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/dma-buf/dma-buf.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletions(-)

Applied to to drm-misc-next.

> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 0007b792827b..f72aaacbe023 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1059,7 +1059,11 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>  	int ret;
>  	struct dma_buf *buf_obj;
>  	struct dma_buf_attachment *attach_obj;
> -	int count = 0, attach_count;
> +	struct reservation_object *robj;
> +	struct reservation_object_list *fobj;
> +	struct dma_fence *fence;
> +	unsigned seq;

Our maintainer tools warned about this line, so I made it "unsigned
int"

Gustavo
