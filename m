Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:41407 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbZEAD0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 23:26:39 -0400
Received: by gxk10 with SMTP id 10so4532451gxk.13
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 20:26:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090428090129.17081.782.sendpatchset@rx1.opensource.se>
References: <20090428090129.17081.782.sendpatchset@rx1.opensource.se>
Date: Fri, 1 May 2009 12:26:38 +0900
Message-ID: <aec7e5c30904302026q42ecbd57m6e88c937bbd262bb@mail.gmail.com>
Subject: Re: [PATCH] videobuf-dma-contig: zero copy USERPTR support V2
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, linux-mm@kvack.org,
	Magnus Damm <magnus.damm@gmail.com>, lethal@linux-sh.org,
	hannes@cmpxchg.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2009 at 6:01 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> This is V2 of the V4L2 videobuf-dma-contig USERPTR zero copy patch.

I guess the V4L2 specific bits are pretty simple.

As for the minor mm modifications below,

> --- 0001/mm/memory.c
> +++ work/mm/memory.c    2009-04-28 14:56:43.000000000 +0900
> @@ -3009,7 +3009,6 @@ int in_gate_area_no_task(unsigned long a
>
>  #endif /* __HAVE_ARCH_GATE_AREA */
>
> -#ifdef CONFIG_HAVE_IOREMAP_PROT
>  int follow_phys(struct vm_area_struct *vma,
>                unsigned long address, unsigned int flags,
>                unsigned long *prot, resource_size_t *phys)

Is it ok with the memory management guys to always build follow_phys()?

> @@ -3063,7 +3062,9 @@ unlock:
>  out:
>        return ret;
>  }
> +EXPORT_SYMBOL(follow_phys);
>
> +#ifdef CONFIG_HAVE_IOREMAP_PROT
>  int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>                        void *buf, int len, int write)
>  {

How about exporting follow_phys()? This because the user
videobuf-dma-contig.c can be built as a module.

Should I use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL()?

Any comments?

Thanks,

/ magnus
