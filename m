Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40877
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753566AbdCTPjw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 11:39:52 -0400
Date: Mon, 20 Mar 2017 12:39:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
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
        Jacek Anaszewski <jacek.anaszewski@gmail.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170320123938.0503c931@vento.lan>
In-Reply-To: <5c935062-61f4-40e7-0ee9-87655197e661@xs4all.nl>
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
        <20170314004533.3b3cd44b@vento.lan>
        <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
        <20170314072143.498cde9b@vento.lan>
        <5c935062-61f4-40e7-0ee9-87655197e661@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 20 Mar 2017 14:24:25 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/14/2017 11:21 AM, Mauro Carvalho Chehab wrote:
> > Em Tue, 14 Mar 2017 08:55:36 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> On 03/14/2017 04:45 AM, Mauro Carvalho Chehab wrote:  
> >>> Hi Sakari,
> >>>

> >> We're all very driver-development-driven, and userspace gets very little
> >> attention in general. So before just throwing in the towel we should take
> >> a good look at the reasons why there has been little or no development: is
> >> it because of fundamental design defects, or because nobody paid attention
> >> to it?  
> > 
> > No. We should look it the other way: basically, there are patches
> > for i.MX6 driver that sends control from videonode to subdevs. 
> > 
> > If we nack apply it, who will write the userspace plugin? When
> > such change will be merged upstream?
> > 
> > If we don't have answers to any of the above questions, we should not
> > nack it.
> > 
> > That's said, that doesn't prevent merging a libv4l plugin if/when
> > someone can find time/interest to develop it.  
> 
> I don't think this control inheritance patch will magically prevent you
> from needed a plugin.

Yeah, it is not just control inheritance. The driver needs to work
without subdev API, e. g. mbus settings should also be done via the
video devnode.

Btw, Sakari made a good point on IRC: what happens if some app 
try to change the pipeline or subdev settings while another
application is using the device? The driver should block such 
changes, maybe using the V4L2 priority mechanism.

> This is literally the first time we have to cater to a cheap devkit. We
> were always aware of this issue, but nobody really needed it.

That's true. Now that we have a real need for that, we need to
provide a solution.

> > I'd say that we should not care anymore on providing a solution for
> > generic applications to run on boards like OMAP3[1]. For hardware that
> > are currently available that have Kernel driver and boards developed
> > to be used as "cheap hobbyist devkit", I'd say we should implement
> > a Kernel solution that would allow them to be used without subdev
> > API, e. g. having all ioctls needed by generic applications to work
> > functional, after some external application sets the pipeline.  
> 
> I liked Russell's idea of having the DT set up an initial video path.
> This would (probably) make it much easier to provide a generic plugin since
> there is already an initial valid path when the driver is loaded, and it
> doesn't require custom code in the driver since this is left to the DT
> which really knows about the HW.

Setting the device via DT indeed makes easier (either for a kernel
or userspace solution), but things like resolution changes should
be possible without needing to change DT.

Also, as MC and subdev changes should be blocked while a V4L2 app
is using the device, using a mechanism like calling VIDIOC_S_PRIORITY
ioctl via the V4l2 interface, Kernel will require changes, anyway.

My suggestion is to touch on one driver to make it work with a
generic application. As we currently have efforts and needs for
the i.MX6 to do it, I'd say that the best would be to make it
work on such driver. Once the work is done, we can see if the
approach taken there would work at libv4l or not.

In parallel, someone has to fix libv4l for it to be default on
applications like gstreamer, e. g. adding support for DMABUF
and fixing other issues that are preventing it to be used by
default.

Nicolas,

Why libv4l is currently disabled at gstreamer's default settings?

> > [1] Yet, I might eventually do that for fun, an OMAP3 board with tvp5150
> > just arrived here last week. It would be nice to have xawtv3 running on it :-)
> > So, if I have a lot of spare time (with is very unlikely), I might eventually 
> > do something for it to work.
> >   
> >> I know it took me a very long time before I had a working omap3.  
> > 
> > My first OMAP3 board with working V4L2 source just arrived last week :-)
> >   
> >> So I am not at all surprised that little progress has been made.  
> > 
> > I'm not surprised, but I'm disappointed, as I tried to push toward a
> > solution for this problem since when we had our initial meetings about
> > it.  
> 
> So many things to do, so little time. Sounds corny, but really, that's what
> this is all about. There were always (and frankly, still are) more important
> things that needed to be done.

What's most important for some developer may not be so important for
another developer.

My understanding here is that there are developers wanting/needing
to have standard V4L2 apps support for (some) i.MX6 devices. Those are
the ones that may/will allocate some time for it to happen.

Thanks,
Mauro
