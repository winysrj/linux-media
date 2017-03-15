Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:52847 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdCOLBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 07:01:05 -0400
Date: Wed, 15 Mar 2017 11:50:49 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Pavel Machek <pavel@ucw.cz>, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
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
Subject: Re: media / v4l2-mc: wishlist for complex cameras (was Re: [PATCH
        v4 14/36] [media] v4l2-mc: add a function to inherit controls from
        a pipeline)
Message-ID: <20170315105049.GA12099@frolo.macqel>
References: <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl> <20170310125342.7f047acf@vento.lan> <20170310223714.GI3220@valkosipuli.retiisi.org.uk> <20170311082549.576531d0@vento.lan> <20170313124621.GA10701@valkosipuli.retiisi.org.uk> <20170314004533.3b3cd44b@vento.lan> <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl> <20170314072143.498cde9b@vento.lan> <20170314223254.GA7141@amd> <20170314215420.6fc63c67@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170314215420.6fc63c67@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 14, 2017 at 09:54:31PM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 14 Mar 2017 23:32:54 +0100
> Pavel Machek <pavel@ucw.cz> escreveu:
> 
> > 
> > Well, I believe first question is: what applications would we want to
> > run on complex devices? Will sending control from video to subdevs
> > actually help?
> 
> I would say: camorama, xawtv3, zbar, google talk, skype. If it runs
> with those, it will likely run with any other application.
> 

I would like to add the 'v4l2src' plugin of gstreamer, and on the imx6 its
imx-specific counterpart 'imxv4l2videosrc' from the gstreamer-imx package
at https://github.com/Freescale/gstreamer-imx, and 'v4l2-ctl'.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
