Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48729 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbbBYO34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 09:29:56 -0500
Message-ID: <54EDDC5C.9090405@xs4all.nl>
Date: Wed, 25 Feb 2015 15:29:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 3/3] smiapp: Use __v4l2_ctrl_grab() to grab controls
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi> <1424867607-4082-4-git-send-email-sakari.ailus@iki.fi> <54EDD216.9030806@xs4all.nl> <20150225135711.GK6539@valkosipuli.retiisi.org.uk> <54EDD8B8.1030608@xs4all.nl> <20150225142213.GL6539@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150225142213.GL6539@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/15 15:22, Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, Feb 25, 2015 at 03:14:16PM +0100, Hans Verkuil wrote:
>> On 02/25/15 14:57, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Wed, Feb 25, 2015 at 02:45:58PM +0100, Hans Verkuil wrote:
>>> ...
>>>>> @@ -1535,15 +1529,15 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
>>>>>  	if (sensor->streaming == enable)
>>>>>  		goto out;
>>>>>  
>>>>> -	if (enable) {
>>>>> -		sensor->streaming = true;
>>>>> +	if (enable)
>>>>>  		rval = smiapp_start_streaming(sensor);
>>>>> -		if (rval < 0)
>>>>> -			sensor->streaming = false;
>>>>> -	} else {
>>>>> +	else
>>>>>  		rval = smiapp_stop_streaming(sensor);
>>>>> -		sensor->streaming = false;
>>>>> -	}
>>>>> +
>>>>> +	sensor->streaming = enable;
>>>>> +	__v4l2_ctrl_grab(sensor->hflip, enable);
>>>>> +	__v4l2_ctrl_grab(sensor->vflip, enable);
>>>>> +	__v4l2_ctrl_grab(sensor->link_freq, enable);
>>>>
>>>> Just checking: is it really not possible to change these controls
>>>> while streaming? Most devices I know of allow changing this on the fly.
>>>>
>>>> If it is really not possible, then you can add my Ack for this series:
>>>
>>> I'm not sure what the sensors would do in practice, but the problem is that
>>> changing the values of these control affect the pixel order. That's why
>>> changing them has been prevented while streaming.
>>
>> Ah, OK.
>>
>> Can you add a comment explaining why this is done?
>>
>> BTW, I understand that HFLIP will cause changes in the pixel order,
>> but VFLIP and link_freq should be OK, I would expect.
> 
> Sure I can add a comment. Same for vflip, it will change the pixel order.
> The flip controls will change the readout direction. For example, a 4x4
> bayer sensor:
> 
> GRGR
> BGBG
> GRGR
> BGBG
> 
> Without flipping, the readout of the first line will be GRGR while the
> second is BGBG. With vertical flipping, the first line read out from the
> sensor will be BGBG and the second GRGR.

Ah, of course. A comment would be useful indeed as this is not immediately
obvious (well, not to me at least!).

> 
> The link frequency cannot be changed since this would change the sensor PLL
> configuration and the CSI-2 bus frequency, neither of which are changeable
> while streaming.
> 

Sorry, my mistake. I confused the link frequency with the powerline frequency
control (50/60 Hz). Of course the link frequency can't be changed while
streaming.

Regards,

	Hans
