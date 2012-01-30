Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32926 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2A3OQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 09:16:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Subash Patel <subashrp@gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 05/10] v4l: add buffer exporting via dmabuf
Date: Mon, 30 Jan 2012 15:16:54 +0100
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	pawel@osciak.com, sumit.semwal@ti.com, jesse.barker@linaro.org,
	kyungmin.park@samsung.com, daniel@ffwll.ch
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <4F1E9EAD.60505@samsung.com> <4F22A952.2080107@gmail.com>
In-Reply-To: <4F22A952.2080107@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201301516.57631.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Subash,

On Friday 27 January 2012 14:40:34 Subash Patel wrote:
> On 01/24/2012 05:36 PM, Tomasz Stanislawski wrote:
> > On 01/24/2012 12:07 PM, Subash Patel wrote:
> >> 
> >> Instead of adding another IOCTL to query the file-descriptor in
> >> user-space, why dont we extend the existing ones in v4l2/vb2?
> >> 
> >> When the memory type set is V4L2_MEMORY_DMABUF, call to VIDIOC_REQBUFS
> >> /VIDIOC_QUERYBUF from driver can take/return the fd. We will need to add
> >> another attribute to struct v4l2_requestbuffers for this.
> >> 
> >> struct v4l2_requestbuffers {
> >> ...
> >> __u32 buf_fd;
> >> };
> >> 
> >> The application requesting buffer would set it to -1, and will receive
> >> the fd's when it calls the vb2_querybuf. In the same way, application
> >> which is trying to attach to already allocated buffer will set this to
> >> valid fd when it calls vidioc_reqbuf, and in vb2_reqbuf depending on the
> >> memory type, this can be checked and used to attach with the dma_buf for
> >> the respective buffer.
> >> 
> >> Ofcourse, this requires changes in vb2_reqbufs and vb2_querybuf similar
> >> to what you did in vb2_expbufs.
> >> 
> >> Will there be any issues in such an approach?
> > 
> > I like your idea but IMO there are some issues which this approach.
> > 
> > The VIDIOC_REQBUF is used to create a collection of buffers (i.e. 5
> > frames). Every frame is a separate buffer therefore it should have
> > separate dmabuf file descriptor. This way you should add buffer index to
> > v4l2_request_buffers. Of course but one could reuse count field but
> > there is still problem with multiplane buffers (see below).
> 
> I agree.
> 
> > Please note that dmabuf file could be create only for buffers with MMAP
> > memory type. The DMABUF memory type for VIDIOC_REQBUFS indicate that a
> > buffer is imported from DMABUF file descriptor. Similar way like content
> > of USERPTR buffers is taken from user pointer.
> > 
> > Therefore only MMAP buffers can be exported as DMABUF file descriptor.
> 
> I think for time being, mmap is best way we can share buffers between
> IP's, like MM and GPU.
> 
> > If VIDIOC_REQUBUF is used for buffer exporting, how to request a bunch
> > of buffers that are dedicated to obtain memory from DMABUF file
> > descriptors?
> 
> I am not sure if I understand this question. But what I meant is,
> VIDIOC_REQBUF with memory type V4L2_MEMORY_DMABUF will ask the driver to
> allocate MMAP type memory and create the dmabuf handles for those. In
> the next call to VIDIOC_QUERYBUF (which you do on each of the buffers
> infact), driver will return the dmabuf file descriptors to user space.
> This can be used by the user space to mmap(when dmabuf supports) or pass
> it onto another process to share the buffers.

That would be nice, but VIDIOC_REQBUFS(DMABUF) is already used to allocate 
buffers that will be imported using dma-buf. We need to handle both the 
importer use case and the exporter use case, we can't handle both with just 
VIDIOC_REQBUFS(DMABUF).

> The recipient user process can now pass these dmabuf file descriptors in
> VIDIOC_REQBUF itself to its driver (say another v4l2 based). In the
> driver, when the user space calls VIDIOC_QUERYBUF for those buffers, we
> can call dmabuf's attach() to actually link to the buffer. Does it make
> sense?
> 
> > The second problem is VIDIOC_QUERYBUF. According to V4L2 spec, the
> > memory type field is read only. The driver returns the same memory type
> > as it was used in VIDIOC_REQBUFS. Therefore VIDIOC_QUERYBUF can only be
> > used for MMAP buffers to obtain memoffset. For DMABUF it may return
> > fd=-1 or most recently used file descriptor. As I remember, it was not
> > defined yet.
> 
> I was thinking why not the memory type move out from enum to an int? In
> that case, we can send ORed types, like
> V4L2_MEMORY_MMAP|V4L2_MEMORY_DMABUF etc. Does it help?

That would break our API, so we can't do that (although we could still OR enum 
types).

> > The third reason are multiplane buffers. This API was introduced if V4L2
> > buffer (IMO it should be called a frame) consist of multiple memory
> > buffers. Every plane can be mmapped separately. Therefore it should be
> > possible to export every plane as separate DMABUF descriptor.
> 
> Do we require to export every plane as separate dmabuf? I think dmabuf
> should cover entire multi-plane buffer instead of individual planes.

It depends on the drivers you use. Some drivers require planes to be 
contiguous in memory, in which case a single dma-buf will likely be used. 
Other drivers can allocate the planes in separate memory regions. Several dma-
buf objects then make sense.

> How to calculate individual plane offsets should be the property of the
> driver depending on its need for it.
>
> > After some research it was found that memoffset is good identifier of a
> > plane in a buffers. This id is also available in the userspace without
> > any API extensions.
> > 
> > VIDIOC_EXPBUF was used to export a buffer by id, similar way as mmap
> > uses this identifier to map a buffer to userspace. It seams to be the
> > simplest solution.
> 
> Ok. Then dont you think when dmabuf supports mmaping the buffers,
> VIDIOC_REQBUF will be useless? VIDIOC_EXPBUF will provide that functionality
> as well.

VIDIOC_REQBUFS will be used to allocate the buffers, and VIDIOC_EXPBUF will be 
used to export them. Those are independent operations.

> > Fourth reason, VIDIOC_REQBUF means that the application request a
> > buffer. DMABUF framework is used to export existing buffers. Note that
> > memory may not be pinned to a buffer for some APIs like DRM. I think
> > that is should stated explicitly that application wants to export not
> > request a buffer. Using VIDIOC_REQBUF seams to be an API abuse.
> 
> I agree that memory may not be static like V4L2 in case of DRM. But this
> is still an issue even with a new IOCTL :) VIDIOC_REQBUF might not be
> abused as far I feel. It is extended to a) request buffers if not
> allocated b) request, as well as pass the information of already
> allocated buffers if any. Both ways, we are using it for the same
> purpose, requesting the buffers from corresponding driver.
> 
> > What is your opinion?
> 
> My concern is what will happen to applications which are already written
> with existing V4L2 IOCTL flows on new framework? i.e., if I have developed
> an application for say, just camera using s5p-fimc, and s5p-fimc driver
> eventually moves to dmabuf. If the application wont move into new buffer
> sharing framework, will things work in first place, and second will driver
> state move even if the new IOCTL is not made (driver can question QBUF
> without QUERYBUF and/or EXPBUF)?

Things will not break. Your existing applications will still use MMAP and/or 
USERPTR buffers. DMABUF support will add dma-buf import and export 
capabilities, but it won't remove existing features.

-- 
Regards,

Laurent Pinchart
