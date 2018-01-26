Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-25.mail.aliyun.com ([115.124.20.25]:58512 "EHLO
        out20-25.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbeAZBrb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 20:47:31 -0500
Date: Fri, 26 Jan 2018 09:46:58 +0800
From: Yong <yong.deng@magewell.com>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linus Walleij <linus.walleij@linaro.org>,
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
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, megous@megous.com
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
In-Reply-To: <201801260759.RyNhDZz4%fengguang.wu@intel.com>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
        <201801260759.RyNhDZz4%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Do you have any experience in solving this problem?
It seems the PHYS_OFFSET maybe undeclared when the ARCH is not arm.

On Fri, 26 Jan 2018 08:04:18 +0800
kbuild test robot <lkp@intel.com> wrote:

> Hi Yong,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.15-rc9 next-20180119]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Yong-Deng/dt-bindings-media-Add-Allwinner-V3s-Camera-Sensor-Interface-CSI/20180126-054511
> base:   git://linuxtv.org/media_tree.git master
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c: In function 'sun6i_csi_update_buf_addr':
> >> drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c:567:31: error: 'PHYS_OFFSET' undeclared (first use in this function); did you mean 'PAGE_OFFSET'?
>      dma_addr_t bus_addr = addr - PHYS_OFFSET;
>                                   ^~~~~~~~~~~
>                                   PAGE_OFFSET
>    drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c:567:31: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +567 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
> 
>    562	
>    563	void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
>    564	{
>    565		struct sun6i_csi_dev *sdev = sun6i_csi_to_dev(csi);
>    566		/* transform physical address to bus address */
>  > 567		dma_addr_t bus_addr = addr - PHYS_OFFSET;
>    568	
>    569		regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
>    570			     (bus_addr + sdev->planar_offset[0]) >> 2);
>    571		if (sdev->planar_offset[1] != -1)
>    572			regmap_write(sdev->regmap, CSI_CH_F1_BUFA_REG,
>    573				     (bus_addr + sdev->planar_offset[1]) >> 2);
>    574		if (sdev->planar_offset[2] != -1)
>    575			regmap_write(sdev->regmap, CSI_CH_F2_BUFA_REG,
>    576				     (bus_addr + sdev->planar_offset[2]) >> 2);
>    577	}
>    578	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


Thanks,
Yong
