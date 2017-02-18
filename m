Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35823 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753093AbdBRRax (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Feb 2017 12:30:53 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v4 00/36] i.MX Media Driver
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <20170216222006.GA21222@n2100.armlinux.org.uk>
 <923326d6-43fe-7328-d959-14fd341e47ae@gmail.com>
 <20170216225742.GB21222@n2100.armlinux.org.uk>
Cc: p.zabel@pengutronix.de, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        mchehab@kernel.org, hverkuil@xs4all.nl, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
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
        Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <0aa45487-1d2a-6d17-2a70-71e39add2b36@gmail.com>
Date: Sat, 18 Feb 2017 09:21:58 -0800
MIME-Version: 1.0
In-Reply-To: <20170216225742.GB21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/16/2017 02:57 PM, Russell King - ARM Linux wrote:
> On Thu, Feb 16, 2017 at 02:27:41PM -0800, Steve Longerbeam wrote:
>>
>>
>> On 02/16/2017 02:20 PM, Russell King - ARM Linux wrote:
>>> On Wed, Feb 15, 2017 at 06:19:02PM -0800, Steve Longerbeam wrote:
>>>> In version 4:
>>>
>>> With this version, I get:
>>>
>>> [28762.892053] imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000000
>>> [28762.899409] ipu1_csi0: pipeline_set_stream failed with -110
>>>
>>
>> Right, in the imx219, on exit from s_power(), the clock and data lanes
>> must be placed in the LP-11 state. This has been done in the ov5640 and
>> tc358743 subdevs.
>
> The only way to do that is to enable streaming from the sensor, wait
> an initialisation time, and then disable streaming, and wait for the
> current line to finish.  There is _no_ other way to get the sensor to
> place its clock and data lines into LP-11 state.
>
> For that to happen, we need to program the sensor a bit more than we
> currently do at power on (to a minimal resolution, and setting up the
> PLLs), and introduce another 4ms on top of the 8ms or so that the
> runtime resume function already takes.

This is basically the same procedure that was necessary to get the
OV5640 to enter LP-11 on all its lanes. Power-on procedure writes
an initial register set that gets the sensor to a default resolution,
turn on streaming briefly (I wait 1msec which is probably too long,
but it's not clear to me how to determine that wait time), and then
disable streaming. All lanes are then in LP-11 state.


Steve
