Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44829 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbFSIC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 04:02:59 -0400
Date: Fri, 19 Jun 2015 11:02:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sunil Shahu <shshahu@gmail.com>
Cc: mchehab@osg.samsung.com, devel@driverdev.osuosl.org,
	hamohammed.sa@gmail.com, arnd@arndb.de, tapaswenipathak@gmail.com,
	gregkh@linuxfoundation.org, jarod@wilsonet.com,
	gulsah.1004@gmail.com, amber.rose.thrall@gmail.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: lirc: fix coding style error
Message-ID: <20150619080232.GN28762@mwanda>
References: <1434544292-32742-1-git-send-email-shshahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1434544292-32742-1-git-send-email-shshahu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 17, 2015 at 06:01:32PM +0530, Sunil Shahu wrote:
> Fix code indentation error by replacing tab in place of spaces.
> 
> Signed-off-by: Sunil Shahu <shshahu@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_sasem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
> index 8ebee96..12aae72 100644
> --- a/drivers/staging/media/lirc/lirc_sasem.c
> +++ b/drivers/staging/media/lirc/lirc_sasem.c
> @@ -185,7 +185,7 @@ static void deregister_from_lirc(struct sasem_context *context)
>  		       __func__, retval);
>  	else
>  		dev_info(&context->dev->dev,
> -		         "Deregistered Sasem driver (minor:%d)\n", minor);
> +			"Deregistered Sasem driver (minor:%d)\n", minor);

Not quite.  The original is:

[tab][tab][space][space][space][space][space][space][space][space][space]"Dere...

You have:

[tab][tab][tab]"Deregistered Sasem driver ...

It should be:

[tab][tab][tab][space]"Deregistered Sasem driver (minor:%d)\n", minor);

regards,
dan carpenter

