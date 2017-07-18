Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60206 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751932AbdGRPGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 11:06:18 -0400
Subject: Re: [PATCH v4 3/3] v4l: async: add subnotifier to subdevices
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
 <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
 <1da4fac1-3bf4-e66a-2341-b1f71f0f917d@xs4all.nl>
 <20170718144715.GD28538@bigcity.dyn.berto.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <236d014c-ce8c-cd50-9500-c26e3f05991f@xs4all.nl>
Date: Tue, 18 Jul 2017 17:06:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170718144715.GD28538@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/07/17 16:47, Niklas Söderlund wrote:
>>>  void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>>>  {
>>> -	struct v4l2_subdev *sd, *tmp;
>>> +	struct v4l2_subdev *sd, *tmp, **subdev;
>>>  	unsigned int notif_n_subdev = notifier->num_subdevs;
>>>  	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
>>>  	struct device **dev;
>>> @@ -217,6 +293,12 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>>>  			"Failed to allocate device cache!\n");
>>>  	}
>>>  
>>> +	subdev = kvmalloc_array(n_subdev, sizeof(*subdev), GFP_KERNEL);
>>> +	if (!dev) {
>>> +		dev_err(notifier->v4l2_dev->dev,
>>> +			"Failed to allocate subdevice cache!\n");
>>> +	}
>>> +
>>
>> How about making a little struct:
>>
>> 	struct whatever {
>> 		struct device *dev;
>> 		struct v4l2_subdev *sd;
>> 	};
>>
>> and allocate an array of that. Only need to call kvmalloc_array once.
> 
> Neat idea, will do so for next version.
> 
>>
>> Some comments after the dev_err of why you ignore the failed memory allocation
>> and what the consequences of that are would be helpful. It is unexpected code,
>> and that needs documentation.
> 
> I agree that it's unexpected and I don't know the reason for it, I was 
> just mimic the existing behavior. If you are OK with it I be more then 
> happy to add patch to this series returning -ENOMEM if the allocation 
> failed as Geert pointed out if this allocation fails I think we are in a 
> lot of trouble anyhow...
> 
> Let me know what you think, but I don't think I can add a comment 
> explaining why the function don't simply abort on failure since I don't 
> understand it myself.

So you don't understand the device_release_driver/device_attach reprobing bit either?

I did some digging and found this thread:

http://lkml.iu.edu/hypermail/linux/kernel/1210.2/00713.html

It explains the reason for this.

I'm pretty sure Greg K-H never saw this code :-)

Looking in drivers/base/bus.c I see this function: device_reprobe().

I think we need to use that instead.

Regards,

	Hans
