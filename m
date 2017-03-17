Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:53665 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751018AbdCQNwP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 09:52:15 -0400
Message-ID: <1489758670.2905.52.camel@pengutronix.de>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
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
        gregkh@linuxfoundation.org, shuah@kernel.org, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Date: Fri, 17 Mar 2017 14:51:10 +0100
In-Reply-To: <20170317102410.18c966ae@vento.lan>
References: <20170310130733.GU21222@n2100.armlinux.org.uk>
         <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
         <20170310140124.GV21222@n2100.armlinux.org.uk>
         <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
         <20170310125342.7f047acf@vento.lan>
         <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
         <20170311082549.576531d0@vento.lan>
         <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
         <20170314004533.3b3cd44b@vento.lan>
         <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
         <20170317114203.GZ21222@n2100.armlinux.org.uk>
         <44161453-02f9-0019-3868-7501967a6a82@linux.intel.com>
         <20170317102410.18c966ae@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-03-17 at 10:24 -0300, Mauro Carvalho Chehab wrote:
[...]
> The big question, waiting for an answer on the last 8 years is
> who would do that? Such person would need to have several different
> hardware from different vendors, in order to ensure that it has
> a generic solution.
> 
> It is a way more feasible that the Kernel developers that already 
> have a certain hardware on their hands to add support inside the
> driver to forward the controls through the pipeline and to setup
> a "default" pipeline that would cover the common use cases at
> driver's probe.

Actually, would setting pipeline via libv4l2 plugin and letting drivers
provide a sane enabled default pipeline configuration be mutually
exclusive? Not sure about the control forwarding, but at least a simple
link setup and format forwarding would also be possible in the kernel
without hindering userspace from doing it themselves later.

regards
Philipp
