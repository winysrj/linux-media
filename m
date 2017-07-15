Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47932 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbdGOJmS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 05:42:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
Date: Sat, 15 Jul 2017 12:42:23 +0300
Message-ID: <2363665.x6z9MR1vqI@avalon>
In-Reply-To: <1500101920-24039-3-git-send-email-jacob-chen@iotwrt.com>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com> <1500101920-24039-3-git-send-email-jacob-chen@iotwrt.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

Thank you for the patch.

On Saturday 15 Jul 2017 14:58:36 Jacob Chen wrote:
> Rockchip RGA is a separate 2D raster graphic acceleration unit. It
> accelerates 2D graphics operations, such as point/line drawing, image
> scaling, rotation, BitBLT, alpha blending and image blur/sharpness.
> 
> The drvier is mostly based on s5p-g2d v4l2 m2m driver.
> And supports various operations from the rendering pipeline.
>  - copy
>  - fast solid color fill
>  - rotation
>  - flip
>  - alpha blending

I notice that you don't support the drawing operations. How do you plan to 
support them later through the V4L2 M2M API ? I hate stating the obvious, but 
wouldn't the DRM API be better fit for a graphic accelerator ?

Additionally, V4L2 M2M has one source and one destination. How do you 
implement alpha blending in that case, which by definition requires at least 
two sources ?

> The code in rga-hw.c is used to configure regs accroding to operations.
> 
> The code in rga-buf.c is used to create private mmu table for RGA.
> The tables is stored in a list, and be removed when buffer is cleanup.

Looking at the implementation it seems to be a scatter-gather list, not an 
MMU. Is that right ? Does the hardware documentation refer to it as an MMU ?

> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> ---
>  drivers/media/platform/Kconfig                |  11 +
>  drivers/media/platform/Makefile               |   2 +
>  drivers/media/platform/rockchip-rga/Makefile  |   3 +
>  drivers/media/platform/rockchip-rga/rga-buf.c | 122 ++++
>  drivers/media/platform/rockchip-rga/rga-hw.c  | 652 ++++++++++++++++++
>  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
>  drivers/media/platform/rockchip-rga/rga.c     | 958 +++++++++++++++++++++++
>  drivers/media/platform/rockchip-rga/rga.h     | 111 +++
>  8 files changed, 2296 insertions(+)
>  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
>  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
>  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
>  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
>  create mode 100644 drivers/media/platform/rockchip-rga/rga.h

-- 
Regards,

Laurent Pinchart
