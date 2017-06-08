Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36504 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdFHDYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 23:24:18 -0400
Received: by mail-wm0-f51.google.com with SMTP id 7so129373400wmo.1
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 20:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
References: <20170530094901.1807-1-hiroh@chromium.org> <1496139572.2618.19.camel@perches.com>
 <CAO5uPHO7GwxCTk2OqQA5NfrL0-Jyt5SB-jVpeUA_eCrqR7u5xA@mail.gmail.com>
 <1496196991.2618.47.camel@perches.com> <CAO5uPHPWGABuKf3FuAky2BRx+9E=n-QhZ94RPQ7wEuHAwC1qGg@mail.gmail.com>
 <1496203602.2618.54.camel@perches.com> <0eb529d9-a710-4305-f0e2-e2fcd5d5433a@xs4all.nl>
From: Hirokazu Honda <hiroh@chromium.org>
Date: Thu, 8 Jun 2017 12:24:16 +0900
Message-ID: <CAO5uPHOX=++z_YGFoCapH9fvhPwXpC5xr=gCCimAK=ZJ5pp7Hw@mail.gmail.com>
Subject: Re: [PATCH v2] [media] vb2: core: Lower the log level of debug outputs
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Joe Perches <joe@perches.com>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I completely understand bitmask method now.
I agree to the idea, but it is necessary to change the specification of
a debug parameter.
 (We probably need to change a document about that?)
For example, there is maybe a user who set a debug parameter 3.
The user assume that logs whose levels are less than 4 are shown.
However, after the bitmask method is adopted, someday the logs whose
level is 1 or 2 are only shown, not 3 level logs are not shown.
This will be confusing to users.
The function that users can select a log method is necessary (e.g.
implement dprintk_bitmask and dprintk_level)

The main purpose of my patch is to not output much log messages.
I think the current patch is enough to accomplish the purpose.

Changing the method is a related but different task from my patch.
Therefore, I think it should be done in another patch.

Best,
Hirokazu Honda

On Wed, Jun 7, 2017 at 6:01 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 31/05/17 06:06, Joe Perches wrote:
>> On Wed, 2017-05-31 at 12:28 +0900, Hirokazu Honda wrote:
>>> If I understand a bitmap correctly, it is necessary to change the log level
>>> for each message.
>>> I didn't mean a bitmap will take a long CPU time.
>>> I mean the work to change so takes a long time.
>>
>> No, none of the messages or levels need change,
>> only the >= test changes to & so that for instance,
>> level 1 and level 3 messages could be emitted
>> without also emitting level 2 messages.
>>
>> The patch suggested is all that would be required.
>>
>
> I prefer the solution that Joe proposed as well.
>
> It's more useful, esp. with a complex beast like vb2.
>
> Regards,
>
>         Hans
