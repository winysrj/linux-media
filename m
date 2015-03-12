Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:34817 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbbCLKEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 06:04:35 -0400
Message-ID: <55016470.8000000@cisco.com>
Date: Thu, 12 Mar 2015 11:03:28 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Emil Renner Berthing <kernel@esmil.dk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v3 00/10] Use media bus formats in imx-drm and add drm
 panel support
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 03/12/15 10:58, Philipp Zabel wrote:
> Currently the imx-drm driver misuses the V4L2_PIX_FMT constants to describe the
> pixel format on the parallel bus between display controllers and encoders. Now
> that MEDIA_BUS_FMT is available, use that instead.
> 
> I'd like to get the V4L2 maintainers' acks for the four necessary media
> bus format patches to be merged through the drm tree, if that still is the
> preferred way for the media format patches to go in together with the driver
> changes using them.

Yes, that's the preferred way.

For patches 1-5:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> The two drm/imx core patches replace V4L2_PIX_FMT with MEDIA_BUS_FMT where
> appropriate and consolidate the variable names for clarification.
> 
> The three LDB patches depend on the of-graph helper series:
>     http://permalink.gmane.org/gmane.linux.kernel/1898485
> They allow to optionally use LVDS panels with drm_panel drivers, connected to
> the LDB encoder in the device tree via of-graph endpoint links.
> 
> Changes since v2:
>  - Added explanation for component-wise padded format names (CPADHI/LO)
>  - Improved documentation (wording, spelling and syntax fixes)
>  - Also rename pixel_fmt parameter to ipu_dc_init_sync to bus_format
> (- Added linux-media to Cc for the media format patches)
> 
> regards
> Philipp
> 
> Boris Brezillion (1):
>   Add RGB444_1X12 and RGB565_1X16 media bus formats
> 
> Philipp Zabel (9):
>   Add LVDS RGB media bus formats
>   Add BGR888_1X24 and GBR888_1X24 media bus formats
>   Add YUV8_1X24 media bus format
>   Add RGB666_1X24_CPADHI media bus format
>   drm/imx: switch to use media bus formats
>   drm/imx: consolidate bus format variable names
>   drm/imx: imx-ldb: add drm_panel support
>   drm/imx: imx-ldb: reset display clock input when disabling LVDS
>   drm/imx: imx-ldb: allow to determine bus format from the connected
>     panel
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 426 ++++++++++++++++++++-
>  Documentation/devicetree/bindings/drm/imx/ldb.txt  |  62 ++-
>  drivers/gpu/drm/imx/Kconfig                        |   1 +
>  drivers/gpu/drm/imx/dw_hdmi-imx.c                  |   2 +-
>  drivers/gpu/drm/imx/imx-drm-core.c                 |  14 +-
>  drivers/gpu/drm/imx/imx-drm.h                      |  10 +-
>  drivers/gpu/drm/imx/imx-ldb.c                      | 196 +++++++---
>  drivers/gpu/drm/imx/imx-tve.c                      |   6 +-
>  drivers/gpu/drm/imx/ipuv3-crtc.c                   |  13 +-
>  drivers/gpu/drm/imx/parallel-display.c             |  13 +-
>  drivers/gpu/ipu-v3/ipu-dc.c                        |  18 +-
>  include/uapi/linux/media-bus-format.h              |  13 +-
>  include/video/imx-ipu-v3.h                         |   2 +-
>  13 files changed, 655 insertions(+), 121 deletions(-)
> 
