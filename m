Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39366 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3JWSNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Oct 2013 14:13:14 -0400
Received: by mail-ea0-f171.google.com with SMTP id n15so641523ead.30
        for <linux-media@vger.kernel.org>; Wed, 23 Oct 2013 11:13:13 -0700 (PDT)
Message-ID: <526811D4.5010102@googlemail.com>
Date: Wed, 23 Oct 2013 20:13:40 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH/RFC 1/2] V4L2: soc-camera: work around unbalanced calls
 to .s_power()
References: <Pine.LNX.4.64.1310211107420.32101@axis700.grange> <5267FFF8.7010805@googlemail.com> <Pine.LNX.4.64.1310231910040.24326@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1310231910040.24326@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.10.2013 19:26, schrieb Guennadi Liakhovetski:
> Hi Frank
>
> On Wed, 23 Oct 2013, Frank Schäfer wrote:
>
>> Hi Guennadi,
>>
>> thanks for the patches and sorry for the delay.
>> I've tested them a few minutes ago and they are working fine.
>>
>> 2 minor things/questions:
>>
>> 1.) Why not always balance v4l2_clk_enable/disable() calls ?
> Because I consider this a work-around for legacy / buggy drivers, that we 
> cannot fix properly. New drivers should balance power-on / off calls.
>
>> 2.) For someone who reads the code it likely looks a bit odd that if the
>> flag "unbalanced_power" is set, soc_camera balances
>> v4l2_clk_enable/disable but not power on/off calls (ssdd->power() calls).
>> So maybe "balance_clk" or "clk_balancing_needed" would be a better name
>> for the flag ?
> Well, the name makes sense to me - the user doesn't balnce calls to power 
> enable / disable methods, so, we have to balance clock enable / disable 
> ourselves. The name might not look very logical in soc-camera, but it's a 
> flag for the user, and the user doesn't know about clocks. It just tells 
> the subdevice - sorry, I won't be balancing power on / off calls.
>
>> Ok, let's summarize what we need:
>> - the 3 fake clock patches patches
>> - em28xx patch "make sure that all subdevices are powered on when needed"
>> - these 2 patches
> In fact I don't even think the second entry - your em28xx patch - is 
> needed strictly speaking. It might be correct and good, , but this 
> specific issue should be fixed also without it. Could you confirm?

Ah yes, right, your patch also avoids warning if the device is powered
off before beeing powered on, so we don't need it for this specific issue.
And yes, it should be applied to make sure the subdevices are powered on
when needed (separate issue).

>> All patches need to marked for stable (3.11).
>> Can you pick up my me28xx patch and send Mauro a pull request ?
> I'd first like to get a confirmation from Mauro (at least), that this 
> approach is acceptable for him.

Ok.

Regards,
Frank

>
> Thanks
> Guennadi
>
>> Regards,
>> Frank
>>
>> Am 21.10.2013 11:28, schrieb Guennadi Liakhovetski:
>>> Some non soc-camera drivers, e.g. em28xx, use subdevice drivers, originally
>>> written for soc-camera, which use soc_camera_power_on() and
>>> soc_camera_power_off() helpers to implement their .s_power() methods. Those
>>> helpers in turn can enable and disable a clock, if it is supplied to them
>>> as a parameter. This works well when camera host drivers balance their
>>> calls to subdevices' .s_power() methods. However, some such drivers fail to
>>> do that, which leads to unbalanced calls to v4l2_clk_enable() /
>>> v4l2_clk_disable(), which then in turn produce kernel warnings. Such
>>> behaviour is wrong and should be fixed, however, sometimes it is difficult,
>>> because some of those drivers are rather old and use lots of subdevices,
>>> which all should be tested after such a fix. To support such drivers this
>>> patch adds a work-around, allowing host drivers or platforms to set a flag,
>>> in which case soc-camera helpers will only enable the clock, if it is
>>> disabled, and disable it only once on the first call to .s_power(0).
>>>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> ---
>>>
>>> As promised yesterday, this is an alternative approach to fixing the 
>>> em28xx problem, compile tested only.
>>>
>>>  drivers/media/platform/soc_camera/soc_camera.c |   22 ++++++++++++++++------
>>>  include/media/soc_camera.h                     |   14 ++++++++++++++
>>>  2 files changed, 30 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
>>> index 387a232..21136a2 100644
>>> --- a/drivers/media/platform/soc_camera/soc_camera.c
>>> +++ b/drivers/media/platform/soc_camera/soc_camera.c
>>> @@ -71,11 +71,21 @@ static int video_dev_create(struct soc_camera_device *icd);
>>>  int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc *ssdd,
>>>  			struct v4l2_clk *clk)
>>>  {
>>> -	int ret = clk ? v4l2_clk_enable(clk) : 0;
>>> -	if (ret < 0) {
>>> -		dev_err(dev, "Cannot enable clock: %d\n", ret);
>>> -		return ret;
>>> +	int ret;
>>> +	bool clock_toggle;
>>> +
>>> +	if (clk && (!ssdd->unbalanced_power ||
>>> +		    !test_and_set_bit(0, &ssdd->clock_state))) {
>>> +		ret = v4l2_clk_enable(clk);
>>> +		if (ret < 0) {
>>> +			dev_err(dev, "Cannot enable clock: %d\n", ret);
>>> +			return ret;
>>> +		}
>>> +		clock_toggle = true;
>>> +	} else {
>>> +		clock_toggle = false;
>>>  	}
>>> +
>>>  	ret = regulator_bulk_enable(ssdd->num_regulators,
>>>  					ssdd->regulators);
>>>  	if (ret < 0) {
>>> @@ -98,7 +108,7 @@ epwron:
>>>  	regulator_bulk_disable(ssdd->num_regulators,
>>>  			       ssdd->regulators);
>>>  eregenable:
>>> -	if (clk)
>>> +	if (clock_toggle)
>>>  		v4l2_clk_disable(clk);
>>>  
>>>  	return ret;
>>> @@ -127,7 +137,7 @@ int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd
>>>  		ret = ret ? : err;
>>>  	}
>>>  
>>> -	if (clk)
>>> +	if (clk && (!ssdd->unbalanced_power || test_and_clear_bit(0, &ssdd->clock_state)))
>>>  		v4l2_clk_disable(clk);
>>>  
>>>  	return ret;
>>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>>> index 34d2414..5678a39 100644
>>> --- a/include/media/soc_camera.h
>>> +++ b/include/media/soc_camera.h
>>> @@ -150,6 +150,15 @@ struct soc_camera_subdev_desc {
>>>  	struct regulator_bulk_data *regulators;
>>>  	int num_regulators;
>>>  
>>> +	/*
>>> +	 * Set unbalanced_power to true to deal with legacy drivers, failing to
>>> +	 * balance their calls to subdevice's .s_power() method. clock_state is
>>> +	 * then used internally by helper functions, it shouldn't be touched by
>>> +	 * drivers or the platform code.
>>> +	 */
>>> +	bool unbalanced_power;
>>> +	unsigned long clock_state;
>>> +
>>>  	/* Optional callbacks to power on or off and reset the sensor */
>>>  	int (*power)(struct device *, int);
>>>  	int (*reset)(struct device *);
>>> @@ -206,6 +215,11 @@ struct soc_camera_link {
>>>  	struct regulator_bulk_data *regulators;
>>>  	int num_regulators;
>>>  
>>> +	/* Set by platforms to handle misbehaving drivers */
>>> +	bool unbalanced_power;
>>> +	/* Used by soc-camera helper functions */
>>> +	unsigned long clock_state;
>>> +
>>>  	/* Optional callbacks to power on or off and reset the sensor */
>>>  	int (*power)(struct device *, int);
>>>  	int (*reset)(struct device *);
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

