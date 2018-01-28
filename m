Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:47518 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbeA1CTs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Jan 2018 21:19:48 -0500
Date: Sun, 28 Jan 2018 10:19:03 +0800
From: Yong <yong.deng@magewell.com>
To: maxime.ripard@free-electrons.com
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
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
Subject: Re: [linux-sunxi] Re: [PATCH v6 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-Id: <20180128101903.fbaec083c787bda30aeb05ef@magewell.com>
In-Reply-To: <20180126081000.hy7g57zp5dv6ug2g@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
        <201801260759.RyNhDZz4%fengguang.wu@intel.com>
        <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
        <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
        <20180126081000.hy7g57zp5dv6ug2g@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Fri, 26 Jan 2018 09:10:00 +0100
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> > Hi Maxime,
> > 
> > On Fri, 26 Jan 2018 09:46:58 +0800
> > Yong <yong.deng@magewell.com> wrote:
> > 
> > > Hi Maxime,
> > > 
> > > Do you have any experience in solving this problem?
> > > It seems the PHYS_OFFSET maybe undeclared when the ARCH is not arm.
> > 
> > Got it.
> > Should I add 'depends on ARM' in Kconfig?
> 
> Yes, or even better a depends on MACH_SUNXI :)

Do you mean ARCH_SUNXI?

ARCH_SUNXI is alreay there. In the early version, my Kconfig is like this:

	depends on ARCH_SUNXI

But Hans suggest me to change this to:

	depends on ARCH_SUNXI || COMPILE_TEST

to allow this driver to be compiled on e.g. Intel for compile testing.

Should we get rid of COMPILE_TEST?

Yong
