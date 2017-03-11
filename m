Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57560
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755348AbdCKL0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:26:06 -0500
Date: Sat, 11 Mar 2017 08:25:49 -0300
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
Message-ID: <20170311082549.576531d0@vento.lan>
In-Reply-To: <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
References: <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
        <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
        <20170303230645.GR21222@n2100.armlinux.org.uk>
        <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
        <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
        <20170310130733.GU21222@n2100.armlinux.org.uk>
        <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
        <20170310140124.GV21222@n2100.armlinux.org.uk>
        <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
        <20170310125342.7f047acf@vento.lan>
        <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 11 Mar 2017 00:37:14 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro (and others),
> 
> On Fri, Mar 10, 2017 at 12:53:42PM -0300, Mauro Carvalho Chehab wrote:
> > Em Fri, 10 Mar 2017 15:20:48 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> > >   
> > > > As I've already mentioned, from talking about this with Mauro, it seems
> > > > Mauro is in agreement with permitting the control inheritence... I wish
> > > > Mauro would comment for himself, as I can't quote our private discussion
> > > > on the subject.    
> > > 
> > > I can't comment either, not having seen his mail and reasoning.  
> > 
> > The rationale is that we should support the simplest use cases first.
> > 
> > In the case of the first MC-based driver (and several subsequent
> > ones), the simplest use case required MC, as it was meant to suport
> > a custom-made sophisticated application that required fine control
> > on each component of the pipeline and to allow their advanced
> > proprietary AAA userspace-based algorithms to work.  
> 
> The first MC based driver (omap3isp) supports what the hardware can do, it
> does not support applications as such.

All media drivers support a subset of what the hardware can do. The
question is if such subset covers the use cases or not.

The current MC-based drivers (except for uvc) took a patch to offer a
more advanced API, to allow direct control to each IP module, as it was
said, by the time we merged the OMAP3 driver, that, for the N9/N900 camera
to work, it was mandatory to access the pipeline's individual components.

Such approach require that some userspace software will have knowledge
about some hardware details, in order to setup pipelines and send controls
to the right components. That makes really hard to have a generic user
friendly application to use such devices.

Non-MC based drivers control the hardware via a portable interface with
doesn't require any knowledge about the hardware specifics, as either the
Kernel or some firmware at the device will set any needed pipelines.

In the case of V4L2 controls, when there's no subdev API, the main
driver (e. g. the driver that creates the /dev/video nodes) sends a
multicast message to all bound I2C drivers. The driver(s) that need 
them handle it. When the same control may be implemented on different
drivers, the main driver sends a unicast message to just one driver[1].

[1] There are several non-MC drivers that have multiple ways to
control some things, like doing scaling or adjust volume levels at
either the bridge driver or at a subdriver.

There's nothing wrong with this approach: it works, it is simpler,
it is generic. So, if it covers most use cases, why not allowing it
for usecases where a finer control is not a requirement?

> Adding support to drivers for different "operation modes" --- this is
> essentially what is being asked for --- is not an approach which could serve
> either purpose (some functionality with simple interface vs. fully support
> what the hardware can do, with interfaces allowing that) adequately in the
> short or the long run.

Why not?

> If we are missing pieces in the puzzle --- in this case the missing pieces
> in the puzzle are a generic pipeline configuration library and another
> library that, with the help of pipeline autoconfiguration would implement
> "best effort" service for regular V4L2 on top of the MC + V4L2 subdev + V4L2
> --- then these pieces need to be impelemented. The solution is
> *not* to attempt to support different types of applications in each driver
> separately. That will make writing drivers painful, error prone and is
> unlikely ever deliver what either purpose requires.
> 
> So let's continue to implement the functionality that the hardware supports.
> Making a different choice here is bound to create a lasting conflict between
> having to change kernel interface behaviour and the requirement of
> supporting new functionality that hasn't been previously thought of, pushing
> away SoC vendors from V4L2 ecosystem. This is what we all do want to avoid.

This situation is there since 2009. If I remember well, you tried to write
such generic plugin in the past, but never finished it, apparently because
it is too complex. Others tried too over the years. 

The last trial was done by Jacek, trying to cover just the exynos4 driver. 
Yet, even such limited scope plugin was not good enough, as it was never
merged upstream. Currently, there's no such plugins upstream.

If we can't even merge a plugin that solves it for just *one* driver,
I have no hope that we'll be able to do it for the generic case.

That's why I'm saying that I'm OK on merging any patch that would allow
setting controls via the /dev/video interface on MC-based drivers when
compiled without subdev API. I may also consider merging patches allowing
to change the behavior on runtime, when compiled with subdev API.

> As far as i.MX6 driver goes, it is always possible to implement i.MX6 plugin
> for libv4l to perform this. This should be much easier than getting the
> automatic pipe configuration library and the rest working, and as it is
> custom for i.MX6, the resulting plugin may make informed technical choices
> for better functionality.

I wouldn't call "much easier" something that experienced media
developers failed to do over the last 8 years.

It is just the opposite: broadcasting a control via I2C is very easy:
there are several examples about how to do that all over the media
drivers.

> Jacek has been working on such a plugin for
> Samsung Exynos hardware, but I don't think he has quite finished it yey.

As Jacek answered when questioned about the merge status:

	Hi Hans,

	On 11/03/2016 12:51 PM, Hans Verkuil wrote:
	> Hi all,
	>
	> Is there anything that blocks me from merging this?
	>
	> This plugin work has been ongoing for years and unless there are serious
	> objections I propose that this is merged.
	>
	> Jacek, is there anything missing that would prevent merging this?  

	There were issues raised by Sakari during last review, related to
	the way how v4l2 control bindings are defined. That discussion wasn't
	finished, so I stayed by my approach. Other than that - I've tested it
	and it works fine both with GStreamer and my test app.

After that, he sent a new version (v7.1), but never got reviews.

> The original plan was and continues to be sound, it's just that there have
> always been too few hands to implement it. :-(

If there are no people to implement a plan, it doesn't matter how good
the plan is, it won't work.

> > That's not true, for example, for the UVC driver. There, MC
> > is optional, as it should be.  
> 
> UVC is different. The device simply provides additional information through
> MC to the user but MC (or V4L2 sub-device interface) is not used for
> controlling the device.

It is not different. If the Kernel is compiled without the V4L2
subdev interface, the i.MX6 driver (or whatever other driver)
won't receive any control via the subdev interface. So, it has to
handle the control logic control via the only interface that
supports it, e. g. via the video devnode.

Thanks,
Mauro
