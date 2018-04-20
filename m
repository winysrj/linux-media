Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35464 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754830AbeDTNk0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 20 Apr 2018 15:40:24 +0200
Message-ID: <CAK8P3a17+rD9o=dKGYPhhjmtZsc7S-1YpPpH+Zfxbx6xVo7UWg@mail.gmail.com>
Subject: Re: [PATCH 0/8] arm: renesas: Change platform dependency to ARCH_RENESAS
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 3:28 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>         Hi all,
>
> Commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS")
> started the conversion from ARCH_SHMOBILE to ARCH_RENESAS for Renesas
> ARM SoCs.  This patch series completes the conversion, by:
>   1. Updating dependencies for drivers that weren't converted yet,
>   2. Removing the ARCH_SHMOBILE Kconfig symbols on ARM and ARM64.
>
> The first 6 patches can be applied independently by subsystem
> maintainers.
> The last two patches depend on the first 6 patches, and are thus marked
> RFC.

This all looks fine to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>

      Arnd
