Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60593 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab2FDUqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 16:46:38 -0400
Received: by qadb17 with SMTP id b17so1668277qad.19
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 13:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsTYpHeqEHJZtkA2p61EG4x-J9MTUjWJe7tzws-eL9T6Q@mail.gmail.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
	<5090892.Z3RkLXNQ1U@avalon>
	<CAB2ybb-0D4vs=k6GjBuw8OitDpPSjDdyOcEqogFtGdZUk0pasQ@mail.gmail.com>
	<CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com>
	<CAF6AEGsTYpHeqEHJZtkA2p61EG4x-J9MTUjWJe7tzws-eL9T6Q@mail.gmail.com>
Date: Mon, 4 Jun 2012 13:46:37 -0700
Message-ID: <CALJcvx58yjQQ_vLkx1VUAQ=PvBVVo2Sy+Wgbg7ZKMLsxT9Focg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv6 00/13] Integration of videobuf2 with dmabuf
From: Rebecca Schultz Zavin <rebecca@android.com>
To: Rob Clark <robdclark@gmail.com>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	remi@remlab.net, pawel@osciak.com, mchehab@redhat.com,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kyungmin.park@samsung.com, airlied@redhat.com,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to do it in my drivier, but I'm not sure how to make it
safe since there is no way to tell the kernel the total size of the
buffer.  From what I can tell, I can't sanity check that the offset
and lengths are within the buffer without adding a field.

Rebecca

On Mon, Jun 4, 2012 at 1:28 PM, Rob Clark <robdclark@gmail.com> wrote:
> this is at least how we do it w/ drm/kms.. I would expect that if you
> could do that w/ output for v4l you also could for input, but perhaps
> the individual driver needs to do something to support mplane?  I
> guess the v4l folks would know better
>
> BR,
> -R
>
> On Tue, Jun 5, 2012 at 3:34 AM, Rebecca Schultz Zavin
> <rebecca@android.com> wrote:
>> I have a system where the data is planar, but the kernel drivers
>> expect to get one allocation with offsets for the planes.  I can't
>> figure out how to do that with the current dma_buf implementation.  I
>> thought I could pass the same dma_buf several times and use the
>> data_offset field of the v4l2_plane struct but it looks like that's
>> only for output.  Am I missing something?  Is this supported?
>>
>> Thanks,
>> Rebecca
>>
>> On Wed, May 30, 2012 at 8:26 AM, Semwal, Sumit <sumit.semwal@ti.com> wrote:
>>> On Tue, May 29, 2012 at 6:25 AM, Laurent Pinchart
>>> <laurent.pinchart@ideasonboard.com> wrote:
>>>> Hi Tomasz,
>>> Hi Tomasz, Laurent, Mauro,
>>>>
>>>> On Wednesday 23 May 2012 14:10:14 Tomasz Stanislawski wrote:
>>>>> Hello everyone,
>>>>> This patchset adds support for DMABUF [2] importing to V4L2 stack.
>>>>> The support for DMABUF exporting was moved to separate patchset
>>>>> due to dependency on patches for DMA mapping redesign by
>>>>> Marek Szyprowski [4].
>>>>
>>>> Except for the small issue with patches 01/13 and 02/13, the set is ready for
>>>> upstream as far as I'm concerned.
>>> +1; Mauro: how do you think about this series? Getting it landed into
>>> 3.5 would make life lot easier :)
>>>>
>>>>> v6:
>>>>> - fixed missing entry in v4l2_memory_names
>>>>> - fixed a bug occuring after get_user_pages failure
>>>>
>>>> I've missed that one, what was it ?
>>>>
>>>>> - fixed a bug caused by using invalid vma for get_user_pages
>>>>> - prepare/finish no longer call dma_sync for dmabuf buffers
>>>>>
>>>>> v5:
>>>>> - removed change of importer/exporter behaviour
>>>>> - fixes vb2_dc_pages_to_sgt basing on Laurent's hints
>>>>> - changed pin/unpin words to lock/unlock in Doc
>>>>>
>>>>> v4:
>>>>> - rebased on mainline 3.4-rc2
>>>>> - included missing importing support for s5p-fimc and s5p-tv
>>>>> - added patch for changing map/unmap for importers
>>>>> - fixes to Documentation part
>>>>> - coding style fixes
>>>>> - pairing {map/unmap}_dmabuf in vb2-core
>>>>> - fixing variable types and semantic of arguments in videobufb2-dma-contig.c
>>>>>
>>>>> v3:
>>>>> - rebased on mainline 3.4-rc1
>>>>> - split 'code refactor' patch to multiple smaller patches
>>>>> - squashed fixes to Sumit's patches
>>>>> - patchset is no longer dependant on 'DMA mapping redesign'
>>>>> - separated path for handling IO and non-IO mappings
>>>>> - add documentation for DMABUF importing to V4L
>>>>> - removed all DMABUF exporter related code
>>>>> - removed usage of dma_get_pages extension
>>>>>
>>>>> v2:
>>>>> - extended VIDIOC_EXPBUF argument from integer memoffset to struct
>>>>>   v4l2_exportbuffer
>>>>> - added patch that breaks DMABUF spec on (un)map_atachment callcacks but
>>>>> allows to work with existing implementation of DMABUF prime in DRM
>>>>> - all dma-contig code refactoring patches were squashed
>>>>> - bugfixes
>>>>>
>>>>> v1: List of changes since [1].
>>>>> - support for DMA api extension dma_get_pages, the function is used to
>>>>> retrieve pages used to create DMA mapping.
>>>>> - small fixes/code cleanup to videobuf2
>>>>> - added prepare and finish callbacks to vb2 allocators, it is used keep
>>>>>   consistency between dma-cpu acess to the memory (by Marek Szyprowski)
>>>>> - support for exporting of DMABUF buffer in V4L2 and Videobuf2, originated
>>>>> from [3].
>>>>> - support for dma-buf exporting in vb2-dma-contig allocator
>>>>> - support for DMABUF for s5p-tv and s5p-fimc (capture interface) drivers,
>>>>>   originated from [3]
>>>>> - changed handling for userptr buffers (by Marek Szyprowski, Andrzej
>>>>>   Pietrasiewicz)
>>>>> - let mmap method to use dma_mmap_writecombine call (by Marek Szyprowski)
>>>>>
>>>>> [1]
>>>>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/4296
>>>>> 6/focus=42968 [2] https://lkml.org/lkml/2011/12/26/29
>>>>> [3]
>>>>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/3635
>>>>> 4/focus=36355 [4]
>>>>> http://thread.gmane.org/gmane.linux.kernel.cross-arch/12819
>>>>>
>>>>> Laurent Pinchart (2):
>>>>>   v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to vb2_dc
>>>>>   v4l: vb2-dma-contig: Reorder functions
>>>>>
>>>>> Marek Szyprowski (2):
>>>>>   v4l: vb2: add prepare/finish callbacks to allocators
>>>>>   v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator
>>>>>
>>>>> Sumit Semwal (4):
>>>>>   v4l: Add DMABUF as a memory type
>>>>>   v4l: vb2: add support for shared buffer (dma_buf)
>>>>>   v4l: vb: remove warnings about MEMORY_DMABUF
>>>>>   v4l: vb2-dma-contig: add support for dma_buf importing
>>>>>
>>>>> Tomasz Stanislawski (5):
>>>>>   Documentation: media: description of DMABUF importing in V4L2
>>>>>   v4l: vb2-dma-contig: Remove unneeded allocation context structure
>>>>>   v4l: vb2-dma-contig: add support for scatterlist in userptr mode
>>>>>   v4l: s5p-tv: mixer: support for dmabuf importing
>>>>>   v4l: s5p-fimc: support for dmabuf importing
>>>>>
>>>>>  Documentation/DocBook/media/v4l/compat.xml         |    4 +
>>>>>  Documentation/DocBook/media/v4l/io.xml             |  179 +++++++
>>>>>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |    1 +
>>>>>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 +
>>>>>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   45 +-
>>>>>  drivers/media/video/s5p-fimc/Kconfig               |    1 +
>>>>>  drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
>>>>>  drivers/media/video/s5p-tv/Kconfig                 |    1 +
>>>>>  drivers/media/video/s5p-tv/mixer_video.c           |    2 +-
>>>>>  drivers/media/video/v4l2-ioctl.c                   |    1 +
>>>>>  drivers/media/video/videobuf-core.c                |    4 +
>>>>>  drivers/media/video/videobuf2-core.c               |  207 +++++++-
>>>>>  drivers/media/video/videobuf2-dma-contig.c         |  520 ++++++++++++++---
>>>>>  include/linux/videodev2.h                          |    7 +
>>>>>  include/media/videobuf2-core.h                     |   34 ++
>>>>>  15 files changed, 924 insertions(+), 99 deletions(-)
>>>> --
>>>> Regards,
>>>>
>>>> Laurent Pinchart
>>>>
>>> Best regards,
>>> ~Sumit.
>>>
>>> _______________________________________________
>>> Linaro-mm-sig mailing list
>>> Linaro-mm-sig@lists.linaro.org
>>> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
