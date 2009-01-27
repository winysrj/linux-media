Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1LRxiN-0000Ok-8B
	for linux-dvb@linuxtv.org; Wed, 28 Jan 2009 00:51:32 +0100
Message-ID: <497F9DFA.3000603@gmail.com>
Date: Wed, 28 Jan 2009 03:51:22 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
References: <20090105170950.GA7131@dreamland.darkstar.lan>
In-Reply-To: <20090105170950.GA7131@dreamland.darkstar.lan>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] saa716x: don't cast pointers to 32bit int
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Luca Tettamanti wrote:
> Pointers may be 64bit long, casting them to u32 is wrong.
> For doing math on the address unsigned long is guaranteed to have to correct
> size to hold the value of the pointer.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> ---
>  Patch applies to HG repo.
> 
>  linux/drivers/media/dvb/saa716x/saa716x_dma.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: saa716x/linux/drivers/media/dvb/saa716x/saa716x_dma.c
> ===================================================================
> --- saa716x.orig/linux/drivers/media/dvb/saa716x/saa716x_dma.c	2008-12-27 21:35:04.000000000 +0100
> +++ saa716x/linux/drivers/media/dvb/saa716x/saa716x_dma.c	2008-12-27 21:35:28.000000000 +0100
> @@ -34,7 +34,7 @@
>  		return -ENOMEM;
>  	}
>  
> -	BUG_ON(!(((u32) dmabuf->mem_ptab_phys % SAA716x_PAGE_SIZE) == 0));
> +	BUG_ON(!(((unsigned long) dmabuf->mem_ptab_phys % SAA716x_PAGE_SIZE) == 0));
>  
>  	return 0;
>  }
> @@ -126,9 +126,9 @@
>  		}
>  
>  		/* align memory to page */
> -		dmabuf->mem_virt = (void *) PAGE_ALIGN (((u32) dmabuf->mem_virt_noalign));
> +		dmabuf->mem_virt = (void *) PAGE_ALIGN (((unsigned long) dmabuf->mem_virt_noalign));
>  
> -		BUG_ON(!((((u32) dmabuf->mem_virt) % SAA716x_PAGE_SIZE) == 0));
> +		BUG_ON(!((((unsigned long) dmabuf->mem_virt) % SAA716x_PAGE_SIZE) == 0));
>  	} else {
>  		dmabuf->mem_virt = buf;
>  	}
> 

Applied.

Thanks,
Manu

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
