Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42473 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753323AbeGEOIv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 10:08:51 -0400
Subject: Re: [PATCH v5 00/27] Venus updates
To: Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org, Alexandre Courbot <acourbot@chromium.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
 <CAAFQd5CQCF=QvTgq8v6K6W6C0Cy27CzHsMxQn+FnML97w9xnCw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <150eb3b4-8b64-6050-6a4e-e06cfaf113cc@xs4all.nl>
Date: Thu, 5 Jul 2018 16:08:48 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CQCF=QvTgq8v6K6W6C0Cy27CzHsMxQn+FnML97w9xnCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/18 16:07, Tomasz Figa wrote:
> Hi Stanimir,
> 
> On Thu, Jul 5, 2018 at 10:05 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi,
>>
>> Changes since v4:
>>  * 02/27 re-write intbufs_alloc as suggested by Alex, and
>>    moved new structures in 03/27 where they are used
>>  * 11/27 exit early if error occur in vdec_runtime_suspend
>>    venc_runtime_suspend and avoid ORing ret variable
>>  * 12/27 fixed typo in patch description
>>  * added a const when declare ptype variable
>>
>> Previous v4 can be found at https://lkml.org/lkml/2018/6/27/404
> 
> Thanks for the patches!
> 
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Are we waiting for anything else? Otherwise I plan to make a pull request for
this tomorrow.

Regards,

	Hans
