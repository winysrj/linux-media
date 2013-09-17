Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:33002 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3IQL32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 07:29:28 -0400
MIME-Version: 1.0
In-Reply-To: <52377DE5.3070808@gmail.com>
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com>
	<1377066881-5423-2-git-send-email-arun.kk@samsung.com>
	<52377DE5.3070808@gmail.com>
Date: Tue, 17 Sep 2013 16:59:26 +0530
Message-ID: <CALt3h79YMgdkju17SF8M3NKLkJ+6Gjzy2vwXDYTXc8B-GaecyQ@mail.gmail.com>
Subject: Re: [PATCH v7 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>
>
> I'd like to propose a little re-design of this binding. The reason is that
> I've noticed issues related to the power domain and FIMC-LITE, FIMC-IS
> clocks
> handling sequences. This lead to a failure to disable the ISP power domain
> and to complete the system suspend/resume cycle. Not sure if this happens on
> Exynos5 SoCs, nevertheless IMHO it would be more reasonable to make
> FIMC-LITE
> device nodes child nodes of FIMC-IS. FIMC-LITE seems to be an integral part
> of the FIMC-IS subsystem.
>
> Then fimc-is node would be placed at root level, with fimc-lite nodes as its
> subnodes:
>
> fimc-is {
>         compatible = "exynos5250-fimc-is";
>         reg = <...>;
>         ...
>         #address-cells = <1>;
>         #size-cells = <1>;
>         ranges;
>
>         fimc_lite_0: fimc-lite@12390000 {
>                 compatible = "samsung,exynos4212-fimc-lite";
>                 ...
>         };
>
>         fimc_lite_1: fimc-lite@123A0000 {
>                 compatible = "samsung,exynos4212-fimc-lite";
>                 ...
>         };
>
>         fimc_lite_2: fimc-lite@123B0000 {
>                 compatible = "samsung,exynos4212-fimc-lite";
>                 ...
>         };
>
>         i2c0_isp: i2c-isp@12130000 {
>                 ...
>         };
>
>         ...
> };
>

Wont this make fimc-is to be enabled to use fimc-lite?
As such there is no dependency like that in hardware and we can
use fimc-lite alone in DMA out mode without fimc-is.
If its modified as per your suggestion, how will the scenario of
sensor -> mipi-csis -> fimc-lite -> memory look like without fimc-is?

Regards
Arun
