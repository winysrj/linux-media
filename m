Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54991 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727098AbeH3LlH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 07:41:07 -0400
Subject: Re: [PATCH 3/3] sr030pc30: Remove redundant setting of sub-device
 name
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
 <20180829105233.3852-4-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fa02a500-6516-3427-e0a5-9fba4b2b0cc4@xs4all.nl>
Date: Thu, 30 Aug 2018 09:40:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180829105233.3852-4-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2018 12:52 PM, Sakari Ailus wrote:
> The sub-device name is set right after in v4l2_i2c_subdev_init(). Remove
> the redundant strcpy() call.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>


Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/i2c/sr030pc30.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
> index 2a4882cddc51..3d3fb1cda28c 100644
> --- a/drivers/media/i2c/sr030pc30.c
> +++ b/drivers/media/i2c/sr030pc30.c
> @@ -703,7 +703,6 @@ static int sr030pc30_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	sd = &info->sd;
> -	strcpy(sd->name, MODULE_NAME);
>  	info->pdata = client->dev.platform_data;
>  
>  	v4l2_i2c_subdev_init(sd, client, &sr030pc30_ops);
> 
