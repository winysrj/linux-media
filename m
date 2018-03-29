Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:47908 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeC2BDT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 21:03:19 -0400
Date: Thu, 29 Mar 2018 09:02:56 +0800
From: Yong <yong.deng@magewell.com>
To: Martin Kelly <mkelly@xevo.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v9 0/2] Initial Allwinner V3s CSI Support
Message-Id: <20180329090256.e9621262cf069c475a706087@magewell.com>
In-Reply-To: <9b60dee0-2504-6ae3-fda3-64c4458025c3@xevo.com>
References: <1520301070-48769-1-git-send-email-yong.deng@magewell.com>
        <9b60dee0-2504-6ae3-fda3-64c4458025c3@xevo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 28 Mar 2018 16:29:47 -0700
Martin Kelly <mkelly@xevo.com> wrote:

> On 03/05/2018 05:51 PM, Yong Deng wrote:
> > This patchset add initial support for Allwinner V3s CSI.
> > 
> > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > interface and CSI1 is used for parallel interface. This is not
> > documented in datasheet but by test and guess.
> > 
> > This patchset implement a v4l2 framework driver and add a binding
> > documentation for it.
> > 
> > Currently, the driver only support the parallel interface. And has been
> > tested with a BT1120 signal which generating from FPGA. The following
> > fetures are not support with this patchset:
> >    - ISP
> >    - MIPI-CSI2
> >    - Master clock for camera sensor
> >    - Power regulator for the front end IC
> > 
> 
> Hi Yong,
> 
> Thanks so much, this driver is a great contribution!
> 
> Unfortunately the board I'm working with (nanopi neo air) uses the MIPI 
> CSI-2 CSI0 interface rather than CSI1. Do you have any plans to support 
> the MIPI CSI-2 interface at some point? If not, do you know the scope of 
> what would be involved?

AFAIK, there is no document about MIPI CSI-2. You can take a look at the
source code in BSP:
https://github.com/friendlyarm/h3_lichee/tree/master/linux-3.4/drivers/media/video/sunxi-vfe/mipi_csi
And try to port it to mainline.

Thanks,
Yong
