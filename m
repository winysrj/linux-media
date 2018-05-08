Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0056.outbound.protection.outlook.com ([104.47.32.56]:8154
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751533AbeEHVTN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:19:13 -0400
Date: Tue, 8 May 2018 14:18:42 -0700
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>
Subject: Re: [PATCH v5 0/8] Add support for multi-planar formats and 10 bit
 formats
Message-ID: <20180508211841.GA25777@smtp.xilinx.com>
References: <cover.1525312401.git.satish.nagireddy.nagireddy@xilinx.com>
 <52e91f0d-e520-9de1-56f7-40cfb45dc7bc@xs4all.nl>
 <20180507174504.GA23132@smtp.xilinx.com>
 <db6cc32b-1ac8-d8ca-b8cd-01cbd1ebbadd@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <db6cc32b-1ac8-d8ca-b8cd-01cbd1ebbadd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, 2018-05-08 at 00:57:25 -0700, Hans Verkuil wrote:
> On 05/07/2018 07:45 PM, Hyun Kwon wrote:
> > Hi Hans,
> > 
> > Thanks for the comment.
> > 
> > On Mon, 2018-05-07 at 05:59:39 -0700, Hans Verkuil wrote:
> >> Hi Satish,
> >>
> >> On 03/05/18 04:42, Satish Kumar Nagireddy wrote:
> >>>  The patches are for xilinx v4l. The patcheset enable support to handle multiplanar
> >>>  formats and 10 bit formats. Single planar implementation is removed as mplane can
> >>>  handle both.
> >>
> >> If I understand the format correctly, then the planes are contiguous in memory,
> >> i.e. it is a single buffer.
> >>
> >> You do not need to switch to the _MPLANE API for that: that API is meant for the
> >> case where the planes are not contiguous in memory but each plane has its own
> >> buffer. And yes, we should have called it the _MBUFFER API or something :-(
> >>
> >> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-nv12.html
> >>
> >> Switching to the _MPLANE API will actually break userspace, so that's another
> >> reason why you shouldn't do this. But from what I can tell, it really isn't
> >> needed at all.
> >>
> > 
> > Sharing some background to get your further input. :-)
> > 
> > The Xilinx V4L driver is currently only for the soft IPs, which are
> > programmable on FPGA, and those IPs are constantly updated. Initially, IPs
> > didn't support _MPLANE formats, so it started with single buffer type format.
> > Now, the IPs support _MPLANE formats, even though those formats are not part of
> > this patch. Those formats are in downstream vendor tree and will be upstreamed
> > at some point[1]. While implementing the multi-buffer formats, we had similar
> > concern regarding UAPI and ended up having the module param[2]. It was there
> > for a couple of Xilinx release cycles to migrate internal applications to
> > _MPLANE formats and to get report if that breaks any external applications. Now
> > we thought it's good time to hard-switch the driver to _MPLANE completely
> > rather than keeping single buffer code, especially because it seems legal to
> > support single buffer formats with _MPLANE type. If this is not the case and
> > the applications with single buffer formats but without mplane formats should
> > be supported, we can revive the single buffer code in one way or another.
> 
> In that case you need to split off the _MPLANE API change into a separate patch.
> Switching to the MPLANE API has nothing to do with supporting this format, it is
> done for a different reason (future support for real multiplane formats).
> 
> Since this also breaks userspace applications you will need to clearly state in
> the commit log why this is a reasonable thing to do.
> 

Sure. I agree, and we will re-organize patches.

Thanks,
-hyun

> Regards,
> 
> 	Hans
> 
> > 
> > Thanks,
> > -hyun
> > 
> > [1] https://github.com/Xilinx/linux-xlnx/blob/xilinx-v2018.1/drivers/media/platform/xilinx/xilinx-vip.c#L33
> > [2] https://github.com/Xilinx/linux-xlnx/blob/xilinx-v2018.1/drivers/media/platform/xilinx/xilinx-vipp.c#L40
> > 
> >> Regards,
> >>
> >> 	Hans
> >>
> >>>
> >>>  Patch-set has downstream changes and bug fixes. Added new media bus format
> >>>  MEDIA_BUS_FMT_VYYUYY8_1X24, new pixel format V4L2_PIX_FMT_XV15 and rst
> >>>  documentation.
> >>>
> >>> Jeffrey Mouroux (1):
> >>>   uapi: media: New fourcc code and rst for 10 bit format
> >>>
> >>> Radhey Shyam Pandey (1):
> >>>   v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format
> >>>
> >>> Rohit Athavale (1):
> >>>   xilinx: v4l: dma: Update driver to allow for probe defer
> >>>
> >>> Satish Kumar Nagireddy (4):
> >>>   media-bus: uapi: Add YCrCb 420 media bus format and rst
> >>>   v4l: xilinx: dma: Update video format descriptor
> >>>   v4l: xilinx: dma: Add multi-planar support
> >>>   v4l: xilinx: dma: Add support for 10 bit formats
> >>>
> >>> Vishal Sagar (1):
> >>>   xilinx: v4l: dma: Terminate DMA when media pipeline fail to start
> >>>
> >>>  Documentation/media/uapi/v4l/pixfmt-xv15.rst    | 134 +++++++++++++++++++
> >>>  Documentation/media/uapi/v4l/subdev-formats.rst |  38 +++++-
> >>>  Documentation/media/uapi/v4l/yuv-formats.rst    |   1 +
> >>>  drivers/media/platform/xilinx/xilinx-dma.c      | 170 +++++++++++++++---------
> >>>  drivers/media/platform/xilinx/xilinx-dma.h      |   4 +-
> >>>  drivers/media/platform/xilinx/xilinx-vip.c      |  37 ++++--
> >>>  drivers/media/platform/xilinx/xilinx-vip.h      |  15 ++-
> >>>  drivers/media/platform/xilinx/xilinx-vipp.c     |  16 +--
> >>>  include/uapi/linux/media-bus-format.h           |   3 +-
> >>>  include/uapi/linux/videodev2.h                  |   1 +
> >>>  10 files changed, 333 insertions(+), 86 deletions(-)
> >>>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-xv15.rst
> >>>
> >>
> 
