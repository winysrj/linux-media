Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53330
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752169AbdBCNqf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 08:46:35 -0500
Date: Fri, 3 Feb 2017 11:46:27 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] media: pci: saa7164: Replace BUG() with BUG_ON()
Message-ID: <20170203114627.65bf6fec@vento.lan>
In-Reply-To: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
References: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 25 Dec 2016 04:01:39 +0530
Shyam Saini <mayhs11saini@gmail.com> escreveu:

> Replace BUG() with BUG_ON() using coccinelle

First of all, don't send one patch per file, but one patch per driver.

Also, as checkpatch warns:

	WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()


I suspect that very few (if any) BUG() calls on this driver would require
to crash the Kernel.


> 
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>  drivers/media/pci/saa7164/saa7164-buffer.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7164/saa7164-buffer.c b/drivers/media/pci/saa7164/saa7164-buffer.c
> index 62c3450..7d28d46 100644
> --- a/drivers/media/pci/saa7164/saa7164-buffer.c
> +++ b/drivers/media/pci/saa7164/saa7164-buffer.c
> @@ -266,15 +266,13 @@ int saa7164_buffer_cfg_port(struct saa7164_port *port)
>  	list_for_each_safe(c, n, &port->dmaqueue.list) {
>  		buf = list_entry(c, struct saa7164_buffer, list);
>  
> -		if (buf->flags != SAA7164_BUFFER_FREE)
> -			BUG();
> +		BUG_ON(buf->flags != SAA7164_BUFFER_FREE);
>  
>  		/* Place the buffer in the h/w queue */
>  		saa7164_buffer_activate(buf, i);
>  
>  		/* Don't exceed the device maximum # bufs */
> -		if (i++ > port->hwcfg.buffercount)
> -			BUG();
> +		BUG_ON(i++ > port->hwcfg.buffercount);
>  
>  	}
>  	mutex_unlock(&port->dmaqueue_lock);



Thanks,
Mauro
