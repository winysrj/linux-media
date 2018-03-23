Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22562 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751288AbeCWVyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:54:00 -0400
Date: Fri, 23 Mar 2018 23:53:56 +0200
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
Message-ID: <20180323215356.3ib2ho2q7sd5z27v@kekkonen.localdomain>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
 <912d2f8228be077a1743adb797ada1dfcfe99c81.1521806166.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <912d2f8228be077a1743adb797ada1dfcfe99c81.1521806166.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Mar 23, 2018 at 07:56:54AM -0400, Mauro Carvalho Chehab wrote:
> While the code there is right, it produces three false positives:
> 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error: copy_from_user() 'parg' too small (128 vs 16383)
> 	drivers/media/v4l2-core/v4l2-ioctl.c:2868 video_usercopy() error: copy_from_user() 'parg' too small (128 vs 16383)
> 	drivers/media/v4l2-core/v4l2-ioctl.c:2876 video_usercopy() error: memset() 'parg' too small (128 vs 16383)
> 
> Store the ioctl size on a cache var, in order to suppress those.

I have to say I'm not a big fan of changing perfectly fine code in order to
please static analysers. What's this, smatch? I wonder if it could be fixed
instead of changing the code. That'd be presumably a lot more work though.

On naming --- "size" is rather more generic, but it's not a long function
either. I'd be a bit more specific, e.g. ioc_size or arg_size.

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 672ab22ccd96..a5dab16ff2d2 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2833,14 +2833,15 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	size_t  array_size = 0;
>  	void __user *user_ptr = NULL;
>  	void	**kernel_ptr = NULL;
> +	size_t	size = _IOC_SIZE(cmd);
>  
>  	/*  Copy arguments into temp kernel buffer  */
>  	if (_IOC_DIR(cmd) != _IOC_NONE) {
> -		if (_IOC_SIZE(cmd) <= sizeof(sbuf)) {
> +		if (size <= sizeof(sbuf)) {
>  			parg = sbuf;
>  		} else {
>  			/* too big to allocate from stack */
> -			mbuf = kvmalloc(_IOC_SIZE(cmd), GFP_KERNEL);
> +			mbuf = kvmalloc(size, GFP_KERNEL);
>  			if (NULL == mbuf)
>  				return -ENOMEM;
>  			parg = mbuf;
> @@ -2848,7 +2849,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  
>  		err = -EFAULT;
>  		if (_IOC_DIR(cmd) & _IOC_WRITE) {
> -			unsigned int n = _IOC_SIZE(cmd);
> +			unsigned int n = size;
>  
>  			/*
>  			 * In some cases, only a few fields are used as input,
> @@ -2869,11 +2870,11 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  				goto out;
>  
>  			/* zero out anything we don't copy from userspace */
> -			if (n < _IOC_SIZE(cmd))
> -				memset((u8 *)parg + n, 0, _IOC_SIZE(cmd) - n);
> +			if (n < size)
> +				memset((u8 *)parg + n, 0, size - n);
>  		} else {
>  			/* read-only ioctl */
> -			memset(parg, 0, _IOC_SIZE(cmd));
> +			memset(parg, 0, size);
>  		}
>  	}
>  
> @@ -2931,7 +2932,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	switch (_IOC_DIR(cmd)) {
>  	case _IOC_READ:
>  	case (_IOC_WRITE | _IOC_READ):
> -		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
> +		if (copy_to_user((void __user *)arg, parg, size))
>  			err = -EFAULT;
>  		break;
>  	}

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
