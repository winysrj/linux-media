Return-path: <linux-media-owner@vger.kernel.org>
Received: from dliviu.plus.com ([80.229.23.120]:53144 "EHLO smtp.dudau.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752189AbeAaOr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 09:47:56 -0500
Date: Wed, 31 Jan 2018 14:47:53 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Yong <yong.deng@magewell.com>, kbuild test robot <lkp@intel.com>,
        kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
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
Subject: Re: [linux-sunxi] Re: [PATCH v6 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-ID: <20180131144753.GB19945@bart.dudau.co.uk>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <201801260759.RyNhDZz4%fengguang.wu@intel.com>
 <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
 <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
 <20180131030807.GA19945@bart.dudau.co.uk>
 <20180131074212.7hvb3nqkt22h2chg@flea.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180131074212.7hvb3nqkt22h2chg@flea.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 31, 2018 at 08:42:12AM +0100, Maxime Ripard wrote:
> Hi Liviu,

Hi Maxime,

> 
> On Wed, Jan 31, 2018 at 03:08:08AM +0000, Liviu Dudau wrote:
> > On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> > > Hi Maxime,
> > > 
> > > On Fri, 26 Jan 2018 09:46:58 +0800
> > > Yong <yong.deng@magewell.com> wrote:
> > > 
> > > > Hi Maxime,
> > > > 
> > > > Do you have any experience in solving this problem?
> > > > It seems the PHYS_OFFSET maybe undeclared when the ARCH is not arm.
> > > 
> > > Got it.
> > > Should I add 'depends on ARM' in Kconfig?
> > 
> > No, I don't think you should do that, you should fix the code.
> > 
> > The dma_addr_t addr that you've got is ideally coming from dma_alloc_coherent(),
> > in which case the addr is already "suitable" for use by the device (because the
> > bus where the device is attached to does all the address translations).
> 
> Like we're discussing in that other part of the thread with Thierry
> and Arnd, things are slightly more complicated than that :)

Yeah, sorry, my threading of the discussion was broken and I've seen the rest of the 
thread after I have replied. My bad!

> 
> In our case, the bus where the device is attached will not do the
> address translations, and shouldn't.

In my view, the bus is already doing address translation at physical level, AFAIU it
remaps the memory to zero. What you (we?) need is a simple bus driver that registers
the correct virt_to_bus()/bus_to_virt() hooks for the device that do this translation
at the DMA API level as well.

> 
> > If you apply PHYS_OFFSET forcefully to it you might get unexpected
> > results.
> 
> Out of curiosity, what would be these unexpected results?

If in the future (or a parallel world setup) the device is sitting behind an IOMMU, the
addr value might well be smaller than PHYS_OFFSET and you will under-wrap, possibly
starting to hit kernel physical addresses (or anything sitting at the top of the physical
memory).

>From my time playing with IOMMUs and PCI domains, I've learned to treat the dma_addr_t as
a cookie value and never try to do arithmetics with it.

Best regards,
Liviu

> 
> Thanks!
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
> 
> -- 
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
