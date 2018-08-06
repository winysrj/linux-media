Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60694 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbeHFLaz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2018 07:30:55 -0400
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
Subject: Re: [PATCH 0/8] renesas: convert to SPDX
Date: Mon, 06 Aug 2018 12:23:25 +0300
Message-ID: <5725513.UuOhmpgbUg@avalon>
In-Reply-To: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
References: <87h8k8nqcf.wl-kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

Thank you for the patches.

On Monday, 6 August 2018 06:15:21 EEST Kuninori Morimoto wrote:
> Hi Mauro, Hans, Laurent
> 
> These patches convert SPDX license on Renesas related drivers.
> 
> Kuninori Morimoto (8):
>   media: vsp1: convert to SPDX identifiers
>   media: rcar-fcp: convert to SPDX identifiers
>   media: adv7180: convert to SPDX identifiers
>   media: adv748x: convert to SPDX identifiers
>   drm: shmobile: convert to SPDX identifiers
>   drm: panel-lvds: convert to SPDX identifiers
>   fbdev: sh7760fb: convert to SPDX identifiers
>   backlight: as3711_bl: convert to SPDX identifiers

For the whole series,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll take the vsp1 and rcar-fcp patches in my tree and send a pull request to 
Mauro for v4.20. I will squash the shmobile patch with the previous one you 
sent, take the panel-lvds patch in the same tree, and send a pull request to 
Dave for v4.20.

For the adv7180 and adv748x patches I expect Hans to handle them.

The sh7760fb and the as3711 patches should be sent to the appropriate mailing 
lists and maintainers.

>  drivers/gpu/drm/panel/panel-lvds.c       |  6 +-----
>  drivers/media/i2c/adv7180.c              | 11 +----------
>  drivers/media/i2c/adv748x/adv748x-afe.c  |  6 +-----
>  drivers/media/i2c/adv748x/adv748x-core.c |  8 ++------
>  drivers/media/i2c/adv748x/adv748x-csi2.c |  6 +-----
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  6 +-----
>  drivers/media/i2c/adv748x/adv748x.h      |  6 +-----
>  drivers/video/backlight/as3711_bl.c      |  7 ++-----
>  drivers/video/fbdev/sh7760fb.c           |  7 ++-----
>  include/linux/platform_data/shmob_drm.h  |  6 +-----
>  include/media/rcar-fcp.h                 |  6 +-----
>  include/media/vsp1.h                     |  6 +-----
>  12 files changed, 15 insertions(+), 66 deletions(-)

-- 
Regards,

Laurent Pinchart
