Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:60179 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbaGQMoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 08:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <1405447012-5340-1-git-send-email-balbi@ti.com>
References: <1405447012-5340-1-git-send-email-balbi@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 17 Jul 2014 13:43:32 +0100
Message-ID: <CA+V-a8sZF-M1Me0ZpVAkCGChQYYNcCopdW50fLZwPQ1uCLgx4Q@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/5] Add Video Processing Front End Support
To: Felipe Balbi <balbi@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Tony Lindgren <tony@atomide.com>,
	Benoit Cousson <bcousson@baylibre.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel Mailing List
	<linux-arm-kernel@lists.infradead.org>,
	linux-media <linux-media@vger.kernel.org>, archit@ti.com,
	"Etheridge, Darren" <detheridge@ti.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 15, 2014 at 6:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi all,
>
> the following patches add suport for AM43xx's Video Processing
> Front End (VPFE). Full documentation is available at [1] chapter 14.
>
> This driver has been tested with linux-next from yesterday, plus my
> (already queued) am437x starter kit patches, plus these patches, plus
> the sensor driver which, saddly enough, we're not allowed to release :-(
>
> This driver has almost full v4l2-compliance with only 2 failures (I'll
> take hints on how to properly fix them) as below:
>
>                 fail: v4l2-compliance.cpp(419): !doioctl(node2,
>                         VIDIOC_S_PRIORITY, &prio)
>         test VIDIOC_G/S_PRIORITY: FAIL
>
>                 fail: v4l2-test-formats.cpp(319): pixelformat !=
>                                 V4L2_PIX_FMT_JPEG && colorspace ==
>                                 V4L2_COLORSPACE_JPEG
>                 fail: v4l2-test-formats.cpp(418):
>                                 testColorspace(pix.pixelformat, pix.colorspace)
>         test VIDIOC_G_FMT: FAIL
>
> I have also tested with gst-launch using fbdevsink and I can see my
> ugly mug just fine.
>
> Please give this a thorough review and let me know of any problems
> which need to be sorted out and I'll try to help out as time allows.
>
> cheers
>
> [1] http://www.ti.com/lit/pdf/spruhl7
>
> Benoit Parrot (4):
>   Media: platform: Add ti-vpfe driver for AM437x device
>   arm: omap: hwmod: add hwmod entries for AM437x VPFE
>   arm: boot: dts: am4372: add vpfe DTS entries
>   arm: dts: am43x-epos: Add VPFE DTS entries
>
> Darren Etheridge (1):
>   ARM: dts: am437x-sk-evm: add vpfe support and ov2659 sensor
>
>  arch/arm/boot/dts/am4372.dtsi                     |   16 +
>  arch/arm/boot/dts/am437x-sk-evm.dts               |   63 +
>  arch/arm/boot/dts/am43x-epos-evm.dts              |   54 +
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c        |   56 +
>  arch/arm/mach-omap2/prcm43xx.h                    |    3 +-
>  drivers/media/platform/Kconfig                    |    1 +
>  drivers/media/platform/Makefile                   |    2 +
>  drivers/media/platform/ti-vpfe/Kconfig            |   12 +
>  drivers/media/platform/ti-vpfe/Makefile           |    2 +
>  drivers/media/platform/ti-vpfe/am437x_isif.c      | 1053 +++++++++
>  drivers/media/platform/ti-vpfe/am437x_isif.h      |  355 +++
>  drivers/media/platform/ti-vpfe/am437x_isif_regs.h |  144 ++
>  drivers/media/platform/ti-vpfe/vpfe_capture.c     | 2478 +++++++++++++++++++++
>  drivers/media/platform/ti-vpfe/vpfe_capture.h     |  263 +++
>  14 files changed, 4501 insertions(+), 1 deletion(-)

Missing documentation for DT ?

Thanks,
--Prabhakar Lad

>  create mode 100644 drivers/media/platform/ti-vpfe/Kconfig
>  create mode 100644 drivers/media/platform/ti-vpfe/Makefile
>  create mode 100644 drivers/media/platform/ti-vpfe/am437x_isif.c
>  create mode 100644 drivers/media/platform/ti-vpfe/am437x_isif.h
>  create mode 100644 drivers/media/platform/ti-vpfe/am437x_isif_regs.h
>  create mode 100644 drivers/media/platform/ti-vpfe/vpfe_capture.c
>  create mode 100644 drivers/media/platform/ti-vpfe/vpfe_capture.h
>
> --
> 2.0.0.390.gcb682f8
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
