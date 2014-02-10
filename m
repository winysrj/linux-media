Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50201 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBJESh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 23:18:37 -0500
Received: by mail-ob0-f175.google.com with SMTP id wn1so6631432obc.6
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 20:18:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F7CE59.90009@math.uni-bielefeld.de>
References: <52F7CE59.90009@math.uni-bielefeld.de>
Date: Mon, 10 Feb 2014 09:48:36 +0530
Message-ID: <CAK9yfHz7_9UWh=tTJeKyJh7V8yFtn8B4+ub=coV67ovRtebRfQ@mail.gmail.com>
Subject: Re: exynos4 / g2d
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+cc linux-media list and some related maintainers

Hi,

On 10 February 2014 00:22, Tobias Jakobi <tjakobi@math.uni-bielefeld.de> wrote:
> Hello!
>
> I noticed while here
> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/arch/arm/boot/dts/exynos4x12.dtsi?id=3a0d48f6f81459c874165ffb14b310c0b5bb0c58)
> the necessary entry for the dts was made, on the drm driver side
> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/exynos/exynos_drm_g2d.c)
> this was never added.
>
> Shouldn't "samsung,exynos4212-g2d" go into exynos_g2d_match as well?

The DRM version of G2D driver does not support Exynos4 based G2D IP
yet. The support for this IP
is available only in the V4L2 version of the driver. Please see the file:
drivers/media/platform/s5p-g2d/g2d.c

-- 
With warm regards,
Sachin
