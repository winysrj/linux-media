Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab2GQKlD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 06:41:03 -0400
Message-ID: <5005412E.5050206@linux.intel.com>
Date: Tue, 17 Jul 2012 13:40:46 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 8/9] soc-camera: Add and use soc_camera_power_[on|off]()
 helper functions
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341520728-2707-9-git-send-email-laurent.pinchart@ideasonboard.com> <50034F97.9060208@linux.intel.com> <1785362.kzK4PIgmvB@avalon>
In-Reply-To: <1785362.kzK4PIgmvB@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/17/2012 04:24 AM, Laurent Pinchart wrote:
> Hi David,
>
> Thanks for the review.

You're welcome.

>
> On Monday 16 July 2012 02:17:43 David Cohen wrote:
>> On 07/05/2012 11:38 PM, Laurent Pinchart wrote:
>>> Instead of forcing all soc-camera drivers to go through the mid-layer to
>>> handle power management, create soc_camera_power_[on|off]() functions
>>> that can be called from the subdev .s_power() operation to manage
>>> regulators and platform-specific power handling. This allows non
>>> soc-camera hosts to use soc-camera-aware clients.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>>
>>>    drivers/media/video/imx074.c              |    9 +++
>>>    drivers/media/video/mt9m001.c             |    9 +++
>>>    drivers/media/video/mt9m111.c             |   52 +++++++++++++-----
>>>    drivers/media/video/mt9t031.c             |   11 +++-
>>>    drivers/media/video/mt9t112.c             |    9 +++
>>>    drivers/media/video/mt9v022.c             |    9 +++
>>>    drivers/media/video/ov2640.c              |    9 +++
>>>    drivers/media/video/ov5642.c              |   10 +++-
>>>    drivers/media/video/ov6650.c              |    9 +++
>>>    drivers/media/video/ov772x.c              |    9 +++
>>>    drivers/media/video/ov9640.c              |   10 +++-
>>>    drivers/media/video/ov9740.c              |   15 +++++-
>>>    drivers/media/video/rj54n1cb0c.c          |    9 +++
>>>    drivers/media/video/soc_camera.c          |   83   ++++++++++++--------
>>>    drivers/media/video/soc_camera_platform.c |   11 ++++-
>>>    drivers/media/video/tw9910.c              |    9 +++
>>>    include/media/soc_camera.h                |   10 ++++
>>>    17 files changed, 225 insertions(+), 58 deletions(-)
>>
>> [snip]
>>
>>> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
>>> index 3eb07c2..effd0f1 100644
>>> --- a/drivers/media/video/ov9740.c
>>> +++ b/drivers/media/video/ov9740.c
>>> @@ -786,16 +786,29 @@ static int ov9740_g_chip_ident(struct v4l2_subdev
>>> *sd,>
>>>    static int ov9740_s_power(struct v4l2_subdev *sd, int on)
>>>    {
>>>
>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>> +	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>>>
>>>    	struct ov9740_priv *priv = to_ov9740(sd);
>>>
>>> +	int ret;
>>>
>>> -	if (!priv->current_enable)
>>> +	if (on) {
>>> +		ret = soc_camera_power_on(&client->dev, icl);
>>> +		if (ret < 0)
>>> +			return ret;
>>> +	}
>>> +
>>> +	if (!priv->current_enable) {
>>> +		if (!on)
>>> +			soc_camera_power_off(&client->dev, icl);
>>
>> After your changes, this function has 3 if's (one nested) where all of
>> them checks "on" variable due to you need to mix "on" and
>> "priv->current_enable" checks. However, code's traceability is not so
>> trivial.
>> How about if you nest "priv->current_enable" into last "if" and keep
>> only that one?
>>
>> See an incomplete code below:
>>>    		return 0;
>>>
>>> +	}
>>>
>>>    	if (on) {
>>
>> soc_camera_power_on();
>> if (!priv->current_enable)
>> 	return;
>>
>>>    		ov9740_s_fmt(sd, &priv->current_mf);
>>>    		ov9740_s_stream(sd, priv->current_enable);
>>>    	
>>>    	} else {
>>>    	
>>>    		ov9740_s_stream(sd, 0);
>>
>> Execute ov9740_s_stream() conditionally:
>> if (priv->current_enable) {
>> 	ov9740_s_stream();
>> 	priv->current_enable = true;
>> }
>>
>>> +		soc_camera_power_off(&client->dev, icl);
>>>
>>>    		priv->current_enable = true;
>>
>> priv->current_enable is set to false when ov9740_s_stream(0) is called
>> then this function sets it back to true afterwards. So, in case you want
>> to have no functional change, it seems to me you should call
>> soc_camera_power_off() after that variable has its original value set
>> back.
>> In this case, even if you don't like my suggestion, you still need to
>> swap those 2 lines above. :)
>
> What do you think of

Sounds good to me :)

Br,

David Cohen

>
> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> index 3eb07c2..10c0ba9 100644
> --- a/drivers/media/video/ov9740.c
> +++ b/drivers/media/video/ov9740.c
> @@ -786,17 +786,27 @@ static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
>
>   static int ov9740_s_power(struct v4l2_subdev *sd, int on)
>   {
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +       struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
>          struct ov9740_priv *priv = to_ov9740(sd);
> -
> -       if (!priv->current_enable)
> -               return 0;
> +       int ret;
>
>          if (on) {
> -               ov9740_s_fmt(sd, &priv->current_mf);
> -               ov9740_s_stream(sd, priv->current_enable);
> +               ret = soc_camera_power_on(&client->dev, icl);
> +               if (ret < 0)
> +                       return ret;
> +
> +               if (priv->current_enable) {
> +                       ov9740_s_fmt(sd, &priv->current_mf);
> +                       ov9740_s_stream(sd, 1);
> +               }
>          } else {
> -               ov9740_s_stream(sd, 0);
> -               priv->current_enable = true;
> +               if (priv->current_enable) {
> +                       ov9740_s_stream(sd, 0);
> +                       priv->current_enable = true;
> +               }
> +
> +               soc_camera_power_off(&client->dev, icl);
>          }
>
>          return 0;
>


