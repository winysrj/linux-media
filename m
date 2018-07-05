Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53312 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753068AbeGEJpY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 05:45:24 -0400
Received: by mail-wm0-f65.google.com with SMTP id b188-v6so10038384wme.3
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 02:45:24 -0700 (PDT)
Subject: Re: [PATCH v2 12/29] venus: add common capability parser
To: Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-13-stanimir.varbanov@linaro.org>
 <CAAFQd5Bj73zyi0vsaSJ2sam2TGm7agshXg+n+sa2c7HoqLRGUw@mail.gmail.com>
 <13c7aec1-2bb9-f449-6b7d-7ec93be4ec71@linaro.org>
 <CAAFQd5B8UVk3n7m+MV3t68vrDhtd9Hi_CnuYS-4QFaVdByOTyA@mail.gmail.com>
 <CAAFQd5CddQBo2JRaab0uWdtkmetd=zDzVt=rM+vJZQ7DM-kLGA@mail.gmail.com>
 <30d141b6-dffa-bf6a-dae8-79595c966a23@linaro.org>
 <CAAFQd5Aet4Hb62Jps6QPu+0fLsB=ruxH1qFwE93c_MWygvmXBw@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <abc191de-de3c-4e5b-9907-5094e82ff50a@linaro.org>
Date: Thu, 5 Jul 2018 12:45:20 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Aet4Hb62Jps6QPu+0fLsB=ruxH1qFwE93c_MWygvmXBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 07/02/2018 01:05 PM, Tomasz Figa wrote:
> On Mon, Jul 2, 2018 at 6:59 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi Tomasz,
>>
>> On 07/02/2018 12:23 PM, Tomasz Figa wrote:
>>> On Thu, May 31, 2018 at 4:06 PM Tomasz Figa <tfiga@chromium.org> wrote:
>>>>
>>>> On Thu, May 31, 2018 at 1:21 AM Stanimir Varbanov
>>>> <stanimir.varbanov@linaro.org> wrote:
>>>>>
>>>>> Hi Tomasz,
>>>>>
>>>>> On 05/24/2018 05:16 PM, Tomasz Figa wrote:
>>>>>> Hi Stanimir,
>>>>>>
>>>>>> On Tue, May 15, 2018 at 5:08 PM Stanimir Varbanov <
>>> [snip]
>>>>>>
>>>>>>> +                       break;
>>>>>>> +               }
>>>>>>> +
>>>>>>> +               word++;
>>>>>>> +               words_count--;
>>>>>>
>>>>>> If data is at |word + 1|, shouldn’t we increment |word| by |1 + |data
>>>>>> size||?
>>>>>
>>>>> yes, that could be possible but the firmware packets are with variable
>>>>> data length and don't want to make the code so complex.
>>>>>
>>>>> The idea is to search for HFI_PROPERTY_PARAM* key numbers. Yes it is not
>>>>> optimal but this enumeration is happen only once during driver probe.
>>>>>
>>>>
>>>> Hmm, do we have a guarantee that we will never find a value that
>>>> matches HFI_PROPERTY_PARAM*, but would be actually just some data
>>>> inside the payload?
>>>
>>> Ping?
>>
>> OK, you are right there is guarantee that we not mixing keywords and
> 
> Did the auto-correction engine in my head got this correctly as "no
> guarantee"? :)
> 
>> data. I can make parse_* functions to return how words they consumed and
>> increment 'word' pointer with consumed words.
> 
> Yes, that or maybe just returning the pointer to the first word after
> consumed data. Most of the looping functions already seem to have this
> value, so it would have to be just returned. (vs having to subtract
> from the start pointer)

I made the relevant changes to satisfy you request but the results were
fine for Venus v3 and wrong on v1. So I'd propose to postpone this
change and fix it with follow up patches because I don't want miss the
next merge window. So far the supported venus firmware versions are fine
with the current parser implementation.

What you think?

-- 
regards,
Stan
