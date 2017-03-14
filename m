Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39344
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752436AbdCNDqD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 23:46:03 -0400
Date: Tue, 14 Mar 2017 00:45:49 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
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
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170314004533.3b3cd44b@vento.lan>
In-Reply-To: <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
References: <20170303230645.GR21222@n2100.armlinux.org.uk>
        <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
        <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
        <20170310130733.GU21222@n2100.armlinux.org.uk>
        <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
        <20170310140124.GV21222@n2100.armlinux.org.uk>
        <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
        <20170310125342.7f047acf@vento.lan>
        <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
        <20170311082549.576531d0@vento.lan>
        <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I started preparing a long argument about it, but gave up in favor of a
simpler one.

Em Mon, 13 Mar 2017 14:46:22 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Drivers are written to support hardware, not particular use case.  

No, it is just the reverse: drivers and hardware are developed to
support use cases.

Btw, you should remember that the hardware is the full board, not just the
SoC. In practice, the board do limit the use cases: several provide a
single physical CSI connector, allowing just one sensor.

> > This situation is there since 2009. If I remember well, you tried to write
> > such generic plugin in the past, but never finished it, apparently because
> > it is too complex. Others tried too over the years.   
> 
> I'd argue I know better what happened with that attempt than you do. I had a
> prototype of a generic pipeline configuration library but due to various
> reasons I haven't been able to continue working on that since around 2012.

...

> > The last trial was done by Jacek, trying to cover just the exynos4 driver. 
> > Yet, even such limited scope plugin was not good enough, as it was never
> > merged upstream. Currently, there's no such plugins upstream.
> > 
> > If we can't even merge a plugin that solves it for just *one* driver,
> > I have no hope that we'll be able to do it for the generic case.  
> 
> I believe Jacek ceased to work on that plugin in his day job; other than
> that, there are some matters left to be addressed in his latest patchset.

The two above basically summaries the issue: the task of doing a generic
plugin on userspace, even for a single driver is complex enough to
not cover within a reasonable timeline.

>From 2009 to 2012, you were working on it, but didn't finish it.

Apparently, nobody worked on it between 2013-2014 (but I may be wrong, as
I didn't check when the generic plugin interface was added to libv4l).

In the case of Jacek's work, the first patch I was able to find was
written in Oct, 2014:
	https://patchwork.kernel.org/patch/5098111/
	(not sure what happened with the version 1).

The last e-mail about this subject was issued in Dec, 2016.

In summary, you had this on your task for 3 years for an OMAP3
plugin (where you have a good expertise), and Jacek for 2 years, 
for Exynos 4, where he should also have a good knowledge.

Yet, with all that efforts, no concrete results were achieved, as none
of the plugins got merged.

Even if they were merged, if we keep the same mean time to develop a
libv4l plugin, that would mean that a plugin for i.MX6 could take 2-3
years to be developed.

There's a clear message on it:
	- we shouldn't keep pushing for a solution via libv4l.

Thanks,
Mauro
