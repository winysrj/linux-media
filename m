Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59461 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbcL2NyD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Dec 2016 08:54:03 -0500
Subject: Re: [PATCH 0/4] video/exynos/cec: add HDMI state notifier & use in
 s5p-cec
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <0b71ac14-a97a-1eba-26dc-6cf85bab7aa2@samsung.com>
Date: Thu, 29 Dec 2016 14:53:57 +0100
MIME-version: 1.0
In-reply-to: <20161213150813.37966-1-hverkuil@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
References: <CGME20161213150827epcas1p3155035a3c8affb78fb7a3c5b4b60007b@epcas1p3.samsung.com>
 <20161213150813.37966-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 2016-12-13 16:08, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This patch series adds the HDMI notifier code, based on Russell's code:
>
> https://patchwork.kernel.org/patch/9277043/
>
> It adds support for it to the exynos_hdmi drm driver, adds support for
> it to the CEC framework and finally adds support to the s5p-cec driver,
> which now can be moved out of staging.
>
> Tested with my Odroid U3 exynos4 devboard.
>
> Comments are welcome. I'd like to get this in for the 4.11 kernel as
> this is a missing piece needed to integrate CEC drivers.
>
> Benjamin, can you look at doing the same notifier integration for your
> st-cec driver as is done for s5p-cec? It would be good to be able to
> move st-cec out of staging at the same time.

Thanks for working on this and taking it from by TODO list! :)

Please add:
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

If you plan to send an updated version, please send it also to
linux-samsung-soc@vger.kernel.org, Krzysztof and Inki to get their acks
for the bindings, dtsi and drm parts.

This HDMI notifier framework will probably be also useful for integrating
HDMI audio support for Samsung ASoC driver.

> Regards,
>
> 	Hans
>
> Hans Verkuil (4):
>    video: add HDMI state notifier support
>    exynos_hdmi: add HDMI notifier support
>    cec: integrate HDMI notifier support
>    s5p-cec: add hdmi-notifier support, move out of staging
>
>   .../devicetree/bindings/media/s5p-cec.txt          |   2 +
>   arch/arm/boot/dts/exynos4.dtsi                     |   1 +
>   drivers/gpu/drm/exynos/Kconfig                     |   1 +
>   drivers/gpu/drm/exynos/exynos_hdmi.c               |  24 +++-
>   drivers/media/cec/cec-core.c                       |  50 ++++++++
>   drivers/media/platform/Kconfig                     |  18 +++
>   drivers/media/platform/Makefile                    |   1 +
>   .../media => media/platform}/s5p-cec/Makefile      |   0
>   .../platform}/s5p-cec/exynos_hdmi_cec.h            |   0
>   .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |   0
>   .../media => media/platform}/s5p-cec/regs-cec.h    |   0
>   .../media => media/platform}/s5p-cec/s5p_cec.c     |  35 +++++-
>   .../media => media/platform}/s5p-cec/s5p_cec.h     |   3 +
>   drivers/staging/media/Kconfig                      |   2 -
>   drivers/staging/media/Makefile                     |   1 -
>   drivers/staging/media/s5p-cec/Kconfig              |   9 --
>   drivers/staging/media/s5p-cec/TODO                 |   7 --
>   drivers/video/Kconfig                              |   3 +
>   drivers/video/Makefile                             |   1 +
>   drivers/video/hdmi-notifier.c                      | 134 +++++++++++++++++++++
>   include/linux/hdmi-notifier.h                      | 109 +++++++++++++++++
>   include/media/cec.h                                |  15 +++
>   22 files changed, 389 insertions(+), 27 deletions(-)
>   rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
>   rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
>   rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
>   rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
>   rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
>   rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
>   delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
>   delete mode 100644 drivers/staging/media/s5p-cec/TODO
>   create mode 100644 drivers/video/hdmi-notifier.c
>   create mode 100644 include/linux/hdmi-notifier.h
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

