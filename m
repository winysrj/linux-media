Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39045 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdGMWhJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 18:37:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Colin King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saatvik Arya <aryasaatvik@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Derek Robson <robsonde@gmail.com>,
        Elizabeth Ferdman <gnudevliz@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] staging: media: davinci_vpfe: fix spelling mistake in variable
Date: Fri, 14 Jul 2017 01:37:11 +0300
Message-ID: <7856105.nTqoDBx7k8@avalon>
In-Reply-To: <20170713223416.15077-1-colin.king@canonical.com>
References: <20170713223416.15077-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Colin,

Thank you for the patch.

On Thursday 13 Jul 2017 23:34:16 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake, rename the function name
> resizer_configure_in_continious_mode to
> resizer_configure_in_continuous_mode and also remove an extraneous space.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> b/drivers/staging/media/davinci_vpfe/dm365_resizer.c index
> 857b0e847c5e..d751d590a894 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -480,7 +480,7 @@ resizer_configure_common_in_params(struct
> vpfe_resizer_device *resizer) return 0;
>  }
>  static int
> -resizer_configure_in_continious_mode(struct vpfe_resizer_device *resizer)
> +resizer_configure_in_continuous_mode(struct vpfe_resizer_device *resizer)
>  {
>  	struct device *dev = resizer->crop_resizer.subdev.v4l2_dev->dev;
>  	struct resizer_params *param = &resizer->config;
> @@ -1242,7 +1242,7 @@ static int resizer_do_hw_setup(struct
> vpfe_resizer_device *resizer) ipipeif_source == IPIPEIF_OUTPUT_RESIZER)
>  			ret = resizer_configure_in_single_shot_mode(resizer);
>  		else
> -			ret =  resizer_configure_in_continious_mode(resizer);
> +			ret = resizer_configure_in_continuous_mode(resizer);
>  		if (ret)
>  			return ret;
>  		ret = config_rsz_hw(resizer, param);

-- 
Regards,

Laurent Pinchart
