Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33313 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933392AbdC3ViY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 17:38:24 -0400
Date: Fri, 31 Mar 2017 00:38:19 +0300
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 07/11] s5p-cec: add cec-notifier support, move out of
 staging
Message-ID: <20170330213819.ccgsdo4h37bl5skg@kozik-lap>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
 <20170329141543.32935-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170329141543.32935-8-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 04:15:39PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> By using the CEC notifier framework there is no longer any reason
> to manually set the physical address. This was the one blocking
> issue that prevented this driver from going out of staging, so do
> this move as well.
> 
> Update the bindings documenting the new hdmi phandle and
> update exynos4.dtsi accordingly.
> 
> Tested with my Odroid U3.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: linux-samsung-soc@vger.kernel.org
> CC: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/media/platform/Kconfig                     | 18 +++++++++++
>  drivers/media/platform/Makefile                    |  1 +
>  .../media => media/platform}/s5p-cec/Makefile      |  0
>  .../platform}/s5p-cec/exynos_hdmi_cec.h            |  0
>  .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |  0
>  .../media => media/platform}/s5p-cec/regs-cec.h    |  0
>  .../media => media/platform}/s5p-cec/s5p_cec.c     | 35 ++++++++++++++++++----
>  .../media => media/platform}/s5p-cec/s5p_cec.h     |  3 ++
>  drivers/staging/media/Kconfig                      |  2 --
>  drivers/staging/media/Makefile                     |  1 -
>  drivers/staging/media/s5p-cec/Kconfig              |  9 ------
>  drivers/staging/media/s5p-cec/TODO                 |  7 -----
>  12 files changed, 52 insertions(+), 24 deletions(-)
>  rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
>  rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
>  delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
>  delete mode 100644 drivers/staging/media/s5p-cec/TODO
> 

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
