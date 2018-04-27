Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:37444 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759079AbeD0VZ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 17:25:56 -0400
Subject: Re: [PATCH v2 1/8] v4l: vsp1: Use SPDX license headers
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-2-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <45a7f1d7-9802-9b3b-c964-2f37c113cc8e@ideasonboard.com>
Date: Fri, 27 Apr 2018 22:25:51 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the patch, and going through the whole driver for this update.

On 22/04/18 23:34, Laurent Pinchart wrote:
> Adopt the SPDX license identifier headers to ease license compliance
> management. All files in the driver are licensed under the GPLv2+ except
> for the vsp1_regs.h file which is licensed under the GPLv2. This is
> likely an oversight, but fixing this requires contacting the copyright
> owners and is out of scope for this patch.

I agree that's out of scope for this patch, but it's not too exhaustive a list
to correct at a later date:

git shortlog -e -n -s -- ./drivers/media/platform/vsp1/vsp1_regs.h
    19  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
     5  Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
     3  Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
     2  Geert Uytterhoeven <geert+renesas@glider.be>
     2  Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
     1  Linus Torvalds <torvalds@linux-foundation.org>
     1  Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
     1  Wolfram Sang <wsa+renesas@sang-engineering.com>

(Both Geert and Linus are merge commits there)

> While at it fix the file descriptions to match file names where copy and
> paste error occurred.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

It's crazy that we have two types of comment style for the SPDX identifier - but
that's not a fault in this patch, so:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1.h        | 6 +-----
>  drivers/media/platform/vsp1/vsp1_brx.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_brx.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_clu.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_clu.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_dl.c     | 8 ++------
>  drivers/media/platform/vsp1/vsp1_dl.h     | 6 +-----
>  drivers/media/platform/vsp1/vsp1_drm.c    | 8 ++------
>  drivers/media/platform/vsp1/vsp1_drm.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_drv.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_entity.c | 6 +-----
>  drivers/media/platform/vsp1/vsp1_entity.h | 6 +-----
>  drivers/media/platform/vsp1/vsp1_hgo.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_hgo.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_hgt.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_hgt.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_histo.c  | 6 +-----
>  drivers/media/platform/vsp1/vsp1_histo.h  | 6 +-----
>  drivers/media/platform/vsp1/vsp1_hsit.c   | 6 +-----
>  drivers/media/platform/vsp1/vsp1_hsit.h   | 6 +-----
>  drivers/media/platform/vsp1/vsp1_lif.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_lif.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_lut.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_lut.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_pipe.c   | 6 +-----
>  drivers/media/platform/vsp1/vsp1_pipe.h   | 6 +-----
>  drivers/media/platform/vsp1/vsp1_regs.h   | 5 +----
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_rwpf.c   | 6 +-----
>  drivers/media/platform/vsp1/vsp1_rwpf.h   | 6 +-----
>  drivers/media/platform/vsp1/vsp1_sru.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_sru.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_uds.c    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_uds.h    | 6 +-----
>  drivers/media/platform/vsp1/vsp1_video.c  | 6 +-----
>  drivers/media/platform/vsp1/vsp1_video.h  | 6 +-----
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 6 +-----
>  37 files changed, 39 insertions(+), 186 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
> index 894cc725c2d4..9cf4e1c4b036 100644
> --- a/drivers/media/platform/vsp1/vsp1.h
> +++ b/drivers/media/platform/vsp1/vsp1.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1.h  --  R-Car VSP1 Driver
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_H__
>  #define __VSP1_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_brx.c b/drivers/media/platform/vsp1/vsp1_brx.c
> index b4af1d546022..3beec18fd863 100644
> --- a/drivers/media/platform/vsp1/vsp1_brx.c
> +++ b/drivers/media/platform/vsp1/vsp1_brx.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_brx.c  --  R-Car VSP1 Blend ROP Unit (BRU and BRS)
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_brx.h b/drivers/media/platform/vsp1/vsp1_brx.h
> index 927aa4254c0f..6abbb8c3343c 100644
> --- a/drivers/media/platform/vsp1/vsp1_brx.h
> +++ b/drivers/media/platform/vsp1/vsp1_brx.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_brx.h  --  R-Car VSP1 Blend ROP Unit (BRU and BRS)
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_BRX_H__
>  #define __VSP1_BRX_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
> index f2fb26e5ab4e..9626b6308585 100644
> --- a/drivers/media/platform/vsp1/vsp1_clu.c
> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_clu.c  --  R-Car VSP1 Cubic Look-Up Table
>   *
>   * Copyright (C) 2015-2016 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
> index 036e0a2f1a42..c45e6e707592 100644
> --- a/drivers/media/platform/vsp1/vsp1_clu.h
> +++ b/drivers/media/platform/vsp1/vsp1_clu.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_clu.h  --  R-Car VSP1 Cubic Look-Up Table
>   *
>   * Copyright (C) 2015 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_CLU_H__
>  #define __VSP1_CLU_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 30ad491605ff..801dea475740 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
> - * vsp1_dl.h  --  R-Car VSP1 Display List
> + * vsp1_dl.c  --  R-Car VSP1 Display List
>   *
>   * Copyright (C) 2015 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
> index 1a5bbd5ddb7b..e6279b1abd19 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_dl.h  --  R-Car VSP1 Display List
>   *
>   * Copyright (C) 2015 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_DL_H__
>  #define __VSP1_DL_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 095dc48aa25a..2b29a83dceb9 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
> - * vsp1_drm.c  --  R-Car VSP1 DRM API
> + * vsp1_drm.c  --  R-Car VSP1 DRM/KMS Interface
>   *
>   * Copyright (C) 2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index d738cc57f0e3..f4af1b2b12d6 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_drm.h  --  R-Car VSP1 DRM/KMS Interface
>   *
>   * Copyright (C) 2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_DRM_H__
>  #define __VSP1_DRM_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index f41cd70409db..331a2e0af0d3 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_drv.c  --  R-Car VSP1 Driver
>   *
>   * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/clk.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index 54de15095709..72354caf5746 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_entity.c  --  R-Car VSP1 Base Entity
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index c26523c56c05..fb20a1578f3b 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_entity.h  --  R-Car VSP1 Base Entity
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_ENTITY_H__
>  #define __VSP1_ENTITY_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
> index 50309c053b78..d514807ccdf4 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgo.c
> +++ b/drivers/media/platform/vsp1/vsp1_hgo.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_hgo.c  --  R-Car VSP1 Histogram Generator 1D
>   *
>   * Copyright (C) 2016 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_hgo.h b/drivers/media/platform/vsp1/vsp1_hgo.h
> index c6c0b7a80e0c..6b0c8580e1bf 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgo.h
> +++ b/drivers/media/platform/vsp1/vsp1_hgo.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_hgo.h  --  R-Car VSP1 Histogram Generator 1D
>   *
>   * Copyright (C) 2016 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_HGO_H__
>  #define __VSP1_HGO_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
> index b5ce305e3e6f..18dc89f47c45 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgt.c
> +++ b/drivers/media/platform/vsp1/vsp1_hgt.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_hgt.c  --  R-Car VSP1 Histogram Generator 2D
>   *
>   * Copyright (C) 2016 Renesas Electronics Corporation
>   *
>   * Contact: Niklas Söderlund (niklas.soderlund@ragnatech.se)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.h b/drivers/media/platform/vsp1/vsp1_hgt.h
> index 83f2e130942a..38ec237bdd2d 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgt.h
> +++ b/drivers/media/platform/vsp1/vsp1_hgt.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_hgt.h  --  R-Car VSP1 Histogram Generator 2D
>   *
>   * Copyright (C) 2016 Renesas Electronics Corporation
>   *
>   * Contact: Niklas Söderlund (niklas.soderlund@ragnatech.se)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_HGT_H__
>  #define __VSP1_HGT_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
> index 8638ebc514b4..029181c1fb61 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.c
> +++ b/drivers/media/platform/vsp1/vsp1_histo.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_histo.c  --  R-Car VSP1 Histogram API
>   *
> @@ -5,11 +6,6 @@
>   * Copyright (C) 2016 Laurent Pinchart
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.h b/drivers/media/platform/vsp1/vsp1_histo.h
> index e774adbf251f..06f029846244 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.h
> +++ b/drivers/media/platform/vsp1/vsp1_histo.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_histo.h  --  R-Car VSP1 Histogram API
>   *
> @@ -5,11 +6,6 @@
>   * Copyright (C) 2016 Laurent Pinchart
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_HISTO_H__
>  #define __VSP1_HISTO_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
> index 764d405345ee..7ba3535f3c9b 100644
> --- a/drivers/media/platform/vsp1/vsp1_hsit.c
> +++ b/drivers/media/platform/vsp1/vsp1_hsit.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_hsit.c  --  R-Car VSP1 Hue Saturation value (Inverse) Transform
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_hsit.h b/drivers/media/platform/vsp1/vsp1_hsit.h
> index 82f1c8426900..a658b1aa49e7 100644
> --- a/drivers/media/platform/vsp1/vsp1_hsit.h
> +++ b/drivers/media/platform/vsp1/vsp1_hsit.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_hsit.h  --  R-Car VSP1 Hue Saturation value (Inverse) Transform
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_HSIT_H__
>  #define __VSP1_HSIT_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
> index 704920753998..b20b842f06ba 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_lif.c  --  R-Car VSP1 LCD Controller Interface
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.h b/drivers/media/platform/vsp1/vsp1_lif.h
> index 3417339379b1..71a4eda9c2b2 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.h
> +++ b/drivers/media/platform/vsp1/vsp1_lif.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_lif.h  --  R-Car VSP1 LCD Controller Interface
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_LIF_H__
>  #define __VSP1_LIF_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
> index c67cc60db0db..7bdabb311c6c 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.c
> +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_lut.c  --  R-Car VSP1 Look-Up Table
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
> index f8c4e8f0a79d..dce2fdc315f6 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.h
> +++ b/drivers/media/platform/vsp1/vsp1_lut.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_lut.h  --  R-Car VSP1 Look-Up Table
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_LUT_H__
>  #define __VSP1_LUT_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index 3fc5ecfa35e8..6fde4c0b9844 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_pipe.c  --  R-Car VSP1 Pipeline
>   *
>   * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/delay.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
> index 07ccd6b810c5..663d7fed7929 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_pipe.h  --  R-Car VSP1 Pipeline
>   *
>   * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_PIPE_H__
>  #define __VSP1_PIPE_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index dae0c1901297..3201ad4b77d4 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -1,13 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
>   *
>   * Copyright (C) 2013 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2
> - * as published by the Free Software Foundation.
>   */
>  
>  #ifndef __VSP1_REGS_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
> index 7e74c2015070..7005a4c6aa88 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_rpf.c  --  R-Car VSP1 Read Pixel Formatter
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
> index cfd8f1904fa6..049bdd958e56 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_rwpf.c  --  R-Car VSP1 Read and Write Pixel Formatters
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/v4l2-subdev.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index 915aeadb21dd..70742ecf766f 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_rwpf.h  --  R-Car VSP1 Read and Write Pixel Formatters
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_RWPF_H__
>  #define __VSP1_RWPF_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
> index 51e5691187c3..44cb9b134a19 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_sru.c  --  R-Car VSP1 Super Resolution Unit
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.h b/drivers/media/platform/vsp1/vsp1_sru.h
> index 85e241457af2..ddb00eadd1ea 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.h
> +++ b/drivers/media/platform/vsp1/vsp1_sru.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_sru.h  --  R-Car VSP1 Super Resolution Unit
>   *
>   * Copyright (C) 2013 Renesas Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_SRU_H__
>  #define __VSP1_SRU_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
> index 72f72a9d2152..e5afd69df939 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_uds.c  --  R-Car VSP1 Up and Down Scaler
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
> index 7bf3cdcffc65..2cd9f4b95442 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.h
> +++ b/drivers/media/platform/vsp1/vsp1_uds.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_uds.h  --  R-Car VSP1 Up and Down Scaler
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_UDS_H__
>  #define __VSP1_UDS_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 2b1c94ffc6f5..c8c12223a267 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_video.c  --  R-Car VSP1 Video Node
>   *
>   * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/list.h>
> diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
> index 50ea7f02205f..75a5a65c66fe 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.h
> +++ b/drivers/media/platform/vsp1/vsp1_video.h
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * vsp1_video.h  --  R-Car VSP1 Video Node
>   *
>   * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  #ifndef __VSP1_VIDEO_H__
>  #define __VSP1_VIDEO_H__
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 53858d100228..65ed2f849551 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -1,14 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /*
>   * vsp1_wpf.c  --  R-Car VSP1 Write Pixel Formatter
>   *
>   * Copyright (C) 2013-2014 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <linux/device.h>
> 
