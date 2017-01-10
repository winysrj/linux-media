Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36288 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbdAJKJR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 05:09:17 -0500
MIME-Version: 1.0
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 10 Jan 2017 11:09:16 +0100
Message-ID: <CAMuHMdXte2UAp59xhoepD7NcGW3tU-ibLHtyXKHAbJY4qrzgZA@mail.gmail.com>
Subject: Re: [PATCH 0/6] R-Car DU: Fix IOMMU operation when connected to VSP
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Aug 19, 2016 at 10:39 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> This patch series fixes the rcar-du-drm driver to support VSP plane sources
> with an IOMMU. It is available for convenience at
>
>         git://linuxtv.org/pinchartl/media.git iommu/devel/du

Dropped from renesas-drivers, as this branch is based on a very old tree
(v4.8-rc2), and many (but not all!) commits have found their way upstream.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
