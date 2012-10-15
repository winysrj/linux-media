Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35282 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2JOKzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 06:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
From: Leela Krishna Amudala <l.krishna@samsung.com>
Date: Mon, 15 Oct 2012 16:24:43 +0530
Message-ID: <CAL1wa8fP8LBCUBVJS1=dy3cyFe+bY-Gu2+wtJyuCrgbP93m3Wg@mail.gmail.com>
Subject: Re: [PATCH 0/2 v6] of: add display helper
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steffen,

To which version of the kernel we can expect this patch set to be merged into?
Because I'm waiting for this from long time to add DT support for my
display controller :)

Best Wishes,
Leela Krishna Amudala.

On Thu, Oct 4, 2012 at 11:29 PM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
>
> Hi!
>
> In accordance with Stepehn Warren, I downsized the binding.
> Now, just the display-timing is described, as I think, it is way easier to
> agree
> on those and have a complete binding.
>
> Regards,
> Steffen
>
> Steffen Trumtrar (2):
>   of: add helper to parse display timings
>   of: add generic videomode description
>
>  .../devicetree/bindings/video/display-timings.txt  |  222
> ++++++++++++++++++++
>  drivers/of/Kconfig                                 |   10 +
>  drivers/of/Makefile                                |    2 +
>  drivers/of/of_display_timings.c                    |  183
> ++++++++++++++++
>  drivers/of/of_videomode.c                          |  212
> +++++++++++++++++++
>  include/linux/of_display_timings.h                 |   85 ++++++++
>  include/linux/of_videomode.h                       |   41 ++++
>  7 files changed, 755 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/video/display-timings.txt
>  create mode 100644 drivers/of/of_display_timings.c
>  create mode 100644 drivers/of/of_videomode.c
>  create mode 100644 include/linux/of_display_timings.h
>  create mode 100644 include/linux/of_videomode.h
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
