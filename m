Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:60396 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbeKZDqz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 22:46:55 -0500
Date: Sun, 25 Nov 2018 18:55:21 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3] media: video-i2c: check if chip struct has set_power
 function
Message-ID: <20181125165520.75v5ijfy7bnbxy2r@kekkonen.localdomain>
References: <20181124220323.13497-1-matt.ranostay@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124220323.13497-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matt,

On Sat, Nov 24, 2018 at 02:03:23PM -0800, Matt Ranostay wrote:
> Not all future supported video chips will always have power management
> support, and so it is important to check before calling set_power() is
> defined.
> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> ---
> 
> Changes from v2:
> - split out from mlx90640 patch series
> - added to Cc list
> 
> Changes from v1:
> - none
> 
>  drivers/media/i2c/video-i2c.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index b6ebb8d53e90..01dcf179f203 100644
> --- a/drivers/media/i2c/video-i2c.c
> +++ b/drivers/media/i2c/video-i2c.c
> @@ -736,9 +736,11 @@ static int video_i2c_probe(struct i2c_client *client,
>  	video_set_drvdata(&data->vdev, data);
>  	i2c_set_clientdata(client, data);
>  
> -	ret = data->chip->set_power(data, true);
> -	if (ret)
> -		goto error_unregister_device;
> +	if (data->chip->set_power) {
> +		ret = data->chip->set_power(data, true);
> +		if (ret)
> +			goto error_unregister_device;
> +	}

How about adding a macro to call the op if it's set? It could be used to
call other ops when they're set, and ignore them when they're not. Just an
idea. See e.g. v4l2_subdev_call() in include/media/v4l2-subdev.h .

>  
>  	pm_runtime_get_noresume(&client->dev);
>  	pm_runtime_set_active(&client->dev);
> @@ -767,7 +769,9 @@ static int video_i2c_probe(struct i2c_client *client,
>  	pm_runtime_disable(&client->dev);
>  	pm_runtime_set_suspended(&client->dev);
>  	pm_runtime_put_noidle(&client->dev);
> -	data->chip->set_power(data, false);
> +
> +	if (data->chip->set_power)
> +		data->chip->set_power(data, false);
>  
>  error_unregister_device:
>  	v4l2_device_unregister(v4l2_dev);
> @@ -791,7 +795,9 @@ static int video_i2c_remove(struct i2c_client *client)
>  	pm_runtime_disable(&client->dev);
>  	pm_runtime_set_suspended(&client->dev);
>  	pm_runtime_put_noidle(&client->dev);
> -	data->chip->set_power(data, false);
> +
> +	if (data->chip->set_power)
> +		data->chip->set_power(data, false);
>  
>  	video_unregister_device(&data->vdev);
>  
> @@ -804,6 +810,9 @@ static int video_i2c_pm_runtime_suspend(struct device *dev)
>  {
>  	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
>  
> +	if (!data->chip->set_power)
> +		return 0;
> +
>  	return data->chip->set_power(data, false);
>  }
>  
> @@ -811,6 +820,9 @@ static int video_i2c_pm_runtime_resume(struct device *dev)
>  {
>  	struct video_i2c_data *data = i2c_get_clientdata(to_i2c_client(dev));
>  
> +	if (!data->chip->set_power)
> +		return 0;
> +
>  	return data->chip->set_power(data, true);
>  }
>  
> -- 
> 2.17.1
> 

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
