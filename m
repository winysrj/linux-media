Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37769 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1BZNj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:39:58 -0500
Received: by fxm17 with SMTP id 17so2554661fxm.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 05:39:57 -0800 (PST)
Message-ID: <4D6902AA.6060805@gmail.com>
Date: Sat, 26 Feb 2011 14:39:54 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <20110225135314.GF23853@valkosipuli.localdomain> <Pine.LNX.4.64.1102251708080.26361@axis700.grange> <201102261331.26681.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102261350001.31455@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102261350001.31455@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/26/2011 02:03 PM, Guennadi Liakhovetski wrote:
> On Sat, 26 Feb 2011, Hans Verkuil wrote:
> 
>> On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:
>>
>> <snip>
>>
>>>>> configure the sensor to react on an external trigger provided by the flash
>>>>> controller is needed, and that could be a control on the flash sub-device.
>>>>> What we would probably miss is a way to issue a STREAMON with a number of
>>>>> frames to capture. A new ioctl is probably needed there. Maybe that would be
>>>>> an opportunity to create a new stream-control ioctl that could replace
>>>>> STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream
>>>>> operation, and easily map STREAMON and STREAMOFF to the new ioctl in
>>>>> video_ioctl2 internally).
>>>>
>>>> How would this be different from queueing n frames (in total; count
>>>> dequeueing, too) and issuing streamon? --- Except that when the last frame
>>>> is processed the pipeline could be stopped already before issuing STREAMOFF.
>>>> That does indeed have some benefits. Something else?
>>>
>>> Well, you usually see in your host driver, that the videobuffer queue is
>>> empty (no more free buffers are available), so, you stop streaming
>>> immediately too.
>>
>> This probably assumes that the host driver knows that this is a special queue?
>> Because in general drivers will simply keep capturing in the last buffer and not
>> release it to userspace until a new buffer is queued.
> 
> Yes, I know about this spec requirement, but I also know, that not all
> drivers do that and not everyone is happy about that requirement:)

Right, similarly a v4l2 output device is not releasing the last buffer
to userland and keeps sending its content until a new buffer is queued to the driver.
But in case of capture device the requirement is a pain, since it only causes
draining the power source, when from a user view the video capture is stopped.
Also it limits a minimum number of buffers that could be used in preview pipeline.

In still capture mode (single shot) we might want to use only one buffer so adhering
to the requirement would not allow this, would it?

> 
>> That said, it wouldn't be hard to add some flag somewhere that puts a queue in
>> a 'stop streaming on last buffer capture' mode.
> 
> No, it wouldn't... But TBH this doesn't seem like the most elegant and
> complete solution. Maybe we have to think a bit more about it - which
> soncequences switching into the snapshot mode has on the host driver,
> apart from stopping after N frames. So, this is one of the possibilities,
> not sure if the best one.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

