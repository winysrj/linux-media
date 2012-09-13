Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34555 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab2IMKQU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:20 -0400
Received: by qaas11 with SMTP id s11so2953579qaa.19
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 03:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5050CF7B.9040204@gmail.com>
References: <1347449164-6306-1-git-send-email-sangwook.lee@linaro.org>
	<5050CF7B.9040204@gmail.com>
Date: Thu, 13 Sep 2012 11:16:19 +0100
Message-ID: <CADPsn1aoj3u+PYie+GSxV7GJLYagxz7yjv_nwTfzgqYGbWbsDA@mail.gmail.com>
Subject: Re: [RFC PATCH v7] media: add v4l2 subdev driver for S5K4ECGX sensor
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	hans.verkuil@cisco.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, Scott Bambrough <scott.bambrough@linaro.org>,
	Homin Lee <suapapa@insignal.co.kr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco

On 12 September 2012 19:07, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> Hi Sangwook,
> two remarks from my review on September 9th haven't been addressed.

Thanks for the review.
I missed those, please let me correct them and send patch again.

Regards
Sangwook


> I believe those remarks are correct, but please let me know if I'm
> missing something.
> See below.
>
> On 09/12/2012 01:26 PM, Sangwook Lee wrote:
>> +static int s5k4ecgx_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
>> +     int ret;
>> +
>> +     v4l2_dbg(1, debug, sd, "Switching %s\n", on ? "on" : "off");
>> +
>> +     if (on) {
>> +             ret = __s5k4ecgx_power_on(priv);
>> +             if (ret < 0)
>> +                     return ret;
>> +             /* Time to stabilize sensor */
>> +             msleep(100);
>> +             ret = s5k4ecgx_init_sensor(sd);
>> +             if (ret < 0)
>> +                     __s5k4ecgx_power_off(priv);
>> +             else
>> +                     priv->set_params = 1;
>> +     } else {
>> +             ret = __s5k4ecgx_power_off(priv);
>> +     }
>> +
>> +     return 0;
>
> return ret;
>
>> +static int s5k4ecgx_probe(struct i2c_client *client,
>> +                       const struct i2c_device_id *id)
>> +{
>> +     int     ret, i;
>> +     struct v4l2_subdev *sd;
>> +     struct s5k4ecgx *priv;
>> +     struct s5k4ecgx_platform_data *pdata = client->dev.platform_data;
>> +
>> +     if (pdata == NULL) {
>> +             dev_err(&client->dev, "platform data is missing!\n");
>> +             return -EINVAL;
>> +     }
>> +     priv = devm_kzalloc(&client->dev, sizeof(struct s5k4ecgx), GFP_KERNEL);
>> +     if (!priv)
>> +             return -ENOMEM;
>> +
>> +     mutex_init(&priv->lock);
>> +     priv->streaming = 0;
>> +
>> +     sd = &priv->sd;
>> +     /* Registering subdev */
>> +     v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
>> +     strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
>> +
>> +     sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
>> +     /* Support v4l2 sub-device user space API */
>> +     sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +
>> +     priv->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +     sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>> +     ret = media_entity_init(&sd->entity, 1, &priv->pad, 0);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = s5k4ecgx_config_gpios(priv, pdata);
>> +     if (ret) {
>> +             dev_err(&client->dev, "Failed to set gpios\n");
>> +             goto out_err1;
>> +     }
>> +     for (i = 0; i < S5K4ECGX_NUM_SUPPLIES; i++)
>> +             priv->supplies[i].supply = s5k4ecgx_supply_names[i];
>> +
>> +     ret = devm_regulator_bulk_get(&client->dev, S5K4ECGX_NUM_SUPPLIES,
>> +                              priv->supplies);
>> +     if (ret) {
>> +             dev_err(&client->dev, "Failed to get regulators\n");
>> +             goto out_err2;
>> +     }
>> +     ret = s5k4ecgx_init_v4l2_ctrls(priv);
>> +     if (ret)
>> +             goto out_err2;
>> +
>> +     priv->curr_pixfmt = &s5k4ecgx_formats[0];
>> +     priv->curr_frmsize = &s5k4ecgx_prev_sizes[0];
>> +
>> +     return 0;
>> +
>> +out_err2:
>> +     s5k4ecgx_free_gpios(priv);
>> +out_err1:
>> +     media_entity_cleanup(&priv->sd.entity);
>> +
>> +     return ret;
>> +}
>> +
>> +static int s5k4ecgx_remove(struct i2c_client *client)
>> +{
>> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
>> +
>> +     mutex_destroy(&priv->lock);
>> +     v4l2_device_unregister_subdev(sd);
>> +     v4l2_ctrl_handler_free(&priv->handler);
>> +     media_entity_cleanup(&sd->entity);
>> +
>> +     return 0;
>
> s5k4ecgx_free_gpios() should be called to release the GPIOs
>
> Thanks,
> Francesco
