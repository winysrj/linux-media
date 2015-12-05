Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:32790 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbbLEK5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 05:57:49 -0500
MIME-Version: 1.0
In-Reply-To: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Sat, 5 Dec 2015 11:57:49 +0100
Message-ID: <CAMuHMdW13=rftd1HOWBGcjH8aYCjyGZ0u60TkVeTif7+HFuwsQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/32] VSP: Add R-Car Gen3 support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Dec 5, 2015 at 3:12 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> This patch set adds support for the Renesas R-Car Gen3 SoC family to the VSP1
> driver. The large number of patches is caused by a change in the display
> controller architecture that makes usage of the VSP mandatory as the display
> controller has lost the ability to read data from memory.
>
> Patch 01/32 to 27/32 prepare for the implementation of an API exported to the
> DRM driver in patch 28/32. Patches 31/32 enables support for the R-Car Gen3
> family, and patch 32/32 finally enhances perfomances by implementing support
> for display lists.
>
> The major change compared to v1 is the usage of the IP version register
> instead of DT properties to configure device parameters such as the number of
> BRU inputs or the availability of the BRU.

Thanks for your series!

As http://git.linuxtv.org/pinchartl/media.git/tag/?id=vsp1-kms-20151112 is
getting old, and has lots of conflicts with recent -next, do you plan to publish
this in a branch, and a separate branch for integration, to ease integration
in renesas-drivers?

Alternatively, I can just import the series you posted, but having the
broken-out integration part would be nice.

Thanks again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
