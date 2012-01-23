Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2AWQ6H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 11:58:07 -0500
Message-ID: <4F1D918D.7070005@redhat.com>
Date: Mon, 23 Jan 2012 14:57:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com
Subject: V4L2 Overlay mode replacement by dma-buf - was: Re: [PATCH 05/10]
 v4l: add buffer exporting via dmabuf
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com> <4F1D6F88.5080202@redhat.com> <4F1D71EA.2060402@samsung.com> <4F1D7705.3080601@redhat.com> <4F1D8324.5000709@samsung.com> <4F1D8E05.4060109@redhat.com>
In-Reply-To: <4F1D8E05.4060109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 14:42, Mauro Carvalho Chehab escreveu:
> Em 23-01-2012 13:56, Tomasz Stanislawski escreveu:
>> Hi Mauro,
>>
>> On 01/23/2012 04:04 PM, Mauro Carvalho Chehab wrote:
>>> Em 23-01-2012 12:42, Tomasz Stanislawski escreveu:
>>>> Hi Mauro.
>>>> On 01/23/2012 03:32 PM, Mauro Carvalho Chehab wrote:
>>>>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>>>>> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
>>>>>> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
>>>>>> mmap and return a file descriptor on success.
>>>>>
>>>>> This requires more discussions.
>>>>>
>>>>> The usecase for this new API seems to replace the features previously provided
>>>>> by the overlay mode. There, not only the buffer were exposed to userspace, but
>>>>> some control were provided, in order to control the overlay window.
>>>>
>>>> This ioctl was introduced to support exporting of V4L2 buffers via dma-buf interface. This framework was little common with overlay mode. Could you describe what overlay mode feature is replaced by VIDIOC_EXPBUF?
>>>
>>> The V4L2 API doesn't just export "raw" buffers. It provides a logic to control
>>> the streams, with includes buffer settings, buffer queue/dequeue, buffer meta-data
>>> (like timestamps), etc.
>>
>> The DMABUF buffers are handled by vb2-core. It provides control for queuing and passing streaming and metadata management (like timestamps) to the driver.
>>
>>>
>>> I would expect to see something similar for the dma buffers.
>>
>> Those features may be introduced to dma-buf. As I understand queue/dequeue refers to passing 
>> ownership between a CPU and a driver. It is handled in vb2-core. Passing buffer between multiple 
>> APIs like V4L2 and DRM will be probably handled in the userspace. Currently the dma-buf provides 
>> only the mechanism for mapping the same memory by multiple devices.
> 
> I'm not sure if the dma-buf itself should have such meta data, but the V4L2 API 
> likely needs it.
> 
>>>
>>> With regards to the overlay mode, this is the old way to export DMA buffers between
>>> a video capture driver and a graphics adapter driver. A dma-buf interface will
>>> superseed the video overlay mode, as it will provide more features. Yet, care
>>> should be taken when writing the userspace interface, in order to be sure that all
>>> features needed will be provided there.
>>>
>>
>> The s5p-tv and s5p-fimc do not have support for OVERLAY mode. As I know vb2-core 
>> has no support for the mode, either.
> 
> True. It was decided that overlay is an old design, and a dma-buffer
> oriented approach would be needed. So, the decision were to not implement
> anything there, until a proper dma-buf support were not added.
> 
>> What kind of features present in OVERLAYS are 
>> needed in dmabuf? Note that dmabuf do not have be used only for buffers with video data.
> 
> That's a good point. Basically, Ovelay mode is supported by
> those 3 ioctl's:
> 
> #define VIDIOC_G_FBUF            _IOR('V', 10, struct v4l2_framebuffer)
> #define VIDIOC_S_FBUF            _IOW('V', 11, struct v4l2_framebuffer)
> #define VIDIOC_OVERLAY           _IOW('V', 14, int)
> 
> With use these structs:
> 
> struct v4l2_pix_format {
>         __u32                   width;
>         __u32                   height;
>         __u32                   pixelformat;
>         enum v4l2_field         field;
>        	__u32                   bytesperline;
>         __u32                   sizeimage;
>         enum v4l2_colorspace    colorspace;
>         __u32                   priv;
> };
> 
> struct v4l2_framebuffer {
>         __u32                   capability;
>         __u32                   flags;
> 
>         void                    *base;		/* Should be replaced by the DMA buf specifics */
>         struct v4l2_pix_format  fmt;
> };
> /*  Flags for the 'capability' field. Read only */
> #define V4L2_FBUF_CAP_EXTERNOVERLAY     0x0001
> #define V4L2_FBUF_CAP_CHROMAKEY         0x0002
> #define V4L2_FBUF_CAP_LIST_CLIPPING     0x0004
> #define V4L2_FBUF_CAP_BITMAP_CLIPPING   0x0008
> #define V4L2_FBUF_CAP_LOCAL_ALPHA       0x0010
> #define V4L2_FBUF_CAP_GLOBAL_ALPHA      0x0020
> #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA   0x0040
> #define V4L2_FBUF_CAP_SRC_CHROMAKEY     0x0080
> /*  Flags for the 'flags' field. */
> #define V4L2_FBUF_FLAG_PRIMARY          0x0001
> #define V4L2_FBUF_FLAG_OVERLAY          0x0002
> #define V4L2_FBUF_FLAG_CHROMAKEY        0x0004
> #define V4L2_FBUF_FLAG_LOCAL_ALPHA	0x0008
> #define V4L2_FBUF_FLAG_GLOBAL_ALPHA     0x0010
> #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA  0x0020
> #define V4L2_FBUF_FLAG_SRC_CHROMAKEY    0x0040
> 
> It should be noticed that devices that support OVERLAY can provide
> data on both dma-buffer sharing and via the standard MMAP/read() mode at
> the same time, each with a different video format. So, the VIDIOC_S_FBUF
> ioctl needs to set the pixel format, and image size for the overlay,
> while the other ioctl's set it for the MMAP (or read) mode.
> 
> Buffer queue/dequeue happens internally, and can be started/stopped via
> a VIDIOC_OVERLAY call.
> 
>>>>>
>>>>> Please start a separate thread about that, explaining how are you imagining that
>>>>> a V4L2 application would use such ioctl.
>>
>> I will post a simple application that does buffer sharing between two V4L2 devices (camera and TV output).
> 
> Ok.
> 
>>>>
>>>> This patch is essential for full implementation of support for DMABUF framework in V4L2. Therefore the patch cannot be moved to separate thread.
>>>
>>> I'm not proposing to move the patch to a separate thread. All I'm saying
>>> is that the API extensions for dmabuf requires its own separate discussions.
>>
>> I agree. However DMA patches plays important role in this PoC patchset so I decided to keep patches to together. Moreover I wanted this code to compile successfully.
>>
>> I prefer to have a good reason for adding extension before proposing it on the mailing list. The DMA buffer sharing seams to be a right reason for adding dma_get_pages but comments for V4L2/Linaro people is needed.
>>
>>>
>>> I couldn't guess, just from your patches, what ioctl's a V4L2 application
>>> like tvtime or xawtv would use the DMABUF.
>>
>> DMABUF is dedicated for application that use streaming between at least two devices. 
>> Especially if those devices are controlled by different APIs, like DRM and V4L2. 
>> It would be probably used in the middle-ware like gstreamer or OpenMAX.
> 
> This is what the X11 v4l extension driver does: it shares DMA buffers between V4L2 
> and DRM. The extension currently relies on XV extension, simply because this is what
> were available at the time the extension was written. I didn't have any time yet
> to port it to use something more modern.
> 
> It is probably a good idea for you to take a look on it, when writing the API bits.
> Its source is available at:
> 
> 	http://cgit.freedesktop.org/xorg/driver/xf86-video-v4l/


(I moved the comment from the other thread to this one, and renamed it,
 in order to have the DMA buf API discussion at the same place)

>> 2) The userspace API changes to properly support for dma buffers.
>>
>> If you're not ready to discuss (2), that's ok, but I'd like to follow
>> the discussions for it with care, not only for reviewing the actual
>> patches, but also since I want to be sure that it will address the
>> needs for xawtv and for the Xorg v4l driver.
>>
> 
> The support of dmabuf could be easily added to framebuffer API.
> I expect that it would not be difficult to add it to Xv.

A texture based API is likely needed, at least for it to work with
modern PC GPU's.

> The selection API could be used to control scaling and composing
> of video stream into framebuffer or a texture for composing manager.

The current approach for Overlay mode is to put everything related to
the overlay settings at VIDIOC_G_FBUF/VIDIOC_S_FBUF. The rationale was
that the same video node supporting Overlay were also supporting MMAP
and/or read() mode.

A dmabuf-based overlay mode can either keep the same strategy, using
an structure very similar to struct v4l2_framebuffer, or, alternatively,
a new video node could be required, for the "overlay2" caps property.

Regards,
Mauro
