Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:16547 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753639AbcHXLqv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 07:46:51 -0400
Subject: Re: [PATCH] [media] ad5820: fix one smatch warning
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
References: <1ee6dd5a918bd98dea20a2847f1ca15964dca952.1472037792.git.mchehab@s-opensource.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57BD8924.9000405@linux.intel.com>
Date: Wed, 24 Aug 2016 14:46:44 +0300
MIME-Version: 1.0
In-Reply-To: <1ee6dd5a918bd98dea20a2847f1ca15964dca952.1472037792.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> drivers/media/i2c/ad5820.c:61:24: error: dubious one-bit signed bitfield
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/i2c/ad5820.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index 62cc1f54622f..d7ad5c1a1219 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -58,7 +58,7 @@ struct ad5820_device {
>  	struct mutex power_lock;
>  	int power_count;
>  
> -	int standby : 1;
> +	unsigned int standby : 1;

I guess a bool would be a better match for this one. It's what it's used
for. [01] assignments should be replaced by boolean values.

I can submit a patch for this as well, up to you.

>  };
>  
>  static int ad5820_write(struct ad5820_device *coil, u16 data)
> 


-- 
Sakari Ailus
sakari.ailus@linux.intel.com
