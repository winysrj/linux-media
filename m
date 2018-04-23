Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:43544 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754163AbeDWJUV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:20:21 -0400
Date: Mon, 23 Apr 2018 11:20:14 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>,
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
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 7/8] ARM: shmobile: Remove the ARCH_SHMOBILE Kconfig
 symbol
Message-ID: <20180423092011.qnhcorgcu2j5hrls@verge.net.au>
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
 <1524230914-10175-8-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524230914-10175-8-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 03:28:33PM +0200, Geert Uytterhoeven wrote:
> All drivers for Renesas ARM SoCs have gained proper ARCH_RENESAS
> platform dependencies.  Hence finish the conversion from ARCH_SHMOBILE
> to ARCH_RENESAS for Renesas 32-bit ARM SoCs, as started by commit
> 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> This depends on the previous patches in this series, hence the RFC.
> 
> JFTR, after this, the following symbols for drivers supporting only
> Renesas SuperH "SH-Mobile" SoCs can no longer be selected:
>   - CONFIG_KEYBOARD_SH_KEYSC,
>   - CONFIG_VIDEO_SH_VOU,
>   - CONFIG_VIDEO_SH_MOBILE_CEU,
>   - CONFIG_DRM_SHMOBILE[*],
>   - CONFIG_FB_SH_MOBILE_MERAM.
> (changes for a shmobile_defconfig .config)
> 
> [*] CONFIG_DRM_SHMOBILE has a dependency on ARM, but it was never wired
>     up.  From the use of sh_mobile_meram, I guess it was meant for
>     SH-Mobile AP4 on Mackerel or AP4EVB, which are long gone.
>     So the only remaining upstream platforms that could make use of it
>     are legacy SuperH SH-Mobile SoCs?

That sounds about right. If there is interest I can sift through my mail
archive and see if it yields any answers.
