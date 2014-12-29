Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40090 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752125AbaL2U77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Dec 2014 15:59:59 -0500
Date: Mon, 29 Dec 2014 22:59:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: vkalia@codeaurora.org
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	vrajesh@codeaurora.org, sachins@codeaurora.org,
	apurupa@codeaurora.org
Subject: Re: V4L2_MEMORY_DMABUF for video decoders
Message-ID: <20141229205953.GK17565@valkosipuli.retiisi.org.uk>
References: <0dabfbb34c548337f7d1098b46e2d197.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dabfbb34c548337f7d1098b46e2d197.squirrel@www.codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinay,

On Mon, Dec 01, 2014 at 08:35:57PM -0000, vkalia@codeaurora.org wrote:
> Hi
> 
> I am facing an issue while using videobuf2-dma-contig.c mem_ops. Following
> is brief description of the driver architecture and the limitation. Any
> pointers/hints are appreciated.
> 
> Driver architecture:
> It is a video codec driver for video decoding. It exposes two ports -
> CAPTURE and OUTPUT. Raw bitstream buffers are queued/dequeued via OUTPUT
> capability and YUV via CAPTURE. This driver uses vb2_qops as well as
> vb2_mem_ops from videobuf2-dma-contig.c. Video hardware has MMU.
> 
> V4L2 framework limitation:
> The empty buffers are allocated by userspace and file descriptor is queued
> to the V4L2 driver via VIDIOC_QBUF call. I am using vb2_mem_ops so the
> buffers are mapped into video device's MMU by map_dmabuf op. Then video
> driver sends this buffer down to hardware and hardware does the decoding
> and writes YUV data in this buffer. This buffer is ready to be shared with
> userspace so hardware returns this buffer back to driver. Userspace calls
> VIDIOC_DQBUF to get the buffer but as a result the buffer is also unmapped
> from video device's MMU. This is because DQBUF calls unmap_dmabuf op. This
> causes problem because video device will still need this buffer so future
> frames referencing to it can be decoded properly. Has anyone else faced
> this problem? Is there a patch for reference counting the MMU
> mappings/unmappings so that driver has more control over it?

I think we need two things for this:

- Streaming mappings for DMA buffers so that the buffers need not to be
  unmapped when the driver is done processing the buffer, and mapped when
  the driver gets the buffer again.

- A generic way to tell the user space the buffer is still accessed by the
  driver as read-only. Currently the buffer may not be accessed by the user
  space while it is owned by the driver, or accessed by the driver when it
  is owned by the user.
  
  I think a new buffer flag should be used for this. QUERYBUF could be used
  to ask the driver whether a buffer is still read-only, if needed.
  
  I wonder if the user would need to explicitly inform the driver that it
  should pass buffers to user space even if they are accessed as read-only
  in order not to potentially break existing applications (which expect
  buffers to be writable once dequeued).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
