Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39007 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753956AbeGEOwB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 10:52:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id h10-v6so1332658wre.6
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 07:52:01 -0700 (PDT)
Subject: Re: [PATCH v5 00/27] Venus updates
To: Hans Verkuil <hverkuil@xs4all.nl>, Tomasz Figa <tfiga@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org, Alexandre Courbot <acourbot@chromium.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
 <CAAFQd5CQCF=QvTgq8v6K6W6C0Cy27CzHsMxQn+FnML97w9xnCw@mail.gmail.com>
 <150eb3b4-8b64-6050-6a4e-e06cfaf113cc@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <6abf8da2-b2e1-1b4f-2727-f9d074081c30@linaro.org>
Date: Thu, 5 Jul 2018 17:51:57 +0300
MIME-Version: 1.0
In-Reply-To: <150eb3b4-8b64-6050-6a4e-e06cfaf113cc@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/05/2018 05:08 PM, Hans Verkuil wrote:
> On 05/07/18 16:07, Tomasz Figa wrote:
>> Hi Stanimir,
>>
>> On Thu, Jul 5, 2018 at 10:05 PM Stanimir Varbanov
>> <stanimir.varbanov@linaro.org> wrote:
>>>
>>> Hi,
>>>
>>> Changes since v4:
>>>  * 02/27 re-write intbufs_alloc as suggested by Alex, and
>>>    moved new structures in 03/27 where they are used
>>>  * 11/27 exit early if error occur in vdec_runtime_suspend
>>>    venc_runtime_suspend and avoid ORing ret variable
>>>  * 12/27 fixed typo in patch description
>>>  * added a const when declare ptype variable
>>>
>>> Previous v4 can be found at https://lkml.org/lkml/2018/6/27/404
>>
>> Thanks for the patches!
>>
>> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks Tomasz!

> 
> Are we waiting for anything else? Otherwise I plan to make a pull request for
> this tomorrow.

I think we are done.

-- 
regards,
Stan
