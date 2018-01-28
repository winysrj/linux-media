Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-27.mail.aliyun.com ([115.124.20.27]:42786 "EHLO
        out20-27.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbeA1CkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Jan 2018 21:40:12 -0500
Date: Sun, 28 Jan 2018 10:39:29 +0800
From: Yong <yong.deng@magewell.com>
To: Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20180128103929.421eb809821f101ee1c6cb60@magewell.com>
In-Reply-To: <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
        <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, 27 Jan 2018 17:14:26 +0100
Linus Walleij <linus.walleij@linaro.org> wrote:

> On Tue, Jan 23, 2018 at 9:18 AM, Yong Deng <yong.deng@magewell.com> wrote:
> 
> > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > interface and CSI1 is used for parallel interface. This is not
> > documented in datasheet but by test and guess.
> >
> > This patch implement a v4l2 framework driver for it.
> >
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> >
> > Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> 
> This is cool stuff :)
> 
> > +void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> > +{
> > +       struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > +       /* transform physical address to bus address */
> > +       dma_addr_t bus_addr = addr - PHYS_OFFSET;
> 
> I am sorry if this is an unjustified drive-by comment. Maybe you
> have already investigate other ways to do this.
> 
> Accessing PHYS_OFFSET directly seems unintuitive
> and not good practice.
> 
> But normally an dma_addr_t only comes from some
> function inside <linux/dma-mapping.h> such as:
> dma_alloc_coherent() for a contigous buffer which is coherent
> in physical memory, or from some buffer <= 64KB that
> is switching ownership between device and CPU explicitly
> with dma_map* or so. Did you check with
> Documentation/DMA-API.txt?

The dma_addr_t here comes from v4l2 vb2 and it's already 'mapped'.

Maybe the dma-mapping code of sunXi does not do conversion between 
device and CPU. I'm not familiar with this. 

Maxime, do you have any idea about this?
Can we get bus address directly from dma_alloc_coherent or dma_map*
at the system layer but not doing the conversion per driver?

Yong
