Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34226 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdCJCiX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 21:38:23 -0500
Subject: Re: [PATCH v4 13/36] [media] v4l2: add a frame timeout event
To: Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-14-git-send-email-steve_longerbeam@mentor.com>
 <20170302155342.GJ3220@valkosipuli.retiisi.org.uk>
 <4b2bcee1-8da0-776e-4455-8d8e7a7abf0a@gmail.com>
 <20170303114506.GM3220@valkosipuli.retiisi.org.uk>
 <59663ea1-b277-1543-e770-6a102ac733a4@gmail.com>
 <20170304105600.GS3220@valkosipuli.retiisi.org.uk>
 <03c9b05c-d3ba-c890-f9fa-ad5e1a49430c@gmail.com>
 <20170305224114.GV21222@n2100.armlinux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mark.rutland@arm.com,
        andrew-ct.chen@mediatek.com, minghsiu.tsai@mediatek.com,
        sakari.ailus@linux.intel.com, nick@shmanahar.org,
        songjun.wu@microchip.com, hverkuil@xs4all.nl,
        Steve Longerbeam <steve_longerbeam@mentor.com>, pavel@ucw.cz,
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
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b739319b-61d7-3d9d-a64f-7650ab5cd4b0@gmail.com>
Date: Thu, 9 Mar 2017 18:38:18 -0800
MIME-Version: 1.0
In-Reply-To: <20170305224114.GV21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/05/2017 02:41 PM, Russell King - ARM Linux wrote:
> On Sat, Mar 04, 2017 at 04:37:43PM -0800, Steve Longerbeam wrote:
>>
>>
>> On 03/04/2017 02:56 AM, Sakari Ailus wrote:
>>> That's a bit of a special situation --- still there are alike conditions on
>>> existing hardware. You should return the buffers to the user with the ERROR
>>> flag set --- or return -EIO from VIDIOC_DQBUF, if the condition will
>>> persist:
>>
>> On i.MX an EOF timeout is not recoverable without a stream restart, so
>> I decided to call vb2_queue_error() when the timeout occurs (instead
>> of sending an event). The user will then get -EIO when it attempts to
>> queue or dequeue further buffers.
>
> I'm not sure that statement is entirely accurate.  With the IMX219
> camera, I _could_ (with previous iterations of the iMX capture code)
> stop it streaming, wait a while, and restart it, and everything
> continues to work.

Hi Russell, did you see the "EOF timeout" kernel error message when you
stopped the IMX219 from streaming? Only a "EOF timeout" message
indicates the unrecoverable case.


>
> Are you sure that the problem you have here is caused by the iMX6
> rather than the ADV718x CVBS decoder (your initial description said
> it was the decoder.)

Actually yes I did say it was the adv718x, but in fact I doubt the
adv718x has abruptly stopped data transmission on the bt.656 bus.
I actually suspect the IPU, specifically the CSI. In our experience
the CSI is rather sensitive to glitches and/or truncated frames on the
bt.656 bus and can easily loose vertical sync, and/or lock-up.

Steve

>
> If it _is_ the decoder that's going wrong, that doesn't justify
> cripping the rest of the driver for one instance of broken hardware
> that _might_ be attached to it.
>
