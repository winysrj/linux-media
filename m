Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34103 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3DWLwB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 07:52:01 -0400
From: "myungjoo.ham" <myungjoo.ham@samsung.com>
To: 'Inki Dae' <inki.dae@samsung.com>,
	"'Rafael J. Wysocki'" <rjw@sisk.pl>
Cc: 'Tomasz Figa' <t.figa@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>, patches@linaro.org,
	'Viresh Kumar' <viresh.kumar@linaro.org>,
	'Tomasz Figa' <tomasz.figa@gmail.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-samsung-soc@vger.kernel.org,
	'Vikas Sajjan' <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org, linux-media@vger.kernel.org,
	'Kevin Hilman' <khilman@deeprootsystems.com>
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org>
 <51750E43.1050602@samsung.com> <2218256.k8DNv9nCJl@amdc1227>
 <1789889.I0NQprXLsB@vostro.rjw.lan>
 <CAAQKjZOpuPw6XZJj198uwJ-WsBHwK6oSKHfYz5zoNivVcbwQng@mail.gmail.com>
In-reply-to: <CAAQKjZOpuPw6XZJj198uwJ-WsBHwK6oSKHfYz5zoNivVcbwQng@mail.gmail.com>
Subject: RE: [PATCH v4] drm/exynos: prepare FIMD clocks
Date: Tue, 23 Apr 2013 20:51:59 +0900
Message-id: <00b401ce4018$f620a390$e261eab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/4/22 Inki Dae
> 2013/4/22 Rafael J. Wysocki <rjw@sisk.pl>
> > On Monday, April 22, 2013 12:37:36 PM Tomasz Figa wrote:
> > > On Monday 22 of April 2013 12:17:39 Sylwester Nawrocki wrote:
> > > > On 04/22/2013 12:03 PM, Inki Dae wrote:
> > > > >     > Also looks good to me. But what if power domain was disabled
without
> > > > >     > pm
> > > > >     > runtime? In this case, you must enable the power domain at
machine
> > > > >     > code or
> > > > >     > bootloader somewhere. This way would not only need some hard
codes
> > > > >     > to turn
> > > > >     > the power domain on but also not manage power management
fully. This
> > > > >     > is same as only the use of pm runtime interface(needing some
hard
> > > > >     > codes without pm runtime) so I don't prefer to add
> > > > >     > clk_enable/disable to fimd probe(). I quite tend to force
only the
> > > > >     > use of pm runtime as possible. So please add the hard codes
to
> > > > >     > machine code or bootloader like you did for power domain if
you
> > > > >     > want to use drm fimd without pm runtime.
> > > > >
> > > > >     That's not how the runtime PM, clock subsystems work:
> > > > >
> > > > >     1) When CONFIG_PM_RUNTIME is disabled, all the used hardware
must be
> > > > >     kept
> > > > >     powered on all the time.
> > > > >
> > > > >     2) Common Clock Framework will always gate all clocks that
have zero
> > > > >     enable_count. Note that CCF support for Exynos is already
merged for
> > > > >     3.10 and it will be the only available clock support method
for
> > > > >     Exynos.
> > > > >
> > > > >     AFAIK, drivers must work correctly in both cases, with
> > > > >     CONFIG_PM_RUNTIME
> > > > >     enabled and disabled.
> > > > >
> > > > > Then is the driver worked correctly if the power domain to this
device was
> > > > > disabled at bootloader without CONFIG_PM_RUNTIME and with
clk_enable()?  I
> > > > > think, in this case, the device wouldn't be worked correctly
because the
> > > > > power of the device remains off. So you must enable the power
domain
> > > > > somewhere. What is the difference between these two cases?
> > > >
> > > > How about making the driver dependant on PM_RUNTIME and making it
always
> > > > use pm_runtime_* API, regardless if the platform actually implements
runtime
> > > > PM or not ? Is there any issue in using the Runtime PM core always,
rather
> > > > than coding any workarounds in drivers when PM_RUNTIME is disabled ?
> > >
> > > I don't think this is a good idea. This would mean that any user that
from
> > > some reasons don't want to use PM_RUNTIME, would not be able to use
the driver
> > > anymore.
> > >
> > > Rafael, Kevin, do you have any opinion on this?
> > I agree.
> > 
> > Drivers should work for CONFIG_PM_RUNTIME unset too and static inline
stubs for
> > all runtime PM helpers are available in that case.
> > 
> Hi Rafael,
> The embedded system, at least Exynos SoC case, has the power domain device
and this device could be enabled only by pm runtime interface. So the device
couldn't be worked correctly without turning the power domain on only
calling clk_enable(). In this case, the power domain must be enabled at
machine code or bootloader. And the machine without CONFIG_PM_RUNTIME would
assume that their own drivers always are enabled so the devices would be
worked correctly. Is there any my missing point?


- Power domain: not controlled if !CONFIG_PM_RUNTIME. Thus, we may
assume that every power domain is kept ON from boot time if
!CONFIG_PM_RUNTIME.
If power domain is kept OFF from boot time (machine init code or bootloader)
with !CONFIG_PM_RUNTIME, then it's simple a mistake at BSP writer.

- Yes, the clock is still controlled while !CONFIG_PM_RUNTIME.

My opinion is also to let probe do clk-enables though I don't want it
to have #ifdef or "clk_enable()" in the probe function.
Thus, implementing "power_on()"-like function in the driver and let probe()
and
runtime_pm_get callback call it seems appropriate to me.
(that "fimd_active(ctx, true)" is "power-on" to itself, right?)


Cheers,
MyungJoo


