Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58215 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2AWP4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 10:56:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY900GE0DLYWY80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 15:56:22 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LY900DZSDLXTD@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 15:56:21 +0000 (GMT)
Date: Mon, 23 Jan 2012 16:56:20 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 05/10] v4l: add buffer exporting via dmabuf
In-reply-to: <4F1D7705.3080601@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com
Message-id: <4F1D8324.5000709@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
 <4F1D6F88.5080202@redhat.com> <4F1D71EA.2060402@samsung.com>
 <4F1D7705.3080601@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 01/23/2012 04:04 PM, Mauro Carvalho Chehab wrote:
> Em 23-01-2012 12:42, Tomasz Stanislawski escreveu:
>> Hi Mauro.
>> On 01/23/2012 03:32 PM, Mauro Carvalho Chehab wrote:
>>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
>>>> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
>>>> mmap and return a file descriptor on success.
>>>
>>> This requires more discussions.
>>>
>>> The usecase for this new API seems to replace the features previously provided
>>> by the overlay mode. There, not only the buffer were exposed to userspace, but
>>> some control were provided, in order to control the overlay window.
>>
>> This ioctl was introduced to support exporting of V4L2 buffers via dma-buf interface. This framework was little common with overlay mode. Could you describe what overlay mode feature is replaced by VIDIOC_EXPBUF?
>
> The V4L2 API doesn't just export "raw" buffers. It provides a logic to control
> the streams, with includes buffer settings, buffer queue/dequeue, buffer meta-data
> (like timestamps), etc.

The DMABUF buffers are handled by vb2-core. It provides control for 
queuing and passing streaming and metadata management (like timestamps) 
to the driver.

>
> I would expect to see something similar for the dma buffers.

Those features may be introduced to dma-buf. As I understand 
queue/dequeue refers to passing ownership between a CPU and a driver. It 
is handled in vb2-core. Passing buffer between multiple APIs like V4L2 
and DRM will be probably handled in the userspace. Currently the dma-buf 
provides only the mechanism for mapping the same memory by multiple devices.

>
> With regards to the overlay mode, this is the old way to export DMA buffers between
> a video capture driver and a graphics adapter driver. A dma-buf interface will
> superseed the video overlay mode, as it will provide more features. Yet, care
> should be taken when writing the userspace interface, in order to be sure that all
> features needed will be provided there.
>

The s5p-tv and s5p-fimc do not have support for OVERLAY mode. As I know 
vb2-core has no support for the mode, either. What kind of features 
present in OVERLAYS are needed in dmabuf? Note that dmabuf do not have 
be used only for buffers with video data.

>>>
>>> Please start a separate thread about that, explaining how are you imagining that
>>> a V4L2 application would use such ioctl.

I will post a simple application that does buffer sharing between two 
V4L2 devices (camera and TV output).

>>
>> This patch is essential for full implementation of support for DMABUF framework in V4L2. Therefore the patch cannot be moved to separate thread.
>
> I'm not proposing to move the patch to a separate thread. All I'm saying
> is that the API extensions for dmabuf requires its own separate discussions.

I agree. However DMA patches plays important role in this PoC patchset 
so I decided to keep patches to together. Moreover I wanted this code to 
compile successfully.

I prefer to have a good reason for adding extension before proposing it 
on the mailing list. The DMA buffer sharing seams to be a right reason 
for adding dma_get_pages but comments for V4L2/Linaro people is needed.

>
> I couldn't guess, just from your patches, what ioctl's a V4L2 application
> like tvtime or xawtv would use the DMABUF.

DMABUF is dedicated for application that use streaming between at least 
two devices. Especially if those devices are controlled by different 
APIs, like DRM and V4L2. It would be probably used in the middle-ware 
like gstreamer or OpenMAX.

Regards,
Tomasz Stanislawski
