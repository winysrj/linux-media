Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49618 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbeGZIUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 04:20:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 00/11] convert to SPDX identifiers
Date: Thu, 26 Jul 2018 10:05:47 +0300
Message-ID: <31280656.BrrmSZ3BW7@avalon>
In-Reply-To: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
References: <87h8kmd938.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san,

Thank you for the patches.

On Thursday, 26 July 2018 05:33:51 EEST Kuninori Morimoto wrote:
> Hi Mauro, Hans
> 
> These convert license to SPDX style for Renesas related drivers
> These are using "Author's favored style", not "Linus favored style".
> 
> Kuninori Morimoto (11):
>   media: soc_camera_platform: convert to SPDX identifiers
>   media: rcar-vin: convert to SPDX identifiers
>   media: rcar-fcp: convert to SPDX identifiers
>   media: rcar_drif: convert to SPDX identifiers
>   media: rcar_fdp1: convert to SPDX identifiers
>   media: rcar_jpu: convert to SPDX identifiers
>   media: sh_veu: convert to SPDX identifiers
>   media: sh_vou: convert to SPDX identifiers
>   media: sh_mobile_ceu: convert to SPDX identifiers
>   drm: rcar-du: convert to SPDX identifiers
>   drm: shmobile: convert to SPDX identifiers

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Please note that the last two patches should go through the DRM tree, not the 
media tree.

How would you like to get this merged, should I take everything in my tree and 
submit pull requests ?

>  drivers/gpu/drm/rcar-du/Kconfig                          | 1 +
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c                   | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h                   | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_drv.c                    | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_drv.h                    | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_encoder.c                | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_encoder.h                | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_group.c                  | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_group.h                  | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c                    | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_kms.h                    | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_plane.c                  | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_plane.h                  | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_regs.h                   | 5 +----
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c                    | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h                    | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_dw_hdmi.c                   | 6 +-----
>  drivers/gpu/drm/rcar-du/rcar_lvds_regs.h                 | 5 +----
>  drivers/gpu/drm/shmobile/Kconfig                         | 1 +
>  drivers/gpu/drm/shmobile/shmob_drm_backlight.c           | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_backlight.h           | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_crtc.c                | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_crtc.h                | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_drv.c                 | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_drv.h                 | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_kms.c                 | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_kms.h                 | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_plane.c               | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_plane.h               | 6 +-----
>  drivers/gpu/drm/shmobile/shmob_drm_regs.h                | 6 +-----
>  drivers/media/platform/rcar-fcp.c                        | 6 +-----
>  drivers/media/platform/rcar-vin/Kconfig                  | 1 +
>  drivers/media/platform/rcar-vin/Makefile                 | 1 +
>  drivers/media/platform/rcar-vin/rcar-core.c              | 8 ++------
>  drivers/media/platform/rcar-vin/rcar-dma.c               | 6 +-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c              | 6 +-----
>  drivers/media/platform/rcar-vin/rcar-vin.h               | 6 +-----
>  drivers/media/platform/rcar_drif.c                       | 8 ++------
>  drivers/media/platform/rcar_fdp1.c                       | 6 +-----
>  drivers/media/platform/rcar_jpu.c                        | 5 +----
>  drivers/media/platform/sh_veu.c                          | 5 +----
>  drivers/media/platform/sh_vou.c                          | 5 +----
>  drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 6 +-----
>  drivers/media/platform/soc_camera/soc_camera_platform.c  | 5 +----
>  44 files changed, 46 insertions(+), 196 deletions(-)


-- 
Regards,

Laurent Pinchart
