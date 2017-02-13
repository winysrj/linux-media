Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34622 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752691AbdBMMxN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 07:53:13 -0500
Received: by mail-it0-f66.google.com with SMTP id r141so1993272ita.1
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 04:53:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1485979523-32404-1-git-send-email-javier@osg.samsung.com>
References: <1485979523-32404-1-git-send-email-javier@osg.samsung.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Mon, 13 Feb 2017 09:53:11 -0300
Message-ID: <CABxcv==+Di=i_KBY1LY0Ejo8UXMYa5yhS=bugsyxFkQTyh0xUw@mail.gmail.com>
Subject: Re: [PATCH 0/2] [media] exynos-gsc: Fix support for NV21 and NV61 formats
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, Feb 1, 2017 at 5:05 PM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> Hello,
>
> Commit 652bb68018a5 ("[media] exynos-gsc: do proper bytesperline and
> sizeimage calculation") fixed corrupted frames for most exynos-gsc
> formats, but even after that patch two issues were still remaining:
>
> 1) Frames were still not correct for NV21 and NV61 formats.
> 2) Y42B format didn't work when used as output (only as input).
>
> This patch series fixes (1).
>
> Best regards,
> Javier
>
>
> Thibault Saunier (2):
>   [media] exynos-gsc: Do not swap cb/cr for semi planar formats
>   [media] exynos-gsc: Add support for NV{16,21,61}M pixel formats
>
>  drivers/media/platform/exynos-gsc/gsc-core.c | 29 ++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)

Any comments on this series?

Best regards,
Javier
