Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59805
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751595AbdCQOBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 10:01:07 -0400
Date: Fri, 17 Mar 2017 10:24:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
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
        gregkh@linuxfoundation.org, shuah@kernel.org, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170317102410.18c966ae@vento.lan>
In-Reply-To: <44161453-02f9-0019-3868-7501967a6a82@linux.intel.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Mar 2017 13:55:33 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Russell,
> 
> On 03/17/17 13:42, Russell King - ARM Linux wrote:
> > On Tue, Mar 14, 2017 at 08:55:36AM +0100, Hans Verkuil wrote:  
> >> We're all very driver-development-driven, and userspace gets very little
> >> attention in general. So before just throwing in the towel we should take
> >> a good look at the reasons why there has been little or no development: is
> >> it because of fundamental design defects, or because nobody paid attention
> >> to it?
> >>
> >> I strongly suspect it is the latter.
> >>
> >> In addition, I suspect end-users of these complex devices don't really care
> >> about a plugin: they want full control and won't typically use generic
> >> applications. If they would need support for that, we'd have seen much more
> >> interest. The main reason for having a plugin is to simplify testing and
> >> if this is going to be used on cheap hobbyist devkits.  
> > 
> > I think you're looking at it with a programmers hat on, not a users hat.

I fully agree with you: whatever solution is provided, this should be fully
transparent for the end user, no matter what V4L2 application he's using.

> > 
> > Are you really telling me that requiring users to 'su' to root, and then
> > use media-ctl to manually configure the capture device is what most
> > users "want" ?  

The need of su can easily be fixed with a simple addition at the udev
rules.d, for it to consider media controller as part of the v4l stuff:

--- udev/rules.d/50-udev-default.rules	2017-02-01 19:45:35.000000000 -0200
+++ udev/rules.d/50-udev-default.rules	2015-08-29 07:54:16.033122614 -0300
@@ -30,6 +30,7 @@ SUBSYSTEM=="mem", KERNEL=="mem|kmem|port
 SUBSYSTEM=="input", GROUP="input"
 SUBSYSTEM=="input", KERNEL=="js[0-9]*", MODE="0664"
 
+SUBSYSTEM=="media", GROUP="video"
 SUBSYSTEM=="video4linux", GROUP="video"
 SUBSYSTEM=="graphics", GROUP="video"
 SUBSYSTEM=="drm", GROUP="video"

Ok, someone should base it on upstream and submit this to
udev maintainers[1].

[1] On a side note, it would also be possible to have an udev rule that
    would be automatically setting the pipeline then the media device pops
    up.

   I wrote something like that for remote controllers, with gets
   installed together with v4l-utils package: when a remote controller
   is detected, it checks the driver and the remote controller table
   that the driver wants and load it on userspace.

   It would be possible to do something like that for MC, but someone 
   would need to do such task. Of course, that would require to have
   a way for a generic application to detect the board type and be
   able to automatically setup the pipelines. So, we'll go back to
   the initial problem that nobody was able to do that so far.

> It depends on who the user is. I don't think anyone is suggesting a
> regular end user is the user of all these APIs: it is either an
> application tailored for that given device, a skilled user with his test
> scripts 

Test scripts are just test scripts, meant for development purposes.
We shouldn't even consider this seriously.

> Making use of the full potential of the hardware requires using a more
> expressive interface. 

That's the core of the problem: most users don't need "full potential
of the hardware". It is actually worse than that: several boards
don't allow "full potential" of the SoC capabilities.

Ok, when the user requires "full potential", they may need a complex
tailored application. But, on most cases, all it is needed is to
support a simple application that controls a video stream via
/dev/video0.

> That's what the kernel interface must provide. If
> we decide to limit ourselves to a small sub-set of that potential on the
> level of the kernel interface, we have made a wrong decision. It's as
> simple as that. This is why the functionality (and which requires taking
> a lot of policy decisions) belongs to the user space. We cannot have
> multiple drivers providing multiple kernel interfaces for the same hardware.

I strongly disagree. Looking only at the hardware capabilities without
having a solution to provide what the user wants is *wrong*.

The project decisions should be based on the common use cases, and, if
possible and not to expensive/complex, covering exotic cases.

The V4L2 API was designed to fulfill the user needs. Drivers should
take it in consideration when choosing policy decisions.

In order to give you some examples, before the V4L2 API, the bttv driver
used to have its own set of ioctls, meant to provide functionality based
on its hardware capabilities (like selecting other standards like PAL/M).
The end result is that applications written for bttv were not generic
enough[1]. The V4L2 API was designed to be generic enough to cover the
common use-cases.

[1] As the bttv board were very popular, most userspace apps didn't
    work on other hardware. The big advantage of V4L2 API is that it
    contains a set of functions that it is good enough to control any
    hardware. Ok, some features are missing. 

   For example, in the past, one could use the bttv hardware to "decrypt"
   analog cable TV using custom ioctls. Those ioctls got removed during
   the V4L2 conversion, as they are specific to the way bttv hardware
   works.
 
   Also, the cx88 hardware could be used as a generic fast A/D converter, 
   using a custom set of ioctls - something similar to SDR. In this
   specific case, such patchset was never merged upstream.


To give you a few examples about policy decisions taken by the drivers
in order to fulfill the user needs, the Conexant chipsets (supported by
bttv,  cx88, cx231xx and cx25821 drivers, among others) provide a way 
more possibilities than what the driver supports.

Basically, they all have fast A/D converters, running at around
27-30 MHz clock. The samples of the A/D can be passed as-is to
userspace and/or handled by some IP blocks inside the chips.

Also, even the simplest one (bttv) uses a RISC with a firmware that
is built dynamically at runtime by the Kernel driver. Such firmware
needs to setup several DMA pipelines.

For example, the cx88 driver sets those DMA pipelines
(see drivers/media/pci/cx88/cx88-core.c):

 * FIFO space allocations:
 *    channel  21    (y video)  - 10.0k
 *    channel  22    (u video)  -  2.0k
 *    channel  23    (v video)  -  2.0k
 *    channel  24    (vbi)      -  4.0k
 *    channels 25+26 (audio)    -  4.0k
 *    channel  28    (mpeg)     -  4.0k
 *    channel  27    (audio rds)-  3.0k

In order to provide the generic V4L2 API, the driver need to
take lots of device-specific decisions. 

For example, the DMA from channel 28 is only enabled if the
device has an IP block to do MPEG, and the user wants to
receive mpeg data, instead of YUV.

The DMA from channel 27 has samples taken from the audio IF.
The audio decoding itself are at DMA channels 25 and 26.

The data from DMA channel 27 is used by a software dsp code, 
implemented at drivers/media/pci/cx88/cx88-dsp.c, with detects 
if the IF contains AM or FM modulation and what are the carriers,
in order to identify the audio standard. Once the standard is
detected, it sets the hardware audio decoder to the right
standard, and the DMA from channels 25 and 26 will contain
audio PCM samples.

The net result is that an user of any of the V4L2 drivers

That's a way more complex than deciding if a pipeline would
require an IP block to convert from Bayer format to YUV.

Another case: the cx25821 hardware supports 12 video streams, 
consuming almost all available bandwidth of an ePCI bus. Each video 
stream connector can either be configured to be capture or output, in
runtime. The hardware vendor chose to hardcode the driver to provide
8 inputs and 4 outputs. Their decision was based in the fact that
the driver is already very complex, and it satisfies their customer's 
needs. The cost/efforts of make the driver to be reconfigured in
runtime were too high for almost no benefit.

> That said, I'm not trying to provide an excuse for not having libraries
> available to help the user to configure and control the device more or
> less automatically even in terms of best effort. It's something that
> does require attention, a lot more of it than it has received in recent
> few years.

The big question, waiting for an answer on the last 8 years is
who would do that? Such person would need to have several different
hardware from different vendors, in order to ensure that it has
a generic solution.

It is a way more feasible that the Kernel developers that already 
have a certain hardware on their hands to add support inside the
driver to forward the controls through the pipeline and to setup
a "default" pipeline that would cover the common use cases at
driver's probe.

Thanks,
Mauro
