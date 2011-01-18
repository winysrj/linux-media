Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:7141 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab1ARCXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 21:23:24 -0500
Subject: Re: [PATCH][_COMPAT_H] git://linuxtv.org/media_build.git Legacy
 issues
From: Andy Walls <awalls@md.metrocast.net>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1295305161.2162.21.camel@tvboxspy>
References: <1295305161.2162.21.camel@tvboxspy>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 21:22:41 -0500
Message-ID: <1295317361.12544.22.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-17 at 22:59 +0000, Malcolm Priestley wrote:
> Clean up legacy issues for error free build on Kernel 2.6.37.
> 
> Today while testing on Kernel 2.6.35 latest tarball throws error with 
> alloc_ordered_workqueue undefined on Kernels less than 2.6.37. defined back to 
> create_singlethread_workqueue.
> 
> Please test on other kernel versions.
>
> Tested-on 2.6.35/37 by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> 
> diff --git a/v4l/compat.h b/v4l/compat.h
> index 9e622ce..df98698 100644
> --- a/v4l/compat.h
> +++ b/v4l/compat.h
> @@ -749,6 +749,8 @@ static inline void *vzalloc(unsigned long size)
>  
>  #endif
>  
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 37)
> +
>  #if NEED_FLUSH_WORK_SYNC
>  #define flush_work_sync(dev)
>  #endif
> @@ -760,6 +762,14 @@ static inline void *vzalloc(unsigned long size)
>  }
>  #endif
>  
> +#define alloc_ordered_workqueue(a,b) create_singlethread_workqueue(a)

That will get cx18 to compile.  However, I can tell you without testing,
the latest cx18 driver could badly affect system event processing
performance on older kernels.

This is because another change happened at the same time as the change
to call alloc_ordered_workqueue().  A kernel version before that, CMWQ
was added to the kernel, so there was no longer a need for the
cx18_out_work workqueue.  So now the cx18_out_work workqueue has been
removed from the cx18 driver.

In the older kernels without CMWQ and without the cx18_out_work
workqueue, outgoing cx18 buffer work will get queued to the [keventd/M]
kernel threads.  Unrelated system work being processed by [keventd/M]
threads will regularly find itself *waiting for the CX23418 hardware* to
respond to firmware commands.

It would be better to not allow the newest cx18 driver version to
compile on older kernels.

Regards,
Andy

