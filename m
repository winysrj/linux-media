Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57606 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932989AbdCKSqo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 13:46:44 -0500
Date: Sat, 11 Mar 2017 18:45:51 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, sakari.ailus@linux.intel.com,
        nick@shmanahar.org, songjun.wu@microchip.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pavel@ucw.cz,
        robert.jarzmik@free.fr, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, shuah@kernel.org,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        mchehab@kernel.org, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, tiffany.lin@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        p.zabel@pengutronix.de, fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170311184551.GD21222@n2100.armlinux.org.uk>
References: <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310120902.1daebc7b@vento.lan>
 <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
 <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
 <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 11, 2017 at 10:08:23AM -0800, Steve Longerbeam wrote:
> On 03/11/2017 07:32 AM, Sakari Ailus wrote:
> >Hi Mauro and Hans,
> >
> >On Sat, Mar 11, 2017 at 10:14:08AM -0300, Mauro Carvalho Chehab wrote:
> >>Em Sat, 11 Mar 2017 12:32:43 +0100
> >>Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>
> >>>On 10/03/17 16:09, Mauro Carvalho Chehab wrote:
> >>>>Em Fri, 10 Mar 2017 13:54:28 +0100
> >>>>Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>>
> >>>>>>Devices that have complex pipeline that do essentially require using the
> >>>>>>Media controller interface to configure them are out of that scope.
> >>>>>>
> >>>>>
> >>>>>Way too much of how the MC devices should be used is in the minds of developers.
> >>>>>There is a major lack for good detailed documentation, utilities, compliance
> >>>>>test (really needed!) and libv4l plugins.
> >>>>
> >>>>Unfortunately, we merged an incomplete MC support at the Kernel. We knew
> >>>>all the problems with MC-based drivers and V4L2 applications by the time
> >>>>it was developed, and we requested Nokia developers (with was sponsoring MC
> >>>>develoment, on that time) to work on a solution to allow standard V4L2
> >>>>applications to work with MC based boards.
> >>>>
> >>>>Unfortunately, we took the decision to merge MC without that, because
> >>>>Nokia was giving up on Linux development, and we didn't want to lose the
> >>>>2 years of discussions and work around it, as Nokia employers were leaving
> >>>>the company. Also, on that time, there was already some patches floating
> >>>>around adding backward support via libv4l. Unfortunately, those patches
> >>>>were never finished.
> >>>>
> >>>>The net result is that MC was merged with some huge gaps, including
> >>>>the lack of a proper solution for a generic V4L2 program to work
> >>>>with V4L2 devices that use the subdev API.
> >>>>
> >>>>That was not that bad by then, as MC was used only on cell phones
> >>>>that run custom-made applications.
> >>>>
> >>>>The reallity changed, as now, we have lots of low cost SoC based
> >>>>boards, used for all sort of purposes. So, we need a quick solution
> >>>>for it.
> >>>>
> >>>>In other words, while that would be acceptable support special apps
> >>>>on really embedded systems, it is *not OK* for general purpose SoC
> >>>>harware[1].
> >>>>
> >>>>[1] I'm calling "general purpose SoC harware" those ARM boards
> >>>>like Raspberry Pi that are shipped to the mass and used by a wide
> >>>>range of hobbyists and other people that just wants to run Linux on
> >>>>ARM. It is possible to buy such boards for a very cheap price,
> >>>>making them to be used not only on special projects, where a custom
> >>>>made application could be interesting, but also for a lot of
> >>>>users that just want to run Linux on a low cost ARM board, while
> >>>>keeping using standard V4L2 apps, like "camorama".
> >>>>
> >>>>That's perhaps one of the reasons why it took a long time for us to
> >>>>start receiving drivers upstream for such hardware: it is quite
> >>>>intimidating and not logical to require developers to implement
> >>>>on their drivers 2 complex APIs (MC, subdev) for those
> >>>>hardware that most users won't care. From user's perspective,
> >>>>being able to support generic applications like "camorama" and
> >>>>"zbar" is all they want.
> >>>>
> >>>>In summary, I'm pretty sure we need to support standard V4L2
> >>>>applications on boards like Raspberry Pi and those low-cost
> >>>>SoC-based boards that are shipped to end users.
> >>>>
> >>>>>Anyway, regarding this specific patch and for this MC-aware driver: no, you
> >>>>>shouldn't inherit controls from subdevs. It defeats the purpose.
> >>>>
> >>>>Sorry, but I don't agree with that. The subdev API is an optional API
> >>>>(and even the MC API can be optional).
> >>>>
> >>>>I see the rationale for using MC and subdev APIs on cell phones,
> >>>>ISV and other embedded hardware, as it will allow fine-tuning
> >>>>the driver's support to allow providing the required quality for
> >>>>certain custom-made applications. but on general SoC hardware,
> >>>>supporting standard V4L2 applications is a need.
> >>>>
> >>>>Ok, perhaps supporting both subdev API and V4L2 API at the same
> >>>>time doesn't make much sense. We could disable one in favor of the
> >>>>other, either at compilation time or at runtime.
> >>>
> >>>Right. If the subdev API is disabled, then you have to inherit the subdev
> >>>controls in the bridge driver (how else would you be able to access them?).
> >>>And that's the usual case.
> >>>
> >>>If you do have the subdev API enabled, AND you use the MC, then the
> >>>intention clearly is to give userspace full control and inheriting controls
> >>>no longer makes any sense (and is highly confusing IMHO).
> >>
> >>I tend to agree with that.
> >
> >I agree as well.
> >
> >This is in line with how existing drivers behave, too.
> 
> Well, sounds like there is consensus on this topic. I guess I'll
> go ahead and remove the control inheritance support. I suppose
> having a control appear in two places (subdev and video nodes) can
> be confusing.

I would say _don't_ do that until there are tools/libraries in place
that are able to support controlling subdevs, otherwise it's just
going to be another reason for me to walk away from this stuff, and
stick with a version that does work sensibly.

> As for the configurability vs. ease-of-use debate, I added the
> control inheritance to make it a little easier on the user, but,
> as the dot graphs below will show, the user already needs quite
> a lot of knowledge of the architecture already, in order to setup
> the different pipelines. So perhaps the control inheritance is
> rather pointless anyway.

I really don't think expecting the user to understand and configure
the pipeline is a sane way forward.  Think about it - should the
user need to know that, because they have a bayer-only CSI data
source, that there is only one path possible, and if they try to
configure a different path, then things will just error out?

For the case of imx219 connected to iMX6, it really is as simple as
"there is only one possible path" and all the complexity of the media
interfaces/subdevs is completely unnecessary.  Every other block in
the graph is just noise.

The fact is that these dot graphs show a complex picture, but reality
is somewhat different - there's only relatively few paths available
depending on the connected source and the rest of the paths are
completely useless.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
