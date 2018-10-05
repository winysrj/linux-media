Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52015 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbeJERvD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 13:51:03 -0400
Message-ID: <1538736767.3545.20.camel@pengutronix.de>
Subject: Re: [PATCH v4 11/11] media: imx.rst: Update doc to reflect fixes to
 interlaced capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 05 Oct 2018 12:52:47 +0200
In-Reply-To: <20181004185401.15751-12-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
         <20181004185401.15751-12-slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-10-04 at 11:54 -0700, Steve Longerbeam wrote:
> Also add an example pipeline for unconverted capture with interweave
> on SabreAuto.
> 
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
> Changes since v3:
> - none.
> Changes since v2:
> - expand on idmac interweave behavior in CSI subdev.
> - switch second SabreAuto pipeline example to PAL to give
>   both NTSC and PAL examples.
> - Cleanup some language in various places.
> ---
>  Documentation/media/v4l-drivers/imx.rst | 93 ++++++++++++++++---------
>  1 file changed, 60 insertions(+), 33 deletions(-)
> 
> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
> index 65d3d15eb159..1f6279d418ed 100644
> --- a/Documentation/media/v4l-drivers/imx.rst
> +++ b/Documentation/media/v4l-drivers/imx.rst
> @@ -22,8 +22,8 @@ memory. Various dedicated DMA channels exist for both video capture and
>  display paths. During transfer, the IDMAC is also capable of vertical
>  image flip, 8x8 block transfer (see IRT description), pixel component
>  re-ordering (for example UYVY to YUYV) within the same colorspace, and
> -even packed <--> planar conversion. It can also perform a simple
> -de-interlacing by interleaving even and odd lines during transfer
> +packed <--> planar conversion. The IDMAC can also perform a simple
> +de-interlacing by interweaving even and odd lines during transfer
>  (without motion compensation which requires the VDIC).
>  
>  The CSI is the backend capture unit that interfaces directly with
> @@ -173,15 +173,19 @@ via the SMFC and an IDMAC channel, bypassing IC pre-processing. This
>  source pad is routed to a capture device node, with a node name of the
>  format "ipuX_csiY capture".
>  
> -Note that since the IDMAC source pad makes use of an IDMAC channel, it
> -can do pixel reordering within the same colorspace. For example, the
> +Note that since the IDMAC source pad makes use of an IDMAC channel, the
> +CSI can do pixel reordering within the same colorspace. For example, the

This change is unrelated to interlacing, and sounds like the CSI
hardware does pixel reordering, which only partially correct.
The CSI either passes through its input unchanged, or turns any known
input format into either 32-bit ARGB or AYUV.

>  sink pad can take UYVY2X8, but the IDMAC source pad can output YUYV2X8.
>  If the sink pad is receiving YUV, the output at the capture device can
>  also be converted to a planar YUV format such as YUV420.
>  
> -It will also perform simple de-interlace without motion compensation,
> -which is activated if the sink pad's field type is an interlaced type,
> -and the IDMAC source pad field type is set to none.
> +The CSI will also perform simple interweave without motion compensation,

Again the CSI. It is the IDMAC that interweaves, not the CSI.

> +which is activated if the source pad's field type is sequential top-bottom
> +or bottom-top or alternate, and the capture interface field type is set
> +to interlaced (t-b, b-t, or unqualified interlaced). The capture interface
> +will enforce the same field order if the source pad field type is seq-bt
> +or seq-tb. However if the source pad's field type is alternate, any
> +interlaced type at the capture interface will be accepted.

This part is fine, though, as are the following changes. I'd just like
to avoid giving the wrong impression that the CSI does line interweaving
or pixel reordering into the output pixel format.

regards
Philipp
