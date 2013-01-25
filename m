Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46032 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AYM2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 07:28:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com, pawel@osciak.com
Subject: Re: [PATCH 0/2 v3] Add proper timestamp types handling in videobuf2
Date: Fri, 25 Jan 2013 13:28:08 +0100
Message-ID: <2638149.FJjr4FCfB8@avalon>
In-Reply-To: <1359109797-12698-1-git-send-email-k.debski@samsung.com>
References: <1359109797-12698-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Thanks for the patches.

On Friday 25 January 2013 11:29:55 Kamil Debski wrote:
> Hi,
> 
> This is the third version of the patch posted earlier this month.
> After the discussion a WARN_ON was added to inform if the driver is not
> setting timestamp type when initialising the videobuf2 queue. Small
> correction to the documentation was also made and two patche were squashed
> to avoid problems with bisect.
> 
> Also the davinci/vpbe_display.c driver was modified to correctly report the
> use of MONOTONIC timestamp type.

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Best wishes,
> Kamil Debski
> 
> PS. Below please find the original cover letter.
> 
> Hi,
> 
> The recent addition of timestamp types (and monotonic timestamp) left some
> room for improvement. First of all not all drivers use monotonic timestamp.
> There are for example mem2mem drivers that copy the timestamp from the
> OUTPUT buffer to the corresponding CAPTURE buffer. Some videobuf2 drivers
> do not fill the timestamp field altogether (yeah, I can agree that a
> constant is monotonic, but still...).
> 
> Hence, I propose the following change to videobuf2. After applying this
> patch the default timestamp type is UNKNOWN. It is up to the driver to set
> the timestamp type to either MONOTONIC or COPY in vb2_queue_init.
> 
> This patch also adds setting proper timestamp type value in case of drivers
> where I determined that type. This list might be missing some drivers, but
> in these cases it will leave the UNKNOWN type which is a safe assumption.
> 
> Best wishes,
> Kamil Debski
> 
> 
> 
> Kamil Debski (2):
>   v4l: Define video buffer flag for the COPY timestamp type
>   vb2: Add support for non monotonic timestamps
> 
>  Documentation/DocBook/media/v4l/io.xml             |    6 ++++++
>  drivers/media/platform/blackfin/bfin_capture.c     |    1 +
>  drivers/media/platform/davinci/vpbe_display.c      |    1 +
>  drivers/media/platform/davinci/vpif_capture.c      |    1 +
>  drivers/media/platform/davinci/vpif_display.c      |    1 +
>  drivers/media/platform/s3c-camif/camif-capture.c   |    1 +
>  drivers/media/platform/s5p-fimc/fimc-capture.c     |    1 +
>  drivers/media/platform/s5p-fimc/fimc-lite.c        |    1 +
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 ++
>  drivers/media/platform/soc_camera/atmel-isi.c      |    1 +
>  drivers/media/platform/soc_camera/mx2_camera.c     |    1 +
>  drivers/media/platform/soc_camera/mx3_camera.c     |    1 +
>  .../platform/soc_camera/sh_mobile_ceu_camera.c     |    1 +
>  drivers/media/platform/vivi.c                      |    1 +
>  drivers/media/usb/pwc/pwc-if.c                     |    1 +
>  drivers/media/usb/stk1160/stk1160-v4l.c            |    1 +
>  drivers/media/usb/uvc/uvc_queue.c                  |    1 +
>  drivers/media/v4l2-core/videobuf2-core.c           |    8 ++++++--
>  include/media/videobuf2-core.h                     |    1 +
>  include/uapi/linux/videodev2.h                     |    1 +
>  20 files changed, 31 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

