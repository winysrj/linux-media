Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46903 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2IYLgb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:36:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v2 0/5] s5p-fimc: Add interleaved image data capture support
Date: Tue, 25 Sep 2012 13:37:06 +0200
Message-ID: <2532715.t0qPncDtcZ@avalon>
In-Reply-To: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Monday 24 September 2012 16:55:41 Sylwester Nawrocki wrote:
> Hi All,
> 
> This patch series adds device/vendor specific media bus pixel code section
> and defines S5C73MX camera specific media bus pixel code, along with
> corresponding fourcc. I realize this isn't probably the best possible
> solution but I don't know how to better handle this without major changes
> in V4L2 API.

Well, given that the format is highly specific to your hardware, I don't think 
it's such a bad solution. It actually looks OK to me.

> The third patch adds support for MIPI-CSI2 Embedded Data capture in
> Samsung S5P/Exynos MIPI-CSIS device. It depends on patch
> "[PATCH RFC] V4L: Add s_rx_buffer subdev video operation".
> 
> The fourth patch extends s5p-fimc driver to allow it to support
> 2-planar V4L2_PIX_FMT_S5C_UYVY_JPG format. More details can be found
> in the patch summary. The [get/set]_frame_desc subdev callback are
> used only to retrive from a sensor subdev required buffer size.
> It depends on patch
> "[PATCH RFC] V4L: Add get/set_frame_desc subdev callbacks"
> 
> The fifth patch adds [get/set]_frame_desc op handlers to the m5mols
> driver as an example. I prepared also similar patch for S5C73M3
> sensor where 2 frame description entries are used, but that driver
> is not yet mainlined due to a few missing items in V4L2 required
> to fully control it, so I didn't include that patch in this series.
> 
> Comments, suggestions welcome.
> 
> Thanks,
> Sylwester
> 
> Sylwester Nawrocki (5):
>   V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus format
>   V4L: Add V4L2_PIX_FMT_S5C_UYVY_JPG fourcc definition
>   s5p-csis: Add support for non-image data packets capture
>   s5p-fimc: Add support for V4L2_PIX_FMT_S5C_UYVY_JPG fourcc
>   m5mols: Implement .get_frame_desc subdev callback
> 
>  Documentation/DocBook/media/v4l/compat.xml         |   4 +
>  Documentation/DocBook/media/v4l/pixfmt.xml         |   9 ++
>  Documentation/DocBook/media/v4l/subdev-formats.xml |  45 ++++++++
>  drivers/media/i2c/m5mols/m5mols.h                  |   9 ++
>  drivers/media/i2c/m5mols/m5mols_capture.c          |   3 +
>  drivers/media/i2c/m5mols/m5mols_core.c             |  47 ++++++++
>  drivers/media/i2c/m5mols/m5mols_reg.h              |   1 +
>  drivers/media/platform/s5p-fimc/fimc-capture.c     | 128 +++++++++++++++---
>  drivers/media/platform/s5p-fimc/fimc-core.c        |  19 ++-
>  drivers/media/platform/s5p-fimc/fimc-core.h        |  28 ++++-
>  drivers/media/platform/s5p-fimc/fimc-reg.c         |  23 +++-
>  drivers/media/platform/s5p-fimc/fimc-reg.h         |   3 +-
>  drivers/media/platform/s5p-fimc/mipi-csis.c        |  59 +++++++++-
>  include/linux/v4l2-mediabus.h                      |   5 +
>  include/linux/videodev2.h                          |   1 +
>  15 files changed, 351 insertions(+), 33 deletions(-)

-- 
Regards,

Laurent Pinchart

