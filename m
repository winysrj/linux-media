Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26154 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756303AbdIHOjF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 10:39:05 -0400
Date: Fri, 8 Sep 2017 17:38:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srishti Sharma <srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: omap4iss: Use WARN_ON() instead of
 BUG_ON().
Message-ID: <20170908143833.yisoj3t2yp5httle@mwanda>
References: <1504879698-5855-1-git-send-email-srishtishar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504879698-5855-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 08, 2017 at 07:38:18PM +0530, Srishti Sharma wrote:
> Use WARN_ON() instead of BUG_ON() to avoid crashing the kernel.
> 
> Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
> ---
>  drivers/staging/media/omap4iss/iss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index c26c99fd..b1036ba 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -893,7 +893,7 @@ void omap4iss_put(struct iss_device *iss)
>  		return;
> 
>  	mutex_lock(&iss->iss_mutex);
> -	BUG_ON(iss->ref_count == 0);
> +	WARN_ON(iss->ref_count == 0);

ref_counting bugs often have a security aspect.  BUG_ON() is probably
safer here.  Better to crash than to lose all your bitcoin.

regards,
dan carpenter
