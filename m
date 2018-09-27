Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-15.mail.aliyun.com ([115.124.20.15]:49724 "EHLO
        out20-15.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbeI0HPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 03:15:20 -0400
Date: Thu, 27 Sep 2018 08:59:23 +0800
From: Yong <yong.deng@magewell.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: maxime.ripard@bootlin.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Thierry Reding <treding@nvidia.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v11 1/2] dt-bindings: media: Add Allwinner V3s Camera
 Sensor Interface (CSI)
Message-Id: <20180927085923.cf24d7e2fba7f38637aff7c4@magewell.com>
In-Reply-To: <1568838.d8CnAYTeDB@avalon>
References: <1537951204-24672-1-git-send-email-yong.deng@magewell.com>
        <7197338.mhOH8fQaEM@avalon>
        <20180926103547.5ubb6xjkl7xngmfg@flea>
        <1568838.d8CnAYTeDB@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 26 Sep 2018 13:38:08 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> Hi Maxime,
> 
> On Wednesday, 26 September 2018 13:35:47 EEST maxime.ripard@bootlin.com wrote:
> > On Wed, Sep 26, 2018 at 01:19:34PM +0300, Laurent Pinchart wrote:
> > > > +Endpoint node properties for CSI1
> > > > +---------------------------------
> > > 
> > > Should you list the CSI0 properties as well ? As the driver in patch 2/2
> > > doesn't support the CSI-2 interface I assume you have left out CSI0 for
> > > now, but it should still be listed in the bindings. I'm fine with fixing
> > > this as a follow-up patch to avoid missing the v4.20 merge window, but if
> > > you end up resubmitting the series, could you please address the problem
> > > ?
> > 
> > That driver is not available, and the documentation isn't either, so
> > there's no easy way to tell which properties are going to be needed
> > before doing the actual work of reverse engineering it and writing a
> > driver for it. Unfortunately...
> 
> While DT bindings should be independent from driver implementations, I agree 
> it's difficult to develop good bindings without hardware documentation and 
> without at least one working driver implementation.
> 
> How about just explicitly stating that these bindings don't support CSI0 yet ?

OK.

Thanks,
Yong
