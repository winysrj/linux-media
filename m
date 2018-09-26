Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11363 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726914AbeI0DcC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 23:32:02 -0400
Date: Thu, 27 Sep 2018 00:17:06 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: ov9650: avoid maybe-uninitialized warnings
Message-ID: <20180926211706.eswbm2hgbmgy2oog@kekkonen.localdomain>
References: <20180926125127.2004280-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926125127.2004280-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, Sep 26, 2018 at 02:51:01PM +0200, Arnd Bergmann wrote:
> The regmap change causes multiple warnings like
> 
> drivers/media/i2c/ov9650.c: In function 'ov965x_g_volatile_ctrl':
> drivers/media/i2c/ov9650.c:889:29: error: 'reg2' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>    exposure = ((reg2 & 0x3f) << 10) | (reg1 << 2) |
>               ~~~~~~~~~~~~~~~^~~~~~
> 
> It is apparently hard for the compiler to see here if ov965x_read()
> returned successfully or not. Besides, we have a v4l2_dbg() statement
> that prints an uninitialized value if regmap_read() fails.
> 
> Adding an 'else' clause avoids the ambiguity.

Thanks!

I'm not sure what happened here but the two lines use spaces for
indentation. I've replaced those with tabs.

> 
> Fixes: 361f3803adfe ("media: ov9650: use SCCB regmap")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/i2c/ov9650.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 3c9e6798d14b..77944da31de1 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -433,6 +433,8 @@ static int ov965x_read(struct ov965x *ov965x, u8 addr, u8 *val)
>  	ret = regmap_read(ov965x->regmap, addr, &buf);
>  	if (!ret)
>  		*val = buf;
> +        else
> +                *val = -1;
>  
>  	v4l2_dbg(2, debug, &ov965x->sd, "%s: 0x%02x @ 0x%02x. (%d)\n",
>  		 __func__, *val, addr, ret);

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
