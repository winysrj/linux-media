Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45636 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdDCPQK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 11:16:10 -0400
Date: Mon, 3 Apr 2017 16:15:11 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Rob Herring <robh@kernel.org>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
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
Message-ID: <20170403151511.GA7909@n2100.armlinux.org.uk>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-3-git-send-email-steve_longerbeam@mentor.com>
 <CAL_JsqJm_JjuVPcOBERCqsnjTDdNoKr9xRE9MXMO4ivxGath2Q@mail.gmail.com>
 <70bacfb5-aef1-76d1-37d2-23a524903d45@mentor.com>
 <20170403140743.trxep36s4z4piyl3@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403140743.trxep36s4z4piyl3@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 03, 2017 at 09:07:43AM -0500, Rob Herring wrote:
> On Tue, Mar 28, 2017 at 05:35:52PM -0700, Steve Longerbeam wrote:
> > I assume if there's another binding doc in progress, it means
> > someone is working on another Synopsys DW CSI-2 subdevice driver.
> 
> Yes. see http://patchwork.ozlabs.org/patch/736177/
> 
> > Unfortunately I don't have the time to contribute and switch to
> > this other subdevice, and do test/debug.
> 
> >From a DT perspective, I'm not asking that you share the subdevice 
> driver, only the binding. Simply put, there's 1 h/w block here, so there 
> should only be 1 binding. The binding is an ABI, so you can't just merge 
> it and change it later.

I think it would be nice to have some kind of standard base binding
for CSI2 interfaces, but beyond the standard compatible/reg/interrupts
and graph properties, I'm not sure what it would look like.

As far as those properties go, the iMX6 version does better than the
DW version, because we specify the full graph, whereas the DW version
only specifies the downstream link.  Once that's done, there's some
properties (like those specifying the output configuration) which
probably ought to be moved to the graph links instead, once they exist.

So, if anything, I think it's the DW version needs to be augmented with
fuller information, and some of the properties moved.

Also, as I've mentioned in my other reply, while they may both appear
to be called "Synopsys DW CSI-2" devices, they appear to be quite
different from the hardware perspective.

The rest 

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
