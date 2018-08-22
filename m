Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48256 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbeHVUu6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 16:50:58 -0400
Message-ID: <828bf3b9f5f2edc2f05b7982ccc5d9777f1a19e3.camel@collabora.com>
Subject: Re: [PATCH v7 0/8] Cedrus driver for the Allwinner Video Engine,
 using media requests
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Wed, 22 Aug 2018 14:25:00 -0300
In-Reply-To: <20180809090435.17248-1-paul.kocialkowski@bootlin.com>
References: <20180809090435.17248-1-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Paul,

On Thu, 2018-08-09 at 11:04 +0200, Paul Kocialkowski wrote:
> This is the seventh iteration of the updated Cedrus driver,
> that supports the Video Engine found on most Allwinner SoCs, starting
> with the A10. It was tested on the A13, A20, A33 and H3.
> 
> The initial version of this driver[0] was originally written and
> submitted by Florent Revest using a previous version of the request API
> that is necessary to provide coherency between controls and the buffers
> they apply to.
> 
> The driver was adapted to use the latest version of the media request
> API[1], as submitted by Hans Verkuil. Media request API support is a
> hard requirement for the Cedrus driver.
> 
> The driver itself currently only supports MPEG2 and more codecs will be
> added eventually. The default output frame format provided by the Video
> Engine is a multi-planar tiled YUV format (based on NV12). A specific
> format is introduced in the V4L2 API to describe it. Starting with the
> A33, the Video Engine can also output untiled YUV formats.
> 
> This implementation is based on the significant work that was conducted
> by various members of the linux-sunxi community for understanding and
> documenting the Video Engine's innards.
> 
> In addition to the media requests API, the following series are required
> for Cedrus:
> * vicodec: the Virtual Codec driver
> * allwinner: a64: add SRAM controller / system control
> * SRAM patches from the Cedrus VPU driver series version 5
> 
> Changes since v6:
> * Reworked MPEG2 controls to stick closer to the bitstream;
> * Updated controls documentation accordingly and added requested fixes;
> * Renamed tiled format to V4L2_PIX_FMT_SUNXI_TILED_NV12;
> * Added various minor driver fixes based on Hans' feedback;
> * Fixed dst frame alignment based on Jernej's feedback and tests;
> * Removed set bits for the disabled secondary output.
> 
> Changes since v5:
> * Added MPEG2 quantization matrices definitions and support;
> * Cleaned up registers definitions;
> * Moved the driver to staging as requested;
> 

I tried to find the reason for moving this driver to staging,
but couldn't find it in the discussion.

If there's a legitimate reason, shouldn't you add a TODO file?

Thanks,
Eze
