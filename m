Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53857 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbbKLTxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 14:53:35 -0500
Received: from recife.lan (unknown [179.183.110.204])
	by lists.s-osg.org (Postfix) with ESMTPSA id 880D5462A0
	for <linux-media@vger.kernel.org>; Thu, 12 Nov 2015 11:53:33 -0800 (PST)
Date: Thu, 12 Nov 2015 17:53:29 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: LMML <linux-media@vger.kernel.org>
Subject: [ANNOUNCE DRAFT] Kernel Summit Media Workshop 2015 report - Seoul
Message-ID: <20151112175329.6ccc66f3@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's the first draft of the KS workshop that we had in Seoul.

It is based on the notes we took on Etherpad, but I had to add several things
from my memory and from Hans slide deck.

A graph version of this draft is at:
	http://linuxtv.org/news.php?entry=2015-11-12.mchehab

TODO:
	Add group photo and links to the presentations
	Fix some visual issues at the web.

---

Linux Kernel Summit Media Workshop – Seoul 2015

Attendees list:

    Arnd Bergmann – Linaro – arnd@arndb.de
    David Howells – Red Hat – dhowells@redhat.com
    Geunyoung Kim – Samsung Visual Display Business – nenggun.kim@samsung.com
    Hans Verkuil – Cisco Systems Norway – hverkuil@xs4all.nl
    Ikjoon Kim – Samsung Visual Display Business – ikjoon.kim@samsung.com
    Inki Dae – Samsung Software R&D Center – inki.dae@samsung.com
    Javier Martinez Canillas – Samsung OSG – javier@osg.samsung.com
    Junghak Sung – Samsung Visual Display Business – jh1009.sung@samsung.com
    Laurent Pinchart – Ideas on Board – laurent.pinchart@ideasonboard.com
    Luis de Bethencourt – Samsung OSB – luisbg@osg.samsung.com
    Mark Brown – Linaro – broonie@kernel.org
    Mauro Carvalho Chehab – Samsung OSG – mchehab@osg.samsung.com
    Minsong Kim – Samsung Visual Display Business – ms17.kim@samsung.com
    Pawel Osciak – Google – pawel@osciak.com
    Rany Kwon – Samsung Visual Display Business – rany.kwon@samsung.com
    Reynaldo – Samsung OSG – reynaldo@osg.samsung.com
    Seung-Woo Kim – Samsung Software R&D Center – sw0312.kim@samsung.com
    Shuah Khan – Samsung OSG – shuahkh@osg.samsung.com
    Thiago – Samsung OSG – thiagoss@osg.samsung.com
    Tomasz Figa – Google – tfiga@chromium.org
    Vinod Koul – Intel – vinod.koul@intel.com

1. Codec API
============

Stream API
==========

The original V4L2 codec API was developed along with the Exynos codec driver. As the device implements high-level operations in hardware the resulting API was high-level as well with drivers accepting unprocessed raw streams. This matches older ARM SoCs where CPU power wasn’t deemed enough to implement stream parsing.

Drivers implement two V4L2 buffer queues, one on the uncompressed side and one on the compressed side. The two queues operate independently, without a 1:1 correspondence between consumed and produced buffers (for instance reference frames need to be accumulated when starting video encoding before producing any output or bitstream header parsed before CAPTURE buffers can be allocated). The mem2mem V4L2 kernel framework thus can’t be used to implement such codec drivers as it hardcodes this 1:1 correspondence. This is a kernel framework issue, not a V4L2 userspace API issue.

(For stream API fundamentals see Pawel’s slides)

Frame API (Slice API)
=====================

CPUs are getting faster in the ARM world. The trend is to implement lower-level hardware codecs that require stream parsing on the CPU. CPU code needs to slice the stream, extract information, process them and pass the result to a shader-like device. This is the model used on Intel platforms and implemented in the VA API library.

Drivers still implement two V4L2 buffer queues, but the encoded stream is split into frames of slices, and a large number of codec-specific controls need to be set from parsed stream information.

Stream parsing and parameters calculation is better done in userspace. Userspace is responsible for managing reference frames and their life time, and for passing data to the codec in such a way that an input buffer will always produce an output buffer. The two queues operate together with a 1:1 correspondence between buffers. The mem2mem framework is thus usable.

Sources buffer contain only slice data (macroblocks + coefficient data). Controls contain information extracted from stream parsing, list of reference frames and DPB (Decoded Picture Buffer). The request API can be used to associate controls with source buffers.

Keeping references to reference frames is one of the remaining problems (especially with DMABUF, and possibly with MMAP in the future when we’ll have the ability to destroy MMAP buffers while streaming). This problem also exists for the stream API. More discussion is needed to design a solution.

Pawel promised to upstream the ChromeOS codec drivers code this year (and you should be also nagging Tomasz to do it…).

For encoders header generation should probably be done in userspace as well as the code is complex and doesn’t require a kernel implementation.

Userspace code should be implemented as libv4l2 plugins to interface between the frame API exposed by the kernel and a stream API exposed to applications.

Status
======

See Pawel’s slides.

Discussion points
=================

Further discussions should happen during the Workshop week (scheduled to happen on Tuesday at 11:30).

References:
===========

Intel libVA SDK: https://bugs.freedesktop.org/show_bug.cgi?id=92533
Request API: https://lwn.net/Articles/641204/
Chromium Code (user): https://code.google.com/p/chromium/codesearch#chromium/src/content/common/gpu/media/v4l2_slice_video_decode_accelerator.cc

2. kABI
=======

The presentation slides are at:

API and kABI Documentation and Improvements from Samsung Open Source Group

The API status is that the DVB documentation API for DVR/demux and CA are outdated and needs some work. The level of documentation at V4L2 is superior than the ones provided for the other media APIs.

The kABI status is that just the DVB Demux and CA documentation is OK. The remaining kABI core functions/structs/enum/… are incomplete. Also, non-core V4L2 headers are mixed with the core ones, making harder to identify the gaps. It was agreed to move some documentation from Documentation/{video4linux,dvb} to the kAPI DocBook.

It was pointed kABI needs more review by developers and sub-maintainers.

It was decided that all new kernel kABI need to be documented, but it was agreed that adding e.g. new fields to undocumented structures doesn’t require the submitter to document the full struct (although it obviously would be very much appreciated).

Laurent suggested to use kernel doc for ‘top-level’ documentation, as found at drivers/gpu/drm/drm_atomic_helper.c (look for “DOC: overview”) and
Documentation/DocBook/drm.tmpl (look for “!Pdrivers/gpu/drm/drm_atomic_helper.c overview”) for the media documentation.

3. uAPI improvements for DVB streaming
======================================

videobuf2
=========

Junghak explained the status of the current videobuf2 DVB patches:

    Adds DVB mmap support using a set of ioctls similar to the ones at V4L2 side.
    No DMABUF support at the moment. It was recommended that that’s added, at the very least planned in the API and likely implemented too.
    Support for DVB output (‘mem2mem demux’) is also recommended, although this is not required for the first version of the DVB.
    Streamon/off is automatically called in the DVB API: should this be available as ioctl? No need seen for this. So, the proposal doesn’t add support for it.
    DVB framework needs to be extended to see whether userspace uses read() or stream I/O. As V4L2 does this as well, it was proposed to usethe same method for DVB too.
    No need to add (or remove) buffers at runtime (à la CREATE_BUF) is foreseen.

SoC pipelines
=============

Samsung SoCs have full hardware pipelines from the tuner output to the screen that, once set, won’t require any intervention at runtime. This requires connecting a DVB device to a V4L2 and/or DRM device.

Hardware pipelines include hardware-configured scalers for seamless resolution change, in order to achieve real-time operation when the input resolution changes, as there are some requirements on changing the resolution without causing any visible image glimpses. It is currently hard to make this work with the current DVB framework, without the Media Controller.

4. v4l2_buffer & Y2038
======================

Should we create a new structure and fix several other issues in one go? This could be an opportunity to start supporting sub-streams.

As Arnd pointed, even if we do it, a backward compatible code will be needed in order to handle the changes on the size of the structure between 32 and 64 bits calls. It sounds reasonable, though that it is time to create a v4l2_buffer_v2 now that we’ll need to increase the size of the struct anyway.

There might be a cache-related problem due to the way DMABUF is handled. DMABUF buffers are only unmapped when applications queue a different DMABUF fd on the same V4L2 buffer index. By that time the driver doesn’t own access to the buffer but still tries to clean the cache. The root cause needs to be investigated.

A related issue is how V4L2 keeps DMABUF mappings around for performance improvement. This prevents buffer eviction by the GPU. This should be discussed with DRM developers and dma-buf maintainers.

Should we add support for sub-streams in a buffer ? Possibly for 3D capture, for other cases there’s not so much interest. Use cases would be needed.

Formats are specified for buffers and makes it difficult to transport meta-data in a plane along with image planes. Redesign of v4l2_buffer and v4l2_plane should take such use case into account.

5. poll() for output streams
============================

The current poll() behaviour is not usable for codecs. As mem2mem is considered as the main use case for output devices we need to optimize for that, and implement write emulation specific code in poll() as a special case. We’ll revert to the old implementation and update the documentation accordingly.

6. poll for capture streams
===========================

q->waiting_for_buffers is v4l2 specific, but after the vb2 split it is now part of the vb2 core: should this be moved to the v4l2 part or be kept in the vb2 core?
After discussing this the opinion is that we should make this v4l2 specific and allow DVB (and other subsystems) to use the standard behavior.
Proposals are welcome on ways to make userspace select the ‘waiting_for_buffers’ behavior for V4L2 since it is awkward there as well (but needed for backwards compatibility)

7. Hardware Color Space Conversion (CSC) status update
======================================================

For video output this already works: v4l2_pix_format(_mplane) contains all the information of the memory format including colorspace information and the driver can enable CSC hardware as needed. However, for video capture the colorspace information (colorspace, ycbcr_enc, quantization and xfer_func fields) is documented as being returned by the driver and the application cannot set it to a desired colorspace.
The suggested solution is to add a V4L2_PIX_FMT_FLAG_REQUEST_CSC flag for the v4l2_pix_format flags field. If set, the application-provided colorspace information will be used by the driver, otherwise the colorspace fields are zeroed. The core will always clear the flag, drivers have to set it in g/try/s_fmt to signal that they support HW colorspace conversion. In drivers, if all colorspace fields are 0, then just return the colorspace of the capture stream, otherwise attempt to do CSC.

8. HDMI-CEC status update
=========================

Last patch series is at v9: http://www.spinics.net/lists/linux-media/msg93362.html. The main to do is to rewrite the documentation for the CEC framework internals and to address some cleanup requests from Russell King.
Hans is unhappy about cec_ready() v4l2_subdev op. But, as this is an internal API, it can be changed later. Such call is used when the CEC adapter is created.

9. VIDIOC_CREATE_BUFS and v4l2_format validation
================================================

How to validate the ‘struct v4l2_format format;’ field? It is documented as “Filled in by the application, preserved by the driver” and “Unsupported formats will result in an error”. However, most drivers use just the sizeimage field, some do partial validation (usually the pixelformat and resolution). Validation is done in the vb2 queue_setup() callback: leads to a void * argument in vb2 core. The original idea was that format contains a format different from the current and that the created buffers would be valid for the requested format. In practice it’s the different buffer size that is of interest.  That means that there is an inconsistent behavior. The question is how to fix?

It was proposed to handle it the same way as REQUEST_BUFS: expect that userspace calls TRY_FMT or similar to fill the format field and only use sizeimage field in drivers.

10. Media Controller Next Generation status update
==================================================

It was briefly discussed the MC next gen status, focusing on the discussions on how this will work with ALSA. It was pointed by Mark and Vinod that the current ALSA patches are barely touching the needs; an aSoC pipeline would be a way more complex than what was done so far on the ALSA patchset.

Vinod and Mark are looking for a way to be able to set a topology using ‘cat file >/dev/mediaX’. This is currently provided via request_firmware logic on aSoC. We need to find a way to keep a core MC support that would be consistent with the current topology setup on aSoC. Both ALSA and media developers need to be involved on such development.

Atomic configuration updates across subsystems (MC for links, V4L2/ALSA for other parameters, …) needs to be taken into account.

For audio devices routing changes ordering matters unless the hardware can apply routing changes atomically.

11. VIDIOC_SUBDEV_QUERYCAP
==========================

QUERYCAP is desired for v4l-subdev devices, because there are currently no ioctls that are always available for v4l-subdev devices, and having such an ioctl will make v4l2-compliance easier to write. It would also be nice to find the media controller from a device node.

It was proposed two solutions:

    to create a struct v4l2_subdev_capability and add a new V4L2-specific ioctl;
    all MC-aware interfaces would support a MEDIA_IOC_DEVICE_INFO ioctl.

It was suggested to check if implementing MEDIA_IOC_INTERFACE_INFO is easy to be added on the various subsystems (dvb, alsa, drm, iio).

12. DELETE_BUFFERS
==================

Suggested by Laurent to create a new ioctl to be able to dynamically delete some buffers created via CREATE_BUFFERS.

A related issue is to allow for more than 32 buffers (already requested in the past).

One of the issues is if the buffer numbers will have “holes” or if the Kernel will dynamically re-allocate bufs array in vb2_queue.

The problem with having holes is the need for an efficient index-to-vb2_buffer lookup.

It was agreed that we’d like to have it. Ditto for more than 32 buffers (don’t limit this).

13. Workshop format
===================

It is currently very technical, hard for non-core developers to follow. What would be the alternatives?

One alternative would be to split into two parts:

    First part less technical, more about status updates, presenting work in progress, invite presentations from application devs, etc.
    Second part for core devs. Perhaps a two day format? Or do two one-day workshops a year, one technical, one open for all?

How do other subsystems do it?

It was proposed to do that on the media workshops that there are at least two days afailable. If we have two days available, then post a CFP to various mailing lists (including apps like gstreamer).

It was suggested that we should do one of the media workshops next year co-located with alsa workshop, in order to address the Media Controller related questions.
