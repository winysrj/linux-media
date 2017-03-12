Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35221 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbdCLATe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 19:19:34 -0500
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
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
 <20170311231456.GH21222@n2100.armlinux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <f4acf2d0-5d19-9f4e-55d5-18b7bcc4937f@gmail.com>
Date: Sat, 11 Mar 2017 16:19:28 -0800
MIME-Version: 1.0
In-Reply-To: <20170311231456.GH21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 03:14 PM, Russell King - ARM Linux wrote:
> On Sat, Mar 11, 2017 at 08:25:49AM -0300, Mauro Carvalho Chehab wrote:
>> This situation is there since 2009. If I remember well, you tried to write
>> such generic plugin in the past, but never finished it, apparently because
>> it is too complex. Others tried too over the years.
>>
>> The last trial was done by Jacek, trying to cover just the exynos4 driver.
>> Yet, even such limited scope plugin was not good enough, as it was never
>> merged upstream. Currently, there's no such plugins upstream.
>>
>> If we can't even merge a plugin that solves it for just *one* driver,
>> I have no hope that we'll be able to do it for the generic case.
>
> This is what really worries me right now about the current proposal for
> iMX6.  What's being proposed is to make the driver exclusively MC-based.
>

I don't see anything wrong with that.


> What that means is that existing applications are _not_ going to work
> until we have some answer for libv4l2, and from what you've said above,
> it seems that this has been attempted multiple times over the last _8_
> years, and each time it's failed.
>
> When thinking about it, it's quite obvious why merely trying to push
> the problem into userspace fails:
>
>   If we assert that the kernel does not have sufficient information to
>   make decisions about how to route and control the hardware, then under
>   what scenario does a userspace library have sufficient information to
>   make those decisions?
>
> So, merely moving the problem into userspace doesn't solve anything.
>
> Loading the problem onto the user in the hope that the user knows
> enough to properly configure it also doesn't work - who is going to
> educate the user about the various quirks of the hardware they're
> dealing with?

Documentation?

>
> I don't think pushing it into platform specific libv4l2 plugins works
> either - as you say above, even just trying to develop a plugin for
> exynos4 seems to have failed, so what makes us think that developing
> a plugin for iMX6 is going to succeed?  Actually, that's exactly where
> the problem lies.
>
> Is "iMX6 plugin" even right?  That only deals with the complexity of
> one part of the system - what about the source device, which as we
> have already seen can be a tuner or a camera with its own multiple
> sub-devices.  What if there's a video improvement chip in the chain
> as well - how is a "generic" iMX6 plugin supposed to know how to deal
> with that?
>
> It seems to me that what's required is not an "iMX6 plugin" but a
> separate plugin for each platform - or worse.  Consider boards like
> the Raspberry Pi, where users can attach a variety of cameras.  I
> don't think this approach scales.  (This is relevant: the iMX6 board
> I have here has a RPi compatible connector for a MIPI CSI2 camera.
> In fact, the IMX219 module I'm using _is_ a RPi camera, it's the RPi
> NoIR Camera V2.)
>
> The iMX6 problem is way larger than just "which subdev do I need to
> configure for control X" - if you look at the dot graphs both Steve
> and myself have supplied, you'll notice that there are eight (yes,
> 8) video capture devices.

There are 4 video nodes (per IPU):

- unconverted capture from CSI0
- unconverted capture from CSI1
- scaled, CSC, and/or rotated capture from PRP ENC
- scaled, CSC, rotated, and/or de-interlaced capture from PRP VF


Configuring the imx6 pipelines are not that difficult. I've put quite
a bit of detail in the media doc, so it should become clear to any
user with MC knowledge (even those with absolutely no knowledge of
imx) to quickly start getting working pipelines.



   Let's say that we can solve the subdev
> problem in libv4l2.  There's another problem lurking here - libv4l2
> is /dev/video* based.  How does it know which /dev/video* device to
> open?
>
> We don't open by sensor, we open by /dev/video*.  In my case, there
> is only one correct /dev/video* node for the attached sensor, the
> other seven are totally irrelevant.  For other situations, there may
> be the choice of three functional /dev/video* nodes.
>
> Right now, for my case, there isn't the information exported from the
> kernel to know which is the correct one, since that requires knowing
> which virtual channel the data is going to be sent over the CSI2
> interface.  That information is not present in DT, or anywhere.

It is described in the media doc:

"This is the MIPI CSI-2 receiver entity. It has one sink pad to receive
the MIPI CSI-2 stream (usually from a MIPI CSI-2 camera sensor). It has
four source pads, corresponding to the four MIPI CSI-2 demuxed virtual
channel outputs."


> It only comes from system knowledge - in my case, I know that the IMX219
> is currently being configured to use virtual channel 0.  SMIA cameras
> are also configurable.  Then there's CSI2 cameras that can produce
> different formats via different virtual channels (eg, JPEG compressed
> image on one channel while streaming a RGB image via the other channel.)
>
> Whether you can use one or three in _this_ scenario depends on the
> source format - again, another bit of implementation specific
> information that userspace would need to know.  Kernel space should
> know that, and it's discoverable by testing which paths accept the
> source format - but that doesn't tell you ahead of time which
> /dev/video* node to open.
>
> So, the problem space we have here is absolutely huge, and merely
> having a plugin that activates when you open a /dev/video* node
> really doesn't solve it.
>
> All in all, I really don't think "lets hope someone writes a v4l2
> plugin to solve it" is ever going to be successful.  I don't even
> see that there will ever be a userspace application that is anything
> more than a representation of the dot graphs that users can use to
> manually configure the capture system with system knowledge.
>
> I think everyone needs to take a step back and think long and hard
> about this from the system usability perspective - I seriously
> doubt that we will ever see any kind of solution to this if we
> continue to progress with "we'll sort it in userspace some day."

While I admit when I first came across the MC idea a couple years ago,
my first impression was it was putting a lot of burden on the user to
have a detailed knowledge of the system in question. But I don't think
that is a problem with good documentation, and most people who have a
need to use a specific MC driver will already have that knowledge.

Steve
