Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:41889 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbeDWHpJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 03:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <20180420164811.GC22369@sirena.org.uk>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be> <20180420164811.GC22369@sirena.org.uk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Apr 2018 09:45:07 +0200
Message-ID: <CAMuHMdUt3ExAD7KEiBhntcOoSWSLMnpNT1Oix4tNRMAM=8g9jQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] arm: renesas: Change platform dependency to ARCH_RENESAS
To: Mark Brown <broonie@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>,
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
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

On Fri, Apr 20, 2018 at 6:48 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Apr 20, 2018 at 03:28:26PM +0200, Geert Uytterhoeven wrote:
>> The first 6 patches can be applied independently by subsystem
>> maintainers.
>> The last two patches depend on the first 6 patches, and are thus marked
>> RFC.
>
> Would it not make sense to try to apply everything en masse rather than
> delaying?  I'm happy to apply the subsystem stuff but if it gets things
> done quicker or more efficiently I'm also happy to have the lot merged
> as one series.

In theory, yes.

However, this touches multiple subsystems, and it's non-critical, so I don't
want to spent the energy to get this done in a synchronized way.
It's way easier to postpone the last (RFC) patches when everything else
has been applied by subsystem maintainers.

So please apply your part, thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
