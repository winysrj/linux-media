Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:34960 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbeC3HXk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 03:23:40 -0400
Received: by mail-wr0-f180.google.com with SMTP id 80so7318703wrb.2
        for <linux-media@vger.kernel.org>; Fri, 30 Mar 2018 00:23:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2c04f13c-48dc-a745-02fc-7bd8cd57e568@xs4all.nl>
References: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
 <2c04f13c-48dc-a745-02fc-7bd8cd57e568@xs4all.nl>
From: asadpt iqroot <asadptiqroot@gmail.com>
Date: Fri, 30 Mar 2018 12:53:38 +0530
Message-ID: <CA+gCWtJgw9Efhug-SveBmSfu55NC2dbaUO2KPCjZE1fVwvah3A@mail.gmail.com>
Subject: Re: V4l2 Sensor driver and V4l2 ctrls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the reply.

In HDMI receivers, when we need to use this control. What scenario?

-Thanks.


On 30 March 2018 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 30/03/18 08:16, asadpt iqroot wrote:
>> Hi All,
>>
>> In reference sensor drivers, they used the
>> V4L2_CID_DV_RX_POWER_PRESENT v4l2 ctrl.
>> It is a standard ctrl and created using v4l2_ctrl_new_std().
>>
>> The doubts are:
>>
>> 1. Whether in our sensor driver, we need to create this Control Id or
>> not. How to take the decision on this. Since this is the standard
>> ctrl. When we need to use these standard ctrls??
>
> No. This control is for HDMI receivers, not for sensors.
>
> Regards,
>
>         Hans
>
>>
>> 2. In Sensor driver, the ctrls creation is anything depends on the
>> bridge driver.
>> Based on bridge driver, whether we need to create any ctrls in Sensor driver.
>>
>> This question belongs to design of the sensor driver.
>>
>>
>>
>> Thanks & Regards
>>
>
