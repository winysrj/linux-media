Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53721 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754749Ab3ADWvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 17:51:41 -0500
Date: Sat, 5 Jan 2013 00:51:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: ispqueue: Fix uninitialized variable
 compiler warnings
Message-ID: <20130104225136.GI4738@valkosipuli.retiisi.org.uk>
References: <1355734368-6908-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355734368-6908-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Mon, Dec 17, 2012 at 09:52:48AM +0100, Laurent Pinchart wrote:
> drivers/media/platform/omap3isp/ispqueue.c:399:18: warning: 'pa' may be
> used uninitialized in this function [-Wuninitialized]
> 
> This is a false positive but the compiler has no way to know about it,
> so initialize the variable to 0.
> 
> drivers/media/platform/omap3isp/ispqueue.c:445:6: warning:
> 'vm_page_prot' may be used uninitialized in this function
> [-Wuninitialized]
> 
> This is a false positive and the compiler should know better. Use
> uninitialized_var().
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/ispqueue.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
> index 15bf3ea..1388eb7 100644
> --- a/drivers/media/platform/omap3isp/ispqueue.c
> +++ b/drivers/media/platform/omap3isp/ispqueue.c
> @@ -366,7 +366,7 @@ static int isp_video_buffer_prepare_pfnmap(struct isp_video_buffer *buf)
>  	unsigned long this_pfn;
>  	unsigned long start;
>  	unsigned long end;
> -	dma_addr_t pa;
> +	dma_addr_t pa = 0;

Why 0 and not something else arbitrary? :-)

The value will not be used as far as I can tell. If it gets used it
certainly is a bug.

>  	int ret = -EFAULT;
>  
>  	start = buf->vbuf.m.userptr;
> @@ -419,7 +419,7 @@ done:
>  static int isp_video_buffer_prepare_vm_flags(struct isp_video_buffer *buf)
>  {
>  	struct vm_area_struct *vma;
> -	pgprot_t vm_page_prot;
> +	pgprot_t uninitialized_var(vm_page_prot);
>  	unsigned long start;
>  	unsigned long end;
>  	int ret = -EFAULT;

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
