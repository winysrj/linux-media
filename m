Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54330 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3DUK1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 06:27:00 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>,
	dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	jy0922.shim@samsung.com, patches@linaro.org, inki.dae@samsung.com,
	linux-samsung-soc@vger.kernel.org, linaro-kernel@lists.linaro.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Sun, 21 Apr 2013 12:26:54 +0200
Message-ID: <56942397.CYxnWkv4Nb@flatron>
In-Reply-To: <CAKohpokPKzHHML1WhhUNYMz1Q-mJmqbp49K4Jp5Na0kjtuivEQ@mail.gmail.com>
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org> <CAKohpokPKzHHML1WhhUNYMz1Q-mJmqbp49K4Jp5Na0kjtuivEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 08 of April 2013 16:41:54 Viresh Kumar wrote:
> On 8 April 2013 16:37, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> > While migrating to common clock framework (CCF), I found that the FIMD
> > clocks were pulled down by the CCF.
> > If CCF finds any clock(s) which has NOT been claimed by any of the
> > drivers, then such clock(s) are PULLed low by CCF.
> > 
> > Calling clk_prepare() for FIMD clocks fixes the issue.
> > 
> > This patch also replaces clk_disable() with clk_unprepare() during
> > exit, since clk_prepare() is called in fimd_probe().
> 
> I asked you about fixing your commit log too.. It still looks incorrect
> to me.
> 
> This patch doesn't have anything to do with CCF pulling clocks down, but
> calling clk_prepare() before clk_enable() is must now.. that's it..
> nothing more.
> 

I fully agree.

The message should be something like:

Common Clock Framework introduced the need to prepare clocks before 
enabling them, otherwise clk_enable() fails. This patch adds clk_prepare 
calls to the driver.

and that's all.

What you are observing as "CCF pulling clocks down" is the fact that 
clk_enable() fails if the clock is not prepared and so the clock is not 
enabled in result.

Another thing is that CCF is not pulling anything down. GPIO pins can be 
pulled down (or up or not pulled), but clocks can be masked, gated or 
simply disabled - this does not imply their signal level.

> > Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> > ---
> > 
> > Changes since v3:
> >         - added clk_prepare() in fimd_probe() and clk_unprepare() in
> >         fimd_remove()>         
> >          as suggested by Viresh Kumar <viresh.kumar@linaro.org>
> > 
> > Changes since v2:
> >         - moved clk_prepare_enable() and clk_disable_unprepare() from
> >         fimd_probe() to fimd_clock() as suggested by Inki Dae
> >         <inki.dae@samsung.com>> 
> > Changes since v1:
> >         - added error checking for clk_prepare_enable() and also
> >         replaced
> >         clk_disable() with clk_disable_unprepare() during exit.
> > 
> > ---
> > 
> >  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > b/drivers/gpu/drm/exynos/exynos_drm_fimd.c index 9537761..aa22370
> > 100644
> > --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > @@ -934,6 +934,16 @@ static int fimd_probe(struct platform_device
> > *pdev)> 
> >                 return ret;
> >         
> >         }
> > 
> > +       ret = clk_prepare(ctx->bus_clk);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = clk_prepare(ctx->lcd_clk);
> > +       if  (ret < 0) {
> > +               clk_unprepare(ctx->bus_clk);
> > +               return ret;
> > +       }
> > +

Why not just simply use clk_prepare_enable() instead of all calls to 
clk_enable() in the driver?

Same goes for s/clk_disable/clk_disable_unprepare/ .

> > 
> >         ctx->vidcon0 = pdata->vidcon0;
> >         ctx->vidcon1 = pdata->vidcon1;
> >         ctx->default_win = pdata->default_win;
> > 
> > @@ -981,8 +991,8 @@ static int fimd_remove(struct platform_device
> > *pdev)> 
> >         if (ctx->suspended)
> >         
> >                 goto out;
> > 
> > -       clk_disable(ctx->lcd_clk);
> > -       clk_disable(ctx->bus_clk);
> > +       clk_unprepare(ctx->lcd_clk);
> > +       clk_unprepare(ctx->bus_clk);
> 
> This looks wrong again.. You still need to call clk_disable() to make
> clk enabled
> count zero...

Viresh is right again here.

Best regards,
Tomasz

