Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47500 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751313AbeC3H2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 03:28:12 -0400
Subject: Re: V4l2 Sensor driver and V4l2 ctrls
To: asadpt iqroot <asadptiqroot@gmail.com>
Cc: linux-media@vger.kernel.org
References: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
 <2c04f13c-48dc-a745-02fc-7bd8cd57e568@xs4all.nl>
 <CA+gCWtJgw9Efhug-SveBmSfu55NC2dbaUO2KPCjZE1fVwvah3A@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7a63122c-cad6-44ee-0d2d-5ce2bd9e6f92@xs4all.nl>
Date: Fri, 30 Mar 2018 09:28:10 +0200
MIME-Version: 1.0
In-Reply-To: <CA+gCWtJgw9Efhug-SveBmSfu55NC2dbaUO2KPCjZE1fVwvah3A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/03/18 09:23, asadpt iqroot wrote:
> Hi Hans,
> 
> Thanks for the reply.
> 
> In HDMI receivers, when we need to use this control. What scenario?

https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/extended-controls.html#digital-video-control-reference

"Detects whether the receiver receives power from the source (e.g. HDMI carries 5V on one of the pins)."

Regards,

	Hans

> 
> -Thanks.
> 
> 
> On 30 March 2018 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 30/03/18 08:16, asadpt iqroot wrote:
>>> Hi All,
>>>
>>> In reference sensor drivers, they used the
>>> V4L2_CID_DV_RX_POWER_PRESENT v4l2 ctrl.
>>> It is a standard ctrl and created using v4l2_ctrl_new_std().
>>>
>>> The doubts are:
>>>
>>> 1. Whether in our sensor driver, we need to create this Control Id or
>>> not. How to take the decision on this. Since this is the standard
>>> ctrl. When we need to use these standard ctrls??
>>
>> No. This control is for HDMI receivers, not for sensors.
>>
>> Regards,
>>
>>         Hans
>>
>>>
>>> 2. In Sensor driver, the ctrls creation is anything depends on the
>>> bridge driver.
>>> Based on bridge driver, whether we need to create any ctrls in Sensor driver.
>>>
>>> This question belongs to design of the sensor driver.
>>>
>>>
>>>
>>> Thanks & Regards
>>>
>>
