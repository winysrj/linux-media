Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59074 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbZJUUvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 16:51:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: pradeepa@digilink.in
Subject: Re: Avoiding mem copy b/w camera which uses uvc standard and the h/w accelerator
Date: Wed, 21 Oct 2009 22:51:58 +0200
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org
References: <OFE70D9FDA.C7DBF7E0-ON65257653.0038E92C-65257653.00396150@digilink.in>
In-Reply-To: <OFE70D9FDA.C7DBF7E0-ON65257653.0038E92C-65257653.00396150@digilink.in>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910212251.58666.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pradeep,

On Sunday 18 October 2009 12:25:56 pradeepa@digilink.in wrote:
> I've a netbook which has a camera of 1.3 Mp. The camera is connected through
> the usb and follows the uvc standard. I've written an application which
> follows the uvc standard and can capture the image from the camera and
> display it on the netbook. My netbook has h/w accelerators to do image
> resizing, format conversion etc.
> The camera that i have gives the me the data in yuv 422 and my h/w
> acclerator converts to rgb 565 and gives me the data so that i can display
> it on to a window.The flow of the application is as follows
> 
>              yuv422                                             rgb 565
> camera------------->        Resizer and Format ----------------> display
>                                         converter
>  uvc standard                   H/w Accelerator
> 
> My h/w accelerator has registers to configure the source/destination memory
> addresses from where it has to pick up/put the data after doing format
> conversion and resizing. The problem is that this h/w accelerator needs the
> Physical Address and not the logical address.

I suppose this also means that the buffers need to be contiguous in physical 
memory, right ?

> I request for 3 buffers using VIDIOC_REQBUFS ioctl and after it succeeds, i
> call VIDIOC_QUERYBUF. I do call the mmap for using the address returned in
> VIDIOC_QUERYBUF.
> 
> struct v4l2_buffer            sV4l2Buf;
> memset(&sV4l2Buf, 0, sizeof(struct v4l2_buffer));
> sV4l2Buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> sV4l2Buf.memory = V4L2_MEMORY_MMAP;
> sV4l2Buf.index = u8Index;
> sV4l2Buf.length = 320 *240 *2; /* qvga image */
> 
> ioctl(i32CaptureFd,VIDIOC_QUERYBUF,&sV4l2Buf);

> The address returned in sV4l2Buf.m.offset structure after calling the QUERY
> buf ioctl is the offset and the not the physical address unlike the v4l2
> standard.

The V4L2 standard states that "the m.offset contains the offset of the buffer 
from the start of the device memory". No mention of a physical memory address 
is made.

> there this address cannot be configured in the h/w accelerator. In order to
> make it work, i took the following approach. My application can configure
> the h/w accelerator through the set of ioctls. One of ioctl can allocate the
> memory and returuns the physical address. The code inside the ioctl uses
> dma_alloc_coherent unlike kmalloc used in uvc standard there by satisfying
> my requirement.

Just to be correct, the uvcvideo driver uses vmalloc_32, not kmalloc. Your 
problem stays the same though.

> The modified folow is as follows
> 
>                          yuv422   rgb 565
> camera        -------------->         mem copy( virtual address allocated
> by h/w driver,    --------> h/w accelerator ----> display
>                                   virtual address containing camera image
> from uvc,
>                                   size of the camera image)
>                     Virtual Address                             physical
> Address

You should create your ASCII art using a non-proportional font and a 80 
characters per column limit. That one is unreadable.

> Problem::
> 
> The above procedure works fine but there is slowness in the image displayed
> as the size of the image captured from the camera is changed from qvga to
> vga because the no of bytes of memcopy increases by 4 times and increases by
> 16 time if capture the camera image at 1280 * 1024 resolution and display it
> in 320 *240 resolution. I want to cut down the mem copy happening before
> giving to the h/w accelerator. The only way to do is to know the physical
> where the image from the camera is placed.
> 
> When i went through the code, the uvc reqbuf ioctl calls kmalloc

Still vmalloc_32().

> (which allocates the virtual address)

Memory allocators don't allocate physical or virtual addresses. They allocate 
pages of physical memory, either contiguous or discontiguous, map the pages in 
virtual memory and return a kernel virtual address. For physically contiguous 
memory the allocator can also return the physical address. In both cases it's 
possible to get the physical address of every allocated page.

vmalloc_32() allocates physically discontiguous memory and remaps it 
contiguously in virtual memory. It returns the kernel virtual address.

> instead of physical address and the address returned by query_buf ioctl in
> sV4l2Buf.m.offset is offset and NOT the physical address.

That's right. Once again there is no requirement to return a physical address. 
v4l2_buffer::m::offset is an opaque token as far as the application is 
concerned (and don't forget that an application can't access physical memory 
directly).

> the reason being kmalloc is used instead of using dma_alloc_coherent which
> is used by the v4l2 standard for the same ioctl

The V4L2 standard doesn't require the use of dma_alloc_coherent.

> Q 1) Is there any ioctl or a function call to get the physical address for
> a given virtual adress so that the application can get the physical address
> and avoid the mem copy in the above scenario ??

As explained above the memory allocated by vmalloc_32() isn't physically 
contiguous, so you can't get a physical address for the buffer. At best your 
hardware accelerator would have to deal with scatter-gather lists, which it 
probably can't.
> Q 2) Can the mechanism of allocating the buffers in req buf ioctl be changed
> so that the application can get both the kernel virtual address and the
> physical address as well ?? What i mean to say is that replace kmalloc with
> dma_alloc_coherent ?

The uvcvideo driver could try to allocate physically contiguous memory, but 
that would put a lot of pressure on the memory subsystem for no reason in most 
cases.

> suggestion:
>         There can be additional code written in query_buf ioctl to return
> the physical address rather than the offset when the application calls it

There's a standard way to remove the extra memcpy. You need to allocate 
physically contiguous buffers outside of the uvcvideo driver (allocation could 
for instance be done by the hardware accelerator driver), map them to the 
userspace application virtual memory space, and pass them to the uvcvideo 
driver using V4L2_MEMORY_USERPTR instead of V4L2_MEMORY_MMAP.

Unfortunately the uvcvideo driver doesn't support V4L2_MEMORY_USERPTR yet, but 
I'm working on it. I'll keep you informed when a patch will be available.

-- 
Regards,

Laurent Pinchart
