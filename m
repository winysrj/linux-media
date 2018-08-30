Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:33333 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727466AbeH3Lki (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 07:40:38 -0400
Subject: =?UTF-8?Q?Re:_[PATCH_1/3]_v4l:_subdev:_Add_a_function_to_set_an_I?=
 =?UTF-8?Q?=c2=b2C_sub-device's_name?=
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20180829105233.3852-1-sakari.ailus@linux.intel.com>
 <20180829105233.3852-2-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e08214f5-b8b3-5cbb-1a0c-f94eb7d809ec@xs4all.nl>
Date: Thu, 30 Aug 2018 09:39:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180829105233.3852-2-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2018 12:52 PM, Sakari Ailus wrote:
> v4l2_i2c_subdev_set_name() can be used to assign a name to a sub-device.
> This way uniform names can be formed easily without having to resort to
> things such as snprintf in drivers.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-common.c | 18 ++++++++++++++----
>  include/media/v4l2-common.h           | 12 ++++++++++++
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index b518b92d6d96..9c48b90b4ae8 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -109,6 +109,19 @@ EXPORT_SYMBOL(v4l2_ctrl_query_fill);
>  
>  #if IS_ENABLED(CONFIG_I2C)
>  
> +void v4l2_i2c_subdev_set_name(struct v4l2_subdev *sd, struct i2c_client *client,
> +			      const char *devname, const char *postfix)
> +{
> +	if (!devname)
> +		devname = client->dev.driver->name;
> +	if (!postfix)
> +		postfix = "";
> +
> +	snprintf(sd->name, sizeof(sd->name), "%s%s %d-%04x", devname, postfix,
> +		 i2c_adapter_id(client->adapter), client->addr);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_set_name);
> +
>  void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
>  		const struct v4l2_subdev_ops *ops)
>  {
> @@ -120,10 +133,7 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
>  	/* i2c_client and v4l2_subdev point to one another */
>  	v4l2_set_subdevdata(sd, client);
>  	i2c_set_clientdata(client, sd);
> -	/* initialize name */
> -	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
> -		client->dev.driver->name, i2c_adapter_id(client->adapter),
> -		client->addr);
> +	v4l2_i2c_subdev_set_name(sd, client, NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
>  
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index cdc87ec61e54..bd880a909ecf 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -155,6 +155,18 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
>  		const unsigned short *probe_addrs);
>  
>  /**
> + * v4l2_i2c_subdev_set_name - Set name for an I²C sub-device
> + *
> + * @sd: pointer to &struct v4l2_subdev
> + * @client: pointer to struct i2c_client
> + * @devname: the name of the device; if NULL, the I²C device's name will be used
> + * @postfix: sub-device specific string to put right after the I²C device name;
> + *	     may be NULL
> + */
> +void v4l2_i2c_subdev_set_name(struct v4l2_subdev *sd, struct i2c_client *client,
> +			      const char *devname, const char *postfix);
> +
> +/**
>   * v4l2_i2c_subdev_init - Initializes a &struct v4l2_subdev with data from
>   *	an i2c_client struct.
>   *
> 
