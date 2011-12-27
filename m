Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52750 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1L0Uxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 15:53:42 -0500
Received: by eekc4 with SMTP id c4so11902562eek.19
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 12:53:41 -0800 (PST)
Message-ID: <4EFA304C.9000802@gmail.com>
Date: Tue, 27 Dec 2011 21:53:32 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face
 detection
References: <1322838172-11149-6-git-send-email-ming.lei@canonical.com>	<20111214153407.GN1967@valkosipuli.localdomain>	<CACVXFVNrEamdXq6qS98U-T6JiPMVNMHMW9j9prD1wz=SOfOyyA@mail.gmail.com>	<4EF23455.10002@gmail.com> <CACVXFVNAsQ7BmkzE1t2bUHz6WJeZeKnwJOhj+GQAH0rbyFCKyA@mail.gmail.com>
In-Reply-To: <CACVXFVNAsQ7BmkzE1t2bUHz6WJeZeKnwJOhj+GQAH0rbyFCKyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ming,

On 12/26/2011 03:00 AM, Ming Lei wrote:
> On Thu, Dec 22, 2011 at 3:32 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>>>> How is face detection enabled or disabled?
>>>
>>> Currently, streaming on will trigger detection enabling, and streaming
>>> off will trigger detection disabling.
>>
>> We would need to develop a boolean control for this I think, this seems 
>> one of the basic features for the configuration interface.
> 
> Yes, it is another way to do it, but considered that for the current two
> use cases(detect objects on user space image or video, detect objects on
> video stream from internal SoC bus), it is implicit that the video device
> should have stream capability, so I think it is still OK to do it via
> streaming on and streaming off interface.

IMHO for drivers that support FD and don't expose an FD start control
applications could assume that VIDIOC_STREAMON/VIDIOC_STREAMOFF also
enables/disables face detection.
In other words if an FD enable control is present face detection would
be disabled until an FD start control is set.

We will also need a FD status control.

>>> Could you let me know how to do it?
>>
>> You would have to use multi-planar interface for that, which would 
>> introduce additional complexity at user interface. Moreover variable plane
>> count is not supported in vb2. Relatively significant effort is required 
>> to add this IMHO.
> 
> So the the introduced two IOCTLs are good to do it, right?

Yes, and no :-)

Since we have a third case to consider:
 1) camera sensor with an embedded ISP that supports face detection.

Another two are:
 2) image input from memory only (like OMAP4 FDIF),
 3) image input from memory OR from external image sensor.

In case 1) we will eventually have a DMA that captures frames to memory.
It's different from 2) and 3) that registers containing result are accessed
through I2C. Then it may be desirable to retrieve detection result data
separately for each object, due to bus access latencies, rather reading all
data in single ioctl.

> Sylwester, could you help to review the v2 patches if you are available?

Yes, I'll try to find some time for it tomorrow.

I would have a general note - I don't really think we should bother with
generic FD kernel module now. We have already generic building blocks in V4L
and hardware is so different that it's seems inappropriate to try to generalize
the implementation before we have clear user interface semantics settled.

-- 
Regards,
Sylwester
