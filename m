Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:53972 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdLLKvP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 05:51:15 -0500
From: Heiko Stuebner <heiko@sntech.de>
To: linux-rockchip@lists.infradead.org
Cc: Leo Wen <leo.wen@rock-chips.com>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, rdunlap@infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        eddie.cai@rock-chips.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: Document the Rockchip RK1608 bindings
Date: Tue, 12 Dec 2017 11:50:41 +0100
Message-ID: <1720708.Qj5c0Lsxha@phil>
In-Reply-To: <1513060095-29588-3-git-send-email-leo.wen@rock-chips.com>
References: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com> <1513060095-29588-3-git-send-email-leo.wen@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Leo,

Am Dienstag, 12. Dezember 2017, 14:28:15 CET schrieb Leo Wen:
> +Optional properties:
> +
> +- spi-max-frequency	: Maximum SPI clocking speed of the device;
> +			        (for RK1608)
> +- spi-min-frequency	: Minimum SPI clocking speed of the device;
> +			        (for RK1608)

There is no general spi-min-frequency property specified and I also guess
systems would try to use a frequency close to maximum anyway, so I don't
really see the use of specifying a minimum frequency.


> +&pinctrl {
> +	rk1608_irq_gpios {
> +		rk1608_irq_gpios: rk1608_irq_gpios {
> +			rockchip,pins = <6 2 RK_FUNC_GPIO &pcfg_pull_none>;
> +			rockchip,pull = <1>;
> +		};
> +	};

There is no need to specify the soc-specific pinctrl settings in a general
devicetree example and you're using properties from your vendor-tree
like the rockchip,pull one ... that are not used in the mainline kernel.

So I'd suggest dropping the whole &pinctrl from the example.


Heiko
