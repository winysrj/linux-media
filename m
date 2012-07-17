Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23870 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab2GQLDe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 07:03:34 -0400
Message-ID: <50054682.7070503@linux.intel.com>
Date: Tue, 17 Jul 2012 14:03:30 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/9] soc-camera: Continue the power off sequence if
 one of the steps fails
References: <1341520728-2707-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341520728-2707-8-git-send-email-laurent.pinchart@ideasonboard.com> <50034325.50006@linux.intel.com> <11676269.DxxC5Mj13x@avalon>
In-Reply-To: <11676269.DxxC5Mj13x@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/17/2012 02:45 AM, Laurent Pinchart wrote:
> Hi David,
>
> Thank you for the review.

You're welcome.

>
> On Monday 16 July 2012 01:24:37 David Cohen wrote:
>> On 07/05/2012 11:38 PM, Laurent Pinchart wrote:
>>> Powering off a device is a "best effort" task: failure to execute one of
>>> the steps should not prevent the next steps to be executed. For
>>> instance, an I2C communication error when putting the chip in stand-by
>>> mode should not prevent the more agressive next step of turning the
>>> chip's power supply off.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>>
>>>    drivers/media/video/soc_camera.c |    9 +++------
>>>    1 files changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/media/video/soc_camera.c
>>> b/drivers/media/video/soc_camera.c index 55b981f..bbd518f 100644
>>> --- a/drivers/media/video/soc_camera.c
>>> +++ b/drivers/media/video/soc_camera.c
>>> @@ -89,18 +89,15 @@ static int soc_camera_power_off(struct
>>> soc_camera_device *icd,>
>>>    				struct soc_camera_link *icl)
>>>    {
>>>    	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>> -	int ret = v4l2_subdev_call(sd, core, s_power, 0);
>>> +	int ret;
>>>
>>> -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
>>> -		return ret;
>>> +	v4l2_subdev_call(sd, core, s_power, 0);
>>
>> Fair enough. I agree we should not prevent power off because of failure
>> in this step. But IMO we should not silently bypass it too. How about
>> an error message?
>
> I'll add that.
>
>>>    	if (icl->power) {
>>>    	
>>>    		ret = icl->power(icd->control, 0);
>>>
>>> -		if (ret < 0) {
>>> +		if (ret < 0)
>>>
>>>    			dev_err(icd->pdev,
>>>    			
>>>    				"Platform failed to power-off the camera.\n");
>>>
>>> -			return ret;
>>> -		}
>>>
>>>    	}
>>>    	
>>>    	ret = regulator_bulk_disable(icl->num_regulators,
>>
>> One more comment. Should this function's return value being based fully
>> on last action? If any earlier error happened but this last step is
>> fine, IMO we should not return 0.
>
> Good point. What about this (on top of the current patch) ?

That sounds nice to me :)

Regards,

David Cohen

>
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index bbd518f..7bf21da 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -89,21 +89,30 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
>                                  struct soc_camera_link *icl)
>   {
>          struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -       int ret;
> +       int ret = 0;
> +       int err;
>
> -       v4l2_subdev_call(sd, core, s_power, 0);
> +       err = v4l2_subdev_call(sd, core, s_power, 0);
> +       if (err < 0 && err != -ENOIOCTLCMD && err != -ENODEV) {
> +               dev_err(icd->pdev, "Subdev failed to power-off the camera.\n");
> +               ret = err;
> +       }
>
>          if (icl->power) {
> -               ret = icl->power(icd->control, 0);
> -               if (ret < 0)
> +               err = icl->power(icd->control, 0);
> +               if (err < 0) {
>                          dev_err(icd->pdev,
>                                  "Platform failed to power-off the camera.\n");
> +                       ret = ret ? : err;
> +               }
>          }
>
> -       ret = regulator_bulk_disable(icl->num_regulators,
> +       err = regulator_bulk_disable(icl->num_regulators,
>                                       icl->regulators);
> -       if (ret < 0)
> +       if (err < 0) {
>                  dev_err(icd->pdev, "Cannot disable regulators\n");
> +               ret = ret ? : err;
> +       }
>
>          return ret;
>   }
>


