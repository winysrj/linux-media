Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48229 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751303Ab2IZUt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 16:49:27 -0400
Message-ID: <50636A53.4080700@iki.fi>
Date: Wed, 26 Sep 2012 23:49:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, a.hajda@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com> <20120924134453.GH12025@valkosipuli.retiisi.org.uk> <50608F9D.40304@samsung.com> <20120924182645.GI12025@valkosipuli.retiisi.org.uk> <50617DE3.2060704@samsung.com>
In-Reply-To: <50617DE3.2060704@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> On 09/24/2012 08:26 PM, Sakari Ailus wrote:
>> On Mon, Sep 24, 2012 at 06:51:41PM +0200, Sylwester Nawrocki wrote:
>>> On 09/24/2012 03:44 PM, Sakari Ailus wrote:
>>>> How about useing a separate video buffer queue for the purpose? That would
>>>> provide a nice way to pass it to the user space where it's needed. It'd also
>>>> play nicely together with the frame layout descriptors.
>>>
>>> It's tempting, but doing frame synchronisation in user space in this case
>>> would have been painful, if at all possible in reliable manner. It would
>>> have significantly complicate applications and the drivers.
>>
>> Let's face it: applications that are interested in this information have to
>> do exactly the same frame number matching with the statistics buffers. Just
>> stitching the data to the same video buffer isn't a generic solution.
>
> Let me list disadvantages of using separate buffer queue:
>
> 1. significant complication of the driver: 	
>      - need to add video node support with all it's memory and file ops,

That's not much of code since the driver already does it once.

>      - more complicated VIDIOC_STREAMON logic, MIPI CSI receiver needs to
>        care about the data pipeline details (power, streaming,..);

Power management complication is about non-existent, streaming likely 
require ensuring that STREAMON IOCTL has been issued on both before 
streaming is really started.

> 2. more processing overhead due second /dev/video handling;

True.

> 3. much more complex device handling in user space.

Somewhat, yes.

> All this for virtually nothing but 2 x 4-byte integers we are interested
> in in the Embedded Data stream.
> And advantages:
>
> 1. More generic solution, no need to invent new fourcc's for standard image
>     data formats with metadata (new fourcc is needed anyway for the device-
>     specific image data (JPEG/YUV/.../YUV/JPEG/meta-data, and we can choose
>     to use multi-planar only for non-standard formats and separate meta-data
>     buffer queue for others);
> 2. Probably other host IF/ISP drivers would implement it this way, or would
>     they ?
> 3. What else could be added ?

One more advantage is that you'll get the metadata immediately to the 
user space after it's been written to the system memory; no need to wait 
for the rest of the frame. That may be interesting sometimes.

> Currently I don't see justification for using separate video node as the
> frame embedded frame grabber. I don't expect it to be useful for us in
> future, not for the ISPs that process sensor data separately from the host
> CPUs. Moreover, this MIPI-CSIS device has maximum buffer size of only 4 KiB,
> which effectively limits its possible use cases.

That's your hardware. Most CSI-2 receivers I've seen either write the 
metadata to the same buffer or to a different memory area equivalent to 
the video buffer where the image is stored.

> I don't think there is a need to force host drivers to use either separate
> buffer queues or multi-planar APIs. Especially in case of non-standard hybrid
> data formats. I'm ready to discuss separate buffer queue approach if we have
> real use case for it. I don't think these two methods are exclusive.

I agree with that. It should be made possible for the user to decide 
which one to use. The hardware may also limit possibilities since if it 
just recognises a single buffer, there's not much that the software can 
do in that case.

Multi-plane buffers are the only option in that case I guess.

> Until then I would prefer not to live with an awkward solution.

I think it would be good to be able to have plane-specific formats on 
multi-plane buffers. Thus we wouldn't end up having a new pixel format 
out of every metadata / image format pair. And there will be many, many 
of those and the applications certainly don't want to care about the 
combinations themselves.

>>> VIDIOC_STREAMON, VIDIOC_QBUF/DQBUF calls would have been at least roughly
>>> synchronized, and applications would have to know somehow which video nodes
>>> needs to be opened together. I guess things like that could be abstracted
>>> in a library, but what do we really gain for such effort ?
>>> And now I can just ask kernel for 2-planar buffers where everything is in
>>> place..
>>
>> That's equally good --- some hardware can only do that after all, but do you
>> need the callback in that case, if there's a single destination buffer
>> anyway? Wouldn't the frame layout descriptor have enough information to do
>> this?
>
> There is as many buffers as user requested with REQBUFS. In VSYNC interrupt

I meant separately allocated and mapped memory areas related to a single 
frame.

> of one device there is a buffer configured for the other device. With each
> frame interrupt there is a different buffer used, the one that the DMA engine
> actually writes data to. Data copying happens from the MIPI-CSIS internal
> ioremapped buffer to a buffer owned by the host interface driver. And the
> callback is used for dynamically switching buffers at the subdev.

So... your CSI-2 receiver has got a small internal memory where the 
metadata can be written? That's certainly a novel solution. :-)

I still don't quite understand the need for the callback. First of all, 
did I understand correctly that a driver for different hardware than 
than the one in the memory of which the metadata actually resides would 
copy the contents of this memory to a multi-plane video buffer that it 
eventually passes to user space?

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
