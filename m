Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38566 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751490AbdCMMrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:47:07 -0400
Date: Mon, 13 Mar 2017 14:46:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
Message-ID: <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170311082549.576531d0@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sat, Mar 11, 2017 at 08:25:49AM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 11 Mar 2017 00:37:14 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro (and others),
> > 
> > On Fri, Mar 10, 2017 at 12:53:42PM -0300, Mauro Carvalho Chehab wrote:
> > > Em Fri, 10 Mar 2017 15:20:48 +0100
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > >   
> > > >   
> > > > > As I've already mentioned, from talking about this with Mauro, it seems
> > > > > Mauro is in agreement with permitting the control inheritence... I wish
> > > > > Mauro would comment for himself, as I can't quote our private discussion
> > > > > on the subject.    
> > > > 
> > > > I can't comment either, not having seen his mail and reasoning.  
> > > 
> > > The rationale is that we should support the simplest use cases first.
> > > 
> > > In the case of the first MC-based driver (and several subsequent
> > > ones), the simplest use case required MC, as it was meant to suport
> > > a custom-made sophisticated application that required fine control
> > > on each component of the pipeline and to allow their advanced
> > > proprietary AAA userspace-based algorithms to work.  
> > 
> > The first MC based driver (omap3isp) supports what the hardware can do, it
> > does not support applications as such.
> 
> All media drivers support a subset of what the hardware can do. The
> question is if such subset covers the use cases or not.

Can you name a feature in the OMAP 3 ISP that is not and can not be
supported using the current driver model (MC + V4L2 sub-device + V4L2) that
could be even remotely useful?

> 
> The current MC-based drivers (except for uvc) took a patch to offer a
> more advanced API, to allow direct control to each IP module, as it was
> said, by the time we merged the OMAP3 driver, that, for the N9/N900 camera
> to work, it was mandatory to access the pipeline's individual components.
> 
> Such approach require that some userspace software will have knowledge
> about some hardware details, in order to setup pipelines and send controls
> to the right components. That makes really hard to have a generic user
> friendly application to use such devices.

The effect you described above is true, but I disagree with the cause. The
cause is the hardware is more complex and variable than what has been
supported previously, and providing a generic interface for accessing such
hardware will require more complex interface.

The hardware we have today and the user cases we have today are more --- not
less --- complex and nuanced than when the Media controller was merged back
in 2010. Arguably there is thus more need for the functionality it provides,
not less.

> 
> Non-MC based drivers control the hardware via a portable interface with
> doesn't require any knowledge about the hardware specifics, as either the
> Kernel or some firmware at the device will set any needed pipelines.
> 
> In the case of V4L2 controls, when there's no subdev API, the main
> driver (e. g. the driver that creates the /dev/video nodes) sends a
> multicast message to all bound I2C drivers. The driver(s) that need 
> them handle it. When the same control may be implemented on different
> drivers, the main driver sends a unicast message to just one driver[1].
> 
> [1] There are several non-MC drivers that have multiple ways to
> control some things, like doing scaling or adjust volume levels at
> either the bridge driver or at a subdriver.
> 
> There's nothing wrong with this approach: it works, it is simpler,
> it is generic. So, if it covers most use cases, why not allowing it
> for usecases where a finer control is not a requirement?

Drivers are written to support hardware, not particular use case. Use case
specific knowledge should be present only in applications, not in drivers.
Doing it otherwise will lead to use case specific drivers and more driver
code to maintain for any particular piece of hardware.

An individual could possibly choose the right driver for his / her use case,
but this approach could hardly work for Linux distribution kernels.

The plain V4L2 interface is generic within its own scope: hardware can be
supported within the hardware model assumed by the interface. However, on
some devices this will end up being a small subset of what the hardware can
do. Besides that, when writing the driver, you need to decide at detail
level what kind of subset that might be.

That's not something anyone writing a driver should need to confront.

> 
> > Adding support to drivers for different "operation modes" --- this is
> > essentially what is being asked for --- is not an approach which could serve
> > either purpose (some functionality with simple interface vs. fully support
> > what the hardware can do, with interfaces allowing that) adequately in the
> > short or the long run.
> 
> Why not?

Let's suppose that the omap3isp driver provided an "operation mode" for more
simple applications.

Would you continue to have a V4L2 video device per DMA engine? Without Media
controller it'd be rather confusing for applications since depending on
which format (and level of processing) is requested defines the video node
where the images is captured.

Instead you'd probably want to have a single video node. For the driver to
expose just a single device node, should that be a Kconfig option or a
module parameter, for instance?

I have to say I wouldn't be even particularly interested to know how much
driver changes you'd have to implement to achieve that and how
unmaintainable to end result would be. Consider inflicting the same on all
drivers.

That's just *one* of a large number of things you'd need to change in order
to support plain V4L2 applications from the driver, while still continuing to
support the current interface.

With the help of a user space library, we can show the omap3isp device as a
single video node with a number of inputs (sensors) that can provide some
level of service to the user. I'm using "can", because it's just up to a
missing implementation of such a library.

It may be hardware specific or not. A hardware specific one may produce
better results than best effort since it may use knowledge of the hardware
not available through the kernel interfaces.

> 
> > If we are missing pieces in the puzzle --- in this case the missing pieces
> > in the puzzle are a generic pipeline configuration library and another
> > library that, with the help of pipeline autoconfiguration would implement
> > "best effort" service for regular V4L2 on top of the MC + V4L2 subdev + V4L2
> > --- then these pieces need to be impelemented. The solution is
> > *not* to attempt to support different types of applications in each driver
> > separately. That will make writing drivers painful, error prone and is
> > unlikely ever deliver what either purpose requires.
> > 
> > So let's continue to implement the functionality that the hardware supports.
> > Making a different choice here is bound to create a lasting conflict between
> > having to change kernel interface behaviour and the requirement of
> > supporting new functionality that hasn't been previously thought of, pushing
> > away SoC vendors from V4L2 ecosystem. This is what we all do want to avoid.
> 
> This situation is there since 2009. If I remember well, you tried to write
> such generic plugin in the past, but never finished it, apparently because
> it is too complex. Others tried too over the years. 

I'd argue I know better what happened with that attempt than you do. I had a
prototype of a generic pipeline configuration library but due to various
reasons I haven't been able to continue working on that since around 2012.
The prototype could figure out that the ccdc -> resizer path isn't usable
with raw sensors due to the lack of common formats between the two,
something that was argued to be too complex to implement.

I'm not aware of anyone else who would have tried that. Are you?

> 
> The last trial was done by Jacek, trying to cover just the exynos4 driver. 
> Yet, even such limited scope plugin was not good enough, as it was never
> merged upstream. Currently, there's no such plugins upstream.
> 
> If we can't even merge a plugin that solves it for just *one* driver,
> I have no hope that we'll be able to do it for the generic case.

I believe Jacek ceased to work on that plugin in his day job; other than
that, there are some matters left to be addressed in his latest patchset.

Having provided feedback on that patchset, I don't see additional technical
problems that require solving before the patches can be merged. The
remaining matters seem to be actually fairly trivial.

> 
> That's why I'm saying that I'm OK on merging any patch that would allow
> setting controls via the /dev/video interface on MC-based drivers when
> compiled without subdev API. I may also consider merging patches allowing
> to change the behavior on runtime, when compiled with subdev API.
> 
> > As far as i.MX6 driver goes, it is always possible to implement i.MX6 plugin
> > for libv4l to perform this. This should be much easier than getting the
> > automatic pipe configuration library and the rest working, and as it is
> > custom for i.MX6, the resulting plugin may make informed technical choices
> > for better functionality.
> 
> I wouldn't call "much easier" something that experienced media
> developers failed to do over the last 8 years.
> 
> It is just the opposite: broadcasting a control via I2C is very easy:
> there are several examples about how to do that all over the media
> drivers.

That's one of the things Jacek's plugin actually does. This is still
functionality that *only* some user applications wish to have, and as
implemented in the plugin it works correctly without use case specific
semantics --- please see my comments on the patch picking the controls from
the pipeline.

Drivers can also make use of v4l2_device_for_each_subdev() to distribute
setting controls on different sub-devices. A few drivers actually do that.

> 
> > Jacek has been working on such a plugin for
> > Samsung Exynos hardware, but I don't think he has quite finished it yey.
> 
> As Jacek answered when questioned about the merge status:
> 
> 	Hi Hans,
> 
> 	On 11/03/2016 12:51 PM, Hans Verkuil wrote:
> 	> Hi all,
> 	>
> 	> Is there anything that blocks me from merging this?
> 	>
> 	> This plugin work has been ongoing for years and unless there are serious
> 	> objections I propose that this is merged.
> 	>
> 	> Jacek, is there anything missing that would prevent merging this?  
> 
> 	There were issues raised by Sakari during last review, related to
> 	the way how v4l2 control bindings are defined. That discussion wasn't
> 	finished, so I stayed by my approach. Other than that - I've tested it
> 	and it works fine both with GStreamer and my test app.
> 
> After that, he sent a new version (v7.1), but never got reviews.

There are a number of mutually agreed but unaddressed comments against v7.
Also, v7.1 is just a single patch that does not address issues pointed out
in v7, but something Jacek wanted to fix himself.

In other words, there are comments to address but no patches to review.
Let's see how to best address them. I could possibly fix at least some of
those, but due to lack of hardware I have no ability to test the end result.

> 
> > The original plan was and continues to be sound, it's just that there have
> > always been too few hands to implement it. :-(
> 
> If there are no people to implement a plan, it doesn't matter how good
> the plan is, it won't work.

Do you have other proposals than what we have commonly agreed on? I don't
see other approaches that could satisfactorily address all the requirements
going forward.

That said, I do think we need to reinvigorate the efforts to get things
rolling again on supporting plain V4L2 applications on devices that are
controlled through the MC inteface. These matters have received undeservedly
little attention in recent years.

> 
> > > That's not true, for example, for the UVC driver. There, MC
> > > is optional, as it should be.  
> > 
> > UVC is different. The device simply provides additional information through
> > MC to the user but MC (or V4L2 sub-device interface) is not used for
> > controlling the device.
> 
> It is not different. If the Kernel is compiled without the V4L2
> subdev interface, the i.MX6 driver (or whatever other driver)
> won't receive any control via the subdev interface. So, it has to
> handle the control logic control via the only interface that
> supports it, e. g. via the video devnode.

Looking at the driver code and the Kconfig file, i.MX6 driver depends on
CONFIG_MEDIA_CONTROLLER and uses the Media controller API. So if Media
controller is disabled in kernel configuration, the i.MX6 IPU driver won't
be compiled.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
