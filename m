Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:40964 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754142AbeDWII4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 04:08:56 -0400
MIME-Version: 1.0
In-Reply-To: <1700954.Qkp7xggMnX@avalon>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
 <1524230914-10175-4-git-send-email-geert+renesas@glider.be>
 <3039853.rivznOVBTv@avalon> <1700954.Qkp7xggMnX@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Apr 2018 10:08:55 +0200
Message-ID: <CAMuHMdUv6Gb6D0qAnDMRYhS8Uzriv1rALXpuzuMm6ndGk24GNg@mail.gmail.com>
Subject: Re: [PATCH 3/8] [media] v4l: rcar_fdp1: Change platform dependency to ARCH_RENESAS
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
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

Hi Laurent,

On Sun, Apr 22, 2018 at 10:46 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Saturday, 21 April 2018 11:07:11 EEST Laurent Pinchart wrote:
>> On Friday, 20 April 2018 16:28:29 EEST Geert Uytterhoeven wrote:
>> > The Renesas Fine Display Processor driver is used on Renesas R-Car SoCs
>> > only.  Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce
>> > ARCH_RENESAS") is ARCH_RENESAS a more appropriate platform dependency
>> > than the legacy ARCH_SHMOBILE, hence use the former.
>> >
>> > This will allow to drop ARCH_SHMOBILE on ARM and ARM64 in the near
>> > future.
>> >
>> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>
>> How would you like to get this merged ?
>
> Unless you would like to merge the whole series in one go, I'll take this in
> my tree as I have a conflicting patch I would like to submit for v4.18.

Please take it in your tree, thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
