Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34489 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935654AbdCJJnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 04:43:37 -0500
Subject: Re: [PATCH] [media] coda: fix warnings when compiling with 64 bits
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <731ad204e54e3c0092668b79c8b3df47502333c6.1489090677.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c3864259-df1b-1bd2-3d29-94ec6f6a04c7@xs4all.nl>
Date: Fri, 10 Mar 2017 10:43:33 +0100
MIME-Version: 1.0
In-Reply-To: <731ad204e54e3c0092668b79c8b3df47502333c6.1489090677.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/17 21:17, Mauro Carvalho Chehab wrote:
> drivers/media/platform/coda/coda-common.c: In function ‘coda_alloc_aux_buf’:
> ./include/linux/kern_levels.h:4:18: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t {aka long unsigned int}’ [-Wformat=]
>  #define KERN_SOH "\001"  /* ASCII Start Of Header */
>                   ^
> ./include/media/v4l2-common.h:69:9: note: in definition of macro ‘v4l2_printk’
>   printk(level "%s: " fmt, (dev)->name , ## arg)
>          ^~~~~
> ./include/linux/kern_levels.h:10:18: note: in expansion of macro ‘KERN_SOH’
>  #define KERN_ERR KERN_SOH "3" /* error conditions */
>                   ^~~~~~~~
> ./include/media/v4l2-common.h:72:14: note: in expansion of macro ‘KERN_ERR’
>   v4l2_printk(KERN_ERR, dev, fmt , ## arg)
>               ^~~~~~~~
> drivers/media/platform/coda/coda-common.c:1341:3: note: in expansion of macro ‘v4l2_err’
>    v4l2_err(&dev->v4l2_dev,
>    ^~~~~~~~

Yes, this too is in my pull request for coda :-)

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/coda/coda-common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index cb76c96759b9..dc51ae2050cc 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1339,7 +1339,7 @@ int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
>  					GFP_KERNEL);
>  	if (!buf->vaddr) {
>  		v4l2_err(&dev->v4l2_dev,
> -			 "Failed to allocate %s buffer of size %u\n",
> +			 "Failed to allocate %s buffer of size %zd\n",
>  			 name, size);
>  		return -ENOMEM;
>  	}
> 
