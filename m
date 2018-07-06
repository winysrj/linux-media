Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41143 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753612AbeGFHLJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 03:11:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id h10-v6so3087191wrq.8
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 00:11:09 -0700 (PDT)
Subject: Re: [PATCH v5 00/27] Venus updates
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
 <CAAFQd5CQCF=QvTgq8v6K6W6C0Cy27CzHsMxQn+FnML97w9xnCw@mail.gmail.com>
 <150eb3b4-8b64-6050-6a4e-e06cfaf113cc@xs4all.nl>
 <6abf8da2-b2e1-1b4f-2727-f9d074081c30@linaro.org>
 <CAPBb6MWoysaL_i8i7HaegRCsfF29bnOy2L5ZHgEwDuSJ7HVO2w@mail.gmail.com>
 <CAPBb6MXoiGLdSuufbJ39va4emswC20VZq+U4X8+_PUa++yh=AQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <b0d3c876-9f3c-7af9-0b4c-cc8293aa6437@linaro.org>
Date: Fri, 6 Jul 2018 10:11:03 +0300
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXoiGLdSuufbJ39va4emswC20VZq+U4X8+_PUa++yh=AQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/06/2018 06:55 AM, Alexandre Courbot wrote:
> On Fri, Jul 6, 2018 at 12:00 AM Alexandre Courbot <acourbot@chromium.org> wrote:
>>
>> On Thu, Jul 5, 2018 at 11:52 PM Stanimir Varbanov
>> <stanimir.varbanov@linaro.org> wrote:
>>>
>>> Hi,
>>>
>>> On 07/05/2018 05:08 PM, Hans Verkuil wrote:
>>>> On 05/07/18 16:07, Tomasz Figa wrote:
>>>>> Hi Stanimir,
>>>>>
>>>>> On Thu, Jul 5, 2018 at 10:05 PM Stanimir Varbanov
>>>>> <stanimir.varbanov@linaro.org> wrote:
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Changes since v4:
>>>>>>  * 02/27 re-write intbufs_alloc as suggested by Alex, and
>>>>>>    moved new structures in 03/27 where they are used
>>>>>>  * 11/27 exit early if error occur in vdec_runtime_suspend
>>>>>>    venc_runtime_suspend and avoid ORing ret variable
>>>>>>  * 12/27 fixed typo in patch description
>>>>>>  * added a const when declare ptype variable
>>>>>>
>>>>>> Previous v4 can be found at https://lkml.org/lkml/2018/6/27/404
>>>>>
>>>>> Thanks for the patches!
>>>>>
>>>>> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
>>>
>>> Thanks Tomasz!
>>>
>>>>
>>>> Are we waiting for anything else? Otherwise I plan to make a pull request for
>>>> this tomorrow.
>>>
>>> I think we are done.
>>
>> I would just like to give this one last test - will be done by tomorrow JST.
> 
> Confirmed my unit tests were still running with this version and had a
> quick look at the changes.
> 
> The series,
> 
> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> Tested-by: Alexandre Courbot <acourbot@chromium.org>

Thanks Alex!

-- 
regards,
Stan
