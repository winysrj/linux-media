Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51402 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754013AbdJIMsQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 08:48:16 -0400
Subject: Re: [PATCH v11 1/4] rockchip/rga: v4l2 m2m support
To: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org
References: <20171009090424.15292-1-jacob-chen@iotwrt.com>
 <20171009090424.15292-2-jacob-chen@iotwrt.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <39318451-a078-3451-47f8-9205a31cadb5@xs4all.nl>
Date: Mon, 9 Oct 2017 14:48:13 +0200
MIME-Version: 1.0
In-Reply-To: <20171009090424.15292-2-jacob-chen@iotwrt.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 11:04, Jacob Chen wrote:
> Rockchip RGA is a separate 2D raster graphic acceleration unit. It
> accelerates 2D graphics operations, such as point/line drawing, image
> scaling, rotation, BitBLT, alpha blending and image blur/sharpness
> 
> The driver supports various operations from the rendering pipeline.
>  - copy
>  - fast solid color fill
>  - rotation
>  - flip
>  - alpha blending
> 
> The code in rga-hw.c is used to configure regs according to operations
> The code in rga-buf.c is used to create private mmu table for RGA.
> 
> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>

I ran checkpatch --strict on this patch and I found a few small issues:

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#1222: FILE: drivers/media/platform/rockchip/rga/rga.c:89:
+               BUG_ON(!ctx);

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#1229: FILE: drivers/media/platform/rockchip/rga/rga.c:96:
+               BUG_ON(!src);

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#1230: FILE: drivers/media/platform/rockchip/rga/rga.c:97:
+               BUG_ON(!dst);

I think you can use WARN_ON here and just return.

CHECK: struct mutex definition without comment
#2235: FILE: drivers/media/platform/rockchip/rga/rga.h:84:
+       struct mutex mutex;

CHECK: spinlock_t definition without comment
#2236: FILE: drivers/media/platform/rockchip/rga/rga.h:85:
+       spinlock_t ctrl_lock;

These two fields need a comment describing what the locks protect.

Also move patch 4/4 to the beginning of the patch series. The bindings
patch should come before the driver.

If I have a v12 with these issues fixed and a MAINTAINERS patch, then
I'll take it on Friday.

Do you want me to take the dts patches or will they go through another tree?

Regards,

	Hans
