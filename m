Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33120 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932599AbdCJXm1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 18:42:27 -0500
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Pavel Machek <pavel@ucw.cz>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
 <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
 <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com> <20170310233008.GC6540@amd>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <899f1c0a-ba3d-02cd-507b-dba71bfcb637@gmail.com>
Date: Fri, 10 Mar 2017 15:42:22 -0800
MIME-Version: 1.0
In-Reply-To: <20170310233008.GC6540@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/10/2017 03:30 PM, Pavel Machek wrote:
> On Fri 2017-03-10 10:37:21, Steve Longerbeam wrote:
>> Hi Hans,
>>
>> On 03/10/2017 04:03 AM, Hans Verkuil wrote:
>>> On 10/03/17 05:52, Steve Longerbeam wrote:
>>>> Add a new FRAME_INTERVAL_ERROR event to signal that a video capture or
>>>> output device has measured an interval between the reception or transmit
>>>> completion of two consecutive frames of video that is outside the nominal
>>>> frame interval by some tolerance value.
>>>
>>> Reading back what was said on this I agree with Sakari that this doesn't
>>> belong here.
>>>
>>> Userspace can detect this just as easily (if not easier) with a timeout.
>>>
>>
>>
>> Unfortunately measuring frame intervals from userland is not accurate
>> enough for i.MX6.
>>
>> The issue here is that the IPUv3, specifically the CSI unit, can
>> permanently lose vertical sync if there are truncated frames sent
>> on the bt.656 bus. We have seen a single missing line of video cause
>> loss of vertical sync. The only way to correct this is to shutdown
>> the IPU capture hardware and restart, which can be accomplished
>> simply by restarting streaming from userland.
>>
>> There are no other indicators from the sensor about these short
>> frame events (believe me, we've exhausted all avenues with the ADV718x).
>> And the IPUv3 DMA engine has no status indicators for short frames
>> either. So the only way to detect them is by measuring frame intervals.
>>
>> The intervals have to be able to resolve a single line of missing video.
>> With a PAL video source that requires better than 58 usec accuracy.
>>
>> There is too much uncertainty to resolve this at user level. The
>> driver is able to resolve this by measuring intervals between hardware
>> interrupts as long as interrupt latency is reasonably low, and we
>> have another method using the i.MX6 hardware input capture support
>> that can measure these intervals very accurately with no errors
>> introduced by interrupt latency.
>
> Requiring < 58 usec interrupt latency for correct operation is a
> little too optimistic, no?


No it's not too optimistic, from experience the imx6 kernel has irq
latency less than 10 usec under normal system load. False events can be
generated if the latency gets bad, it's true, and that's why there is
the imx6 timer input capture approach.

Steve
