Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:51986 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440Ab0JFOOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 10:14:38 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 6 Oct 2010 19:44:33 +0530
Subject: RE: [PATCH v2 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build
 without VRFB
Message-ID: <19F8576C6E063C45BE387C64729E739404AA21CDF5@dbde02.ent.ti.com>
References: <1285571807-23210-1-git-send-email-archit@ti.com>
In-Reply-To: <1285571807-23210-1-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> -----Original Message-----
> From: Taneja, Archit
> Sent: Monday, September 27, 2010 12:47 PM
> To: Hiremath, Vaibhav
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org; Taneja,
> Archit
> Subject: [PATCH v2 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build
> without VRFB
> 
> This lets omap_vout driver build and run without VRFB. It works along the
> lines of the following patch series:
> 
> OMAP: DSS2: OMAPFB: Allow FB_OMAP2 to build without VRFB
> https://patchwork.kernel.org/patch/105371/
> 
> Since VRFB is tightly coupled with the omap_vout driver, a handful of vrfb
> specific functions have been defined and placed in omap_vout_vrfb.c
> 
> A variable rotation_type is introduced in omapvideo_info like the way in
> omapfb_info, this allows to call vrfb specific functions only if the
> rotation
> type is vrfb. When the rotation_type is set to SDMA, the S_CTRL ioctl
> prevents
> the user setting a non zero rotation value.
> 
[Hiremath, Vaibhav] Lets make one stand here,

I think this series still doesn't support DMA based rotation, unlike Fbdev driver so I would say lets clearly state that we are not supporting sDMA based rotation here. So I don't see any reason why we need 

> Archit Taneja (2):
>   V4L/DVB: OMAP_VOUT: Create a seperate vrfb functions library
>   V4L/DVB: OMAP_VOUT: Use rotation_type to choose between vrfb and
>     sdram buffers
> 
>  drivers/media/video/omap/Kconfig          |    1 -
>  drivers/media/video/omap/Makefile         |    1 +
>  drivers/media/video/omap/omap_vout.c      |  480 ++++++------------------
> -----
>  drivers/media/video/omap/omap_vout_vrfb.c |  417
> +++++++++++++++++++++++++
>  drivers/media/video/omap/omap_vout_vrfb.h |   40 +++
>  drivers/media/video/omap/omap_voutdef.h   |   26 ++
>  6 files changed, 571 insertions(+), 394 deletions(-)
>  create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
>  create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
> --
> Version 2:
>  - Don't try to enable SDRAM rotation , return an error if non zero
> rotation
>    is attempted when rotation_type is set to SDMA rotation.
> Version 1:
>    http://www.mail-archive.com/linux-media@vger.kernel.org/msg21937.html
