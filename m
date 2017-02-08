Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33760 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdBIAYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 19:24:13 -0500
Date: Wed, 8 Feb 2017 17:17:08 -0600
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv4 8/9] stih-cec: add HPD notifier support
Message-ID: <20170208231708.gei5j5jmus4rsham@rob-hp-laptop>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
 <20170206102951.12623-9-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206102951.12623-9-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 06, 2017 at 11:29:50AM +0100, Hans Verkuil wrote:
> From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> 
> By using the HPD notifier framework there is no longer any reason
> to manually set the physical address. This was the one blocking
> issue that prevented this driver from going out of staging, so do
> this move as well.
> 
> Update the bindings documentation the new hdmi phandle.
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> CC: devicetree@vger.kernel.org
> ---
>  .../devicetree/bindings/media/stih-cec.txt         |  2 ++
>  drivers/media/platform/Kconfig                     | 10 +++++++
>  drivers/media/platform/Makefile                    |  1 +
>  .../st-cec => media/platform/sti/cec}/Makefile     |  0
>  .../st-cec => media/platform/sti/cec}/stih-cec.c   | 31 +++++++++++++++++++---
>  drivers/staging/media/Kconfig                      |  2 --
>  drivers/staging/media/Makefile                     |  1 -
>  drivers/staging/media/st-cec/Kconfig               |  8 ------
>  drivers/staging/media/st-cec/TODO                  |  7 -----
>  9 files changed, 41 insertions(+), 21 deletions(-)
>  rename drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile (100%)
>  rename drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c (93%)
>  delete mode 100644 drivers/staging/media/st-cec/Kconfig
>  delete mode 100644 drivers/staging/media/st-cec/TODO
> 
> diff --git a/Documentation/devicetree/bindings/media/stih-cec.txt b/Documentation/devicetree/bindings/media/stih-cec.txt
> index 71c4b2f4bcef..7d82121d148a 100644
> --- a/Documentation/devicetree/bindings/media/stih-cec.txt
> +++ b/Documentation/devicetree/bindings/media/stih-cec.txt
> @@ -9,6 +9,7 @@ Required properties:
>   - pinctrl-names: Contains only one value - "default"
>   - pinctrl-0: Specifies the pin control groups used for CEC hardware.
>   - resets: Reference to a reset controller
> + - st,hdmi-handle: Phandle to the HMDI controller

2 cases in this series. Just drop the vendor prefix on both.

s/HMDI/HDMI/

>  
>  Example for STIH407:
>  
> @@ -22,4 +23,5 @@ sti-cec@094a087c {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_cec0_default>;
>  	resets = <&softreset STIH407_LPM_SOFTRESET>;
> +	st,hdmi-handle = <&hdmi>;
>  };
