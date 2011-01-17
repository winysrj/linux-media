Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2627 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1AQG7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 01:59:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC/PATCH v6 0/4] Multi Format Codec 5.1 driver for S5PC110 SoC
Date: Mon, 17 Jan 2011 07:59:29 +0100
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com
References: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1294417534-3856-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101170759.29752.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kamil,

I still need to review this carefully since this is the first codec driver.
I had hoped to do this during the weekend, but I didn't manage it. I hope I
can get to it on Friday.

One thing I noticed: you aren't using the control framework in this driver.
Please switch to that. From now on I will NACK any new driver that is not
using that framework. I'm in the process of converting all existing drivers
to it, and I don't want to have to fix new drivers as well :-)

Documentation is in Documentation/video4linux/v4l2-controls.txt.

Regards,

	Hans

On Friday, January 07, 2011 17:25:30 Kamil Debski wrote:
> Hello,
> 
> This is the sixth version of the MFC 5.1 driver, decoding part. The suggestions
> and comments from the group members have been very helpful.
> 
> I would be grateful for your comments. Original cover letter ant detailed change
> log has been attached below.
> 
> Best regards,
> Kamil Debski
> 
> * Changelog:
> 
> ==================
>  Changes since v5
> ==================
> 
> 1) Changes suggested by Hans Verkuil:
> - small change in videodev2.h - corrected control offsets
> - made the code more readable by simplifying if statements and using temporary
>   pointers
> - mfc_mutex is now included in s5p_mfc_dev structure
> - after discussion with Peter Oh modification of fourcc defintions
>  (replaced DX52 and DX53 with DX50)
> 
> 2) Changes suggested by JongHun Han:
> - comsmetic changed of defines in regs-mfc5.h
> - in buffers that have no width adn height, such as the buffer for compressed
>   stream, those values are set to 0 instead of 1
> - remove redundant pointer to MFC registers
> - change name of the union in s5p_mfc_buf from paddr to cookie
> - removed global variable (struct s5p_mfc_dev *dev) and moved to use video_drvdata
> 
> 3) Other changes:
> - added check for values returned after parsing header - in rare circumstances MFC
>   hw returned 0x0 as image size and this could cause problems
> 
> ==================
>  Changes since v4
> ==================
> 
> 1) Changes suggested by Kukjin Kim from:
> - removed comment arch/arm/mach-s5pv210/include/mach/map.h
> - changed device name to s5p-mfc (removed "5", MFC version number)
>   also removed the version number from the name of MFC device file
> - added GPL license to arch/arm/plat-s5p/dev-mfc.c
> - removed unused include file from dev-mfc.c and unnecessary comments
> 
> 2) Cache handling improvement:
> - changed cache handling to use dma_map_single and dma_unmap_single
> 
> ==================
>  Changes since v3
> ==================
> 
> 1) Update to the v6 videobuf2 API (here thanks go to Marek Szyprowski)
> - s5p_mfc_buf_negotiate and s5p_mfc_buf_setup_plane functions
> have been merged
> - queue initialization has been adapted to the new API
> - use of the allocator memops has been changed, now there are single
> memops for all the allocator contexts
> 
> 2) Split of the s5p_mfc_try_run and s5p_mfc_handle_frame_int functions
> - parts of the s5p_mfc_try_run function have been moved to separate
> functions (s5p_mfc_get_new_ctx, s5p_mfc_run_dec_last_frames,
> s5p_mfc_run_dec_frame, s5p_mfc_run_get_inst_no, s5p_mfc_run_return_inst
> s5p_mfc_run_init_dec,s5p_mfc_run_init_dec_buffers)
> - s5p_mfc_handle_frame_int has been split to the following functions:
> s5p_mfc_handle_frame_all_extracted, s5p_mfc_handle_frame_new
> and s5p_mfc_handle_frame to handle different cases
> 
> 3) Remove remaining magic numbers and tidy up comments
> 
> ==================
>  Changes since v2
> ==================
> 
> 1) Update to newest videobuf2 API
> This is the major change from v2. The videobuf2 API will hopefully have no more
> major API changes. Buffer initialization has been moved from buf_prepare
> callback to buf_init to simplify the process. Locking mechanism has been
> modified to the requirements of new videobuf2 version.
> 2) Code cleanup
> Removed more magic contants and replaced them with appropriate defines. Changed
> code to use unlocked_ioctl instead of ioctl in v4l2 file ops.
> 3) Allocators
> All internal buffer allocations are done using the selected vb2 allocator,
> instead of using CMA functions directly.
> 
> ==================
>  Changes since v1
> ==================
> 
> 1) Cleanup accoridng to Peter Oh suggestions on the mailing list (Thanks).
> 
> * Original cover letter:
> 
> ==============
>  Introduction
> ==============
> 
> The purpose of this RFC is to discuss the driver for a hw video codec
> embedded in the new Samusng's SoCs. Multi Format Codec 5.0 is able to
> handle video decoding of in a range of formats.
> 
> So far no hardware codec was supported in V4L2 and this would be the
> first one. I guess there are more similar device that would benefit from
> a V4L2 unified interface. I suggest a separate control class for codec
> devices - V4L2_CTRL_CLASS_CODEC.
> 
> Internally the driver uses videobuf2 framework and CMA memory allocator.
> I am aware that those have not yet been merged, but I wanted to start
> discussion about the driver earlier so it could be merged sooner. The
> driver posted here is the initial version, so I suppose it will require
> more work.
> 
> ==================
>  Device interface
> ==================
> 
> The driver principle is based on the idea of memory-to-memory devices:
> it provides a single video node and each opened file handle gets its own
> private context with separate buffer queues. Each context consist of 2
> buffer queues: OUTPUT (for source buffers, i.e. encoded video frames)
> and CAPTURE (for destination buffers, i.e. decoded raw video frames).
> The process of decoding video data from stream is a bit more complicated
> than typical memory-to-memory processing, that's why the m2m framework
> is not directly used (it is too limited for this case). The main reason
> for this is the fact that the CAPTURE buffers can be dequeued in a
> different order than they queued. The hw block decides which buffer has
> been completely processed. This is due to the structure of most
> compressed video streams - use of B frames causes that decoding and
> display order may be different.
> 
> ==============================
>  Decoding initialization path
> ==============================
> 
> First the OUTPUT queue is initialized. With S_FMT the application
> chooses which video format to decode and what size should be the input
> buffer. Fourcc values have been defined for different codecs e.g.
> V4L2_PIX_FMT_H264 for h264. Then the OUTPUT buffers are requested and
> mmaped. The stream header frame is loaded into the first buffer, queued
> and streaming is enabled. At this point the hardware is able to start
> processing the stream header and afterwards it will have information
> about the video dimensions and the size of the buffers with raw video
> data.
> 
> The next step is setting up the CAPTURE queue and buffers. The width,
> height, buffer size and minimum number of buffers can be read with G_FMT
> call. The application can request more output buffer if necessary. After
> requesting and mmaping buffers the device is ready to decode video
> stream.
> 
> The stream frames (ES frames) are written to the OUTPUT buffers, and
> decoded video frames can be read from the CAPTURE buffers. When no more
> source frames are present a single buffer with bytesused set to 0 should
> be queued. This will inform the driver that processing should be
> finished and it can dequeue all video frames that are still left. The
> number of such frames is dependent on the stream and its internal
> structure (how many frames had to be kept as reference frames for
> decoding, etc).
> 
> ===============
>  Usage summary
> ===============
> 
> This is a step by step summary of the video decoding (from user
> application point of view, with 2 treads and blocking api):
> 
> 01. S_FMT(OUTPUT, V4L2_PIX_FMT_H264, ...)
> 02. REQ_BUFS(OUTPUT, n)
> 03. for i=1..n MMAP(OUTPUT, i)
> 04. put stream header to buffer #1
> 05. QBUF(OUTPUT, #1)
> 06. STREAM_ON(OUTPUT)
> 07. G_FMT(CAPTURE)
> 08. REQ_BUFS(CAPTURE, m)
> 09. for j=1..m MMAP(CAPTURE, j)
> 10. for j=1..m QBUF(CAPTURE, #j)
> 11. STREAM_ON(CAPTURE)
> 
> display thread:
> 12. DQBUF(CAPTURE) -> got decoded video data in buffer #j
> 13. display buffer #j
> 14. QBUF(CAPTURE, #j)
> 15. goto 12
> 
> parser thread:
> 16. put next ES frame to buffer #i
> 17. QBUF(OUTPUT, #i)
> 18. DQBUF(OUTPUT) -> get next empty buffer #i 19. goto 16
> 
> ...
> 
> Similar usage sequence can be achieved with single threaded application
> and non-blocking api with poll() call.
> 
> Branch with MFC, CMA and videobuf2 will be soon available at
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc
> This tree is based on 2.6.37 rc4.
> 
> Please have a look at the code and the idea of how to introduce codec
> devices to V4L2. Comments will be very much appreciated.
> 
> Patch summary:
> 
> 
> 
> Subject: [PATCH 0/4] *** SUBJECT HERE ***
> 
> *** BLURB HERE ***
> 
> Kamil Debski (4):
>   Changes in include/linux/videodev2.h for MFC
>   MFC: Add MFC 5.1 driver to plat-s5p and mach-s5pv210
>   MFC: Add MFC 5.1 V4L2 driver
>   s5pv210: Enable MFC on Goni
> 
>  arch/arm/mach-s5pv210/Kconfig                   |    1 +
>  arch/arm/mach-s5pv210/clock.c                   |    6 +
>  arch/arm/mach-s5pv210/include/mach/map.h        |    4 +
>  arch/arm/mach-s5pv210/mach-goni.c               |    3 +-
>  arch/arm/plat-s5p/Kconfig                       |    5 +
>  arch/arm/plat-s5p/Makefile                      |    2 +-
>  arch/arm/plat-s5p/dev-mfc.c                     |   49 +
>  arch/arm/plat-samsung/include/plat/devs.h       |    2 +
>  drivers/media/video/Kconfig                     |    8 +
>  drivers/media/video/Makefile                    |    1 +
>  drivers/media/video/s5p-mfc/Makefile            |    3 +
>  drivers/media/video/s5p-mfc/regs-mfc5.h         |  335 ++++
>  drivers/media/video/s5p-mfc/s5p_mfc.c           | 2072 +++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h    |  224 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h     |  173 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_debug.h     |   47 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c      |   92 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.h      |   26 +
>  drivers/media/video/s5p-mfc/s5p_mfc_memory.h    |   43 +
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c       |  885 ++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h       |  160 ++
>  include/linux/videodev2.h                       |   45 +
>  25 files changed, 4233 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/plat-s5p/dev-mfc.c
>  create mode 100644 drivers/media/video/s5p-mfc/Makefile
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc5.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_memory.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
