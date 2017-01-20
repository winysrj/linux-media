Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35615 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753499AbdATUlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 15:41:14 -0500
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
 <1484929911.2897.70.camel@pengutronix.de>
 <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
Date: Fri, 20 Jan 2017 21:39:22 +0100
MIME-Version: 1.0
In-Reply-To: <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2017 07:40 PM, Steve Longerbeam wrote:
> Hi Hans, Philipp,
> 
> 
> On 01/20/2017 08:31 AM, Philipp Zabel wrote:
>> Hi Hans,
>>
>> On Fri, 2017-01-20 at 14:52 +0100, Hans Verkuil wrote:
>>> Hi Steve, Philipp,
>>>
>>> On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
>>>> In version 3:
>>>>
>>>> Changes suggested by Rob Herring <robh@kernel.org>:
>>>>
>>>>    - prepended FIM node properties with vendor prefix "fsl,".
>>>>
>>>>    - make mipi csi-2 receiver compatible string SoC specific:
>>>>      "fsl,imx6-mipi-csi2" instead of "fsl,imx-mipi-csi2".
>>>>
>>>>    - redundant "_clk" removed from mipi csi-2 receiver clock-names property.
>>>>
>>>>    - removed board-specific info from the media driver binding doc. These
>>>>      were all related to sensor bindings, which already are (adv7180)
>>>>      or will be (ov564x) covered in separate binding docs. All reference
>>>>      board info not related to DT bindings has been moved to
>>>>      Documentation/media/v4l-drivers/imx.rst.
>>>>
>>>>    - removed "_mipi" from the OV5640 compatible string.
>>>>
>>>> Changes suggested by Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>:
>>>>
>>>>    Mostly cosmetic/non-functional changes which I won't list here, except
>>>>    for the following:
>>>>
>>>>    - spin_lock_irqsave() changed to spin_lock() in a couple interrupt handlers.
>>>>
>>>>    - fixed some unnecessary of_node_put()'s in for_each_child_of_node() loops.
>>>>
>>>>    - check/handle return code from required reg property of CSI port nodes.
>>>>
>>>>    - check/handle return code from clk_prepare_enable().
>>>>
>>>> Changes suggested by Fabio Estevam <festevam@gmail.com>:
>>>>
>>>>    - switch to VGEN3 Analog Vdd supply assuming rev. C SabreSD boards.
>>>>
>>>>    - finally got around to passing valid IOMUX pin config values to the
>>>>      pin groups.
>>>>
>>>> Other changes:
>>>>
>>>>    - removed the FIM properties that overrided the v4l2 FIM control defaults
>>>>      values. This was left-over from a requirement of a customer and is not
>>>>      necessary here.
>>>>
>>>>    - The FIM must be explicitly enabled in the fim child node under the CSI
>>>>      port nodes, using the status property. If not enabled, FIM v4l2 controls
>>>>      will not appear in the video capture driver.
>>>>
>>>>    - brought in additional media types patch from Philipp Zabel. Use new
>>>>      MEDIA_ENT_F_VID_IF_BRIDGE in mipi csi-2 receiver subdev.
>>>>
>>>>    - brought in latest platform generic video multiplexer subdevice driver
>>>>      from Philipp Zabel (squashed with patch that uses new MEDIA_ENT_F_MUX).
>>>>
>>>>    - removed imx-media-of.h, moved those prototypes into imx-media.h.
>>> Based on the discussion on the mailinglist it seems everyone agrees that this
>>> is the preferred driver, correct?
>> No. I have some major reservations against the custom mem2mem framework
>> embedded in Steve's driver.
>> I think it is a misuse of the media entity links (which should describe
>> hardware connections) for something that should be done at the vb2 level
>> (letting one device's capture EOF interrupt trigger the next device's
>> m2m device_run without going through userspace).
>> Steve and I disagree on that point, so we'd appreciate if we could get
>> some more eyes on the above issue.
> 
> This needs some background first, so let me first describe one example
> pipeline in this driver.
> 
> There is a VDIC entity in the i.MX IPU that performs de-interlacing with
> hardware filters for motion compensation. Some of the motion compensation
> modes ("low" and "medium" motion) require that the VDIC receive video
> frame fields from memory buffers (dedicated dma channels in the
> IPU are used to transfer those buffers into the VDIC).
> 
> So one option to support those modes would be to pass the raw buffers
> from a camera sensor up to userspace to a capture device, and then pass
> them back to the VDIC for de-interlacing using a mem2mem device.
> 
> Philipp and I are both in agreement that, since userland is not interested
> in the intermediate interlaced buffers in this case, but only the final
> result (motion compensated, de-interlaced frames), it is more efficient
> to provide a media link that allows passing those intermediate frames
> directly from a camera source pad to VDIC sink pad, without having
> to route them through userspace.
> 
> So in order to support that, I've implemented a simple FIFO dma buffer
> queue in the driver to allow passing video buffers directly from a source
> to a sink. It is modeled loosely off the vb2 state machine and API, but
> simpler (for instance it only allows contiguous, cache-coherent buffers).
> 
> This is where Philipp has an argument, that this should be done with a
> new API in videobuf2.
> 
> And I'm actually in total agreement with that. I definitely agree that there
> should be a mechanism in the media framework that allows passing video
> buffers from a source pad to a sink pad using a software queue, with no
> involvement from userland.
> 
> My only disagreement is when this should be implemented. I think it is
> fine to keep my custom implementation of this in the driver for now. Once
> an extension of vb2 is ready to support this feature, it would be fairly
> straightforward to strip out my custom implementation and go with the
> new API.

For a staging driver this isn't necessary, as long as it is documented in
the TODO file that this needs to be fixed before it can be moved out of
staging. The whole point of staging is that there is still work to be
done in the driver, after all :-)

BTW, did you look at the vb2_thread_* functions in videobuf2-core.c? A lot
of what you need is already there. Making a new version that has producer
and consumer queues shouldn't be hard given that code.

Regards,

	Hans
