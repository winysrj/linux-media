Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32910 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754218AbdCKTG7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 14:06:59 -0500
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310120902.1daebc7b@vento.lan>
 <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
 <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
 <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
 <20170311184551.GD21222@n2100.armlinux.org.uk>
 <1f1b350a-5523-34bc-07b7-f3cd2d1fd4c1@gmail.com>
 <20170311185959.GF21222@n2100.armlinux.org.uk>
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <71f61b28-1252-45ad-b5f4-52ae2f5b9352@gmail.com>
Date: Sat, 11 Mar 2017 11:06:55 -0800
MIME-Version: 1.0
In-Reply-To: <20170311185959.GF21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 10:59 AM, Russell King - ARM Linux wrote:
> On Sat, Mar 11, 2017 at 10:54:55AM -0800, Steve Longerbeam wrote:
>>
>>
>> On 03/11/2017 10:45 AM, Russell King - ARM Linux wrote:
>>> I really don't think expecting the user to understand and configure
>>> the pipeline is a sane way forward.  Think about it - should the
>>> user need to know that, because they have a bayer-only CSI data
>>> source, that there is only one path possible, and if they try to
>>> configure a different path, then things will just error out?
>>>
>>> For the case of imx219 connected to iMX6, it really is as simple as
>>> "there is only one possible path" and all the complexity of the media
>>> interfaces/subdevs is completely unnecessary.  Every other block in
>>> the graph is just noise.
>>>
>>> The fact is that these dot graphs show a complex picture, but reality
>>> is somewhat different - there's only relatively few paths available
>>> depending on the connected source and the rest of the paths are
>>> completely useless.
>>>
>>
>> I totally disagree there. Raw bayer requires passthrough yes, but for
>> all other media bus formats on a mipi csi-2 bus, and all other media
>> bus formats on 8-bit parallel buses, the conersion pipelines can be
>> used for scaling, CSC, rotation, and motion-compensated de-interlacing.
>
> ... which only makes sense _if_ your source can produce those formats.
> We don't actually disagree on that.
>
> Let me re-state.  If the source can _only_ produce bayer, then there is
> _only_ _one_ possible path, and all the overhead of the media controller
> stuff is totally unnecessary.
>
> Or, are you going to tell me that the user should have the right to
> configure paths through the iMX6 hardware that are not permitted by the
> iMX6 manuals for the data format being produced by the sensor?
>

Russell, I'm not following you. The imx6 pipelines allow for many
different sources, not just the inx219 that only outputs bayer. You
seem to be saying that those other pipelines should not be present
because they don't support raw bayer.

Steve
