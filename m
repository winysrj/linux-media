Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46454 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbCXJkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 05:40:21 -0400
Message-ID: <1427190009.3180.9.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/10] Use media bus formats in imx-drm and add drm
 panel support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Emil Renner Berthing <kernel@esmil.dk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Tue, 24 Mar 2015 10:40:09 +0100
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Donnerstag, den 12.03.2015, 10:58 +0100 schrieb Philipp Zabel:
> Currently the imx-drm driver misuses the V4L2_PIX_FMT constants to describe the
> pixel format on the parallel bus between display controllers and encoders. Now
> that MEDIA_BUS_FMT is available, use that instead.
> 
> I'd like to get the V4L2 maintainers' acks for the four necessary media
> bus format patches to be merged through the drm tree, if that still is the
> preferred way for the media format patches to go in together with the driver
> changes using them.
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

I'd like to send a pull request for these if you could give your ack for
the first five patches above.

regards
Philipp

