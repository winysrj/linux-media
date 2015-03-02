Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:42027 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbbCBM2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 07:28:37 -0500
Received: by mail-qa0-f45.google.com with SMTP id j7so22406113qaq.4
        for <linux-media@vger.kernel.org>; Mon, 02 Mar 2015 04:28:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
References: <1421673760-2600-1-git-send-email-ulf.hansson@linaro.org>
Date: Mon, 2 Mar 2015 13:28:36 +0100
Message-ID: <CAPDyKFpC4Ytd7j7MRV6G27Be7TphKBc-7ZyVBveAbiHB8VMt+g@mail.gmail.com>
Subject: Re: [PATCH V2 0/8] [media] exynos-gsc: Fixup PM support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	linux-media@vger.kernel.org,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 January 2015 at 14:22, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> Changes in v2:
>         - Rebase patches.
>         - Adapt to changes for the PM core. Especially, the Kconfig option for
>           CONFIG_PM_RUNTIME has been removed and the runtime PM core is now
>           build for CONFIG_PM.
>
> This patchset fixup the PM support and adds some minor improvements to
> potentially save some more power at runtime PM suspend.
>
>
> Ulf Hansson (8):
>   [media] exynos-gsc: Simplify clock management
>   [media] exynos-gsc: Convert gsc_m2m_resume() from int to void
>   [media] exynos-gsc: Make driver functional when CONFIG_PM is unset
>   [media] exynos-gsc: Make runtime PM callbacks available for CONFIG_PM
>   [media] exynos-gsc: Fixup clock management at ->remove()
>   [media] exynos-gsc: Do full clock gating at runtime PM suspend
>   [media] exynos-gsc: Make system PM callbacks available for
>     CONFIG_PM_SLEEP
>   [media] exynos-gsc: Simplify system PM
>
>  drivers/media/platform/exynos-gsc/gsc-core.c | 183 +++++++++++----------------
>  drivers/media/platform/exynos-gsc/gsc-core.h |   3 -
>  2 files changed, 72 insertions(+), 114 deletions(-)
>
> --
> 1.9.1
>

I guess you guys have been busy, but it would be nice to get some
feedback of these patches.

Kind regards
Uffe
