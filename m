Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45536 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdCSOZL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 10:25:11 -0400
Date: Sun, 19 Mar 2017 14:21:10 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170319142110.GT21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <20170318192258.GL21222@n2100.armlinux.org.uk>
 <aef6c412-5464-726b-42f6-a24b7323aa9c@mentor.com>
 <20170318204324.GM21222@n2100.armlinux.org.uk>
 <4e7f91fa-e1c4-1cbc-2542-2aaf19a35329@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e7f91fa-e1c4-1cbc-2542-2aaf19a35329@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 19, 2017 at 03:57:56PM +0200, Vladimir Zapolskiy wrote:
> Hi Russell,
> 
> On 03/18/2017 10:43 PM, Russell King - ARM Linux wrote:
> > On Sat, Mar 18, 2017 at 12:58:27PM -0700, Steve Longerbeam wrote:
> >> Can you share your gstreamer pipeline? For now, until
> >> VIDIOC_ENUM_FRAMESIZES is implemented, try a pipeline that
> >> does not attempt to specify a frame rate. I use the attached
> >> script for testing, which works for me.
> > 
> > It's nothing more than
> > 
> >   gst-launch-1.0 -v v4l2src ! <any needed conversions> ! xvimagesink
> > 
> > in my case, the conversions are bayer2rgbneon.  However, this only shows
> > you the frame rate negotiated on the pads (which is actually good enough
> > to show the issue.)
> 
> I'm sorry for potential offtopic, but is bayer2rgbneon element found in
> any officially supported by GStreamer plugin?

No it isn't.  Google is wonderful, please make use of planetary search
facilities.

> Can it be a point of failure?

There's a good reason why I dumped a full debug log using GST_DEBUG=*:9,
analysed it for the cause of the failure, and tried several different
pipelines, including the standard bayer2rgb plugin.

Please don't blame this on random stuff after analysis of the logs _and_
reading the appropriate plugin code has shown where the problem is.  I
know gstreamer can be very complex, but it's very possible to analyse
the cause of problems and pin them down with detailed logs in conjunction
with the source code.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
