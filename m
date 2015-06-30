Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50577 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbbF3JFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 05:05:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] mt9v032: Add missing initialization of pdata in mt9v032_get_pdata()
Date: Tue, 30 Jun 2015 12:05:12 +0300
Message-ID: <2598276.2OYSshb3AX@avalon>
In-Reply-To: <1435580621-21663-1-git-send-email-geert@linux-m68k.org>
References: <1435580621-21663-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the patch.

On Monday 29 June 2015 14:23:41 Geert Uytterhoeven wrote:
> drivers/media/i2c/mt9v032.c: In function ‘mt9v032_get_pdata’:
> drivers/media/i2c/mt9v032.c:885: warning: ‘pdata’ may be used uninitialized
> in this function
> 
> If parsing the endpoint node properties fails, mt9v032_get_pdata() will
> return an uninitialized pointer value.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/i2c/mt9v032.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 977f4006edbd496d..a68ce94ee097604a 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -882,7 +882,7 @@ static const struct regmap_config mt9v032_regmap_config
> = { static struct mt9v032_platform_data *
>  mt9v032_get_pdata(struct i2c_client *client)
>  {
> -	struct mt9v032_platform_data *pdata;
> +	struct mt9v032_platform_data *pdata = NULL;
>  	struct v4l2_of_endpoint endpoint;
>  	struct device_node *np;
>  	struct property *prop;

-- 
Regards,

Laurent Pinchart

