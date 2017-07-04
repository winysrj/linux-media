Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-51.mail.aliyun.com ([115.124.20.51]:33221 "EHLO
        out20-51.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdGDH0J (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 03:26:09 -0400
Date: Tue, 4 Jul 2017 15:25:45 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, wens@csie.org,
        hans.verkuil@cisco.com, peter.griffin@linaro.org,
        hugues.fruchet@st.com, krzk@kernel.org, bparrot@ti.com,
        arnd@arndb.de, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RFC 1/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20170704152545.4a70f04db2c984d4d54bf9dd@magewell.com>
In-Reply-To: <20170703112521.ca253erguut5v7se@flea>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
        <1498561654-14658-2-git-send-email-yong.deng@magewell.com>
        <667c858b-2655-88c5-6bbc-9d70d06c1ff1@xs4all.nl>
        <20170703185952.18a97e9b7b05cbe321cb1268@magewell.com>
        <20170703112521.ca253erguut5v7se@flea>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 Jul 2017 13:25:21 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi,
> 
> On Mon, Jul 03, 2017 at 06:59:52PM +0800, Yong wrote:
> > > > +	select VIDEOBUF2_DMA_CONTIG
> > > > +	select REGMAP_MMIO
> > > > +	---help---
> > > > +	   Support for the Allwinner Camera Sensor Interface Controller.
> > > 
> > > This controller is the same for all Allwinner SoC models?
> > 
> > No.
> > I will change the Kconfig and Makefile.
> 
> This is basically a design that has been introduced in the A31 (sun6i
> family). I guess we should just call the driver and Kconfig symbols
> sun6i_csi (even though we don't support it yet). It also used on the
> A23, A33, A80, A83T, H3, and probably the H5 and A64.
> 
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com

Thanks for the advice. That's good.
My purpose is to make the code reusable. People working on other
Allwinner SoC could easily make their CSI working by just filling the
SoC specific code. But I'm not familiar with other Allwinner SoCs 
except V3s. I hope to get more advice.
