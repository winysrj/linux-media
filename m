Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52779 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751107AbeCZK2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 06:28:44 -0400
Date: Mon, 26 Mar 2018 13:28:15 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH 08/30] media: v4l2-ioctl: fix some "too small" warnings
Message-ID: <20180326102814.mq7qg3aaagzcwvr4@paasikivi.fi.intel.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
 <912d2f8228be077a1743adb797ada1dfcfe99c81.1521806166.git.mchehab@s-opensource.com>
 <20180323215356.3ib2ho2q7sd5z27v@kekkonen.localdomain>
 <20180326070816.26859af6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326070816.26859af6@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Mar 26, 2018 at 07:08:16AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 23 Mar 2018 23:53:56 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > Hi Mauro,
> > 
> > On Fri, Mar 23, 2018 at 07:56:54AM -0400, Mauro Carvalho Chehab wrote:
> > > While the code there is right, it produces three false positives:
> > > 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error: copy_from_user() 'parg' too small (128 vs 16383)
> > > 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error: copy_from_user() 'parg' too small (128 vs 16383)
> > > 	drivers/media/v4l2-core/v4l2-ioctl.c:2876 video_usercopy() error: memset() 'parg' too small (128 vs 16383)
> > > 
> > > Store the ioctl size on a cache var, in order to suppress those.  
> > 
> > I have to say I'm not a big fan of changing perfectly fine code in order to
> > please static analysers.
> 
> Well, there's a side effect of this patch: it allows gcc to better
> optimize the text size, with is good:
> 
>    text	   data	    bss	    dec	    hex	filename
>   34538	   2320	      0	  36858	   8ffa	old/drivers/media/v4l2-core/v4l2-ioctl.o
>   34490	   2320	      0	  36810	   8fca	new/drivers/media/v4l2-core/v4l2-ioctl.o
> 
> > What's this, smatch? I wonder if it could be fixed
> > instead of changing the code. That'd be presumably a lot more work though.
> 
> Yes, the warnings came from smatch. No idea how easy/hard would be to
> change it. 
> 
> > 
> > On naming --- "size" is rather more generic, but it's not a long function
> > either. I'd be a bit more specific, e.g. ioc_size or arg_size.
> 
> Agreed.
> 
> I'll add the enclosed patch changing it to ioc_size.

Thanks. To the original + this change:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> 
> 
> Thanks,
> Mauro
> 
> [PATCH] media: v4l2-ioctl: rename a temp var that stores _IOC_SIZE(cmd)
>     
> Instead of just calling it as "size", let's name it as "ioc_size",
> as it reflects better its contents.
>     
> As this is constant along the function, also mark it as const.
>     
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index a5dab16ff2d2..f48c505550e0 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2833,15 +2833,15 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	size_t  array_size = 0;
>  	void __user *user_ptr = NULL;
>  	void	**kernel_ptr = NULL;
> -	size_t	size = _IOC_SIZE(cmd);
> +	const size_t ioc_size = _IOC_SIZE(cmd);
>  
>  	/*  Copy arguments into temp kernel buffer  */
>  	if (_IOC_DIR(cmd) != _IOC_NONE) {
> -		if (size <= sizeof(sbuf)) {
> +		if (ioc_size <= sizeof(sbuf)) {
>  			parg = sbuf;
>  		} else {
>  			/* too big to allocate from stack */
> -			mbuf = kvmalloc(size, GFP_KERNEL);
> +			mbuf = kvmalloc(ioc_size, GFP_KERNEL);
>  			if (NULL == mbuf)
>  				return -ENOMEM;
>  			parg = mbuf;
> @@ -2849,7 +2849,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  
>  		err = -EFAULT;
>  		if (_IOC_DIR(cmd) & _IOC_WRITE) {
> -			unsigned int n = size;
> +			unsigned int n = ioc_size;
>  
>  			/*
>  			 * In some cases, only a few fields are used as input,
> @@ -2870,11 +2870,11 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  				goto out;
>  
>  			/* zero out anything we don't copy from userspace */
> -			if (n < size)
> -				memset((u8 *)parg + n, 0, size - n);
> +			if (n < ioc_size)
> +				memset((u8 *)parg + n, 0, ioc_size - n);
>  		} else {
>  			/* read-only ioctl */
> -			memset(parg, 0, size);
> +			memset(parg, 0, ioc_size);
>  		}
>  	}
>  
> @@ -2932,7 +2932,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	switch (_IOC_DIR(cmd)) {
>  	case _IOC_READ:
>  	case (_IOC_WRITE | _IOC_READ):
> -		if (copy_to_user((void __user *)arg, parg, size))
> +		if (copy_to_user((void __user *)arg, parg, ioc_size))
>  			err = -EFAULT;
>  		break;
>  	}
> 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
