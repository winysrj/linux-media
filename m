Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49339 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755341AbdCKLjz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:39:55 -0500
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
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
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
Date: Sat, 11 Mar 2017 12:39:51 +0100
MIME-Version: 1.0
In-Reply-To: <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/17 19:37, Steve Longerbeam wrote:
> Hi Hans,
> 
> On 03/10/2017 04:03 AM, Hans Verkuil wrote:
>> On 10/03/17 05:52, Steve Longerbeam wrote:
>>> Add a new FRAME_INTERVAL_ERROR event to signal that a video capture or
>>> output device has measured an interval between the reception or transmit
>>> completion of two consecutive frames of video that is outside the nominal
>>> frame interval by some tolerance value.
>>
>> Reading back what was said on this I agree with Sakari that this doesn't
>> belong here.
>>
>> Userspace can detect this just as easily (if not easier) with a timeout.
>>
> 
> 
> Unfortunately measuring frame intervals from userland is not accurate
> enough for i.MX6.
> 
> The issue here is that the IPUv3, specifically the CSI unit, can
> permanently lose vertical sync if there are truncated frames sent
> on the bt.656 bus. We have seen a single missing line of video cause
> loss of vertical sync. The only way to correct this is to shutdown
> the IPU capture hardware and restart, which can be accomplished
> simply by restarting streaming from userland.
> 
> There are no other indicators from the sensor about these short
> frame events (believe me, we've exhausted all avenues with the ADV718x).
> And the IPUv3 DMA engine has no status indicators for short frames
> either. So the only way to detect them is by measuring frame intervals.
> 
> The intervals have to be able to resolve a single line of missing video.
> With a PAL video source that requires better than 58 usec accuracy.
> 
> There is too much uncertainty to resolve this at user level. The
> driver is able to resolve this by measuring intervals between hardware
> interrupts as long as interrupt latency is reasonably low, and we
> have another method using the i.MX6 hardware input capture support
> that can measure these intervals very accurately with no errors
> introduced by interrupt latency.
> 
> I made this event a private event to imx-media driver in a previous
> iteration, so I can return it to a private event, but this can't be
> done at user level.

It's fine to use an internal event as long as the end-user doesn't
see it. But if you lose vsyncs, then you never capture another frame,
right? So userspace can detect that (i.e. no new frames arrive) and
it can timeout on that. Or you detect it in the driver and restart there,
or call vb2_queue_error().

Anything really as long as this event isn't user-visible :-)

Regards,

	Hans

> 
> Steve
> 
> 
>>
>>>
>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>> ---
>>>  Documentation/media/uapi/v4l/vidioc-dqevent.rst | 6 ++++++
>>>  Documentation/media/videodev2.h.rst.exceptions  | 1 +
>>>  include/uapi/linux/videodev2.h                  | 1 +
>>>  3 files changed, 8 insertions(+)
>>>
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>>> index 8d663a7..dc77363 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>>> @@ -197,6 +197,12 @@ call.
>>>      the regions changes. This event has a struct
>>>      :c:type:`v4l2_event_motion_det`
>>>      associated with it.
>>> +    * - ``V4L2_EVENT_FRAME_INTERVAL_ERROR``
>>> +      - 7
>>> +      - This event is triggered when the video capture or output device
>>> +    has measured an interval between the reception or transmit
>>> +    completion of two consecutive frames of video that is outside
>>> +    the nominal frame interval by some tolerance value.
>>>      * - ``V4L2_EVENT_PRIVATE_START``
>>>        - 0x08000000
>>>        - Base event number for driver-private events.
>>> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
>>> index e11a0d0..c7d8fad 100644
>>> --- a/Documentation/media/videodev2.h.rst.exceptions
>>> +++ b/Documentation/media/videodev2.h.rst.exceptions
>>> @@ -459,6 +459,7 @@ replace define V4L2_EVENT_CTRL event-type
>>>  replace define V4L2_EVENT_FRAME_SYNC event-type
>>>  replace define V4L2_EVENT_SOURCE_CHANGE event-type
>>>  replace define V4L2_EVENT_MOTION_DET event-type
>>> +replace define V4L2_EVENT_FRAME_INTERVAL_ERROR event-type
>>>  replace define V4L2_EVENT_PRIVATE_START event-type
>>>
>>>  replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
>>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>>> index 45184a2..cf5a0d0 100644
>>> --- a/include/uapi/linux/videodev2.h
>>> +++ b/include/uapi/linux/videodev2.h
>>> @@ -2131,6 +2131,7 @@ struct v4l2_streamparm {
>>>  #define V4L2_EVENT_FRAME_SYNC            4
>>>  #define V4L2_EVENT_SOURCE_CHANGE        5
>>>  #define V4L2_EVENT_MOTION_DET            6
>>> +#define V4L2_EVENT_FRAME_INTERVAL_ERROR        7
>>>  #define V4L2_EVENT_PRIVATE_START        0x08000000
>>>
>>>  /* Payload for V4L2_EVENT_VSYNC */
>>>
>>
> 
