Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:45117 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbeIJIHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 04:07:25 -0400
Date: Mon, 10 Sep 2018 11:14:52 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thierry Reding <treding@nvidia.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v10 0/2] Initial Allwinner V3s CSI Support
Message-Id: <20180910111452.052358a7c5cb789473b8a571@magewell.com>
In-Reply-To: <20180907132311.g7q3zzziiagqecae@flea>
References: <20180517090224.u3ygdzjr77im2mmp@flea>
        <20180529095757.qkz7jyuxza7movbc@flea.home>
        <20180530091934.tbd6xbyr5s3ipn3v@paasikivi.fi.intel.com>
        <CAGb2v67RP8bjObBJu_1JsREUo64hnEzptG_n-aYMn4Dcd_Zo-g@mail.gmail.com>
        <20180907132311.g7q3zzziiagqecae@flea>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Fri, 7 Sep 2018 15:23:11 +0200
Maxime Ripard <maxime.ripard@bootlin.com> wrote:

> Hi Yong,
> 
> On Wed, Jun 20, 2018 at 12:45:03PM +0800, Chen-Yu Tsai wrote:
> > On Wed, May 30, 2018 at 5:19 PM, Sakari Ailus
> > <sakari.ailus@linux.intel.com> wrote:
> > > On Tue, May 29, 2018 at 11:57:57AM +0200, Maxime Ripard wrote:
> > >> On Thu, May 17, 2018 at 11:02:24AM +0200, Maxime Ripard wrote:
> > >> > On Fri, May 04, 2018 at 02:44:08PM +0800, Yong Deng wrote:
> > >> > > This patchset add initial support for Allwinner V3s CSI.
> > >> > >
> > >> > > Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
> > >> > > interface and CSI1 is used for parallel interface. This is not
> > >> > > documented in datasheet but by test and guess.
> > >> > >
> > >> > > This patchset implement a v4l2 framework driver and add a binding
> > >> > > documentation for it.
> > >> > >
> > >> > > Currently, the driver only support the parallel interface. And has been
> > >> > > tested with a BT1120 signal which generating from FPGA. The following
> > >> > > fetures are not support with this patchset:
> > >> > >   - ISP
> > >> > >   - MIPI-CSI2
> > >> > >   - Master clock for camera sensor
> > >> > >   - Power regulator for the front end IC
> > >> >
> > >> > I tested it on my H3 with a parallel camera, and it still works. Thanks!
> > >> >
> > >> > Hans, Sakari, any chance this might land in 4.18?
> > >>
> > >> Ping?
> > >
> > > I'll try to look into this soonish but it seems to be too late for 4.18.
> > > Sorry about that.
> > 
> > Can we get this into 4.19?
> 
> Did you have some time to make the changes Sakari asked for? That
> would be great to have it in 4.20.

Sorry. I've been busy lately.
And I am still thinking about how to deal with it. I have some ideas.
But I think all of them are not good enough. I plan to study the 
relevant knowledge and try to find a little better solution.

Thanks,
Yong
