Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0BHSEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 13:04:52 -0500
Message-ID: <4B705216.7040907@redhat.com>
Date: Mon, 08 Feb 2010 16:04:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for subdevices
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange> <4B7012D1.40605@redhat.com> <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002081447020.4936@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Hi Mauro
> 
> Thanks for your comments.
> 
> On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:
> 
>> Guennadi Liakhovetski wrote:
>>> To save power soc-camera powers subdevices down, when they are not in use, 
>>> if this is supported by the platform. However, the V4L standard dictates, 
>>> that video nodes shall preserve configuration between uses. This requires 
>>> runtime power management, which is implemented by this patch. It allows 
>>> subdevice drivers to specify their runtime power-management methods, by 
>>> assigning a type to the video device.
>> It seems a great idea to me. For sure we need some sort of power management
>> control.
> 
> Agree;)
> 
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> ---
>>>
>>> I've posted this patch to linux-media earlier, but I'd also like to get 
>>> comments on linux-pm, sorry to linux-media falks for a duplicate. To 
>>> explain a bit - soc_camera.c is a management module, that binds video 
>>> interfaces on SoCs and sensor drivers. The calls, that I am adding to 
>>> soc_camera.c shall save and restore sensor registers before they are 
>>> powered down and after they are powered up.
>>>
>>> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
>>> index 6b3fbcc..53201f3 100644
>>> --- a/drivers/media/video/soc_camera.c
>>> +++ b/drivers/media/video/soc_camera.c
>>> @@ -24,6 +24,7 @@
>>>  #include <linux/mutex.h>
>>>  #include <linux/module.h>
>>>  #include <linux/platform_device.h>
>>> +#include <linux/pm_runtime.h>
>>>  #include <linux/vmalloc.h>
>>
>> Hmm... wouldn't it be better to enable it at the subsystem level? We may for 
>> example call ?
>> The subsystem can call vidioc_streamoff() at suspend and vidioc_streamon() at
>> resume, if the device were streaming during suspend. We may add another ops to
>> the struct for the drivers/subdrivers that needs additional care.
>>
>> That's said, it shouldn't be hard to implement some routine that will save/restore
>> all registers if the device goes to power down mode. Unfortunately, very few
>> devices successfully recovers from hibernation if streaming. One good example
>> is saa7134, that even disables/re-enables IR IRQ's during suspend/resume.
> 
> To clarify a bit - this patch implements not static PM, but dynamic 
> (runtime) power-management. 

Ok.

> In this case it means, we are trying to save 
> power while the system is running, but we know, that the sensor is not 
> needed. Specifically, as long as no application is holding the video 
> device open. And this information is only available at the bridge driver 
> (soc-camera core) level - there is no subdev operation for open and close 
> calls, so, subdevices do not "know" whether they are in use or not. So, 
> only saving / restoring registers when streaming is not enough. Static PM 
> will also be interesting - as it has been mentioned before, we will have 
> to be careful, because sensors "sit" on two busses - i2c and video. So, 
> you have to resume after both are up and suspend before the first of them 
> goes down... So, that will be a different exciting topic;)

In fact, on all drivers, there are devices that needs to be turn on only when
streaming is happening: sensors, analog TV/audio demods, digital demods. Also,
a few devices (for example: TV tuners) could eventually be on power off when
no device is opened.

As the V4L core knows when this is happening (due to
open/close/poll/streamon/reqbuf/qbuf/dqbuf hooks, I think the runtime management 
can happen at V4L core level.

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/


-- 

Cheers,
Mauro
