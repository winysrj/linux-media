Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34892 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753406AbeC1OOG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 10:14:06 -0400
Date: Wed, 28 Mar 2018 17:13:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: devel@driverdev.osuosl.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 12/18] media: staging: atomisp: avoid a warning if 32
 bits build
Message-ID: <20180328141329.6nhx5qcaigqwz25d@mwanda>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
 <313cb7db7e3fc7c7c14d2e82e249ccebcbd51ff8.1522098456.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <313cb7db7e3fc7c7c14d2e82e249ccebcbd51ff8.1522098456.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2018 at 05:10:45PM -0400, Mauro Carvalho Chehab wrote:
> Checking if a size_t value is bigger than ULONG_INT only makes
> sense if building on 64 bits, as warned by:
> 	drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c:697 gmin_get_config_var() warn: impossible condition '(*out_len > (~0)) => (0-u32max > u32max)'
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  .../staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c    | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> index be0c5e11e86b..3283c1b05d6a 100644
> --- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> +++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
> @@ -693,9 +693,11 @@ static int gmin_get_config_var(struct device *dev, const char *var,
>  	for (i = 0; i < sizeof(var8) && var8[i]; i++)
>  		var16[i] = var8[i];
>  
> +#ifdef CONFIG_64BIT
>  	/* To avoid owerflows when calling the efivar API */
>  	if (*out_len > ULONG_MAX)
>  		return -EINVAL;
> +#endif

I should just silence this particular warning in Smatch.  I feel like
this is a pretty common thing and the ifdefs aren't very pretty.  :(

regards,
dan carpenter
