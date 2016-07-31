Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43926 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750748AbcGaLJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2016 07:09:23 -0400
Date: Sun, 31 Jul 2016 14:09:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] i2c: Modify error handling
Message-ID: <20160731110915.GE3243@valkosipuli.retiisi.org.uk>
References: <20160731035800.GA4576@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160731035800.GA4576@amitoj-Inspiron-3542>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Amitoj,

On Sun, Jul 31, 2016 at 09:28:00AM +0530, Amitoj Kaur Chawla wrote:
> devm_gpiod_get returns an ERR_PTR on error so a null check is
> incorrect and an IS_ERR check is required.
> 
> The Coccinelle semantic patch used to make this change is as follows:
> @@
> expression e;
> statement S;
> @@
> 
>   e = devm_gpiod_get(...);
>  if(
> -   !e
> +   IS_ERR(e)
>    )
>   {
>    ...
> -  return ...;
> +  return PTR_ERR(e);
>   }
> 
> Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
> ---
>  drivers/media/i2c/adp1653.c | 4 ++--

In this exact case, the issue has been fixed by similar patch in media-tree
master branch. You likely used another branch for preparing this patch.

Nevertheless, thank you for the patch --- this kind of cleanups are always
much appreciated.

commit 806f8ffa8a0fa9a6f0481c5648c27aa51d10fdc6
Author: Vladimir Zapolskiy <vz@mleia.com>
Date:   Mon Mar 7 15:39:32 2016 -0300

    [media] media: i2c/adp1653: fix check of devm_gpiod_get() error code
    
    The devm_gpiod_get() function returns either a valid pointer to
    struct gpio_desc or ERR_PTR() error value, check for NULL is bogus.
    
    Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index fb7ed73..9e1731c 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -466,9 +466,9 @@ static int adp1653_of_init(struct i2c_client *client,
        of_node_put(child);
 
        pd->enable_gpio = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-       if (!pd->enable_gpio) {
+       if (IS_ERR(pd->enable_gpio)) {
                dev_err(&client->dev, "Error getting GPIO\n");
-               return -EINVAL;
+               return PTR_ERR(pd->enable_gpio);
        }
 
        return 0;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
