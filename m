Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25051 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdIMIWc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:22:32 -0400
Date: Wed, 13 Sep 2017 11:22:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] drivers:staging/media:Use ARRAY_SIZE() for the size
 calculation of the array
Message-ID: <20170913082211.2btqdehfq7co4mtx@mwanda>
References: <1505289879-26163-1-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505289879-26163-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You need a changelog.

On Wed, Sep 13, 2017 at 01:34:39PM +0530, Allen Pais wrote:
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> index e882b55..d822918 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
> @@ -451,7 +451,7 @@ static enum ia_css_frame_format yuv422_copy_formats[] = {
>  	IA_CSS_FRAME_FORMAT_YUYV
>  };
>  
> -#define array_length(array) (sizeof(array)/sizeof(array[0]))
> +#define array_length(array) (ARRAY_SIZE(array))

Just get rid of this array_length macro and use ARRAY_SIZE() directly.

regards,
dan carpenter
