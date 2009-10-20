Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15908 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZJTNxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 09:53:20 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KRT00EK8FGA1I10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Oct 2009 14:43:22 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KRT008Q4FG9R4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Oct 2009 14:43:21 +0100 (BST)
Date: Tue, 20 Oct 2009 15:41:30 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [RFC] v1.1: Multi-plane (discontiguous) buffers
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45382@bssrvexch01.BS.local>
Content-language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

we are currently working on a chip that requires a separate buffer for each
plane in a frame. Our hardware requires, those plane buffers not to be placed
immediately one after another.

There is no support for such buffers in V4L2 yet and we would like to propose
a solution for this problem.


Purpose and requirements
=========================
Currently, the v4l2_buffer struct supports only contiguous memory buffers,
i.e. one frame has to fit in one, contiguous physical buffer. A driver
receives and passes back to the userspace (e.g. when mmap()ing) only one
pointer (offset).

Our hardware requires two physically separate buffers for Y and CbCr components,
which must be placed in two different memory banks.
A similar problem was also expressed by Jun Nie in a recent discussion on this
list:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/10462.

That proposal included a hardcoded 3-plane format.
There also was a requirement for per-plane stride as well and although we have
not included it in this proposal, it could be easily incorporated into this
design (see comments below).

We would like to add support for a more general type of buffers: n-plane
buffers.
No changes should be made to break the existing API.



Proposed extensions
====================
The proposed extensions to the framework are as follows:

1. Add two new memory types:

 enum v4l2_memory {
         V4L2_MEMORY_MMAP             = 1,
         V4L2_MEMORY_USERPTR          = 2,
         V4L2_MEMORY_OVERLAY          = 3,
+        V4L2_MEMORY_MULTI_USERPTR    = 4,
+        V4L2_MEMORY_MULTI_MMAP       = 5,
 };

The new types would be used to identify multi-planar buffers.


2. Modify the buffer struct (no change to size):

struct v4l2_buffer {
         /* ... */
         union {
                 __u32           offset;
                 unsigned long   userptr;
+                unsigned long   multi_info_ptr;
         } m;
         /* ... */
 };


3. The multi_info_ptr would contain a userspace pointer to a structure further
describing the buffer:

+ struct v4l2_multiplane_info {
+         __u32  count;
+         struct v4l2_plane[0];
+ };

Where the v4l2_plane array would contain count elements:

+ struct v4l2_plane {
+         __u32   parent_index;
+         __u32   bytesused;
+         union {
+                 __u32 offset;
+                 unsigned long userptr;
+         } m;
+         __u32   flags;
+         __u32   length;
+         __u32   reserved;
+ };

parent_index - index of the parent v4l2_buffer

offset, userptr, bytesused, length - same as in v4l2_buffer struct but for
current frame

flags - one flag currently: V4L2_PLANE_FLAG_MAPPED
(or reuse V4L2_BUF_FLAG_MAPPED for that)

A stride field could also be added if there is a need for one. 



How this would work
===================

-------------------------------------------------------------------------------
1. Formats
-------------------------------------------------------------------------------
No need to change the format API, although new formats for such buffers may be
needed and added, as required.


-------------------------------------------------------------------------------
2. Requesting, querying and mapping buffers
-------------------------------------------------------------------------------
No changes to existing applications/drivers required.

A driver (and the videobuffer framework components) willing to support
multi-plane buffers would have to be made aware of the new memory types:


VIDIOC_REQBUFS:
---------------

- MULTI_MMAP:

  * application: pass the new memory type and count of multi-plane buffers
    (not plane count) normally

  * driver: fills in count as usual, being the number of actually allocated
    buffers (i.e. 1 for each multi-plane buffer, not each plane)

- MULTI_USERPTR:
  * no changes


VIDIOC_QUERYBUFS:
-----------------
- MULTI_MMAP:

* application: pass a v4l2_buffer struct as usual, but with the new memory
    type and a userspace pointer (in multi_info_ptr) to an instance of 
    v4l2_multiplane_info structure. The structure and the embedded
    v4l2_plane[] array has to be preallocated in userspace and have count set
    to the required number of planes.

* driver fills offset fields in each v4l2_plane struct, analogically to
  offsets in "normal" v4l2_buffers.


- MULTI_USERPTR:
n/a



mmap()
-----------------
Basically just like in normal buffer case, but with planes instead of buffers
and one mmap() call per each plane.

- application calls mmap count times (one for each plane), passing the offsets
provided in v4l2_plane structs

- there is no need for those calls to be in any particular order.


- driver (videobuffer framework) should store an array of planes
internally - just like it does with v4l2_buffers - and match offsets in 
that array to those provided in mmap.

- a plane gets marked as mapped (V4L2_PLANE_FLAG_MAPPED flag) after
a successful mmap. A buffer changes state to mapped (V4L2_BUF_FLAG_MAPPED)
only if all of its planes are mapped.

- matching planes with buffers can be done using the parent_index member


-------------------------------------------------------------------------------
3. Queuing and dequeuing buffers, buffer usage
-------------------------------------------------------------------------------

No real changes have to be made to be made to the v4l2 framework, the buffers
get queued and dequeud as usual. Only access to the new type differs, but
not much - in practice, just handle more pointers than one.

As for the videobuffer framework, additional function(s) to acquire addresses
to each plane will have to be added and it should be made aware of planes.
But the overall mechanism remains mostly unchanged.



Comments are welcome, especially other requirements that we might not have
considered.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center

