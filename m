Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34878 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbdDCOHq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 10:07:46 -0400
Date: Mon, 3 Apr 2017 09:07:43 -0500
From: Rob Herring <robh@kernel.org>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Benoit Parrot <bparrot@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        tiffany lin <tiffany.lin@mediatek.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Songjun Wu <songjun.wu@microchip.com>,
        Andrew-CT Chen =?utf-8?B?KOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v6 02/39] [media] dt-bindings: Add bindings for i.MX
 media driver
Message-ID: <20170403140743.trxep36s4z4piyl3@rob-hp-laptop>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-3-git-send-email-steve_longerbeam@mentor.com>
 <CAL_JsqJm_JjuVPcOBERCqsnjTDdNoKr9xRE9MXMO4ivxGath2Q@mail.gmail.com>
 <70bacfb5-aef1-76d1-37d2-23a524903d45@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70bacfb5-aef1-76d1-37d2-23a524903d45@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 28, 2017 at 05:35:52PM -0700, Steve Longerbeam wrote:
> 
> 
> On 03/28/2017 05:21 PM, Rob Herring wrote:
> > On Mon, Mar 27, 2017 at 7:40 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> > > Add bindings documentation for the i.MX media driver.
> > > 
> > > <snip>
> > > +
> > > +mipi_csi2 node
> > > +--------------
> > > +
> > > +This is the device node for the MIPI CSI-2 Receiver, required for MIPI
> > > +CSI-2 sensors.
> > > +
> > > +Required properties:
> > > +- compatible   : "fsl,imx6-mipi-csi2", "snps,dw-mipi-csi2";
> > 
> > As I mentioned in v5, there's a DW CSI2 binding in progress. This
> > needs to be based on that.
> 
> Hi Rob, I'm not sure what you are asking me to do.
> 
> I assume if there's another binding doc in progress, it means
> someone is working on another Synopsys DW CSI-2 subdevice driver.

Yes. see http://patchwork.ozlabs.org/patch/736177/

> Unfortunately I don't have the time to contribute and switch to
> this other subdevice, and do test/debug.

>From a DT perspective, I'm not asking that you share the subdevice 
driver, only the binding. Simply put, there's 1 h/w block here, so there 
should only be 1 binding. The binding is an ABI, so you can't just merge 
it and change it later.

The driver side is a decision for the V4L2 maintainers.

> For now I would prefer if this patchset is merged as is, and
> then contribute/switch to another CSI-2 subdev later. It is
> also getting very difficult managing all these patches (39 as
> of this version), and I'd prefer not to spam the lists with
> such large patchsets for too much longer.

Then maybe you should figure out how to split up the series. I've not 
looked at it to provide suggestions.

Rob
