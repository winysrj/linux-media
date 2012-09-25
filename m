Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58865 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2IYJsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 05:48:22 -0400
Received: from eusync2.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAW00H3VGL8OX50@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 10:48:44 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAW00DW7GKKVL00@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 10:48:20 +0100 (BST)
Message-id: <50617DE3.2060704@samsung.com>
Date: Tue, 25 Sep 2012 11:48:19 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC] V4L: Add s_rx_buffer subdev video operation
References: <1348493213-32278-1-git-send-email-s.nawrocki@samsung.com>
 <20120924134453.GH12025@valkosipuli.retiisi.org.uk>
 <50608F9D.40304@samsung.com>
 <20120924182645.GI12025@valkosipuli.retiisi.org.uk>
In-reply-to: <20120924182645.GI12025@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/24/2012 08:26 PM, Sakari Ailus wrote:
> On Mon, Sep 24, 2012 at 06:51:41PM +0200, Sylwester Nawrocki wrote:
>> On 09/24/2012 03:44 PM, Sakari Ailus wrote:
>>> How about useing a separate video buffer queue for the purpose? That would
>>> provide a nice way to pass it to the user space where it's needed. It'd also
>>> play nicely together with the frame layout descriptors.
>>
>> It's tempting, but doing frame synchronisation in user space in this case
>> would have been painful, if at all possible in reliable manner. It would 
>> have significantly complicate applications and the drivers.
> 
> Let's face it: applications that are interested in this information have to
> do exactly the same frame number matching with the statistics buffers. Just
> stitching the data to the same video buffer isn't a generic solution.

Let me list disadvantages of using separate buffer queue:

1. significant complication of the driver: 	
    - need to add video node support with all it's memory and file ops,
    - more complicated VIDIOC_STREAMON logic, MIPI CSI receiver needs to
      care about the data pipeline details (power, streaming,..);
2. more processing overhead due second /dev/video handling;
3. much more complex device handling in user space.

All this for virtually nothing but 2 x 4-byte integers we are interested
in in the Embedded Data stream.

And advantages:

1. More generic solution, no need to invent new fourcc's for standard image
   data formats with metadata (new fourcc is needed anyway for the device-
   specific image data (JPEG/YUV/.../YUV/JPEG/meta-data, and we can choose
   to use multi-planar only for non-standard formats and separate meta-data
   buffer queue for others);
2. Probably other host IF/ISP drivers would implement it this way, or would
   they ?
3. What else could be added ?

Currently I don't see justification for using separate video node as the
frame embedded frame grabber. I don't expect it to be useful for us in
future, not for the ISPs that process sensor data separately from the host
CPUs. Moreover, this MIPI-CSIS device has maximum buffer size of only 4 KiB,
which effectively limits its possible use cases.

I don't think there is a need to force host drivers to use either separate
buffer queues or multi-planar APIs. Especially in case of non-standard hybrid
data formats. I'm ready to discuss separate buffer queue approach if we have
real use case for it. I don't think these two methods are exclusive.
Until then I would prefer not to live with an awkward solution.

>> VIDIOC_STREAMON, VIDIOC_QBUF/DQBUF calls would have been at least roughly
>> synchronized, and applications would have to know somehow which video nodes
>> needs to be opened together. I guess things like that could be abstracted
>> in a library, but what do we really gain for such effort ?
>> And now I can just ask kernel for 2-planar buffers where everything is in
>> place..
> 
> That's equally good --- some hardware can only do that after all, but do you
> need the callback in that case, if there's a single destination buffer
> anyway? Wouldn't the frame layout descriptor have enough information to do
> this?

There is as many buffers as user requested with REQBUFS. In VSYNC interrupt
of one device there is a buffer configured for the other device. With each
frame interrupt there is a different buffer used, the one that the DMA engine
actually writes data to. Data copying happens from the MIPI-CSIS internal
ioremapped buffer to a buffer owned by the host interface driver. And the
callback is used for dynamically switching buffers at the subdev.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
