Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60899 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdHRJQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 05:16:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rohit Athavale <rohit.athavale@xilinx.com>
Cc: linux-media@vger.kernel.org, hyun.kwon@xilinx.com,
        Rohit Athavale <rathaval@xilinx.com>
Subject: Re: [PATCH 2/3] media: xilinx-vip: Add 8-bit YCbCr 4:2:0 to formats table
Date: Fri, 18 Aug 2017 12:16:44 +0300
Message-ID: <4081123.eIeaFnY7EH@avalon>
In-Reply-To: <1502303274-40609-3-git-send-email-rathaval@xilinx.com>
References: <1502303274-40609-1-git-send-email-rathaval@xilinx.com> <1502303274-40609-3-git-send-email-rathaval@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rohit,

Thank you for the patch.

On Wednesday 09 Aug 2017 11:27:53 Rohit Athavale wrote:
> Add Xilinx YCbCr 4:2:0 to xvip formats table. This commit
> will allow driver to setup media pad codes to YUV 420
> via DT properties.
> 
> Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
> ---
>  drivers/media/platform/xilinx/xilinx-vip.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.c
> b/drivers/media/platform/xilinx/xilinx-vip.c index 3112591..37b80bf 100644
> --- a/drivers/media/platform/xilinx/xilinx-vip.c
> +++ b/drivers/media/platform/xilinx/xilinx-vip.c
> @@ -15,6 +15,7 @@
>  #include <linux/clk.h>
>  #include <linux/export.h>
>  #include <linux/kernel.h>
> +#include <linux/media-bus-format.h>

I'm pretty sure the file is included indirectly already, so this isn't 
strictly needed, but it shouldn't hurt either.

>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> 
> @@ -27,6 +28,8 @@
>   */
> 
>  static const struct xvip_video_format xvip_video_formats[] = {
> +	{ XVIP_VF_YUV_420, 8, NULL, MEDIA_BUS_FMT_XLNX8_VUY420_1X24,
> +	  2, V4L2_PIX_FMT_NV12, "4:2:0, semi-planar, YUYV" },

You're mapping XVIP_VF_YUV_420 to V4L2_PIX_FMT_NV12 which has an average bpp 
of 1.5 bytes per pixel, but you're setting bpp to 2. How does that work ? You 
obviously can't express a 1.5 bpp currently in the driver, so we might need to 
extend the xvip_video_format structure with additional fields (for instance 
turning bytes per pixel into bits per pixel, but we might need per-plane 
information too).

On a side note, how does this work with VDMA ? The latest VDMA version I 
checked (v6.2, a while ago) didn't seem to support planar formats. Has it 
changed in more recent versions ? Doesn't it require changes in the xilinx-vip 
driver ?

>  	{ XVIP_VF_YUV_422, 8, NULL, MEDIA_BUS_FMT_UYVY8_1X16,
>  	  2, V4L2_PIX_FMT_YUYV, "4:2:2, packed, YUYV" },
>  	{ XVIP_VF_YUV_444, 8, NULL, MEDIA_BUS_FMT_VUY8_1X24,

-- 
Regards,

Laurent Pinchart
