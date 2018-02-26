Return-path: <linux-media-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:46488 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750969AbeBZPuY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 10:50:24 -0500
From: Heiko Stuebner <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Wen Nuan <leo.wen@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        jacob2.chen@rock-chips.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Eddie Cai <eddie.cai@rock-chips.com>
Subject: Re: [PATCH V2 1/2] [media] Add Rockchip RK1608 driver
Date: Mon, 26 Feb 2018 16:15:44 +0100
Message-ID: <3613277.0XuNfbW5nk@phil>
In-Reply-To: <CACRpkdZDWvqrpop9FaJUidJjR8jB=Db-WztePrqKSg5Yp5gvCA@mail.gmail.com>
References: <1519632964-64257-1-git-send-email-leo.wen@rock-chips.com> <1519632964-64257-2-git-send-email-leo.wen@rock-chips.com> <CACRpkdZDWvqrpop9FaJUidJjR8jB=Db-WztePrqKSg5Yp5gvCA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

thanks for catching these things :-) .

Am Montag, 26. Februar 2018, 11:12:30 CET schrieb Linus Walleij:
> On Mon, Feb 26, 2018 at 9:16 AM, Wen Nuan <leo.wen@rock-chips.com> wrote:
> > +               pdata->grf_gpio2b_iomux = ioremap((resource_size_t)
> > +                                                 (GRF_BASE_ADDR +
> > +                                                  GRF_GPIO2B_IOMUX), 4);
> > +               grf_val = __raw_readl(pdata->grf_gpio2b_iomux);
> > +               __raw_writel(((grf_val) | (1 << 6) | (1 << (6 + 16))),
> > +                            pdata->grf_gpio2b_iomux);
> > +
> > +               pdata->grf_io_vsel = ioremap((resource_size_t)
> > +                                             (GRF_BASE_ADDR + GRF_IO_VSEL), 4);
> > +               grf_val = __raw_readl(pdata->grf_io_vsel);
> > +               __raw_writel(((grf_val) | (1 << 1) | (1 << (1 + 16))),
> > +                            pdata->grf_io_vsel);
> 
> You are doing pin control on the side of the pin control subsystem
> it looks like?
> 
> I think David Wu and Heiko Stubner needs to have a look at what you
> are doing here to suggest other solutions.

Especially as the rk1608 seems to be some a spi-connected peripheral.
So it should definitly not touch _any_ soc-specific registers at all.

I just looked up the patch in patchwork and apart from the one Linus
quoted above, I found quite a bit more open-coded pinctrl settings
as well as direct writes to the clock controller and even io-voltage
selections.

All these things are highly soc-specific so vary with each soc this
ic gets connected to and the kernel does provide abstractions for
all of them. For clock-rates there are the clock-apis and also
the assigned-clock* properties for the devicetree, pinctrl supports
multiple states and io-vsel selections normally should just monitor
the supply-regulator via the io-domain driver we already have
[See vqmmc handling in for sd-cards for example].

So this driver should not touch anything of that sort and therefore
should _not_ contain any iomem-based read or write at all.


Heiko
