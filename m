Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1DFWEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 18:04:51 -0400
Received: by wya21 with SMTP id 21so1716280wya.19
        for <linux-media@vger.kernel.org>; Wed, 06 Apr 2011 15:04:50 -0700 (PDT)
Message-ID: <4D9CE37D.6000202@gmail.com>
Date: Thu, 07 Apr 2011 00:04:45 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
CC: Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com> <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com> <AANLkTimx+MBg4qPHzubOCrAe7vDsic8_ot99NOxOWDHD@mail.gmail.com> <201103011154.19883.laurent.pinchart@ideasonboard.com> <AANLkTi=UKiPWRoDMj5aS1bAMOrnHOJ3Kiq-NyTQQpUjd@mail.gmail.com> <4D9CC780.3000902@gmail.com>
In-Reply-To: <4D9CC780.3000902@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 04/06/2011 10:05 PM, Sylwester Nawrocki wrote:
> Hi Pawel,
> 
> On 03/07/2011 12:20 AM, Pawel Osciak wrote:
>> Hi Laurent,
>>
>> On Tue, Mar 1, 2011 at 02:54, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com>   wrote:
>>> Hi Pawel,
>>>
>>> On Monday 28 February 2011 16:44:38 Pawel Osciak wrote:
>>>> Hi Laurent,
>>>> A few questions from me below. I feel we need to talk about this
>>>> change a bit more, it introduces some recovery and consistency
>>>> problems, unless I'm missing something.
>>>>
>>>> On Sun, Feb 27, 2011 at 10:12, Laurent Pinchart wrote:
>>>>> videobuf2 expects drivers to check buffer in the buf_prepare operation
>>>>> and to return success only if the buffer can queued without any issue.
>>>>>
>>>>> For hot-pluggable devices, disconnection events need to be handled at
>>>>> buf_queue time. Checking the disconnected flag and adding the buffer to
>>>>> the driver queue need to be performed without releasing the driver
>>>>> spinlock, otherwise race conditions can occur in which the driver could
>>>>> still allow a buffer to be queued after the disconnected flag has been
>>>>> set, resulting in a hang during the next DQBUF operation.
>>>>>
>>>>> This problem can be solved either in the videobuf2 core or in the device
>>>>> drivers. To avoid adding a spinlock to videobuf2, make buf_queue return
>>>>> an int and handle buf_queue failures in videobuf2. Drivers must not
>>>>> return an error in buf_queue if the condition leading to the error can
>>>>> be caught in buf_prepare.
>>>>>

...
 
> As buf_queue callback is called by vb2 only after start_streaming,
> for a camera snapshot capture I needed to start a pipeline only from the
> buf_queue handler level, i.e. subdev's video s_stream op was called from
> within buf_queue. s_stream couldn't be done in the start_streaming handler
> as at the time it is invoked there is always no buffer available in the
> bridge H/W.
> It's a consequence of how the vb2_streamon() is designed.
> 
> Before, I used to simply call s_stream in start_streaming, only deferring
> the actual bridge DMA enable till a buf_queue call, thus letting first frames
> in the stream to be lost. This of course cannot be done in case of single-frame
> capture.
> 
> To make a long story short, it would be useful in my case to have the ability
> to return error codes as per VIDIOC_STREAMON through buf_queue in the driver
> (when the first buffer is queued).
> At the moment mainly EPIPE comes to my mind. This error code has no meaning
> in the API for QBUF though. Should the pipeline be started from buf_queue

Hmm, the pipeline validation could still be done in start_streaming()
so we can return any EPIPE error from there directly and effectively
in VIDIOC_STREAMON. So the only remaining errors are those related to I2C
communication etc. when streaming is actually enabled in the subdev. 

> the errors from buf_queue would be seen in userspace via VIDIOC_STREAMON
> and/or VIDIOC_QBUF.
> 
> It should be also possible to signal any errors originating from the subdev
> when s_stream is called on it, perhaps by EIO ?
> 
...

--
Regards,
Sylwester

