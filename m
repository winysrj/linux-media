Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51660 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750749AbcBGSIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Feb 2016 13:08:48 -0500
Date: Sun, 7 Feb 2016 20:08:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Anton Protopopov <a.s.protopopov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c/adp1653: probe: fix erroneous return value
Message-ID: <20160207180845.GE32612@valkosipuli.retiisi.org.uk>
References: <1454819252-6773-1-git-send-email-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454819252-6773-1-git-send-email-a.s.protopopov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anton,

On Sat, Feb 06, 2016 at 11:27:32PM -0500, Anton Protopopov wrote:
> The adp1653_probe() function may return positive value EINVAL
> which is obviously wrong.
> 
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> ---
>  drivers/media/i2c/adp1653.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 7e9cbf7..fb7ed73 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -497,7 +497,7 @@ static int adp1653_probe(struct i2c_client *client,
>  		if (!client->dev.platform_data) {
>  			dev_err(&client->dev,
>  				"Neither DT not platform data provided\n");
> -			return EINVAL;
> +			return -EINVAL;
>  		}
>  		flash->platform_data = client->dev.platform_data;
>  	}

Thanks!

Applied to my tree.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
