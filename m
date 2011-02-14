Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:19729 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1BNMzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:55:53 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v6 00/10] OMAP3 ISP driver
Date: Mon, 14 Feb 2011 13:56:19 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141356.19903.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch series is

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

On Monday, February 14, 2011 13:21:27 Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's the sixth version of the OMAP3 ISP driver patches, updated to
> 2.6.38-rc4 and the latest changes in the media controller and sub-device 
APIs.
> 
> You can find the patches in http://git.linuxtv.org/pinchartl/media.git as
> usual (media-0005-omap3isp).
> 
> David Cohen (1):
>   omap3isp: Statistics
> 
> Laurent Pinchart (5):
>   omap3: Add function to register omap3isp platform device structure
>   omap3isp: Video devices and buffers queue
>   omap3isp: CCP2/CSI2 receivers
>   omap3isp: CCDC, preview engine and resizer
>   omap3isp: Kconfig and Makefile
> 
> Sakari Ailus (1):
>   omap3isp: OMAP3 ISP core
> 
> Sergio Aguirre (2):
>   omap3: Remove unusued ISP CBUFF resource
>   omap2: Fix camera resources for multiomap
> 
> Tuukka Toivonen (1):
>   ARM: OMAP3: Update Camera ISP definitions for OMAP3630
> 
>  arch/arm/mach-omap2/devices.c                      |   64 +-
>  arch/arm/mach-omap2/devices.h                      |   17 +
>  arch/arm/plat-omap/include/plat/omap34xx.h         |   16 +-
>  drivers/media/video/Kconfig                        |   13 +
>  drivers/media/video/Makefile                       |    2 +
>  drivers/media/video/omap3-isp/Makefile             |   13 +
>  drivers/media/video/omap3-isp/cfa_coef_table.h     |   61 +
>  drivers/media/video/omap3-isp/gamma_table.h        |   90 +
>  drivers/media/video/omap3-isp/isp.c                | 2220 
+++++++++++++++++++
>  drivers/media/video/omap3-isp/isp.h                |  427 ++++
>  drivers/media/video/omap3-isp/ispccdc.c            | 2268 
++++++++++++++++++++
>  drivers/media/video/omap3-isp/ispccdc.h            |  219 ++
>  drivers/media/video/omap3-isp/ispccp2.c            | 1173 ++++++++++
>  drivers/media/video/omap3-isp/ispccp2.h            |   98 +
>  drivers/media/video/omap3-isp/ispcsi2.c            | 1316 ++++++++++++
>  drivers/media/video/omap3-isp/ispcsi2.h            |  166 ++
>  drivers/media/video/omap3-isp/ispcsiphy.c          |  247 +++
>  drivers/media/video/omap3-isp/ispcsiphy.h          |   74 +
>  drivers/media/video/omap3-isp/isph3a.h             |  117 +
>  drivers/media/video/omap3-isp/isph3a_aewb.c        |  374 ++++
>  drivers/media/video/omap3-isp/isph3a_af.c          |  429 ++++
>  drivers/media/video/omap3-isp/isphist.c            |  520 +++++
>  drivers/media/video/omap3-isp/isphist.h            |   40 +
>  drivers/media/video/omap3-isp/isppreview.c         | 2113 
++++++++++++++++++
>  drivers/media/video/omap3-isp/isppreview.h         |  214 ++
>  drivers/media/video/omap3-isp/ispqueue.c           | 1153 ++++++++++
>  drivers/media/video/omap3-isp/ispqueue.h           |  187 ++
>  drivers/media/video/omap3-isp/ispreg.h             | 1589 ++++++++++++++
>  drivers/media/video/omap3-isp/ispresizer.c         | 1693 +++++++++++++++
>  drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
>  drivers/media/video/omap3-isp/ispstat.c            | 1092 ++++++++++
>  drivers/media/video/omap3-isp/ispstat.h            |  169 ++
>  drivers/media/video/omap3-isp/ispvideo.c           | 1264 +++++++++++
>  drivers/media/video/omap3-isp/ispvideo.h           |  202 ++
>  drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
>  drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
>  include/linux/Kbuild                               |    1 +
>  include/linux/omap3isp.h                           |  646 ++++++
>  38 files changed, 20478 insertions(+), 28 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/devices.h
>  create mode 100644 drivers/media/video/omap3-isp/Makefile
>  create mode 100644 drivers/media/video/omap3-isp/cfa_coef_table.h
>  create mode 100644 drivers/media/video/omap3-isp/gamma_table.h
>  create mode 100644 drivers/media/video/omap3-isp/isp.c
>  create mode 100644 drivers/media/video/omap3-isp/isp.h
>  create mode 100644 drivers/media/video/omap3-isp/ispccdc.c
>  create mode 100644 drivers/media/video/omap3-isp/ispccdc.h
>  create mode 100644 drivers/media/video/omap3-isp/ispccp2.c
>  create mode 100644 drivers/media/video/omap3-isp/ispccp2.h
>  create mode 100644 drivers/media/video/omap3-isp/ispcsi2.c
>  create mode 100644 drivers/media/video/omap3-isp/ispcsi2.h
>  create mode 100644 drivers/media/video/omap3-isp/ispcsiphy.c
>  create mode 100644 drivers/media/video/omap3-isp/ispcsiphy.h
>  create mode 100644 drivers/media/video/omap3-isp/isph3a.h
>  create mode 100644 drivers/media/video/omap3-isp/isph3a_aewb.c
>  create mode 100644 drivers/media/video/omap3-isp/isph3a_af.c
>  create mode 100644 drivers/media/video/omap3-isp/isphist.c
>  create mode 100644 drivers/media/video/omap3-isp/isphist.h
>  create mode 100644 drivers/media/video/omap3-isp/isppreview.c
>  create mode 100644 drivers/media/video/omap3-isp/isppreview.h
>  create mode 100644 drivers/media/video/omap3-isp/ispqueue.c
>  create mode 100644 drivers/media/video/omap3-isp/ispqueue.h
>  create mode 100644 drivers/media/video/omap3-isp/ispreg.h
>  create mode 100644 drivers/media/video/omap3-isp/ispresizer.c
>  create mode 100644 drivers/media/video/omap3-isp/ispresizer.h
>  create mode 100644 drivers/media/video/omap3-isp/ispstat.c
>  create mode 100644 drivers/media/video/omap3-isp/ispstat.h
>  create mode 100644 drivers/media/video/omap3-isp/ispvideo.c
>  create mode 100644 drivers/media/video/omap3-isp/ispvideo.h
>  create mode 100644 drivers/media/video/omap3-isp/luma_enhance_table.h
>  create mode 100644 drivers/media/video/omap3-isp/noise_filter_table.h
>  create mode 100644 include/linux/omap3isp.h
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
