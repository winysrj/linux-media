Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59899 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1DHVIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 17:08:43 -0400
Received: by eyx24 with SMTP id 24so1222463eyx.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 14:08:42 -0700 (PDT)
Message-ID: <4D9F7955.8090506@gmail.com>
Date: Fri, 08 Apr 2011 23:08:37 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com> <4D9CC780.3000902@gmail.com> <4D9CE37D.6000202@gmail.com> <201104081453.21999.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104081453.21999.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent!

On 04/08/2011 02:53 PM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> On Thursday 07 April 2011 00:04:45 Sylwester Nawrocki wrote:
>> On 04/06/2011 10:05 PM, Sylwester Nawrocki wrote:
>>> On 03/07/2011 12:20 AM, Pawel Osciak wrote:
>>>> On Tue, Mar 1, 2011 at 02:54, Laurent Pinchart wrote:
>>>>> On Monday 28 February 2011 16:44:38 Pawel Osciak wrote:
>>>>>> Hi Laurent,
>>>>>> A few questions from me below. I feel we need to talk about this
>>>>>> change a bit more, it introduces some recovery and consistency
>>>>>> problems, unless I'm missing something.
>>>>>>
>>>>>> On Sun, Feb 27, 2011 at 10:12, Laurent Pinchart wrote:
>>>>>>> videobuf2 expects drivers to check buffer in the buf_prepare
>>>>>>> operation and to return success only if the buffer can queued
>>>>>>> without any issue.
>>>>>>>
>>>>>>> For hot-pluggable devices, disconnection events need to be handled at
>>>>>>> buf_queue time. Checking the disconnected flag and adding the buffer
>>>>>>> to the driver queue need to be performed without releasing the
>>>>>>> driver spinlock, otherwise race conditions can occur in which the
>>>>>>> driver could still allow a buffer to be queued after the
>>>>>>> disconnected flag has been set, resulting in a hang during the next
>>>>>>> DQBUF operation.
>>>>>>>
>>>>>>> This problem can be solved either in the videobuf2 core or in the
>>>>>>> device drivers. To avoid adding a spinlock to videobuf2, make
>>>>>>> buf_queue return an int and handle buf_queue failures in videobuf2.
>>>>>>> Drivers must not return an error in buf_queue if the condition
>>>>>>> leading to the error can be caught in buf_prepare.
>>
>> ...
>>
>>> As buf_queue callback is called by vb2 only after start_streaming,
>>> for a camera snapshot capture I needed to start a pipeline only from the
>>> buf_queue handler level, i.e. subdev's video s_stream op was called from
>>> within buf_queue. s_stream couldn't be done in the start_streaming
>>> handler as at the time it is invoked there is always no buffer available
>>> in the bridge H/W.
>>> It's a consequence of how the vb2_streamon() is designed.
>>>
>>> Before, I used to simply call s_stream in start_streaming, only deferring
>>> the actual bridge DMA enable till a buf_queue call, thus letting first
>>> frames in the stream to be lost. This of course cannot be done in case
>>> of single-frame capture.
>>>
>>> To make a long story short, it would be useful in my case to have the
>>> ability to return error codes as per VIDIOC_STREAMON through buf_queue
>>> in the driver (when the first buffer is queued).
>>> At the moment mainly EPIPE comes to my mind. This error code has no
>>> meaning in the API for QBUF though. Should the pipeline be started from
>>> buf_queue
>>
>> Hmm, the pipeline validation could still be done in start_streaming()
>> so we can return any EPIPE error from there directly and effectively
>> in VIDIOC_STREAMON.
> 
> That's correct, and that's what the OMAP3 ISP driver does.
> 
>> So the only remaining errors are those related to I2C communication etc.
>> when streaming is actually enabled in the subdev.
> 
> buf_queue is called with a spinlock help, so you can't perform I2C
> communication there.

This sounds like a really simple requirement - configure the capture format,
allocate and queue a single buffer and trigger the hardware to fill exactly
that buffer. Yet the drivers are forced to perform some acrobatics to achieve
that fairly simple task. 

Luckily videobuf2 does not enforce atomic context in buf_queue as Marek 
pointed out. And I know it from experience as I've experimented with 
S5P FIMC and M-5MOLS drivers for still JPEG capture, on top of your
patch allowing to return errors from buf_queue btw :)

VIDIOC_STREAMON has rather fuzzy meaning for me and I assume there has been
an agreement that allowing drivers to return errors from buf_queue and 
performing blocking I/O from there is the expected way to work around
the freedom the API gives to applications in regards to VIDIOC_STREAMON.
But someone could prove me wrong here. 

I guess there are some issues with streaming over USB when buf_queue
is called in a non atomic context?
I'll have a closer look at your email explaining the USB disconnection 
handling.

--
Regards,
Sylwester Nawrocki


