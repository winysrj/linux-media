Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-39.mail.aliyun.com ([115.124.20.39]:56703 "EHLO
        out20-39.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdGaAsD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 20:48:03 -0400
Date: Mon, 31 Jul 2017 08:47:44 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Baruch Siach <baruch@tkos.co.il>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-Id: <20170731084744.3d8d9f632858241c54efd185@magewell.com>
In-Reply-To: <20170727122551.qca4atjeet6whfrs@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
        <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
        <20170727121644.jtpge4x432gfxhvw@tarshish>
        <20170727122551.qca4atjeet6whfrs@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Jul 2017 14:25:51 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> On Thu, Jul 27, 2017 at 03:16:44PM +0300, Baruch Siach wrote:
> > Hi Yong,
> > 
> > I managed to get the Frame Done interrupt with the previous version of this 
> > driver on the A33 OLinuXino. No data yet (all zeros). I'm still working on it.
> > 
> > One comment below.
> > 
> > On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> > > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > > and CSI1 is used for parallel interface. This is not documented in
> > > datasheet but by testing and guess.
> > > 
> > > This patch implement a v4l2 framework driver for it.
> > > 
> > > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > > ISP's support are not included in this patch.
> > > 
> > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > > ---
> > 
> > [...]
> > 
> > > +static int update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> > > +{
> > > +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> > > +	/* transform physical address to bus address */
> > > +	dma_addr_t bus_addr = addr - 0x40000000;
> > 
> > What is the source of this magic number? Is it platform dependent? Are there 
> > other devices doing DMA that need this adjustment?
> 
> This is the RAM base address in most (but not all) Allwinner
> SoCs. You'll want to use PHYS_OFFSET instead.

I have try to use PHYS_OFFSET. But I found it is not 0x40000000. I will
try it again.

> 
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com


Thanks,
Yong
