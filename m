Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33435 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbdFGSgs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 14:36:48 -0400
Date: Wed, 7 Jun 2017 20:36:45 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrzej Hajda <a.hajda@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 9/9] ARM: dts: exynos: add needs-hpd to &hdmicec for
 Odroid-U3
Message-ID: <20170607183645.tsjj3mb2k6fdnoei@kozik-lap>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
 <20170607144616.15247-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170607144616.15247-10-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 07, 2017 at 04:46:16PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The Odroid-U3 board has an IP4791CZ12 level shifter that is
> disabled if the HPD is low, which means that the CEC pin is
> disabled as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: devicetree@vger.kernel.org
> ---
>  arch/arm/boot/dts/exynos4412-odroidu3.dts | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> index 7504a5aa538e..7209cb48fc2a 100644
> --- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
> +++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> @@ -131,3 +131,7 @@
>  	cs-gpios = <&gpb 5 GPIO_ACTIVE_HIGH>;
>  	status = "okay";
>  };
> +
> +&hdmicec {
> +	needs-hpd;
> +};

All good, except we try to keep them sorted alphabetically (helps
avoiding conflicts and makes things easier to find)... which for this
particular file will be difficult as it is semi-sorted. :)
Anyway, how about putting this new node after &buck?

Best regards,
Krzysztof
