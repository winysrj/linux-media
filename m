Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47932 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbbFAPtk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 11:49:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC] Export alignment requirements for buffers
Date: Mon, 01 Jun 2015 18:50:06 +0300
Message-ID: <46233666.tCPCuE4QYo@avalon>
In-Reply-To: <556C2993.4030708@xs4all.nl>
References: <556C2993.4030708@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 01 June 2015 11:44:51 Hans Verkuil wrote:
> One of the things that is really irritating is the fact that drivers that
> use contig-dma sometimes want to support USERPTR, allowing applications to
> pass pointers to the driver that point to physically contiguous memory that
> was somehow obtained, and that userspace has no way of knowing whether the
> driver has this requirement or not.
>
> A related issue is that, depending on the DMA engine, the user pointer might
> have some alignment requirements (page aligned, or at minimum 16 bytes
> aligned) that userspace has no way of knowing.
> 
> The same alignment issue is present also for dma-buf.

Doesn't the first issue also apply to DMABUF ?

As you already know, I'm not a big fan of USERPTR when used for sharing 
buffers between devices. DMABUF is a much better choice there. USERPTR can 
still be helpful for other use cases though. One of them that comes to my mind 
is to capturing directly buffers allocated by a software codec (or another 
similar userspace library) that doesn't support externally allocated memory 
(although the core issue there would be the library design).

Anyway, the problem of conveying memory constraints is identical in the DMABUF 
case, so a solution is needed.

> I propose to take one reserved field from struct v4l2_create_buffers and
> from struct v4l2_requestbuffers and change it to this:
> 
> 	__u32 flags;
> 
> #define V4L2_REQBUFS_FL_ALIGNMENT_MSK	0x3f
> #define V4L2_REQBUFS_FL_PHYS_CONTIG	(1 << 31)
> 
> Where the alignment is a power of 2 (and if 0 the alignment is unknown). The
> max is 2^63, which should be enough for the foreseeable future :-)
> 
> If the physically contiguous flag is set, then the buffer must be physically
> contiguous.
> 
> These flags can be set for every vb2 dma implementation:
> 
> dma-contig: the PHYS_CONTIG flag is always set and the alignment is (unless
> overridden by the driver) page aligned.
> 
> dma-sg: the PHYS_CONTIG flag is 0 and the alignment will depend on the
> driver DMA implementation. Note: malloc will align the buffer to 8 bytes on
> a 32 bit OS and 16 bytes on a 64 bit OS.
> 
> vmalloc: PHYS_CONFIG is 0 and the alignment should be 3 (2^3 == 8) for 32
> bit and 4 (2^4=16) for 64 bit OS. This matches malloc() which will align
> the buffer to 8 bytes on a 32 bit OS and 16 bytes on a 64 bit OS.
> 
> The flags field can be extended with things like OPAQUE if the buffers
> cannot be mmapped (since they are in protected memory).
> 
> Comments? Alternative solutions?

The question of conveying memory constraints has been raised several times in 
the past, without any solutions being merged. The work has been revived 
recently, see http://lists.freedesktop.org/archives/dri-devel/2015-February/076862.html for instance.

Even if the API proposed here is specific to V4L2, and even if the patch set I 
linked to addresses a different problem, I believe it would be wise to widen 
the audience to make sure the solutions we come up with are at least aligned 
between subsystems. I've thus CC'ed Sumit to this e-mail as a start.

-- 
Regards,

Laurent Pinchart

