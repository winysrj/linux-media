Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:44410 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbeB0BTM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 20:19:12 -0500
Date: Tue, 27 Feb 2018 09:18:47 +0800
From: Yong <yong.deng@magewell.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
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
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v7 2/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20180227091847.e67a1aeffff94eb37c7fff1e@magewell.com>
In-Reply-To: <ce3a30b9-f017-61b6-1fe6-f5dcc8bd3ec3@xs4all.nl>
References: <1517217696-17816-1-git-send-email-yong.deng@magewell.com>
        <c86097d7-dade-01e5-3826-3f22f9ca4b4f@infradead.org>
        <20180130104833.a06e44c558c7ddc6b38e20b3@magewell.com>
        <ce3a30b9-f017-61b6-1fe6-f5dcc8bd3ec3@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 26 Feb 2018 12:06:37 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi all,
> 
> On 01/30/2018 03:48 AM, Yong wrote:
> > Hi,
> > 
> > On Mon, 29 Jan 2018 13:49:14 -0800
> > Randy Dunlap <rdunlap@infradead.org> wrote:
> > 
> >> On 01/29/2018 01:21 AM, Yong Deng wrote:
> >>> Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> >>> interface and CSI1 is used for parallel interface. This is not
> >>> documented in datasheet but by test and guess.
> >>>
> >>> This patch implement a v4l2 framework driver for it.
> >>>
> >>> Currently, the driver only support the parallel interface. MIPI-CSI2,
> >>> ISP's support are not included in this patch.
> >>>
> >>> Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>> Signed-off-by: Yong Deng <yong.deng@magewell.com>
> >>> ---
> >>
> >>
> >> A previous version (I think v6) had a build error with the use of
> >> PHYS_OFFSET, so Kconfig was modified to depend on ARM and ARCH_SUNXI
> >> (one of which seems to be overkill).  As is here, the COMPILE_TEST piece is
> >> meaningless for all arches except ARM.  If you care enough for COMPILE_TEST
> >> (and I would), then you could make COMPILE_TEST useful on any arch by
> >> removing the "depends on ARM" (the ARCH_SUNXI takes care of that) and by
> >> having an alternate value for PHYS_OFFSET, like so:
> >>
> >> +#if defined(CONFIG_COMPILE_TEST) && !defined(PHYS_OFFSET)
> >> +#define PHYS_OFFSET	0
> >> +#endif
> >>
> >> With those 2 changes, the driver builds for me on x86_64.
> > 
> > I have considered this method.
> > But it's so sick to put these code in dirver (for my own). I mean 
> > this is meaningless for the driver itself and make people confused.
> > 
> > I grepped the driver/ code and I found many drivers writing Kconfig
> > like this. For example:
> > ARM && COMPILE_TEST
> > MIPS && COMPILE_TEST
> > PPC64 && COMPILE_TEST
> > 
> > BTW, for my own, I do not care about COMPILE_TEST.
> 
> There was a discussion about this in the v6 patch, but it petered out.
> 
> I want to merge this driver, but I would very much prefer that this
> compiles with COMPILE_TEST. So unless someone has a better solution, then
> adding 'hack' that defines PHYS_OFFSET to 0 for COMPILE_TEST would be required.

If so, I will take the advice of Randy.

> 
> Otherwise this driver looks good, so it is just this issue blocking it.
> 
> Regards,
> 
> 	Hans
> 
> > 
> >>
> >>> diff --git a/drivers/media/platform/sunxi/sun6i-csi/Kconfig b/drivers/media/platform/sunxi/sun6i-csi/Kconfig
> >>> new file mode 100644
> >>> index 0000000..f80c965
> >>> --- /dev/null
> >>> +++ b/drivers/media/platform/sunxi/sun6i-csi/Kconfig
> >>> @@ -0,0 +1,10 @@
> >>> +config VIDEO_SUN6I_CSI
> >>> +	tristate "Allwinner V3s Camera Sensor Interface driver"
> >>> +	depends on ARM
> >>> +	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> >>> +	depends on ARCH_SUNXI || COMPILE_TEST
> >>> +	select VIDEOBUF2_DMA_CONTIG
> >>> +	select REGMAP_MMIO
> >>> +	select V4L2_FWNODE
> >>> +	---help---
> >>> +	   Support for the Allwinner Camera Sensor Interface Controller on V3s.
> >>
> >> thanks,
> >> -- 
> >> ~Randy
> > 
> > 
> > Thanks,
> > Yong
> > 


Thanks,
Yong
