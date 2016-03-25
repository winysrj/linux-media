Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35450 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbcCYIIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 04:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 25 Mar 2016 09:08:14 +0100
Message-ID: <CAMuHMdUAtZAP+oeKgD_ufvfgR6ieOohMpaP9gT+asuypENbjYg@mail.gmail.com>
Subject: Re: [PATCH 00/51] R-Car VSP improvements for v4.6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Mar 25, 2016 at 12:26 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> This patch series contains all the pending vsp1 driver improvements for v4.6.

v4.6 or v4.7?

> In particular, it enables display list usage in non-DRM pipelines (24/51) and
> adds support for multi-body display lists (48/51) and the R-Car Gen3 RPF alpha
> multiplier (50/51) and Z-order control (51/51).
>
> The other patches are cleanups, bug fixes and refactoring to support the four
> features listed above.
>
> The code is based on top of the "[PATCH v6 0/2] media: Add entity types" patch
> series. For convenience I've pushed a branch that contains all the necessary
> patches on top of the latest Linux media master branch to
>
>         git://linuxtv.org/pinchartl/media.git vsp1/next
>
> Note that while patch 51/51 enables support for Z-order control in the vsp1
> driver, enabling the feature for userspace requires an additional patch for
> the rcar-du-drm driver. I have pushed a branch that includes the rcar-du-drm
> changes and platform enablements to
>
>         git://linuxtv.org/pinchartl/media.git drm/du/vsp1-kms/boards

I assume this is the branch to be included by renesas-drivers?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
