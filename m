Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:49144 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbeEDBT6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 21:19:58 -0400
Date: Fri, 4 May 2018 09:19:40 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
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
Subject: Re: [PATCH v9 0/2] Initial Allwinner V3s CSI Support
Message-Id: <20180504091940.88dbbe8eed8da931ab4bfbea@magewell.com>
In-Reply-To: <20180503171410.q52ak27u47gycy6o@flea>
References: <1520301070-48769-1-git-send-email-yong.deng@magewell.com>
        <20180503171410.q52ak27u47gycy6o@flea>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Thu, 3 May 2018 19:14:10 +0200
Maxime Ripard <maxime.ripard@bootlin.com> wrote:

> Hi Yong,
> 
> On Tue, Mar 06, 2018 at 09:51:10AM +0800, Yong Deng wrote:
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
> >   - ISP 
> >   - MIPI-CSI2
> >   - Master clock for camera sensor
> >   - Power regulator for the front end IC
> 
> Do you plan on sending another version some time soon? It would be
> awesome to have this in 4.18.

I was waiting for Sakari Ailus's feedback. But ...
I will send a new version soon. But not all suggestion from Sakari Ailus
would be accepted.

> 
> Thanks!
> Maxime
> 
> -- 
> Maxime Ripard, Bootlin (formerly Free Electrons)
> Embedded Linux and Kernel engineering
> https://bootlin.com


Thanks,
Yong
