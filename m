Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbaEIU7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 16:59:50 -0400
Date: Fri, 9 May 2014 13:59:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix _IOC_TYPECHECK sparse error
Message-Id: <20140509135949.feac79f3cb0ed9b13afbfeb4@linux-foundation.org>
In-Reply-To: <536C873E.8060408@xs4all.nl>
References: <536C873E.8060408@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 09 May 2014 09:43:58 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Andrew, can you merge this for 3.15 or 3.16 (you decide)? While it fixes a sparse error
> for the media subsystem, it is not really appropriate to go through our media tree.
> 
> Thanks,
> 
> 	Hans
> 
> 
> When running sparse over drivers/media/v4l2-core/v4l2-ioctl.c I get these
> errors:
> 
> drivers/media/v4l2-core/v4l2-ioctl.c:2043:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2044:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2045:9: error: bad integer constant expression
> drivers/media/v4l2-core/v4l2-ioctl.c:2046:9: error: bad integer constant expression
> 
> etc.
> 
> The root cause of that turns out to be in include/asm-generic/ioctl.h:
> 
> #include <uapi/asm-generic/ioctl.h>
> 
> /* provoke compile error for invalid uses of size argument */
> extern unsigned int __invalid_size_argument_for_IOC;
> #define _IOC_TYPECHECK(t) \
>         ((sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>           sizeof(t) : __invalid_size_argument_for_IOC)
> 
> If it is defined as this (as is already done if __KERNEL__ is not defined):
> 
> #define _IOC_TYPECHECK(t) (sizeof(t))
> 
> then all is well with the world.
> 
> This patch allows sparse to work correctly.
> 
> --- a/include/asm-generic/ioctl.h
> +++ b/include/asm-generic/ioctl.h
> @@ -3,10 +3,15 @@
>  
>  #include <uapi/asm-generic/ioctl.h>
>  
> +#ifdef __CHECKER__
> +#define _IOC_TYPECHECK(t) (sizeof(t))
> +#else
>  /* provoke compile error for invalid uses of size argument */
>  extern unsigned int __invalid_size_argument_for_IOC;
>  #define _IOC_TYPECHECK(t) \
>  	((sizeof(t) == sizeof(t[1]) && \
>  	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>  	  sizeof(t) : __invalid_size_argument_for_IOC)
> +#endif
> +
>  #endif /* _ASM_GENERIC_IOCTL_H */

Can't we use BUILD_BUG_ON() here?  That's neater, more standard and
BUILD_BUG_ON() already has sparse handling.  
