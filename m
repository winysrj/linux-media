Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:54181 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdIUJkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 05:40:09 -0400
Subject: Re: [RESEND RFC PATCH 0/7] sun8i H3 HDMI glue driver for DW HDMI
To: Jernej Skrabec <jernej.skrabec@siol.net>,
        <maxime.ripard@free-electrons.com>, <wens@csie.org>
References: <20170920200124.20457-1-jernej.skrabec@siol.net>
CC: <Laurent.pinchart@ideasonboard.com>, <hans.verkuil@cisco.com>,
        <narmstrong@baylibre.com>, <dri-devel@lists.freedesktop.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <icenowy@aosc.io>, <linux-sunxi@googlegroups.com>,
        <linux-media@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <5172c185-c6b5-49c3-cf0a-c3e073459346@synopsys.com>
Date: Thu, 21 Sep 2017 10:39:42 +0100
MIME-Version: 1.0
In-Reply-To: <20170920200124.20457-1-jernej.skrabec@siol.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jernej,

On 20-09-2017 21:01, Jernej Skrabec wrote:
> [added media mailing list due to CEC question]
>
> This patch series adds a HDMI glue driver for Allwinner H3 SoC. For now, only
> video and CEC functionality is supported. Audio needs more tweaks.
>
> Series is based on the H3 DE2 patch series available on mailing list:
> https://urldefense.proofpoint.com/v2/url?u=http-3A__lists.infradead.org_pipermail_linux-2Darm-2Dkernel_2017-2DAugust_522697.html&d=DwIBAg&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=coyfcQKSr2asrHcaCeWFmAP_9nkFkRK8s7Uw5bmVei4&s=JCFaMXK1MmZ3jE745_YcqZhZkaqtc6UapGfSSapcz_s&e= 
> (ignore patches marked with [NOT FOR REVIEW NOW] tag)
>
> Patch 1 adds support for polling plug detection since custom PHY used here
> doesn't support HPD interrupt.
>
> Patch 2 enables overflow workaround for v1.32a. This HDMI controller exhibits
> same issues as HDMI controller used in iMX6 SoCs.
>
> Patch 3 adds CLK_SET_RATE_PARENT to hdmi clock.
>
> Patch 4 adds dt bindings documentation.
>
> Patch 5 adds actual H3 HDMI glue driver.
>
> Patch 6 and 7 add HDMI node to DT and enable it where needed.
>
> Allwinner used DW HDMI controller in a non standard way:
> - register offsets obfuscation layer, which can fortunately be turned off
> - register read lock, which has to be disabled by magic number
> - custom PHY, which have to be initialized before DW HDMI controller
> - non standard clocks
> - no HPD interrupt
>
> Because of that, I have two questions:
> - Since HPD have to be polled, is it enough just to enable poll mode? I'm
>   mainly concerned about invalidating CEC address here.

You mean you get no interrupt when HPD status changes? Hans can
answer this better but then you will need to invalidate the cec
physical address yourself because right now its invalidated in
the dw-hdmi irq handler (see dw_hdmi_irq()).

> - PHY has to be initialized before DW HDMI controller to disable offset
>   obfuscation and read lock among other things. This means that all clocks have
>   to be enabled in glue driver. This poses a problem, since when using
>   component model, dw-hdmi bridge uses drvdata for it's own private data and
>   prevents glue layer to pass a pointer to unbind function, where clocks should
>   be disabled. I noticed same issue in meson DW HDMI glue driver, where clocks
>   are also not disabled when unbind callback is called. I noticed that when H3
>   SoC is shutdown, HDMI output is still enabled and lastest image is shown on
>   monitor until it is unplugged from power supply. Is there any simple solution
>   to this?

I don't know if you can use an empty platform device created with
platform_device_alloc(). Perhaps it would be better fix this in
the dw-hdmi driver. I see two solutions:

    - Either you return the dw-hdmi private structure in the bind
callback, store it and pass it in the unbind
    - Or, you pass your own private data to the dw-hdmi bind, the
dw-hdmi stores it and you just create a public function in the
dw-hdmi driver called like dw_hdmi_get_auxdata(struct device
*dev) which returns your private data.

I think first option is nice, maybe anyone else can suggest
something better?

Best regards,
Jose Miguel Abreu

>
> Chen-Yu,
> TL Lim was unable to obtain any answer from Allwinner about HDMI clocks. I think
> it is safe to assume that divider in HDMI clock doesn't have any effect.
>
> Branch based on linux-next from 1. September with integrated patches is
> available here:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_jernejsk_linux-2D1_tree_h3-5Fhdmi-5Frfc&d=DwIBAg&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=coyfcQKSr2asrHcaCeWFmAP_9nkFkRK8s7Uw5bmVei4&s=lDAnd3egsc2sxqVM-Ya_Me9ozWXKWvxxvsdV3Jn3vpA&e= 
>
> Some additonal info about H3 HDMI:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__linux-2Dsunxi.org_DWC-5FHDMI-5FController&d=DwIBAg&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=coyfcQKSr2asrHcaCeWFmAP_9nkFkRK8s7Uw5bmVei4&s=d9iEgk23RCLJL4oXJ4kkt6NyYK90_vFy0mCD3WauJDk&e= 
>
> Thanks to Jens Kuske, who figured out that it is actually DW HDMI controller
> and mapped scrambled register offsets to original ones.
>
> Icenowy Zheng (1):
>   ARM: sun8i: h3: Add DesignWare HDMI controller node
>
> Jernej Skrabec (6):
>   drm: bridge: Enable polling hpd event in dw_hdmi
>   drm: bridge: Enable workaround in dw_hdmi for v1.32a
>   clk: sunxi: Add CLK_SET_RATE_PARENT flag for H3 HDMI clock
>   dt-bindings: Document Allwinner DWC HDMI TX node
>   drm: sun4i: Add a glue for the DesignWare HDMI controller in H3
>   ARM: sun8i: h3: Enable HDMI output on H3 boards
>
>  .../bindings/display/sunxi/sun4i-drm.txt           | 158 ++++++-
>  arch/arm/boot/dts/sun8i-h3-bananapi-m2-plus.dts    |  33 ++
>  arch/arm/boot/dts/sun8i-h3-beelink-x2.dts          |  33 ++
>  arch/arm/boot/dts/sun8i-h3-nanopi-m1.dts           |  33 ++
>  arch/arm/boot/dts/sun8i-h3-orangepi-2.dts          |  33 ++
>  arch/arm/boot/dts/sun8i-h3-orangepi-lite.dts       |  33 ++
>  arch/arm/boot/dts/sun8i-h3-orangepi-one.dts        |  33 ++
>  arch/arm/boot/dts/sun8i-h3-orangepi-pc.dts         |  33 ++
>  arch/arm/boot/dts/sun8i-h3.dtsi                    |   5 +
>  arch/arm/boot/dts/sunxi-h3-h5.dtsi                 |  36 ++
>  drivers/clk/sunxi-ng/ccu-sun8i-h3.c                |   2 +-
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |  14 +-
>  drivers/gpu/drm/sun4i/Kconfig                      |   9 +
>  drivers/gpu/drm/sun4i/Makefile                     |   1 +
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              | 500 +++++++++++++++++++++
>  15 files changed, 950 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
>
