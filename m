Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59092 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751325AbdCKUmV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 15:42:21 -0500
Date: Sat, 11 Mar 2017 20:41:26 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, Hans Verkuil <hverkuil@xs4all.nl>,
        pavel@ucw.cz, shuah@kernel.org, devel@driverdev.osuosl.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, robert.jarzmik@free.fr,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        geert@linux-m68k.org, p.zabel@pengutronix.de,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, arnd@arndb.de, tiffany.lin@mediatek.com,
        bparrot@ti.com, robh+dt@kernel.org, horms+renesas@verge.net.au,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
        jean-christophe.trotin@st.com, sakari.ailus@linux.intel.com,
        fabio.estevam@nxp.com, shawnguo@kernel.org,
        sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
Message-ID: <20170311204126.GG21222@n2100.armlinux.org.uk>
References: <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310120902.1daebc7b@vento.lan>
 <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
 <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
 <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
 <20170311184551.GD21222@n2100.armlinux.org.uk>
 <1f1b350a-5523-34bc-07b7-f3cd2d1fd4c1@gmail.com>
 <20170311185959.GF21222@n2100.armlinux.org.uk>
 <71f61b28-1252-45ad-b5f4-52ae2f5b9352@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71f61b28-1252-45ad-b5f4-52ae2f5b9352@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 11, 2017 at 11:06:55AM -0800, Steve Longerbeam wrote:
> On 03/11/2017 10:59 AM, Russell King - ARM Linux wrote:
> >On Sat, Mar 11, 2017 at 10:54:55AM -0800, Steve Longerbeam wrote:
> >>
> >>
> >>On 03/11/2017 10:45 AM, Russell King - ARM Linux wrote:
> >>>I really don't think expecting the user to understand and configure
> >>>the pipeline is a sane way forward.  Think about it - should the
> >>>user need to know that, because they have a bayer-only CSI data
> >>>source, that there is only one path possible, and if they try to
> >>>configure a different path, then things will just error out?
> >>>
> >>>For the case of imx219 connected to iMX6, it really is as simple as
> >>>"there is only one possible path" and all the complexity of the media
> >>>interfaces/subdevs is completely unnecessary.  Every other block in
> >>>the graph is just noise.
> >>>
> >>>The fact is that these dot graphs show a complex picture, but reality
> >>>is somewhat different - there's only relatively few paths available
> >>>depending on the connected source and the rest of the paths are
> >>>completely useless.
> >>>
> >>
> >>I totally disagree there. Raw bayer requires passthrough yes, but for
> >>all other media bus formats on a mipi csi-2 bus, and all other media
> >>bus formats on 8-bit parallel buses, the conersion pipelines can be
> >>used for scaling, CSC, rotation, and motion-compensated de-interlacing.
> >
> >... which only makes sense _if_ your source can produce those formats.
> >We don't actually disagree on that.
> >
> >Let me re-state.  If the source can _only_ produce bayer, then there is
> >_only_ _one_ possible path, and all the overhead of the media controller
> >stuff is totally unnecessary.
> >
> >Or, are you going to tell me that the user should have the right to
> >configure paths through the iMX6 hardware that are not permitted by the
> >iMX6 manuals for the data format being produced by the sensor?
> >
> 
> Russell, I'm not following you. The imx6 pipelines allow for many
> different sources, not just the inx219 that only outputs bayer. You
> seem to be saying that those other pipelines should not be present
> because they don't support raw bayer.

What I'm saying is this:

_If_ you have a sensor connected that can _only_ produce bayer, _then_
there is only _one_ possible path through the imx6 pipelines that is
legal.  Offering other paths from the source is noise, because every
other path can't be used with a bayer source.

_If_ you have a sensor connected which can produce RGB or YUV formats,
_then_ other paths are available, and pipeline needs to be configured
to select the appropriate path with the desired features.

So, in the case of a bayer source, offering the user the chance to
manually configure the _single_ allowable route through the tree is
needless complexity.  Forcing the user to have to use the subdev
interfaces to configure the camera is needless complexity.  Such a
source can only ever be used with one single /dev/video* node.

Moreover, this requires user education, and this brings me on to much
larger concerns.  We seem to be saying "this is too complicated, the
user can work it out!"

We've been here with VGA devices.  Remember the old days when you had
to put mode lines into the Xorg.conf, or go through a lengthy setup
process to get X running?  It wasn't very user-friendly.  We seem to
be making the same mistake here.

Usability comes first and foremost - throwing complex problems at
users is not a solution.

Now, given that this media control API has been around for several
years, and the userspace side of the story has not really improved
(according to Mauro, several attempts have been made, every single
attempt so far has failed, even for specific hardware) it seems to me
that using the media control API is a very poor choice for the very
simple reason that _no one_ knows how to configure a system using it.
Hans thoughts of getting some funding to look at this aspect is a
good idea, but I really wonder, given the history so far, how long
this will take - and whether it _ever_ will get solved.

If it doesn't get solved, then we're stuck with quite a big problem.

So, I suggest that we don't merge any further media-controller based
kernel code _until_ we have the userspace side sorted out.  Merging
the kernel side drivers when we don't even know that the userspace
API is functionally usable in userspace beyond test programs is
utterly absurd - what if it turns out that no one can write v4l
plugins that sort out the issues that have been highlighted throughout
these discussions.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
