Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34558 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752764AbdI3L6M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 30 Sep 2017 07:58:12 -0400
Received: by mail-pf0-f196.google.com with SMTP id g65so1432718pfe.1
        for <linux-media@vger.kernel.org>; Sat, 30 Sep 2017 04:58:12 -0700 (PDT)
Subject: Re: [RESEND RFC PATCH 0/7] sun8i H3 HDMI glue driver for DW HDMI
To: Jernej Skrabec <jernej.skrabec@siol.net>,
        maxime.ripard@free-electrons.com, wens@csie.org
Cc: Laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        narmstrong@baylibre.com, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        icenowy@aosc.io, linux-sunxi@googlegroups.com,
        linux-media@vger.kernel.org
References: <20170920200124.20457-1-jernej.skrabec@siol.net>
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <51c50157-6794-852b-f89d-647b9cf06ef2@ozlabs.ru>
Date: Sat, 30 Sep 2017 21:58:03 +1000
MIME-Version: 1.0
In-Reply-To: <20170920200124.20457-1-jernej.skrabec@siol.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/09/17 06:01, Jernej Skrabec wrote:
> [added media mailing list due to CEC question]
> 
> This patch series adds a HDMI glue driver for Allwinner H3 SoC. For now, only
> video and CEC functionality is supported. Audio needs more tweaks.
> 
> Series is based on the H3 DE2 patch series available on mailing list:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/522697.html
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
> 
> Chen-Yu,
> TL Lim was unable to obtain any answer from Allwinner about HDMI clocks. I think
> it is safe to assume that divider in HDMI clock doesn't have any effect.
> 
> Branch based on linux-next from 1. September with integrated patches is
> available here:
> https://github.com/jernejsk/linux-1/tree/h3_hdmi_rfc


Out of curiosity I tried this one and got:



[    0.071711] sun4i-usb-phy 1c19400.phy: Couldn't request ID GPIO
[    0.074809] sun8i-h3-pinctrl 1c20800.pinctrl: initialized sunXi PIO driver
[    0.076167] sun8i-h3-r-pinctrl 1f02c00.pinctrl: initialized sunXi PIO driver
[    0.148009] ------------[ cut here ]------------
[    0.148035] WARNING: CPU: 0 PID: 1 at
drivers/clk/sunxi-ng/ccu_common.c:41 ccu_nm_set_rate+0x1d0/0x274
[    0.148046] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
4.13.0-rc6-next-20170825-aik-aik #24
[    0.148051] Hardware name: Allwinner sun8i Family
[    0.148082] [<c010de6c>] (unwind_backtrace) from [<c010b260>]
(show_stack+0x10/0x14)
[    0.148101] [<c010b260>] (show_stack) from [<c077a464>]
(dump_stack+0x84/0x98)
[    0.148117] [<c077a464>] (dump_stack) from [<c011abe0>] (__warn+0xe0/0xfc)
[    0.148132] [<c011abe0>] (__warn) from [<c011acac>]
(warn_slowpath_null+0x20/0x28)
[    0.148145] [<c011acac>] (warn_slowpath_null) from [<c03d1888>]
(ccu_nm_set_rate+0x1d0/0x274)
[    0.148161] [<c03d1888>] (ccu_nm_set_rate) from [<c03c78b4>]
(clk_change_rate+0x19c/0x250)
[    0.148175] [<c03c78b4>] (clk_change_rate) from [<c03c7b7c>]
(clk_core_set_rate_nolock+0x68/0xb0)
[    0.148187] [<c03c7b7c>] (clk_core_set_rate_nolock) from [<c03c8134>]
(clk_set_rate+0x20/0x30)
[    0.148202] [<c03c8134>] (clk_set_rate) from [<c03cc560>]
(of_clk_set_defaults+0x200/0x364)
[    0.148219] [<c03cc560>] (of_clk_set_defaults) from [<c045427c>]
(platform_drv_probe+0x18/0xb0)
[    0.148233] [<c045427c>] (platform_drv_probe) from [<c0452efc>]
(driver_probe_device+0x234/0x2e8)
[    0.148246] [<c0452efc>] (driver_probe_device) from [<c0453068>]
(__driver_attach+0xb8/0xbc)
[    0.148258] [<c0453068>] (__driver_attach) from [<c0451414[    1.336154]
Unable to handle kernel NULL pointer dereference at virtual address 00000008

and a bit later:

[    1.995572] Rebooting in 10 seconds..

Orange PI PC, script.bin.OPI-PC_1080p60_hdmi.

What do I miss? Thanks.



-- 
Alexey
