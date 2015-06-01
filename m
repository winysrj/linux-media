Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50993 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbbFALCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 07:02:35 -0400
Message-ID: <556C3BC2.2050500@xs4all.nl>
Date: Mon, 01 Jun 2015 13:02:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Export alignment requirements for buffers
References: <556C2993.4030708@xs4all.nl> <20150601104428.GE25595@valkosipuli.retiisi.org.uk>
In-Reply-To: <20150601104428.GE25595@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/01/2015 12:44 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the RFC.
> 
> On Mon, Jun 01, 2015 at 11:44:51AM +0200, Hans Verkuil wrote:
>> One of the things that is really irritating is the fact that drivers that
>> use contig-dma sometimes want to support USERPTR, allowing applications to
>> pass pointers to the driver that point to physically contiguous memory that
>> was somehow obtained, and that userspace has no way of knowing whether the
>> driver has this requirement or not.
>>
>> A related issue is that, depending on the DMA engine, the user pointer might
>> have some alignment requirements (page aligned, or at minimum 16 bytes aligned)
>> that userspace has no way of knowing.
>>
>> The same alignment issue is present also for dma-buf.
>>
>> I propose to take one reserved field from struct v4l2_create_buffers and
>> from struct v4l2_requestbuffers and change it to this:
>>
>> 	__u32 flags;
>>
>> #define V4L2_REQBUFS_FL_ALIGNMENT_MSK	0x3f
> 
> How about V4L2_REQBUFS_FL_ALIGN_MASK instead? It's shorter, and that msk
> part looks odd to me.

Hmm, how to do this. Currently it masks out 6 bits which form the power-of-two
that determines the alignment. How about this:

#define V4L2_REQBUFS_FL_ALIGN_EXP(flags) ((flags) & 0x3f)
#define V4L2_REQBUFS_FL_ALIGN_MASK(flags) ((1ULL << (flags & 0x3f)) - 1)

That gives you both mask and the exponent. Better names are welcome :-)
ALIGN_PWR? PWR2? ALIGN_AT_BIT?

> 
>> #define V4L2_REQBUFS_FL_PHYS_CONTIG	(1 << 31)
>>
>> Where the alignment is a power of 2 (and if 0 the alignment is unknown). The max
>> is 2^63, which should be enough for the foreseeable future :-)
>>
>> If the physically contiguous flag is set, then the buffer must be physically
>> contiguous.
> 
> Both only apply to userptr buffers. I guess saying this in documentation
> only is enough.

I don't follow you. Perhaps there is some confusion here? The flags field is set
by the driver, not by userspace. So PHYS_CONTIG applies to any type of buffer if
the driver uses dma-contig. And the alignment is valid for all drivers as well.

> 
> The approach looks good to me.
> 
>> dma-contig: the PHYS_CONTIG flag is always set and the alignment is (unless overridden
>> by the driver) page aligned.
>>
>> dma-sg: the PHYS_CONTIG flag is 0 and the alignment will depend on the driver DMA
>> implementation. Note: malloc will align the buffer to 8 bytes on a 32 bit OS and 16 bytes
>> on a 64 bit OS.
>>
>> vmalloc: PHYS_CONFIG is 0 and the alignment should be 3 (2^3 == 8) for 32 bit and
>> 4 (2^4=16) for 64 bit OS. This matches malloc() which will align the buffer to
>> 8 bytes on a 32 bit OS and 16 bytes on a 64 bit OS.
> 
> Ack. Many dma-sg drivers actually can handle physically contiguous memory
> since they're behind an IOMMU; the drivers can then set the flag if needed.

All dma-sg drivers can handle phys contig memory since that's just one DMA descriptor.

The flag is meant to say that the buffer *has* to be phys contig, not that it might
be. So dma-sg drivers will not set it, since they don't have that requirement.

Regards,

	Hans
