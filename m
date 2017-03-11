Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36699 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdCKSOy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 13:14:54 -0500
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
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
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
 <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
 <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
 <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <5d5cf4a4-a4d3-586e-cd16-54f543dfcce9@gmail.com>
Date: Sat, 11 Mar 2017 10:14:49 -0800
MIME-Version: 1.0
In-Reply-To: <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/11/2017 03:39 AM, Hans Verkuil wrote:
> On 10/03/17 19:37, Steve Longerbeam wrote:
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
>>
>> I made this event a private event to imx-media driver in a previous
>> iteration, so I can return it to a private event, but this can't be
>> done at user level.
>
> It's fine to use an internal event as long as the end-user doesn't
> see it. But if you lose vsyncs, then you never capture another frame,
> right?

No, that's not correct. By loss of vertical sync, I mean the IPU
captures portions of two different frames, resulting in a permanent
"split image", with one frame containing portions of two consecutive
images. Or, the video rolls continuously, if you remember the old CRT
television sets of yore, it's the same rolling effect.


> So userspace can detect that (i.e. no new frames arrive) and
> it can timeout on that. Or you detect it in the driver and restart there,
> or call vb2_queue_error().
>

There is no timeout, the frames keep coming, but they are split images
or rolling.

> Anything really as long as this event isn't user-visible :-)

The event must be user visible, otherwise the user has no indication
the error, and can't correct it by stream restart.

Steve
