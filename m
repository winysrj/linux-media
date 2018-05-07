Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40026 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751949AbeEGM7m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:59:42 -0400
Subject: Re: [PATCH v5 0/8] Add support for multi-planar formats and 10 bit
 formats
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        michal.simek@xilinx.com, hyun.kwon@xilinx.com
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <52e91f0d-e520-9de1-56f7-40cfb45dc7bc@xs4all.nl>
Date: Mon, 7 May 2018 14:59:39 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

On 03/05/18 04:42, Satish Kumar Nagireddy wrote:
>  The patches are for xilinx v4l. The patcheset enable support to handle multiplanar
>  formats and 10 bit formats. Single planar implementation is removed as mplane can
>  handle both.

If I understand the format correctly, then the planes are contiguous in memory,
i.e. it is a single buffer.

You do not need to switch to the _MPLANE API for that: that API is meant for the
case where the planes are not contiguous in memory but each plane has its own
buffer. And yes, we should have called it the _MBUFFER API or something :-(

https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-nv12.html

Switching to the _MPLANE API will actually break userspace, so that's another
reason why you shouldn't do this. But from what I can tell, it really isn't
needed at all.

Regards,

	Hans

> 
>  Patch-set has downstream changes and bug fixes. Added new media bus format
>  MEDIA_BUS_FMT_VYYUYY8_1X24, new pixel format V4L2_PIX_FMT_XV15 and rst
>  documentation.
> 
> Jeffrey Mouroux (1):
>   uapi: media: New fourcc code and rst for 10 bit format
> 
> Radhey Shyam Pandey (1):
>   v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format
> 
> Rohit Athavale (1):
>   xilinx: v4l: dma: Update driver to allow for probe defer
> 
> Satish Kumar Nagireddy (4):
>   media-bus: uapi: Add YCrCb 420 media bus format and rst
>   v4l: xilinx: dma: Update video format descriptor
>   v4l: xilinx: dma: Add multi-planar support
>   v4l: xilinx: dma: Add support for 10 bit formats
> 
> Vishal Sagar (1):
>   xilinx: v4l: dma: Terminate DMA when media pipeline fail to start
> 
>  Documentation/media/uapi/v4l/pixfmt-xv15.rst    | 134 +++++++++++++++++++
>  Documentation/media/uapi/v4l/subdev-formats.rst |  38 +++++-
>  Documentation/media/uapi/v4l/yuv-formats.rst    |   1 +
>  drivers/media/platform/xilinx/xilinx-dma.c      | 170 +++++++++++++++---------
>  drivers/media/platform/xilinx/xilinx-dma.h      |   4 +-
>  drivers/media/platform/xilinx/xilinx-vip.c      |  37 ++++--
>  drivers/media/platform/xilinx/xilinx-vip.h      |  15 ++-
>  drivers/media/platform/xilinx/xilinx-vipp.c     |  16 +--
>  include/uapi/linux/media-bus-format.h           |   3 +-
>  include/uapi/linux/videodev2.h                  |   1 +
>  10 files changed, 333 insertions(+), 86 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv15.rst
> 
