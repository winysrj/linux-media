Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:33951 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbcDYHhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 03:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <1461455400-28767-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1461455400-28767-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 25 Apr 2016 09:37:07 +0200
Message-ID: <CAMuHMdWOQJfOdZmo7Z3EiXeXFeANLtDPRZvSwx9mG5ecG5kpvQ@mail.gmail.com>
Subject: Re: [PATCH 02/13] v4l: Add Renesas R-Car FCP driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Apr 24, 2016 at 1:49 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The FCP is a companion module of video processing modules in the
> Renesas R-Car Gen3 SoCs. It provides data compression and decompression,
> data caching, and conversion of AXI transaction in order to reduce the

transactions

> memory bandwidth.

> --- /dev/null
> +++ b/drivers/media/platform/rcar-fcp.c
> @@ -0,0 +1,176 @@

> +/**
> + * rcar_fcp_enable - Enable an FCP
> + * @fcp: The FCP instance
> + *
> + * Before any memory access through an FCP is performed by a module, the FCP
> + * must be enabled by a call to this function. The enable calls are reference
> + * counted, each of them must be followed by one rcar_fcp_disable() call when
> + * no more memory transfer can occur through the FCP.
> + */
> +void rcar_fcp_enable(struct rcar_fcp_device *fcp)
> +{
> +       if (fcp)
> +               pm_runtime_get_sync(fcp->dev);

Given pm_runtime_get_sync() returns an error code (which is usually just
ignored), perhaps you want to forward that?

> +}
> +EXPORT_SYMBOL_GPL(rcar_fcp_enable);

Regardless
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
