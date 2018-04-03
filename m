Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34693 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDCGc7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 02:32:59 -0400
Received: by mail-wm0-f48.google.com with SMTP id w2so9773807wmw.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 23:32:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7a63122c-cad6-44ee-0d2d-5ce2bd9e6f92@xs4all.nl>
References: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
 <2c04f13c-48dc-a745-02fc-7bd8cd57e568@xs4all.nl> <CA+gCWtJgw9Efhug-SveBmSfu55NC2dbaUO2KPCjZE1fVwvah3A@mail.gmail.com>
 <7a63122c-cad6-44ee-0d2d-5ce2bd9e6f92@xs4all.nl>
From: asadpt iqroot <asadptiqroot@gmail.com>
Date: Tue, 3 Apr 2018 12:02:57 +0530
Message-ID: <CA+gCWtKmDps+NJvXGowBCJrdStV9_1D7kwWqxx8mnG9OswV0xQ@mail.gmail.com>
Subject: Re: V4l2 Sensor driver and V4l2 ctrls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the reply.

In board, we have the HDMI connectors. Is it mandatory to use this ctrl
V4L2_CID_DV_RX_POWER_PRESENT. Based on this v4l2 ctrl, what v4l2 framework
will do? If I do not set any value to this ctrl, what will happen to
video streaming?

For example, if I did not add this control in driver, what will
happen? Whether this will
affect the functionality of the video streaming? or not.

Why do we have the standard v4l2 ctrl like this?

Thanks for the inputs.

On 30 March 2018 at 12:58, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 30/03/18 09:23, asadpt iqroot wrote:
>> Hi Hans,
>>
>> Thanks for the reply.
>>
>> In HDMI receivers, when we need to use this control. What scenario?
>
> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/extended-controls.html#digital-video-control-reference
>
> "Detects whether the receiver receives power from the source (e.g. HDMI carries 5V on one of the pins)."
>
> Regards,
>
>         Hans
>
>>
>> -Thanks.
>>
>>
>> On 30 March 2018 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 30/03/18 08:16, asadpt iqroot wrote:
>>>> Hi All,
>>>>
>>>> In reference sensor drivers, they used the
>>>> V4L2_CID_DV_RX_POWER_PRESENT v4l2 ctrl.
>>>> It is a standard ctrl and created using v4l2_ctrl_new_std().
>>>>
>>>> The doubts are:
>>>>
>>>> 1. Whether in our sensor driver, we need to create this Control Id or
>>>> not. How to take the decision on this. Since this is the standard
>>>> ctrl. When we need to use these standard ctrls??
>>>
>>> No. This control is for HDMI receivers, not for sensors.
>>>
>>> Regards,
>>>
>>>         Hans
>>>
>>>>
>>>> 2. In Sensor driver, the ctrls creation is anything depends on the
>>>> bridge driver.
>>>> Based on bridge driver, whether we need to create any ctrls in Sensor driver.
>>>>
>>>> This question belongs to design of the sensor driver.
>>>>
>>>>
>>>>
>>>> Thanks & Regards
>>>>
>>>
>
