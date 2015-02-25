Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41145 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbbBYOOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 09:14:23 -0500
Message-ID: <54EDD8B8.1030608@xs4all.nl>
Date: Wed, 25 Feb 2015 15:14:16 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 3/3] smiapp: Use __v4l2_ctrl_grab() to grab controls
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi> <1424867607-4082-4-git-send-email-sakari.ailus@iki.fi> <54EDD216.9030806@xs4all.nl> <20150225135711.GK6539@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150225135711.GK6539@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/15 14:57, Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, Feb 25, 2015 at 02:45:58PM +0100, Hans Verkuil wrote:
> ...
>>> @@ -1535,15 +1529,15 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
>>>  	if (sensor->streaming == enable)
>>>  		goto out;
>>>  
>>> -	if (enable) {
>>> -		sensor->streaming = true;
>>> +	if (enable)
>>>  		rval = smiapp_start_streaming(sensor);
>>> -		if (rval < 0)
>>> -			sensor->streaming = false;
>>> -	} else {
>>> +	else
>>>  		rval = smiapp_stop_streaming(sensor);
>>> -		sensor->streaming = false;
>>> -	}
>>> +
>>> +	sensor->streaming = enable;
>>> +	__v4l2_ctrl_grab(sensor->hflip, enable);
>>> +	__v4l2_ctrl_grab(sensor->vflip, enable);
>>> +	__v4l2_ctrl_grab(sensor->link_freq, enable);
>>
>> Just checking: is it really not possible to change these controls
>> while streaming? Most devices I know of allow changing this on the fly.
>>
>> If it is really not possible, then you can add my Ack for this series:
> 
> I'm not sure what the sensors would do in practice, but the problem is that
> changing the values of these control affect the pixel order. That's why
> changing them has been prevented while streaming.

Ah, OK.

Can you add a comment explaining why this is done?

BTW, I understand that HFLIP will cause changes in the pixel order,
but VFLIP and link_freq should be OK, I would expect.

Regards,

	Hans
