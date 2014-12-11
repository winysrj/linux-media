Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50660 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaLKSd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 13:33:28 -0500
Message-ID: <58d5518bed6f1511e08f1a66796fa2a9.squirrel@www.codeaurora.org>
In-Reply-To: <0dabfbb34c548337f7d1098b46e2d197.squirrel@www.codeaurora.org>
References: <0dabfbb34c548337f7d1098b46e2d197.squirrel@www.codeaurora.org>
Date: Thu, 11 Dec 2014 18:33:27 -0000
Subject: Re: V4L2_MEMORY_DMABUF for video decoders
From: vkalia@codeaurora.org
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, vrajesh@codeaurora.org,
	sachins@codeaurora.org, apurupa@codeaurora.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans/Community

Can you please help us with this query.

Thanks
Vinay

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
>
> Thanks
> Vinay
>


