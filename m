Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38914 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbbFAJo5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 05:44:57 -0400
Message-ID: <556C2993.4030708@xs4all.nl>
Date: Mon, 01 Jun 2015 11:44:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC] Export alignment requirements for buffers
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One of the things that is really irritating is the fact that drivers that
use contig-dma sometimes want to support USERPTR, allowing applications to
pass pointers to the driver that point to physically contiguous memory that
was somehow obtained, and that userspace has no way of knowing whether the
driver has this requirement or not.

A related issue is that, depending on the DMA engine, the user pointer might
have some alignment requirements (page aligned, or at minimum 16 bytes aligned)
that userspace has no way of knowing.

The same alignment issue is present also for dma-buf.

I propose to take one reserved field from struct v4l2_create_buffers and
from struct v4l2_requestbuffers and change it to this:

	__u32 flags;

#define V4L2_REQBUFS_FL_ALIGNMENT_MSK	0x3f
#define V4L2_REQBUFS_FL_PHYS_CONTIG	(1 << 31)

Where the alignment is a power of 2 (and if 0 the alignment is unknown). The max
is 2^63, which should be enough for the foreseeable future :-)

If the physically contiguous flag is set, then the buffer must be physically
contiguous.

These flags can be set for every vb2 dma implementation:

dma-contig: the PHYS_CONTIG flag is always set and the alignment is (unless overridden
by the driver) page aligned.

dma-sg: the PHYS_CONTIG flag is 0 and the alignment will depend on the driver DMA
implementation. Note: malloc will align the buffer to 8 bytes on a 32 bit OS and 16 bytes
on a 64 bit OS.

vmalloc: PHYS_CONFIG is 0 and the alignment should be 3 (2^3 == 8) for 32 bit and
4 (2^4=16) for 64 bit OS. This matches malloc() which will align the buffer to
8 bytes on a 32 bit OS and 16 bytes on a 64 bit OS.

The flags field can be extended with things like OPAQUE if the buffers cannot be
mmapped (since they are in protected memory).

Comments? Alternative solutions?

Regards,

	Hans
