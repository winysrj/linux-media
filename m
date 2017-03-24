Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39755 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753963AbdCXI2p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 04:28:45 -0400
Date: Fri, 24 Mar 2017 11:28:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MEDIA INPUT INFRASTRUCTURE V4L/DVB"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH] drivers/staging/media: atomisp: Removing redundant
 information from dev_err
Message-ID: <20170324082832.GP32449@mwanda>
References: <1490334513-7721-1-git-send-email-pushkar.iit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490334513-7721-1-git-send-email-pushkar.iit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 24, 2017 at 11:18:33AM +0530, Pushkar Jambhlekar wrote:
> Removing hardcoded function name as code is already using __func__
> 
> Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> index d1a609d2..a51a27b 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
> @@ -64,7 +64,7 @@ struct hmm_buffer_object *__bo_alloc(struct kmem_cache *bo_cache)
>  
>  	bo = kmem_cache_alloc(bo_cache, GFP_KERNEL);
>  	if (!bo)
> -		dev_err(atomisp_dev, "%s: __bo_alloc failed!\n", __func__);
> +		dev_err(atomisp_dev, "%s: failed!\n", __func__);

The whole printk can be removed.  kmem_cache_alloc() has its own better
printks.

regards,
dan carpenter
