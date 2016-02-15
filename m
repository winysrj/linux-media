Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33388 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbcBOJcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 04:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <1455242450-24493-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1455242450-24493-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 15 Feb 2016 10:32:35 +0100
Message-ID: <CAMuHMdW1bWPPL-4hRM=dx-216V4Aew1dg=i=ApkLww4RFXQgmg@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/9] v4l: Add Renesas R-Car FCP driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Feb 12, 2016 at 3:00 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The FCP is a companion module of video processing modules in the
> Renesas R-Car Gen3 SoCs. It provides data compression and decompression,
> data caching, and converting of AXI transaction in order to reduce the

"conversion"?

> memory bandwidth.
>
> The driver is not meant to be used standalone but provides an API to the
> video processing modules to control the FCP.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -0,0 +1,24 @@
> +Renesas R-Car Frame Compression Processor (FCP)
> +-----------------------------------------------
> +
> +The FCP is a companion module of video processing modules in the Renesas R-Car
> +Gen3 SoCs. It provides data compression and decompression, data caching, and
> +converting of AXI transaction in order to reduce the memory bandwidth.

"conversion"?

> +
> +There are three types of FCP whose configuration and behaviour highly depend
> +on the module they are paired with.
> +
> + - compatible: Must be one of the following
> +   - "renesas,fcpv" for the 'FCP for VSP' device

Any chance this module can turn up in another SoC later? I guess yes.
What about future-proofing using "renesas,r8a7795-fcpv" and
"renesas,rcar-gen3-fcpv"?

> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index fd4fcd5a7184..cbb4e5735bf8 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -255,6 +255,19 @@ config VIDEO_RENESAS_JPU
>           To compile this driver as a module, choose M here: the module
>           will be called rcar_jpu.
>
> +config VIDEO_RENESAS_FCP
> +       tristate "Renesas Frame Compression Processor"
> +       depends on ARCH_SHMOBILE || COMPILE_TEST

ARCH_RENESAS

> diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
> new file mode 100644
> index 000000000000..cf8cb629ae4f
> --- /dev/null
> +++ b/drivers/media/platform/rcar-fcp.c

> +struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
> +{
> +       struct rcar_fcp_device *fcp;
> +
> +       mutex_lock(&fcp_lock);
> +
> +       list_for_each_entry(fcp, &fcp_devices, list) {
> +               if (fcp->dev->of_node != np)
> +                       continue;
> +
> +               /*
> +                * Make sure the module won't be unloaded behind our back. This
> +                * is a poor's man safety net, the module should really not be

poor man's

> diff --git a/include/media/rcar-fcp.h b/include/media/rcar-fcp.h
> new file mode 100644
> index 000000000000..4260cf48d3b1
> --- /dev/null
> +++ b/include/media/rcar-fcp.h
> @@ -0,0 +1,34 @@
> +/*
> + * rcar-fcp.h  --  R-Car Frame Compression Processor Driver
> + *
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + *
> + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#ifndef __MEDIA_RCAR_FCP_H__
> +#define __MEDIA_RCAR_FCP_H__
> +
> +struct device_node;
> +struct rcar_fcp_device;
> +
> +#if IS_ENABLED(CONFIG_VIDEO_RENESAS_FCP)
> +struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np);
> +void rcar_fcp_put(struct rcar_fcp_device *fcp);
> +void rcar_fcp_enable(struct rcar_fcp_device *fcp);
> +void rcar_fcp_disable(struct rcar_fcp_device *fcp);
> +#else
> +static inline struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
> +{
> +       return ERR_PTR(-ENOENT);
> +}
> +static inline void rcar_fcp_put(struct rcar_fcp_device *fcp) { }
> +static inline void rcar_fcp_enable(struct rcar_fcp_device *fcp) { }
> +static inline void rcar_fcp_disable(struct rcar_fcp_device *fcp) { }

Given the dummies, the vsp driver can also work when FCP support is not
enabled?
Or is this meant purely to avoid #ifdefs in the vsp driver when compiling for
R-Car Gen2?

In case of the latter, you may want to enforce this in Kconfig.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
