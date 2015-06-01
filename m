Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41524 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751754AbbFAKpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 06:45:02 -0400
Date: Mon, 1 Jun 2015 13:44:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Export alignment requirements for buffers
Message-ID: <20150601104428.GE25595@valkosipuli.retiisi.org.uk>
References: <556C2993.4030708@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556C2993.4030708@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the RFC.

On Mon, Jun 01, 2015 at 11:44:51AM +0200, Hans Verkuil wrote:
> One of the things that is really irritating is the fact that drivers that
> use contig-dma sometimes want to support USERPTR, allowing applications to
> pass pointers to the driver that point to physically contiguous memory that
> was somehow obtained, and that userspace has no way of knowing whether the
> driver has this requirement or not.
> 
> A related issue is that, depending on the DMA engine, the user pointer might
> have some alignment requirements (page aligned, or at minimum 16 bytes aligned)
> that userspace has no way of knowing.
> 
> The same alignment issue is present also for dma-buf.
> 
> I propose to take one reserved field from struct v4l2_create_buffers and
> from struct v4l2_requestbuffers and change it to this:
> 
> 	__u32 flags;
> 
> #define V4L2_REQBUFS_FL_ALIGNMENT_MSK	0x3f

How about V4L2_REQBUFS_FL_ALIGN_MASK instead? It's shorter, and that msk
part looks odd to me.

> #define V4L2_REQBUFS_FL_PHYS_CONTIG	(1 << 31)
> 
> Where the alignment is a power of 2 (and if 0 the alignment is unknown). The max
> is 2^63, which should be enough for the foreseeable future :-)
> 
> If the physically contiguous flag is set, then the buffer must be physically
> contiguous.

Both only apply to userptr buffers. I guess saying this in documentation
only is enough.

The approach looks good to me.

> dma-contig: the PHYS_CONTIG flag is always set and the alignment is (unless overridden
> by the driver) page aligned.
> 
> dma-sg: the PHYS_CONTIG flag is 0 and the alignment will depend on the driver DMA
> implementation. Note: malloc will align the buffer to 8 bytes on a 32 bit OS and 16 bytes
> on a 64 bit OS.
> 
> vmalloc: PHYS_CONFIG is 0 and the alignment should be 3 (2^3 == 8) for 32 bit and
> 4 (2^4=16) for 64 bit OS. This matches malloc() which will align the buffer to
> 8 bytes on a 32 bit OS and 16 bytes on a 64 bit OS.

Ack. Many dma-sg drivers actually can handle physically contiguous memory
since they're behind an IOMMU; the drivers can then set the flag if needed.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
