Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35667 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932193AbeEHOZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 10:25:06 -0400
Message-ID: <1525789504.18091.9.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/2] media: imx: add capture support for RGB565_2X8
 on parallel bus
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com, kernel@pengutronix.de
Date: Tue, 08 May 2018 16:25:04 +0200
In-Reply-To: <20180508141411.26620-1-jlu@pengutronix.de>
References: <20180508141411.26620-1-jlu@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-05-08 at 16:14 +0200, Jan Luebbe wrote:
> The IPU can only capture RGB565 with two 8-bit cycles in bayer/generic
> mode on the parallel bus, compared to a specific mode on MIPI CSI-2.
> To handle this, we extend imx_media_pixfmt with a cycles per pixel
> field, which is used for generic formats on the parallel bus.
> 
> Before actually adding RGB565_2X8 support for the parallel bus, this
> series simplifies handing of the the different configurations for RGB565
> between parallel and MIPI CSI-2 in imx-media-capture. This avoids having
> to explicitly pass on the format in the second patch.
> 
> Changes since v1:
>   - fixed problems reported the kbuild test robot
>   - added helper functions as suggested by Steve Longerbeam
>     (is_parallel_bus and requires_passthrough)
>   - removed passthough format check in csi_link_validate() (suggested by
>     Philipp Zabel during internal review)

The theory is that IC only supports AYUV8_1X32 and RGB888_1X24 input,
and any passthrough format on the CSI sink will differ from those.
Mismatching formats are already caught by v4l2_subdev_link_validate
called on the ipu?_vdic or ipu?_ic_prp entities' sink pads.

regards
Philipp
