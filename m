Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60906 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdHRJQu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 05:16:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rohit Athavale <rohit.athavale@xilinx.com>
Cc: linux-media@vger.kernel.org, hyun.kwon@xilinx.com,
        Rohit Athavale <rathaval@xilinx.com>
Subject: Re: [PATCH 1/3] uapi: media-bus-format: Add Xilinx specific YCbCr 4:2:0 media bus format
Date: Fri, 18 Aug 2017 12:17:16 +0300
Message-ID: <214739951.lpc3CT9Zau@avalon>
In-Reply-To: <1502303274-40609-2-git-send-email-rathaval@xilinx.com>
References: <1502303274-40609-1-git-send-email-rathaval@xilinx.com> <1502303274-40609-2-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rohit,

Thank you for the patch.

On Wednesday 09 Aug 2017 11:27:52 Rohit Athavale wrote:
> This commit adds Xilinx Video IP specific 8-bit color depth YCbCr 4:2:0
> to the media bus format uapi.
> 
> Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
> ---
>  include/uapi/linux/media-bus-format.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/media-bus-format.h
> b/include/uapi/linux/media-bus-format.h index ef6fb30..6f65607 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -143,10 +143,12 @@
>  /* JPEG compressed formats - next is	0x4002 */
>  #define MEDIA_BUS_FMT_JPEG_1X8			0x4001
> 
> -/* Vendor specific formats - next is	0x5002 */
> +/* Vendor specific formats - next is	0x5003 */
> 
>  /* S5C73M3 sensor specific interleaved UYVY and JPEG */
>  #define MEDIA_BUS_FMT_S5C_UYVY_JPEG_1X8		0x5001
> +/* Xilinx IP Specific 8-bit YCbCr 4:2:0 */
> +#define MEDIA_BUS_FMT_XLNX8_VUY420_1X24		0x5002

Is this really a Xilinx-specific format ? I think it would make sense to 
define it as a standard YUV format.

>  /* HSV - next is	0x6002 */
>  #define MEDIA_BUS_FMT_AHSV8888_1X32		0x6001

-- 
Regards,

Laurent Pinchart
