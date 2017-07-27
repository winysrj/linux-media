Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:44546 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbdG0MQu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 08:16:50 -0400
Date: Thu, 27 Jul 2017 15:16:44 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Yong Deng <yong.deng@magewell.com>
Cc: maxime.ripard@free-electrons.com,
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
Message-ID: <20170727121644.jtpge4x432gfxhvw@tarshish>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

I managed to get the Frame Done interrupt with the previous version of this 
driver on the A33 OLinuXino. No data yet (all zeros). I'm still working on it.

One comment below.

On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> and CSI1 is used for parallel interface. This is not documented in
> datasheet but by testing and guess.
> 
> This patch implement a v4l2 framework driver for it.
> 
> Currently, the driver only support the parallel interface. MIPI-CSI2,
> ISP's support are not included in this patch.
> 
> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> ---

[...]

> +static int update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> +{
> +	struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
> +	/* transform physical address to bus address */
> +	dma_addr_t bus_addr = addr - 0x40000000;

What is the source of this magic number? Is it platform dependent? Are there 
other devices doing DMA that need this adjustment?

baruch

> +
> +	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
> +		     (bus_addr + sdev->planar_offset[0]) >> 2);
> +	if (sdev->planar_offset[1] != -1)
> +		regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
> +			     (bus_addr + sdev->planar_offset[1]) >> 2);
> +	if (sdev->planar_offset[2] != -1)
> +		regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
> +			     (bus_addr + sdev->planar_offset[2]) >> 2);
> +
> +	return 0;
> +}

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
