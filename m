Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40117 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751477AbdCPKEs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 06:04:48 -0400
Message-ID: <1489658516.2303.11.camel@pengutronix.de>
Subject: Re: media / v4l2-mc: wishlist for complex cameras (was Re: [PATCH
 v4 14/36] [media] v4l2-mc: add a function to inherit controls from a
 pipeline)
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Philippe De Muyter <phdm@macq.eu>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Date: Thu, 16 Mar 2017 11:01:56 +0100
In-Reply-To: <20170316094729.GA5595@frolo.macqel>
References: <20170311082549.576531d0@vento.lan>
         <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
         <20170314004533.3b3cd44b@vento.lan>
         <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
         <20170314072143.498cde9b@vento.lan> <20170314223254.GA7141@amd>
         <20170314215420.6fc63c67@vento.lan> <20170315105049.GA12099@frolo.macqel>
         <1489604109.4593.4.camel@ndufresne.ca>
         <1489656360.2303.2.camel@pengutronix.de>
         <20170316094729.GA5595@frolo.macqel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-03-16 at 10:47 +0100, Philippe De Muyter wrote:
> On Thu, Mar 16, 2017 at 10:26:00AM +0100, Philipp Zabel wrote:
> > On Wed, 2017-03-15 at 14:55 -0400, Nicolas Dufresne wrote:
> > > Le mercredi 15 mars 2017 à 11:50 +0100, Philippe De Muyter a écrit :
> > > > > I would say: camorama, xawtv3, zbar, google talk, skype. If it runs
> > > > > with those, it will likely run with any other application.
> > > > > 
> > > > 
> > > > I would like to add the 'v4l2src' plugin of gstreamer, and on the
> > > > imx6 its
> > > 
> > > While it would be nice if somehow you would get v4l2src to work (in
> > > some legacy/emulation mode through libv4l2),
> > 
> > v4l2src works just fine, provided the pipeline is configured manually in
> > advance via media-ctl.
> 
> Including choosing the framerate ?  Sorry, I have no time these days
> to test it myself.

No, the framerate is set with media-ctl on the CSI output pad. To really
choose the framerate, the element would indeed need a deeper
understanding of the pipeline, as the resulting framerate depends on at
least the source v4l2_subdevice (sensor) framerate and the CSI frame
skipping.

> And I cited imxv4l2videosrc for its ability to provide the physical address
> of the image buffers for further processing by other (not necessarily next
> in gstreamer pipeline, or for all frames) hardware-accelerated plugins likes
> the h.264 video encoder.  As I am stuck with fsl/nxp kernel and driver on that
> matter, I don't know how the interfaces have evolved in current linux kernels.

The physical address of the image buffers is hidden from userspace by
dma-buf objects, but those can be passed around to the next driver
without copying the image data.

regards
Philipp
