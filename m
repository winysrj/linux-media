Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:39997 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753609AbeBSSWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 13:22:31 -0500
MIME-Version: 1.0
In-Reply-To: <1519055046-2399-2-git-send-email-m.purski@samsung.com>
References: <CGME20180219154456eucas1p15f4073beaf61312238f142f217a8bb3c@eucas1p1.samsung.com>
 <1519055046-2399-1-git-send-email-m.purski@samsung.com> <1519055046-2399-2-git-send-email-m.purski@samsung.com>
From: Emil Velikov <emil.l.velikov@gmail.com>
Date: Mon, 19 Feb 2018 18:22:29 +0000
Message-ID: <CACvgo50-Cx_=yvbLD-osxHXnrdENHpwFBkrXT_jV4R9vJniTjw@mail.gmail.com>
Subject: Re: [PATCH 1/8] clk: Add clk_bulk_alloc functions
To: Maciej Purski <m.purski@samsung.com>
Cc: linux-media@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..."
        <linux-samsung-soc@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-clk@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Michael Turquette <mturquette@baylibre.com>,
        Kamil Debski <kamil@wypas.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Maciej,

Just sharing a couple of fly-by ideas - please don't read too much into them.

On 19 February 2018 at 15:43, Maciej Purski <m.purski@samsung.com> wrote:
> When a driver is going to use clk_bulk_get() function, it has to
> initialize an array of clk_bulk_data, by filling its id fields.
>
> Add a new function to the core, which dynamically allocates
> clk_bulk_data array and fills its id fields. Add clk_bulk_free()
> function, which frees the array allocated by clk_bulk_alloc() function.
> Add a managed version of clk_bulk_alloc().
>
Most places use a small fixed number of struct clk pointers.
Using devres + kalloc to allocate 1-4 pointers feels a bit strange.

Quick grep shows over 150 instances that could be updated to use the new API.
Adding a cocci script to simplify the transition would be a good idea.

> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -15,6 +15,7 @@
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/notifier.h>
> +#include <linux/slab.h>
>
The extra header declaration should not be needed. One should be able
to forward declare any undefined structs.

HTH
Emil
