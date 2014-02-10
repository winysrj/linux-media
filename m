Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:45935 "EHLO
	smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaBJIhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 03:37:54 -0500
Message-ID: <52F88DA0.8000201@math.uni-bielefeld.de>
Date: Mon, 10 Feb 2014 09:28:16 +0100
From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-media <linux-media@vger.kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: exynos4 / g2d
References: <52F7CE59.90009@math.uni-bielefeld.de> <CAK9yfHz7_9UWh=tTJeKyJh7V8yFtn8B4+ub=coV67ovRtebRfQ@mail.gmail.com>
In-Reply-To: <CAK9yfHz7_9UWh=tTJeKyJh7V8yFtn8B4+ub=coV67ovRtebRfQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!


Sachin Kamat wrote:
> +cc linux-media list and some related maintainers
>
> Hi,
>
> On 10 February 2014 00:22, Tobias Jakobi <tjakobi@math.uni-bielefeld.de> wrote:
>> Hello!
>>
>> I noticed while here
>> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/arm/boot/dts/exynos4x12.dtsi?id=3a0d48f6f81459c874165ffb14b310c0b5bb0c58)
>> the necessary entry for the dts was made, on the drm driver side
>> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/exynos/exynos_drm_g2d.c)
>> this was never added.
>>
>> Shouldn't "samsung,exynos4212-g2d" go into exynos_g2d_match as well?
> The DRM version of G2D driver does not support Exynos4 based G2D IP
> yet. The support for this IP
> is available only in the V4L2 version of the driver. Please see the file:
> drivers/media/platform/s5p-g2d/g2d.c
>
That doesn't make sense to me. From the initial commit message of the
DRM code:
"The G2D is a 2D graphic accelerator that supports Bit Block Transfer.
This G2D driver is exynos drm specific and supports only G2D(version
4.1) of later Exynos series from Exynos4X12 because supporting DMA."
(https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/drivers/gpu/drm/exynos/exynos_drm_g2d.c?id=d7f1642c90ab5eb2d7c48af0581c993094f97e1a)

In fact, this doesn't even mention the Exynos5?!

Greets,
Tobias

