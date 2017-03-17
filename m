Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42524 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdCQOpJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 10:45:09 -0400
Date: Fri, 17 Mar 2017 14:37:43 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
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
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170317143743.GG21222@n2100.armlinux.org.uk>
References: <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170317114203.GZ21222@n2100.armlinux.org.uk>
 <44161453-02f9-0019-3868-7501967a6a82@linux.intel.com>
 <20170317102410.18c966ae@vento.lan>
 <1489758670.2905.52.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489758670.2905.52.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 17, 2017 at 02:51:10PM +0100, Philipp Zabel wrote:
> On Fri, 2017-03-17 at 10:24 -0300, Mauro Carvalho Chehab wrote:
> [...]
> > The big question, waiting for an answer on the last 8 years is
> > who would do that? Such person would need to have several different
> > hardware from different vendors, in order to ensure that it has
> > a generic solution.
> > 
> > It is a way more feasible that the Kernel developers that already 
> > have a certain hardware on their hands to add support inside the
> > driver to forward the controls through the pipeline and to setup
> > a "default" pipeline that would cover the common use cases at
> > driver's probe.
> 
> Actually, would setting pipeline via libv4l2 plugin and letting drivers
> provide a sane enabled default pipeline configuration be mutually
> exclusive? Not sure about the control forwarding, but at least a simple
> link setup and format forwarding would also be possible in the kernel
> without hindering userspace from doing it themselves later.

I think this is the exact same problem as controls in ALSA.

When ALSA started off in life, the requirement was that all controls
shall default to minimum, and the user is expected to adjust controls
after the system is running.

After OSS, this gave quite a marked change in system behaviour, and
led to a lot of "why doesn't my sound work anymore" problems, because
people then had to figure out which combination of controls had to be
set to get sound out of their systems.

Now it seems to be much better, where install Linux on a platform, and
you have a working sound system (assuming that the drivers are all there
which is generally the case for x86.)

However, it's still possible to adjust all the controls from userspace.
All that's changed is the defaults.

Why am I mentioning this - because from what I understand Mauro saying,
it's no different from this situation.  Userspace will still have the
power to disable all links and setup its own.  The difference is that
there will be a default configuration that the kernel sets up at boot
time that will be functional, rather than the current default
configuration where the system is completely non-functional until
manually configured.

However, at the end of the day, I don't care _where_ the usability
problems are solved, only that there is some kind of solution.  It's not
the _where_ that's the real issue here, but the _how_, and discussion of
the _how_ is completely missing.

So, let's try kicking off a discussion about _how_ to do things.

_How_ do we setup a media controller system so that we end up with a
usable configuration - let's start with the obvious bit... which links
should be enabled.

I think the first pre-requisit is that we stop exposing capture devices
that can never be functional for the hardware that's present on the board,
so that there isn't this plentora of useless /dev/video* nodes and useless
subdevices.

One possible solution to finding a default path may be "find the shortest
path between the capture device and the sensor and enable intervening
links".

Then we need to try configuring that path with format/resolution
information.

However, what if something in the shortest path can't handle the format
that the sensor produces?  I think at that point, we'd need to drop that
subdev out of the path resolution, re-run the "find the shortest path"
algorithm, and try again.

Repeat until success or no path between the capture and sensor exists.

This works fine if you have just one sensor visible from a capture device,
but not if there's more than one (which I suspect is the case with the
Sabrelite board with its two cameras and video receiver.)  That breaks
the "find the shortest path" algorithm.

So, maybe it's a lot better to just let the board people provide via DT
a default setup for the connectivity of the modules somehow - certainly
one big step forward would be to disable in DT parts of the capture
system that can never be used (remembering that boards like the RPi /
Hummingboard may end up using DT overlays to describe this for different
cameras, so the capture setup may change after initial boot.)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
