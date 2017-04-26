Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37794 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3001159AbdDZO2w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 10:28:52 -0400
Received: by mail-it0-f47.google.com with SMTP id x188so3661501itb.0
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 07:28:52 -0700 (PDT)
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query
To: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>,
        Dave Airlie <airlied@gmail.com>
References: <20170426013632.4716-1-andresx7@gmail.com>
 <d555eb6a-e975-b025-6ed0-c458b1c71f34@gmail.com>
 <6a3b44f0-bc9f-462c-9b0f-96ae15712b8b@vodafone.de>
 <CAPM=9tzmBifbmh8zdMAZwv+vxT5WNLQAHqzACe1Sx63F-LUWLQ@mail.gmail.com>
 <a280488c-8bf0-f0c8-fff4-9f89462ebe34@vodafone.de>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Andres Rodriguez <andresx7@gmail.com>
Message-ID: <5c38fa6a-7be1-d2d3-13fd-ec3d527cf021@gmail.com>
Date: Wed, 26 Apr 2017 10:28:49 -0400
MIME-Version: 1.0
In-Reply-To: <a280488c-8bf0-f0c8-fff4-9f89462ebe34@vodafone.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2017-04-26 06:13 AM, Christian König wrote:
> Am 26.04.2017 um 11:59 schrieb Dave Airlie:
>> On 26 April 2017 at 17:20, Christian König <deathsimple@vodafone.de>
>> wrote:
>>> NAK, I'm wondering how often I have to reject that change. We should
>>> probably add a comment here.
>>>
>>> Even with a zero timeout we still need to enable signaling, otherwise
>>> some
>>> fence will never signal if userspace just polls on them.
>>>
>>> If a caller is only interested in the fence status without enabling the
>>> signaling it should call dma_fence_is_signaled() instead.
>> Can we not move the return 0 (with spin unlock) down after we enabling
>> signalling, but before
>> we enter the schedule_timeout(1)?
>
> Yes, that would be an option.
>

I was actually arguing with Dave about this on IRC yesterday. Seems like 
I owe him a beer now.

-Andres

> Christian.
>
>>
>> Dave.
>
>
