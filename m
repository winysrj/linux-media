Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34410 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbdJKLST (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 07:18:19 -0400
Subject: Re: [PATCH v4] drm/bridge/sii8620: add remote control support
To: Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Maciej Purski <m.purski@samsung.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, airlied@linux.ie,
        architt@codeaurora.org, Laurent.pinchart@ideasonboard.com,
        b.zolnierkie@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <d6bbf0a3-f052-721c-d4f9-5819df4362b5@samsung.com>
Date: Wed, 11 Oct 2017 13:18:14 +0200
MIME-version: 1.0
In-reply-to: <20171009084450.k3zdouahgthhplbs@gofer.mess.org>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20170824085828eucas1p1b3d00ffc06f14cf7c8b9fe84a8f7a0c9@eucas1p1.samsung.com>
        <1503565087-19730-1-git-send-email-m.purski@samsung.com>
        <89e30b5f-f90d-1e27-24a1-bd514c1ddc46@xs4all.nl>
        <3ec0c4ac-d0dc-2127-20a3-344a3604a046@samsung.com>
        <e07b423a-b7f1-26a6-280b-4da7c8b8199e@xs4all.nl>
        <20170921114604.blke4aqmkpa4zhhz@gofer.mess.org>
        <20171009084450.k3zdouahgthhplbs@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.10.2017 10:44, Sean Young wrote:
> Hi,
>
> On Thu, Sep 21, 2017 at 12:46:04PM +0100, Sean Young wrote:
>> On Mon, Sep 18, 2017 at 04:37:52PM +0200, Hans Verkuil wrote:
>>> On 09/18/2017 04:15 PM, Maciej Purski wrote:
>>>> Hi Hans,
>>>> some time ago in reply to your email I described what messages does
>>>> the MHL driver receive and at what time intervals.
>>>> Regarding that information, do you think that a similar solution as
>>>> in [1] is required? Would it be OK, if I just set REP_DELAY and REP_PERIOD
>>>> to values, which I presented in my last email?
>>> Based on the timings you measured I would say that there is a 99% chance that MHL
>>> uses exactly the same "Press and Hold" mechanism as CEC. Since you already specify
>>> RC_PROTO_BIT_CEC in the driver, it will set REP_DELAY and REP_PERIOD to the right
>>> values automatically.
>>>
>>> You will have to implement the same code as in cec-adap.c for the key press handling,
>>> though. It's a bit tricky to get it right.
>>>
>>> Since you will have to do the same thing as I do in CEC, I wonder if it would make
>>> more sense to move this code to the RC core. Basically it ensures that repeat mode
>>> doesn't turn on until you get two identical key presses 550ms or less apart. This
>>> is independent of REP_DELAY which can be changed by userspace.
>>>
>>> Sean, what do you think?
>> Yes, this makes sense. In fact, since IR protocols have different repeat
>> times, I would like to make this protocol dependant anyway.
>>
>> To be honest I find REP_DELAY of 500ms too long and REP_PERIOD of 125ms
>> too short; IOW it takes too long for a key to start repeating, and once
>> it starts repeating it is very hard to control. If I try to increase the
>> volume with my remote it first hardly changes at all and then after 500ms
>> the volume shoots up far too quickly, same thing when navigating menus.
>>
>> CEC dictates a delay period of 550ms, which is not great for the user IMO.
>>
>> Anyway I'll have a look at this over the weekend.
> I have started on this, but I haven't gotten it in a state where I'm
> happy to submit it. I hope to have it ready for v4.15; in the mean time,
> there is no reason to block this patch on this.
>
>
> Sean
>
>
>

Queued to drm-misc-next.

Thanks
Andrzej
