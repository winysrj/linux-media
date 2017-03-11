Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32992 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755518AbdCKTBD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 14:01:03 -0500
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
 <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
 <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
 <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
 <5d5cf4a4-a4d3-586e-cd16-54f543dfcce9@gmail.com>
 <20170311185137.GE21222@n2100.armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
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
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1d3b4d81-587f-38c1-753f-4e7775dd4bca@gmail.com>
Date: Sat, 11 Mar 2017 11:00:53 -0800
MIME-Version: 1.0
In-Reply-To: <20170311185137.GE21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 10:51 AM, Russell King - ARM Linux wrote:
> On Sat, Mar 11, 2017 at 10:14:49AM -0800, Steve Longerbeam wrote:
>> On 03/11/2017 03:39 AM, Hans Verkuil wrote:
>>> It's fine to use an internal event as long as the end-user doesn't
>>> see it. But if you lose vsyncs, then you never capture another frame,
>>> right?
>>
>> No, that's not correct. By loss of vertical sync, I mean the IPU
>> captures portions of two different frames, resulting in a permanent
>> "split image", with one frame containing portions of two consecutive
>> images. Or, the video rolls continuously, if you remember the old CRT
>> television sets of yore, it's the same rolling effect.
>
> I have seen that rolling effect, but the iMX6 regains correct sync
> within one complete "roll" just fine here with IMX219.  However, it
> has always recovered.
>
> So, I don't think there's a problem with the iMX6 part of the
> processing, and so I don't think we should cripple the iMX6 capture
> drivers for this problem.

And there is no crippling going on. Measuring the frame intervals
adds very little overhead.

Steve
