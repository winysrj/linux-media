Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32905 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbcEKMit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 08:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <1462970190-588-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461620198-13428-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1462970190-588-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 11 May 2016 14:38:48 +0200
Message-ID: <CAMuHMdV07YFMf4z-pBv-xzMMteH49OKKEgYD7tMRWUWT8Zv7+A@mail.gmail.com>
Subject: Re: [PATCH v2.1] dt-bindings: Add Renesas R-Car FCP DT bindings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 11, 2016 at 2:36 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The FCP is a companion module of video processing modules in the Renesas
> R-Car Gen3 SoCs. It provides data compression and decompression, data
> caching, and conversion of AXI transactions in order to reduce the
> memory bandwidth.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
