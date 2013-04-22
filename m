Return-path: <linux-media-owner@vger.kernel.org>
Received: from hydra.sisk.pl ([212.160.235.94]:40564 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3DVLen (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 07:34:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	"patches@linaro.org" <patches@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-samsung-soc@vger.kernel.org, myungjoo.ham@samsung.com,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	khilman@deeprootsystems.com
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Mon, 22 Apr 2013 13:42:43 +0200
Message-ID: <1789889.I0NQprXLsB@vostro.rjw.lan>
In-Reply-To: <2218256.k8DNv9nCJl@amdc1227>
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org> <51750E43.1050602@samsung.com> <2218256.k8DNv9nCJl@amdc1227>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, April 22, 2013 12:37:36 PM Tomasz Figa wrote:
> On Monday 22 of April 2013 12:17:39 Sylwester Nawrocki wrote:
> > On 04/22/2013 12:03 PM, Inki Dae wrote:
> > >     > Also looks good to me. But what if power domain was disabled without
> > >     > pm
> > >     > runtime? In this case, you must enable the power domain at machine
> > >     > code or
> > >     > bootloader somewhere. This way would not only need some hard codes
> > >     > to turn
> > >     > the power domain on but also not manage power management fully. This
> > >     > is same as only the use of pm runtime interface(needing some hard
> > >     > codes without pm runtime) so I don't prefer to add
> > >     > clk_enable/disable to fimd probe(). I quite tend to force only the
> > >     > use of pm runtime as possible. So please add the hard codes to
> > >     > machine code or bootloader like you did for power domain if you
> > >     > want to use drm fimd without pm runtime.
> > >     
> > >     That's not how the runtime PM, clock subsystems work:
> > >     
> > >     1) When CONFIG_PM_RUNTIME is disabled, all the used hardware must be
> > >     kept
> > >     powered on all the time.
> > >     
> > >     2) Common Clock Framework will always gate all clocks that have zero
> > >     enable_count. Note that CCF support for Exynos is already merged for
> > >     3.10 and it will be the only available clock support method for
> > >     Exynos.
> > >     
> > >     AFAIK, drivers must work correctly in both cases, with
> > >     CONFIG_PM_RUNTIME
> > >     enabled and disabled.
> > > 
> > > Then is the driver worked correctly if the power domain to this device was
> > > disabled at bootloader without CONFIG_PM_RUNTIME and with clk_enable()?  I
> > > think, in this case, the device wouldn't be worked correctly because the
> > > power of the device remains off. So you must enable the power domain
> > > somewhere. What is the difference between these two cases?
> > 
> > How about making the driver dependant on PM_RUNTIME and making it always
> > use pm_runtime_* API, regardless if the platform actually implements runtime
> > PM or not ? Is there any issue in using the Runtime PM core always, rather
> > than coding any workarounds in drivers when PM_RUNTIME is disabled ?
> 
> I don't think this is a good idea. This would mean that any user that from 
> some reasons don't want to use PM_RUNTIME, would not be able to use the driver 
> anymore.
> 
> Rafael, Kevin, do you have any opinion on this?

I agree.

Drivers should work for CONFIG_PM_RUNTIME unset too and static inline stubs for
all runtime PM helpers are available in that case.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
