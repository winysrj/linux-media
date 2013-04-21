Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42134 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3DUOne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 10:43:34 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	"patches@linaro.org" <patches@linaro.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-samsung-soc@vger.kernel.org,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Sun, 21 Apr 2013 16:43:28 +0200
Message-ID: <3109033.iP2qIPD33v@flatron>
In-Reply-To: <CAAQKjZOg+H=Dnd3HWEWKjQq6e2UGZvX6s0waBdqsxx=CEAXtQw@mail.gmail.com>
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org> <56942397.CYxnWkv4Nb@flatron> <CAAQKjZOg+H=Dnd3HWEWKjQq6e2UGZvX6s0waBdqsxx=CEAXtQw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Inki,

On Sunday 21 of April 2013 22:36:08 Inki Dae wrote:
> 2013/4/21 Tomasz Figa <tomasz.figa@gmail.com>
> 
> > Hi,
> > 
> > On Monday 08 of April 2013 16:41:54 Viresh Kumar wrote:
> > > On 8 April 2013 16:37, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> > > > While migrating to common clock framework (CCF), I found that the
> > > > FIMD
> > > > clocks were pulled down by the CCF.
> > > > If CCF finds any clock(s) which has NOT been claimed by any of the
> > > > drivers, then such clock(s) are PULLed low by CCF.
> > > > 
> > > > Calling clk_prepare() for FIMD clocks fixes the issue.
> > > > 
> > > > This patch also replaces clk_disable() with clk_unprepare() during
> > > > exit, since clk_prepare() is called in fimd_probe().
> > > 
> > > I asked you about fixing your commit log too.. It still looks
> > > incorrect
> > > to me.
> > > 
> > > This patch doesn't have anything to do with CCF pulling clocks down,
> > > but calling clk_prepare() before clk_enable() is must now.. that's
> > > it.. nothing more.
> > 
> > I fully agree.
> > 
> > The message should be something like:
> > 
> > Common Clock Framework introduced the need to prepare clocks before
> > enabling them, otherwise clk_enable() fails. This patch adds
> > clk_prepare calls to the driver.
> > 
> > and that's all.
> > 
> > What you are observing as "CCF pulling clocks down" is the fact that
> > clk_enable() fails if the clock is not prepared and so the clock is
> > not
> > enabled in result.
> > 
> > Another thing is that CCF is not pulling anything down. GPIO pins can
> > be pulled down (or up or not pulled), but clocks can be masked, gated
> > or simply disabled - this does not imply their signal level.
> > 
> > > > Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> > > > ---
> > > > 
> > > > Changes since v3:
> > > >         - added clk_prepare() in fimd_probe() and clk_unprepare()
> > > >         in
> > > >         fimd_remove()>
> > > >         
> > > >          as suggested by Viresh Kumar <viresh.kumar@linaro.org>
> > > > 
> > > > Changes since v2:
> > > >         - moved clk_prepare_enable() and clk_disable_unprepare()
> > > >         from
> > > >         fimd_probe() to fimd_clock() as suggested by Inki Dae
> > > >         <inki.dae@samsung.com>>
> > > > 
> > > > Changes since v1:
> > > >         - added error checking for clk_prepare_enable() and also
> > > >         replaced
> > > >         clk_disable() with clk_disable_unprepare() during exit.
> > > > 
> > > > ---
> > > > 
> > > >  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   14 ++++++++++++--
> > > >  1 file changed, 12 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > > > b/drivers/gpu/drm/exynos/exynos_drm_fimd.c index 9537761..aa22370
> > > > 100644
> > > > --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > > > +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > > > @@ -934,6 +934,16 @@ static int fimd_probe(struct platform_device
> > > > *pdev)>
> > > > 
> > > >                 return ret;
> > > >         
> > > >         }
> > > > 
> > > > +       ret = clk_prepare(ctx->bus_clk);
> > > > +       if (ret < 0)
> > > > +               return ret;
> > > > +
> > > > +       ret = clk_prepare(ctx->lcd_clk);
> > > > +       if  (ret < 0) {
> > > > +               clk_unprepare(ctx->bus_clk);
> > > > +               return ret;
> > > > +       }
> > > > +
> > 
> > Why not just simply use clk_prepare_enable() instead of all calls to
> > clk_enable() in the driver?
> > 
> > Same goes for s/clk_disable/clk_disable_unprepare/ .
> 
> I agree with you. Using clk_prepare_enable() is more clear. Actually I
> had already commented on this. Please see the patch v2. But this way
> also looks good to me.

Well, both versions are technically correct and will have the same effect 
for Exynos SoC clocks, since only enable/disable ops change hardware 
state.

However if we look at general meaning of those generic ops, the clock will 
remain prepared for all the time the driver is loaded, even if the device 
is runtime suspended. Again on Exynos SoCs this won't have any effect, but 
I think we should respect general Common Clock Framework semantics anyway.

> > > >         ctx->vidcon0 = pdata->vidcon0;
> > > >         ctx->vidcon1 = pdata->vidcon1;
> > > >         ctx->default_win = pdata->default_win;
> > > > 
> > > > @@ -981,8 +991,8 @@ static int fimd_remove(struct platform_device
> > > > *pdev)>
> > > > 
> > > >         if (ctx->suspended)
> > > >         
> > > >                 goto out;
> > > > 
> > > > -       clk_disable(ctx->lcd_clk);
> > > > -       clk_disable(ctx->bus_clk);
> > > > +       clk_unprepare(ctx->lcd_clk);
> > > > +       clk_unprepare(ctx->bus_clk);
> > > 
> > > This looks wrong again.. You still need to call clk_disable() to
> > > make
> > > clk enabled
> > > count zero...
> > 
> > Viresh is right again here.
> 
> Ok, you two guys say together this looks wrong so I'd like to take more
> checking. I thought that clk->clk_enable is 1 at here and it would be 0
> by pm_runtimg_put_sync(). Is there any my missing point?

You're reasoning is correct, but only assuming that runtime PM is enabled. 
When it is disabled, pm_runtime_put_sync() is a no-op.

Well, after digging into the exynos_drm_fimd driver a bit more, it seems 
like its power management code needs a serious rework, because I was able 
to find more problems:

1) fimd_activate() does not get called at all if CONFIG_PM_RUNTIME is not 
enabled (except in system-wide suspend callbacks, but this is irrelevant 
to this point) - this means that the hardware is not properly initialized 
without CONFIG_PM_RUNTIME - at least clocks does not get enabled.

2) pm_runtime_set_suspended() can be used only when runtime PM is disabled 
for the device (i.e. by calling pm_runtime_disable() or not calling 
pm_runtime_enable() at all) - when runtime PM is enabled it is basically a 
no-op returning -EAGAIN error.

So here's my proposed solution:

1) call fimd_activate() and pm_runtime_set_active() explicitly in 
fimd_probe(), before calling pm_runtime_enable():

 	mutex_init(&ctx->lock);
 
 	platform_set_drvdata(pdev, ctx);
+
+	fimd_activate(ctx, true);
 
+	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);

This would power up the device even if CONFIG_PM_RUNTIME is not enabled. 
Note that pm_runtime_get_sync() after marking the device as active with 
pm_runtime_set_active() won't result in calling fimd_runtime_resume(), 
because the device is considered already resumed.

2) in fimd_remove():

+	pm_runtime_disable(dev);
+
 	if (ctx->suspended)
-		goto out;
+		return 0;
 
-	clk_disable(ctx->lcd_clk);
-	clk_disable(ctx->bus_clk);
+	fimd_activate(ctx, false);
 
+	pm_runtime_put_noidle(dev);
 	pm_runtime_set_suspended(dev);
-	pm_runtime_put_sync(dev);
-
-out:
-	pm_runtime_disable(dev);

First, pm_runtime_disable() will prevent any further runtime PM operations 
that could change ctx->suspended state. Then, if ctx->suspended is true, 
there is no need to suspend anything and we can leave. Otherwise, we power 
down the hardware manually - which will work with both CONFIG_PM_RUNTIME 
enabled and disabled, and then mark the hardware as suspended and free 
remaining reference in runtime PM core. Note that pm_runtime_put_noidle 
just decreases the reference counter and nothing else.

3) after those two changes, all that remains is to fix compliance with 
Common Clock Framework, in other words:

s/clk_enable/clk_prepare_enable/

and

s/clk_disable/clk_disable_unprepare/
 
Best regards,
Tomasz

