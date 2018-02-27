Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:38658 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752573AbeB0PMZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:12:25 -0500
From: Heiko Stuebner <heiko@sntech.de>
To: =?utf-8?B?5rip5pqW?= <leo.wen@rock-chips.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        David Wu <david.wu@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "jacob2.chen@rock-chips.com" <jacob2.chen@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Eddie Cai <eddie.cai@rock-chips.com>
Subject: Re: [PATCH V2 1/2] [media] Add Rockchip RK1608 driver
Date: Tue, 27 Feb 2018 16:12:04 +0100
Message-ID: <14366388.KYv6Y7EbEA@phil>
In-Reply-To: <06296C1C-0ACB-4BB2-86DF-EBDBE3265DA4@rock-chips.com>
References: <1519632964-64257-1-git-send-email-leo.wen@rock-chips.com> <CACRpkdZDWvqrpop9FaJUidJjR8jB=Db-WztePrqKSg5Yp5gvCA@mail.gmail.com> <06296C1C-0ACB-4BB2-86DF-EBDBE3265DA4@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Leo,

Am Dienstag, 27. Februar 2018, 04:15:46 CET schrieb 温暖:
> Thank you for your advice! I will revise it according to your suggestion.

please also keep an eye on my reply to Linus' mail pointing out some
other issues where the driver should not tie into soc-specific areas
like the clock controller etc.


Thanks
Heiko

Am Dienstag, 27. Februar 2018, 04:15:46 CET schrieb 温暖:
> On 2/26/2018 18:12，Linus Walleij<linus.walleij@linaro.org>  wrote：
> On Mon, Feb 26, 2018 at 9:16 AM, Wen Nuan <leo.wen@rock-chips.com> wrote:
> +               pdata->grf_gpio2b_iomux = ioremap((resource_size_t)
>  +                                                 (GRF_BASE_ADDR +
>  +                                                  GRF_GPIO2B_IOMUX), 4);
>  +               grf_val = __raw_readl(pdata->grf_gpio2b_iomux);
>  +               __raw_writel(((grf_val) | (1 << 6) | (1 << (6 + 16))),
>  +                            pdata->grf_gpio2b_iomux);
>  +
>  +               pdata->grf_io_vsel = ioremap((resource_size_t)
>  +                                             (GRF_BASE_ADDR + GRF_IO_VSEL), 4);
>  +               grf_val = __raw_readl(pdata->grf_io_vsel);
>  +               __raw_writel(((grf_val) | (1 << 1) | (1 << (1 + 16))),
>  +                            pdata->grf_io_vsel);
> 
> You are doing pin control on the side of the pin control subsystem
> it looks like?
> 
> I think David Wu and Heiko Stubner needs to have a look at what you
> are doing here to suggest other solutions.
> 
> Apart from that, why use __raw_writel instead of just writel()?
> 
> This pin is iomux, default GPIO, need to be changed to CLK. 
> This CLK is provided to external sensor for use.
> I'll use writel().

As stated, please don't directly access soc blocks like the clock
controller or iomuxes, there are standard APIs like the general
clock API and also assigned-clock* devicetree properties.

Similarly for pinctrl access.

So there should not be any writel (or ioremap) at all in this spi driver
I'd think.


Thanks
Heiko
