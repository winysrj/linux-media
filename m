Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35482 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdLLLfy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 06:35:54 -0500
MIME-Version: 1.0
In-Reply-To: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 12 Dec 2017 12:35:51 +0100
Message-ID: <CAMuHMdWC_SNJB4QNypTJ01EKbROicqV1m-LPSk3jo+f14fbZzA@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] vsp1: TLB optimisation and DL caching
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, Nov 17, 2017 at 4:47 PM, Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> wrote:
> Each display list currently allocates an area of DMA memory to store register
> settings for the VSP1 to process. Each of these allocations adds pressure to
> the IPMMU TLB entries.
>
> We can reduce the pressure by pre-allocating larger areas and dividing the area
> across multiple bodies represented as a pool.
>
> With this reconfiguration of bodies, we can adapt the configuration code to
> separate out constant hardware configuration and cache it for re-use.
>
> --
>
> The patches provided in this series can be found at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git  tags/vsp1/tlb-optimise/v4

This started to conflict with commit dd286a531461748f ("v4l: vsp1:
Start and stop DRM pipeline independently of planes"), causing build
failures as it changes the signature of vsp1_entity_route_setup(), and
removed several VSP1_ENTITY_PARAMS_* definitions.

After fixing those, it hangs after:
     [drm] No driver support for vblank timestamp query.

So I dropped the above for today's release.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
