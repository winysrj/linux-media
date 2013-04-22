Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59867 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3DVKRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 06:17:42 -0400
Message-id: <51750E43.1050602@samsung.com>
Date: Mon, 22 Apr 2013 12:17:39 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Inki Dae <inki.dae@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	"patches@linaro.org" <patches@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-samsung-soc@vger.kernel.org, myungjoo.ham@samsung.com,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org>
 <3109033.iP2qIPD33v@flatron>
 <CAAQKjZPrk6L=RmpywPgmiah+gtBgKOfsFdJLt7cfefyU76A80A@mail.gmail.com>
 <1830339.IiQ8P4gtV3@amdc1227>
 <CAAQKjZPT8pMQtY4ud=mMwgw7MYGf-JdqXePCt=yvcNcM1XgxoA@mail.gmail.com>
In-reply-to: <CAAQKjZPT8pMQtY4ud=mMwgw7MYGf-JdqXePCt=yvcNcM1XgxoA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2013 12:03 PM, Inki Dae wrote:
>     > Also looks good to me. But what if power domain was disabled without pm
>     > runtime? In this case, you must enable the power domain at machine code or
>     > bootloader somewhere. This way would not only need some hard codes to turn
>     > the power domain on but also not manage power management fully. This is same
>     > as only the use of pm runtime interface(needing some hard codes without pm
>     > runtime) so I don't prefer to add clk_enable/disable to fimd probe(). I quite
>     > tend to force only the use of pm runtime as possible. So please add the hard
>     > codes to machine code or bootloader like you did for power domain if you
>     > want to use drm fimd without pm runtime.
> 
>     That's not how the runtime PM, clock subsystems work:
> 
>     1) When CONFIG_PM_RUNTIME is disabled, all the used hardware must be kept
>     powered on all the time.
> 
>     2) Common Clock Framework will always gate all clocks that have zero
>     enable_count. Note that CCF support for Exynos is already merged for 3.10 and
>     it will be the only available clock support method for Exynos.
> 
>     AFAIK, drivers must work correctly in both cases, with CONFIG_PM_RUNTIME
>     enabled and disabled.
> 
> 
> Then is the driver worked correctly if the power domain to this device was
> disabled at bootloader without CONFIG_PM_RUNTIME and with clk_enable()?  I
> think, in this case, the device wouldn't be worked correctly because the power
> of the device remains off. So you must enable the power domain somewhere. What
> is the difference between these two cases?

How about making the driver dependant on PM_RUNTIME and making it always
use pm_runtime_* API, regardless if the platform actually implements runtime
PM or not ? Is there any issue in using the Runtime PM core always, rather
than coding any workarounds in drivers when PM_RUNTIME is disabled ?

Thanks,
Sylwester
