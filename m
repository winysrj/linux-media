Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1BZPm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 10:42:58 -0500
Received: by fxm17 with SMTP id 17so2605316fxm.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 07:42:57 -0800 (PST)
Message-ID: <4D691F7F.9070903@gmail.com>
Date: Sat, 26 Feb 2011 16:42:55 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <Pine.LNX.4.64.1102261350001.31455@axis700.grange> <4D6902AA.6060805@gmail.com> <201102261456.18736.hverkuil@xs4all.nl>
In-Reply-To: <201102261456.18736.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On 02/26/2011 02:56 PM, Hans Verkuil wrote:
> On Saturday, February 26, 2011 14:39:54 Sylwester Nawrocki wrote:
>> On 02/26/2011 02:03 PM, Guennadi Liakhovetski wrote:
>>> On Sat, 26 Feb 2011, Hans Verkuil wrote:
>>>
>>>> On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:
>>>>
>>>> <snip>
>>>>
>>>>>>> configure the sensor to react on an external trigger provided by the flash
>>>>>>> controller is needed, and that could be a control on the flash sub-device.
>>>>>>> What we would probably miss is a way to issue a STREAMON with a number of
>>>>>>> frames to capture. A new ioctl is probably needed there. Maybe that would be
>>>>>>> an opportunity to create a new stream-control ioctl that could replace
>>>>>>> STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream
>>>>>>> operation, and easily map STREAMON and STREAMOFF to the new ioctl in
>>>>>>> video_ioctl2 internally).
>>>>>>
>>>>>> How would this be different from queueing n frames (in total; count
>>>>>> dequeueing, too) and issuing streamon? --- Except that when the last frame
>>>>>> is processed the pipeline could be stopped already before issuing STREAMOFF.
>>>>>> That does indeed have some benefits. Something else?
>>>>>
>>>>> Well, you usually see in your host driver, that the videobuffer queue is
>>>>> empty (no more free buffers are available), so, you stop streaming
>>>>> immediately too.
>>>>
>>>> This probably assumes that the host driver knows that this is a special queue?
>>>> Because in general drivers will simply keep capturing in the last buffer and not
>>>> release it to userspace until a new buffer is queued.
>>>
>>> Yes, I know about this spec requirement, but I also know, that not all
>>> drivers do that and not everyone is happy about that requirement:)
>>
>> Right, similarly a v4l2 output device is not releasing the last buffer
>> to userland and keeps sending its content until a new buffer is queued to the driver.
>> But in case of capture device the requirement is a pain, since it only causes
>> draining the power source, when from a user view the video capture is stopped.
>> Also it limits a minimum number of buffers that could be used in preview pipeline.
> 
> No, we can't change this. We can of course add some setting that will explicitly
> request different behavior.
> 
> The reason this is done this way comes from the traditional TV/webcam viewing apps.
> If for some reason the app can't keep up with the capture rate, then frames should
> just be dropped silently. All apps assume this behavior. In a normal user environment
> this scenario is perfectly normal (e.g. you use a webcam app, then do a CPU
> intensive make run).

All right, I have nothing against extra flags, e.g. in REQBUFS to define a specific
behavior. 

Perhaps I didn't express myself straight. I was thinking only about stopping
the capture/DMA engine when there is no more empty buffers. And releasing 
the last buffer rather than keeping it in the driver. Then when subsequent buffer
is queued by the app the driver would restart the capture engine.
Streaming as seen from user space is not stopped. This just corresponds to a frame
dropping mode, discarding just happens earlier in the H/W pipeline. It's
no different from the app POV than endlessly overwriting memory with new frames.

BTW, in STREAMON ioctl documentation we have following requirement:

"... Accordingly the output hardware is disabled, no video signal is produced until
 VIDIOC_STREAMON has been called. *The ioctl will succeed only when at least one
 output buffer is in the incoming queue*."

It has been discussed that memory-to-memory interface should be an exception
from the at least one buffer requirement on an output queue for STREAMON to succeed.
However I see no good way to implement it in videobuf2. Now there is a relevant check
in vb2_streamon. There were opinions that the above restriction causes more harm
than good. I'm not sure if we should keep it.

I'm working on mem-to-mem interface DocBook documentation and it would be nice
to have this clarified.


Regards,
Sylwester
