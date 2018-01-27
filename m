Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:37631 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753157AbeA0QO1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Jan 2018 11:14:27 -0500
Received: by mail-io0-f195.google.com with SMTP id f89so3417029ioj.4
        for <linux-media@vger.kernel.org>; Sat, 27 Jan 2018 08:14:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sat, 27 Jan 2018 17:14:26 +0100
Message-ID: <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
To: Yong Deng <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>, megous@megous.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 23, 2018 at 9:18 AM, Yong Deng <yong.deng@magewell.com> wrote:

> Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> interface and CSI1 is used for parallel interface. This is not
> documented in datasheet but by test and guess.
>
> This patch implement a v4l2 framework driver for it.
>
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
>
> Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Signed-off-by: Yong Deng <yong.deng@magewell.com>

This is cool stuff :)

> +void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> +{
> +       struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +       /* transform physical address to bus address */
> +       dma_addr_t bus_addr = addr - PHYS_OFFSET;

I am sorry if this is an unjustified drive-by comment. Maybe you
have already investigate other ways to do this.

Accessing PHYS_OFFSET directly seems unintuitive
and not good practice.

But normally an dma_addr_t only comes from some
function inside <linux/dma-mapping.h> such as:
dma_alloc_coherent() for a contigous buffer which is coherent
in physical memory, or from some buffer <= 64KB that
is switching ownership between device and CPU explicitly
with dma_map* or so. Did you check with
Documentation/DMA-API.txt?

Yours,
Linus Walleij
