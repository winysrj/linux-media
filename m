Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62832 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3DVFty (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 01:49:54 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Viresh Kumar' <viresh.kumar@linaro.org>,
	'Vikas Sajjan' <vikas.sajjan@linaro.org>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	jy0922.shim@samsung.com, kgene.kim@samsung.com,
	linaro-kernel@lists.linaro.org, linux-media@vger.kernel.org
References: <1364805830-6129-1-git-send-email-vikas.sajjan@linaro.org>
 <CAKohpo=az=FS6-jfjN0WR=eKSAZ=MSo90Qc91kK-PEWOH3tzsQ@mail.gmail.com>
In-reply-to: <CAKohpo=az=FS6-jfjN0WR=eKSAZ=MSo90Qc91kK-PEWOH3tzsQ@mail.gmail.com>
Subject: RE: [PATCH v3] drm/exynos: enable FIMD clocks
Date: Mon, 22 Apr 2013 14:49:52 +0900
Message-id: <07b501ce3f1d$359f5900$a0de0b00$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Mr. Vikas

Please fix the below typos Viresh pointed out and my comments.

> -----Original Message-----
> From: Viresh Kumar [mailto:viresh.kumar@linaro.org]
> Sent: Monday, April 01, 2013 5:51 PM
> To: Vikas Sajjan
> Cc: dri-devel@lists.freedesktop.org; linux-samsung-soc@vger.kernel.org;
> jy0922.shim@samsung.com; inki.dae@samsung.com; kgene.kim@samsung.com;
> linaro-kernel@lists.linaro.org; linux-media@vger.kernel.org
> Subject: Re: [PATCH v3] drm/exynos: enable FIMD clocks
> 
> On 1 April 2013 14:13, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
> > While migrating to common clock framework (CCF), found that the FIMD
> clocks
> 
> s/found/we found/
> 
> > were pulled down by the CCF.
> > If CCF finds any clock(s) which has NOT been claimed by any of the
> > drivers, then such clock(s) are PULLed low by CCF.
> >
> > By calling clk_prepare_enable() for FIMD clocks fixes the issue.
> 
> s/By calling/Calling/
> 
> and
> 
> s/the/this
> 
> > this patch also replaces clk_disable() with clk_disable_unprepare()
> 
> s/this/This
> 
> > during exit.
> 
> Sorry but your log doesn't say what you are doing. You are just adding
> relevant calls to clk_prepare/unprepare() before calling
> clk_enable/disable.
> 
> > Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
> > ---
> > Changes since v2:
> >         - moved clk_prepare_enable() and clk_disable_unprepare() from
> >         fimd_probe() to fimd_clock() as suggested by Inki Dae
> <inki.dae@samsung.com>
> > Changes since v1:
> >         - added error checking for clk_prepare_enable() and also
replaced
> >         clk_disable() with clk_disable_unprepare() during exit.
> > ---
> >  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > index 9537761..f2400c8 100644
> > --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
> > @@ -799,18 +799,18 @@ static int fimd_clock(struct fimd_context *ctx,
> bool enable)
> >         if (enable) {
> >                 int ret;
> >
> > -               ret = clk_enable(ctx->bus_clk);
> > +               ret = clk_prepare_enable(ctx->bus_clk);
> >                 if (ret < 0)
> >                         return ret;
> >
> > -               ret = clk_enable(ctx->lcd_clk);
> > +               ret = clk_prepare_enable(ctx->lcd_clk);
> >                 if  (ret < 0) {
> > -                       clk_disable(ctx->bus_clk);
> > +                       clk_disable_unprepare(ctx->bus_clk);
> >                         return ret;
> >                 }
> >         } else {
> > -               clk_disable(ctx->lcd_clk);
> > -               clk_disable(ctx->bus_clk);
> > +               clk_disable_unprepare(ctx->lcd_clk);
> > +               clk_disable_unprepare(ctx->bus_clk);
> >         }
> >
> >         return 0;
> > @@ -981,8 +981,8 @@ static int fimd_remove(struct platform_device *pdev)
> >         if (ctx->suspended)
> >                 goto out;
> >
> > -       clk_disable(ctx->lcd_clk);
> > -       clk_disable(ctx->bus_clk);
> > +       clk_disable_unprepare(ctx->lcd_clk);
> > +       clk_disable_unprepare(ctx->bus_clk);

Just remove the above codes. It seems that clk_disable(also
clk_disable_unprepare) isn't needed because it will be done by
pm_runtime_put_sync and please re-post it(probably patch v5??)

Thanks,
Inki Dae

> 
> You are doing things at the right place but i have a suggestion. Are you
> doing
> anything in your clk_prepare() atleast for this device? Probably not.
> 
> If not, then its better to call clk_prepare/unprepare only once at
> probe/remove
> and keep clk_enable/disable calls as is.
> 
> --
> viresh

