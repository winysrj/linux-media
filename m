Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36506 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933397AbeBLLAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 06:00:06 -0500
Subject: Re: [PATCH v5 0/6] IR support for A83T
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
References: <20180130174656.10657-1-embed3d@gmail.com>
Message-ID: <a1ce4422-33d7-1214-6527-0d299e97fe8b@gmail.com>
Date: Mon, 12 Feb 2018 12:00:02 +0100
MIME-Version: 1.0
In-Reply-To: <20180130174656.10657-1-embed3d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 30.01.2018 18:46, Philipp Rossak wrote:
> This patch series adds support for the sunxi A83T ir module and enhances
> the sunxi-ir driver. Right now the base clock frequency for the ir driver
> is a hard coded define and is set to 8 MHz.
> This works for the most common ir receivers. On the Sinovoip Bananapi M3
> the ir receiver needs, a 3 MHz base clock frequency to work without
> problems with this driver.
> 
> This patch series adds support for an optinal property that makes it able
> to override the default base clock frequency and enables the ir interface
> on the a83t and the Bananapi M3.
> 
> changes since v4:
> * rename cir pin from cir_pins to r_cir_pin
> * drop unit-adress from r_cir_pin
> * add a83t compatible to the cir node
> * move muxing options to dtsi
> * rename cir label and reorder it in the bananpim3.dts file
> 
> changes since v3:
> * collecting all acks & reviewd by
> * fixed typos
> 
> changes since v2:
> * reorder cir pin (alphabetical)
> * fix typo in documentation
> 
> changes since v1:
> * fix typos, reword Documentation
> * initialize 'b_clk_freq' to 'SUNXI_IR_BASE_CLK' & remove if statement
> * change dev_info() to dev_dbg()
> * change naming to cir* in dts/dtsi
> * Added acked Ackedi-by to related patch
> * use whole memory block instead of registers needed + fix for h3/h5
> 
> changes since rfc:
> * The property is now optinal. If the property is not available in
>    the dtb the driver uses the default base clock frequency.
> * the driver prints out the the selected base clock frequency.
> * changed devicetree property from base-clk-frequency to clock-frequency
> 
> Regards,
> Philipp
> 
> Philipp Rossak (6):
>    media: rc: update sunxi-ir driver to get base clock frequency from
>      devicetree
>    media: dt: bindings: Update binding documentation for sunxi IR
>      controller
>    arm: dts: sun8i: a83t: Add the cir pin for the A83T
>    arm: dts: sun8i: a83t: Add support for the cir interface
>    arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
>    arm: dts: sun8i: h3-h5: ir register size should be the whole memory
>      block
> 
>   Documentation/devicetree/bindings/media/sunxi-ir.txt |  3 +++
>   arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts         |  5 +++++
>   arch/arm/boot/dts/sun8i-a83t.dtsi                    | 18 ++++++++++++++++++
>   arch/arm/boot/dts/sunxi-h3-h5.dtsi                   |  2 +-
>   drivers/media/rc/sunxi-cir.c                         | 19 +++++++++++--------
>   5 files changed, 38 insertions(+), 9 deletions(-)
> 

Hey,

RC1 is now out, thus I would like to ask you to have a look at this 
patch series again. Some patches still miss an acked-by. It would be 
nice if we could schedule this for v4.17.

Thanks,
Philipp
