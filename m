Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39732 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753222AbeDCHZT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 03:25:19 -0400
Subject: Re: V4l2 Sensor driver and V4l2 ctrls
To: asadpt iqroot <asadptiqroot@gmail.com>
Cc: linux-media@vger.kernel.org
References: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
 <2c04f13c-48dc-a745-02fc-7bd8cd57e568@xs4all.nl>
 <CA+gCWtJgw9Efhug-SveBmSfu55NC2dbaUO2KPCjZE1fVwvah3A@mail.gmail.com>
 <7a63122c-cad6-44ee-0d2d-5ce2bd9e6f92@xs4all.nl>
 <CA+gCWtKmDps+NJvXGowBCJrdStV9_1D7kwWqxx8mnG9OswV0xQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <828efe4e-bb7b-6c5d-a0b1-9f84cf16d1bc@xs4all.nl>
Date: Tue, 3 Apr 2018 09:25:16 +0200
MIME-Version: 1.0
In-Reply-To: <CA+gCWtKmDps+NJvXGowBCJrdStV9_1D7kwWqxx8mnG9OswV0xQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/18 08:32, asadpt iqroot wrote:
> Hi Hans,
> 
> Thanks for the reply.
> 
> In board, we have the HDMI connectors. Is it mandatory to use this ctrl
> V4L2_CID_DV_RX_POWER_PRESENT. Based on this v4l2 ctrl, what v4l2 framework
> will do? If I do not set any value to this ctrl, what will happen to
> video streaming?

This control isn't for the kernel, it's to help userspace. Userspace can
subscribe to this control and receive an event whenever it changes value
(i.e. whenever the driver detects a change in the 5V HDMI line).

It then knows that it looks like something has been connected to the receiver
and it can start waiting for a stable signal, inform the user or just keep
track of it internally for debug purposes.

What HDMI receivers do you use? Analog Devices? NXP? SoC-based?

> 
> For example, if I did not add this control in driver, what will
> happen? Whether this will
> affect the functionality of the video streaming? or not.

No, it is just to inform userspace that something was connected or
disconnected. And to aid in debugging problems.

> Why do we have the standard v4l2 ctrl like this?

See above.

Note: if you plan on upstreaming your HDMI receiver driver, then this control
must be present.

Regards,

	Hans

> 
> Thanks for the inputs.
> 
> On 30 March 2018 at 12:58, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 30/03/18 09:23, asadpt iqroot wrote:
>>> Hi Hans,
>>>
>>> Thanks for the reply.
>>>
>>> In HDMI receivers, when we need to use this control. What scenario?
>>
>> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/extended-controls.html#digital-video-control-reference
>>
>> "Detects whether the receiver receives power from the source (e.g. HDMI carries 5V on one of the pins)."
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> -Thanks.
>>>
>>>
>>> On 30 March 2018 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 30/03/18 08:16, asadpt iqroot wrote:
>>>>> Hi All,
>>>>>
>>>>> In reference sensor drivers, they used the
>>>>> V4L2_CID_DV_RX_POWER_PRESENT v4l2 ctrl.
>>>>> It is a standard ctrl and created using v4l2_ctrl_new_std().
>>>>>
>>>>> The doubts are:
>>>>>
>>>>> 1. Whether in our sensor driver, we need to create this Control Id or
>>>>> not. How to take the decision on this. Since this is the standard
>>>>> ctrl. When we need to use these standard ctrls??
>>>>
>>>> No. This control is for HDMI receivers, not for sensors.
>>>>
>>>> Regards,
>>>>
>>>>         Hans
>>>>
>>>>>
>>>>> 2. In Sensor driver, the ctrls creation is anything depends on the
>>>>> bridge driver.
>>>>> Based on bridge driver, whether we need to create any ctrls in Sensor driver.
>>>>>
>>>>> This question belongs to design of the sensor driver.
>>>>>
>>>>>
>>>>>
>>>>> Thanks & Regards
>>>>>
>>>>
>>
