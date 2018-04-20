Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34122 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755172AbeDTOxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 10:53:22 -0400
Received: by mail-lf0-f45.google.com with SMTP id r7-v6so5593960lfr.1
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 07:53:21 -0700 (PDT)
Subject: Re: [PATCH 1/8] arm: shmobile: Change platform dependency to
 ARCH_RENESAS
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <1524230914-10175-1-git-send-email-geert+renesas@glider.be>
 <1524230914-10175-2-git-send-email-geert+renesas@glider.be>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <44b6b9a3-5273-54f4-ee72-0d5fcc36348a@cogentembedded.com>
Date: Fri, 20 Apr 2018 17:53:18 +0300
MIME-Version: 1.0
In-Reply-To: <1524230914-10175-2-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/20/2018 04:28 PM, Geert Uytterhoeven wrote:

> Since commit 9b5ba0df4ea4f940 ("ARM: shmobile: Introduce ARCH_RENESAS")
> is ARCH_RENESAS a more appropriate platform dependency than the legacy

   "ARCH_RENESAS is", no?

> ARCH_SHMOBILE, hence use the former.
> 
> This will allow to drop ARCH_SHMOBILE on ARM in the near future.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
[...]

MBR, Sergei
