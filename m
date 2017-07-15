Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34566 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdGOQtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 12:49:16 -0400
Received: by mail-io0-f179.google.com with SMTP id r36so27247141ioi.1
        for <linux-media@vger.kernel.org>; Sat, 15 Jul 2017 09:49:16 -0700 (PDT)
Message-ID: <1500137353.2353.1.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
From: Personnel <nicolas@ndufresne.ca>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org
Date: Sat, 15 Jul 2017 12:49:13 -0400
In-Reply-To: <2363665.x6z9MR1vqI@avalon>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
         <1500101920-24039-3-git-send-email-jacob-chen@iotwrt.com>
         <2363665.x6z9MR1vqI@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le samedi 15 juillet 2017 à 12:42 +0300, Laurent Pinchart a écrit :
> Hi Jacob,
> 
> Thank you for the patch.
> 
> On Saturday 15 Jul 2017 14:58:36 Jacob Chen wrote:
> > Rockchip RGA is a separate 2D raster graphic acceleration unit. It
> > accelerates 2D graphics operations, such as point/line drawing, image
> > scaling, rotation, BitBLT, alpha blending and image blur/sharpness.
> > 
> > The drvier is mostly based on s5p-g2d v4l2 m2m driver.
> > And supports various operations from the rendering pipeline.
> >  - copy
> >  - fast solid color fill
> >  - rotation
> >  - flip
> >  - alpha blending
> 
> I notice that you don't support the drawing operations. How do you plan to 
> support them later through the V4L2 M2M API ? I hate stating the obvious, but 
> wouldn't the DRM API be better fit for a graphic accelerator ?

It could fit, maybe, but it really lacks some framework. Also, DRM is
not really meant for M2M operation, and it's also not great for multi-
process. Until recently, there was competing drivers for Exynos, both
implemented in V4L2 and DRM, for similar rational, all DRM ones are
being deprecated/removed.

I think 2D blitters in V4L2 are fine, but they terribly lack something
to differentiate them from converters/scalers when looking up the HW
list. Could be as simple as a capability flag, if I can suggest. For
the reference, the 2D blitter on IMX6 has been used to implement a live
video mixer in GStreamer.

https://bugzilla.gnome.org/show_bug.cgi?id=772766

> 
> Additionally, V4L2 M2M has one source and one destination. How do you 
> implement alpha blending in that case, which by definition requires at least 
> two sources ?

This type of HW only do in-place blits. When using such a node, the
buffer queued on the V4L2_CAPTURE contains the destination image, and
the buffer queued on the V4L2_OUTPUT is the source image.

> 
> > The code in rga-hw.c is used to configure regs accroding to operations.
> > 
> > The code in rga-buf.c is used to create private mmu table for RGA.
> > The tables is stored in a list, and be removed when buffer is cleanup.
> 
> Looking at the implementation it seems to be a scatter-gather list, not an 
> MMU. Is that right ? Does the hardware documentation refer to it as an MMU ?
> 
> > Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> > ---
> >  drivers/media/platform/Kconfig                |  11 +
> >  drivers/media/platform/Makefile               |   2 +
> >  drivers/media/platform/rockchip-rga/Makefile  |   3 +
> >  drivers/media/platform/rockchip-rga/rga-buf.c | 122 ++++
> >  drivers/media/platform/rockchip-rga/rga-hw.c  | 652 ++++++++++++++++++
> >  drivers/media/platform/rockchip-rga/rga-hw.h  | 437 ++++++++++++
> >  drivers/media/platform/rockchip-rga/rga.c     | 958 +++++++++++++++++++++++
> >  drivers/media/platform/rockchip-rga/rga.h     | 111 +++
> >  8 files changed, 2296 insertions(+)
> >  create mode 100644 drivers/media/platform/rockchip-rga/Makefile
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga-buf.c
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.c
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga-hw.h
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga.c
> >  create mode 100644 drivers/media/platform/rockchip-rga/rga.h
> 
> 
