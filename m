Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47887 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZALSuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 13:50:14 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Tue, 13 Jan 2009 00:19:41 +0530
Subject: RE: [PATCH] v4l/tvp514x: make the module aware of rich people
Message-ID: <19F8576C6E063C45BE387C64729E739403ECF709E2@dbde02.ent.ti.com>
In-Reply-To: <20090112182440.GA24931@www.tglx.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
> Sent: Monday, January 12, 2009 11:55 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; Mauro Carvalho Chehab; video4linux-
> list@redhat.com
> Subject: [PATCH] v4l/tvp514x: make the module aware of rich people
> 
> because they might design two of those chips on a single board.
> You never know.
> 
[Hiremath, Vaibhav] Thanks, it was in my todo list. I will verify this patch tomorrow and let you know.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/media/video/tvp514x.c |   52 +++++++++++++++++++++++-------
> ----------
>  1 files changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c
> b/drivers/media/video/tvp514x.c
> index 8e23aa5..f9eb6dc 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -103,7 +103,7 @@ struct tvp514x_std_info {
>   * @route: input and output routing at chip level
>   */
>  struct tvp514x_decoder {
> -	struct v4l2_int_device *v4l2_int_device;
> +	struct v4l2_int_device v4l2_int_device;
>  	const struct tvp514x_platform_data *pdata;
>  	struct i2c_client *client;
> 
> @@ -1369,17 +1369,14 @@ static struct tvp514x_decoder tvp514x_dev =
> {
>  	.current_std = STD_NTSC_MJ,
>  	.std_list = tvp514x_std_list,
>  	.num_stds = ARRAY_SIZE(tvp514x_std_list),
> -
> -};
> -
> -static struct v4l2_int_device tvp514x_int_device = {
> -	.module = THIS_MODULE,
> -	.name = TVP514X_MODULE_NAME,
> -	.priv = &tvp514x_dev,
> -	.type = v4l2_int_type_slave,
> -	.u = {
> -	      .slave = &tvp514x_slave,
> -	      },
> +	.v4l2_int_device = {
> +		.module = THIS_MODULE,
> +		.name = TVP514X_MODULE_NAME,
> +		.type = v4l2_int_type_slave,
> +		.u = {
> +			.slave = &tvp514x_slave,
> +		},
> +	},
>  };
> 
>  /**
> @@ -1392,18 +1389,26 @@ static struct v4l2_int_device
> tvp514x_int_device = {
>  static int
>  tvp514x_probe(struct i2c_client *client, const struct i2c_device_id
> *id)
>  {
> -	struct tvp514x_decoder *decoder = &tvp514x_dev;
> +	struct tvp514x_decoder *decoder;
>  	int err;
> 
>  	/* Check if the adapter supports the needed features */
>  	if (!i2c_check_functionality(client->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -EIO;
> 
> -	decoder->pdata = client->dev.platform_data;
> -	if (!decoder->pdata) {
> +	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
> +	if (!decoder)
> +		return -ENOMEM;
> +
> +	if (!client->dev.platform_data) {
>  		v4l_err(client, "No platform data!!\n");
> -		return -ENODEV;
> +		err = -ENODEV;
> +		goto out_free;
>  	}
> +
> +	*decoder = tvp514x_dev;
> +	decoder->v4l2_int_device.priv = decoder;
> +	decoder->pdata = client->dev.platform_data;
>  	/*
>  	 * Fetch platform specific data, and configure the
>  	 * tvp514x_reg_list[] accordingly. Since this is one
> @@ -1419,23 +1424,26 @@ tvp514x_probe(struct i2c_client *client,
> const struct i2c_device_id *id)
>  	 */
>  	decoder->id = (struct i2c_device_id *)id;
>  	/* Attach to Master */
> -	strcpy(tvp514x_int_device.u.slave->attach_to, decoder->pdata-
> >master);
> -	decoder->v4l2_int_device = &tvp514x_int_device;
> +	strcpy(decoder->v4l2_int_device.u.slave->attach_to, decoder-
> >pdata->master);
>  	decoder->client = client;
>  	i2c_set_clientdata(client, decoder);
> 
>  	/* Register with V4L2 layer as slave device */
> -	err = v4l2_int_device_register(decoder->v4l2_int_device);
> +	err = v4l2_int_device_register(&decoder->v4l2_int_device);
>  	if (err) {
>  		i2c_set_clientdata(client, NULL);
>  		v4l_err(client,
>  			"Unable to register to v4l2. Err[%d]\n", err);
> +		goto out_free;
> 
>  	} else
>  		v4l_info(client, "Registered to v4l2 master %s!!\n",
>  				decoder->pdata->master);
> -
>  	return 0;
> +
> +out_free:
> +	kfree(decoder);
> +	return err;
>  }
> 
>  /**
> @@ -1452,9 +1460,9 @@ static int __exit tvp514x_remove(struct
> i2c_client *client)
>  	if (!client->adapter)
>  		return -ENODEV;	/* our client isn't attached */
> 
> -	v4l2_int_device_unregister(decoder->v4l2_int_device);
> +	v4l2_int_device_unregister(&decoder->v4l2_int_device);
>  	i2c_set_clientdata(client, NULL);
> -
> +	kfree(decoder);
>  	return 0;
>  }
>  /*
> --
> 1.5.6.5
> 

