Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15458 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0BVQKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 11:10:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KY90082T3L8EI00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:20 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KY9007L83L72D@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Feb 2010 16:10:20 +0000 (GMT)
Date: Mon, 22 Feb 2010 17:10:05 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH/RFC v1 0/4] Multi-plane video buffer support for V4L2 API and
 videobuf
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, m-karicheri2@ti.com
Message-id: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello,

This is a preliminary implementation of multi-planar buffer support for V4L2
and videobuf.

It is a rather big change so I wanted to put it up for discussion sooner rather
than later, in case we decide to go in a completely different direction.

We are proposing backward compatible extensions to the V4L2 API and a redesign
of memory handling in videobuf core and its memory type modules. The videobuf
redesign should have a minimal impact on current drivers though. No videobuf
high-level logic (queuing, etc.) has been changed.

Only streaming I/O has been tested, read/write might not work correctly.
vivi has been adapted for testing and demonstration purposes, but other drivers
will not compile. Tests have been made on vivi and on an another driver for an
embedded device (those involved dma-contig and USERPTR as well). I am not
attaching that driver, as I expect nobody would be able to compile/test it
anyway.


The previous discussion concerning V4L2 API changes can be found here:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11212.



=================================
Purpose and requirements
=================================
Currently, the v4l2_buffer struct supports only contiguous memory buffers,
i.e. one video frame has to fit into one, contiguous physical buffer. A driver
receives from and passes back to the userspace (e.g. when mmap()ing) only one
pointer (offset).

Our hardware requires two physically separate buffers for Y and CbCr
components, which must be placed in two different memory banks. A similar
problem was also expressed by Jun Nie:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/10462.

This series adds support for a more general type of video buffers: n-plane
buffers.


=================================
Contents
=================================
This series consists of the following parts:
- V4L2 API extensions
- videobuf core and memory type modifications
- vivi extensions for YCbCr422 2- and 3-planar formats

API extensions are standalone and fully backward compatible with the old
videobuf, drivers and applications.

As for videobuf, it could have probably been possible to retain backward
compatibility, but we have chosen to introduce some minimal changes, mostly
to avoid duplication. They should require only a little bit of minor and
practically automatic modifications in the existing drivers though (details
below).

We have also broken ABI compatibility in one place (videobuf_queue_ops), in
order to make sure those minor changes are taken into account by drivers that
use videobuf.

Please note that videobuf-dma-sg is not adapted yet and will fail to compile, as
will all the other drivers, with the exception of vivi, which is intended for
demonstration. I will of course adapt everything else as well, after we have
agreed on everything. I hope vmalloc and dma-contig are enough for everybody
to be able to test/verify and/or discuss.


=================================
I. V4L2 API changes
=================================

1. New memory types:
----------------------------------
V4L2_MEMORY_MULTI_USERPTR
V4L2_MEMORY_MULTI_MMAP

Basically USERTPTR and MMAP for multiplane buffers.


2. A new v4l2_plane structure.
----------------------------------
v4l2_buffers of type V4L2_MEMORY_MULTI_* now contain an array of v4l2_plane
structures under their 'planes' member pointer. The size of the array should be
equal to the number of planes in the buffer and should be stored in the 'length'
member of the buffer structure (recycled for this purpose).

The v4l2_plane structure members retain the meaning of their counterparts
in the v4l2_buffer struct, but refer to their respective planes.


3. Ioctl handling
----------------------------------
Automatic v4l2_plane array copying has been added for relevant ioctls: QUERYBUF,
QBUF and DQBUF. Copy operations are performed only if 'memory' is set to
V4L2_MEMORY_MULTI_* and the 'planes' pointer is not NULL.



=================================
II. videobuf API changes
=================================

1. A new videobuf_plane structure
----------------------------------
All the memory-related info, such as baddr, bsize, etc. has been moved there.
Mappings and private data for memory-specific code should be per-plane now as
well. The videobuf_buffer structure now contains the buffer logic-related parts
only (queuing, etc.). From the logical point of view (e.g. queuing, waiting,
etc.) a videobuf_buffer is it still one entity (userspace cannot operate on
planes separately). The new 'mapped' member is set to 1 when all the planes
are mapped.

A plane is treated as a separate memory buffer, so now all the memory
type-related management operates on planes, even if the buffer is not
multiplanar. A non-multiplanar buffer is simply a buffer with one plane
(planes start at 0).

I could have left baddr, bsize, etc. in videobuf_buffer to retain compatibility,
but I think that changing all related code from e.g. vb->baddr to
vb->planes[0].baddr, etc. is automatic and simple enough and a low price to pay
for a cleaner design.

I have left the priv pointer in videobuf_buffer to simplify allocation. It
should be an array (size equal to num_planes) of per-plane private data now.


2. Changes to queue_ops:
----------------------------------
* buf_setup() -> buf_negotiate()
This is intentional to break ABI compatibility. There were some alternatives,
e.g. to add a specific meaning to count while setting size to 0 in case of
multiplanes, but as drivers have to be adapted (due to the addition of planes
array) anyway, this should at least prevent binary drivers from exploding in
a hard-to-debug way.

* buf_setup_plane()
Basically buf_setup for every plane, called num_planes times.


3. Changes to qtype_ops
----------------------------------
* alloc()
Now accepts num_planes to allow allocation of planes and arrays of private data,
etc. The memory types are expected to allocate planes array and an additional
array for their private data (if required) under vb->priv.

* plane_vmalloc()
Is basically a per-plane vmalloc().

* videobuf_plane_to_*()
Per plane versions.

4. qtype_ops:
----------------
alloc() - now accepts number of planes as well. The memory-type code usually
needs to allocate its private structures for each plane. In order not to
overcomplicate things, I chose not to add a priv pointer to videobuf_plane and
the memory-type code is to store everything in the buffer's priv, as an array.


=================================
Other issues and considerations
=================================

1. bytesused in v4l2_buffer
----------------------------------
I am not sure what to do with this, as bytesused has been moved to v4l2_plane.
Should it contain a sum of all per-plane 'bytesused'?


2. sizeimage in v4l2_pix_format
----------------------------------
The API says:
"Size in bytes of the buffer to hold a complete image, set by the driver.
Usually this is bytesperline times height."

It is a similar problem to the previous one... should it be a sum?  I feel it
loses its usability anyway for multiplane formats though.

3. VIDIOC_QUERYBUF
Filling in memory type for this ioctl in case of multiplane buffers is required
for the ioctl usercopy code to copy the planes array. It is analogical to QBUF
and DQBUF, but 'memory' is a required argument for those latter ioctls already.
Non-multiplane users are not affected.

4. DQBUF copy-back
videobuf_status copies back buffer data during DQBUF, including buffer
addresses, etc. For multiplane buffers this would require passing the planes
array to each DQBUF call. Applications usually use only indexes anyway, so
I have made this optional (the data is not copied if the array has not been
passed).


=================================
Required driver changes
=================================
For drivers that use videobuf and do not intend to support multiplanes:

1. Switch from buf_setup() to buf_negotiate(), return buffer count as usual
and '1' as the number of planes.

2. Move buffer size calculation from buffer_setup() to buffer_setup_plane(),
expect it to be called once with plane = 0. Return the buffer size as it was
for the old buf_setup().

3. For members of video_buffer moved to videbuf_plane, use their equivalents
for plane 0, e.g.: vb->planes[0].baddr instead of vb->baddr.


=================================
>From an application's point of view
=================================

Fully backward compatible with existing applications, no changes required if
an application does not intend to support multiplane buffers.


How multi-buffer extensions affect applications that intend to support them:

1. Formats
----------------------------------
No need to change the format API (although there might be a small problem with
sizeimage in v4l2_pix_format, see above). New forccs for multiplane buffers
have to be added as required.

Requesting multiplane versions of buffers can be made by passing one of the
multiplane fourccs to the S_FMT call.


2. Requesting, querying and mapping buffers
----------------------------------
The whole process is almost identical to the non-multiplane case, but with
pointers/offsets/sizes and mmap() per each plane, not per buffer.


* VIDIOC_REQBUFS:
Pass the new memory type and count of video frames (not plane count) normally.
Expect the driver to return count as usual or EINVAL if multiplanes are not
supported.

* VIDIOC_QUERYBUFS:
Pass a v4l2_buffer struct as usual, set a multiplane memory type and put a
pointer to an array of v4l2_plane structures under 'planes'.  Place the size
of that array in 'length'. Expect the driver to fill offset fields in each
v4l2_plane struct, analogically to offsets in non-multiplanar v4l2_buffers.

* VIDIOC_QBUF
As in the case of QUERYBUFS, pass along the array of planes and its size in
'length'. Fill all the fields required by non-multiplanar versions of this call,
although some of them in the planes' array members.

* VIDIOC_DQBUF
Array of planes does not have to be passed, but if you do pass it, you will
have it filled with data, just like in case of the non-multiplane version.

* mmap()
Basically just like in non-multiplanar buffer case, but with planes instead of
buffers and one mmap() call per each plane.

Call mmap() once for each plane, passing the offsets provided in v4l2_plane
structs. Repeat for all buffers (num_planes * num_buffers calls to mmap).
There is no need for those calls to be in any particular order.

A v4l2_buffer changes state to mapped (V4L2_BUF_FLAG_MAPPED flag) only after all
of its planes have been mmapped successfully.

-----------------------------------------------------------

The series contains:

[PATCH v1 1/4] v4l: add missing checks for kzalloc returning NULL.
[PATCH v1 2/4] v4l: Add support for multi-plane buffers to V4L2 API.
[PATCH v1 3/4] v4l: videobuf: Add support for multi-plane buffers.
[PATCH v1 4/4] v4l: vivi: add 2- and 3-planar YCbCr422
[EXAMPLE v1] Test application for multiplane vivi driver.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
