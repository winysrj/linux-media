Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab2GOXZH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 19:25:07 -0400
Message-ID: <5003514E.2080406@linux.intel.com>
Date: Mon, 16 Jul 2012 02:25:02 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 8/9] soc-camera: Add and use soc_camera_power_[on|off]()
 helper functions
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341520728-2707-9-git-send-email-laurent.pinchart@ideasonboard.com> <50034F97.9060208@linux.intel.com>
In-Reply-To: <50034F97.9060208@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2012 02:17 AM, David Cohen wrote:
> Hi Laurent,
>
> Few more comments below :)
>
> On 07/05/2012 11:38 PM, Laurent Pinchart wrote:
>> Instead of forcing all soc-camera drivers to go through the mid-layer to
>> handle power management, create soc_camera_power_[on|off]() functions
>> that can be called from the subdev .s_power() operation to manage
>> regulators and platform-specific power handling. This allows non
>> soc-camera hosts to use soc-camera-aware clients.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> ---
>>   drivers/media/video/imx074.c              |    9 +++
>>   drivers/media/video/mt9m001.c             |    9 +++
>>   drivers/media/video/mt9m111.c             |   52 +++++++++++++-----
>>   drivers/media/video/mt9t031.c             |   11 +++-
>>   drivers/media/video/mt9t112.c             |    9 +++
>>   drivers/media/video/mt9v022.c             |    9 +++
>>   drivers/media/video/ov2640.c              |    9 +++
>>   drivers/media/video/ov5642.c              |   10 +++-
>>   drivers/media/video/ov6650.c              |    9 +++
>>   drivers/media/video/ov772x.c              |    9 +++
>>   drivers/media/video/ov9640.c              |   10 +++-
>>   drivers/media/video/ov9740.c              |   15 +++++-
>>   drivers/media/video/rj54n1cb0c.c          |    9 +++
>>   drivers/media/video/soc_camera.c          |   83
>> +++++++++++++++++------------
>>   drivers/media/video/soc_camera_platform.c |   11 ++++-
>>   drivers/media/video/tw9910.c              |    9 +++
>>   include/media/soc_camera.h                |   10 ++++
>>   17 files changed, 225 insertions(+), 58 deletions(-)
>>
>
> [snip]
>
>> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
>> index 3eb07c2..effd0f1 100644
>> --- a/drivers/media/video/ov9740.c
>> +++ b/drivers/media/video/ov9740.c
>> @@ -786,16 +786,29 @@ static int ov9740_g_chip_ident(struct
>> v4l2_subdev *sd,
>>
>>   static int ov9740_s_power(struct v4l2_subdev *sd, int on)
>>   {
>> +    struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +    struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>>       struct ov9740_priv *priv = to_ov9740(sd);
>> +    int ret;
>>
>> -    if (!priv->current_enable)
>> +    if (on) {
>> +        ret = soc_camera_power_on(&client->dev, icl);
>> +        if (ret < 0)
>> +            return ret;
>> +    }
>> +
>> +    if (!priv->current_enable) {
>> +        if (!on)
>> +            soc_camera_power_off(&client->dev, icl);
>
> After your changes, this function has 3 if's (one nested) where all of
> them checks "on" variable due to you need to mix "on" and
> "priv->current_enable" checks. However, code's traceability is not so
> trivial.
> How about if you nest "priv->current_enable" into last "if" and keep
> only that one?
>
> See an incomplete code below:
>
>>           return 0;
>> +    }
>>
>>       if (on) {
>
> soc_camera_power_on();
> if (!priv->current_enable)
>      return;
>
>>           ov9740_s_fmt(sd, &priv->current_mf);
>>           ov9740_s_stream(sd, priv->current_enable);
>>       } else {
>>           ov9740_s_stream(sd, 0);
>
> Execute ov9740_s_stream() conditionally:
> if (priv->current_enable) {
>      ov9740_s_stream();
>      priv->current_enable = true;
> }
>
>> +        soc_camera_power_off(&client->dev, icl);
>>           priv->current_enable = true;
>
> priv->current_enable is set to false when ov9740_s_stream(0) is called
> then this function sets it back to true afterwards. So, in case you want
> to have no functional change, it seems to me you should call

Let me just correct my sentence:
s/no functional change/no potential functional change/

Br,

David

> soc_camera_power_off() after that variable has its original value set
> back.
> In this case, even if you don't like my suggestion, you still need to
> swap those 2 lines above. :)
>
> Br,
>
> David Cohen
>
>>       }
>>
>> diff --git a/drivers/media/video/rj54n1cb0c.c
>> b/drivers/media/video/rj54n1cb0c.c
>> index f6419b2..ca1cee7 100644
>> --- a/drivers/media/video/rj54n1cb0c.c
>> +++ b/drivers/media/video/rj54n1cb0c.c
>> @@ -1180,6 +1180,14 @@ static int rj54n1_s_register(struct v4l2_subdev
>> *sd,
>>   }
>>   #endif
>>
>> +static int rj54n1_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +    struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +    struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>> +
>> +    return soc_camera_set_power(&client->dev, icl, on);
>> +}
>> +
>>   static int rj54n1_s_ctrl(struct v4l2_ctrl *ctrl)
>>   {
>>       struct rj54n1 *rj54n1 = container_of(ctrl->handler, struct
>> rj54n1, hdl);
>> @@ -1230,6 +1238,7 @@ static struct v4l2_subdev_core_ops
>> rj54n1_subdev_core_ops = {
>>       .g_register    = rj54n1_g_register,
>>       .s_register    = rj54n1_s_register,
>>   #endif
>> +    .s_power    = rj54n1_s_power,
>>   };
>>
>>   static int rj54n1_g_mbus_config(struct v4l2_subdev *sd,
>> diff --git a/drivers/media/video/soc_camera.c
>> b/drivers/media/video/soc_camera.c
>> index bbd518f..576146e 100644
>> --- a/drivers/media/video/soc_camera.c
>> +++ b/drivers/media/video/soc_camera.c
>> @@ -50,63 +50,72 @@ static LIST_HEAD(hosts);
>>   static LIST_HEAD(devices);
>>   static DEFINE_MUTEX(list_lock);        /* Protects the list of hosts */
>>
>> -static int soc_camera_power_on(struct soc_camera_device *icd,
>> -                   struct soc_camera_link *icl)
>> +int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
>>   {
>> -    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>       int ret = regulator_bulk_enable(icl->num_regulators,
>>                       icl->regulators);
>>       if (ret < 0) {
>> -        dev_err(icd->pdev, "Cannot enable regulators\n");
>> +        dev_err(dev, "Cannot enable regulators\n");
>>           return ret;
>>       }
>>
>>       if (icl->power) {
>> -        ret = icl->power(icd->control, 1);
>> +        ret = icl->power(dev, 1);
>>           if (ret < 0) {
>> -            dev_err(icd->pdev,
>> +            dev_err(dev,
>>                   "Platform failed to power-on the camera.\n");
>> -            goto elinkpwr;
>> +            regulator_bulk_disable(icl->num_regulators,
>> +                           icl->regulators);
>>           }
>>       }
>>
>> -    ret = v4l2_subdev_call(sd, core, s_power, 1);
>> -    if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
>> -        goto esdpwr;
>> -
>> -    return 0;
>> -
>> -esdpwr:
>> -    if (icl->power)
>> -        icl->power(icd->control, 0);
>> -elinkpwr:
>> -    regulator_bulk_disable(icl->num_regulators,
>> -                   icl->regulators);
>>       return ret;
>>   }
>> +EXPORT_SYMBOL(soc_camera_power_on);
>>
>> -static int soc_camera_power_off(struct soc_camera_device *icd,
>> -                struct soc_camera_link *icl)
>> +int soc_camera_power_off(struct device *dev, struct soc_camera_link
>> *icl)
>>   {
>> -    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>       int ret;
>>
>> -    v4l2_subdev_call(sd, core, s_power, 0);
>> -
>>       if (icl->power) {
>> -        ret = icl->power(icd->control, 0);
>> +        ret = icl->power(dev, 0);
>>           if (ret < 0)
>> -            dev_err(icd->pdev,
>> +            dev_err(dev,
>>                   "Platform failed to power-off the camera.\n");
>>       }
>>
>>       ret = regulator_bulk_disable(icl->num_regulators,
>>                        icl->regulators);
>>       if (ret < 0)
>> -        dev_err(icd->pdev, "Cannot disable regulators\n");
>> +        dev_err(dev, "Cannot disable regulators\n");
>>
>>       return ret;
>>   }
>> +EXPORT_SYMBOL(soc_camera_power_off);
>> +
>> +static int __soc_camera_power_on(struct soc_camera_device *icd)
>> +{
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    int ret;
>> +
>> +    ret = v4l2_subdev_call(sd, core, s_power, 1);
>> +    if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
>> +        return ret;
>> +
>> +    return 0;
>> +}
>> +
>> +static int __soc_camera_power_off(struct soc_camera_device *icd)
>> +{
>> +    struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +    int ret;
>> +
>> +    ret = v4l2_subdev_call(sd, core, s_power, 0);
>> +    if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
>> +        return ret;
>> +
>> +    return 0;
>> +}
>>
>>   const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
>>       struct soc_camera_device *icd, unsigned int fourcc)
>> @@ -539,7 +548,7 @@ static int soc_camera_open(struct file *file)
>>               goto eiciadd;
>>           }
>>
>> -        ret = soc_camera_power_on(icd, icl);
>> +        ret = __soc_camera_power_on(icd);
>>           if (ret < 0)
>>               goto epower;
>>
>> @@ -581,7 +590,7 @@ einitvb:
>>   esfmt:
>>       pm_runtime_disable(&icd->vdev->dev);
>>   eresume:
>> -    soc_camera_power_off(icd, icl);
>> +    __soc_camera_power_off(icd);
>>   epower:
>>       ici->ops->remove(icd);
>>   eiciadd:
>> @@ -598,8 +607,6 @@ static int soc_camera_close(struct file *file)
>>
>>       icd->use_count--;
>>       if (!icd->use_count) {
>> -        struct soc_camera_link *icl = to_soc_camera_link(icd);
>> -
>>           pm_runtime_suspend(&icd->vdev->dev);
>>           pm_runtime_disable(&icd->vdev->dev);
>>
>> @@ -607,7 +614,7 @@ static int soc_camera_close(struct file *file)
>>               vb2_queue_release(&icd->vb2_vidq);
>>           ici->ops->remove(icd);
>>
>> -        soc_camera_power_off(icd, icl);
>> +        __soc_camera_power_off(icd);
>>       }
>>
>>       if (icd->streamer == file)
>> @@ -1066,8 +1073,14 @@ static int soc_camera_probe(struct
>> soc_camera_device *icd)
>>        * subdevice has not been initialised yet. We'll have to call it
>> once
>>        * again after initialisation, even though it shouldn't be
>> needed, we
>>        * don't do any IO here.
>> +     *
>> +     * The device pointer passed to soc_camera_power_on(), and
>> ultimately to
>> +     * the platform callback, should be the subdev physical device.
>> However,
>> +     * we have no way to retrieve a pointer to that device here. This
>> isn't
>> +     * a real issue, as no platform currently uses the device
>> pointer, and
>> +     * this soc_camera_power_on() call will be removed in the next
>> commit.
>>        */
>> -    ret = soc_camera_power_on(icd, icl);
>> +    ret = soc_camera_power_on(icd->pdev, icl);
>>       if (ret < 0)
>>           goto epower;
>>
>> @@ -1140,7 +1153,7 @@ static int soc_camera_probe(struct
>> soc_camera_device *icd)
>>
>>       ici->ops->remove(icd);
>>
>> -    soc_camera_power_off(icd, icl);
>> +    __soc_camera_power_off(icd);
>>
>>       mutex_unlock(&icd->video_lock);
>>
>> @@ -1162,7 +1175,7 @@ eadddev:
>>       video_device_release(icd->vdev);
>>       icd->vdev = NULL;
>>   evdc:
>> -    soc_camera_power_off(icd, icl);
>> +    __soc_camera_power_off(icd);
>>   epower:
>>       ici->ops->remove(icd);
>>   eadd:
>> diff --git a/drivers/media/video/soc_camera_platform.c
>> b/drivers/media/video/soc_camera_platform.c
>> index f59ccad..7cf7fd1 100644
>> --- a/drivers/media/video/soc_camera_platform.c
>> +++ b/drivers/media/video/soc_camera_platform.c
>> @@ -50,7 +50,16 @@ static int soc_camera_platform_fill_fmt(struct
>> v4l2_subdev *sd,
>>       return 0;
>>   }
>>
>> -static struct v4l2_subdev_core_ops platform_subdev_core_ops;
>> +static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +    struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
>> +
>> +    return soc_camera_set_power(p->icd->control, p->icd->link, on);
>> +}
>> +
>> +static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
>> +    .s_power = soc_camera_platform_s_power,
>> +};
>>
>>   static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd,
>> unsigned int index,
>>                       enum v4l2_mbus_pixelcode *code)
>> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
>> index 9f53eac..f283650 100644
>> --- a/drivers/media/video/tw9910.c
>> +++ b/drivers/media/video/tw9910.c
>> @@ -566,6 +566,14 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
>>   }
>>   #endif
>>
>> +static int tw9910_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +    struct i2c_client *client = v4l2_get_subdevdata(sd);
>> +    struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>> +
>> +    return soc_camera_set_power(&client->dev, icl, on);
>> +}
>> +
>>   static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32
>> *height)
>>   {
>>       struct i2c_client *client = v4l2_get_subdevdata(sd);
>> @@ -814,6 +822,7 @@ static struct v4l2_subdev_core_ops
>> tw9910_subdev_core_ops = {
>>       .g_register    = tw9910_g_register,
>>       .s_register    = tw9910_s_register,
>>   #endif
>> +    .s_power    = tw9910_s_power,
>>   };
>>
>>   static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>> index d865dcf..982bfc9 100644
>> --- a/include/media/soc_camera.h
>> +++ b/include/media/soc_camera.h
>> @@ -254,6 +254,16 @@ unsigned long
>> soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
>>   unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
>>                          const struct v4l2_mbus_config *cfg);
>>
>> +int soc_camera_power_on(struct device *dev, struct soc_camera_link
>> *icl);
>> +int soc_camera_power_off(struct device *dev, struct soc_camera_link
>> *icl);
>> +
>> +static inline int soc_camera_set_power(struct device *dev,
>> +                       struct soc_camera_link *icl, bool on)
>> +{
>> +    return on ? soc_camera_power_on(dev, icl)
>> +          : soc_camera_power_off(dev, icl);
>> +}
>> +
>>   /* This is only temporary here - until v4l2-subdev begins to link to
>> video_device */
>>   #include <linux/i2c.h>
>>   static inline struct video_device *soc_camera_i2c_to_vdev(const
>> struct i2c_client *client)
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


