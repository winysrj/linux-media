Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60924 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdHRJRh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 05:17:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rohit Athavale <rohit.athavale@xilinx.com>
Cc: linux-media@vger.kernel.org, hyun.kwon@xilinx.com,
        Rohit Athavale <rathaval@xilinx.com>
Subject: Re: [PATCH 3/3] Documentation: subdev-formats: Add Xilinx YCbCr to Vendor specific area
Date: Fri, 18 Aug 2017 12:18:03 +0300
Message-ID: <5444997.CSWZR4Ez4Z@avalon>
In-Reply-To: <1502303274-40609-4-git-send-email-rathaval@xilinx.com>
References: <1502303274-40609-1-git-send-email-rathaval@xilinx.com> <1502303274-40609-4-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rohit,

Thank you for the patch.

On Wednesday 09 Aug 2017 11:27:54 Rohit Athavale wrote:
> This commit adds the custom Xilinx IP specific 8-bit YCbCr 4:2:0
> to the custom formats area in the subdev-formats documentation.
> 
> Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst
> b/Documentation/media/uapi/v4l/subdev-formats.rst index 8e73bb0..141a837
> 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -7483,3 +7483,8 @@ formats.
>        - 0x5001
>        - Interleaved raw UYVY and JPEG image format with embedded meta-data
>  	used by Samsung S3C73MX camera sensors.
> +    * .. _MEDIA_BUS_FMT_XLNX8_VUY420_1X24:
> +
> +      - MEDIA_BUS_FMT_XLNX8_VUY420_1X24
> +      - 0x5002
> +      - Xilinx IP specific 8-bit color depth YCbCr 4:2:0 used by Xilinx
> Video IP.

You need to document this format in more details, with a table explaining how 
bits are transferred on the bus, the same way the standard YUV formats are 
documented.

-- 
Regards,

Laurent Pinchart
