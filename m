Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33843 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdCCWu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 17:50:26 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v4 13/36] [media] v4l2: add a frame timeout event
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-14-git-send-email-steve_longerbeam@mentor.com>
 <20170302155342.GJ3220@valkosipuli.retiisi.org.uk>
 <4b2bcee1-8da0-776e-4455-8d8e7a7abf0a@gmail.com>
 <20170303114506.GM3220@valkosipuli.retiisi.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <59663ea1-b277-1543-e770-6a102ac733a4@gmail.com>
Date: Fri, 3 Mar 2017 14:43:51 -0800
MIME-Version: 1.0
In-Reply-To: <20170303114506.GM3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/03/2017 03:45 AM, Sakari Ailus wrote:
> On Thu, Mar 02, 2017 at 03:07:21PM -0800, Steve Longerbeam wrote:
>>
>>
>> On 03/02/2017 07:53 AM, Sakari Ailus wrote:
>>> Hi Steve,
>>>
>>> On Wed, Feb 15, 2017 at 06:19:15PM -0800, Steve Longerbeam wrote:
>>>> Add a new FRAME_TIMEOUT event to signal that a video capture or
>>>> output device has timed out waiting for reception or transmit
>>>> completion of a video frame.
>>>>
>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>> ---
>>>> Documentation/media/uapi/v4l/vidioc-dqevent.rst | 5 +++++
>>>> Documentation/media/videodev2.h.rst.exceptions  | 1 +
>>>> include/uapi/linux/videodev2.h                  | 1 +
>>>> 3 files changed, 7 insertions(+)
>>>>
>>>> diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>>>> index 8d663a7..dd77d9b 100644
>>>> --- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>>>> +++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
>>>> @@ -197,6 +197,11 @@ call.
>>>> 	the regions changes. This event has a struct
>>>> 	:c:type:`v4l2_event_motion_det`
>>>> 	associated with it.
>>>> +    * - ``V4L2_EVENT_FRAME_TIMEOUT``
>>>> +      - 7
>>>> +      - This event is triggered when the video capture or output device
>>>> +	has timed out waiting for the reception or transmit completion of
>>>> +	a frame of video.
>>>
>>> As you're adding a new interface, I suppose you have an implementation
>>> around. How do you determine what that timeout should be?
>>
>> The imx-media driver sets the timeout to 1 second, or 30 frame
>> periods at 30 fps.
>
> The frame rate is not necessarily constant during streaming. It may well
> change as a result of lighting conditions.

I think you mean that would be a _temporary_ change in frame rate, but
yes I agree the data rate can temporarily fluctuate. Although I doubt
lighting conditions would cause a sensor to pause data transmission
for a full 1 second.


> I wouldn't add an event for this:
> this is unreliable and 30 times the frame period is an arbitrary value
> anyway. No other drivers do this either.

If no other drivers do this I don't mind removing it. It is really meant
to deal with the ADV718x CVBS decoder, which often simply stops sending
data on the BT.656 bus if there is an interruption in the input analog
signal. But I agree that user space could detect this timeout instead.
Unless I hear from someone else that they would like to keep this
feature I'll remove it in version 5.

Steve


>
> The user space is generally in control of the frame period (or on some
> devices it could be the sensor, too, but *not* the CSI-2 receiver driver),
> so detecting the condition of not receiving any frames is more reliably done
> in the user space --- if needed.
>
