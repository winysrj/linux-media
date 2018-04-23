Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49964 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbeDWIn6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 04:43:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] v4l: rcar_fdp1: Enable compilation on Gen2 platforms
Date: Mon, 23 Apr 2018 11:44:09 +0300
Message-ID: <2980962.LsAd7PBAGk@avalon>
In-Reply-To: <CAMuHMdWiFa4_wyQpOHbb9r-55o_gjvQUKOVVbkuYGEbHRsrEuQ@mail.gmail.com>
References: <20180422102849.2481-1-laurent.pinchart+renesas@ideasonboard.com> <20180422102849.2481-3-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdWiFa4_wyQpOHbb9r-55o_gjvQUKOVVbkuYGEbHRsrEuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday, 23 April 2018 10:58:13 EEST Geert Uytterhoeven wrote:
> On Sun, Apr 22, 2018 at 12:28 PM, Laurent Pinchart wrote:
> > Commit 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency") fixed
> > a compilation breakage when the optional VIDEO_RENESAS_FCP dependency is
> > compiled as a module while the rcar_fdp1 driver is built in. As a side
> > effect it disabled compilation on Gen2 by disallowing the valid
> > combination ARCH_RENESAS && !VIDEO_RENESAS_FCP. Fix it by handling the
> > dependency the same way the vsp1 driver did in commit 199946731fa4
> > ("[media] vsp1: clarify FCP dependency").
> > 
> > Fixes: 1d3897143815 ("[media] v4l: rcar_fdp1: add FCP dependency")
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig
> > b/drivers/media/platform/Kconfig index 621d63b2001d..81c3ab95c050 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -397,7 +397,7 @@ config VIDEO_RENESAS_FDP1
> >         tristate "Renesas Fine Display Processor"
> >         depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> >         depends on ARCH_RENESAS || COMPILE_TEST
> > -       depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) ||
> > VIDEO_RENESAS_FCP
> > +       depends on (!ARM64 && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
> 
> s/!ARM64/ARCH_RCAR_GEN2/?

That would work too, but is it any better ? It would only matter is 
COMPILE_TEST is set, and thus won't really make a difference.

> >         select VIDEOBUF2_DMA_CONTIG
> >         select V4L2_MEM2MEM_DEV

-- 
Regards,

Laurent Pinchart
