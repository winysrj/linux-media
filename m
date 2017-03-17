Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3504 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751079AbdCQMFg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 08:05:36 -0400
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
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
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <44161453-02f9-0019-3868-7501967a6a82@linux.intel.com>
Date: Fri, 17 Mar 2017 13:55:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170317114203.GZ21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On 03/17/17 13:42, Russell King - ARM Linux wrote:
> On Tue, Mar 14, 2017 at 08:55:36AM +0100, Hans Verkuil wrote:
>> We're all very driver-development-driven, and userspace gets very little
>> attention in general. So before just throwing in the towel we should take
>> a good look at the reasons why there has been little or no development: is
>> it because of fundamental design defects, or because nobody paid attention
>> to it?
>>
>> I strongly suspect it is the latter.
>>
>> In addition, I suspect end-users of these complex devices don't really care
>> about a plugin: they want full control and won't typically use generic
>> applications. If they would need support for that, we'd have seen much more
>> interest. The main reason for having a plugin is to simplify testing and
>> if this is going to be used on cheap hobbyist devkits.
> 
> I think you're looking at it with a programmers hat on, not a users hat.
> 
> Are you really telling me that requiring users to 'su' to root, and then
> use media-ctl to manually configure the capture device is what most
> users "want" ?

It depends on who the user is. I don't think anyone is suggesting a
regular end user is the user of all these APIs: it is either an
application tailored for that given device, a skilled user with his test
scripts or as suggested previously, a libv4l plugin knowing the device
or a generic library geared towards providing best effort service. The
last one of this list does not exist yet and the second last item
requires help.

Typically this class of devices is simply not up to provide the level of
service you're requesting without additional user space control library
which is responsible for automatic white balance, exposure and focus.

Making use of the full potential of the hardware requires using a more
expressive interface. That's what the kernel interface must provide. If
we decide to limit ourselves to a small sub-set of that potential on the
level of the kernel interface, we have made a wrong decision. It's as
simple as that. This is why the functionality (and which requires taking
a lot of policy decisions) belongs to the user space. We cannot have
multiple drivers providing multiple kernel interfaces for the same hardware.

That said, I'm not trying to provide an excuse for not having libraries
available to help the user to configure and control the device more or
less automatically even in terms of best effort. It's something that
does require attention, a lot more of it than it has received in recent
few years.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
